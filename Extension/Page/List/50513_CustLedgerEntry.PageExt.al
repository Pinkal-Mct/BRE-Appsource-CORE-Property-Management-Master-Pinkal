pageextension 73209590 BLRCustomerLedgerEntriesExt extends "Customer Ledger Entries"
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