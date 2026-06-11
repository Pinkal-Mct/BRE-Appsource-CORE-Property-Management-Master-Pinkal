page 73209802 "BLRResidential Property List"
{
    PageType = List;
    SourceTable = "BLRPropertyRegistration";
    ApplicationArea = All;
    Caption = 'Residential Property List';
    UsageCategory = Lists;
    SourceTableView = where("BLRProperty Classification" = const('Residential'));
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Property ID"; Rec."BLRProperty ID")
                {
                    ApplicationArea = All;
                    Caption = 'Property ID';
                    ToolTip = 'Specifies the unique identifier for the property.';
                }
                field("Property Name"; Rec."BLRProperty Name")
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    ToolTip = 'Specifies the name of the property.';
                }
                field("BLRPropertyType"; Rec."BLRProperty Classification")
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
        Rec.SetRange("BLRProperty Classification", 'Residential');
    end;
}
