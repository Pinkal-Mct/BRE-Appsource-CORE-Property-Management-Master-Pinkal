page 73209696 "Invoice-Credit Note Card"
{
    PageType = ListPart;
    SourceTable = "Invoice-Credit Note";
    ApplicationArea = All;
    Caption = 'Invoice-Credit Note Card';
    layout
    {
        area(content)
        {
            repeater("Contract Details")
            {
                field("ID"; Rec."ID")
                {
                    ToolTip = 'The unique identifier for the invoice or credit note.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ToolTip = 'The unique identifier for the contract associated with the invoice or credit note.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ToolTip = 'The unique identifier for the tenant associated with the invoice or credit note.';
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    Editable = false;
                }
                field("Invoice ID"; Rec."Invoice ID")
                {
                    ToolTip = 'The unique identifier for the invoice associated with the credit note.';
                    ApplicationArea = All;
                    Caption = 'Invoice ID';
                    Editable = false;
                }
                field("Item Name"; Rec."Item Name")
                {
                    ToolTip = 'The name of the item associated with the invoice or credit note.';
                    ApplicationArea = All;
                    Caption = 'Item Name';
                    Editable = false;
                }
                field("Item Amount"; Rec."Item Amount")
                {
                    ToolTip = 'The amount of the item associated with the invoice or credit note.';
                    ApplicationArea = All;
                    Caption = 'Item Amount';
                    Editable = false;
                }
                field("Status"; Rec."Status")
                {
                    ToolTip = 'The status of the invoice or credit note.';
                    ApplicationArea = All;
                    Caption = 'Status';
                }
            }
            group(" ")
            {
                field("Remark"; Rec."Remark")
                {
                    ToolTip = 'Additional remarks or comments related to the invoice or credit note.';
                    ApplicationArea = All;
                    Caption = 'Remark';
                }
                field("Reference"; Rec."Reference")
                {
                    ToolTip = 'Reference information for the invoice or credit note.';
                    ApplicationArea = All;
                    Caption = 'Reference';
                }
            }
        }
    }
}
