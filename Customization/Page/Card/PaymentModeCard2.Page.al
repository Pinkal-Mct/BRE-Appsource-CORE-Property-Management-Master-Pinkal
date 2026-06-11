page 73209706 "BLRPayment Mode Card2"
{
    PageType = ListPart;
    SourceTable = "BLRPaymentMode2";
    ApplicationArea = All;
    Caption = 'Payment Details';
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Payment Series"; Rec."BLRPayment Series")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The Payment Series is a unique identifier for the payment mode.';
                }

                field("Amount"; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The Amount is the total amount for the payment mode.';
                }


                field("VAT Amount"; Rec."BLRVAT Amount")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The VAT Amount is the value-added tax applied to the payment mode.';
                }


                field("Amount Including VAT"; Rec."BLRAmount Including VAT")
                {
                    ApplicationArea = All;
                    Editable = IsApproved and false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The Amount Including VAT is the total amount after adding VAT.';
                }

                field("Due Date"; Rec."BLRDue Date")
                {
                    ApplicationArea = All;
                    Editable = IsApproved and false;  // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The Due Date is the date by which the payment should be made.';
                }

                field("BLRPaymentMode"; Rec."BLRPayment Mode")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = IsApproved AND (Rec."BLRPayment Status" <> Rec."BLRPayment Status"::Cancelled); // Makes the field editable unless Payment Status is "Cancelled"
                    ToolTip = 'The Payment Mode indicates the method of payment, such as Cash, Cheque, or Bank Transfer.';
                }

                field("Cheque Number"; Rec."BLRCheque Number")
                {
                    ApplicationArea = All;
                    Editable = IsApproved AND (Rec."BLRPayment Mode" = 'Cheque') AND (Rec."BLRPayment Status" <> Rec."BLRPayment Status"::Cancelled);  // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The Cheque Number is the unique identifier for the cheque payment.';
                }

                field("Deposit Bank"; Rec."BLRDeposit Bank")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = not (Rec."BLRPayment Mode" = 'Cash');
                    ToolTip = 'The Deposit Bank indicates the bank where the payment is being made.';
                }

                field("Deposit Status"; Rec."BLRDeposit Status")
                {
                    ApplicationArea = All;
                    Editable = not IsReceivedCancelled;

                    ToolTip = 'The Deposit Status indicates the status of the deposit.';
                }

                field("Payment Status"; Rec."BLRPayment Status")
                {
                    ApplicationArea = All;
                    Editable = (IsApproved or not IsReceivedCancelled) and not (Rec."BLRPayment Mode" = 'Cheque');
                    ToolTip = 'The Payment Status indicates the status of the payment, such as Scheduled, Due, Received, or Cancelled.';

                    trigger OnValidate()
                    var
                        PDCTransRec: Record "BLRPDCTransaction";
                    begin
                        if (Rec."BLRPayment Status" = Rec."BLRPayment Status"::Cancelled) or
                          (Rec."BLRPayment Status" = Rec."BLRPayment Status"::Received) then
                            IsReceivedCancelled := true
                        else
                            IsReceivedCancelled := false;

                        PDCTransRec.SetRange("BLRContract ID", Rec."BLRContract ID");
                        PDCTransRec.SetRange("BLRpayment Series", Rec."BLRPayment Series");
                        if PDCTransRec.FindFirst() then
                            if PDCTransRec."BLRCheque Status" <> PDCTransRec."BLRCheque Status"::Cleared then begin
                                PDCTransRec."BLRCheque Status" := Rec."BLRCheque Status"::Cleared;
                                PDCTransRec.Modify();
                            end;
                    end;
                }
                field("Cheque Status"; Rec."BLRCheque Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The Cheque Status indicates the status of the cheque payment, such as Cheque Received or Cheque Cleared.';
                    trigger OnValidate()
                    var
                        PDCTransRec: Record "BLRPDCTransaction";
                        CashReceiptJournalCodeunit: Codeunit "BLRCash Receipt Journal Entry";
                        selectDate: Page "BLRSelect Date";
                    begin
                        if Rec."BLRApproval Status" <> Rec."BLRApproval Status"::Approved then
                            Error('Approval Status must be Approved to update Cheque Status.');

                        PDCTransRec.SetRange("BLRPayment Series", Rec."BLRPayment Series");
                        PDCTransRec.SetRange("BLRContract ID", Rec."BLRContract ID");
                        if PDCTransRec.FindFirst() then begin
                            if (Rec."BLRCheque Status" <> Rec."BLRCheque Status"::" ") AND (Rec."BLRCheque Status" <> Rec."BLRCheque Status"::Cleared) then begin
                                Commit();
                                selectDate.Caption := 'Select Transaction Date';
                                if selectDate.RunModal() = Action::OK then begin
                                    PDCTransRec."BLRTransaction Date" := selectDate.GetDate();
                                    PDCTransRec.Modify();
                                end
                                else
                                    Error('Transaction Date selection is mandatory to proceed.');
                            end;
                            case Rec."BLRCheque Status" of
                                Rec."BLRCheque Status"::"Cheque Received":
                                    begin
                                        CashReceiptJournalCodeunit.PDCReceivedTransaction(PDCTransRec);
                                        PDCTransRec."BLRCheque Status" := PDCTransRec."BLRCheque Status"::"Cheque Received";
                                        PDCTransRec.Modify();
                                        Rec."BLRPayment Status" := Rec."BLRPayment Status"::Scheduled;
                                        Rec."BLRDeposit Status" := Rec."BLRDeposit Status"::"-";
                                        Rec.Modify();
                                    end;
                                Rec."BLRCheque Status"::Cleared:
                                    begin
                                        Rec.Validate("BLRPayment Status", Rec."BLRPayment Status"::Received);
                                        PDCTransRec."BLRCheque Status" := PDCTransRec."BLRCheque Status"::Cleared;
                                        PDCTransRec.Modify();
                                        Rec.Modify();
                                    end;
                                Rec."BLRCheque Status"::Deposited:
                                    begin
                                        CashReceiptJournalCodeunit.PDCDepositedTransaction(PDCTransRec);
                                        PDCTransRec."BLRCheque Status" := PDCTransRec."BLRCheque Status"::Deposited;
                                        PDCTransRec.Modify();
                                        Rec."BLRPayment Status" := Rec."BLRPayment Status"::Due;
                                        Rec."BLRDeposit Status" := Rec."BLRDeposit Status"::Y;
                                        Rec.Modify();
                                    end;
                                Rec."BLRCheque Status"::"Due cheque not deposited":
                                    begin
                                        PDCTransRec."BLRCheque Status" := PDCTransRec."BLRCheque Status"::"Due cheque not deposited";
                                        PDCTransRec.Modify();
                                        Rec."BLRPayment Status" := Rec."BLRPayment Status"::Scheduled;
                                        Rec."BLRDeposit Status" := Rec."BLRDeposit Status"::"-";
                                        Rec.Modify();
                                    end;
                                Rec."BLRCheque Status"::"Replaced & Received":
                                    begin
                                        PDCTransRec."BLRCheque Status" := PDCTransRec."BLRCheque Status"::"Replaced & Received";
                                        PDCTransRec."BLROld Cheque#" := PDCTransRec."BLRCheque Number";
                                        PDCTransRec."BLRCheque Number" := '';
                                        PDCTransRec.Modify();
                                        Rec."BLRPayment Status" := Rec."BLRPayment Status"::Scheduled;
                                        Rec."BLRDeposit Status" := Rec."BLRDeposit Status"::"-";
                                        Rec."BLROld Cheque #" := Rec."BLRCheque Number";
                                        Rec."BLRCheque Number" := '-';
                                        Rec.Modify();
                                    end;
                                Rec."BLRCheque Status"::Retrieved:
                                    begin
                                        CashReceiptJournalCodeunit.PDCRetrivedTransaction(PDCTransRec);
                                        PDCTransRec."BLRCheque Status" := PDCTransRec."BLRCheque Status"::Retrieved;
                                        PDCTransRec."BLROld Cheque#" := PDCTransRec."BLRCheque Number";
                                        PDCTransRec."BLRCheque Number" := '';
                                        PDCTransRec.Modify();
                                        Rec."BLRPayment Status" := Rec."BLRPayment Status"::Cancelled;
                                        Rec."BLRDeposit Status" := Rec."BLRDeposit Status"::"-";
                                        Rec."BLROld Cheque #" := Rec."BLRCheque Number";
                                        Rec."BLRCheque Number" := '-';
                                        Rec.Modify();
                                    end;
                                Rec."BLRCheque Status"::Returned:
                                    begin
                                        CashReceiptJournalCodeunit.PDCReturnedTransaction(PDCTransRec);
                                        PDCTransRec."BLRCheque Status" := PDCTransRec."BLRCheque Status"::Returned;
                                        PDCTransRec.Modify();
                                        Rec."BLRPayment Status" := Rec."BLRPayment Status"::Cancelled;
                                        Rec."BLRDeposit Status" := Rec."BLRDeposit Status"::"-";
                                        Rec.Modify();
                                    end;
                                Rec."BLRCheque Status"::Cancelled:

                                    if Rec."BLRCheque Status" = Rec."BLRCheque Status"::Cancelled then begin

                                        PDCTransRec."BLRCheque Status" := PDCTransRec."BLRCheque Status"::Cancelled;
                                        PDCTransRec.Modify();
                                    end;


                            end;
                        end else
                            Error('The related Payment Series record was not found.');
                    end;
                }

                field("Invoice #"; Rec."BLRInvoice #")
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = Rec."BLRReceipt #" <> '-';
                    ToolTip = 'The Invoice # is the unique identifier for the invoice associated with the payment.';
                    trigger OnDrillDown()
                    var
                        SalesHeader: Record "Sales Header";
                        postedsalesinvoice: Record "Sales Invoice Header";
                    begin
                        if SalesHeader.Get(Enum::"Sales Document Type"::Invoice, Rec."BLRInvoice #") then
                            PAGE.Run(PAGE::"Sales Invoice", SalesHeader)
                        else
                            if postedsalesinvoice.Get(Rec."BLRInvoice #") then
                                PAGE.Run(PAGE::"Posted Sales Invoice", postedsalesinvoice);

                    end;
                }

                field("Receipt #"; Rec."BLRReceipt #")
                {
                    ApplicationArea = All;
                    Editable = IsApproved AND (Rec."BLRPayment Status" <> Rec."BLRPayment Status"::Cancelled); // Makes the field editable unless Payment Status is "Cancelled"
                    ToolTip = 'The Receipt # is the unique identifier for the receipt associated with the payment.';
                }
                field("Receipt Date"; Rec."BLRReceipt Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The Receipt Date indicates the date when the receipt was issued.';
                }

                field("Old Cheque #"; Rec."BLROld Cheque #")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The Old Cheque # is the previous cheque number if the payment mode was changed from Cheque to another mode.';

                    trigger OnValidate()
                    begin
                        if Rec."BLRPayment Mode" <> 'Cheque' then
                            Error('Cheque number can only be entered when Payment Mode is set to Cheque.');
                    end;

                }

                field("Upload Cheque"; Rec."BLRUpload Cheque")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    Editable = false;
                    ToolTip = 'The Upload Cheque field allows you to upload a cheque document for the payment mode.';

                    trigger OnDrillDown()
                    var
                        azureBlobUploader: Codeunit "BLRAzure AD Blob Storage";
                        fileName: Text;
                        uploadResult: Text;
                        folderName: Text;
                    begin

                        if Rec."BLRPayment Status" = Rec."BLRPayment Status"::Cancelled then begin
                            Message('Upload Cheque cannot be accessed because Payment Status is Cancelled');
                            exit; // Stop execution here
                        end;
                        // Check if the Payment Mode is 'Cheque'
                        if Rec."BLRPayment Mode" <> 'Cheque' then
                            Error('Cheque upload is only allowed when Payment Mode is "Cheque".');

                        folderName := 'PropertyDocuments';
                        fileName := azureBlobUploader.ValidateDocument(uploadResult, folderName);
                        if fileName <> '' then begin
                            Rec."BLRUpload Cheque" := CopyStr(fileName, 1, StrLen(fileName));
                            Rec."BLRView Document URL" := CopyStr(uploadResult, 1, StrLen(uploadResult));
                            Rec.Modify();
                            Message('File uploaded successfully: %1', fileName);
                        end;
                    end;
                }

                field("View"; Rec."BLRView")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    ToolTip = 'The View field allows you to view the uploaded cheque document.';

                    trigger OnValidate()
                    begin
                        if Rec."BLRPayment Mode" <> 'Cheque' then
                            Error('Cheque number can only be entered when Payment Mode is set to Cheque.');
                    end;

                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin

                        if Rec."BLRPayment Status" = Rec."BLRPayment Status"::Cancelled then begin
                            Message('View cannot be accessed because Payment Status is Cancelled');
                            exit; // Stop execution here
                        end;
                        // Check if the Payment Mode is 'Cheque'
                        if Rec."BLRPayment Mode" <> 'Cheque' then
                            Error('Cheque upload is only allowed when Payment Mode is "Cheque".');

                        // Get the URL of the uploaded document
                        FileURL := Rec."BLRView Document URL";

                        // Check if the file URL is not empty
                        if FileURL = '' then
                            Error('No document is available to view.');

                        // Open the file URL in the browser (new tab)
                        OpenFileInBrowser(FileURL);

                    end;
                }

                field("View Revenue Details"; Rec."BLRView Revenue Details")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    ToolTip = 'The View Revenue Details field allows you to view the revenue details associated with the payment mode.';

                    trigger OnDrillDown()
                    var

                        PaymentScheduleRec: Record "BLRPaymentSchedule2";
                        FilteredSchedulePage: Page "BLRPayment Schedule Card2"; // Replace with your actual page name
                    begin
                        if Rec."BLRPayment Status" = Rec."BLRPayment Status"::Cancelled then begin
                            Message('View Revenue Details cannot be accessed because Payment Status is Cancelled');
                            exit; // Stop execution here
                        end;
                        PaymentScheduleRec.SetRange("BLRContract ID", Rec."BLRContract ID");
                        // PaymentScheduleRec.SetRange("BLRProposal ID", Rec."Proposal ID");
                        PaymentScheduleRec.SetRange("BLRTenant ID", Rec."BLRTenant ID");
                        PaymentScheduleRec.SetRange("BLRDue Date", Rec."BLRDue Date");
                        PaymentScheduleRec.SetRange("BLRPayment Series", Rec."BLRPayment Series");

                        // Hide other data and show the filtered records
                        if PaymentScheduleRec.FindFirst() then
                            FilteredSchedulePage.SetTableView(PaymentScheduleRec);

                        // Open the filtered page
                        PAGE.Run(PAGE::"BLRPayment Schedule Card2", PaymentScheduleRec);

                    end;

                }

                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Visible = false;
                    ToolTip = 'The Tenant ID is the unique identifier for the tenant associated with the payment mode.';
                }

                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = false;// The ID is not editable since it's auto-incrementing
                    Visible = false;
                    ToolTip = 'The Contract ID is the unique identifier for the contract associated with the payment mode.';
                }

                field("ID"; Rec."BLRID")
                {
                    ApplicationArea = All;
                    Editable = false;// The ID is not editable since it's auto-incrementing
                    Visible = false;
                    ToolTip = 'The ID is the unique identifier for the payment mode.';
                }

                field("Approval Status"; Rec."BLRApproval Status")
                {
                    ApplicationArea = All;
                    Editable = IsApproved AND IsFinanceManager;
                    ToolTip = 'The Approval Status indicates the approval status of the payment mode, such as Approved, Pending, or Declined.';

                    trigger OnValidate()
                    begin
                        case Rec."BLRPayment Mode" of
                            'Cheque':
                                if (Rec."BLRCheque Number" = '-') or (Rec."BLRDeposit Bank" = '') or (Rec."BLRUpload Cheque" = 'Upload Cheque') then
                                    Error('Cheque details are incomplete. Please fill Cheque Number, Deposit Bank, and upload the Cheque.');

                            'Bank Transfer', 'Credit Card', 'Mobile Wallet':
                                if Rec."BLRDeposit Bank" = '' then
                                    Error('Deposit Bank must be entered for %1 payments.', Rec."BLRPayment Mode");
                        end;
                    end;
                }
                field(Reason; Rec."BLRReason")
                {
                    ApplicationArea = All;
                    Editable = IsApproved;
                    ToolTip = 'The Reason field allows you to provide a reason for the approval or decline of the payment mode.';
                }
                field(IsUpdated; Rec."BLRIsUpdated")
                {
                    ApplicationArea = All;
                    Editable = IsApproved;
                    Visible = false;
                    ToolTip = 'The IsUpdated field indicates whether the payment mode has been updated.';
                }
                field("Approve/Decline Status"; Rec."BLRApprove/Decline Status")
                {
                    ApplicationArea = All;
                    Editable = IsApproved;
                    Visible = false;
                    ToolTip = 'The Approve/Decline Status indicates the status of the approval or decline action for the payment mode.';
                }

                field("Tenant Name"; Rec."BLRTenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'The Tenant Name is the name of the tenant associated with the payment mode.';
                }

                field("Tenant Email"; Rec."BLRTenant Email")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'The Tenant Email is the email address of the tenant associated with the payment mode.';
                }

                field("Payment Received Date"; Rec."BLRPayment Received Date")
                {
                    Caption = 'Payment Received Date';
                    Editable = false;
                    ToolTip = 'The Payment Received Date indicates the date when the payment was received.';
                    Visible = false;
                }

                field("View Invoice"; Rec."BLRView Invoice")
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

                        FileURL := Rec."BLRView Reciept document URL";

                        if FileURL = '' then
                            Error('No document is available to view.');

                        OpenFileInBrowser1(FileURL);
                    end;

                }
                field("View Reciept document URL"; Rec."BLRView Reciept document URL")
                {
                    ApplicationArea = All;
                    Caption = 'View Reciept document URL';
                    ToolTip = 'The View Receipt Document URL field contains the URL of the receipt document associated with the payment mode.';
                    Visible = false;
                }
                field("Payment Reminder"; rec."BLRPayment Reminder")
                {
                    ApplicationArea = All;
                    Editable = true;
                    Visible = false;
                    ToolTip = 'The Payment Reminder field allows you to set a reminder for the payment mode.';
                }

                field("Credit Note Amount"; Rec."BLRCredit Note Amount")
                {
                    ApplicationArea = All;
                    Caption = '"Credit Note Amount"';
                    ToolTip = 'The Credit Note Amount is the amount of credit note applied to the payment mode.';
                    Editable = false;
                }

                field("Final Rent Amount"; Rec."BLRFinal Rent Amount")
                {
                    ApplicationArea = All;
                    Caption = '"Final Rent Amount"';
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The Final Rent Amount is the total rent amount after applying any credit notes.';
                }
                field("Credit Note No."; Rec."BLRCredit Note No.")
                {
                    ApplicationArea = All;
                    Caption = '"Credit Note No."';
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The Credit Note No. is the unique identifier for the credit note applied to the payment mode.';
                }
                field(FinalRentAmountIncludingVAT; Rec."BLRFinalRentAmountIncludingVAT")
                {
                    ApplicationArea = All;
                    Caption = '"Final Rent Amount Including VAT"';
                    Editable = false;
                    ToolTip = 'The Final Rent Amount Including VAT is the total rent amount after applying any credit notes and adding VAT.';
                }
                field(PortalSidePaymentProcessing; Rec."BLRPortalSidePaymentProcessing")
                {
                    ApplicationArea = All;
                    ToolTip = 'The Portal Side Payment Processing indicates whether the payment processing is done through the portal side.';
                    Caption = 'Portal Side Payment Processing';
                    Editable = true;
                }
            }

            group(TotalAmountCalculation)
            {
                field("Total Amount"; Rec."BLRTotal Amount")
                {
                    Caption = 'Total Amount';
                    Editable = false;
                    ToolTip = 'The Total Amount is the total amount for the payment mode, including any adjustments.';
                }
                field("Total VAT Amount"; Rec."BLRTotal VAT Amount")
                {
                    Caption = 'Total VAT Amount';
                    Editable = false;
                    ToolTip = 'The Total VAT Amount is the total value-added tax applied to the payment mode.';
                }
                field("Total Amount Including VAT"; Rec."BLRTotal Amount Including VAT")
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
                    PaymentModeRec: Record "BLRPaymentMode2";
                    PrePDCTransRec: Record "BLRPDCTransaction";
                    PDCTransRec: Record "BLRPDCTransaction";
                    paymentRec: Record "BLRPaymentMode";
                    approvalflow: Codeunit 73209605;
                    Isupdate: Boolean;
                begin
                    Isupdate := false;

                    // // Update Approval Status in the grid
                    // PaymentModeRec.SetRange("BLRContract ID", Rec."BLRContract ID"); // Filter by Contract ID
                    // if PaymentModeRec.FindSet() then
                    //     repeat

                    //         PaymentModeRec."BLRApproval Status" := PaymentModeRec."BLRApproval Status"::Pending; // Set Approval Status to Pending

                    //         PaymentModeRec.Modify();
                    //     until PaymentModeRec.Next() = 0;

                    paymentRec.SetRange("BLRContract ID", Rec."BLRContract ID");
                    paymentRec.SetRange("BLRTenant Id", Rec."BLRTenant Id");
                    if paymentRec.FindSet() then begin
                        paymentRec."BLRApproval Status" := paymentRec."BLRApproval Status"::Pending;
                        paymentRec."BLROn-hold" := paymentRec."BLROn-hold"::"True";
                        paymentRec.Modify();
                    end;

                    // Insert records into PDC Transaction for Payment Modes with "Cheque"
                    PaymentModeRec.SetRange("BLRContract ID", Rec."BLRContract ID"); // Filter by Contract ID
                    PaymentModeRec.SetRange("BLRTenant Id", Rec."BLRTenant Id"); // Filter by Tenant ID
                    PaymentModeRec.SetRange("BLRPayment Mode", 'Cheque');
                    PaymentModeRec.SetFilter("BLRCheque Status", '<>%1', PaymentModeRec."BLRCheque Status"::Cancelled); // Filter by Payment Mode = Cheque

                    if PaymentModeRec.FindSet() then begin
                        repeat
                            //  **Validation: Check if Cheque Number is blank**
                            if DelChr(PaymentModeRec."BLRCheque Number", '=', ' ') = '' then
                                Error('Cheque Number cannot be blank when Payment Mode is Cheque.');
                            // Check for duplicate PDC Transaction record
                            PrePDCTransRec.SetRange("BLRTenant Id", PaymentModeRec."BLRTenant Id");
                            PrePDCTransRec.SetRange("BLRContract ID", PaymentModeRec."BLRContract ID");
                            PrePDCTransRec.SetRange("BLRpayment Series", PaymentModeRec."BLRPayment Series");

                            if not PrePDCTransRec.FindFirst() then begin
                                // Insert record into PDC Transaction
                                PDCTransRec.Init();
                                PDCTransRec."BLRCheque Number" := PaymentModeRec."BLRCheque Number";
                                PDCTransRec."BLRBank Name" := PaymentModeRec."BLRDeposit Bank";
                                PDCTransRec."BLRCheque Date" := PaymentModeRec."BLRDue Date";
                                PDCTransRec."BLRAmount" := PaymentModeRec."BLRAmount Including VAT";
                                PDCTransRec."BLRTenant Id" := PaymentModeRec."BLRTenant Id";
                                PDCTransRec."BLRContract ID" := PaymentModeRec."BLRContract ID";
                                PDCTransRec."BLRCheque Status" := PDCTransRec."BLRCheque Status"::" ";
                                PDCTransRec."BLRApproval Status" := PDCTransRec."BLRApproval Status"::Pending;
                                PDCTransRec."BLRView Document URL" := PaymentModeRec."BLRView Document URL";
                                PDCTransRec."BLRpayment Series" := PaymentModeRec."BLRPayment Series";
                                PDCTransRec.Insert(true);
                                Clear(PDCTransRec);
                            end;

                        until PaymentModeRec.Next() = 0;
                        // CreateChequeEntry();
                        Message('PDC Transaction records successfully created for Cheque payment modes.');
                    end else
                        Message('No payment modes with "Cheque" found for the given Contract ID and Tenant ID.');

                    approvalflow.SendPaymentModeApprovalToFinanceManger(Format(Rec."BLRContract ID"), Rec."BLRTenant Id", Rec."BLRContract ID", Isupdate);

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
                    PDCTransRec: Record "BLRPDCTransaction";
                    PrePDCTransRec: Record "BLRPDCTransaction";
                    PaymentModeRec: Record "BLRPaymentMode2";
                    approvalflow: Codeunit 73209605;
                    Isupdate: Boolean;
                    approvalEnum: Enum "BLRApproval Status Enum";
                begin
                    Isupdate := true;
                    approvalflow.SendPaymentModeApprovalToFinanceManger(Format(Rec."BLRContract ID"), Rec."BLRTenant Id", Rec."BLRContract ID", Isupdate);

                    PaymentModeRec.Reset();
                    PaymentModeRec.SetRange("BLRApproval Status", approvalEnum::Pending);
                    if PaymentModeRec.FindSet() then begin
                        repeat
                            PaymentModeRec."BLRApproval Status" := approvalEnum::Pending;
                            PaymentModeRec.Modify();
                        until PaymentModeRec.Next() = 0;
                        Message('Approval Status updated successfully.');
                    end;

                    PaymentModeRec.Reset();
                    PaymentModeRec.SetRange("BLRContract ID", Rec."BLRContract ID");
                    PaymentModeRec.SetRange("BLRTenant Id", Rec."BLRTenant Id");
                    PaymentModeRec.SetRange("BLRPayment Mode", 'Cheque');

                    if PaymentModeRec.FindSet() then begin
                        repeat
                            PrePDCTransRec.SetRange("BLRTenant Id", PaymentModeRec."BLRTenant Id");
                            PrePDCTransRec.SetRange("BLRContract ID", PaymentModeRec."BLRContract ID");
                            PrePDCTransRec.SetRange("BLRpayment Series", PaymentModeRec."BLRPayment Series");

                            if not PrePDCTransRec.FindFirst() then begin
                                PDCTransRec.Init();
                                PDCTransRec."BLRCheque Number" := PaymentModeRec."BLRCheque Number";
                                PDCTransRec."BLRBank Name" := PaymentModeRec."BLRDeposit Bank";
                                PDCTransRec."BLRCheque Date" := PaymentModeRec."BLRDue Date";
                                PDCTransRec."BLRAmount" := PaymentModeRec."BLRAmount Including VAT";
                                PDCTransRec."BLRTenant Id" := PaymentModeRec."BLRTenant Id";
                                PDCTransRec."BLRContract ID" := PaymentModeRec."BLRContract ID";
                                PDCTransRec."BLRCheque Status" := PaymentModeRec."BLRCheque Status";
                                PDCTransRec."BLRApproval Status" := PaymentModeRec."BLRApproval Status";
                                PDCTransRec."BLRView Document URL" := PaymentModeRec."BLRView Document URL";
                                PDCTransRec."BLRpayment Series" := PaymentModeRec."BLRPayment Series";
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
        paymentschedul2grid: Record "BLRPaymentSchedule2";
        paymentTypeRec: Record "BLRPaymentType";
        PaymentStatus: Enum "BLRPayment Status";
    begin
        IsApproved := (Rec."BLRApproval Status" <> Rec."BLRApproval Status"::Approved);
        if (Rec."BLRPayment Status" = Rec."BLRPayment Status"::Cancelled) or (Rec."BLRPayment Status" = Rec."BLRPayment Status"::Received) then
            IsReceivedCancelled := true
        else
            IsReceivedCancelled := false;

        // If the field is blank, assign '-'
        if Rec."BLRCheque Number" = '' then
            Rec."BLRCheque Number" := '-';

        if Rec."BLROld Cheque #" = '' then
            Rec."BLROld Cheque #" := '-';

        if Rec."BLRReceipt #" = '' then
            Rec."BLRReceipt #" := '-';

        if Rec."BLRInvoice #" = '' then
            Rec."BLRInvoice #" := '-';


        if Rec."BLRPayment Mode" = '' then
            // Retrieve the first available Payment Method from the Payment Type table
            if paymentTypeRec.FindFirst() then
                Rec."BLRPayment mode" := paymentTypeRec."BLRPayment Method"; // Set the first Payment Method as default


        if Rec."BLRPayment Status" = PaymentStatus::Cancelled then
            exit; // Do nothing if already cancelled

        if Rec."BLRPayment Status" = PaymentStatus::Received then
            exit;

        if Rec."BLRDue Date" = Today() then
            Rec."BLRPayment Status" := PaymentStatus::Due

        else
            if Rec."BLRDue Date" > Today() then
                Rec."BLRPayment Status" := PaymentStatus::Scheduled

            else
                if Rec."BLRDue Date" = 0D then
                    Rec."BLRPayment Status" := PaymentStatus::Scheduled

                else
                    if Rec."BLRDue Date" < Today() then begin
                        Rec."BLRPayment Status" := PaymentStatus::Overdue;
                        OverduePaymentSendRequest();
                    end;

        Rec.Modify();

        paymentschedul2grid.SetRange("BLRContract ID", Rec."BLRContract ID");
        paymentschedul2grid.SetRange("BLRPayment Series", Rec."BLRPayment Series");
        paymentschedul2grid.SetRange(BLRInvoiced, true);
        if paymentschedul2grid.FindSet() then
            repeat
                Rec."BLRInvoice #" := paymentschedul2grid."BLRInvoice ID";
                Rec.Modify();
            until paymentschedul2grid.Next() = 0;

        Rec."BLRFinal Rent Amount" := Rec."BLRAmount" - Rec."BLRCredit Note Amount";
        Rec."BLRFinalRentAmountIncludingVAT" := Rec."BLRFinal Rent Amount" + Rec."BLRVAT Amount";

        Rec.Modify();
    end;

    trigger OnAfterGetCurrRecord()
    var
        paymentschedul2grid: Record "BLRPaymentSchedule2";
    begin
        paymentschedul2grid.SetRange("BLRContract ID", Rec."BLRContract ID");
        paymentschedul2grid.SetRange("BLRPayment Series", Rec."BLRPayment Series");
        paymentschedul2grid.SetRange(BLRInvoiced, true);
        if paymentschedul2grid.FindSet() then
            repeat
                Rec."BLRInvoice #" := paymentschedul2grid."BLRInvoice ID";
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

        Rec."BLRTenant ID" := tenantID;
        Rec."BLRContract ID" := ContractID;
        Rec."BLRTenant Name" := tenantName;
        Rec."BLRTenant Email" := tenantEmail;

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

        editdepositbank: Boolean;

    trigger OnOpenPage()
    var
        PermissionSet: Record "User Personalization";

    begin
        // Check if the current user has the 'LEASE MANAGER' permission set
        IsLeaseManager := false;
        IsFinanceManager := false;
        PermissionSet.SetRange("User ID", UserId());

        if PermissionSet.FindFirst() then begin
            if PermissionSet."Profile ID" = 'LEASE MANAGER' then
                IsLeaseManager := true;
            if PermissionSet."Profile ID" = 'FINANCE MANAGER' then
                IsFinanceManager := true;
        end;

    end;

    trigger OnModifyRecord(): Boolean
    begin
        IsApproved := (Rec."BLRApproval Status" <> Rec."BLRApproval Status"::Approved);

        if (Rec."BLRPayment Status" = Rec."BLRPayment Status"::Cancelled) or (Rec."BLRPayment Status" = Rec."BLRPayment Status"::Received) then
            IsReceivedCancelled := true
        else
            IsReceivedCancelled := false;
    end;



    procedure OverduePaymentSendRequest()
    var
        OverduePaymentList: Record "BLROverDuePaymentmode";
        approvalstatus: Enum "BLRApproval Status Enum";
    begin
        if Rec."BLRDue Date" < Today() then begin
            Rec."BLRPayment Status" := Rec."BLRPayment Status"::Overdue;
            Rec.Modify();

            OverduePaymentList.Reset();
            OverduePaymentList.SetRange("BLRTenant Id", Rec."BLRTenant Id");
            OverduePaymentList.SetRange("BLRContract ID", Rec."BLRContract ID");
            OverduePaymentList.SetRange("BLRPayment Series", Rec."BLRPayment Series");
            if not OverduePaymentList.FindFirst() then begin
                OverduePaymentList.Init();
                OverduePaymentList."BLRStatus" := approvalstatus::Pending;
                OverduePaymentList."BLRTenant Id" := Rec."BLRTenant Id";
                OverduePaymentList."BLRContract ID" := Rec."BLRContract ID";
                OverduePaymentList."BLRPayment Series" := Rec."BLRPayment Series";
                OverduePaymentList."BLRDue Date" := Rec."BLRDue Date";
                OverduePaymentList."BLRPayment Status" := Rec."BLRPayment Status";
                OverduePaymentList."BLRTenant Name" := Rec."BLRTenant Name";
                OverduePaymentList.Insert(true);
            end;
        end;
    end;
}