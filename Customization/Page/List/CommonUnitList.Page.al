page 73209771 "BLRCommon Unit List"
{
    PageType = List;
    SourceTable = item;
    ApplicationArea = All;
    Caption = 'Common Unit List';
    UsageCategory = Lists;
    SourceTableView = where("BLRUsage Type" = const('Common'));
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    ToolTip = 'Specifies the unique number of the unit.';
                }
                field("Property Name"; Rec."BLRProperty Name")
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    ToolTip = 'Specifies the name of the property where the unit is located.';
                }
                field(UnitID; Rec.BLRUnitID)
                {
                    ApplicationArea = All;
                    Caption = 'Unit ID';
                    ToolTip = 'Specifies the unique identifier for the unit.';
                }
                field("Unit Name"; Rec."BLRUnit Name")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Name';
                    ToolTip = 'Specifies the name assigned to the unit.';
                }
                field("Unit Number"; Rec."BLRUnit Number")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Number';
                    ToolTip = 'Specifies the number assigned to the unit.';
                }
                field("Floor Number"; Rec."BLRFloor Number")
                {
                    ApplicationArea = All;
                    Caption = 'Floor Number';
                    ToolTip = 'Specifies the floor on which the unit is located.';
                }
                field("Usage Type"; Rec."BLRUsage Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the usage type of the unit (e.g., Common, Residential, Commercial).';
                }
            }
        }
    }
    trigger OnOpenPage();
    begin
        Rec.SetRange("BLRUsage Type", 'Common');
    end;
}
