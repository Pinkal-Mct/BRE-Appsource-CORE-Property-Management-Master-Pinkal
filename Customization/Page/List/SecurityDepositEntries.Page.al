page 73209807 "BLRSecurity Deposit Entries"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "BLRSecurityDepositEntry";
    Caption = 'Security Deposit Entries';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."BLREntry No.")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                    ToolTip = 'The unique identifier for the security deposit entry.';
                }
                field("Security Deposit ID"; Rec."BLRSecurity Deposit ID")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                    ToolTip = 'The unique identifier for the security deposit.';
                }
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                    ToolTip = 'The unique identifier for the contract associated with this security deposit.';
                }
                field("Main Security Deposit"; Rec."BLRMain Security Deposit")
                {
                    ApplicationArea = All;
                    Visible = false;
                    Editable = IsFinanceManager;
                    ToolTip = 'The main security deposit amount for the contract.';
                }
                field("BLRSecurityDeposit"; Rec."BLRSecurity Deposit")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                    ToolTip = 'The current security deposit amount for the contract.';
                }
                field("Start Date"; Rec."BLRStart Date")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                    ToolTip = 'The start date of the security deposit entry.';
                }
                field("End Date"; Rec."BLREnd Date")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                    ToolTip = 'The end date of the security deposit entry.';
                }
                field(Status; Rec."BLRStatus")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                    ToolTip = 'The current status of the security deposit entry.';
                }
                field("Total Amount"; Rec."BLRTotal Amount")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                    ToolTip = 'The total amount associated with the security deposit entry.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Approve)
            {
                ApplicationArea = All;
                Caption = 'Approve Entry';
                Image = Approve;
                Visible = IsFinanceManager;
                ToolTip = 'Approve the selected security deposit entry.';

                trigger OnAction()
                var
                    AdjustSecurityDeposit: Record "BLRAdjustmentSecurityDeposit";
                    FinaCalculation: Record "BLRFinalCalculation";
                    CarryForwardGrid: Record "BLRCarryForwardGrid";
                    SecurityDeposit: Record "BLRSecurityDeposit";
                    TenancyContract: Record "BLRTenancyContract";
                    TenancyContractSubpage: Record "BLRTenancyContractSubpage";
                    TerminationAddCharges: Record "BLRAdditionalChargesSub";
                    PendingReceivableGrid: Record "BLRPendingReceviableGrid";
                    ChillarDepositAmount: Decimal;
                    OtherDepositAmount: Decimal;
                    NetBalanceAmount: Decimal;
                    TotalRefundableDeposit: Decimal;
                    TotalClaimAmount: Decimal;
                    AmountIncludingVAT: Decimal;
                    TotalRefundableAmount: Decimal;
                    TotalReceivableAmount: Decimal;
                    NetAmount: Decimal;
                    SummeryNetAmount: Decimal;
                begin
                    if Rec."BLRStatus" = Rec."BLRStatus"::Approved then
                        Error('This entry is already approved');

                    if Confirm('Do you want to approve this entry?', true) then begin

                        // Update main record status
                        if AdjustSecurityDeposit.Get(Rec."BLRSecurity Deposit ID") then begin
                            AdjustSecurityDeposit."BLRStatus" := AdjustSecurityDeposit."BLRStatus"::Approved;

                            // Get the Amount Including VAT from the Adjustment Security Deposit table
                            AmountIncludingVAT := AdjustSecurityDeposit."BLRAmount Including VAT";

                            AdjustSecurityDeposit.Modify();

                            // Get Chillar Deposit amount from Tenancy Contract Subpage
                            ChillarDepositAmount := 0;
                            OtherDepositAmount := 0;
                            TenancyContract.Reset();
                            TenancyContract.SetRange("BLRContract ID", Rec."BLRContract ID");
                            if TenancyContract.FindFirst() then begin

                                TenancyContractSubpage.Reset();
                                TenancyContractSubpage.SetRange(BLRContractID, TenancyContract."BLRContract ID");
                                TenancyContractSubpage.SetRange("BLRSecondary Item Type", 'Chiller Deposit Amount');
                                if TenancyContractSubpage.FindFirst() then
                                    ChillarDepositAmount := TenancyContractSubpage."BLRAmount";

                                // Get Other Deposit amount
                                TenancyContractSubpage.Reset();
                                TenancyContractSubpage.SetRange(BLRContractID, TenancyContract."BLRContract ID");
                                TenancyContractSubpage.SetRange("BLRSecondary Item Type", 'Other Deposit');
                                if TenancyContractSubpage.FindFirst() then
                                    OtherDepositAmount := TenancyContractSubpage."BLRAmount";
                            end;

                            // Calculate Net Balance for Security Deposit
                            NetBalanceAmount := Rec."BLRSecurity Deposit";

                            TotalRefundableDeposit := NetBalanceAmount + ChillarDepositAmount + OtherDepositAmount;

                            // Get the Total Amount from Additional Charges Sub directly from Final Calculation
                            TotalClaimAmount := 0;

                            TerminationAddCharges.Reset();
                            TerminationAddCharges.SetRange("BLRContract ID", Rec."BLRContract ID");
                            if TerminationAddCharges.FindSet() then
                                repeat
                                    TotalClaimAmount += TerminationAddCharges."BLRAmount Including VAT";
                                until TerminationAddCharges.Next() = 0;

                            if TotalClaimAmount = 0 then begin
                                TerminationAddCharges.Reset();
                                TerminationAddCharges.SetRange("BLRContract ID", Rec."BLRContract ID");
                                TerminationAddCharges.CalcSums(BLRAmount);
                                TotalClaimAmount := TerminationAddCharges."BLRAmount";

                                if TotalClaimAmount = 0 then
                                    TotalClaimAmount := GetTotalAmountFromTermination(Rec."BLRContract ID");
                            end;

                            TotalRefundableAmount := 0;
                            TotalReceivableAmount := 0;
                            PendingReceivableGrid.Reset();
                            PendingReceivableGrid.SetRange("BLRContract ID", Rec."BLRContract ID");
                            if PendingReceivableGrid.FindFirst() then begin
                                TotalRefundableAmount := PendingReceivableGrid."BLRTotal Refundable";
                                TotalReceivableAmount := PendingReceivableGrid."BLRTotal Receivable";
                            end;

                            Message('Total Claim Amount calculated: %1', TotalClaimAmount + TotalReceivableAmount);
                            Message('Amount Including VAT from Adjustment Security Deposit: %1', AmountIncludingVAT);

                            FinaCalculation.Reset();
                            FinaCalculation.SetRange("BLRContract ID", Rec."BLRContract ID");
                            if FinaCalculation.FindFirst() then begin
                                FinaCalculation."BLRSecurity Deposit" := Rec."BLRMain Security Deposit";
                                FinaCalculation."BLRAdjustment Security Deposit" := Rec."BLRMain Security Deposit" - Rec."BLRSecurity Deposit";
                                FinaCalculation."BLRNet Balance" := Rec."BLRSecurity Deposit";
                                // Update Chillar Deposit field
                                FinaCalculation."BLRChiller Deposit" := ChillarDepositAmount;
                                FinaCalculation."BLROther Deposit" := OtherDepositAmount;
                                // Update Total Refundable Deposit
                                FinaCalculation."BLRTotal Refundable Deposit" := TotalRefundableDeposit;
                                // Update Total Claim with the sum of Total Amount from Additional Charges Sub
                                FinaCalculation."BLRTotal Claim" := TotalClaimAmount;

                                NetAmount := FinaCalculation."BLRTotal Claim" - FinaCalculation."BLRTotal Refundable Deposit";
                                if NetAmount < 0 then begin
                                    FinaCalculation."BLRTotal Refund" := ABS(NetAmount); // negative value
                                    FinaCalculation."BLRTotal Receive" := 0;
                                end else begin
                                    FinaCalculation."BLRTotal Receive" := ABS(NetAmount); // positive value
                                    FinaCalculation."BLRTotal Refund" := 0;
                                end;

                                // Initialize variables
                                SummeryNetAmount := 0;

                                // Scenario 1: Both are Receivable
                                if ((FinaCalculation."BLRTotal Receive" <> 0) and (TotalReceivableAmount <> 0)) or
                                   ((FinaCalculation."BLRTotal Receive" = 0) and (TotalReceivableAmount <> 0)) or
                                   ((FinaCalculation."BLRTotal Receive" <> 0) and (TotalReceivableAmount = 0)) then begin
                                    SummeryNetAmount := FinaCalculation."BLRTotal Receive" + ABS(TotalReceivableAmount);
                                    FinaCalculation."BLRSummery Net Balance" := SummeryNetAmount;
                                    FinaCalculation."BLRNetRecvFromTheTenant" := SummeryNetAmount;
                                    FinaCalculation."BLRAmount Refundable" := 0;
                                end
                                // Scenario 2: Both are Refund
                                else
                                    if ((FinaCalculation."BLRTotal Refund" <> 0) and (TotalRefundableAmount <> 0)) or
                                   ((FinaCalculation."BLRTotal Refund" <> 0) and (TotalRefundableAmount = 0)) or
                                   ((FinaCalculation."BLRTotal Refund" = 0) and (TotalRefundableAmount <> 0)) then begin
                                        SummeryNetAmount := FinaCalculation."BLRTotal Refund" + ABS(TotalRefundableAmount);
                                        FinaCalculation."BLRSummery Net Balance" := SummeryNetAmount;
                                        FinaCalculation."BLRAmount Refundable" := FinaCalculation."BLRSummery Net Balance";
                                        FinaCalculation."BLRNetRecvFromTheTenant" := 0;
                                    end

                                    // Scenario 3: Refund (500) - Receivable (300) => 200 Amount Refundable
                                    else
                                        if (FinaCalculation."BLRTotal Refund" <> 0) and (TotalReceivableAmount <> 0) then begin
                                            SummeryNetAmount := FinaCalculation."BLRTotal Refund" - TotalReceivableAmount;
                                            FinaCalculation."BLRSummery Net Balance" := SummeryNetAmount;
                                            if SummeryNetAmount > 0 then begin
                                                FinaCalculation."BLRAmount Refundable" := ABS(SummeryNetAmount);
                                                FinaCalculation."BLRNetRecvFromTheTenant" := 0;
                                            end else begin
                                                FinaCalculation."BLRNetRecvFromTheTenant" := ABS(SummeryNetAmount);
                                                FinaCalculation."BLRAmount Refundable" := 0;
                                            end;
                                        end

                                        // Scenario 4: Receive (500) - Refundable (300) => 200 Net Receivable
                                        else
                                            if (FinaCalculation."BLRTotal Receive" <> 0) and (TotalRefundableAmount <> 0) then begin
                                                SummeryNetAmount := FinaCalculation."BLRTotal Receive" - TotalRefundableAmount;
                                                FinaCalculation."BLRSummery Net Balance" := SummeryNetAmount;
                                                if SummeryNetAmount > 0 then begin
                                                    FinaCalculation."BLRNetRecvFromTheTenant" := ABS(SummeryNetAmount);
                                                    FinaCalculation."BLRAmount Refundable" := 0;
                                                end else begin
                                                    FinaCalculation."BLRAmount Refundable" := ABS(SummeryNetAmount);
                                                    FinaCalculation."BLRNetRecvFromTheTenant" := 0;
                                                end;
                                            end;

                                FinaCalculation.Modify();
                                Message('Final Calculation updated with Security Deposit: %1', Rec."BLRMain Security Deposit");
                            end else
                                Message('No Final Calculation record found for Contract ID: %1', Rec."BLRContract ID");
                        end else
                            Message('No Adjustment Security Deposit found');

                        // Handle carry forward grid for security deposits
                        SecurityDeposit.Reset();
                        SecurityDeposit.SetRange("BLRContract ID", Rec."BLRContract ID");

                        if SecurityDeposit.FindSet() then
                            repeat
                                // Check if a Carry Forward Grid record already exists
                                CarryForwardGrid.Reset();
                                CarryForwardGrid.SetRange("BLRContract ID", SecurityDeposit."BLRContract ID");
                                CarryForwardGrid.SetRange("BLRNew Contract ID", SecurityDeposit."BLRNew_Contract ID");
                                CarryForwardGrid.SetRange("BLRTotal Amount", SecurityDeposit."BLRCarry Forward Amount"); // Additional Check

                                if not CarryForwardGrid.FindFirst() then begin
                                    // Create new record only if it doesn't exist
                                    CarryForwardGrid.Init();
                                    // Get the next available Entry No.
                                    CarryForwardGrid."BLREntry No." := GetNextEntryNo();
                                    CarryForwardGrid."BLRContract ID" := SecurityDeposit."BLRContract ID";
                                    CarryForwardGrid."BLRNew Contract ID" := SecurityDeposit."BLRNew_Contract ID";
                                    CarryForwardGrid."BLRTotal Amount" := SecurityDeposit."BLRCarry Forward Amount";
                                    CarryForwardGrid."BLRSecurity Deposit" := 'Security Deposit';
                                    CarryForwardGrid.Insert();
                                end else begin
                                    // Update existing record
                                    CarryForwardGrid."BLRTotal Amount" := SecurityDeposit."BLRCarry Forward Amount";
                                    CarryForwardGrid."BLRSecurity Deposit" := 'Security Deposit';
                                    CarryForwardGrid.Modify();
                                end;
                            until SecurityDeposit.Next() = 0
                        else begin
                            // If no Security Deposit records exist, create a basic Carry Forward Grid record
                            CarryForwardGrid.Reset();
                            CarryForwardGrid.SetRange("BLRContract ID", Rec."BLRContract ID");

                            if not CarryForwardGrid.FindFirst() then begin
                                CarryForwardGrid.Init();
                                // Get the next available Entry No.
                                CarryForwardGrid."BLREntry No." := GetNextEntryNo();
                                CarryForwardGrid."BLRContract ID" := Rec."BLRContract ID";
                                // You'll need to determine the New Contract ID from elsewhere
                                CarryForwardGrid."BLRTotal Amount" := Rec."BLRSecurity Deposit";
                                CarryForwardGrid."BLRSecurity Deposit" := 'Security Deposit';
                                CarryForwardGrid.Insert();
                            end;
                        end;
                        AdditinalchargescashReceipt();
                        Message('Entry has been approved successfully!');
                        // Update entry status
                        Rec."BLRStatus" := Rec."BLRStatus"::Approved;
                        Rec.Modify();
                    end else
                        exit;

                end;
            }
        }

        area(Promoted)
        {
            actionref(Approve_; Approve) { }
        }
    }

    var
        Math: Codeunit Math;
        IsFinanceManager: Boolean;

    local procedure GetNextEntryNo(): Integer
    var
        CarryForwardGrid: Record "BLRCarryForwardGrid";
    begin
        CarryForwardGrid.Reset();
        if CarryForwardGrid.FindLast() then
            exit(CarryForwardGrid."BLREntry No." + 1)
        else
            exit(1);
    end;

    // Add this trigger to check user permissions when the page loads
    trigger OnOpenPage()
    var
        PermissionSet: Record "User Personalization";
    begin
        // Check if the current user has the 'FINANCE MANAGER' profile
        IsFinanceManager := false;
        PermissionSet.SetRange("User ID", UserId());

        if PermissionSet.FindSet() then
            repeat
                if PermissionSet."Profile ID" = 'FINANCE MANAGER' then
                    IsFinanceManager := true;
            until (PermissionSet.Next() = 0) or IsFinanceManager;

        // If user is not a Finance Manager, show error and exit
        if not IsFinanceManager then
            Error('You do not have permission to access this page. Only Finance Managers can access this page.');
    end;

    // Helper function to get the total amount from a parent termination record if needed
    local procedure GetTotalAmountFromTermination(ContractID: Integer): Decimal
    var
        TerminationHeader: Record "BLRAdditionalChargesSub"; // Use the actual table name
        TotalAmount: Decimal;
    begin
        TotalAmount := 0;
        TerminationHeader.Reset();
        TerminationHeader.SetRange("BLRContract ID", ContractID);
        if TerminationHeader.FindFirst() then
            // Try to get TotalAmount field or equivalent
            if TerminationHeader.Get(ContractID) then
                TotalAmount := TerminationHeader."BLRTotal Amount"; // Use the correct field name
        exit(TotalAmount);
    end;

    procedure AdditinalchargescashReceipt()
    var
        GenJnlLine: Record "Gen. Journal Line";
        finalcalculation: Record "BLRFinalCalculation";
        TerminationCharges: Record "BLRTerminationChargesSub";
        PendingReceivableGrid: Record "BLRPendingReceviableGrid";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        BillingCalculation: Record "BLRFinalBillingCalculationGrid";
        finalsettlmentRefund1: Record BLRFinalSettlementRefund;
        PostingDate: Date;
        DocumentNo: Code[20];
        InvoiceNo: Code[20];
        AdditionalInvoiceNo: Code[20];
        RefundDocumentNo: Code[20];
        Tenantid: Code[20];
        Tenantname: Text[100];
        LastLineNo: Integer;
        AppliedAmount: Decimal;
        securitydeposit: Decimal;
        chillerdeposit: Decimal;
        otherdeposit: Decimal;
        Totaladdtionalcharges: Decimal;
        TotalReceivable: Decimal;
        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        ContractID: Integer;
    begin
        JournalTemplateName := 'CASH RECE';
        JournalBatchName := 'DEFAULT';

        // Validate Journal Template and Batch
        if not GenJnlTemplate.Get(JournalTemplateName) then
            Error('The Journal Template %1 does not exist.', JournalTemplateName);

        GenJnlBatch.Reset();
        GenJnlBatch.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlBatch.SetRange(Name, JournalBatchName);
        if GenJnlBatch.IsEmpty() then
            Error('The Journal Batch %1 does not exist for template %2.', JournalBatchName, JournalTemplateName);

        PostingDate := Today();
        DocumentNo := 'REFUND-' + Format(Rec."BLRContract ID");
        RefundDocumentNo := 'REF-' + Format(Rec."BLRContract ID");

        // *** FIXED: Properly retrieve Final Calculation record ***
        finalcalculation.Reset();
        finalcalculation.SetRange("BLRContract ID", Rec."BLRContract ID");
        if not finalcalculation.FindFirst() then
            Error('Final Calculation not found for Contract ID %1', Rec."BLRContract ID");

        // Get values from Final Calculation
        Tenantid := finalcalculation."BLRTenant ID";
        Tenantname := finalcalculation."BLRTenant Name";
        ContractID := finalcalculation."BLRContract ID";
        securitydeposit := Round(finalcalculation."BLRNet Balance");
        chillerdeposit := Round(finalcalculation."BLRChiller Deposit");
        otherdeposit := Round(finalcalculation."BLROther Deposit");

        TerminationCharges.Reset();
        TerminationCharges.SetRange("BLRContract ID", Rec."BLRContract ID");
        if TerminationCharges.FindFirst() then
            AdditionalInvoiceNo := TerminationCharges."BLRPosted Invoice ID"
        else
            AdditionalInvoiceNo := '';


        // *** FIXED: Properly retrieve Billing Calculation ***
        BillingCalculation.Reset();
        BillingCalculation.SetRange("BLRContract ID", Rec."BLRContract ID");
        if BillingCalculation.FindFirst() then
            InvoiceNo := BillingCalculation."BLRPosted Invoice ID"
        else
            InvoiceNo := '';


        // Calculate total additional charges
        Totaladdtionalcharges := 0;
        TerminationCharges.Reset();
        TerminationCharges.SetRange("BLRContract ID", Rec."BLRContract ID");
        if TerminationCharges.FindSet() then
            repeat
                Totaladdtionalcharges += TerminationCharges."BLRAmount Including VAT";
            until TerminationCharges.Next() = 0;

        // Get total receivable from Pending Receivable Grid
        TotalReceivable := 0;
        PendingReceivableGrid.Reset();
        PendingReceivableGrid.SetRange("BLRContract ID", Rec."BLRContract ID");
        if PendingReceivableGrid.FindFirst() then
            TotalReceivable := PendingReceivableGrid."BLRTotal Receivable";

        // Debug message for amounts
        if (securitydeposit = 0) and (chillerdeposit = 0) and (otherdeposit = 0) then
            Error('No deposit amounts found to process for Contract ID %1', Rec."BLRContract ID");

        // Get last line number
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        if GenJnlLine.FindLast() then
            LastLineNo := GenJnlLine."Line No." + 10000
        else
            LastLineNo := 10000;

        // *** SECURITY DEPOSIT PROCESSING ***
        while (securitydeposit > 0) and ((Totaladdtionalcharges > 0) or (TotalReceivable > 0)) do
            if Totaladdtionalcharges > 0 then begin
                AppliedAmount := Min(securitydeposit, Totaladdtionalcharges);

                if Tenantid = '' then
                    Error('Tenant ID is blank for Contract ID %1', Rec."BLRContract ID");

                // Create journal line for Additional Charges
                Clear(GenJnlLine);
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name" := JournalTemplateName;
                GenJnlLine."Journal Batch Name" := JournalBatchName;
                GenJnlLine."Line No." := LastLineNo;
                GenJnlLine."Posting Date" := PostingDate;
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No." := DocumentNo;
                GenJnlLine.Description := Tenantname + ' - Security Deposit';
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                GenJnlLine."Account No." := Tenantid;
                GenJnlLine."BLRContract ID" := ContractID;
                GenJnlLine.Amount := Round(-AppliedAmount);
                GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '4502';
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := AdditionalInvoiceNo;
                GenJnlLine.Insert(true);

                securitydeposit -= AppliedAmount;
                Totaladdtionalcharges -= AppliedAmount;
                LastLineNo += 10000;

            end else
                if TotalReceivable > 0 then begin
                    AppliedAmount := Min(securitydeposit, TotalReceivable);

                    // Create journal line for Receivable
                    Clear(GenJnlLine);
                    GenJnlLine.Init();
                    GenJnlLine."Journal Template Name" := JournalTemplateName;
                    GenJnlLine."Journal Batch Name" := JournalBatchName;
                    GenJnlLine."Line No." := LastLineNo;
                    GenJnlLine."Posting Date" := PostingDate;
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine."Document No." := DocumentNo;
                    GenJnlLine.Description := Tenantname + ' - Security Deposit';
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                    GenJnlLine."Account No." := Tenantid;
                    GenJnlLine."BLRContract ID" := ContractID;
                    GenJnlLine.Amount := Round(-AppliedAmount);
                    GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                    GenJnlLine."Bal. Account No." := '4502';
                    GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                    GenJnlLine."Applies-to Doc. No." := InvoiceNo;
                    GenJnlLine.Insert(true);

                    securitydeposit -= AppliedAmount;
                    TotalReceivable -= AppliedAmount;
                    LastLineNo += 10000;
                end;

        while (chillerdeposit > 0) and ((Totaladdtionalcharges > 0) or (TotalReceivable > 0)) do
            if Totaladdtionalcharges > 0 then begin
                AppliedAmount := Min(chillerdeposit, Totaladdtionalcharges);

                if Tenantid = '' then
                    Error('Tenant ID is blank for Contract ID %1', Rec."BLRContract ID");

                Clear(GenJnlLine);
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name" := JournalTemplateName;
                GenJnlLine."Journal Batch Name" := JournalBatchName;
                GenJnlLine."Line No." := LastLineNo;
                GenJnlLine."Posting Date" := PostingDate;
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No." := DocumentNo;
                GenJnlLine.Description := Tenantname + ' - Chiller Deposit';
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                GenJnlLine."Account No." := Tenantid;
                GenJnlLine."BLRContract ID" := ContractID;
                GenJnlLine.Amount := Round(-AppliedAmount);
                GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '4508';
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := AdditionalInvoiceNo;
                GenJnlLine.Insert(true);

                chillerdeposit -= AppliedAmount;
                Totaladdtionalcharges -= AppliedAmount;
                LastLineNo += 10000;

            end else
                if TotalReceivable > 0 then begin
                    AppliedAmount := Min(chillerdeposit, TotalReceivable);

                    Clear(GenJnlLine);
                    GenJnlLine.Init();
                    GenJnlLine."Journal Template Name" := JournalTemplateName;
                    GenJnlLine."Journal Batch Name" := JournalBatchName;
                    GenJnlLine."Line No." := LastLineNo;
                    GenJnlLine."Posting Date" := PostingDate;
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine."Document No." := DocumentNo;
                    GenJnlLine.Description := Tenantname + ' - Chiller Deposit';
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                    GenJnlLine."Account No." := Tenantid;
                    GenJnlLine."BLRContract ID" := ContractID;
                    GenJnlLine.Amount := Round(-AppliedAmount);
                    GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                    GenJnlLine."Bal. Account No." := '4508';
                    GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                    GenJnlLine."Applies-to Doc. No." := InvoiceNo;
                    GenJnlLine.Insert(true);

                    chillerdeposit -= AppliedAmount;
                    TotalReceivable -= AppliedAmount;
                    LastLineNo += 10000;
                end;

        while (otherdeposit > 0) and ((Totaladdtionalcharges > 0) or (TotalReceivable > 0)) do
            if Totaladdtionalcharges > 0 then begin
                AppliedAmount := Min(otherdeposit, Totaladdtionalcharges);

                if Tenantid = '' then
                    Error('Tenant ID is blank for Contract ID %1', Rec."BLRContract ID");

                Clear(GenJnlLine);
                GenJnlLine.Init();
                GenJnlLine."Journal Template Name" := JournalTemplateName;
                GenJnlLine."Journal Batch Name" := JournalBatchName;
                GenJnlLine."Line No." := LastLineNo;
                GenJnlLine."Posting Date" := PostingDate;
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                GenJnlLine."Document No." := DocumentNo;
                GenJnlLine.Description := Tenantname + ' - Other Deposit';
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                GenJnlLine."Account No." := Tenantid;
                GenJnlLine."BLRContract ID" := ContractID;
                GenJnlLine.Amount := Round(-AppliedAmount);
                GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Bal. Account No." := '4508';
                GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                GenJnlLine."Applies-to Doc. No." := AdditionalInvoiceNo;
                GenJnlLine.Insert(true);

                otherdeposit -= AppliedAmount;
                Totaladdtionalcharges -= AppliedAmount;
                LastLineNo += 10000;

            end else
                if TotalReceivable > 0 then begin
                    AppliedAmount := Min(otherdeposit, TotalReceivable);

                    Clear(GenJnlLine);
                    GenJnlLine.Init();
                    GenJnlLine."Journal Template Name" := JournalTemplateName;
                    GenJnlLine."Journal Batch Name" := JournalBatchName;
                    GenJnlLine."Line No." := LastLineNo;
                    GenJnlLine."Posting Date" := PostingDate;
                    GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
                    GenJnlLine."Document No." := DocumentNo;
                    GenJnlLine.Description := Tenantname + ' - Other Deposit';
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
                    GenJnlLine."Account No." := Tenantid;
                    GenJnlLine."BLRContract ID" := ContractID;
                    GenJnlLine.Amount := Round(-AppliedAmount);
                    GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
                    GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                    GenJnlLine."Bal. Account No." := '4508';
                    GenJnlLine."Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type"::Invoice;
                    GenJnlLine."Applies-to Doc. No." := InvoiceNo;
                    GenJnlLine.Insert(true);

                    otherdeposit -= AppliedAmount;
                    TotalReceivable -= AppliedAmount;
                    LastLineNo += 10000;
                end;

        // *** NEW: REFUND REMAINING DEPOSITS ***
        // Update Final Settlement Refund with remaining amounts
        finalsettlmentRefund1.Reset();
        finalsettlmentRefund1.SetRange("BLRContract ID", Rec."BLRContract ID");
        if finalsettlmentRefund1.FindFirst() then begin
            finalsettlmentRefund1."BLRAdjust Security Deposit" := securitydeposit;
            finalsettlmentRefund1."BLRAdjust Chiller Deposit" := chillerdeposit;
            finalsettlmentRefund1."BLRAdjust other deposit" := otherdeposit;
            finalsettlmentRefund1.Modify();
        end;

        // Create REFUND entries for remaining deposits
        if securitydeposit > 0 then begin
            Clear(GenJnlLine);
            GenJnlLine.Init();
            GenJnlLine."Journal Template Name" := JournalTemplateName;
            GenJnlLine."Journal Batch Name" := JournalBatchName;
            GenJnlLine."Line No." := LastLineNo;
            GenJnlLine."Posting Date" := PostingDate;
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
            GenJnlLine."Document No." := RefundDocumentNo;
            GenJnlLine.Description := Tenantname + ' - Security Deposit Refund';
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := '4502';  // Security Deposit Account
            GenJnlLine."BLRContract ID" := ContractID;
            GenJnlLine.Amount := Round(-securitydeposit);  // Credit G/L (reduce liability)
            GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Customer;
            GenJnlLine."Bal. Account No." := Tenantid;  // Debit Customer (refund to tenant)
            GenJnlLine.Insert(true);
            LastLineNo += 10000;
        end;

        if chillerdeposit > 0 then begin
            Clear(GenJnlLine);
            GenJnlLine.Init();
            GenJnlLine."Journal Template Name" := JournalTemplateName;
            GenJnlLine."Journal Batch Name" := JournalBatchName;
            GenJnlLine."Line No." := LastLineNo;
            GenJnlLine."Posting Date" := PostingDate;
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
            GenJnlLine."Document No." := RefundDocumentNo;
            GenJnlLine.Description := Tenantname + ' - Chiller Deposit Refund';
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := '4508';  // Chiller Deposit Account
            GenJnlLine.Amount := Round(-chillerdeposit);
            GenJnlLine."BLRContract ID" := ContractID;
            GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Customer;
            GenJnlLine."Bal. Account No." := Tenantid;
            GenJnlLine.Insert(true);
            LastLineNo += 10000;
        end;

        if otherdeposit > 0 then begin
            Clear(GenJnlLine);
            GenJnlLine.Init();
            GenJnlLine."Journal Template Name" := JournalTemplateName;
            GenJnlLine."Journal Batch Name" := JournalBatchName;
            GenJnlLine."Line No." := LastLineNo;
            GenJnlLine."Posting Date" := PostingDate;
            GenJnlLine."Document Type" := GenJnlLine."Document Type"::Refund;
            GenJnlLine."Document No." := RefundDocumentNo;
            GenJnlLine.Description := Tenantname + ' - Other Deposit Refund';
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := '4508';  // Other Deposit Account
            GenJnlLine.Amount := Round(-otherdeposit);
            GenJnlLine."BLRContract ID" := ContractID;
            GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::Customer;
            GenJnlLine."Bal. Account No." := Tenantid;
            GenJnlLine.Insert(true);
            LastLineNo += 10000;
        end;

        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        if GenJnlLine.FindFirst() then begin
            if Confirm('Do you want to post journal lines?', true) then begin
                Codeunit.Run(Codeunit::"Gen. Jnl.-Post", GenJnlLine);
                Message('Journal entries have been created and posted successfully');
            end;
        end else
            Message('No journal lines were created. Please check the data for Contract ID: %1', Rec."BLRContract ID");
    end;

    procedure Min(a: Decimal; b: Decimal): Decimal
    begin
        if a < b then
            exit(a)
        else
            exit(b);
    end;
}