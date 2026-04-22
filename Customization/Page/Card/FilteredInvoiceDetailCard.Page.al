page 73209690 "Filtered Invoice Detail Card"
{
    PageType = ListPart;
    SourceTable = "Filtered Invoice Detail";
    ApplicationArea = All;
    Caption = 'Filtered Invoice Detail Card';
    layout
    {
        area(content)
        {
            repeater("Contract Details")
            {
                field("ID"; Rec."ID")
                {
                    ToolTip = 'The unique identifier for the invoice detail.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ToolTip = 'The unique identifier for the contract associated with the invoice detail.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ToolTip = 'The unique identifier for the tenant associated with the invoice detail.';
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    Editable = false;
                }
                field("Invoice ID"; Rec."Invoice ID")
                {
                    ToolTip = 'The unique identifier for the invoice associated with the detail.';
                    ApplicationArea = All;
                    Caption = 'Invoice ID';
                    Editable = false;
                }
                field("Item Name"; Rec."Item Name")
                {
                    ToolTip = 'The name of the item associated with the invoice detail.';
                    ApplicationArea = All;
                    Caption = 'Item Name';
                    Editable = false;
                }
                field("Item Amount"; Rec."Item Amount")
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