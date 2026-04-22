page 73209768 "Commercial Property List"
{
    PageType = List;
    SourceTable = "Property Registration";
    ApplicationArea = All;
    Caption = 'Commercial Property List';
    UsageCategory = Administration;
    SourceTableView = where("Property Classification" = const('Commercial'));
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    Caption = 'Property ID';
                    ToolTip = 'Specifies the unique identifier for the property.';
                }
                field("Property Name"; Rec."Property Name")
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    ToolTip = 'Specifies the name of the property.';
                }
                field("Property Type"; Rec."Property Classification")
                {
                    ApplicationArea = All;
                    Caption = 'Property Type';
                    ToolTip = 'Specifies the classification of the property (e.g., Commercial).';
                }
            }
        }
    }
    trigger OnOpenPage();
    begin
        Rec.SetRange("Property Classification", 'Commercial');
    end;
}
