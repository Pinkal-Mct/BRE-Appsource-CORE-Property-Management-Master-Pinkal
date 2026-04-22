pageextension 73209601 "PostedsalesinvoiceList" extends "Posted Sales Invoices"
{
    layout
    {
        addafter("No.")
        {
            field("Pre-Assigned No."; Rec."Pre-Assigned No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the pre-assigned number of the sales invoice.';
            }
            field("Contract ID"; Rec."Contract ID")
            {
                ApplicationArea = All;
            }
        }
    }
}