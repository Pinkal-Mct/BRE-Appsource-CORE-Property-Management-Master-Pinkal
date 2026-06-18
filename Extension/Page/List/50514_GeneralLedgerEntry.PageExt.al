pageextension 73209591 BLRGeneralLedgerEntriesExt extends "General Ledger Entries"
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