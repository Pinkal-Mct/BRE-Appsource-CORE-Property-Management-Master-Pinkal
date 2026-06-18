page 73209759 "BLRAdjustmentDeposits"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "BLRAdjustmentDeposits";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."BLREntry No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Unique identifier for each adjustment or refund entry.';
                }
                field("Contract Id"; Rec."BLRContract Id")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the contract associated with the adjustment or refund.';
                }
                field("Item Description"; Rec."BLRItem Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of deposit being adjusted or refunded.';
                    trigger OnValidate()
                    begin
                        ClearAllFields();
                        ClearNarration();
                    end;
                }
                field("Transaction Type"; Rec."BLRTransaction Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the deposit is to be refunded or adjusted.';

                    trigger OnValidate()
                    begin
                        ClearNarration();
                        UpdateNarration();
                        RefundValidateDepositAmount(Rec);
                        checkedadjustement();

                    end;
                }
                field(Amount; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the amount to be refunded or adjusted.';

                    trigger OnValidate()
                    begin
                        ValidateAmount();
                    end;

                }
                field("Posting Date"; Rec."BLRPosting Date")
                {
                    ApplicationArea = All;
                }
                field(Narration; Rec."BLRNarration")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Shows narration based on the transaction type selected.';
                }
                field(Adjusted; Rec."BLRAdjusted")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether this record has been processed for refund or adjustment. Once marked as adjusted, the record cannot be edited.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(PrevireRefund)
            {
                Caption = 'Preview Refund';
                Image = View;
                ToolTip = 'Preview the refund journal lines before posting.';
                trigger OnAction()
                var
                    adjustmentDepositsRec: Record "BLRAdjustmentDeposits";
                    GenJournalLineRec: Record "Gen. Journal Line";
                    Previewed: Boolean;
                begin
                    GenJournalLineRec.SetRange("Journal Template Name", 'GENERAL');
                    GenJournalLineRec.SetRange("Journal Batch Name", 'DEFAULT');
                    if GenJournalLineRec.FindSet() then
                        GenJournalLineRec.DeleteAll();

                    adjustmentDepositsRec.SetRange("BLRContract ID", Rec."BLRContract ID");
                    adjustmentDepositsRec.SetRange("BLRTransaction Type", Rec."BLRTransaction Type"::Refund);
                    adjustmentDepositsRec.SetRange(BLRAdjusted, false);
                    if adjustmentDepositsRec.FindSet() then
                        repeat
                            if adjustmentDepositsRec."BLRPosting Date" <> 0D then begin
                                Previewed := true;
                                RefundDepositAmount(adjustmentDepositsRec, Previewed);
                            end
                            else
                                Error('Please enter a valid posting date before previewing the refund.');
                        until adjustmentDepositsRec.Next() = 0
                    else
                        Error('No refund entries found to post for this contract or all entries have already been refunded.');

                end;
            }
            action(PostRefund)
            {
                Caption = 'Post Refund';
                Image = PrepaymentPost;
                ToolTip = 'Previews the refund journal entry before posting.';
                trigger OnAction()
                var
                    adjustmentDepositsRec: Record "BLRAdjustmentDeposits";
                    GenJournalLineRec: Record "Gen. Journal Line";
                    TenancyContractRec: Record "BLRTenancyContract";
                    Previewed: Boolean;
                begin

                    GenJournalLineRec.SetRange("Journal Template Name", 'GENERAL');
                    GenJournalLineRec.SetRange("Journal Batch Name", 'REFUND');
                    if GenJournalLineRec.FindSet() then
                        GenJournalLineRec.DeleteAll();

                    adjustmentDepositsRec.SetRange("BLRContract ID", Rec."BLRContract ID");
                    adjustmentDepositsRec.SetRange("BLRTransaction Type", Rec."BLRTransaction Type"::Refund);
                    adjustmentDepositsRec.SetRange(BLRAdjusted, false);
                    if adjustmentDepositsRec.FindSet() then
                        repeat
                            if adjustmentDepositsRec."BLRPosting Date" <> 0D then begin

                                Previewed := false;
                                RefundDepositAmount(adjustmentDepositsRec, Previewed);
                                if adjustmentDepositsRec."BLRItem Description" = adjustmentDepositsRec."BLRItem Description"::"Security Deposit" then begin
                                    TenancyContractRec.SetRange("BLRContract ID", adjustmentDepositsRec."BLRContract ID");
                                    if TenancyContractRec.FindFirst() then begin
                                        TenancyContractRec.Validate(BLRRefund, TenancyContractRec.BLRRefund + adjustmentDepositsRec."BLRAmount");
                                        TenancyContractRec.Modify();
                                    end
                                    else
                                        Error('Please enter a valid posting date before posting the refund.');

                                end;
                            end;
                        until adjustmentDepositsRec.Next() = 0
                    else
                        Error('No refund entries found to post for this contract or all entries have already been refunded.');


                end;
            }
            action(Post)
            {
                Caption = 'Post Adjustment';
                Image = Post;
                ToolTip = 'Posts the adjustment to the ledger and opens the Cash Receipt Journal for review.';

                trigger OnAction()
                var
                    adjustmentDepositsRec: Record "BLRAdjustmentDeposits";
                    GenJnlLine: Record "Gen. Journal Line";
                begin
                    GenJnlLine.Reset();
                    GenJnlLine.SetRange("Journal Template Name", 'CASH RECE');
                    GenJnlLine.SetRange("Journal Batch Name", 'DEFAULT');
                    if GenJnlLine.FindSet() then
                        GenJnlLine.DeleteAll();

                    adjustmentDepositsRec.SetRange("BLRContract ID", Rec."BLRContract ID");
                    adjustmentDepositsRec.SetRange("BLRTransaction Type", Rec."BLRTransaction Type"::Adjustment);
                    adjustmentDepositsRec.SetRange(BLRAdjusted, false);
                    if adjustmentDepositsRec.FindSet() then begin
                        repeat
                            if adjustmentDepositsRec."BLRPosting Date" <> 0D then
                                AdditinalchargescashReceipt(adjustmentDepositsRec)
                            else
                                Error('Please enter a valid posting date before posting the adjustment.');
                        until adjustmentDepositsRec.Next() = 0;
                        Commit();
                        PAGE.Run(PAGE::"Cash Receipt Journal");
                    end
                    else
                        Error('No adjustment entries found to post for this contract or all entries have already been adjusted.');
                    // Commit created journal lines and open Cash Receipt Journals for user review
                end;
            }
        }
    }

    var
        refundNarrationLbl: Label '%1 refund for contract ID "%2"', Comment = '%1 = Item Description, %2 = Contract ID';
        adjustnarrationLbl: Label '%1 adjusted with other receivables for contract ID "%2"', Comment = '%1 = Item Description, %2 = Contract ID';
        errorSDamountLbl: Label 'Amount should be less than or equal to the Security Deposit amount.', Comment = 'Error message when Security Deposit amount is invalid.';
        errorChilleramountLbl: Label 'Amount should be less than or equal to the Chiller Deposit amount.', Comment = 'Error message when Chiller Deposit amount is invalid.';
        errorOtheramountLbl: Label 'Amount should be less than or equal to the Other Deposit amount.', Comment = 'Error message when Other Deposit amount is invalid.';

    procedure UpdateNarration()
    begin
        case Rec."BLRTransaction Type" of
            Rec."BLRTransaction Type"::Refund:
                Rec."BLRNarration" := StrSubstNo(refundNarrationLbl, Rec."BLRItem Description", Rec."BLRContract Id");
            Rec."BLRTransaction Type"::Adjustment:
                Rec."BLRNarration" := StrSubstNo(adjustnarrationLbl, Rec."BLRItem Description", Rec."BLRContract Id");
            Rec."BLRTransaction Type"::" ":
                Rec."BLRNarration" := '';
        end;
    end;

    procedure ClearNarration()
    begin
        Rec."BLRNarration" := '';
    end;

    procedure ValidateAmount()
    var
        finalCalculationRec: Record "BLRFinalCalculation";
    begin
        finalCalculationRec.SetRange("BLRContract ID", Rec."BLRContract Id");
        if finalCalculationRec.FindFirst() then
            if Rec."BLRTransaction Type" = Rec."BLRTransaction Type"::Refund then
                case Rec."BLRItem Description" of
                    Rec."BLRItem Description"::"Security Deposit":
                        if Rec."BLRAmount" > finalCalculationRec."BLRRemaining Security Deposit" then
                            Error(errorSDamountLbl);
                    Rec."BLRItem Description"::"Chiller Deposit":
                        if Rec."BLRAmount" > finalCalculationRec."BLRRemaining Chiller Deposit" then
                            Error(errorChilleramountLbl);
                    Rec."BLRItem Description"::"Other Deposit":
                        if Rec."BLRAmount" > finalCalculationRec."BLRRemaining Other Deposit" then
                            Error(errorOtheramountLbl);
                end
            else
                case Rec."BLRItem Description" of
                    Rec."BLRItem Description"::"Security Deposit":
                        if Rec."BLRAmount" > finalCalculationRec."BLRRemaining Security Deposit" then
                            Error(errorSDamountLbl);
                    Rec."BLRItem Description"::"Chiller Deposit":
                        if Rec."BLRAmount" > finalCalculationRec."BLRRemaining Chiller Deposit" then
                            Error(errorChilleramountLbl);
                    Rec."BLRItem Description"::"Other Deposit":
                        if Rec."BLRAmount" > finalCalculationRec."BLRRemaining Other Deposit" then
                            Error(errorOtheramountLbl);
                end
    end;

    procedure ClearAllFields()
    begin
        Rec."BLRTransaction Type" := Rec."BLRTransaction Type"::" ";
        Rec."BLRAmount" := 0;
    end;

    procedure AdditinalchargescashReceipt(adjustmentDepositsRec: Record "BLRAdjustmentDeposits")
    var
        GenJnlLine: Record "Gen. Journal Line";
        finalcalculation: Record "BLRFinalCalculation";

        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";

        CustomerCard: Record Customer;

        COASetupLine: Record "BLRCOASetupLine";

        PostingDate: Date;
        DocumentNo: Code[20];

        Tenantid: Code[20];
        Tenantname: Text[250];
        LastLineNo: Integer;
        AppliedAmount: Decimal;

        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        ContractID: Integer;

        BalanceAccountNo: Code[20];

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



        // Only process Adjustment transaction types in this procedure
        if ((adjustmentDepositsRec."BLRTransaction Type" = adjustmentDepositsRec."BLRTransaction Type"::Adjustment) AND (adjustmentDepositsRec."BLRAmount" = 0)) or (adjustmentDepositsRec."BLRTransaction Type" = adjustmentDepositsRec."BLRTransaction Type"::Refund) then
            exit;

        // Use a clear document number for adjustment postings
        DocumentNo := 'ADJUSTMENT-' + Format(adjustmentDepositsRec."BLRContract ID");

        // Retrieve Final Calculation record
        finalcalculation.Reset();
        finalcalculation.SetRange("BLRContract ID", adjustmentDepositsRec."BLRContract ID");
        if not finalcalculation.FindFirst() then
            Error('Final Calculation not found for Contract ID %1', adjustmentDepositsRec."BLRContract ID");

        // Get values from Final Calculation
        Tenantid := finalcalculation."BLRTenant ID";
        Tenantname := finalcalculation."BLRTenant Name";
        ContractID := finalcalculation."BLRContract ID";




        // Retrieve Termination Charges (additional charges) and calculate totals

        AppliedAmount := adjustmentDepositsRec."BLRAmount";

        // Create General Journal Line
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        if GenJnlLine.FindLast() then
            LastLineNo := GenJnlLine."Line No." + 10000
        else
            LastLineNo := 10000;

        // case adjustmentDepositsRec."BLRItem Description" of
        //     adjustmentDepositsRec."BLRItem Description"::"BLRSecurityDeposit":
        //         BalanceAccountNo := '4502';
        //     adjustmentDepositsRec."BLRItem Description"::"Chiller Deposit",
        //     adjustmentDepositsRec."BLRItem Description"::"Other Deposit":
        //         BalanceAccountNo := '4508';
        // end;

        COASetupLine.SetRange("BLRSecondary Item", Format(adjustmentDepositsRec."BLRItem Description"));
        if COASetupLine.FindFirst() then begin
            if (COASetupLine.BLRResidential = '') and (COASetupLine.BLRCommercial = '') then
                Error('COA Setup doest not exist or no G/L account has been selected for %1', adjustmentDepositsRec."BLRItem Description")
            else
                if COASetupLine.BLRResidential <> '' then
                    BalanceAccountNo := COASetupLine.BLRResidential
                else
                    BalanceAccountNo := COASetupLine.BLRCommercial;


        end
        else
            Error('COA Setup doest not exist or no G/L account has been selected for %1', adjustmentDepositsRec."BLRItem Description");


        if finalcalculation."BLRUnit Type" <> '' then begin
            CustomerCard.Reset();
            CustomerCard.SetRange("No.", finalcalculation."BLRTenant ID");
            if CustomerCard.FindFirst() then begin
                CustomerCard.Validate("Gen. Bus. Posting Group", finalcalculation."BLRUnit Type");
                CustomerCard.Validate("Customer Posting Group", finalcalculation."BLRUnit Type");
                CustomerCard.Modify();
            end;
        end;





        // Insert a single cash receipt journal line for this adjustment record
        Clear(GenJnlLine);
        GenJnlLine.Init();
        GenJnlLine."Journal Template Name" := JournalTemplateName;
        GenJnlLine."Journal Batch Name" := JournalBatchName;
        GenJnlLine."Line No." := LastLineNo;
        GenJnlLine."Posting Date" := adjustmentDepositsRec."BLRPosting Date";
        GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Document No." := DocumentNo;
        GenJnlLine.Description := adjustmentDepositsRec."BLRNarration";
        GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
        GenJnlLine."Account No." := Tenantid;
        GenJnlLine."BLRContract ID" := ContractID;
        GenJnlLine.Amount := Round(-AppliedAmount);
        GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
        GenJnlLine."BLRItem Description" := adjustmentDepositsRec."BLRItem Description";
        GenJnlLine."BLRTransaction Type" := adjustmentDepositsRec."BLRTransaction Type";
        GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
        GenJnlLine."Bal. Account No." := BalanceAccountNo;
        // Do not set Applies-to fields since we don't need Posted Invoice IDs for adjustments
        GenJnlLine.Insert(true);
        LastLineNo += 10000;
    end;

    procedure RefundDepositAmount(adjustmentDepositsRec: Record "BLRAdjustmentDeposits"; Previewed: Boolean)
    var
        GenJnlLine: Record "Gen. Journal Line";
        finalcalculation: Record "BLRFinalCalculation";

        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";

        CustomerCard: Record Customer;

        COASetupLine: Record "BLRCOASetupLine";
        GenJnlPost: Codeunit "Gen. Jnl.-Post";

        PostingDate: Date;
        DocumentNo: Code[20];

        Tenantid: Code[20];
        Tenantname: Text[250];
        LastLineNo: Integer;
        AppliedAmount: Decimal;

        JournalTemplateName: Code[10];
        JournalBatchName: Code[10];
        ContractID: Integer;

        BalanceAccountNo: Code[20];

    begin
        JournalTemplateName := 'GENERAL';
        JournalBatchName := 'DEFAULT';

        // Validate Journal Template and Batch
        if not GenJnlTemplate.Get(JournalTemplateName) then
            Error('The Journal Template %1 does not exist.', JournalTemplateName);

        GenJnlBatch.Reset();
        GenJnlBatch.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlBatch.SetRange(Name, JournalBatchName);
        if GenJnlBatch.IsEmpty() then
            Error('The Journal Batch %1 does not exist for template %2.', JournalBatchName, JournalTemplateName);



        // Only process Adjustment transaction types in this procedure
        if ((adjustmentDepositsRec."BLRTransaction Type" = adjustmentDepositsRec."BLRTransaction Type"::Refund) AND (adjustmentDepositsRec."BLRAmount" = 0)) or (adjustmentDepositsRec."BLRTransaction Type" = adjustmentDepositsRec."BLRTransaction Type"::Adjustment) then
            exit;

        // Use a clear document number for adjustment postings
        DocumentNo := 'ADJUSTMENT-' + Format(adjustmentDepositsRec."BLRContract ID");

        // Retrieve Final Calculation record
        finalcalculation.Reset();
        finalcalculation.SetRange("BLRContract ID", adjustmentDepositsRec."BLRContract ID");
        if not finalcalculation.FindFirst() then
            Error('Final Calculation not found for Contract ID %1', adjustmentDepositsRec."BLRContract ID");

        // Get values from Final Calculation
        Tenantid := finalcalculation."BLRTenant ID";
        Tenantname := finalcalculation."BLRTenant Name";
        ContractID := finalcalculation."BLRContract ID";




        // Retrieve Termination Charges (additional charges) and calculate totals

        AppliedAmount := adjustmentDepositsRec."BLRAmount";

        // Create General Journal Line
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", JournalTemplateName);
        GenJnlLine.SetRange("Journal Batch Name", JournalBatchName);
        if GenJnlLine.FindLast() then
            LastLineNo := GenJnlLine."Line No." + 10000
        else
            LastLineNo := 10000;

        // case adjustmentDepositsRec."BLRItem Description" of
        //     adjustmentDepositsRec."BLRItem Description"::"BLRSecurityDeposit":
        //         BalanceAccountNo := '4502';
        //     adjustmentDepositsRec."BLRItem Description"::"Chiller Deposit",
        //     adjustmentDepositsRec."BLRItem Description"::"Other Deposit":
        //         BalanceAccountNo := '4508';
        // end;

        COASetupLine.SetRange("BLRSecondary Item", Format(adjustmentDepositsRec."BLRItem Description"));
        if COASetupLine.FindFirst() then begin
            if (COASetupLine.BLRResidential = '') and (COASetupLine.BLRCommercial = '') then
                Error('COA Setup doest not exist or no G/L account has been selected for %1', adjustmentDepositsRec."BLRItem Description")
            else
                if COASetupLine.BLRResidential <> '' then
                    BalanceAccountNo := COASetupLine.BLRResidential
                else
                    BalanceAccountNo := COASetupLine.BLRCommercial;

        end
        else
            Error('COA Setup doest not exist or no G/L account has been selected for %1', adjustmentDepositsRec."BLRItem Description");
        if finalcalculation."BLRUnit Type" <> '' then begin
            CustomerCard.Reset();
            CustomerCard.SetRange("No.", finalcalculation."BLRTenant ID");
            if CustomerCard.FindFirst() then begin
                CustomerCard.Validate("Gen. Bus. Posting Group", finalcalculation."BLRUnit Type");
                CustomerCard.Validate("Customer Posting Group", finalcalculation."BLRUnit Type");
                CustomerCard.Modify();
            end;
        end;


        // Insert a single cash receipt journal line for this adjustment record
        Clear(GenJnlLine);
        GenJnlLine.Init();
        GenJnlLine.Validate("Journal Template Name", JournalTemplateName);
        GenJnlLine.Validate("Journal Batch Name", JournalBatchName);
        GenJnlLine."Line No." := LastLineNo;
        GenJnlLine."Posting Date" := adjustmentDepositsRec."BLRPosting Date";
        //GenJnlLine."Document Type" := GenJnlLine."Document Type"::Payment;
        GenJnlLine."Document No." := DocumentNo;
        GenJnlLine.Validate("Account Type", GenJnlLine."Account Type"::Customer);
        GenJnlLine.Validate("Account No.", Tenantid);
        GenJnlLine.Description := adjustmentDepositsRec."BLRNarration";
        GenJnlLine."BLRContract ID" := ContractID;
        GenJnlLine.Validate("Amount", Round(-AppliedAmount));
        GenJnlLine."BLRItem Description" := adjustmentDepositsRec."BLRItem Description";
        GenJnlLine."BLRTransaction Type" := adjustmentDepositsRec."BLRTransaction Type";
        GenJnlLine.Validate("Bal. Account Type", GenJnlLine."Bal. Account Type"::"G/L Account");
        GenJnlLine.Validate("Bal. Account No.", BalanceAccountNo);
        // Do not set Applies-to fields since we don't need Posted Invoice IDs for adjustments
        GenJnlLine.Insert(true);
        LastLineNo += 10000;

        if not Previewed then
            GenJnlPost.Run(GenJnlLine)
        else begin

            Commit();
            GenJnlPost.Preview(GenJnlLine);
        end;
    end;


    // Validate deposit amount

    procedure RefundValidateDepositAmount(var adjustmenrtDepositsRec: Record "BLRAdjustmentDeposits")
    var
        finalcalculationRec: Record "BLRFinalCalculation";
    begin
        finalcalculationRec.SetRange("BLRContract ID", adjustmenrtDepositsRec."BLRContract Id");
        if finalcalculationRec.FindFirst() then
            if adjustmenrtDepositsRec."BLRTransaction Type" = adjustmenrtDepositsRec."BLRTransaction Type"::Refund then begin
                if finalcalculationRec."BLRTotal Claim" <> 0 then
                    case adjustmenrtDepositsRec."BLRItem Description" of
                        adjustmenrtDepositsRec."BLRItem Description"::"Security Deposit":
                            if finalcalculationRec."BLRRemaining Security Deposit" = 0 then
                                Error('No Security Deposit available for refund.');
                        adjustmenrtDepositsRec."BLRItem Description"::"Chiller Deposit":
                            if finalcalculationRec."BLRRemaining Chiller Deposit" = 0 then
                                Error('No Chiller Deposit available for refund.');
                        adjustmenrtDepositsRec."BLRItem Description"::"Other Deposit":
                            if finalcalculationRec."BLRRemaining Other Deposit" = 0 then
                                Error('No Other Deposit available for refund.');
                    end;

            end
            else
                if finalcalculationRec."BLRTotal Claim" = 0 then
                    Error('Adjustment cannot be processed because no claim amount is available for contract  %1', Rec."BLRContract Id");


    end;

    procedure checkedadjustement()
    var
        adjustmentdepositsRec: Record "BLRAdjustmentDeposits";
    begin
        adjustmentdepositsRec.SetRange("BLRContract Id", Rec."BLRContract Id");
        adjustmentdepositsRec.SetRange("BLRItem Description", Rec."BLRItem Description");
        adjustmentdepositsRec.SetRange("BLRTransaction Type", Rec."BLRTransaction Type");
        adjustmentdepositsRec.SetRange(BLRAdjusted, true);
        if adjustmentdepositsRec.FindFirst()
        then
            Error('%1 - %2 entry already exists for this contract', adjustmentdepositsRec."BLRItem Description", adjustmentdepositsRec."BLRTransaction Type");

    end;
}