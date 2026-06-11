pageextension 73209593 BLRValueEntryExt extends "Value Entries"
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