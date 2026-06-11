page 73209761 "BLRApprovalPaymentRequest"
{
    PageType = List;
    SourceTable = "BLRApprovalPaymentRequest";
    ApplicationArea = All;
    Caption = 'Payment Change Request Status List';
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID"; Rec."BLRID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the payment change request.';
                }

                field("Manual/Auto Status"; Rec."BLRManual/Auto Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies whether the payment change request was processed manually or automatically.';
                }

                field("Status"; Rec."BLRStatus")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the current status of the payment change request.';
                }
                field("Request Type"; Rec."BLRRequest Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the type of request for the payment change, such as Split or Combine.';
                }
                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the tenant associated with this payment change request.';
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        Tenantprofile: Record Customer;
                    begin
                        Tenantprofile.SetRange("No.", Rec."BLRTenant ID");
                        if Tenantprofile.FindSet() then
                            PAGE.RunModal(PAGE::"Customer Card", Tenantprofile)
                        else
                            Message('No Customer found using FindFirst either.');
                    end;
                }
                field("Payment mode ID"; Rec."BLRPayment mode ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier for the payment mode associated with this payment change request.';
                    Editable = false;
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        paymentmode: Record "BLRPaymentMode";
                    begin
                        paymentmode.SetRange("BLRContract ID", Rec."BLRContract ID");
                        if paymentmode.FindSet() then
                            PAGE.RunModal(PAGE::"BLRPayment Mode Card", paymentmode)
                        else
                            Message('No payment mode found using FindFirst either.');
                    end;
                }
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the contract associated with this payment change request.';
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        tenancycontact: Record "BLRTenancyContract";
                    begin
                        tenancycontact.SetRange("BLRContract ID", Rec."BLRContract ID");
                        if tenancycontact.FindSet() then
                            PAGE.RunModal(PAGE::"BLRTenancy Contract Card", tenancycontact)
                        else
                            Message('No Tenancy Contract found using FindFirst either.');
                    end;
                }
                field("Payment Series"; Rec."BLRPayment Series")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the payment series associated with this payment change request.';
                }
                field("Change Amount"; Rec."BLRChange Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the amount of change requested for the payment.';
                }
                field("Due Date"; Rec."BLRDue Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the due date for the payment change request.';
                }
                field("Payment mode"; Rec."BLRPayment mode")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the payment mode for the payment change request.';
                }
                field(Amount; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the amount associated with the payment change request.';
                }
                field("Vat Amount"; Rec."BLRVat Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the VAT amount associated with the payment change request.';
                }
                field("Cheque No"; Rec."BLRC_Cheque_Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cheque number associated with this payment change request.';
                }
                field("Deposit Bank"; Rec."BLRC_Deposit_Bank")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the deposit bank associated with this payment change request.';
                }
                field(Description; Rec."BLRDescription")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the description or notes related to the payment change request.';
                }

                field(Items; Rec."BLRItems")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the items associated with the payment change request.';
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Approve)
            {
                Caption = 'Approve';
                ApplicationArea = All;
                Image = Approve;
                Visible = IsFinanceManager;
                ToolTip = 'Approve selected records as paid';


                trigger OnAction()
                var
                    SelectedRecs: Record "BLRApprovalPaymentRequest";
                    ApproveCount: Integer;
                    ErrorCount: Integer;
                begin
                    CurrPage.SetSelectionFilter(SelectedRecs);

                    if SelectedRecs.IsEmpty() then begin
                        Message('No records selected for approval.');
                        exit;
                    end;

                    ApproveCount := 0;
                    ErrorCount := 0;

                    if SelectedRecs.FindSet() then
                        repeat
                            if SelectedRecs."BLRStatus" = 'Pending' then begin
                                // SelectedRecs."BLRStatus" := 'Approve';
                                // SelectedRecs.Modify();
                                ApproveCount += 1;
                                ProcessApprovalAndSplitRequest();
                                GetNextSequenceNo();

                            end else
                                ErrorCount += 1;
                        until SelectedRecs.Next() = 0;

                    Commit();
                    CurrPage.Update(false);

                    Message('%1 record(s) approved. %2 record(s) were not in "Pending" status.', ApproveCount, ErrorCount);


                end;
            }
            action(Reject)
            {
                Caption = 'Reject';
                ApplicationArea = All;
                Image = Reject;
                Visible = IsFinanceManager;
                ToolTip = 'Reject selected records as not paid';

                trigger OnAction()
                var
                    SelectedRecs: Record "BLRApprovalPaymentRequest";
                    RejectCount: Integer;
                    ErrorCount: Integer;

                begin
                    // Store selected records
                    CurrPage.SetSelectionFilter(SelectedRecs);

                    if SelectedRecs.IsEmpty() then begin
                        Message('No records selected for rejection.');
                        exit;
                    end;

                    RejectCount := 0;
                    ErrorCount := 0;

                    if SelectedRecs.FindSet() then
                        repeat
                            if SelectedRecs."BLRStatus" = 'Pending' then begin
                                SelectedRecs."BLRStatus" := 'Reject'; // Set status to "Declined"
                                SelectedRecs.Modify();
                                RejectCount += 1;
                            end else
                                ErrorCount += 1; // Count records that are not in "Pending" status
                        until SelectedRecs.Next() = 0;

                    Commit(); // Commit changes
                    CurrPage.Update(false); // Refresh page

                    // Display result messages
                    Message('%1 record(s) rejected. %2 record(s) were not in "Pending" status.', RejectCount, ErrorCount);
                end;
            }
        }

        area(navigation)
        {

        }
    }

    procedure ProcessApprovalAndSplitRequest()
    var
        PaymentChangeReqTable: Record "BLRApprovalPaymentRequest";
        PaymentModeTable: Record "BLRPaymentMode2";
        PaymentSchedule: Record "BLRPaymentSchedule2";
        ApprovalRec: Record "BLRApprovalPaymentRequest";
        PaymentModeRec: Record "BLRPaymentMode2";
        pdcTransRec: Record "BLRPDCTransaction";
        PDCCashreceiptEntry: Codeunit "BLRCash Receipt Journal Entry";
        SendmailToTenant: Codeunit "BLRSplitCombinePaymentModemail";
        selectDate: Page "BLRSelect Date";
        TransactionDate: Date;
        itemList: List of [Text];
        NewPaymentCode: Text;
        PaymentSeries: Text[200];
        RequestType: Text[50];
        SequenceNo, increment : Integer;
        ItemSeries: Text;
        paymentSeriesNos: List of [Text];
        oldChequeNumber: Text[100];

    begin
        ApprovalRec.Reset();
        ApprovalRec.SetRange("BLRContract ID", Rec."BLRContract ID");
        ApprovalRec.SetRange("BLRTenant ID", Rec."BLRTenant ID");
        ApprovalRec.SetRange("BLRID", Rec."BLRID");

        if ApprovalRec.FindFirst() then begin
            RequestType := ApprovalRec."BLRRequest Type";
            PaymentSeries := ApprovalRec."BLRPayment Series";

            case
                RequestType of
                'Split':
                    begin
                        // Filter Split Requests
                        PaymentChangeReqTable.Reset();
                        PaymentChangeReqTable.SetRange("BLRContract ID", Rec."BLRContract ID");
                        PaymentChangeReqTable.SetRange("BLRTenant ID", Rec."BLRTenant ID");
                        PaymentChangeReqTable.SetRange("BLRID", Rec."BLRID");
                        PaymentChangeReqTable.SetRange("BLRRequest Type", 'Split');

                        if not PaymentChangeReqTable.FindSet() then begin
                            Message('No matching records found for Contract ID: %1, Tenant ID: %2, ID: %3',
                                Rec."BLRContract ID", Rec."BLRTenant ID", Rec."BLRID");
                            exit;
                        end;

                        repeat
                            // Debug message
                            Message('Processing Split Request for ID: %1', PaymentChangeReqTable."BLRID");

                            // Extract and store `Items` in a list
                            Clear(itemList);
                            if PaymentChangeReqTable."BLRItems".Contains(', ') then
                                foreach ItemSeries in PaymentChangeReqTable."BLRItems".Split(', ') do
                                    itemList.Add(DelChr(ItemSeries, '>', ' '))
                            else
                                itemList.Add(PaymentChangeReqTable."BLRItems");


                            // Cancel old payment records in PaymentModeTable
                            if PaymentChangeReqTable."BLRPayment Series" <> '' then begin
                                PaymentModeTable.Reset();
                                PaymentModeTable.SetRange("BLRContract ID", Rec."BLRContract ID");
                                PaymentModeTable.SetRange("BLRTenant ID", Rec."BLRTenant ID");
                                PaymentModeTable.SetRange("BLRPayment Series", paymentSeries);

                                if PaymentModeTable.FindSet() then begin
                                    // repeat
                                    if PaymentModeTable."BLRPayment Status" <> PaymentModeTable."BLRPayment Status"::Cancelled then begin
                                        PaymentModeTable."BLRPayment Status" := PaymentModeTable."BLRPayment Status"::Cancelled;
                                        PaymentModeTable."BLRCheque Number" := '-';
                                        if PaymentModeTable."BLRPayment Mode" = 'Cheque' then begin
                                            pdcTransRec.SetRange("BLRContract ID", PaymentModeTable."BLRContract ID");
                                            pdcTransRec.SetRange("BLRpayment Series", PaymentModeTable."BLRPayment Series");
                                            pdcTransRec.SetFilter("BLRCheque Status", '%1', PaymentModeTable."BLRCheque Status"::"Cheque Received");
                                            if pdcTransRec.FindFirst() then begin
                                                Commit();
                                                selectDate.Caption := 'Select Transaction Date';
                                                if selectDate.RunModal() = Action::OK then
                                                    Rec."BLRTransaction Date" := selectDate.GetDate();

                                                if Rec."BLRTransaction Date" = 0D then
                                                    // Revert status change
                                                    Error('Please enter Transaction Date before approval.')
                                                else
                                                    PDCCashreceiptEntry.ReversePDCReceivedTransaction(pdcTransRec, 'Payment Split', Rec."BLRTransaction Date");

                                            end;
                                            PaymentModeTable.Validate("BLRCheque Status", PaymentModeTable."BLRCheque Status"::Cancelled);
                                        end;
                                        PaymentModeTable.Modify(true);
                                        // Message('Cancelled Payment Series: %1', PaymentModeTable."BLRPayment Series");
                                        // until PaymentModeTable.Next() = 0;
                                    end;
                                    Clear(PaymentModeTable);
                                end;
                            end;

                            // Generate new payment series
                            SequenceNo := GetNextSequenceNo();
                            NewPaymentCode := GeneratePaymentCode(SequenceNo);

                            // Insert new Payment Mode record
                            PaymentModeTable.Init();
                            PaymentModeTable."BLRContract ID" := PaymentChangeReqTable."BLRContract ID";
                            PaymentModeTable."BLRTenant ID" := CopyStr(PaymentChangeReqTable."BLRTenant ID", 1, StrLen(PaymentChangeReqTable."BLRTenant ID"));
                            PaymentModeTable."BLRID" := PaymentChangeReqTable."BLRID";
                            PaymentModeTable."BLRAmount Including VAT" := PaymentChangeReqTable."BLRChange Amount";
                            PaymentModeTable."BLRAmount" := PaymentChangeReqTable."BLRAmount";
                            PaymentModeTable."BLRVAT Amount" := PaymentChangeReqTable."BLRVat Amount";
                            PaymentModeTable."BLRDue Date" := PaymentChangeReqTable."BLRDue Date";
                            PaymentModeTable."BLRPayment Mode" := CopyStr(PaymentChangeReqTable."BLRPayment Mode", 1, StrLen(PaymentChangeReqTable."BLRPayment Mode"));
                            PaymentModeTable."BLRDeposit Bank" := PaymentChangeReqTable."BLRC_Deposit_Bank";

                            PaymentModeTable."BLRPayment Series" := CopyStr(NewPaymentCode, 1, StrLen(NewPaymentCode));
                            PaymentModeTable."BLRPayment Status" := PaymentModeTable."BLRPayment Status"::Scheduled;
                            PaymentModeTable."BLROld Cheque #" := PaymentChangeReqTable."BLROld Cheque";

                            PaymentModeTable.Insert(true);
                            // PaymentModeRec.ModifyAll("BLRPaymentMode", ApprovalRec."BLRPaymentMode");
                            Clear(PaymentModeTable);

                            // Update Payment Schedule for matching `Items` and `Payment Series`
                            for increment := 1 to itemList.Count() do begin
                                //foreach ItemSeries in itemList do begin
                                //foreach paymentSeries in paymentSeriesNos do begin
                                PaymentSchedule.Reset();
                                PaymentSchedule.SetRange("BLRContract ID", Rec."BLRContract ID");
                                PaymentSchedule.SetRange("BLRTenant ID", Rec."BLRTenant ID");
                                PaymentSchedule.SetRange("BLRSecondary Item Type", itemList.Get(increment));
                                PaymentSchedule.SetRange("BLRPayment Series", paymentSeries);
                                if PaymentSchedule.FindFirst() then begin

                                    PaymentSchedule."BLRPayment Series" := CopyStr(NewPaymentCode, 1, StrLen(NewPaymentCode));
                                    PaymentSchedule."BLRDue Date" := PaymentChangeReqTable."BLRDue Date";
                                    PaymentSchedule.Modify(true);
                                    //  until PaymentSchedule.Next() = 0;
                                end;

                            end;

                        until PaymentChangeReqTable.Next() = 0;
                        Rec."BLRStatus" := 'Approve';
                        SendmailToTenant.SendTenantEmail(Rec);
                        Message('Payment split request approved and processed successfully. Tenant has been notified via email.');

                        Rec.Modify();
                    end;
                'Combine':
                    begin

                        // Filter PaymentChangeReqTable for approval requests with "Combine" type
                        PaymentChangeReqTable.Reset();
                        PaymentChangeReqTable.SetRange("BLRContract ID", Rec."BLRContract ID");
                        PaymentChangeReqTable.SetRange("BLRTenant ID", Rec."BLRTenant ID");
                        PaymentChangeReqTable.SetRange("BLRID", Rec."BLRID");
                        PaymentChangeReqTable.SetRange("BLRRequest Type", 'Combine');

                        if not PaymentChangeReqTable.FindSet() then begin
                            Message('No matching records found for Contract ID: %1, Tenant ID: %2, ID: %3',
                                Rec."BLRContract ID", Rec."BLRTenant ID", Rec."BLRID");
                            exit;
                        end;

                        repeat
                            // Debug: Log each processing record
                            Message('Processing Record: Contract ID: %1, Tenant ID: %2, ID: %3',
                                PaymentChangeReqTable."BLRContract ID",
                                PaymentChangeReqTable."BLRTenant ID", PaymentChangeReqTable."BLRID");

                            Clear(paymentSeriesNos);
                            Clear(oldChequeNumber);

                            if PaymentChangeReqTable."BLRPayment Series".Contains(',') then
                                foreach paymentSeries in PaymentChangeReqTable."BLRPayment Series".Split(',') do
                                    paymentSeriesNos.Add(DelChr(paymentSeries, '=', ' '))
                            else
                                paymentSeriesNos.Add(PaymentChangeReqTable."BLRPayment Series");

                            // Update status of old payment records
                            for increment := 1 to paymentSeriesNos.Count() do begin
                                PaymentModeTable.Reset();
                                PaymentModeTable.SetRange("BLRPayment Series", paymentSeriesNos.Get(increment));
                                PaymentModeTable.SetRange("BLRContract ID", Rec."BLRContract ID");
                                PaymentModeTable.SetRange("BLRTenant ID", Rec."BLRTenant ID");

                                if PaymentModeTable.FindSet() then begin
                                    //repeat
                                    PaymentModeTable."BLRPayment Status" := PaymentModeTable."BLRPayment Status"::Cancelled;
                                    if PaymentModeTable."BLRPayment Mode" = 'Cheque' then begin
                                        if oldChequeNumber = '' then
                                            oldChequeNumber := PaymentModeTable."BLRCheque Number"
                                        else
                                            oldChequeNumber += ', ' + PaymentModeTable."BLRCheque Number";
                                        PaymentModeTable."BLRCheque Number" := '-';
                                        pdcTransRec.SetRange("BLRContract ID", PaymentModeTable."BLRContract ID");
                                        pdcTransRec.SetRange("BLRpayment Series", PaymentModeTable."BLRPayment Series");
                                        pdcTransRec.SetFilter("BLRCheque Status", '%1', PaymentModeTable."BLRCheque Status"::"Cheque Received");
                                        if pdcTransRec.FindFirst() then begin

                                            Commit();
                                            selectDate.Caption := 'Select Transaction Date';
                                            if selectDate.RunModal() = Action::OK then
                                                Rec."BLRTransaction Date" := selectDate.GetDate();

                                            if Rec."BLRTransaction Date" = 0D then
                                                // Revert status change
                                                Error('Please enter Transaction Date before approval.')
                                            else
                                                PDCCashreceiptEntry.ReversePDCReceivedTransaction(pdcTransRec, 'Payment Combined', Rec."BLRTransaction Date");

                                        end;
                                        PaymentModeTable.Validate("BLRCheque Status", PaymentModeTable."BLRCheque Status"::Cancelled);

                                    end;
                                    PaymentModeTable.Modify(true);
                                    Clear(PaymentModeTable);
                                end;
                            end;

                            // Generate new payment series
                            SequenceNo := GetNextSequenceNo();
                            NewPaymentCode := GeneratePaymentCode(SequenceNo);

                            // Check if a record already exists in PaymentModeTable
                            PaymentModeTable.Reset();
                            PaymentModeTable.SetRange(BLRId, PaymentChangeReqTable."BLRID");
                            if not PaymentModeTable.FindFirst() then begin
                                // Insert new record
                                PaymentModeTable.Init();
                                PaymentModeTable."BLRContract ID" := PaymentChangeReqTable."BLRContract ID";
                                PaymentModeTable."BLRTenant ID" := CopyStr(PaymentChangeReqTable."BLRTenant ID", 1, StrLen(PaymentChangeReqTable."BLRTenant ID"));
                                PaymentModeTable."BLRID" := PaymentChangeReqTable."BLRID";
                                PaymentModeTable."BLRAmount Including VAT" := PaymentChangeReqTable."BLRChange Amount";
                                PaymentModeTable."BLRAmount" := PaymentChangeReqTable."BLRAmount";
                                PaymentModeTable."BLRVAT Amount" := PaymentChangeReqTable."BLRVat Amount";
                                PaymentModeTable."BLRDue Date" := PaymentChangeReqTable."BLRDue Date";
                                PaymentModeTable."BLRPayment Mode" := CopyStr(PaymentChangeReqTable."BLRPayment mode", 1, StrLen(PaymentChangeReqTable."BLRPayment mode"));
                                PaymentModeTable."BLRPayment Series" := CopyStr(NewPaymentCode, 1, StrLen(NewPaymentCode));
                                PaymentModeTable."BLRPayment Status" := PaymentModeTable."BLRPayment Status"::Scheduled;
                                PaymentModeTable."BLRApproval Status" := PaymentModeTable."BLRApproval Status"::Approved;
                                PaymentModeTable."BLROld Cheque #" := oldChequeNumber;
                                PaymentModeTable.Insert(true);
                                // PaymentModeRec.ModifyAll("BLRPaymentMode", ApprovalRec."BLRPaymentMode");
                                Clear(PaymentModeTable);
                            end else begin
                                // Modify existing record
                                PaymentModeTable."BLRDeposit Bank" := PaymentChangeReqTable."BLRC_Deposit_Bank";
                                PaymentModeTable."BLRCheque Number" := PaymentChangeReqTable."BLRC_Cheque_Number";
                                PaymentModeTable."BLRAmount Including VAT" := PaymentChangeReqTable."BLRChange Amount";
                                PaymentModeTable."BLRAmount" := PaymentChangeReqTable."BLRAmount";
                                PaymentModeTable."BLRVAT Amount" := PaymentChangeReqTable."BLRVat Amount";
                                PaymentModeTable."BLRDue Date" := PaymentChangeReqTable."BLRDue Date";
                                PaymentModeTable.Modify(true);
                                Message('Updated existing payment record with ID: %1', PaymentModeTable."BLRID");
                            end;

                            for increment := 1 to paymentSeriesNos.Count() do begin
                                PaymentSchedule.Reset();
                                PaymentSchedule.SetRange("BLRPayment Series", paymentSeriesNos.Get(increment));
                                PaymentSchedule.SetRange("BLRContract ID", Rec."BLRContract ID");
                                PaymentSchedule.SetRange("BLRTenant ID", Rec."BLRTenant ID");

                                if PaymentSchedule.FindSet() then
                                    repeat
                                        PaymentSchedule."BLRPayment Series" := CopyStr(NewPaymentCode, 1, StrLen(NewPaymentCode));
                                        PaymentSchedule."BLRDue Date" := PaymentChangeReqTable."BLRDue Date";
                                        PaymentSchedule.Modify(true);
                                    until PaymentSchedule.Next() = 0;

                            end;
                        until PaymentChangeReqTable.Next() = 0;
                        Rec."BLRStatus" := 'Approve';
                        SendmailToTenant.SendTenantEmail(Rec);
                        Message('Payment combine request approved and processed successfully. Tenant has been notified via email.');

                        Rec.Modify();
                    end;

                'Payment Mode':
                    begin
                        PaymentModeRec.Reset();
                        PaymentModeRec.SetRange("BLRPayment Series", PaymentSeries);
                        PaymentModeRec.SetRange("BLRContract ID", Rec."BLRContract ID");
                        PaymentModeRec.SetRange("BLRTenant ID", Rec."BLRTenant ID");
                        if PaymentModeRec.FindSet() then begin
                            if PaymentModeRec."BLRPayment Mode" = 'Cheque' then begin
                                pdcTransRec.SetRange("BLRContract ID", PaymentModeRec."BLRContract ID");
                                pdcTransRec.SetRange("BLRpayment Series", PaymentModeRec."BLRPayment Series");
                                pdcTransRec.SetFilter("BLRCheque Status", '%1', PaymentModeRec."BLRCheque Status"::"Cheque Received");
                                if pdcTransRec.FindFirst() then begin

                                    Commit();
                                    selectDate.Caption := 'Select Transaction Date';
                                    if selectDate.RunModal() = Action::OK then
                                        Rec."BLRTransaction Date" := selectDate.GetDate();

                                    if Rec."BLRTransaction Date" = 0D then
                                        // Revert status change
                                        Error('Please enter Transaction Date before approval.')
                                    else
                                        PDCCashreceiptEntry.ReversePDCReceivedTransaction(pdcTransRec, 'Payment Method Changed', Rec."BLRTransaction Date");

                                end;
                                PaymentModeRec.Validate("BLRCheque Status", PaymentModeRec."BLRCheque Status"::Cancelled);
                            end;
                            PaymentModeRec.Validate("BLRCheque Status", PaymentModeRec."BLRCheque Status"::" ");
                            PaymentModeRec."BLRPayment Mode" := ApprovalRec."BLRPayment mode";
                            PaymentModeRec."BLRCheque Number" := ApprovalRec."BLRC_Cheque_Number";
                            PaymentModeRec."BLRDeposit Bank" := ApprovalRec."BLRC_Deposit_Bank";
                            PaymentModeRec.Modify();
                            //  Message('Updated Payment Mode for Series: %1', PaymentSeries);
                            Rec."BLRStatus" := 'Approve';
                            SendmailToTenant.SendTenantEmail(Rec);
                            Message('Payment mode change request approved and processed successfully. Tenant has been notified via email.');

                            Rec.Modify();

                        end else
                            Error('Payment Series %1 not found in Payment Mode Table.', PaymentSeries);
                    end;
            end;
        end else
            Error('No matching Approval Record found for Contract ID: %1, Tenant ID: %2, ID: %3',
                Rec."BLRContract ID", Rec."BLRTenant ID", Rec."BLRID");

        Message('Processing complete.');
    end;

    // Generates a new payment code with a padded sequence number
    local procedure GeneratePaymentCode(SequenceNumber: Integer): Text
    begin
        exit('PAY' + PadStr(Format(SequenceNumber), 2, '0')); // Format as PAY000001
    end;

    // Pads a string to a specified length with a specified character
    local procedure PadStr(Input: Text[20]; Length: Integer; PaddingChar: Char): Text[20]
    begin
        while StrLen(Input) < Length do
            Input := PaddingChar + Input;
        exit(Input);
    end;

    // Gets the next sequence number for the Payment Series
    local procedure GetNextSequenceNo(): Integer
    var
        MergedRecord: Record "BLRPaymentMode2";
        MaxSequence: Integer;
        LastSequence: Text[10];
    begin
        MergedRecord.Reset();
        MergedRecord.SetRange("BLRContract ID", Rec."BLRContract ID");

        if MergedRecord.FindSet() then
            repeat
                // Extract the numeric part of the Payment Series
                LastSequence := CopyStr(MergedRecord."BLRPayment Series", 4, StrLen(MergedRecord."BLRPayment Series"));
                if Evaluate(MaxSequence, LastSequence) and (MaxSequence > MaxSequence) then
                    MaxSequence := MaxSequence;
            until MergedRecord.Next() = 0
        else
            MaxSequence := 0; // Default to 0 if no records are found

        exit(MaxSequence + 1);
    end;





    trigger OnOpenPage()
    begin
        // Check if the current user has the 'LEASE MANAGER' permission set
        IsFinanceManager := VisibleApproveAction();
    end;

    procedure VisibleApproveAction(): Boolean
    var
        UserPersonalization: Record "User Personalization";
    begin

        if UserPersonalization.Get(UserSecurityId()) then
            case UserPersonalization."Profile ID" of
                'PROPERTY MANAGER':
                    exit(false);
                'LEASE MANAGER':
                    exit(false);
                'FINANCE MANAGER':
                    exit(true);
            end;


        exit(false);
    end;

    var
        IsFinanceManager: Boolean;
}