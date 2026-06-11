pageextension 73209595 BLRVATEntryExt extends "VAT Entries"
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