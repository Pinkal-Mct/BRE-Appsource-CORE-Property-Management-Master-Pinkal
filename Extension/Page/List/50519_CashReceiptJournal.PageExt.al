pageextension 73209596 BLRCashReceiptJournalExt extends "Cash Receipt Journal"
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
            field("Item Description"; Rec."BLRItem Description")
            {
                ApplicationArea = All;
                Caption = 'Item Description';
                ToolTip = 'Specifies the description of the item.';
                Editable = false;
            }
            field("Transaction Type"; Rec."BLRTransaction Type")
            {
                ApplicationArea = All;
                Caption = 'Transaction Type';
                ToolTip = 'Specifies the type of transaction.';
                Editable = false;
            }

        }

    }
}