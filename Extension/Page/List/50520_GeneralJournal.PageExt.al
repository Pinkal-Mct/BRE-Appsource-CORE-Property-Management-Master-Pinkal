pageextension 73209597 BLRGeneralJournalExt extends "General Journal"
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