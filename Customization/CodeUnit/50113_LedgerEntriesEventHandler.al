codeunit 73209621 "Ledger Entries Event Handler"
{
    Permissions = TableData "VAT Entry" = rimd;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnPostItemJnlLineOnAfterCopyDocumentFields, '', false, false)]
    local procedure OnPostItemJnlLineOnAfterCopyDocumentFields(var ItemJournalLine: Record "Item Journal Line"; SalesLine: Record "Sales Line"; WarehouseReceiptHeader: Record "Warehouse Receipt Header"; WarehouseShipmentHeader: Record "Warehouse Shipment Header")
    begin
        ItemJournalLine."Contract ID" := SalesLine."Contract ID";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnAfterInitItemLedgEntry, '', false, false)]
    local procedure OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer)
    begin
        NewItemLedgEntry."Contract ID" := ItemJournalLine."Contract ID";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", OnAfterInitValueEntry, '', false, false)]
    local procedure OnAfterInitValueEntry(var ValueEntry: Record "Value Entry"; var ItemJournalLine: Record "Item Journal Line"; var ValueEntryNo: Integer; var ItemLedgEntry: Record "Item Ledger Entry")
    begin
        ValueEntry."Contract ID" := ItemJournalLine."Contract ID";
    end;


    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", OnAfterCopyGenJnlLineFromSalesHeader, '', false, false)]
    local procedure OnAfterCopyGenJnlLineFromSalesHeader(SalesHeader: Record "Sales Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."Contract ID" := SalesHeader."Contract ID";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Bank Account Ledger Entry", OnAfterCopyFromGenJnlLine, '', false, false)]
    local procedure OnAfterCopyFromGenJnlLine(GenJournalLine: Record "Gen. Journal Line"; var BankAccountLedgerEntry: Record "Bank Account Ledger Entry");
    begin
        BankAccountLedgerEntry."Contract ID" := GenJournalLine."Contract ID";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnAfterInitGLEntry, '', false, false)]
    local procedure OnAfterInitGLEntry(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line"; Amount: Decimal; AddCurrAmount: Decimal; UseAddCurrAmount: Boolean; var CurrencyFactor: Decimal; var GLRegister: Record "G/L Register")
    var
        adjustmentdeposit: Record "Adjustment Deposits";
    begin
        GLEntry."Contract ID" := GenJournalLine."Contract ID";

        adjustmentdeposit.SetRange("Contract Id", GenJournalLine."Contract ID");
        adjustmentdeposit.SetRange("Transaction Type", GenJournalLine."Transaction Type");
        if adjustmentdeposit.FindSet() then
            repeat
                adjustmentdeposit.Adjusted := true;
                adjustmentdeposit.Modify();
            until adjustmentdeposit.Next() = 0;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", OnAfterInitCustLedgEntry, '', false, false)]
    local procedure OnAfterInitCustLedgEntry(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line"; var GLRegister: Record "G/L Register")
    var
        finalcalculationRec: Record "Final Calculation";
        tenancyContractRec: Record "Tenancy Contract";
        AmountToDeduct: Decimal;
    begin
        CustLedgerEntry."Contract ID" := GenJournalLine."Contract ID";

        AmountToDeduct := Abs(GenJournalLine.Amount);
        if AmountToDeduct < 0 then
            AmountToDeduct := AmountToDeduct;
        finalcalculationRec.SetRange("Contract ID", GenJournalLine."Contract ID");
        if finalcalculationRec.FindFirst() then begin
            case Format(GenJournalLine."Item Description") of
                'Security Deposit':
                    begin
                        if finalcalculationRec."Security Deposit" >= AmountToDeduct then
                            finalcalculationRec."Remaining Security Deposit" -= AmountToDeduct
                        else
                            finalcalculationRec."Remaining Security Deposit" := 0;
                        if tenancyContractRec.Get(GenJournalLine."Contract ID") then begin
                            tenancyContractRec.Validate(Adjustments, tenancyContractRec.Adjustments + Abs(AmountToDeduct));
                            tenancyContractRec.Modify();
                        end;
                    end;
                'Chiller Deposit':

                    if finalcalculationRec."Chiller Deposit" >= AmountToDeduct then
                        finalcalculationRec."Remaining Chiller Deposit" -= AmountToDeduct
                    else
                        finalcalculationRec."Remaining Chiller Deposit" := 0;

                'Other Deposit':

                    if finalcalculationRec."Other Deposit" >= AmountToDeduct then
                        finalcalculationRec."Remaining Other Deposit" -= AmountToDeduct
                    else
                        finalcalculationRec."Remaining Other Deposit" := 0;

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
        if GenJournalLine."Contract ID" = 0 then
            exit;

        // Try to find VAT entries that belong to the same document
        VATEntry.SetRange("Document No.", GenJournalLine."Document No.");
        if VATEntry.FindSet() then
            repeat
                VATEntry."Contract ID" := GenJournalLine."Contract ID";
                VATEntry.Modify();
            until VATEntry.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Apply", OnSelectCustLedgEntryOnAfterSetFilters, '', false, false)]
    local procedure OnSelectCustLedgEntryOnAfterSetFilters(var CustLedgerEntry: Record "Cust. Ledger Entry"; var GenJournalLine: Record "Gen. Journal Line")

    begin
        CustLedgerEntry.SetRange("Contract ID", GenJournalLine."Contract ID");
        // ParentCLE.CopyFilters(CustLedgerEntry);

        // // Re-apply Contract ID filter
        // if ParentCLE.GetFilter("Contract ID") <> '' then
        //     CustLedgerEntry.SetFilter("Contract ID", ParentCLE.GetFilter("Contract ID"));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CustEntry-Apply Posted Entries", OnApplyApplyCustEntryFormEntryOnAfterCustLedgEntrySetFilters, '', false, false)]
    local procedure OnApplyApplyCustEntryFormEntryOnAfterCustLedgEntrySetFilters(var CustLedgerEntry: Record "Cust. Ledger Entry"; var ApplyingCustLedgerEntry: Record "Cust. Ledger Entry" temporary; var IsHandled: Boolean; var CustEntryApplID: Code[50]);
    begin
        CustLedgerEntry.SetRange("Contract ID", ApplyingCustLedgerEntry."Contract ID");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", OnCodeOnBeforeConfirmPostJournalLinesResponse, '', false, false)]
    local procedure OnCodeOnBeforeConfirmPostJournalLinesResponse(var GenJournalLine: Record "Gen. Journal Line"; var IsHandled: Boolean; var ShouldExit: Boolean)
    begin
        IsHandled := true;
    end;


}