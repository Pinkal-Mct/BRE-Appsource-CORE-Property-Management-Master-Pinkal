codeunit 73209621 "BLRLedgerEntries Event Handler"
{
    Permissions = TableData "VAT Entry" = rimd;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnPostItemJnlLineOnAfterCopyDocumentFields, '', false, false)]
    local procedure OnPostItemJnlLineOnAfterCopyDocumentFields(var ItemJournalLine: Record "Item Journal Line"; SalesLine: Record "Sales Line"; WarehouseReceiptHeader: Record "Warehouse Receipt Header"; WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        ItemJournalLine."BLRContract ID" := SalesLine."BLRContract ID";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnAfterInitItemLedgEntry, '', false, false)]
    local procedure OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer)
    begin
        NewItemLedgEntry."BLRContract ID" := ItemJournalLine."BLRContract ID";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnAfterInitValueEntry, '', false, false)]
    local procedure OnAfterInitValueEntry(var ValueEntry: Record "Value Entry"; var ItemJournalLine: Record "Item Journal Line"; var ValueEntryNo: Integer; var ItemLedgEntry: Record "Item Ledger Entry")
    begin
        ValueEntry."BLRContract ID" := ItemJournalLine."BLRContract ID";
    end;


    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnAfterCopyGenJnlLineFromSalesHeader, '', false, false)]
    local procedure OnAfterCopyGenJnlLineFromSalesHeader(SalesHeader: Record "Sales Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."BLRContract ID" := SalesHeader."BLRContract ID";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Bank Account Ledger Entry", OnAfterCopyFromGenJnlLine, '', false, false)]
    local procedure OnAfterCopyFromGenJnlLine(GenJournalLine: Record "Gen. Journal Line"; var BankAccountLedgerEntry: Record "Bank Account Ledger Entry");
    begin
        BankAccountLedgerEntry."BLRContract ID" := GenJournalLine."BLRContract ID";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnAfterInitGLEntry, '', false, false)]
    local procedure OnAfterInitGLEntry(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line"; Amount: Decimal; AddCurrAmount: Decimal; UseAddCurrAmount: Boolean; var CurrencyFactor: Decimal; var GLRegister: Record "G/L Register")
    var
        adjustmentdeposit: Record "BLRAdjustmentDeposits";
    begin
        GLEntry."BLRContract ID" := GenJournalLine."BLRContract ID";

        adjustmentdeposit.SetRange("BLRContract Id", GenJournalLine."BLRContract ID");
        adjustmentdeposit.SetRange("BLRTransaction Type", GenJournalLine."BLRTransaction Type");
        if adjustmentdeposit.FindSet() then
            repeat
                adjustmentdeposit."BLRAdjusted" := true;
                adjustmentdeposit.Modify();
            until adjustmentdeposit.Next() = 0;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnAfterInitCustLedgEntry, '', false, false)]
    local procedure OnAfterInitCustLedgEntry(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line"; var GLRegister: Record "G/L Register")
    var
        finalcalculationRec: Record "BLRFinalCalculation";
        tenancyContractRec: Record "BLRTenancyContract";
        AmountToDeduct: Decimal;
    begin
        CustLedgerEntry."BLRContract ID" := GenJournalLine."BLRContract ID";

        AmountToDeduct := Abs(GenJournalLine.Amount);
        if AmountToDeduct < 0 then
            AmountToDeduct := AmountToDeduct;
        finalcalculationRec.SetRange("BLRContract ID", GenJournalLine."BLRContract ID");
        if finalcalculationRec.FindFirst() then begin
            case Format(GenJournalLine."BLRItem Description") of
                'Security Deposit':
                    begin
                        if finalcalculationRec."BLRSecurity Deposit" >= AmountToDeduct then
                            finalcalculationRec."BLRRemaining Security Deposit" -= AmountToDeduct
                        else
                            finalcalculationRec."BLRRemaining Security Deposit" := 0;
                        if tenancyContractRec.Get(GenJournalLine."BLRContract ID") then begin
                            tenancyContractRec.Validate(BLRAdjustments, tenancyContractRec.BLRAdjustments + Abs(AmountToDeduct));
                            tenancyContractRec.Modify();
                        end;
                    end;
                'Chiller Deposit':

                    if finalcalculationRec."BLRChiller Deposit" >= AmountToDeduct then
                        finalcalculationRec."BLRRemaining Chiller Deposit" -= AmountToDeduct
                    else
                        finalcalculationRec."BLRRemaining Chiller Deposit" := 0;

                'Other Deposit':

                    if finalcalculationRec."BLROther Deposit" >= AmountToDeduct then
                        finalcalculationRec."BLRRemaining Other Deposit" -= AmountToDeduct
                    else
                        finalcalculationRec."BLRRemaining Other Deposit" := 0;

            end;
            finalcalculationRec.Modify();
        end;


    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnAfterFinishPosting, '', false, false)]
    local procedure OnAfterFinishPosting(var GlobalGLEntry: Record "G/L Entry"; var GLRegister: Record "G/L Register"; IsTransactionConsistent: Boolean; GenJournalLine: Record "Gen. Journal Line")
    var
        VATEntry: Record "VAT Entry";
    begin
        // If Gen. Journal Line has Contract ID filled, copy it to the VAT Entry records created for this posting
        if GenJournalLine."BLRContract ID" = 0 then
            exit;

        // Try to find VAT entries that belong to the same document
        VATEntry.SetRange("Document No.", GenJournalLine."Document No.");
        if VATEntry.FindSet() then
            repeat
                VATEntry."BLRContract ID" := GenJournalLine."BLRContract ID";
                VATEntry.Modify();
            until VATEntry.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Apply", OnSelectCustLedgEntryOnAfterSetFilters, '', false, false)]
    local procedure OnSelectCustLedgEntryOnAfterSetFilters(var CustLedgerEntry: Record "Cust. Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line")

    begin
        CustLedgerEntry.SetRange("BLRContract ID", GenJournalLine."BLRContract ID");
        // ParentCLE.CopyFilters(CustLedgerEntry);

        // // Re-apply Contract ID filter
        // if ParentCLE.GetFilter("BLRContract ID") <> '' then
        //     CustLedgerEntry.SetFilter("BLRContract ID", ParentCLE.GetFilter("BLRContract ID"));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CustEntry-Apply Posted Entries", OnApplyApplyCustEntryFormEntryOnAfterCustLedgEntrySetFilters, '', false, false)]
    local procedure OnApplyApplyCustEntryFormEntryOnAfterCustLedgEntrySetFilters(var CustLedgerEntry: Record "Cust. Ledger Entry"; var ApplyingCustLedgerEntry: Record "Cust. Ledger Entry" temporary; var IsHandled: Boolean; var CustEntryApplID: Code[50]);
    begin
        CustLedgerEntry.SetRange("BLRContract ID", ApplyingCustLedgerEntry."BLRContract ID");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", OnCodeOnBeforeConfirmPostJournalLinesResponse, '', false, false)]
    local procedure OnCodeOnBeforeConfirmPostJournalLinesResponse(var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean; var ShouldExit: Boolean)
    begin
        IsHandled := true;
    end;


}