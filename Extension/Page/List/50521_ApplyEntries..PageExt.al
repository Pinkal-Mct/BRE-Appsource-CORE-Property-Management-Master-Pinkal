pageextension 50521 ApplyEntriesPageExt extends "Apply Customer Entries"
{
    layout
    {
        addafter("Document No.")
        {
            field("Contract ID"; Rec."Contract ID")
            {
                ApplicationArea = All;
                Caption = 'Contract ID';
                ToolTip = 'Specifies the contract ID related to the customer ledger entry.';
                Editable = false;
            }
        }
    }
    // trigger OnOpenPage()
    // var
    //     ParentCLE: Record "Cust. Ledger Entry";
    // begin
    //     ParentCLE.CopyFilters(Rec);

    //     // Re-apply Contract ID filter
    //     if ParentCLE.GetFilter("Contract ID") <> '' then
    //         Rec.SetFilter("Contract ID", ParentCLE.GetFilter("Contract ID"));
    // end;
}