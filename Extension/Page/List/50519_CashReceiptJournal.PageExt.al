pageextension 73209596 BLRCashReceiptJournalExt extends "Cash Receipt Journal"
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
            field("BLRItem Description"; Rec."BLRItem Description")
            {
                ApplicationArea = All;
                Caption = 'Item Description';
                ToolTip = 'Specifies the description of the item.';
                Editable = false;
            }
            field("BLRTransaction Type"; Rec."BLRTransaction Type")
            {
                ApplicationArea = All;
                Caption = 'Transaction Type';
                ToolTip = 'Specifies the type of transaction.';
                Editable = false;
            }

        }

    }
}