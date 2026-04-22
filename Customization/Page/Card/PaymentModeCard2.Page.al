page 73209706 "Payment Mode Card2"
{
    PageType = ListPart;
    SourceTable = "Payment Mode2";
    ApplicationArea = All;
    Caption = 'Payment Details';
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Payment Series"; Rec."Payment Series")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The Payment Series is a unique identifier for the payment mode.';
                }

                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The Amount is the total amount for the payment mode.';
                }


                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The VAT Amount is the value-added tax applied to the payment mode.';
                }


                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Editable = IsApproved and false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The Amount Including VAT is the total amount after adding VAT.';
                }

                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Editable = IsApproved and false;  // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The Due Date is the date by which the payment should be made.';
                }

                field("Payment Mode"; Rec."Payment Mode")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = IsApproved AND (Rec."Payment Status" <> Rec."Payment Status"::Cancelled); // Makes the field editable unless Payment Status is "Cancelled"
                    ToolTip = 'The Payment Mode indicates the method of payment, such as Cash, Cheque, or Bank Transfer.';
                }

                field("Cheque Number"; Rec."Cheque Number")
                {
                    ApplicationArea = All;
                    Editable = IsApproved AND (Rec."Payment Mode" = 'Cheque') AND (Rec."Payment Status" <> Rec."Payment Status"::Cancelled);  // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The Cheque Number is the unique identifier for the cheque payment.';
                }

                field("Deposit Bank"; Rec."Deposit Bank")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    ToolTip = 'The Deposit Bank indicates the bank where the payment is being made.';
                }

                field("Deposit Status"; Rec."Deposit Status")
                {
                    ApplicationArea = All;
                    Editable = not IsReceivedCancelled;

                    ToolTip = 'The Deposit Status indicates the status of the deposit.';
                }

                field("Payment Status"; Rec."Payment Status")
                {
                    ApplicationArea = All;
                    Editable = (IsApproved or not IsReceivedCancelled) and not (Rec."Payment Mode" = 'Cheque');
                    ToolTip = 'The Payment Status indicates the status of the payment, such as Scheduled, Due, Received, or Cancelled.';

                    trigger OnValidate()
                    var
                        PDCTransRec: Record "PDC Transaction";
                    begin
                        if (Rec."Payment Status" = Rec."Payment Status"::Cancelled) or
                          (Rec."Payment Status" = Rec."Payment Status"::Received) then
                            IsReceivedCancelled := true
                        else
                            IsReceivedCancelled := false;

                        PDCTransRec.SetRange("Contract ID", Rec."Contract ID");
                        PDCTransRec.SetRange("payment Series", Rec."Payment Series");
                        if PDCTransRec.FindFirst() then
                            if PDCTransRec."Cheque Status" <> PDCTransRec."Cheque Status"::Cleared then begin
                                PDCTransRec."Cheque Status" := Rec."Cheque Status"::Cleared;
                                PDCTransRec.Modify();
                            end;
                    end;
                }
                field("Cheque Status"; Rec."Cheque Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The Cheque Status indicates the status of the cheque payment, such as Cheque Received or Cheque Cleared.';
                    trigger OnValidate()
                    var
                        PDCTransRec: Record "PDC Transaction";
                        CashReceiptJournalCodeunit: Codeunit "Cash Receipt Journal Entry";
                        selectDate: Page "Select Date";
                    begin
                        if Rec."Approval Status" <> Rec."Approval Status"::Approved then
                            Error('Approval Status must be Approved to update Cheque Status.');

                        PDCTransRec.SetRange("Payment Series", Rec."payment Series");
                        PDCTransRec.SetRange("Contract ID", Rec."Contract ID");
                        if PDCTransRec.FindFirst() then begin
                            if (Rec."Cheque Status" <> Rec."Cheque Status"::" ") AND (Rec."Cheque Status" <> Rec."Cheque Status"::Cleared) then begin
                                Commit();
                                selectDate.Caption := 'Select Transaction Date';
                                if selectDate.RunModal() = Action::OK then begin
                                    PDCTransRec."Transaction Date" := selectDate.GetDate();
                                    PDCTransRec.Modify();
                                end
                                else
                                    Error('Transaction Date selection is mandatory to proceed.');
                            end;
                            case Rec."Cheque Status" of
                                Rec."Cheque Status"::"Cheque Received":
                                    begin
                                        CashReceiptJournalCodeunit.PDCReceivedTransaction(PDCTransRec);
                                        PDCTransRec."Cheque Status" := PDCTransRec."Cheque Status"::"Cheque Received";
                                        PDCTransRec.Modify();
                                        Rec."Payment Status" := Rec."Payment Status"::Scheduled;
                                        Rec."Deposit Status" := Rec."Deposit Status"::"-";
                                        Rec.Modify();
                                    end;
                                Rec."Cheque Status"::Cleared:
                                    begin
                                        Rec.Validate("Payment Status", Rec."Payment Status"::Received);
                                        PDCTransRec."Cheque Status" := PDCTransRec."Cheque Status"::Cleared;
                                        PDCTransRec.Modify();
                                        Rec.Modify();
                                    end;
                                Rec."Cheque Status"::Deposited:
                                    begin
                                        CashReceiptJournalCodeunit.PDCDepositedTransaction(PDCTransRec);
                                        PDCTransRec."Cheque Status" := PDCTransRec."Cheque Status"::Deposited;
                                        PDCTransRec.Modify();
                                        Rec."Payment Status" := Rec."Payment Status"::Due;
                                        Rec."Deposit Status" := Rec."Deposit Status"::Y;
                                        Rec.Modify();
                                    end;
                                Rec."Cheque Status"::"Due cheque not deposited":
                                    begin
                                        PDCTransRec."Cheque Status" := PDCTransRec."Cheque Status"::"Due cheque not deposited";
                                        PDCTransRec.Modify();
                                        Rec."Payment Status" := Rec."Payment Status"::Scheduled;
                                        Rec."Deposit Status" := Rec."Deposit Status"::"-";
                                        Rec.Modify();
                                    end;
                                Rec."Cheque Status"::"Replaced & Received":
                                    begin
                                        PDCTransRec."Cheque Status" := PDCTransRec."Cheque Status"::"Replaced & Received";
                                        PDCTransRec."Old Cheque#" := PDCTransRec."Cheque Number";
                                        PDCTransRec."Cheque Number" := '';
                                        PDCTransRec.Modify();
                                        Rec."Payment Status" := Rec."Payment Status"::Scheduled;
                                        Rec."Deposit Status" := Rec."Deposit Status"::"-";
                                        Rec."Old Cheque #" := Rec."Cheque Number";
                                        Rec."Cheque Number" := '-';
                                        Rec.Modify();
                                    end;
                                Rec."Cheque Status"::Retrieved:
                                    begin
                                        CashReceiptJournalCodeunit.PDCRetrivedTransaction(PDCTransRec);
                                        PDCTransRec."Cheque Status" := PDCTransRec."Cheque Status"::Retrieved;
                                        PDCTransRec."Old Cheque#" := PDCTransRec."Cheque Number";
                                        PDCTransRec."Cheque Number" := '';
                                        PDCTransRec.Modify();
                                        Rec."Payment Status" := Rec."Payment Status"::Cancelled;
                                        Rec."Deposit Status" := Rec."Deposit Status"::"-";
                                        Rec."Old Cheque #" := Rec."Cheque Number";
                                        Rec."Cheque Number" := '-';
                                        Rec.Modify();
                                    end;
                                Rec."Cheque Status"::Returned:
                                    begin
                                        CashReceiptJournalCodeunit.PDCReturnedTransaction(PDCTransRec);
                                        PDCTransRec."Cheque Status" := PDCTransRec."Cheque Status"::Returned;
                                        PDCTransRec.Modify();
                                        Rec."Payment Status" := Rec."Payment Status"::Cancelled;
                                        Rec."Deposit Status" := Rec."Deposit Status"::"-";
                                        Rec.Modify();
                                    end;
                                Rec."Cheque Status"::Cancelled:

                                    if Rec."Cheque Status" = Rec."Cheque Status"::Cancelled then begin

                                        PDCTransRec."Cheque Status" := PDCTransRec."Cheque Status"::Cancelled;
                                        PDCTransRec.Modify();
                                    end;


                            end;
                        end else
                            Error('The related Payment Series record was not found.');
                    end;
                }

                field("Invoice #"; Rec."Invoice #")
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = Rec."Receipt #" <> '-';
                    ToolTip = 'The Invoice # is the unique identifier for the invoice associated with the payment.';
                    trigger OnDrillDown()
                    var
                        SalesHeader: Record "Sales Header";
                        postedsalesinvoice: Record "Sales Invoice Header";
                    begin
                        if SalesHeader.Get(Enum::"Sales Document Type"::Invoice, Rec."Invoice #") then
                            PAGE.Run(PAGE::"Sales Invoice", SalesHeader)
                        else
                            if postedsalesinvoice.Get(Rec."Invoice #") then
                                PAGE.Run(PAGE::"Posted Sales Invoice", postedsalesinvoice);

                    end;
                }

                field("Receipt #"; Rec."Receipt #")
                {
                    ApplicationArea = All;
                    Editable = IsApproved AND (Rec."Payment Status" <> Rec."Payment Status"::Cancelled); // Makes the field editable unless Payment Status is "Cancelled"
                    ToolTip = 'The Receipt # is the unique identifier for the receipt associated with the payment.';
                }
                field("Receipt Date"; Rec."Receipt Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The Receipt Date indicates the date when the receipt was issued.';
                }

                field("Old Cheque #"; Rec."Old Cheque #")
                {
                    ApplicationArea = All;
                    Editable = IsApproved AND (Rec."Payment Mode" = 'Cheque') and (Rec."Payment Status" <> Rec."Payment Status"::Cancelled);
                    ToolTip = 'The Old Cheque # is the previous cheque number if the payment mode was changed from Cheque to another mode.';

                    trigger OnValidate()
                    begin
                        if Rec."Payment Mode" <> 'Cheque' then
                            Error('Cheque number can only be entered when Payment Mode is set to Cheque.');
                    end;

                }

                field("Upload Cheque"; Rec."Upload Cheque")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    Editable = false;
                    ToolTip = 'The Upload Cheque field allows you to upload a cheque document for the payment mode.';

                    trigger OnDrillDown()
                    var
                        azureBlobUploader: Codeunit "Azure AD Blob Storage";
                        fileName: Text;
                        uploadResult: Text;
                        folderName: Text;
                    begin

                        if Rec."Payment Status" = Rec."Payment Status"::Cancelled then begin
                            Message('Upload Cheque cannot be accessed because Payment Status is Cancelled');
                            exit; // Stop execution here
                        end;
                        // Check if the Payment Mode is 'Cheque'
                        if Rec."Payment Mode" <> 'Cheque' then
                            Error('Cheque upload is only allowed when Payment Mode is "Cheque".');

                        folderName := 'PropertyDocuments';
                        fileName := azureBlobUploader.ValidateDocument(uploadResult, folderName);
                        if fileName <> '' then begin
                            Rec."Upload Cheque" := CopyStr(fileName, 1, StrLen(fileName));
                            Rec."View Document URL" := CopyStr(uploadResult, 1, StrLen(uploadResult));
                            Rec.Modify();
                            Message('File uploaded successfully: %1', fileName);
                        end;
                    end;
                }

                field("View"; Rec."View")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    ToolTip = 'The View field allows you to view the uploaded cheque document.';

                    trigger OnValidate()
                    begin
                        if Rec."Payment Mode" <> 'Cheque' then
                            Error('Cheque number can only be entered when Payment Mode is set to Cheque.');
                    end;

                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin

                        if Rec."Payment Status" = Rec."Payment Status"::Cancelled then begin
                            Message('View cannot be accessed because Payment Status is Cancelled');
                            exit; // Stop execution here
                        end;
                        // Check if the Payment Mode is 'Cheque'
                        if Rec."Payment Mode" <> 'Cheque' then
                            Error('Cheque upload is only allowed when Payment Mode is "Cheque".');

                        // Get the URL of the uploaded document
                        FileURL := Rec."View Document URL";

                        // Check if the file URL is not empty
                        if FileURL = '' then
                            Error('No document is available to view.');

                        // Open the file URL in the browser (new tab)
                        OpenFileInBrowser(FileURL);

                    end;
                }

                field("View Revenue Details"; Rec."View Revenue Details")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    ToolTip = 'The View Revenue Details field allows you to view the revenue details associated with the payment mode.';

                    trigger OnDrillDown()
                    var

                        PaymentScheduleRec: Record "Payment Schedule2";
                        FilteredSchedulePage: Page "Payment Schedule Card2"; // Replace with your actual page name
                    begin
                        if Rec."Payment Status" = Rec."Payment Status"::Cancelled then begin
                            Message('View Revenue Details cannot be accessed because Payment Status is Cancelled');
                            exit; // Stop execution here
                        end;
                        PaymentScheduleRec.SetRange("Contract ID", Rec."Contract ID");
                        // PaymentScheduleRec.SetRange("Proposal ID", Rec."Proposal ID");
                        PaymentScheduleRec.SetRange("Tenant ID", Rec."Tenant ID");
                        PaymentScheduleRec.SetRange("Due Date", Rec."Due Date");
                        PaymentScheduleRec.SetRange("Payment Series", Rec."Payment Series");

                        // Hide other data and show the filtered records
                        if PaymentScheduleRec.FindFirst() then
                            FilteredSchedulePage.SetTableView(PaymentScheduleRec);

                        // Open the filtered page
                        PAGE.Run(PAGE::"Payment Schedule Card2", PaymentScheduleRec);

                    end;

                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Visible = false;
                    ToolTip = 'The Tenant ID is the unique identifier for the tenant associated with the payment mode.';
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;// The ID is not editable since it's auto-incrementing
                    Visible = false;
                    ToolTip = 'The Contract ID is the unique identifier for the contract associated with the payment mode.';
                }

                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                    Editable = false;// The ID is not editable since it's auto-incrementing
                    Visible = false;
                    ToolTip = 'The ID is the unique identifier for the payment mode.';
                }

                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    Editable = IsApproved AND IsFinanceManager;
                    ToolTip = 'The Approval Status indicates the approval status of the payment mode, such as Approved, Pending, or Declined.';

                    trigger OnValidate()
                    begin
                        case Rec."Payment Mode" of
                            'Cheque':
                                if (Rec."Cheque Number" = '-') or (Rec."Deposit Bank" = '') or (Rec."Upload Cheque" = 'Upload Cheque') then
                                    Error('Cheque details are incomplete. Please fill Cheque Number, Deposit Bank, and upload the Cheque.');

                            'Bank Transfer', 'Credit Card', 'Mobile Wallet':
                                if Rec."Deposit Bank" = '' then
                                    Error('Deposit Bank must be entered for %1 payments.', Rec."Payment Mode");
                        end;
                    end;
                }
                field(Reason; Rec.Reason)
                {
                    ApplicationArea = All;
                    Editable = IsApproved;
                    ToolTip = 'The Reason field allows you to provide a reason for the approval or decline of the payment mode.';
                }
                field(IsUpdated; Rec.IsUpdated)
                {
                    ApplicationArea = All;
                    Editable = IsApproved;
                    Visible = false;
                    ToolTip = 'The IsUpdated field indicates whether the payment mode has been updated.';
                }
                field("Approve/Decline Status"; Rec."Approve/Decline Status")
                {
                    ApplicationArea = All;
                    Editable = IsApproved;
                    Visible = false;
                    ToolTip = 'The Approve/Decline Status indicates the status of the approval or decline action for the payment mode.';
                }

                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'The Tenant Name is the name of the tenant associated with the payment mode.';
                }

                field("Tenant Email"; Rec."Tenant Email")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'The Tenant Email is the email address of the tenant associated with the payment mode.';
                }

                field("Payment Received Date"; Rec."Payment Received Date")
                {
                    Caption = 'Payment Received Date';
                    Editable = false;
                    ToolTip = 'The Payment Received Date indicates the date when the payment was received.';
                    Visible = false;
                }

                field("View Invoice"; Rec."View Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'View Receipt Document';
                    ToolTip = 'The View Receipt Document field allows you to view the receipt document associated with the payment mode.';
                    DrillDown = true;
                    Editable = false;
                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin

                        FileURL := Rec."View Reciept document URL";

                        if FileURL = '' then
                            Error('No document is available to view.');

                        OpenFileInBrowser1(FileURL);
                    end;

                }
                field("View Reciept document URL"; Rec."View Reciept document URL")
                {
                    ApplicationArea = All;
                    Caption = 'View Reciept document URL';
                    ToolTip = 'The View Receipt Document URL field contains the URL of the receipt document associated with the payment mode.';
                    Visible = false;
                }
                field("Payment Reminder"; rec."Payment Reminder")
                {
                    ApplicationArea = All;
                    Editable = true;
                    Visible = false;
                    ToolTip = 'The Payment Reminder field allows you to set a reminder for the payment mode.';
                }

                field("Credit Note Amount"; Rec."Credit Note Amount")
                {
                    ApplicationArea = All;
                    Caption = '"Credit Note Amount"';
                    ToolTip = 'The Credit Note Amount is the amount of credit note applied to the payment mode.';
                    Editable = false;
                }

                field("Final Rent Amount"; Rec."Final Rent Amount")
                {
                    ApplicationArea = All;
                    Caption = '"Final Rent Amount"';
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The Final Rent Amount is the total rent amount after applying any credit notes.';
                }
                field("Credit Note No."; Rec."Credit Note No.")
                {
                    ApplicationArea = All;
                    Caption = '"Credit Note No."';
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The Credit Note No. is the unique identifier for the credit note applied to the payment mode.';
                }
                field(FinalRentAmountIncludingVAT; Rec.FinalRentAmountIncludingVAT)
                {
                    ApplicationArea = All;
                    Caption = '"Final Rent Amount Including VAT"';
                    Editable = false;
                    ToolTip = 'The Final Rent Amount Including VAT is the total rent amount after applying any credit notes and adding VAT.';
                }
                field(PortalSidePaymentProcessing; Rec.PortalSidePaymentProcessing)
                {
                    ApplicationArea = All;
                    ToolTip = 'The Portal Side Payment Processing indicates whether the payment processing is done through the portal side.';
                    Caption = 'Portal Side Payment Processing';
                    Editable = true;
                }
            }

            group(TotalAmountCalculation)
            {
                field("Total Amount"; Rec."Total Amount")
                {
                    Caption = 'Total Amount';
                    Editable = false;
                    ToolTip = 'The Total Amount is the total amount for the payment mode, including any adjustments.';
                }
                field("Total VAT Amount"; Rec."Total VAT Amount")
                {
                    Caption = 'Total VAT Amount';
                    Editable = false;
                    ToolTip = 'The Total VAT Amount is the total value-added tax applied to the payment mode.';
                }
                field("Total Amount Including VAT"; Rec."Total Amount Including VAT")
                {
                    Caption = 'Total Amount Including VAT';
                    Editable = false;
                    ToolTip = 'The Total Amount Including VAT is the total amount for the payment mode, including any adjustments and value-added tax.';
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action(InsertData)
            {
                ToolTip = 'Insert Data';
                ApplicationArea = All;
                Caption = 'Insert Data';
                Image = NewDocument;
                Visible = IsApproved;

                trigger OnAction()
                var
                    PaymentModeRec: Record "Payment Mode2";
                    PrePDCTransRec: Record "PDC Transaction";
                    PDCTransRec: Record "PDC Transaction";
                    paymentRec: Record "Payment Mode";
                    approvalflow: Codeunit 73209605;
                    Isupdate: Boolean;
                begin
                    Isupdate := false;

                    // Update Approval Status in the grid
                    PaymentModeRec.SetRange("Contract ID", Rec."Contract ID"); // Filter by Contract ID
                    if PaymentModeRec.FindSet() then
                        repeat
                            PaymentModeRec."Approval Status" := PaymentModeRec."Approval Status"::Pending; // Set Approval Status to Pending

                            PaymentModeRec.Modify();
                        until PaymentModeRec.Next() = 0;

                    paymentRec.SetRange("Contract ID", Rec."Contract ID");
                    paymentRec.SetRange("Tenant Id", Rec."Tenant Id");
                    if paymentRec.FindSet() then begin
                        paymentRec."Approval Status" := paymentRec."Approval Status"::Pending;
                        paymentRec."On-hold" := paymentRec."On-hold"::"True";
                        paymentRec.Modify();
                    end;

                    // Insert records into PDC Transaction for Payment Modes with "Cheque"
                    PaymentModeRec.SetRange("Contract ID", Rec."Contract ID"); // Filter by Contract ID
                    PaymentModeRec.SetRange("Tenant Id", Rec."Tenant Id"); // Filter by Tenant ID
                    PaymentModeRec.SetRange("Payment Mode", 'Cheque');
                    PaymentModeRec.SetFilter("Cheque Status", '<>%1', PaymentModeRec."Cheque Status"::Cancelled); // Filter by Payment Mode = Cheque

                    if PaymentModeRec.FindSet() then begin
                        repeat
                            //  **Validation: Check if Cheque Number is blank**
                            if DelChr(PaymentModeRec."Cheque Number", '=', ' ') = '' then
                                Error('Cheque Number cannot be blank when Payment Mode is Cheque.');
                            // Check for duplicate PDC Transaction record
                            PrePDCTransRec.SetRange("Tenant Id", PaymentModeRec."Tenant Id");
                            PrePDCTransRec.SetRange("Contract ID", PaymentModeRec."Contract ID");
                            PrePDCTransRec.SetRange("payment Series", PaymentModeRec."Payment Series");

                            if not PrePDCTransRec.FindFirst() then begin
                                // Insert record into PDC Transaction
                                PDCTransRec.Init();
                                PDCTransRec."Cheque Number" := PaymentModeRec."Cheque Number";
                                PDCTransRec."Bank Name" := PaymentModeRec."Deposit Bank";
                                PDCTransRec."Cheque Date" := PaymentModeRec."Due Date";
                                PDCTransRec.Amount := PaymentModeRec."Amount Including VAT";
                                PDCTransRec."Tenant Id" := PaymentModeRec."Tenant Id";
                                PDCTransRec."Contract ID" := PaymentModeRec."Contract ID";
                                PDCTransRec."Cheque Status" := PDCTransRec."Cheque Status"::" ";
                                PDCTransRec."Approval Status" := PDCTransRec."Approval Status"::Pending;
                                PDCTransRec."View Document URL" := PaymentModeRec."View Document URL";
                                PDCTransRec."payment Series" := PaymentModeRec."Payment Series";
                                PDCTransRec.Insert(true);
                                Clear(PDCTransRec);
                            end;

                        until PaymentModeRec.Next() = 0;
                        // CreateChequeEntry();
                        Message('PDC Transaction records successfully created for Cheque payment modes.');
                    end else
                        Message('No payment modes with "Cheque" found for the given Contract ID and Tenant ID.');

                    approvalflow.SendPaymentModeApprovalToFinanceManger(Format(Rec."Contract ID"), Rec."Tenant Id", Rec."Contract ID", Isupdate);

                end;
            }

            action(UpdateData)
            {
                ApplicationArea = All;
                Caption = 'Update Data';
                Image = NewDocument;
                ToolTip = 'Update Data';

                trigger OnAction()
                var
                    PDCTransRec: Record "PDC Transaction";
                    PrePDCTransRec: Record "PDC Transaction";
                    PaymentModeRec: Record "Payment Mode2";
                    approvalflow: Codeunit 73209605;
                    Isupdate: Boolean;
                    approvalEnum: Enum "Approval Status Enum";
                begin
                    Isupdate := true;
                    approvalflow.SendPaymentModeApprovalToFinanceManger(Format(Rec."Contract ID"), Rec."Tenant Id", Rec."Contract ID", Isupdate);

                    PaymentModeRec.Reset();
                    PaymentModeRec.SetRange("Approval Status", approvalEnum::Pending);
                    if PaymentModeRec.FindSet() then begin
                        repeat
                            PaymentModeRec."Approval Status" := approvalEnum::Pending;
                            PaymentModeRec.Modify();
                        until PaymentModeRec.Next() = 0;
                        Message('Approval Status updated successfully.');
                    end;

                    PaymentModeRec.Reset();
                    PaymentModeRec.SetRange("Contract ID", Rec."Contract ID");
                    PaymentModeRec.SetRange("Tenant Id", Rec."Tenant Id");
                    PaymentModeRec.SetRange("Payment Mode", 'Cheque');

                    if PaymentModeRec.FindSet() then begin
                        repeat
                            PrePDCTransRec.SetRange("Tenant Id", PaymentModeRec."Tenant Id");
                            PrePDCTransRec.SetRange("Contract ID", PaymentModeRec."Contract ID");
                            PrePDCTransRec.SetRange("payment Series", PaymentModeRec."Payment Series");

                            if not PrePDCTransRec.FindFirst() then begin
                                PDCTransRec.Init();
                                PDCTransRec."Cheque Number" := PaymentModeRec."Cheque Number";
                                PDCTransRec."Bank Name" := PaymentModeRec."Deposit Bank";
                                PDCTransRec."Cheque Date" := PaymentModeRec."Due Date";
                                PDCTransRec.Amount := PaymentModeRec."Amount Including VAT";
                                PDCTransRec."Tenant Id" := PaymentModeRec."Tenant Id";
                                PDCTransRec."Contract ID" := PaymentModeRec."Contract ID";
                                PDCTransRec."Cheque Status" := PaymentModeRec."Cheque Status";
                                PDCTransRec."Approval Status" := PaymentModeRec."Approval Status";
                                PDCTransRec."View Document URL" := PaymentModeRec."View Document URL";
                                PDCTransRec."payment Series" := PaymentModeRec."Payment Series";
                                PDCTransRec.Insert(true);
                                Clear(PDCTransRec);
                            end;
                        until PaymentModeRec.Next() = 0;
                        Message('PDC Transaction Updated successfully.');
                    end
                    else
                        Message('No new cheque payments found.');
                end;
            }
        }
    }




    trigger OnAfterGetRecord()
    var
        paymentschedul2grid: Record "Payment Schedule2";
        paymentTypeRec: Record "Payment Type";
        PaymentStatus: Enum "Payment Status";
    begin
        IsApproved := (Rec."Approval Status" <> Rec."Approval Status"::Approved);

        if (Rec."Payment Status" = Rec."Payment Status"::Cancelled) or (Rec."Payment Status" = Rec."Payment Status"::Received) then
            IsReceivedCancelled := true
        else
            IsReceivedCancelled := false;

        // If the field is blank, assign '-'
        if Rec."Cheque Number" = '' then
            Rec."Cheque Number" := '-';

        if Rec."Old Cheque #" = '' then
            Rec."Old Cheque #" := '-';

        if Rec."Receipt #" = '' then
            Rec."Receipt #" := '-';

        if Rec."Invoice #" = '' then
            Rec."Invoice #" := '-';


        if Rec."Payment mode" = '' then
            // Retrieve the first available Payment Method from the Payment Type table
            if paymentTypeRec.FindFirst() then
                Rec."Payment mode" := paymentTypeRec."Payment Method"; // Set the first Payment Method as default


        if Rec."Payment Status" = PaymentStatus::Cancelled then
            exit; // Do nothing if already cancelled

        if Rec."Payment Status" = PaymentStatus::Received then
            exit;

        if Rec."Due Date" = Today() then
            Rec."Payment Status" := PaymentStatus::Due

        else
            if Rec."Due Date" > Today() then
                Rec."Payment Status" := PaymentStatus::Scheduled

            else
                if Rec."Due Date" = 0D then
                    Rec."Payment Status" := PaymentStatus::Scheduled

                else
                    if Rec."Due Date" < Today() then begin
                        Rec."Payment Status" := PaymentStatus::Overdue;
                        OverduePaymentSendRequest();
                    end;

        Rec.Modify();

        paymentschedul2grid.SetRange("Contract ID", Rec."Contract ID");
        paymentschedul2grid.SetRange("Payment Series", Rec."Payment Series");
        paymentschedul2grid.SetRange(Invoiced, true);
        if paymentschedul2grid.FindSet() then
            repeat
                Rec."Invoice #" := paymentschedul2grid."Invoice ID";
                Rec.Modify();
            until paymentschedul2grid.Next() = 0;

        Rec."Final Rent Amount" := Rec."Amount" - Rec."Credit Note Amount";
        Rec.FinalRentAmountIncludingVAT := Rec."Final Rent Amount" + Rec."VAT Amount";

        Rec.Modify();
    end;

    trigger OnAfterGetCurrRecord()
    var
        paymentschedul2grid: Record "Payment Schedule2";
    begin
        paymentschedul2grid.SetRange("Contract ID", Rec."Contract ID");
        paymentschedul2grid.SetRange("Payment Series", Rec."Payment Series");
        paymentschedul2grid.SetRange(Invoiced, true);
        if paymentschedul2grid.FindSet() then
            repeat
                Rec."Invoice #" := paymentschedul2grid."Invoice ID";
                Rec.Modify();
            until paymentschedul2grid.Next() = 0;
    end;

    procedure SetProposalID(pProposalID: Integer)
    begin

    end;

    procedure SetTenantID(pTenantID: Code[20])
    begin
        tenantID := pTenantID;

    end;

    procedure SetContractID(pContractID: Integer)
    begin
        ContractID := pContractID;

    end;

    procedure OpenFileInBrowser(URL: Text)
    begin
        // Use the Hyperlink method to open the file in the browser
        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;


    procedure OpenFileInBrowser1(URL: Text)
    begin
        // Use the Hyperlink method to open the file in the browser
        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;

    procedure SetDetails(pTenantName: Text[100]; pTenantEmail: Text[80])
    begin
        tenantName := pTenantName;
        tenantEmail := pTenantEmail;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        Rec."Tenant ID" := tenantID;
        Rec."Contract ID" := ContractID;
        Rec."Tenant Name" := tenantName;
        Rec."Tenant Email" := tenantEmail;

    end;

    var
        tenantID: Code[20];
        tenantName: Text[100];
        tenantEmail: Text[80];
        ContractID: Integer;
        IsApproved: Boolean;
        IsLeaseManager: Boolean;
        IsFinanceManager: Boolean;
        IsReceivedCancelled: Boolean;

    trigger OnOpenPage()
    var
        PermissionSet: Record "User Personalization";

    begin
        // Check if the current user has the 'LEASE_MANAGER' permission set
        IsLeaseManager := false;
        IsFinanceManager := false;
        PermissionSet.SetRange("User ID", UserId());

        if PermissionSet.FindFirst() then begin
            if PermissionSet."Profile ID" = 'LEASE_MANAGER' then
                IsLeaseManager := true;
            if PermissionSet."Profile ID" = 'FINANCE MANAGER' then
                IsFinanceManager := true;
        end;

    end;

    trigger OnModifyRecord(): Boolean
    begin
        IsApproved := (Rec."Approval Status" <> Rec."Approval Status"::Approved);

        if (Rec."Payment Status" = Rec."Payment Status"::Cancelled) or (Rec."Payment Status" = Rec."Payment Status"::Received) then
            IsReceivedCancelled := true
        else
            IsReceivedCancelled := false;
    end;



    procedure OverduePaymentSendRequest()
    var
        OverduePaymentList: Record "OverDuePaymentmode";
        approvalstatus: Enum "Approval Status Enum";
    begin
        if Rec."Due Date" < Today() then begin
            Rec."Payment Status" := Rec."Payment Status"::Overdue;
            Rec.Modify();

            OverduePaymentList.Reset();
            OverduePaymentList.SetRange("Tenant Id", Rec."Tenant Id");
            OverduePaymentList.SetRange("Contract ID", Rec."Contract ID");
            OverduePaymentList.SetRange("Payment Series", Rec."Payment Series");
            if not OverduePaymentList.FindFirst() then begin
                OverduePaymentList.Init();
                OverduePaymentList."Status" := approvalstatus::Pending;
                OverduePaymentList."Tenant Id" := Rec."Tenant Id";
                OverduePaymentList."Contract ID" := Rec."Contract ID";
                OverduePaymentList."Payment Series" := Rec."Payment Series";
                OverduePaymentList."Due Date" := Rec."Due Date";
                OverduePaymentList."Payment Status" := Rec."Payment Status";
                OverduePaymentList."Tenant Name" := Rec."Tenant Name";
                OverduePaymentList.Insert(true);
            end;
        end;
    end;
}