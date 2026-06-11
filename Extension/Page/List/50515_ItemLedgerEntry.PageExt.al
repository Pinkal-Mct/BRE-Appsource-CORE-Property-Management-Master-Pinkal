pageextension 73209592 BLRItemLedgerEntriesExt extends "Item Ledger Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("Contract ID"; Rec."BLRContract ID")
            {
                ApplicationArea = All;
                Caption = 'Contract ID';
            }
        }
    }
}