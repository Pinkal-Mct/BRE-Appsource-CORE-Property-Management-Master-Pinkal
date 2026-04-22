pageextension 73209577 CustomerLedgerEntries extends "Customer Ledger Entries"
{
    layout
    {
        addafter(Open)
        {
            field(Positive; Rec.Positive)
            {
                ApplicationArea = All;
                Caption = 'Positive';
                ToolTip = 'Indicates if the entry is positive.';
            }
        }

    }
}