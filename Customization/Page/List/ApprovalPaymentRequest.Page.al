page 73209761 "Approval Payment Request"
{
    PageType = List;
    SourceTable = "Approval Payment Request";
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
                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the payment change request.';
                }

                field("Manual/Auto Status"; Rec."Manual/Auto Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies whether the payment change request was processed manually or automatically.';
                }

                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the current status of the payment change request.';
                }
                field("Request Type"; Rec."Request Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the type of request for the payment change, such as Split or Combine.';
                }
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the tenant associated with this payment change request.';
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        Tenantprofile: Record Customer;
                    begin
                        Tenantprofile.SetRange("No.", Rec."Tenant ID");
                        if Tenantprofile.FindSet() then
                            PAGE.RunModal(PAGE::"Customer Card", Tenantprofile)
                        else
                            Message('No Customer found using FindFirst either.');
                    end;
                }
                field("Payment mode ID"; Rec."Payment mode ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier for the payment mode associated with this payment change request.';
                    Editable = false;
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        paymentmode: Record "Payment Mode";
                    begin
                        paymentmode.SetRange("Contract ID", Rec."Contract ID");
                        if paymentmode.FindSet() then
                            PAGE.RunModal(PAGE::"Payment Mode Card", paymentmode)
                        else
                            Message('No payment mode found using FindFirst either.');
                    end;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the contract associated with this payment change request.';
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        tenancycontact: Record "Tenancy Contract";
                    begin
                        tenancycontact.SetRange("Contract ID", Rec."Contract ID");
                        if tenancycontact.FindSet() then
                            PAGE.RunModal(PAGE::"Tenancy Contract Card", tenancycontact)
                        else
                            Message('No Tenancy Contract found using FindFirst either.');
                    end;
                }
                field("Payment Series"; Rec."Payment Series")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the payment series associated with this payment change request.';
                }
                field("Change Amount"; Rec."Change Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the amount of change requested for the payment.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the due date for the payment change request.';
                }
                field("Payment mode"; Rec."Payment mode")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the payment mode for the payment change request.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the amount associated with the payment change request.';
                }
                field("Vat Amount"; Rec."Vat Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the VAT amount associated with the payment change request.';
                }
                field("Cheque No"; Rec."C_Cheque_Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cheque number associated with this payment change request.';
                }
                field("Deposit Bank"; Rec."C_Deposit_Bank")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the deposit bank associated with this payment change request.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the description or notes related to the payment change request.';
                }

                field(Items; Rec.Items)
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
                    SelectedRecs: Record "Approval Payment Request";
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
                            if SelectedRecs.Status = 'Pending' then begin
                                // SelectedRecs.Status := 'Approve';
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
                    SelectedRecs: Record "Approval Payment Request";
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
                            if SelectedRecs.Status = 'Pending' then begin
                                SelectedRecs.Status := 'Reject'; // Set status to "Declined"
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
        PaymentChangeReqTable: Record "Approval Payment Request";
        PaymentModeTable: Record "Payment Mode2";
        PaymentSchedule: Record "Payment Schedule2";
        ApprovalRec: Record "Approval Payment Request";
        PaymentModeRec: Record "Payment Mode2";
        pdcTransRec: Record "PDC Transaction";
        PDCCashreceiptEntry: Codeunit "Cash Receipt Journal Entry";
        SendmailToTenant: Codeunit "SplitCombinePaymentModemail";
        selectDate: Page "Select Date";
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
        ApprovalRec.SetRange("Contract ID", Rec."Contract ID");
        ApprovalRec.SetRange("Tenant ID", Rec."Tenant ID");
        ApprovalRec.SetRange("ID", Rec."ID");

        if ApprovalRec.FindFirst() then begin
            RequestType := ApprovalRec."Request Type";
            PaymentSeries := ApprovalRec."Payment Series";

            case
                RequestType of
                'Split':
                    begin
                        // Filter Split Requests
                        PaymentChangeReqTable.Reset();
                        PaymentChangeReqTable.SetRange("Contract ID", Rec."Contract ID");
                        PaymentChangeReqTable.SetRange("Tenant ID", Rec."Tenant ID");
                        PaymentChangeReqTable.SetRange("ID", Rec."ID");
                        PaymentChangeReqTable.SetRange("Request Type", 'Split');

                        if not PaymentChangeReqTable.FindSet() then begin
                            Message('No matching records found for Contract ID: %1, Tenant ID: %2, ID: %3',
                                Rec."Contract ID", Rec."Tenant ID", Rec."ID");
                            exit;
                        end;

                        repeat
                            // Debug message
                            Message('Processing Split Request for ID: %1', PaymentChangeReqTable.ID);

                            // Extract and store `Items` in a list
                            Clear(itemList);
                            if PaymentChangeReqTable."Items".Contains(', ') then
                                foreach ItemSeries in PaymentChangeReqTable."Items".Split(', ') do
                                    itemList.Add(DelChr(ItemSeries, '>', ' '))
                            else
                                itemList.Add(PaymentChangeReqTable."Items");


                            // Cancel old payment records in PaymentModeTable
                            if PaymentChangeReqTable."Payment Series" <> '' then begin
                                PaymentModeTable.Reset();
                                PaymentModeTable.SetRange("Contract ID", Rec."Contract ID");
                                PaymentModeTable.SetRange("Tenant ID", Rec."Tenant ID");
                                PaymentModeTable.SetRange("Payment Series", paymentSeries);

                                if PaymentModeTable.FindSet() then begin
                                    // repeat
                                    if PaymentModeTable."Payment Status" <> PaymentModeTable."Payment Status"::Cancelled then begin
                                        PaymentModeTable."Payment Status" := PaymentModeTable."Payment Status"::Cancelled;
                                        PaymentModeTable."Cheque Number" := '-';
                                        if PaymentModeTable."Payment Mode" = 'Cheque' then begin
                                            pdcTransRec.SetRange("Contract ID", PaymentModeTable."Contract ID");
                                            pdcTransRec.SetRange("payment Series", PaymentModeTable."Payment Series");
                                            pdcTransRec.SetFilter("Cheque Status", '%1', PaymentModeTable."Cheque Status"::"Cheque Received");
                                            if pdcTransRec.FindFirst() then begin
                                                Commit();
                                                selectDate.Caption := 'Select Transaction Date';
                                                if selectDate.RunModal() = Action::OK then
                                                    Rec."Transaction Date" := selectDate.GetDate();

                                                if Rec."Transaction Date" = 0D then
                                                    // Revert status change
                                                    Error('Please enter Transaction Date before approval.')
                                                else
                                                    PDCCashreceiptEntry.ReversePDCReceivedTransaction(pdcTransRec, 'Payment Split', Rec."Transaction Date");

                                            end;
                                            PaymentModeTable.Validate("Cheque Status", PaymentModeTable."Cheque Status"::Cancelled);
                                        end;
                                        PaymentModeTable.Modify(true);
                                        // Message('Cancelled Payment Series: %1', PaymentModeTable."Payment Series");
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
                            PaymentModeTable."Contract ID" := PaymentChangeReqTable."Contract ID";
                            PaymentModeTable."Tenant ID" := CopyStr(PaymentChangeReqTable."Tenant ID", 1, StrLen(PaymentChangeReqTable."Tenant ID"));
                            PaymentModeTable."ID" := PaymentChangeReqTable."ID";
                            PaymentModeTable."Amount Including VAT" := PaymentChangeReqTable."Change Amount";
                            PaymentModeTable.Amount := PaymentChangeReqTable.Amount;
                            PaymentModeTable."VAT Amount" := PaymentChangeReqTable."Vat Amount";
                            PaymentModeTable."Due Date" := PaymentChangeReqTable."Due Date";
                            PaymentModeTable."Payment Mode" := CopyStr(PaymentChangeReqTable."Payment Mode", 1, StrLen(PaymentChangeReqTable."Payment Mode"));
                            PaymentModeTable."Deposit Bank" := PaymentChangeReqTable.C_Deposit_Bank;

                            PaymentModeTable."Payment Series" := CopyStr(NewPaymentCode, 1, StrLen(NewPaymentCode));
                            PaymentModeTable."Payment Status" := PaymentModeTable."Payment Status"::Scheduled;
                            PaymentModeTable."Old Cheque #" := PaymentChangeReqTable."Old Cheque";

                            PaymentModeTable.Insert(true);
                            // PaymentModeRec.ModifyAll("Payment Mode", ApprovalRec."Payment Mode");
                            Clear(PaymentModeTable);

                            // Update Payment Schedule for matching `Items` and `Payment Series`
                            for increment := 1 to itemList.Count() do begin
                                //foreach ItemSeries in itemList do begin
                                //foreach paymentSeries in paymentSeriesNos do begin
                                PaymentSchedule.Reset();
                                PaymentSchedule.SetRange("Contract ID", Rec."Contract ID");
                                PaymentSchedule.SetRange("Tenant ID", Rec."Tenant ID");
                                PaymentSchedule.SetRange("Secondary Item Type", itemList.Get(increment));
                                PaymentSchedule.SetRange("Payment Series", paymentSeries);
                                if PaymentSchedule.FindFirst() then begin

                                    PaymentSchedule."Payment Series" := CopyStr(NewPaymentCode, 1, StrLen(NewPaymentCode));
                                    PaymentSchedule."Due Date" := PaymentChangeReqTable."Due Date";
                                    PaymentSchedule.Modify(true);
                                    //  until PaymentSchedule.Next() = 0;
                                end;

                            end;

                        until PaymentChangeReqTable.Next() = 0;
                        Rec.Status := 'Approve';
                        SendmailToTenant.SendTenantEmail(Rec);
                        Message('Payment split request approved and processed successfully. Tenant has been notified via email.');

                        Rec.Modify();
                    end;
                'Combine':
                    begin

                        // Filter PaymentChangeReqTable for approval requests with "Combine" type
                        PaymentChangeReqTable.Reset();
                        PaymentChangeReqTable.SetRange("Contract ID", Rec."Contract ID");
                        PaymentChangeReqTable.SetRange("Tenant ID", Rec."Tenant ID");
                        PaymentChangeReqTable.SetRange("ID", Rec."ID");
                        PaymentChangeReqTable.SetRange("Request Type", 'Combine');

                        if not PaymentChangeReqTable.FindSet() then begin
                            Message('No matching records found for Contract ID: %1, Tenant ID: %2, ID: %3',
                                Rec."Contract ID", Rec."Tenant ID", Rec."ID");
                            exit;
                        end;

                        repeat
                            // Debug: Log each processing record
                            Message('Processing Record: Contract ID: %1, Tenant ID: %2, ID: %3',
                                PaymentChangeReqTable."Contract ID",
                                PaymentChangeReqTable."Tenant ID", PaymentChangeReqTable."ID");

                            Clear(paymentSeriesNos);
                            Clear(oldChequeNumber);

                            if PaymentChangeReqTable."Payment Series".Contains(',') then
                                foreach paymentSeries in PaymentChangeReqTable."Payment Series".Split(',') do
                                    paymentSeriesNos.Add(DelChr(paymentSeries, '=', ' '))
                            else
                                paymentSeriesNos.Add(PaymentChangeReqTable."Payment Series");

                            // Update status of old payment records
                            for increment := 1 to paymentSeriesNos.Count() do begin
                                PaymentModeTable.Reset();
                                PaymentModeTable.SetRange("Payment Series", paymentSeriesNos.Get(increment));
                                PaymentModeTable.SetRange("Contract ID", Rec."Contract ID");
                                PaymentModeTable.SetRange("Tenant ID", Rec."Tenant ID");

                                if PaymentModeTable.FindSet() then begin
                                    //repeat
                                    PaymentModeTable."Payment Status" := PaymentModeTable."Payment Status"::Cancelled;
                                    if PaymentModeTable."Payment Mode" = 'Cheque' then begin
                                        if oldChequeNumber = '' then
                                            oldChequeNumber := PaymentModeTable."Cheque Number"
                                        else
                                            oldChequeNumber += ', ' + PaymentModeTable."Cheque Number";
                                        PaymentModeTable."Cheque Number" := '-';
                                        pdcTransRec.SetRange("Contract ID", PaymentModeTable."Contract ID");
                                        pdcTransRec.SetRange("payment Series", PaymentModeTable."Payment Series");
                                        pdcTransRec.SetFilter("Cheque Status", '%1', PaymentModeTable."Cheque Status"::"Cheque Received");
                                        if pdcTransRec.FindFirst() then begin

                                            Commit();
                                            selectDate.Caption := 'Select Transaction Date';
                                            if selectDate.RunModal() = Action::OK then
                                                Rec."Transaction Date" := selectDate.GetDate();

                                            if Rec."Transaction Date" = 0D then
                                                // Revert status change
                                                Error('Please enter Transaction Date before approval.')
                                            else
                                                PDCCashreceiptEntry.ReversePDCReceivedTransaction(pdcTransRec, 'Payment Combined', Rec."Transaction Date");

                                        end;
                                        PaymentModeTable.Validate("Cheque Status", PaymentModeTable."Cheque Status"::Cancelled);

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
                            PaymentModeTable.SetRange(Id, PaymentChangeReqTable.ID);
                            if not PaymentModeTable.FindFirst() then begin
                                // Insert new record
                                PaymentModeTable.Init();
                                PaymentModeTable."Contract ID" := PaymentChangeReqTable."Contract ID";
                                PaymentModeTable."Tenant ID" := CopyStr(PaymentChangeReqTable."Tenant ID", 1, StrLen(PaymentChangeReqTable."Tenant ID"));
                                PaymentModeTable."ID" := PaymentChangeReqTable."ID";
                                PaymentModeTable."Amount Including VAT" := PaymentChangeReqTable."Change Amount";
                                PaymentModeTable.Amount := PaymentChangeReqTable.Amount;
                                PaymentModeTable."VAT Amount" := PaymentChangeReqTable."Vat Amount";
                                PaymentModeTable."Due Date" := PaymentChangeReqTable."Due Date";
                                PaymentModeTable."Payment Mode" := CopyStr(PaymentChangeReqTable."Payment mode", 1, StrLen(PaymentChangeReqTable."Payment mode"));
                                PaymentModeTable."Payment Series" := CopyStr(NewPaymentCode, 1, StrLen(NewPaymentCode));
                                PaymentModeTable."Payment Status" := PaymentModeTable."Payment Status"::Scheduled;
                                PaymentModeTable."Approval Status" := PaymentModeTable."Approval Status"::Approved;
                                PaymentModeTable."Old Cheque #" := oldChequeNumber;
                                PaymentModeTable.Insert(true);
                                // PaymentModeRec.ModifyAll("Payment Mode", ApprovalRec."Payment Mode");
                                Clear(PaymentModeTable);
                            end else begin
                                // Modify existing record
                                PaymentModeTable."Deposit Bank" := PaymentChangeReqTable."C_Deposit_Bank";
                                PaymentModeTable."Cheque Number" := PaymentChangeReqTable."C_Cheque_Number";
                                PaymentModeTable."Amount Including VAT" := PaymentChangeReqTable."Change Amount";
                                PaymentModeTable.Amount := PaymentChangeReqTable.Amount;
                                PaymentModeTable."VAT Amount" := PaymentChangeReqTable."Vat Amount";
                                PaymentModeTable."Due Date" := PaymentChangeReqTable."Due Date";
                                PaymentModeTable.Modify(true);
                                Message('Updated existing payment record with ID: %1', PaymentModeTable."ID");
                            end;

                            for increment := 1 to paymentSeriesNos.Count() do begin
                                PaymentSchedule.Reset();
                                PaymentSchedule.SetRange("Payment Series", paymentSeriesNos.Get(increment));
                                PaymentSchedule.SetRange("Contract ID", Rec."Contract ID");
                                PaymentSchedule.SetRange("Tenant ID", Rec."Tenant ID");

                                if PaymentSchedule.FindSet() then
                                    repeat
                                        PaymentSchedule."Payment Series" := CopyStr(NewPaymentCode, 1, StrLen(NewPaymentCode));
                                        PaymentSchedule."Due Date" := PaymentChangeReqTable."Due Date";
                                        PaymentSchedule.Modify(true);
                                    until PaymentSchedule.Next() = 0;

                            end;
                        until PaymentChangeReqTable.Next() = 0;
                        Rec.Status := 'Approve';
                        SendmailToTenant.SendTenantEmail(Rec);
                        Message('Payment combine request approved and processed successfully. Tenant has been notified via email.');

                        Rec.Modify();
                    end;

                'Payment Mode':
                    begin
                        PaymentModeRec.Reset();
                        PaymentModeRec.SetRange("Payment Series", PaymentSeries);
                        PaymentModeRec.SetRange("Contract ID", Rec."Contract ID");
                        PaymentModeRec.SetRange("Tenant ID", Rec."Tenant ID");
                        if PaymentModeRec.FindSet() then begin
                            if PaymentModeRec."Payment Mode" = 'Cheque' then begin
                                pdcTransRec.SetRange("Contract ID", PaymentModeRec."Contract ID");
                                pdcTransRec.SetRange("payment Series", PaymentModeRec."Payment Series");
                                pdcTransRec.SetFilter("Cheque Status", '%1', PaymentModeRec."Cheque Status"::"Cheque Received");
                                if pdcTransRec.FindFirst() then begin

                                    Commit();
                                    selectDate.Caption := 'Select Transaction Date';
                                    if selectDate.RunModal() = Action::OK then
                                        Rec."Transaction Date" := selectDate.GetDate();

                                    if Rec."Transaction Date" = 0D then
                                        // Revert status change
                                        Error('Please enter Transaction Date before approval.')
                                    else
                                        PDCCashreceiptEntry.ReversePDCReceivedTransaction(pdcTransRec, 'Payment Method Changed', Rec."Transaction Date");

                                end;
                                PaymentModeRec.Validate("Cheque Status", PaymentModeRec."Cheque Status"::Cancelled);
                            end;
                            PaymentModeRec.Validate("Cheque Status", PaymentModeRec."Cheque Status"::" ");
                            PaymentModeRec."Payment Mode" := ApprovalRec."Payment mode";
                            PaymentModeRec."Cheque Number" := ApprovalRec.C_Cheque_Number;
                            PaymentModeRec."Deposit Bank" := ApprovalRec.C_Deposit_Bank;
                            PaymentModeRec.Modify();
                            //  Message('Updated Payment Mode for Series: %1', PaymentSeries);
                            Rec.Status := 'Approve';
                            SendmailToTenant.SendTenantEmail(Rec);
                            Message('Payment mode change request approved and processed successfully. Tenant has been notified via email.');

                            Rec.Modify();

                        end else
                            Error('Payment Series %1 not found in Payment Mode Table.', PaymentSeries);
                    end;
            end;
        end else
            Error('No matching Approval Record found for Contract ID: %1, Tenant ID: %2, ID: %3',
                Rec."Contract ID", Rec."Tenant ID", Rec."ID");

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
        MergedRecord: Record "Payment Mode2";
        MaxSequence: Integer;
        LastSequence: Text[10];
    begin
        MergedRecord.Reset();
        MergedRecord.SetRange("Contract ID", Rec."Contract ID");

        if MergedRecord.FindSet() then
            repeat
                // Extract the numeric part of the Payment Series
                LastSequence := CopyStr(MergedRecord."Payment Series", 4, StrLen(MergedRecord."Payment Series"));
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