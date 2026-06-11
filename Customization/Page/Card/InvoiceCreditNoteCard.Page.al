page 73209696 "BLRInvoice-Credit Note Card"
{
    PageType = ListPart;
    SourceTable = "BLRInvoiceCreditNote";
    ApplicationArea = All;
    Caption = 'Invoice-Credit Note Card';
    layout
    {
        area(content)
        {
            repeater("Contract Details")
            {
                field("ID"; Rec."BLRID")
                {
                    ToolTip = 'The unique identifier for the invoice or credit note.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ToolTip = 'The unique identifier for the contract associated with the invoice or credit note.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ToolTip = 'The unique identifier for the tenant associated with the invoice or credit note.';
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    Editable = false;
                }
                field("Invoice ID"; Rec."BLRInvoice ID")
                {
                    ToolTip = 'The unique identifier for the invoice associated with the credit note.';
                    ApplicationArea = All;
                    Caption = 'Invoice ID';
                    Editable = false;
                }
                field("Item Name"; Rec."BLRItem Name")
                {
                    ToolTip = 'The name of the item associated with the invoice or credit note.';
                    ApplicationArea = All;
                    Caption = 'Item Name';
                    Editable = false;
                }
                field("Item Amount"; Rec."BLRItem Amount")
                {
                    ToolTip = 'The amount of the item associated with the invoice or credit note.';
                    ApplicationArea = All;
                    Caption = 'Item Amount';
                    Editable = false;
                }
                field("Status"; Rec."BLRStatus")
                {
                    ToolTip = 'The status of the invoice or credit note.';
                    ApplicationArea = All;
                    Caption = 'Status';
                }
            }
            group(" ")
            {
                field("Remark"; Rec."BLRRemark")
                {
                    ToolTip = 'Additional remarks or comments related to the invoice or credit note.';
                    ApplicationArea = All;
                    Caption = 'Remark';
                }
                field("Reference"; Rec."BLRReference")
                {
                    ToolTip = 'Reference information for the invoice or credit note.';
                    ApplicationArea = All;
                    Caption = 'Reference';
                }
            }
        }
    }
}
