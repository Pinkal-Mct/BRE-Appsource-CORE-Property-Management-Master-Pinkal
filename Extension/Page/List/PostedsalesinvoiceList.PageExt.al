pageextension 73209601 "BLRPostedsalesinvoiceList" extends "Posted Sales Invoices"
{
    layout
    {
        addafter("No.")
        {
            field("BLRPre-Assigned No."; Rec."Pre-Assigned No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the pre-assigned number of the sales invoice.';
            }
            field("BLRContract ID"; Rec."BLRContract ID")
            {
                ApplicationArea = All;
            }
        }
    }
}