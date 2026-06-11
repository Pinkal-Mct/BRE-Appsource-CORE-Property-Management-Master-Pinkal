page 73209694 "BLRFinalSettlemtCard"
{
    PageType = ListPart;
    SourceTable = "BLRFinalSettlement";
    ApplicationArea = All;
    Caption = 'Final Settlement Details';

    layout
    {
        area(Content)
        {
            group(ReceivableDetails)
            {
                Caption = 'Receivable Details';
                field("Receivable from the Tenant"; Rec."BLRReceivable from the Tenant")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The total amount receivable from the tenant.';
                }

                field("Payment Processed"; Rec."BLRPayment Processed")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The total amount processed for payment.';
                }

                field("Balance Receivable"; Rec."BLRBalance Receivable")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The balance amount receivable from the tenant.';
                }

                field("PaymentStatus"; Rec."BLRPaymentStatus")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The current payment status of the final settlement.';
                }
            }


            repeater(ReceivablePaymentDetails)
            {
                Caption = 'Receivable Payment Details';
                // Editable = (Rec."BLRReceivable Payment Status" <> PaymentStatus::Received);
                field("FC ID"; Rec."BLRFC ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'FC ID';
                    ToolTip = 'The unique identifier for the final calculation associated with this payment.';
                }
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'Contract ID';
                    ToolTip = 'The unique identifier for the contract associated with this payment.';
                }
                field("Receivable Total Amount"; Rec."BLRReceivable Total Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The total amount receivable from the tenant for this payment.';
                }
                field("Receivable Due Date"; Rec."BLRReceivable Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'The due date for the receivable payment.';
                }
                field("Receivable Payment mode"; Rec."BLRReceivable Payment mode")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    ToolTip = 'The payment mode for the receivable payment.';
                }

                field("Receivable Payment Status"; Rec."BLRReceivable Payment Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'The current payment status of the receivable payment.';

                    trigger OnValidate()
                    var
                        PaymentStatus: Enum "BLRPayment Status";
                    begin
                        // Check if Receivable Payment Status is 'Received'
                        if Rec."BLRReceivable Payment Status" = PaymentStatus::Received then begin
                            // Set PaymentStatus to 'Received' as well
                            Rec."BLRPaymentStatus" := Rec."BLRPaymentStatus"::Received;
                            Rec.Modify();  // Save changes to the current record
                        end;

                        if Rec."BLRReceivable Payment Status" <> PaymentStatus::Received then begin
                            // Set PaymentStatus to 'Received' as well
                            Rec."BLRPaymentStatus" := Rec."BLRPaymentStatus"::Pending;
                            Rec.Modify();  // Save changes to the current record
                        end;
                    end;
                }
                field("Receivable Cheque No."; Rec."BLRReceivable Cheque No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'The cheque number for the receivable payment.';
                    Editable = Rec."BLRReceivable Payment mode" = 'Cheque';

                    trigger OnValidate()
                    var

                    begin
                        if Rec."BLRReceivable Payment Mode" <> 'Cheque' then
                            Error('Cheque number can only be entered when Payment Mode is set to Cheque.');
                    end;
                }

                field("Deposit Bank"; Rec."BLRDeposit Bank")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    ToolTip = 'The bank where the deposit is made.';
                    Editable = not (Rec."BLRReceivable Payment mode" = 'Cash') and not (Rec."BLRReceivable Payment mode" = 'Pending');
                    trigger OnValidate()
                    var

                    begin
                        if Rec."BLRReceivable Payment Mode" = 'Cash' then
                            Error('Deposit Bank is not valid for Cash');
                    end;
                }

                field("Deposit Status"; Rec."BLRDeposit Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The status of the deposit for the receivable payment.';

                    trigger OnValidate()
                    var

                    begin
                        if Rec."BLRReceivable Payment Mode" = 'Cash' then
                            Error('Deposit Bank is not valid for Cash');
                    end;
                }

                field("Payment Receipt"; Rec."BLRPayment Receipt")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Receipt';
                    ToolTip = 'The payment receipt for the receivable payment.';
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin

                        FileURL := Rec."BLRPmtRcptDocURL";
                        if FileURL = '' then
                            Error('No document is available to view.');
                        OpenFileInBrowser1(FileURL);
                    end;
                }
                field("Payment Receipt document URL"; Rec."BLRPmtRcptDocURL")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Receipt document URL';
                    ToolTip = 'The URL of the payment receipt document.';
                }

                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'The unique identifier for the tenant associated with this payment.';
                }
                field("Tenant Email"; Rec."BLRTenant Email")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'The email address of the tenant associated with this payment.';
                }
                field("Tenant Name"; Rec."BLRTenant Name")
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
        finalCalculationgrid: Record "BLRFinalCalculation";
        paymentTypeRec: Record "BLRPaymentType"; // Record variable for Payment Type
        lPaymentStatus: Enum "BLRPayment Status";
    begin

        /////////////////////////// Receivable final settlement /////////////////////////////////

        if Rec."BLRReceivable Cheque No." = '' then
            Rec."BLRReceivable Cheque No." := '-';

        if Rec."BLRReceivable Payment mode" = '' then
            if paymentTypeRec.FindFirst() then
                Rec."BLRReceivable Payment mode" := paymentTypeRec."BLRPayment Method"; // Set the first Payment Method as default


        finalCalculationgrid.SetRange("BLRFC ID", Rec."BLRFC ID");
        if finalCalculationgrid.FindFirst() then begin
            Rec."BLRContract ID" := finalCalculationgrid."BLRContract ID";
            Rec."BLRTenant ID" := finalCalculationgrid."BLRTenant ID";
            Rec."BLRReceivable from the Tenant" := finalCalculationgrid."BLRNetRecvFromTheTenant";
            Rec."BLRBalance Receivable" := Rec."BLRReceivable from the Tenant";
            Rec."BLRReceivable Total Amount" := Rec."BLRReceivable from the Tenant";
            if Rec."BLRReceivable Payment Status" = lPaymentStatus::" " then
                Rec."BLRReceivable Payment Status" := lPaymentStatus::Scheduled;

            if Rec."BLRReceivable Payment Status" = lPaymentStatus::Received then begin
                Rec."BLRPaymentStatus" := Rec."BLRPaymentStatus"::Received;
                Rec."BLRBalance Receivable" := 0;
                Rec."BLRPayment Processed" := Rec."BLRReceivable from the Tenant";
                Rec.Modify();
            end;

            if Rec."BLRReceivable Payment Status" = lPaymentStatus::Received then
                exit;

            if Rec."BLRReceivable Due Date" = Today() then
                Rec."BLRReceivable Payment Status" := lPaymentStatus::Due

            else
                if Rec."BLRReceivable Due Date" > Today() then
                    Rec."BLRReceivable Payment Status" := lPaymentStatus::Scheduled

                else
                    if Rec."BLRReceivable Due Date" = 0D then
                        Rec."BLRReceivable Payment Status" := lPaymentStatus::Scheduled

                    else
                        if Rec."BLRReceivable Due Date" < Today() then
                            Rec."BLRReceivable Payment Status" := lPaymentStatus::Overdue;

            Rec.Modify();
        end;
    end;

    trigger OnAfterGetRecord()
    var
        finalCalculationgrid: Record "BLRFinalCalculation";
        paymentTypeRec: Record "BLRPaymentType"; // Record variable for Payment Type
        lPaymentStatus: Enum "BLRPayment Status";
    begin

        /////////////////////////// Receivable final settlement /////////////////////////////////

        if Rec."BLRReceivable Cheque No." = '' then
            Rec."BLRReceivable Cheque No." := '-';

        if Rec."BLRReceivable Payment mode" = '' then
            if paymentTypeRec.FindFirst() then
                Rec."BLRReceivable Payment mode" := paymentTypeRec."BLRPayment Method"; // Set the first Payment Method as default


        finalCalculationgrid.SetRange("BLRFC ID", Rec."BLRFC ID");
        if finalCalculationgrid.FindFirst() then begin
            Rec."BLRContract ID" := finalCalculationgrid."BLRContract ID";
            Rec."BLRTenant ID" := finalCalculationgrid."BLRTenant ID";
            Rec."BLRReceivable from the Tenant" := finalCalculationgrid."BLRNetRecvFromTheTenant";
            Rec."BLRBalance Receivable" := Rec."BLRReceivable from the Tenant";
            Rec."BLRReceivable Total Amount" := Rec."BLRReceivable from the Tenant";
            if Rec."BLRReceivable Payment Status" = lPaymentStatus::" " then
                Rec."BLRReceivable Payment Status" := lPaymentStatus::Scheduled;

            if Rec."BLRReceivable Payment Status" = lPaymentStatus::Received then begin
                Rec."BLRPaymentStatus" := Rec."BLRPaymentStatus"::Received;
                Rec."BLRBalance Receivable" := 0;
                Rec."BLRPayment Processed" := Rec."BLRReceivable from the Tenant";
                Rec.Modify();
            end;

            if Rec."BLRReceivable Payment Status" = lPaymentStatus::Received then
                exit;

            if Rec."BLRReceivable Due Date" = Today() then
                Rec."BLRReceivable Payment Status" := lPaymentStatus::Due
            else
                if Rec."BLRReceivable Due Date" > Today() then
                    Rec."BLRReceivable Payment Status" := lPaymentStatus::Scheduled
                else
                    if Rec."BLRReceivable Due Date" = 0D then
                        Rec."BLRReceivable Payment Status" := lPaymentStatus::Scheduled
                    else
                        if Rec."BLRReceivable Due Date" < Today() then
                            Rec."BLRReceivable Payment Status" := lPaymentStatus::Overdue;

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
        if Rec."BLRReceivable Payment mode" = 'Cash' then
            exit(false)
        else
            exit(true);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        finalCalculationgrid: Record "BLRFinalCalculation";
        paymentTypeRec: Record "BLRPaymentType"; // Record variable for Payment Type
        lPaymentStatus: Enum "BLRPayment Status";
    begin

        Rec."BLRContract ID" := ContractID;
        Rec."BLRTenant ID" := tenantID;

        /////////////////////////// Receivable final settlement /////////////////////////////////

        if Rec."BLRReceivable Cheque No." = '' then
            Rec."BLRReceivable Cheque No." := '-';

        if Rec."BLRReceivable Payment mode" = '' then
            if paymentTypeRec.FindFirst() then
                Rec."BLRReceivable Payment mode" := paymentTypeRec."BLRPayment Method"; // Set the first Payment Method as default

        finalCalculationgrid.SetRange("BLRFC ID", Rec."BLRFC ID");
        if finalCalculationgrid.FindFirst() then begin
            Rec."BLRContract ID" := finalCalculationgrid."BLRContract ID";
            Rec."BLRTenant ID" := finalCalculationgrid."BLRTenant ID";
            Rec."BLRReceivable from the Tenant" := finalCalculationgrid."BLRNetRecvFromTheTenant";
            Rec."BLRBalance Receivable" := Rec."BLRReceivable from the Tenant";
            Rec."BLRReceivable Total Amount" := Rec."BLRReceivable from the Tenant";

            if Rec."BLRReceivable Payment Status" = lPaymentStatus::" " then
                Rec."BLRReceivable Payment Status" := lPaymentStatus::Scheduled;

            if Rec."BLRReceivable Payment Status" = lPaymentStatus::Received then begin
                Rec."BLRPaymentStatus" := Rec."BLRPaymentStatus"::Received;
                Rec."BLRBalance Receivable" := 0;
                Rec."BLRPayment Processed" := Rec."BLRReceivable from the Tenant";
                Rec.Modify();
            end;

            if Rec."BLRReceivable Payment Status" = lPaymentStatus::Received then
                exit;

            if Rec."BLRReceivable Due Date" = Today() then
                Rec."BLRReceivable Payment Status" := lPaymentStatus::Due

            else
                if Rec."BLRReceivable Due Date" > Today() then
                    Rec."BLRReceivable Payment Status" := lPaymentStatus::Scheduled

                else
                    if Rec."BLRReceivable Due Date" = 0D then
                        Rec."BLRReceivable Payment Status" := lPaymentStatus::Scheduled

                    else
                        if Rec."BLRReceivable Due Date" < Today() then
                            Rec."BLRReceivable Payment Status" := lPaymentStatus::Overdue;

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

        PaymentStatus: Enum "BLRPayment Status";

        editablelogic: Boolean;

}