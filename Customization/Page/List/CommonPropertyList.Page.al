page 73209770 "BLRCommon Property List"
{
    PageType = List;
    SourceTable = "BLRPropertyRegistration";
    ApplicationArea = All;
    Caption = 'Common Property List';
    UsageCategory = Lists;
    ShowFilter = false;
    SourceTableView = where("BLRProperty Classification" = const('Common'));

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
                    ToolTip = 'The unique identifier for the property.';
                }
                field("Property Name"; Rec."BLRProperty Name")
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    ToolTip = 'The name of the property.';
                }
                field("BLRPropertyType"; Rec."BLRProperty Classification")
                {
                    ApplicationArea = All;
                    Caption = 'Property Type';
                    ToolTip = 'The classification of the property.';
                    TableRelation = "BLRPropertyType";
                }
            }
        }
    }

    trigger OnOpenPage();
    begin
        Rec.SetRange("BLRProperty Classification", 'Common'); // Filter for only vacant properties
    end;

}
