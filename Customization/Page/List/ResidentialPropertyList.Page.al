page 73209802 "Residential Property List"
{
    PageType = List;
    SourceTable = "Property Registration";
    ApplicationArea = All;
    Caption = 'Residential Property List';
    UsageCategory = Lists;
    SourceTableView = where("Property Classification" = const('Residential'));
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
                    ToolTip = 'Specifies the classification of the property (e.g., Residential).';
                }
            }
        }
    }
    trigger OnOpenPage();
    begin
        Rec.SetRange("Property Classification", 'Residential');
    end;
}
