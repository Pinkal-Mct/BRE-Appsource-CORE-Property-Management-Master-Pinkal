page 73209713 "BLRPDCTransaction"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "BLRPDCTransaction";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                Caption = 'General Information';
                field("PDC ID"; Rec."BLRPDC ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the PDC transaction. This field is auto-generated and cannot be edited.';
                }

                field("payment Series"; Rec."BLRpayment Series")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the payment series associated with this PDC transaction. This field is auto-generated and cannot be edited.';
                }
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the contract associated with this PDC transaction. This field is auto-generated and cannot be edited.';
                }
                field("Tenant Name"; Rec."BLRTenant Id")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the tenant associated with this PDC transaction. This field is auto-populated based on the Contract ID and cannot be edited.';
                }
                field("Tenant"; Rec."BLRTenant Name Display")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the tenant associated with this PDC transaction. This field is auto-populated based on the Contract ID and cannot be edited.';

                }
                field("Cheque Number"; Rec."BLRCheque Number")
                {
                    ApplicationArea = All;
                    Editable = IsFieldEditable;
                    ToolTip = 'Specifies the cheque number for this PDC transaction. This field is editable when the cheque status allows for changes.';
                    trigger OnValidate()
                    var
                        PaymentSeriesRec: Record "BLRPaymentMode2";
                    begin
                        PaymentSeriesRec.SetRange("BLRContract ID", Rec."BLRContract ID");
                        PaymentSeriesRec.SetRange("BLRPayment Series", Rec."BLRpayment Series");
                        if PaymentSeriesRec.FindSet() then begin
                            PaymentSeriesRec."BLRCheque Number" := Rec."BLRCheque Number";
                            PaymentSeriesRec.Modify();
                        end;
                    end;
                }
                field("Bank Name"; Rec."BLRBank Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the bank associated with this PDC transaction. This field is editable when the cheque status allows for changes.';
                    Editable = IsFieldEditable;
                    trigger OnValidate()
                    var
                        PaymentSeriesRec: Record "BLRPaymentMode2";
                    begin
                        PaymentSeriesRec.SetRange("BLRContract ID", Rec."BLRContract ID");
                        PaymentSeriesRec.SetRange("BLRPayment Series", Rec."BLRpayment Series");
                        if PaymentSeriesRec.FindSet() then begin
                            PaymentSeriesRec."BLRDeposit Bank" := Rec."BLRBank Name";
                            PaymentSeriesRec.Modify();
                        end;
                    end;
                }

                field("Cheque Date"; Rec."BLRCheque Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on the cheque for this PDC transaction. This field is editable when the cheque status allows for changes.';
                    Editable = false;

                }
                field(Amount; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    Editable = IsFieldEditable;
                    ToolTip = 'Specifies the amount for this PDC transaction. This field is editable when the cheque status allows for changes.';

                }
                field("Old Cheque#"; Rec."BLROld Cheque#")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the old cheque number for this PDC transaction. This field is auto-populated when the cheque status is changed to Returned, Retrieved, or Replaced & Received, and cannot be edited.';
                }
                field(Status; Rec."BLRCheque Status")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                    ToolTip = 'Specifies the current status of the cheque for this PDC transaction. Changing the status will trigger specific actions based on the new status value.';
                    trigger OnValidate()
                    var
                        PaymentSeriesRec: Record "BLRPaymentMode2";
                        CashReceiptJournalCodeunit: Codeunit "BLRCash Receipt Journal Entry";
                        selectDate: Page "BLRSelect Date";
                    begin
                        if (xRec."BLRCheque Status" = xRec."BLRCheque Status"::Retrieved) then
                            if (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Cleared) OR (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Deposited) OR (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Returned) OR (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Deferred) then
                                Error('Cannot change Retrived status to %1', Rec."BLRCheque Status");


                        if (xRec."BLRCheque Status" = xRec."BLRCheque Status"::Returned) then
                            if (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Cleared) OR (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Deposited) OR (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Retrieved) OR (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Deferred) then
                                Error('Cannot change Returned status to %1', Rec."BLRCheque Status");



                        if (xRec."BLRCheque Status" = xRec."BLRCheque Status"::Deferred) then
                            if (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Cleared) OR (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Retrieved) OR (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Returned) OR (Rec."BLRCheque Status" = Rec."BLRCheque Status"::"Replaced & Received") then
                                Error('Cannot change Deferred status to %1', Rec."BLRCheque Status");

                        // if (xRec."BLRCheque Status" = xRec."BLRCheque Status"::Returned) and (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Cleared) OR (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Deposited) OR (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Retrieved) OR (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Deferred) then
                        //     Error('Cannot change Returned status to %1', Rec."BLRCheque Status");
                        // if (xRec."BLRCheque Status" = xRec."BLRCheque Status"::Deferred) and (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Cleared) OR (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Retrieved) OR (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Returned) OR (Rec."BLRCheque Status" = Rec."BLRCheque Status"::"Replaced & Received") then
                        //     Error('Cannot change Deferred status to %1', Rec."BLRCheque Status");

                        // if (xRec."BLRCheque Status" = xRec."BLRCheque Status"::Cancelled) and (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Cleared) OR (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Deposited) OR (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Returned) OR (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Deferred) OR (Rec."BLRCheque Status" = Rec."BLRCheque Status"::"Replaced & Received") OR (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Retrieved) OR (Rec."BLRCheque Status" = Rec."BLRCheque Status"::"Cheque Received") then
                        //     Error('Cannot change Cancelled status to %1', Rec."BLRCheque Status");

                        if (xRec."BLRCheque Status" = xRec."BLRCheque Status"::Deposited) then
                            if (Rec."BLRCheque Status" = Rec."BLRCheque Status"::"Cheque Received") then
                                Error('Cannot change Deposited status to %1', Rec."BLRCheque Status");

                        if (xRec."BLRCheque Status" = xRec."BLRCheque Status"::Cleared) then
                            Error('Cannot change Cleared status to %1', Rec."BLRCheque Status");

                        if (xRec."BLRCheque Status" = xRec."BLRCheque Status"::Cancelled) then
                            Error('Cannot change Cancelled status to %1', Rec."BLRCheque Status");

                        if (Rec."BLRCheque Status" <> Rec."BLRCheque Status"::Cleared) AND (Rec."BLRCheque Status" <> Rec."BLRCheque Status"::" ") AND (Rec."BLRCheque Status" <> Rec."BLRCheque Status"::Cancelled) then begin
                            Commit();
                            selectDate.Caption := 'Select Transaction Date';
                            if selectDate.RunModal() = Action::OK then
                                Rec."BLRTransaction Date" := selectDate.GetDate()
                            else
                                Error('Transaction Date selection is mandatory to proceed.');
                        end;

                        // Check if the Cheque Status is set to 'Cleared'
                        case Rec."BLRCheque Status" of
                            Rec."BLRCheque Status"::Cleared:
                                begin
                                    PaymentSeriesRec.SetRange("BLRPayment Series", Rec."BLRpayment Series");
                                    PaymentSeriesRec.SetRange("BLRContract ID", Rec."BLRContract ID");
                                    if PaymentSeriesRec.FindSet() then begin
                                        PaymentSeriesRec.Validate("BLRPayment Status", PaymentSeriesRec."BLRPayment Status"::Received);
                                        PaymentSeriesRec."BLRCheque Status" := PaymentSeriesRec."BLRCheque Status"::Cleared;
                                        PaymentSeriesRec."BLRDeposit Status" := PaymentSeriesRec."BLRDeposit Status"::Y;
                                        PaymentSeriesRec.Modify();
                                    end else
                                        Error('The related Payment Series record was not found.');
                                end;
                            Rec."BLRCheque Status"::Deposited:
                                begin
                                    CashReceiptJournalCodeunit.PDCDepositedTransaction(Rec);
                                    PaymentSeriesRec.SetRange("BLRPayment Series", Rec."BLRpayment Series");
                                    PaymentSeriesRec.SetRange("BLRContract ID", Rec."BLRContract ID");
                                    if PaymentSeriesRec.FindSet() then begin
                                        PaymentSeriesRec."BLRCheque Status" := PaymentSeriesRec."BLRCheque Status"::Deposited;
                                        PaymentSeriesRec."BLRPayment Status" := PaymentSeriesRec."BLRPayment Status"::Due;
                                        PaymentSeriesRec."BLRDeposit Status" := PaymentSeriesRec."BLRDeposit Status"::Y;
                                        PaymentSeriesRec.Modify();
                                    end else
                                        Error('The related Payment Series record was not found.');
                                end;
                            Rec."BLRCheque Status"::"Cheque Received":
                                begin
                                    CashReceiptJournalCodeunit.PDCReceivedTransaction(Rec);
                                    PaymentSeriesRec.SetRange("BLRPayment Series", Rec."BLRpayment Series");
                                    PaymentSeriesRec.SetRange("BLRContract ID", Rec."BLRContract ID");
                                    if PaymentSeriesRec.FindSet() then begin
                                        PaymentSeriesRec."BLRCheque Status" := PaymentSeriesRec."BLRCheque Status"::"Cheque Received";
                                        PaymentSeriesRec."BLRPayment Status" := PaymentSeriesRec."BLRPayment Status"::Scheduled;
                                        PaymentSeriesRec."BLRDeposit Status" := PaymentSeriesRec."BLRDeposit Status"::"-";
                                        PaymentSeriesRec.Modify();
                                    end else
                                        Error('The related Payment Series record was not found.');
                                end;
                            Rec."BLRCheque Status"::"Due cheque not deposited":
                                begin
                                    PaymentSeriesRec.SetRange("BLRPayment Series", Rec."BLRpayment Series");
                                    PaymentSeriesRec.SetRange("BLRContract ID", Rec."BLRContract ID");
                                    if PaymentSeriesRec.FindSet() then begin
                                        PaymentSeriesRec."BLRCheque Status" := PaymentSeriesRec."BLRCheque Status"::"Due cheque not deposited";
                                        PaymentSeriesRec."BLRPayment Status" := PaymentSeriesRec."BLRPayment Status"::Scheduled;
                                        PaymentSeriesRec."BLRDeposit Status" := PaymentSeriesRec."BLRDeposit Status"::"-";
                                        PaymentSeriesRec.Modify();
                                    end else
                                        Error('The related Payment Series record was not found.');
                                end;
                            Rec."BLRCheque Status"::"Replaced & Received":
                                begin
                                    PaymentSeriesRec.SetRange("BLRPayment Series", Rec."BLRpayment Series");
                                    PaymentSeriesRec.SetRange("BLRContract ID", Rec."BLRContract ID");
                                    if PaymentSeriesRec.FindSet() then begin
                                        PaymentSeriesRec."BLRCheque Status" := PaymentSeriesRec."BLRCheque Status"::"Replaced & Received";
                                        PaymentSeriesRec."BLRPayment Status" := PaymentSeriesRec."BLRPayment Status"::Scheduled;
                                        PaymentSeriesRec."BLRDeposit Status" := PaymentSeriesRec."BLRDeposit Status"::"-";
                                        PaymentSeriesRec."BLROld Cheque #" := PaymentSeriesRec."BLRCheque Number";
                                        PaymentSeriesRec."BLRCheque Number" := '';
                                        PaymentSeriesRec.Modify();
                                        Rec."BLROld Cheque#" := Rec."BLRCheque Number";
                                        Rec."BLRCheque Number" := '';
                                        Rec.Modify();
                                    end else
                                        Error('The related Payment Series record was not found.');
                                end;
                            Rec."BLRCheque Status"::Retrieved:
                                begin
                                    CashReceiptJournalCodeunit.PDCRetrivedTransaction(Rec);
                                    PaymentSeriesRec.SetRange("BLRPayment Series", Rec."BLRpayment Series");
                                    PaymentSeriesRec.SetRange("BLRContract ID", Rec."BLRContract ID");
                                    if PaymentSeriesRec.FindSet() then begin
                                        PaymentSeriesRec."BLRCheque Status" := PaymentSeriesRec."BLRCheque Status"::Retrieved;
                                        PaymentSeriesRec."BLRPayment Status" := PaymentSeriesRec."BLRPayment Status"::Cancelled;
                                        PaymentSeriesRec."BLRDeposit Status" := PaymentSeriesRec."BLRDeposit Status"::"-";
                                        PaymentSeriesRec."BLROld Cheque #" := PaymentSeriesRec."BLRCheque Number";
                                        PaymentSeriesRec."BLRCheque Number" := '';
                                        PaymentSeriesRec.Modify();
                                        Rec."BLROld Cheque#" := Rec."BLRCheque Number";
                                        Rec."BLRCheque Number" := '';
                                        Rec.Modify();
                                    end else
                                        Error('The related Payment Series record was not found.');
                                end;
                            Rec."BLRCheque Status"::Returned:
                                begin
                                    CashReceiptJournalCodeunit.PDCReturnedTransaction(Rec);
                                    PaymentSeriesRec.SetRange("BLRPayment Series", Rec."BLRpayment Series");
                                    PaymentSeriesRec.SetRange("BLRContract ID", Rec."BLRContract ID");
                                    if PaymentSeriesRec.FindSet() then begin
                                        PaymentSeriesRec."BLRCheque Status" := PaymentSeriesRec."BLRCheque Status"::Returned;
                                        PaymentSeriesRec."BLRPayment Status" := PaymentSeriesRec."BLRPayment Status"::Cancelled;
                                        PaymentSeriesRec."BLRDeposit Status" := PaymentSeriesRec."BLRDeposit Status"::"-";
                                        PaymentSeriesRec.Modify();
                                    end else
                                        Error('The related Payment Series record was not found.');
                                end;
                            Rec."BLRCheque Status"::Cancelled:
                                begin
                                    PaymentSeriesRec.SetRange("BLRPayment Series", Rec."BLRpayment Series");
                                    PaymentSeriesRec.SetRange("BLRContract ID", Rec."BLRContract ID");
                                    if PaymentSeriesRec.FindSet() then begin
                                        PaymentSeriesRec."BLRCheque Status" := PaymentSeriesRec."BLRCheque Status"::Cancelled;
                                        PaymentSeriesRec."BLRPayment Status" := PaymentSeriesRec."BLRPayment Status"::Cancelled;
                                        PaymentSeriesRec."BLRDeposit Status" := PaymentSeriesRec."BLRDeposit Status"::"-";
                                        PaymentSeriesRec.Modify();
                                    end else
                                        Error('The related Payment Series record was not found.');
                                end;
                        end;

                    end;


                }

                field("Approval Status"; Rec."BLRApproval Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = true;
                    ToolTip = 'Indicates the approval status of the PDC transaction. This field is for informational purposes and cannot be edited.';
                }

                field(View; Rec.BLRView)
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    ToolTip = 'Click to view the associated document or image for this PDC transaction.';

                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin

                        FileURL := Rec."BLRView Document URL";
                        // Check if the file URL is not empty
                        if FileURL = '' then
                            Error('No document is available to view.');

                        // Open the file URL in the browser (new tab)
                        OpenFileInBrowser(FileURL);

                    end;

                }

                group(HideFields)
                {
                    ShowCaption = false;
                    Visible = (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Returned) or (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Retrieved) or (Rec."BLRCheque Status" = Rec."BLRCheque Status"::"Replaced & Received");

                    field("Reason"; Rec."BLRReason")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the reason for the cheque status change. This field is only visible when the cheque status is Returned, Retrieved, or Replaced & Received.';
                    }
                }
            }

            group(NewGroup)
            {
                Caption = 'New Payment Details';
                Visible = (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Returned) or (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Retrieved) or (Rec."BLRCheque Status" = Rec."BLRCheque Status"::"Replaced & Received");
                Editable = not Rec.BLRInserted;

                group(subgroup)
                {
                    ShowCaption = false;
                    field("BLRPaymentMode"; Rec."BLRPayment Mode")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Select the new payment mode for the transaction. This field is only editable when the cheque status is Returned, Retrieved, or Replaced & Received.';
                    }
                    field("Due Date"; Rec."BLRDue Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Select the due date for the new payment. This field is only editable when the cheque status is Returned, Retrieved, or Replaced & Received.';
                    }
                }
                group(subgroup2)
                {
                    ShowCaption = false;
                    group(Bank)
                    {
                        ShowCaption = false;
                        Visible = (Rec."BLRPayment Mode" <> 'Cash') and (Rec."BLRPayment Mode" <> 'Pending') and (Rec."BLRPayment Mode" <> '');

                        field("Deposit Bank"; Rec."BLRDeposit Bank")
                        {
                            Caption = 'Deposit Bank';
                            ApplicationArea = All;
                            ToolTip = 'Enter the name of the bank where the new payment will be deposited. This field is required for payment modes other than Cash and Pending.';
                        }
                    }
                    group(NewChequeDetails)
                    {
                        ShowCaption = false;
                        Visible = (Rec."BLRPayment Mode" = 'Cheque');
                        field("New Cheque Number"; Rec."BLRNew Cheque Number")
                        {
                            Caption = 'Cheque No.';
                            ApplicationArea = All;
                            ToolTip = 'Enter the cheque number for the new payment. This field is required when the payment mode is Cheque.';
                        }
                        field("Upload Cheque"; Rec."BLRUpload Cheque")
                        {
                            ApplicationArea = All;
                            Editable = false;
                            Caption = 'Upload Cheque';
                            ToolTip = 'Upload an image of the cheque for the new payment. This field is required when the payment mode is Cheque. Click to upload the cheque image.';

                            trigger OnDrillDown()
                            var
                                azureBlobUploader: Codeunit "BLRAzure AD Blob Storage";
                                fileName: Text[2048];
                                uploadResult: Text;
                                folderName: Text[2048];
                            begin
                                if Rec."BLRPayment Mode" <> 'Cheque' then
                                    Error('Cheque upload is only allowed when Payment Mode is "Cheque".');


                                folderName := 'PropertyDocuments';
                                fileName := Format(azureBlobUploader.ValidateDocument(uploadResult, folderName));
                                if fileName <> '' then begin
                                    Rec."BLRUpload Cheque" := fileName;
                                    Rec."BLRNew View Document URL" := uploadResult;
                                    Rec.Modify();
                                    Message('File uploaded successfully: %1', fileName);
                                end;
                            end;
                        }
                        field("New View"; Rec."BLRNew View")
                        {
                            Caption = 'View';
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Click to view the uploaded document for the new payment. This field is only enabled when a document has been uploaded for the new payment.';

                            trigger OnDrillDown()
                            var
                                FileURL: Text;
                            begin
                                FileURL := Rec."BLRNew View Document URL";

                                if FileURL = '' then
                                    Error('No document is available to view.');

                                OpenFileInBrowser(FileURL);
                            end;
                        }
                    }
                }
            }

        }
    }

    actions
    {
        area(Processing)
        {


            action(CreatePaymentRecord)
            {
                Caption = 'Create Payment Record';
                Image = New;
                ToolTip = 'Create a new payment record with the updated payment details.';
                ApplicationArea = All;
                Enabled = (not Rec.BLRInserted) and ((Rec."BLRCheque Status" = Rec."BLRCheque Status"::Returned) or (Rec."BLRCheque Status" = Rec."BLRCheque Status"::Retrieved) or (Rec."BLRCheque Status" = Rec."BLRCheque Status"::"Replaced & Received"));

                trigger OnAction()
                var
                    paymentMode: Record "BLRPaymentMode";
                    paymentMode2: Record "BLRPaymentMode2";
                    newPaymentMode2: Record "BLRPaymentMode2";
                    paymentSchedule: Record "BLRPaymentSchedule2";
                    NewPaymentCode: Text[20];
                begin
                    if Rec."BLRPayment Mode" = '' then
                        Error('Payment Mode must be selected to create a new payment record.');

                    if Rec."BLRDue Date" = 0D then
                        Error('Due Date is required to create a new payment record.');

                    case Rec."BLRPayment Mode" of
                        'Cheque':
                            if (Rec."BLRNew Cheque Number" = '-') or (Rec."BLRDeposit Bank" = '') or (Rec."BLRUpload Cheque" = 'Upload Cheque') then
                                Error('Cheque details are incomplete. Please fill Cheque Number, Deposit Bank, and upload the Cheque.');


                        'Bank Transfer', 'Credit Card', 'Mobile Wallet':
                            if Rec."BLRDeposit Bank" = '' then
                                Error('Deposit Bank must be entered for %1 payments.', Rec."BLRPayment Mode");


                    end;

                    paymentMode.SetRange("BLRContract ID", Rec."BLRContract ID");
                    if paymentMode.FindFirst() then begin
                        paymentMode2.SetRange("BLRContract ID", Rec."BLRContract ID");
                        paymentMode2.SetRange("BLRPayment Series", Rec."BLRpayment Series");
                        if paymentMode2.FindFirst() then begin
                            NewPaymentCode := GeneratePaymentCode(GetNextSequenceNo());
                            newPaymentMode2.Init();
                            newPaymentMode2."BLRTenant ID" := Rec."BLRTenant ID";
                            newPaymentMode2."BLRContract ID" := Rec."BLRContract ID";
                            newPaymentMode2."BLRTenant Email" := paymentMode."BLRTenant Email";
                            newPaymentMode2."BLRTenant Name" := paymentMode."BLRTenant Name";
                            newPaymentMode2."BLRPayment Series" := NewPaymentCode;
                            newPaymentMode2."BLRAmount" := paymentMode2."BLRAmount";
                            newPaymentMode2."BLRVAT Amount" := paymentMode2."BLRVAT Amount";
                            newPaymentMode2."BLRAmount Including VAT" := paymentMode2."BLRAmount Including VAT";
                            newPaymentMode2."BLRDue Date" := Rec."BLRDue Date";
                            newPaymentMode2."BLRPayment Status" := newPaymentMode2."BLRPayment Status"::Scheduled;
                            newPaymentMode2."BLRPayment Reminder" := paymentMode."BLRPayment Reminder";
                            newPaymentMode2."BLRPayment Mode" := Rec."BLRPayment Mode";
                            newPaymentMode2."BLRDeposit Bank" := Rec."BLRDeposit Bank";
                            newPaymentMode2."BLRCheque Number" := Rec."BLRNew Cheque Number";
                            newPaymentMode2."BLRUpload Cheque" := Rec."BLRUpload Cheque";
                            newPaymentMode2."BLRView Document URL" := Rec."BLRNew View Document URL";
                            newPaymentMode2."BLRInvoice #" := paymentMode2."BLRInvoice #";
                            newPaymentMode2.Insert();

                            Rec.BLRInserted := true;
                            Rec.Modify();

                            paymentMode2."BLRPayment Status" := paymentMode2."BLRPayment Status"::Cancelled;
                            paymentMode2.Modify(true);

                            paymentSchedule.SetRange("BLRContract ID", Rec."BLRContract ID");
                            paymentSchedule.SetRange("BLRPayment Series", Rec."BLRpayment Series");
                            if paymentSchedule.FindSet() then begin
                                paymentSchedule.ModifyAll("BLRDue Date", newPaymentMode2."BLRDue Date");
                                paymentSchedule.ModifyAll("BLRPayment Series", NewPaymentCode);
                            end;
                        end;
                    end;
                end;
            }
        }

        area(Promoted)
        {

            actionref(CreatePaymentRecord_; CreatePaymentRecord)
            { }
        }
    }

    var
        IsLeaseManager: Boolean;
        IsFieldEditable: Boolean;
        IsFinanceManager: Boolean;

    trigger OnAfterGetRecord()
    begin
        IsFieldEditable := (Rec."BLRApproval Status" <> Rec."BLRApproval Status"::Approved);
    end;

    trigger OnOpenPage()
    var
        PermissionSet: Record "User Personalization";
    begin
        // Check if the current user has the 'LEASE MANAGER' permission set
        IsFinanceManager := false;
        PermissionSet.SetRange("User ID", UserId());
        // PermissionSet.SetRange("Profile ID", 'LEASE MANAGER');
        if PermissionSet.FindFirst() then
            if PermissionSet."Profile ID" = 'LEASE MANAGER' then
                IsLeaseManager := true

            else
                if PermissionSet."Profile ID" = 'FINANCE MANAGER' then
                    IsFinanceManager := true;

    end;

    procedure OpenFileInBrowser(URL: Text)
    begin
        // Use the Hyperlink method to open the file in the browser
        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;

    procedure GetNextSequenceNo(): Integer
    var
        paymentMode2: Record "BLRPaymentMode2";
        MaxSequence: Integer;
        LastSequence: Text[10];
    begin
        PaymentMode2.Reset();
        PaymentMode2.SetRange("BLRContract ID", Rec."BLRContract ID");
        if PaymentMode2.FindSet() then
            repeat
                // Extract the numeric part of the Payment Series
                LastSequence := CopyStr(PaymentMode2."BLRPayment Series", 4, StrLen(PaymentMode2."BLRPayment Series"));
                if Evaluate(MaxSequence, LastSequence) and (MaxSequence > MaxSequence) then
                    MaxSequence := MaxSequence;
            until PaymentMode2.Next() = 0
        else
            MaxSequence := 0; // Default to 0 if no records are found

        exit(MaxSequence + 1);
    end;

    procedure GeneratePaymentCode(SequenceNumber: Integer): Code[20]
    var
        PaymentCodeText: Text;
    begin
        PaymentCodeText := 'PAY' + PadStr(Format(SequenceNumber), 2, '0');
        exit(CopyStr(PaymentCodeText, 1, 20));
    end;

    local procedure PadStr(Input: Text[20]; Length: Integer; PaddingChar: Char): Text[20]
    begin
        while StrLen(Input) < Length do
            Input := PaddingChar + Input;
        exit(Input);
    end;

}