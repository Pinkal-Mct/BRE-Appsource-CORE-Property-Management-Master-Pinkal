page 73209769 "BLRCommercial Unit List"
{
    PageType = List;
    SourceTable = item;
    ApplicationArea = All;
    Caption = 'Commercial Unit List';
    UsageCategory = Lists;
    SourceTableView = where("BLRUsage Type" = const('Commercial'));
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
                    ToolTip = 'Specifies the unique identifier for the commercial unit.';
                }
                field("Property Name"; Rec."BLRProperty Name")
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    ToolTip = 'Specifies the name of the property to which the commercial unit belongs.';
                }
                field(UnitID; Rec.BLRUnitID)
                {
                    ApplicationArea = All;
                    Caption = 'Unit ID';
                    ToolTip = 'Specifies the unique identifier for the commercial unit.';
                }
                field("Unit Name"; Rec."BLRUnit Name")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Name';
                    ToolTip = 'Specifies the name of the commercial unit.';
                }
                field("Unit Number"; Rec."BLRUnit Number")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Number';
                    ToolTip = 'Specifies the number assigned to the commercial unit.';
                }
                field("Floor Number"; Rec."BLRFloor Number")
                {
                    ApplicationArea = All;
                    Caption = 'Floor Number';
                    ToolTip = 'Specifies the floor on which the commercial unit is located.';
                }
                field("Usage Type"; Rec."BLRUsage Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of usage for the commercial unit, such as Residential, Commercial, etc.';
                }
            }
        }
    }

    trigger OnOpenPage();
    begin
        Rec.SetRange("BLRUsage Type", 'Commercial'); // Filter for only vacant properties
    end;

}
