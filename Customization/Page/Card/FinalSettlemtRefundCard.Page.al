page 73209695 "BLRFinalSettlemtRefundCard"
{
    PageType = ListPart;
    SourceTable = "BLRFinalSettlementRefund";
    ApplicationArea = All;
    Caption = 'Final Settlement Details';

    layout
    {
        area(Content)
        {
            group(RefundDetails)
            {
                Caption = 'Refund Details';

                field("Net Refund to the Tenant"; Rec."BLRNet Refund to the Tenant")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Displays the net refund amount to the tenant.';
                }

                field("Refund Processed"; Rec."BLRRefund Processed")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Displays the amount that has been processed for refund.';
                }

                field("Balance Refundable"; Rec."BLRBalance Refundable")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Displays the balance amount that can be processed for refund.';
                }

                field("Refund Status"; Rec."BLRRefund Status")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Displays the current status of the refund process.';
                }
                field("Adjust Security Deposit"; Rec."BLRAdjust Security Deposit")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Indicates if the security deposit has been adjusted.';
                }
                field("Adjust Chiller Deposit"; Rec."BLRAdjust Chiller Deposit")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Indicates if the chiller deposit has been adjusted.';
                }
                field("Adjust other deposit"; Rec."BLRAdjust other deposit")
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
                //  Editable = (Rec."BLRRefund Payment Status" <> Rec."BLRRefund Payment Status"::Paid);

                field("FC ID"; Rec."BLRFC ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'FC ID';
                    ToolTip = 'Displays the Final Calculation ID associated with the refund.';
                }
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'Refund Contract ID';
                    ToolTip = 'Displays the contract ID associated with the refund.';
                }
                field("Refund Total Amount"; Rec."BLRRefund Total Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays the total amount to be refunded to the tenant.';
                }

                field("Refund Due Date"; Rec."BLRRefund Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Displays the due date for the refund.';
                }

                field("Refund Payment mode"; Rec."BLRRefund Payment mode")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    ToolTip = 'Select the payment mode for the refund. Options include Cash, Cheque, Bank Transfer, etc.';
                }

                field("Refund Payment Status"; Rec."BLRRefund Payment Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Displays the payment status of the refund. Options include Scheduled, Due, Overdue, Paid, etc.';

                    trigger OnValidate()
                    var
                        finalSettlementRefund: Record BLRFinalSettlementRefund;
                        Email: Codeunit "BLRFSRefundablePaymentReceipt";
                        azureBlobUploader: Codeunit "BLRAzure AD Blob Storage";
                        RefundPostingMgt: Codeunit "BLRRefundSettlementPostingMgt.";
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
                        if Rec."BLRRefund Payment Status" = Rec."BLRRefund Payment Status"::Paid then begin
                            // Set Rec."BLRRefund Payment Status" to 'Received' as well
                            Rec."BLRRefund Status" := Rec."BLRRefund Status"::Paid;
                            Rec.Modify();  // Save changes to the current record
                        end;

                        if Rec."BLRRefund Payment Status" <> Rec."BLRRefund Payment Status"::Paid then begin
                            // Set PaymentStatus to 'Received' as well
                            Rec."BLRRefund Status" := Rec."BLRRefund Status"::Pending;
                            Rec.Modify();  // Save changes to the current record
                        end;
                        if Rec."BLRRefund Payment Status" = Rec."BLRRefund Payment Status"::Paid then begin
                            if (Rec."BLRRefund Due Date" = 0D) or (Rec."BLRRefund Due Date" > Today()) then
                                Error('Refund Date is required. It must be today or in the past to mark payment status as Paid.');



                            case Rec."BLRRefund Payment mode" of
                                'Cheque':
                                    if (Rec."BLRRefund Cheque No." = '-') or (Rec."BLRDeposit Bank" = '') then
                                        Error('Cheque details are incomplete. Please fill Cheque Number and Deposit Bank');



                                'Bank Transfer', 'Credit Card', 'Mobile Wallet':
                                    if Rec."BLRDeposit Bank" = '' then
                                        Error('Deposit Bank must be entered for %1 payments.', Rec."BLRRefund Payment mode");

                            end;

                            if Confirm('Do you want to post journal lines?', true) then begin
                                RefundPostingMgt.PostRefundJournalLines(Rec);
                                Rec."BLRReceipt #" := 'Receipt_' + Format(Rec."BLRContract ID") + '-' + Format(Rec."BLRFC ID");

                                Rec.Modify(true);
                                Commit();
                                Email.SendEmail(Rec);

                                ReportID := 73209582;
                                //  RecRef.Open(DATABASE::"Sales Header"); // Open the table reference
                                // RecRef.GetTable(Rec);
                                finalSettlementRefund.Reset();
                                finalSettlementRefund.SetRange("BLRTenant ID", Rec."BLRTenant ID");
                                finalSettlementRefund.SetRange("BLRContract ID", Rec."BLRContract ID");
                                if not finalSettlementRefund.FindFirst() then begin
                                    Rec."BLRRefund Payment Status" := xRec."BLRRefund Payment Status";
                                    exit;
                                end;

                                RecRef.GetTable(finalSettlementRefund);
                                TempBlob.CreateOutStream(OutStream);
                                Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStream, RecRef);
                                TempBlob.CreateInStream(inStream);

                                fileName := 'Receipt_' + Format(Rec."BLRContract ID") + Format(Rec."BLRFC ID") + '.pdf';

                                folderName := 'Payment Receipt';
                                uploadResult := azureBlobUploader.UploadDocumentToBlob(inStream, fileName, folderName);
                                if fileName <> '' then begin
                                    Rec."BLRPayment Receipt/Proof" := fileName;
                                    Rec."BLRPayRcptProofDocURL" := CopyStr(uploadResult, 1, StrLen(uploadResult));
                                    Rec.Modify(true);
                                    Message('File uploaded successfully: %1', fileName);
                                end;
                            end
                        end;
                    end;
                }

                field("Deposit Bank"; Rec."BLRDeposit Bank")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = Rec."BLRRefund Payment Mode" <> 'Cash';
                    ToolTip = 'Select the bank where the refund will be deposited. This field is editable only if the payment mode is not Cash.';
                }
                field("Refund Cheque No."; Rec."BLRRefund Cheque No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the cheque number for the refund. This field is editable only if the payment mode is Cheque.';
                    Editable = Rec."BLRRefund Payment Mode" = 'Cheque';

                    trigger OnValidate()
                    var

                    begin
                        if Rec."BLRRefund Payment Mode" <> 'Cheque' then
                            Error('Cheque number can only be entered when Payment Mode is set to Cheque.');
                    end;
                }

                field("Payment Receipt/Proof"; Rec."BLRPayment Receipt/Proof")
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

                        FileURL := Rec."BLRPayRcptProofDocURL";


                        if FileURL = '' then
                            Error('No document is available to view.');


                        OpenFileInBrowser1(FileURL);
                    end;
                }
                field("Pay Receipt/Proof document URL"; Rec."BLRPayRcptProofDocURL")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Receipt/Proof document URL';
                    ToolTip = 'Displays the URL of the payment receipt or proof document.';
                }
                field("Tenant ID"; Rec."BLRTenant ID")
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
        finalCalculationgrid: Record "BLRFinalCalculation";
        paymentTypeRec: Record "BLRPaymentType"; // Record variable for Payment Type

    begin

        ////////////////////////// Refund final settlement /////////////////////////////////////

        if Rec."BLRRefund Cheque No." = '' then
            Rec."BLRRefund Cheque No." := '-';
        if Rec."BLRRefund Payment mode" = '' then
            if paymentTypeRec.FindFirst() then
                Rec."BLRRefund Payment mode" := paymentTypeRec."BLRPayment Method";

        finalCalculationgrid.SetRange("BLRFC ID", Rec."BLRFC ID");
        if finalCalculationgrid.FindFirst() then begin
            Rec."BLRContract ID" := finalCalculationgrid."BLRContract ID";
            Rec."BLRTenant ID" := finalCalculationgrid."BLRTenant ID";
            Rec."BLRNet Refund to the Tenant" := finalCalculationgrid."BLRAmount Refundable";
            Rec."BLRBalance Refundable" := Rec."BLRNet Refund to the Tenant";
            Rec."BLRRefund Total Amount" := Rec."BLRNet Refund to the Tenant";

            if Rec."BLRRefund Payment Status" = Rec."BLRRefund Payment Status"::Paid then begin
                Rec."BLRRefund Status" := Rec."BLRRefund Status"::Paid;
                Rec."BLRBalance Refundable" := 0;
                Rec."BLRRefund Processed" := Rec."BLRNet Refund to the Tenant";
                Rec.Modify();
            end;

            if Rec."BLRRefund Payment Status" = Rec."BLRRefund Payment Status"::Paid then
                exit;

            if Rec."BLRRefund Due Date" = Today() then
                Rec."BLRRefund Payment Status" := Rec."BLRRefund Payment Status"::Due

            else
                if Rec."BLRRefund Due Date" > Today() then
                    Rec."BLRRefund Payment Status" := Rec."BLRRefund Payment Status"::Scheduled

                else
                    if Rec."BLRRefund Due Date" = 0D then
                        Rec."BLRRefund Payment Status" := Rec."BLRRefund Payment Status"::Scheduled

                    else
                        if Rec."BLRRefund Due Date" < Today() then
                            Rec."BLRRefund Payment Status" := Rec."BLRRefund Payment Status"::Overdue;

            Rec.Modify();

        end;
    end;

    trigger OnAfterGetRecord()
    var
        finalCalculationgrid: Record "BLRFinalCalculation";
        paymentTypeRec: Record "BLRPaymentType"; // Record variable for Payment Type

    begin

        ////////////////////////// Refund final settlement /////////////////////////////////////

        if Rec."BLRRefund Cheque No." = '' then
            Rec."BLRRefund Cheque No." := '-';
        if Rec."BLRRefund Payment mode" = '' then
            if paymentTypeRec.FindFirst() then
                Rec."BLRRefund Payment mode" := paymentTypeRec."BLRPayment Method";

        finalCalculationgrid.SetRange("BLRFC ID", Rec."BLRFC ID");
        if finalCalculationgrid.FindFirst() then begin
            Rec."BLRContract ID" := finalCalculationgrid."BLRContract ID";
            Rec."BLRTenant ID" := finalCalculationgrid."BLRTenant ID";
            Rec."BLRNet Refund to the Tenant" := finalCalculationgrid."BLRAmount Refundable";
            Rec."BLRBalance Refundable" := Rec."BLRNet Refund to the Tenant";
            Rec."BLRRefund Total Amount" := Rec."BLRNet Refund to the Tenant";

            if Rec."BLRRefund Payment Status" = Rec."BLRRefund Payment Status"::Paid then begin
                Rec."BLRRefund Status" := Rec."BLRRefund Status"::Paid;
                Rec."BLRBalance Refundable" := 0;
                Rec."BLRRefund Processed" := Rec."BLRNet Refund to the Tenant";
                Rec.Modify();
            end;

            if Rec."BLRRefund Payment Status" = Rec."BLRRefund Payment Status"::Paid then
                exit;

            if Rec."BLRRefund Due Date" = Today() then
                Rec."BLRRefund Payment Status" := Rec."BLRRefund Payment Status"::Due

            else
                if Rec."BLRRefund Due Date" > Today() then
                    Rec."BLRRefund Payment Status" := Rec."BLRRefund Payment Status"::Scheduled

                else
                    if Rec."BLRRefund Due Date" = 0D then
                        Rec."BLRRefund Payment Status" := Rec."BLRRefund Payment Status"::Scheduled

                    else
                        if Rec."BLRRefund Due Date" < Today() then
                            Rec."BLRRefund Payment Status" := Rec."BLRRefund Payment Status"::Overdue;

            Rec.Modify();
        end;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        finalCalculationgrid: Record "BLRFinalCalculation";
        paymentTypeRec: Record "BLRPaymentType";
    begin

        Rec."BLRContract ID" := ContractID;
        Rec."BLRTenant ID" := tenantID;


        ////////////////////////// Refund final settlement /////////////////////////////////////

        if Rec."BLRRefund Cheque No." = '' then
            Rec."BLRRefund Cheque No." := '-';
        if Rec."BLRRefund Payment mode" = '' then
            if paymentTypeRec.FindFirst() then
                Rec."BLRRefund Payment mode" := paymentTypeRec."BLRPayment Method";

        finalCalculationgrid.SetRange("BLRFC ID", Rec."BLRFC ID");
        if finalCalculationgrid.FindFirst() then begin
            Rec."BLRContract ID" := finalCalculationgrid."BLRContract ID";
            Rec."BLRTenant ID" := finalCalculationgrid."BLRTenant ID";
            Rec."BLRNet Refund to the Tenant" := finalCalculationgrid."BLRAmount Refundable";
            Rec."BLRBalance Refundable" := Rec."BLRNet Refund to the Tenant";
            Rec."BLRRefund Total Amount" := Rec."BLRNet Refund to the Tenant";

            if Rec."BLRRefund Payment Status" = Rec."BLRRefund Payment Status"::Paid then begin
                Rec."BLRRefund Status" := Rec."BLRRefund Status"::Paid;
                Rec."BLRBalance Refundable" := 0;
                Rec."BLRRefund Processed" := Rec."BLRNet Refund to the Tenant";
                Rec.Modify();
            end;

            if Rec."BLRRefund Payment Status" = Rec."BLRRefund Payment Status"::Paid then
                exit;

            if Rec."BLRRefund Due Date" = Today() then
                Rec."BLRRefund Payment Status" := Rec."BLRRefund Payment Status"::Due

            else
                if Rec."BLRRefund Due Date" > Today() then
                    Rec."BLRRefund Payment Status" := Rec."BLRRefund Payment Status"::Scheduled

                else
                    if Rec."BLRRefund Due Date" = 0D then
                        Rec."BLRRefund Payment Status" := Rec."BLRRefund Payment Status"::Scheduled

                    else
                        if Rec."BLRRefund Due Date" < Today() then
                            Rec."BLRRefund Payment Status" := Rec."BLRRefund Payment Status"::Overdue;

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