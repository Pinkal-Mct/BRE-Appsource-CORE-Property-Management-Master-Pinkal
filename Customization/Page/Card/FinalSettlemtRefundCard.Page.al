page 50940 "FinalSettlemtRefundCard"
{
    PageType = ListPart;
    SourceTable = "FinalSettlementRefund";
    ApplicationArea = All;
    Caption = 'Final Settlement Details';

    layout
    {
        area(Content)
        {
            group(RefundDetails)
            {
                Caption = 'Refund Details';

                field("Net Refund to the Tenant"; Rec."Net Refund to the Tenant")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Displays the net refund amount to the tenant.';
                }

                field("Refund Processed"; Rec."Refund Processed")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Displays the amount that has been processed for refund.';
                }

                field("Balance Refundable"; Rec."Balance Refundable")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Displays the balance amount that can be processed for refund.';
                }

                field("Refund Status"; Rec."Refund Status")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Displays the current status of the refund process.';
                }
                field("Adjust Security Deposit"; Rec."Adjust Security Deposit")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Indicates if the security deposit has been adjusted.';
                }
                field("Adjust Chiller Deposit"; Rec."Adjust Chiller Deposit")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Indicates if the chiller deposit has been adjusted.';
                }
                field("Adjust other deposit"; Rec."Adjust other deposit")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Indicates if the other deposit has been adjusted.';
                }
            }

            repeater(RefundPaymentDetails)
            {
                Caption = 'Refund Payment Details';
                Editable = (Rec."Refund Payment Status" <> Rec."Refund Payment Status"::Paid);

                field("FC ID"; Rec."FC ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'FC ID';
                    ToolTip = 'Displays the Final Calculation ID associated with the refund.';
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'Refund Contract ID';
                    ToolTip = 'Displays the contract ID associated with the refund.';
                }
                field("Refund Total Amount"; Rec."Refund Total Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays the total amount to be refunded to the tenant.';
                }

                field("Refund Due Date"; Rec."Refund Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Displays the due date for the refund.';
                }

                field("Refund Payment mode"; Rec."Refund Payment mode")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    ToolTip = 'Select the payment mode for the refund. Options include Cash, Cheque, Bank Transfer, etc.';
                }

                field("Refund Payment Status"; Rec."Refund Payment Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Displays the payment status of the refund. Options include Scheduled, Due, Overdue, Paid, etc.';

                    trigger OnValidate()
                    var
                        finalSettlementRefund: Record FinalSettlementRefund;
                        Email: Codeunit "FS Refundable Payment Receipt";
                        azureBlobUploader: Codeunit "Azure AD Blob Storage";
                        RefundPostingMgt: Codeunit "Refund Settlement Posting Mgt.";
                        TempBlob: Codeunit "Temp Blob";
                        RecRef: RecordRef;
                        fileName: Text;
                        uploadResult: Text;
                        folderName: Text;
                        inStream: InStream;
                        ReportID: Integer;
                        OutStream: OutStream;
                    begin
                        // Check if Receivable Payment Status is 'Received'
                        if Rec."Refund Payment Status" = Rec."Refund Payment Status"::Paid then begin
                            // Set Rec."Refund Payment Status" to 'Received' as well
                            Rec."Refund Status" := Rec."Refund Status"::Paid;
                            Rec.Modify();  // Save changes to the current record
                        end;

                        if Rec."Refund Payment Status" <> Rec."Refund Payment Status"::Paid then begin
                            // Set PaymentStatus to 'Received' as well
                            Rec."Refund Status" := Rec."Refund Status"::Pending;
                            Rec.Modify();  // Save changes to the current record
                        end;
                        if Rec."Refund Payment Status" = Rec."Refund Payment Status"::Paid then
                            if Confirm('Do you want to post journal lines?', true) then begin
                                RefundPostingMgt.PostRefundJournalLines(Rec);

                                Email.SendEmail(Rec);

                                ReportID := 50114;
                                //  RecRef.Open(DATABASE::"Sales Header"); // Open the table reference
                                // RecRef.GetTable(Rec);
                                finalSettlementRefund.Reset();
                                finalSettlementRefund.SetRange("Tenant ID", Rec."Tenant ID");
                                finalSettlementRefund.SetRange("Contract ID", Rec."Contract ID"); // Ensure filtering on unique ID
                                if not finalSettlementRefund.FindFirst() then
                                    Error('Not avavilable');
                                RecRef.GetTable(finalSettlementRefund);
                                RecRef.GetTable(Rec);
                                TempBlob.CreateOutStream(OutStream);
                                Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStream, RecRef);
                                TempBlob.CreateInStream(inStream);

                                fileName := 'Receipt_' + Format(Rec."Contract ID") + Format(Rec."FC ID") + '.pdf';

                                folderName := 'Payment Receipt';
                                uploadResult := azureBlobUploader.UploadDocumentToBlob(inStream, fileName, folderName);
                                if fileName <> '' then begin
                                    Rec."Payment Receipt/Proof" := CopyStr(fileName, 1, StrLen(fileName));
                                    Rec."Pay Receipt/Proof document URL" := CopyStr(uploadResult, 1, StrLen(uploadResult));
                                    Rec.Modify();
                                    Message('File uploaded successfully: %1', fileName);
                                end;
                                Rec.Modify();
                            end
                            else
                                exit;
                    end;
                }

                field("Deposit Bank"; Rec."Deposit Bank")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = Rec."Refund Payment Mode" <> 'Cash';
                    ToolTip = 'Select the bank where the refund will be deposited. This field is editable only if the payment mode is not Cash.';
                }
                field("Refund Cheque No."; Rec."Refund Cheque No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the cheque number for the refund. This field is editable only if the payment mode is Cheque.';

                    trigger OnValidate()
                    var

                    begin
                        if Rec."Refund Payment Mode" <> 'Cheque' then
                            Error('Cheque number can only be entered when Payment Mode is set to Cheque.');
                    end;
                }

                field("Payment Receipt/Proof"; Rec."Payment Receipt/Proof")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Receipt/Proof';
                    Editable = false;
                    DrillDown = true;
                    ToolTip = 'Displays the name of the payment receipt or proof document. Click to view the document.';
                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin

                        FileURL := Rec."Pay Receipt/Proof document URL";


                        if FileURL = '' then
                            Error('No document is available to view.');


                        OpenFileInBrowser1(FileURL);
                    end;
                }
                field("Pay Receipt/Proof document URL"; Rec."Pay Receipt/Proof document URL")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Receipt/Proof document URL';
                    ToolTip = 'Displays the URL of the payment receipt or proof document.';
                }
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Displays the tenant ID associated with the refund.';
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

    trigger OnModifyRecord(): Boolean
    var
        finalCalculationgrid: Record "Final Calculation";
        paymentTypeRec: Record "Payment Type"; // Record variable for Payment Type

    begin

        ////////////////////////// Refund final settlement /////////////////////////////////////

        if Rec."Refund Cheque No." = '' then
            Rec."Refund Cheque No." := '-';
        if Rec."Refund Payment mode" = '' then
            if paymentTypeRec.FindFirst() then
                Rec."Refund Payment mode" := paymentTypeRec."Payment Method";

        finalCalculationgrid.SetRange("FC ID", Rec."FC ID");
        if finalCalculationgrid.FindFirst() then begin
            Rec."Contract ID" := finalCalculationgrid."Contract ID";
            Rec."Tenant ID" := finalCalculationgrid."Tenant ID";
            Rec."Net Refund to the Tenant" := finalCalculationgrid."Amount Refundable";
            Rec."Balance Refundable" := Rec."Net Refund to the Tenant";
            Rec."Refund Total Amount" := Rec."Net Refund to the Tenant";

            if Rec."Refund Payment Status" = Rec."Refund Payment Status"::Paid then begin
                Rec."Refund Status" := Rec."Refund Status"::Paid;
                Rec."Balance Refundable" := 0;
                Rec."Refund Processed" := Rec."Net Refund to the Tenant";
                Rec.Modify();
            end;

            if Rec."Refund Payment Status" = Rec."Refund Payment Status"::Paid then
                exit;

            if Rec."Refund Due Date" = Today() then
                Rec."Refund Payment Status" := Rec."Refund Payment Status"::Due

            else
                if Rec."Refund Due Date" > Today() then
                    Rec."Refund Payment Status" := Rec."Refund Payment Status"::Scheduled

                else
                    if Rec."Refund Due Date" = 0D then
                        Rec."Refund Payment Status" := Rec."Refund Payment Status"::Scheduled

                    else
                        if Rec."Refund Due Date" < Today() then
                            Rec."Refund Payment Status" := Rec."Refund Payment Status"::Overdue;

            Rec.Modify();

        end;
    end;

    trigger OnAfterGetRecord()
    var
        finalCalculationgrid: Record "Final Calculation";
        paymentTypeRec: Record "Payment Type"; // Record variable for Payment Type

    begin

        ////////////////////////// Refund final settlement /////////////////////////////////////

        if Rec."Refund Cheque No." = '' then
            Rec."Refund Cheque No." := '-';
        if Rec."Refund Payment mode" = '' then
            if paymentTypeRec.FindFirst() then
                Rec."Refund Payment mode" := paymentTypeRec."Payment Method";

        finalCalculationgrid.SetRange("FC ID", Rec."FC ID");
        if finalCalculationgrid.FindFirst() then begin
            Rec."Contract ID" := finalCalculationgrid."Contract ID";
            Rec."Tenant ID" := finalCalculationgrid."Tenant ID";
            Rec."Net Refund to the Tenant" := finalCalculationgrid."Amount Refundable";
            Rec."Balance Refundable" := Rec."Net Refund to the Tenant";
            Rec."Refund Total Amount" := Rec."Net Refund to the Tenant";

            if Rec."Refund Payment Status" = Rec."Refund Payment Status"::Paid then begin
                Rec."Refund Status" := Rec."Refund Status"::Paid;
                Rec."Balance Refundable" := 0;
                Rec."Refund Processed" := Rec."Net Refund to the Tenant";
                Rec.Modify();
            end;

            if Rec."Refund Payment Status" = Rec."Refund Payment Status"::Paid then
                exit;

            if Rec."Refund Due Date" = Today() then
                Rec."Refund Payment Status" := Rec."Refund Payment Status"::Due

            else
                if Rec."Refund Due Date" > Today() then
                    Rec."Refund Payment Status" := Rec."Refund Payment Status"::Scheduled

                else
                    if Rec."Refund Due Date" = 0D then
                        Rec."Refund Payment Status" := Rec."Refund Payment Status"::Scheduled

                    else
                        if Rec."Refund Due Date" < Today() then
                            Rec."Refund Payment Status" := Rec."Refund Payment Status"::Overdue;

            Rec.Modify();
        end;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        finalCalculationgrid: Record "Final Calculation";
        paymentTypeRec: Record "Payment Type";
    begin

        Rec."Contract ID" := ContractID;
        Rec."Tenant ID" := tenantID;


        ////////////////////////// Refund final settlement /////////////////////////////////////

        if Rec."Refund Cheque No." = '' then
            Rec."Refund Cheque No." := '-';
        if Rec."Refund Payment mode" = '' then
            if paymentTypeRec.FindFirst() then
                Rec."Refund Payment mode" := paymentTypeRec."Payment Method";

        finalCalculationgrid.SetRange("FC ID", Rec."FC ID");
        if finalCalculationgrid.FindFirst() then begin
            Rec."Contract ID" := finalCalculationgrid."Contract ID";
            Rec."Tenant ID" := finalCalculationgrid."Tenant ID";
            Rec."Net Refund to the Tenant" := finalCalculationgrid."Amount Refundable";
            Rec."Balance Refundable" := Rec."Net Refund to the Tenant";
            Rec."Refund Total Amount" := Rec."Net Refund to the Tenant";

            if Rec."Refund Payment Status" = Rec."Refund Payment Status"::Paid then begin
                Rec."Refund Status" := Rec."Refund Status"::Paid;
                Rec."Balance Refundable" := 0;
                Rec."Refund Processed" := Rec."Net Refund to the Tenant";
                Rec.Modify();
            end;

            if Rec."Refund Payment Status" = Rec."Refund Payment Status"::Paid then
                exit;

            if Rec."Refund Due Date" = Today() then
                Rec."Refund Payment Status" := Rec."Refund Payment Status"::Due

            else
                if Rec."Refund Due Date" > Today() then
                    Rec."Refund Payment Status" := Rec."Refund Payment Status"::Scheduled

                else
                    if Rec."Refund Due Date" = 0D then
                        Rec."Refund Payment Status" := Rec."Refund Payment Status"::Scheduled

                    else
                        if Rec."Refund Due Date" < Today() then
                            Rec."Refund Payment Status" := Rec."Refund Payment Status"::Overdue;

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
}