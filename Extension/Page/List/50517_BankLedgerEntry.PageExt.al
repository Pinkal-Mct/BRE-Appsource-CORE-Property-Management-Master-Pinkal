pageextension 73209594 BLRBankAccountLedgerEntriesExt extends "Bank Account Ledger Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("BLRContract ID"; Rec."BLRContract ID")
            {
                ApplicationArea = All;
                Caption = 'Contract ID';
            }
        }
    }
}