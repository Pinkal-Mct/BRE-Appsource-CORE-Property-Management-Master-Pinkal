pageextension 73209583 "BLRPostedSalesInvoiceLine" extends "Posted Sales Invoice Subform"
{
    layout
    {
        addafter("Gen. Prod. Posting Group")
        {
            field("BLRContract ID"; Rec."BLRContract ID")
            {
                ApplicationArea = All;
                Caption = 'Contract ID';
                Editable = false;
                ToolTip = 'Specifies the contract associated with this posted sales invoice.';
            }
        }
    }
}