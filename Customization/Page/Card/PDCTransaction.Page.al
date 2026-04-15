page 50509 "PDC Transaction"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "PDC Transaction";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                Caption = 'General Information';
                field("PDC ID"; Rec."PDC ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the PDC transaction. This field is auto-generated and cannot be edited.';
                }

                field("payment Series"; Rec."payment Series")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the payment series associated with this PDC transaction. This field is auto-generated and cannot be edited.';
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the contract associated with this PDC transaction. This field is auto-generated and cannot be edited.';
                }
                field("Tenant Name"; Rec."Tenant Id")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the tenant associated with this PDC transaction. This field is auto-populated based on the Contract ID and cannot be edited.';
                }
                field("Tenant"; Rec."Tenant Name Display")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the tenant associated with this PDC transaction. This field is auto-populated based on the Contract ID and cannot be edited.';

                }
                field("Cheque Number"; Rec."Cheque Number")
                {
                    ApplicationArea = All;
                    Editable = IsFieldEditable;
                    ToolTip = 'Specifies the cheque number for this PDC transaction. This field is editable when the cheque status allows for changes.';
                    trigger OnValidate()
                    var
                        PaymentSeriesRec: Record "Payment Mode2";
                    begin
                        PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                        PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                        if PaymentSeriesRec.FindSet() then begin
                            PaymentSeriesRec."Cheque Number" := Rec."Cheque Number";
                            PaymentSeriesRec.Modify();
                        end;
                    end;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the bank associated with this PDC transaction. This field is editable when the cheque status allows for changes.';
                    Editable = IsFieldEditable;
                    trigger OnValidate()
                    var
                        PaymentSeriesRec: Record "Payment Mode2";
                    begin
                        PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                        PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                        if PaymentSeriesRec.FindSet() then begin
                            PaymentSeriesRec."Deposit Bank" := Rec."Bank Name";
                            PaymentSeriesRec.Modify();
                        end;
                    end;
                }

                field("Cheque Date"; Rec."Cheque Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date on the cheque for this PDC transaction. This field is editable when the cheque status allows for changes.';
                    Editable = false;

                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = IsFieldEditable;
                    ToolTip = 'Specifies the amount for this PDC transaction. This field is editable when the cheque status allows for changes.';

                }
                field("Old Cheque#"; Rec."Old Cheque#")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the old cheque number for this PDC transaction. This field is auto-populated when the cheque status is changed to Returned, Retrieved, or Replaced & Received, and cannot be edited.';
                }
                field(Status; Rec."Cheque Status")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                    ToolTip = 'Specifies the current status of the cheque for this PDC transaction. Changing the status will trigger specific actions based on the new status value.';
                    trigger OnValidate()
                    var
                        PaymentSeriesRec: Record "Payment Mode2";
                        CashReceiptJournalCodeunit: Codeunit "Cash Receipt Journal Entry";
                        selectDate: Page "Select Date";
                    begin
                        if (xRec."Cheque Status" = xRec."Cheque Status"::Retrieved) then
                            if (Rec."Cheque Status" = Rec."Cheque Status"::Cleared) OR (Rec."Cheque Status" = Rec."Cheque Status"::Deposited) OR (Rec."Cheque Status" = Rec."Cheque Status"::Returned) OR (Rec."Cheque Status" = Rec."Cheque Status"::Deferred) then
                                Error('Cannot change Retrived status to %1', Rec."Cheque Status");


                        if (xRec."Cheque Status" = xRec."Cheque Status"::Returned) then
                            if (Rec."Cheque Status" = Rec."Cheque Status"::Cleared) OR (Rec."Cheque Status" = Rec."Cheque Status"::Deposited) OR (Rec."Cheque Status" = Rec."Cheque Status"::Retrieved) OR (Rec."Cheque Status" = Rec."Cheque Status"::Deferred) then
                                Error('Cannot change Returned status to %1', Rec."Cheque Status");



                        if (xRec."Cheque Status" = xRec."Cheque Status"::Deferred) then
                            if (Rec."Cheque Status" = Rec."Cheque Status"::Cleared) OR (Rec."Cheque Status" = Rec."Cheque Status"::Retrieved) OR (Rec."Cheque Status" = Rec."Cheque Status"::Returned) OR (Rec."Cheque Status" = Rec."Cheque Status"::"Replaced & Received") then
                                Error('Cannot change Deferred status to %1', Rec."Cheque Status");

                        // if (xRec."Cheque Status" = xRec."Cheque Status"::Returned) and (Rec."Cheque Status" = Rec."Cheque Status"::Cleared) OR (Rec."Cheque Status" = Rec."Cheque Status"::Deposited) OR (Rec."Cheque Status" = Rec."Cheque Status"::Retrieved) OR (Rec."Cheque Status" = Rec."Cheque Status"::Deferred) then
                        //     Error('Cannot change Returned status to %1', Rec."Cheque Status");
                        // if (xRec."Cheque Status" = xRec."Cheque Status"::Deferred) and (Rec."Cheque Status" = Rec."Cheque Status"::Cleared) OR (Rec."Cheque Status" = Rec."Cheque Status"::Retrieved) OR (Rec."Cheque Status" = Rec."Cheque Status"::Returned) OR (Rec."Cheque Status" = Rec."Cheque Status"::"Replaced & Received") then
                        //     Error('Cannot change Deferred status to %1', Rec."Cheque Status");

                        // if (xRec."Cheque Status" = xRec."Cheque Status"::Cancelled) and (Rec."Cheque Status" = Rec."Cheque Status"::Cleared) OR (Rec."Cheque Status" = Rec."Cheque Status"::Deposited) OR (Rec."Cheque Status" = Rec."Cheque Status"::Returned) OR (Rec."Cheque Status" = Rec."Cheque Status"::Deferred) OR (Rec."Cheque Status" = Rec."Cheque Status"::"Replaced & Received") OR (Rec."Cheque Status" = Rec."Cheque Status"::Retrieved) OR (Rec."Cheque Status" = Rec."Cheque Status"::"Cheque Received") then
                        //     Error('Cannot change Cancelled status to %1', Rec."Cheque Status");


                        if (xRec."Cheque Status" = xRec."Cheque Status"::Cleared) then
                            Error('Cannot change Cleared status to %1', Rec."Cheque Status");

                        if (xRec."Cheque Status" = xRec."Cheque Status"::Cancelled) then
                            Error('Cannot change Cancelled status to %1', Rec."Cheque Status");

                        if (Rec."Cheque Status" <> Rec."Cheque Status"::Cleared) AND (Rec."Cheque Status" <> Rec."Cheque Status"::" ") AND (Rec."Cheque Status" <> Rec."Cheque Status"::Cancelled) then begin
                            Commit();
                            selectDate.Caption := 'Select Transaction Date';
                            if selectDate.RunModal() = Action::OK then
                                Rec."Transaction Date" := selectDate.GetDate()
                            else
                                Error('Transaction Date selection is mandatory to proceed.');
                        end;

                        // Check if the Cheque Status is set to 'Cleared'
                        case Rec."Cheque Status" of
                            Rec."Cheque Status"::Cleared:
                                begin
                                    PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                                    PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                                    if PaymentSeriesRec.FindSet() then begin
                                        PaymentSeriesRec.Validate("Payment Status", PaymentSeriesRec."Payment Status"::Received);
                                        PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::Cleared;
                                        PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::Y;
                                        PaymentSeriesRec.Modify();
                                    end else
                                        Error('The related Payment Series record was not found.');
                                end;
                            Rec."Cheque Status"::Deposited:
                                begin
                                    CashReceiptJournalCodeunit.PDCDepositedTransaction(Rec);
                                    PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                                    PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                                    if PaymentSeriesRec.FindSet() then begin
                                        PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::Deposited;
                                        PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Due;
                                        PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::Y;
                                        PaymentSeriesRec.Modify();
                                    end else
                                        Error('The related Payment Series record was not found.');
                                end;
                            Rec."Cheque Status"::"Cheque Received":
                                begin
                                    CashReceiptJournalCodeunit.PDCReceivedTransaction(Rec);
                                    PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                                    PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                                    if PaymentSeriesRec.FindSet() then begin
                                        PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::"Cheque Received";
                                        PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Scheduled;
                                        PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::"-";
                                        PaymentSeriesRec.Modify();
                                    end else
                                        Error('The related Payment Series record was not found.');
                                end;
                            Rec."Cheque Status"::"Due cheque not deposited":
                                begin
                                    PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                                    PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                                    if PaymentSeriesRec.FindSet() then begin
                                        PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::"Due cheque not deposited";
                                        PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Scheduled;
                                        PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::"-";
                                        PaymentSeriesRec.Modify();
                                    end else
                                        Error('The related Payment Series record was not found.');
                                end;
                            Rec."Cheque Status"::"Replaced & Received":
                                begin
                                    PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                                    PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                                    if PaymentSeriesRec.FindSet() then begin
                                        PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::"Replaced & Received";
                                        PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Scheduled;
                                        PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::"-";
                                        PaymentSeriesRec."Old Cheque #" := PaymentSeriesRec."Cheque Number";
                                        PaymentSeriesRec."Cheque Number" := '';
                                        PaymentSeriesRec.Modify();
                                        Rec."Old Cheque#" := Rec."Cheque Number";
                                        Rec."Cheque Number" := '';
                                        Rec.Modify();
                                    end else
                                        Error('The related Payment Series record was not found.');
                                end;
                            Rec."Cheque Status"::Retrieved:
                                begin
                                    CashReceiptJournalCodeunit.PDCRetrivedTransaction(Rec);
                                    PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                                    PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                                    if PaymentSeriesRec.FindSet() then begin
                                        PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::Retrieved;
                                        PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Cancelled;
                                        PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::"-";
                                        PaymentSeriesRec."Old Cheque #" := PaymentSeriesRec."Cheque Number";
                                        PaymentSeriesRec."Cheque Number" := '';
                                        PaymentSeriesRec.Modify();
                                        Rec."Old Cheque#" := Rec."Cheque Number";
                                        Rec."Cheque Number" := '';
                                        Rec.Modify();
                                    end else
                                        Error('The related Payment Series record was not found.');
                                end;
                            Rec."Cheque Status"::Returned:
                                begin
                                    CashReceiptJournalCodeunit.PDCReturnedTransaction(Rec);
                                    PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                                    PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                                    if PaymentSeriesRec.FindSet() then begin
                                        PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::Returned;
                                        PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Cancelled;
                                        PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::"-";
                                        PaymentSeriesRec.Modify();
                                    end else
                                        Error('The related Payment Series record was not found.');
                                end;
                            Rec."Cheque Status"::Cancelled:
                                begin
                                    PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                                    PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                                    if PaymentSeriesRec.FindSet() then begin
                                        PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::Cancelled;
                                        PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Cancelled;
                                        PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::"-";
                                        PaymentSeriesRec.Modify();
                                    end else
                                        Error('The related Payment Series record was not found.');
                                end;
                        end;

                    end;


                }

                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = true;
                    ToolTip = 'Indicates the approval status of the PDC transaction. This field is for informational purposes and cannot be edited.';
                }

                field(View; Rec.View)
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    ToolTip = 'Click to view the associated document or image for this PDC transaction.';

                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin

                        FileURL := Rec."View Document URL";
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
                    Visible = (Rec."Cheque Status" = Rec."Cheque Status"::Returned) or (Rec."Cheque Status" = Rec."Cheque Status"::Retrieved) or (Rec."Cheque Status" = Rec."Cheque Status"::"Replaced & Received");

                    field("Reason"; Rec."Reason")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the reason for the cheque status change. This field is only visible when the cheque status is Returned, Retrieved, or Replaced & Received.';
                    }
                }
            }

            group(NewGroup)
            {
                Caption = 'New Payment Details';
                Visible = (Rec."Cheque Status" = Rec."Cheque Status"::Returned) or (Rec."Cheque Status" = Rec."Cheque Status"::Retrieved) or (Rec."Cheque Status" = Rec."Cheque Status"::"Replaced & Received");
                Editable = not Rec.Inserted;

                group(subgroup)
                {
                    ShowCaption = false;
                    field("Payment Mode"; Rec."Payment Mode")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Select the new payment mode for the transaction. This field is only editable when the cheque status is Returned, Retrieved, or Replaced & Received.';
                    }
                    field("Due Date"; Rec."Due Date")
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
                        Visible = (Rec."Payment Mode" <> 'Cash') and (Rec."Payment Mode" <> 'Pending') and (Rec."Payment Mode" <> '');

                        field("Deposit Bank"; Rec."Deposit Bank")
                        {
                            Caption = 'Deposit Bank';
                            ApplicationArea = All;
                            ToolTip = 'Enter the name of the bank where the new payment will be deposited. This field is required for payment modes other than Cash and Pending.';
                        }
                    }
                    group(NewChequeDetails)
                    {
                        ShowCaption = false;
                        Visible = (Rec."Payment Mode" = 'Cheque');
                        field("New Cheque Number"; Rec."New Cheque Number")
                        {
                            Caption = 'Cheque No.';
                            ApplicationArea = All;
                            ToolTip = 'Enter the cheque number for the new payment. This field is required when the payment mode is Cheque.';
                        }
                        field("Upload Cheque"; Rec."Upload Cheque")
                        {
                            ApplicationArea = All;
                            Editable = false;
                            Caption = 'Upload Cheque';
                            ToolTip = 'Upload an image of the cheque for the new payment. This field is required when the payment mode is Cheque. Click to upload the cheque image.';

                            trigger OnDrillDown()
                            var
                                azureBlobUploader: Codeunit "Azure AD Blob Storage";
                                fileName: Text[2048];
                                uploadResult: Text;
                                folderName: Text[2048];
                            begin
                                if Rec."Payment Mode" <> 'Cheque' then
                                    Error('Cheque upload is only allowed when Payment Mode is "Cheque".');


                                folderName := 'PropertyDocuments';
                                fileName := Format(azureBlobUploader.ValidateDocument(uploadResult, folderName));
                                if fileName <> '' then begin
                                    Rec."Upload Cheque" := fileName;
                                    Rec."New View Document URL" := uploadResult;
                                    Rec.Modify();
                                    Message('File uploaded successfully: %1', fileName);
                                end;
                            end;
                        }
                        field("New View"; Rec."New View")
                        {
                            Caption = 'View';
                            ApplicationArea = All;
                            Editable = false;
                            ToolTip = 'Click to view the uploaded document for the new payment. This field is only enabled when a document has been uploaded for the new payment.';

                            trigger OnDrillDown()
                            var
                                FileURL: Text;
                            begin
                                FileURL := Rec."New View Document URL";

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
                Enabled = (not Rec.Inserted) and ((Rec."Cheque Status" = Rec."Cheque Status"::Returned) or (Rec."Cheque Status" = Rec."Cheque Status"::Retrieved) or (Rec."Cheque Status" = Rec."Cheque Status"::"Replaced & Received"));

                trigger OnAction()
                var
                    paymentMode: Record "Payment Mode";
                    paymentMode2: Record "Payment Mode2";
                    newPaymentMode2: Record "Payment Mode2";
                    paymentSchedule: Record "Payment Schedule2";
                    NewPaymentCode: Text[20];
                begin
                    if Rec."Payment Mode" = '' then
                        Error('Payment Mode must be selected to create a new payment record.');

                    if Rec."Due Date" = 0D then
                        Error('Due Date is required to create a new payment record.');

                    case Rec."Payment Mode" of
                        'Cheque':
                            if (Rec."New Cheque Number" = '-') or (Rec."Deposit Bank" = '') or (Rec."Upload Cheque" = 'Upload Cheque') then
                                Error('Cheque details are incomplete. Please fill Cheque Number, Deposit Bank, and upload the Cheque.');


                        'Bank Transfer', 'Credit Card', 'Mobile Wallet':
                            if Rec."Deposit Bank" = '' then
                                Error('Deposit Bank must be entered for %1 payments.', Rec."Payment Mode");


                    end;

                    paymentMode.SetRange("Contract ID", Rec."Contract ID");
                    if paymentMode.FindFirst() then begin
                        paymentMode2.SetRange("Contract ID", Rec."Contract ID");
                        paymentMode2.SetRange("Payment Series", Rec."payment Series");
                        if paymentMode2.FindFirst() then begin
                            NewPaymentCode := GeneratePaymentCode(GetNextSequenceNo());
                            newPaymentMode2.Init();
                            newPaymentMode2."Tenant ID" := Rec."Tenant ID";
                            newPaymentMode2."Contract ID" := Rec."Contract ID";
                            newPaymentMode2."Tenant Email" := paymentMode."Tenant Email";
                            newPaymentMode2."Tenant Name" := paymentMode."Tenant Name";
                            newPaymentMode2."Payment Series" := NewPaymentCode;
                            newPaymentMode2."Amount" := paymentMode2.Amount;
                            newPaymentMode2."VAT Amount" := paymentMode2."VAT Amount";
                            newPaymentMode2."Amount Including VAT" := paymentMode2."Amount Including VAT";
                            newPaymentMode2."Due Date" := Rec."Due Date";
                            newPaymentMode2."Payment Status" := newPaymentMode2."Payment Status"::Scheduled;
                            newPaymentMode2."Payment Reminder" := paymentMode."Payment Reminder";
                            newPaymentMode2."Payment Mode" := Rec."Payment Mode";
                            newPaymentMode2."Deposit Bank" := Rec."Deposit Bank";
                            newPaymentMode2."Cheque Number" := Rec."New Cheque Number";
                            newPaymentMode2."Upload Cheque" := Rec."Upload Cheque";
                            newPaymentMode2."View Document URL" := Rec."New View Document URL";
                            newPaymentMode2."Invoice #" := paymentMode2."Invoice #";
                            newPaymentMode2.Insert();

                            Rec.Inserted := true;
                            Rec.Modify();

                            paymentMode2."Payment Status" := paymentMode2."Payment Status"::Cancelled;
                            paymentMode2.Modify(true);

                            paymentSchedule.SetRange("Contract ID", Rec."Contract ID");
                            paymentSchedule.SetRange("Payment Series", Rec."payment Series");
                            if paymentSchedule.FindSet() then begin
                                paymentSchedule.ModifyAll("Due Date", newPaymentMode2."Due Date");
                                paymentSchedule.ModifyAll("Payment Series", NewPaymentCode);
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
        IsFieldEditable := (Rec."Approval Status" <> Rec."Approval Status"::Approved);
    end;

    trigger OnOpenPage()
    var
        PermissionSet: Record "User Personalization";
    begin
        // Check if the current user has the 'LEASE_MANAGER' permission set
        IsFinanceManager := false;
        PermissionSet.SetRange("User ID", UserId());
        // PermissionSet.SetRange("Profile ID", 'LEASE_MANAGER');
        if not PermissionSet.IsEmpty() then
            if PermissionSet."Profile ID" = 'LEASE_MANAGER' then
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
        paymentMode2: Record "Payment Mode2";
        MaxSequence: Integer;
        LastSequence: Text[10];
    begin
        PaymentMode2.Reset();
        PaymentMode2.SetRange("Contract ID", Rec."Contract ID");
        if PaymentMode2.FindSet() then
            repeat
                // Extract the numeric part of the Payment Series
                LastSequence := CopyStr(PaymentMode2."Payment Series", 4, StrLen(PaymentMode2."Payment Series"));
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