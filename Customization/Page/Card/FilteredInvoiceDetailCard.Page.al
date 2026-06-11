page 73209690 "BLRFilteredInvoiceDetailCard"
{
    PageType = ListPart;
    SourceTable = "BLRFilteredInvoiceDetail";
    ApplicationArea = All;
    Caption = 'Filtered Invoice Detail Card';
    layout
    {
        area(content)
        {
            repeater("Contract Details")
            {
                field("ID"; Rec."BLRID")
                {
                    ToolTip = 'The unique identifier for the invoice detail.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ToolTip = 'The unique identifier for the contract associated with the invoice detail.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ToolTip = 'The unique identifier for the tenant associated with the invoice detail.';
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    Editable = false;
                }
                field("Invoice ID"; Rec."BLRInvoice ID")
                {
                    ToolTip = 'The unique identifier for the invoice associated with the detail.';
                    ApplicationArea = All;
                    Caption = 'Invoice ID';
                    Editable = false;
                }
                field("Item Name"; Rec."BLRItem Name")
                {
                    ToolTip = 'The name of the item associated with the invoice detail.';
                    ApplicationArea = All;
                    Caption = 'Item Name';
                    Editable = false;
                }
                field("Item Amount"; Rec."BLRItem Amount")
                {
                    ToolTip = 'The amount of the item associated with the invoice detail.';
                    ApplicationArea = All;
                    Caption = 'Item Amount';
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(GenerateCreditNote)
            {
                ToolTip = 'Generate a credit note for the selected invoice detail.';
                ApplicationArea = All;
                Caption = 'Generate Credit Note';
                Image = PostDocument;
                trigger OnAction()
                var
                begin
                    Message('Generate Credit Note');
                end;
            }
        }
    }
}