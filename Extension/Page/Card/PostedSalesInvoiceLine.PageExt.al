pageextension 73209583 "PostedSalesInvoiceLine" extends "Posted Sales Invoice Subform"
{
    layout
    {
        addafter("Gen. Prod. Posting Group")
        {
            field("Contract ID"; Rec."Contract ID")
            {
                ApplicationArea = All;
                Caption = 'Contract ID';
                Editable = false;
                ToolTip = 'Specifies the contract associated with this posted sales invoice.';
            }
        }
    }
}