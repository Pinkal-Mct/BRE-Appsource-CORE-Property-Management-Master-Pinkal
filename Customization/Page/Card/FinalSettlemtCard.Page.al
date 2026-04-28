page 73209694 "FinalSettlemtCard"
{
    PageType = ListPart;
    SourceTable = "FinalSettlement";
    ApplicationArea = All;
    Caption = 'Final Settlement Details';

    layout
    {
        area(Content)
        {
            group(ReceivableDetails)
            {
                Caption = 'Receivable Details';
                field("Receivable from the Tenant"; Rec."Receivable from the Tenant")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The total amount receivable from the tenant.';
                }

                field("Payment Processed"; Rec."Payment Processed")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The total amount processed for payment.';
                }

                field("Balance Receivable"; Rec."Balance Receivable")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The balance amount receivable from the tenant.';
                }

                field("PaymentStatus"; Rec."PaymentStatus")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The current payment status of the final settlement.';
                }
            }


            repeater(ReceivablePaymentDetails)
            {
                Caption = 'Receivable Payment Details';
                // Editable = (Rec."Receivable Payment Status" <> PaymentStatus::Received);
                field("FC ID"; Rec."FC ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'FC ID';
                    ToolTip = 'The unique identifier for the final calculation associated with this payment.';
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'Contract ID';
                    ToolTip = 'The unique identifier for the contract associated with this payment.';
                }
                field("Receivable Total Amount"; Rec."Receivable Total Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The total amount receivable from the tenant for this payment.';
                }
                field("Receivable Due Date"; Rec."Receivable Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'The due date for the receivable payment.';
                }
                field("Receivable Payment mode"; Rec."Receivable Payment mode")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    ToolTip = 'The payment mode for the receivable payment.';
                }

                field("Receivable Payment Status"; Rec."Receivable Payment Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'The current payment status of the receivable payment.';

                    trigger OnValidate()
                    var
                        PaymentStatus: Enum "Payment Status";
                    begin
                        // Check if Receivable Payment Status is 'Received'
                        if Rec."Receivable Payment Status" = PaymentStatus::Received then begin
                            // Set PaymentStatus to 'Received' as well
                            Rec."PaymentStatus" := Rec."PaymentStatus"::Received;
                            Rec.Modify();  // Save changes to the current record
                        end;

                        if Rec."Receivable Payment Status" <> PaymentStatus::Received then begin
                            // Set PaymentStatus to 'Received' as well
                            Rec."PaymentStatus" := Rec."PaymentStatus"::Pending;
                            Rec.Modify();  // Save changes to the current record
                        end;
                    end;
                }
                field("Receivable Cheque No."; Rec."Receivable Cheque No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'The cheque number for the receivable payment.';
                    Editable = Rec."Receivable Payment mode" = 'Cheque';

                    trigger OnValidate()
                    var

                    begin
                        if Rec."Receivable Payment Mode" <> 'Cheque' then
                            Error('Cheque number can only be entered when Payment Mode is set to Cheque.');
                    end;
                }

                field("Deposit Bank"; Rec."Deposit Bank")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    ToolTip = 'The bank where the deposit is made.';
                    Editable = not (Rec."Receivable Payment mode" = 'Cash') and not (Rec."Receivable Payment mode" = 'Pending');
                    trigger OnValidate()
                    var

                    begin
                        if Rec."Receivable Payment Mode" = 'Cash' then
                            Error('Deposit Bank is not valid for Cash');
                    end;
                }

                field("Deposit Status"; Rec."Deposit Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The status of the deposit for the receivable payment.';

                    trigger OnValidate()
                    var

                    begin
                        if Rec."Receivable Payment Mode" = 'Cash' then
                            Error('Deposit Bank is not valid for Cash');
                    end;
                }

                field("Payment Receipt"; Rec."Payment Receipt")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Receipt';
                    ToolTip = 'The payment receipt for the receivable payment.';
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin

                        FileURL := Rec."Payment Receipt document URL";
                        if FileURL = '' then
                            Error('No document is available to view.');
                        OpenFileInBrowser1(FileURL);
                    end;
                }
                field("Payment Receipt document URL"; Rec."Payment Receipt document URL")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Receipt document URL';
                    ToolTip = 'The URL of the payment receipt document.';
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'The unique identifier for the tenant associated with this payment.';
                }
                field("Tenant Email"; Rec."Tenant Email")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'The email address of the tenant associated with this payment.';
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The name of the tenant associated with this payment.';
                }

            }
        }
    }

    procedure OpenFileInBrowser1(URL: Text)
    begin
        // Use the Hyperlink method to open the file in the browser
        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;
    /////////////////////////// SALES INVOICE //////////////////////////////////////

    trigger OnModifyRecord(): Boolean
    var
        finalCalculationgrid: Record "Final Calculation";
        paymentTypeRec: Record "Payment Type"; // Record variable for Payment Type
        lPaymentStatus: Enum "Payment Status";
    begin

        /////////////////////////// Receivable final settlement /////////////////////////////////

        if Rec."Receivable Cheque No." = '' then
            Rec."Receivable Cheque No." := '-';

        if Rec."Receivable Payment mode" = '' then
            if paymentTypeRec.FindFirst() then
                Rec."Receivable Payment mode" := paymentTypeRec."Payment Method"; // Set the first Payment Method as default


        finalCalculationgrid.SetRange("FC ID", Rec."FC ID");
        if finalCalculationgrid.FindFirst() then begin
            Rec."Contract ID" := finalCalculationgrid."Contract ID";
            Rec."Tenant ID" := finalCalculationgrid."Tenant ID";
            Rec."Receivable from the Tenant" := finalCalculationgrid."Net Receivable From The Tenant";
            Rec."Balance Receivable" := Rec."Receivable from the Tenant";
            Rec."Receivable Total Amount" := Rec."Receivable from the Tenant";
            if Rec."Receivable Payment Status" = lPaymentStatus::" " then
                Rec."Receivable Payment Status" := lPaymentStatus::Scheduled;

            if Rec."Receivable Payment Status" = lPaymentStatus::Received then begin
                Rec."PaymentStatus" := Rec."PaymentStatus"::Received;
                Rec."Balance Receivable" := 0;
                Rec."Payment Processed" := Rec."Receivable from the Tenant";
                Rec.Modify();
            end;

            if Rec."Receivable Payment Status" = lPaymentStatus::Received then
                exit;

            if Rec."Receivable Due Date" = Today() then
                Rec."Receivable Payment Status" := lPaymentStatus::Due

            else
                if Rec."Receivable Due Date" > Today() then
                    Rec."Receivable Payment Status" := lPaymentStatus::Scheduled

                else
                    if Rec."Receivable Due Date" = 0D then
                        Rec."Receivable Payment Status" := lPaymentStatus::Scheduled

                    else
                        if Rec."Receivable Due Date" < Today() then
                            Rec."Receivable Payment Status" := lPaymentStatus::Overdue;

            Rec.Modify();
        end;
    end;

    trigger OnAfterGetRecord()
    var
        finalCalculationgrid: Record "Final Calculation";
        paymentTypeRec: Record "Payment Type"; // Record variable for Payment Type
        lPaymentStatus: Enum "Payment Status";
    begin

        /////////////////////////// Receivable final settlement /////////////////////////////////

        if Rec."Receivable Cheque No." = '' then
            Rec."Receivable Cheque No." := '-';

        if Rec."Receivable Payment mode" = '' then
            if paymentTypeRec.FindFirst() then
                Rec."Receivable Payment mode" := paymentTypeRec."Payment Method"; // Set the first Payment Method as default


        finalCalculationgrid.SetRange("FC ID", Rec."FC ID");
        if finalCalculationgrid.FindFirst() then begin
            Rec."Contract ID" := finalCalculationgrid."Contract ID";
            Rec."Tenant ID" := finalCalculationgrid."Tenant ID";
            Rec."Receivable from the Tenant" := finalCalculationgrid."Net Receivable From The Tenant";
            Rec."Balance Receivable" := Rec."Receivable from the Tenant";
            Rec."Receivable Total Amount" := Rec."Receivable from the Tenant";
            if Rec."Receivable Payment Status" = lPaymentStatus::" " then
                Rec."Receivable Payment Status" := lPaymentStatus::Scheduled;

            if Rec."Receivable Payment Status" = lPaymentStatus::Received then begin
                Rec."PaymentStatus" := Rec."PaymentStatus"::Received;
                Rec."Balance Receivable" := 0;
                Rec."Payment Processed" := Rec."Receivable from the Tenant";
                Rec.Modify();
            end;

            if Rec."Receivable Payment Status" = lPaymentStatus::Received then
                exit;

            if Rec."Receivable Due Date" = Today() then
                Rec."Receivable Payment Status" := lPaymentStatus::Due
            else
                if Rec."Receivable Due Date" > Today() then
                    Rec."Receivable Payment Status" := lPaymentStatus::Scheduled
                else
                    if Rec."Receivable Due Date" = 0D then
                        Rec."Receivable Payment Status" := lPaymentStatus::Scheduled
                    else
                        if Rec."Receivable Due Date" < Today() then
                            Rec."Receivable Payment Status" := lPaymentStatus::Overdue;

            Rec.Modify();

        end;
    end;


    trigger OnAfterGetCurrRecord()
    var
    begin
        editablelogic := editablelogicfield();
    end;


    procedure editablelogicfield(): Boolean
    begin
        if Rec."Receivable Payment mode" = 'Cash' then
            exit(false)
        else
            exit(true);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        finalCalculationgrid: Record "Final Calculation";
        paymentTypeRec: Record "Payment Type"; // Record variable for Payment Type
        lPaymentStatus: Enum "Payment Status";
    begin

        Rec."Contract ID" := ContractID;
        Rec."Tenant ID" := tenantID;

        /////////////////////////// Receivable final settlement /////////////////////////////////

        if Rec."Receivable Cheque No." = '' then
            Rec."Receivable Cheque No." := '-';

        if Rec."Receivable Payment mode" = '' then
            if paymentTypeRec.FindFirst() then
                Rec."Receivable Payment mode" := paymentTypeRec."Payment Method"; // Set the first Payment Method as default

        finalCalculationgrid.SetRange("FC ID", Rec."FC ID");
        if finalCalculationgrid.FindFirst() then begin
            Rec."Contract ID" := finalCalculationgrid."Contract ID";
            Rec."Tenant ID" := finalCalculationgrid."Tenant ID";
            Rec."Receivable from the Tenant" := finalCalculationgrid."Net Receivable From The Tenant";
            Rec."Balance Receivable" := Rec."Receivable from the Tenant";
            Rec."Receivable Total Amount" := Rec."Receivable from the Tenant";

            if Rec."Receivable Payment Status" = lPaymentStatus::" " then
                Rec."Receivable Payment Status" := lPaymentStatus::Scheduled;

            if Rec."Receivable Payment Status" = lPaymentStatus::Received then begin
                Rec."PaymentStatus" := Rec."PaymentStatus"::Received;
                Rec."Balance Receivable" := 0;
                Rec."Payment Processed" := Rec."Receivable from the Tenant";
                Rec.Modify();
            end;

            if Rec."Receivable Payment Status" = lPaymentStatus::Received then
                exit;

            if Rec."Receivable Due Date" = Today() then
                Rec."Receivable Payment Status" := lPaymentStatus::Due

            else
                if Rec."Receivable Due Date" > Today() then
                    Rec."Receivable Payment Status" := lPaymentStatus::Scheduled

                else
                    if Rec."Receivable Due Date" = 0D then
                        Rec."Receivable Payment Status" := lPaymentStatus::Scheduled

                    else
                        if Rec."Receivable Due Date" < Today() then
                            Rec."Receivable Payment Status" := lPaymentStatus::Overdue;

            Rec.Modify();

        end;

    end;


    procedure SetContractID(pContractID: Integer)
    begin
        contractID := pContractID;
    end;

    procedure SetTenantID(pTenantID: Code[20])
    begin
        tenantID := pTenantID;
    end;

    var
        contractID: Integer;
        tenantID: Code[20];

        PaymentStatus: Enum "Payment Status";

        editablelogic: Boolean;

}