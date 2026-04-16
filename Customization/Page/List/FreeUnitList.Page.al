page 50103 "Free Unit List"
{
    PageType = List;
    SourceTable = item;
    ApplicationArea = All;
    Caption = 'Free Unit List';
    UsageCategory = Lists;
    SourceTableView = where("Unit Status" = const(Free), "Item type template" = const("Item Type Template Enum"::"Unit Service"));
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
                field("Property Name"; Rec."Property Name")
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    ToolTip = 'Specifies the name of the property where the unit is located.';
                }
                field(UnitID; Rec.UnitID)
                {
                    ApplicationArea = All;
                    Caption = 'Unit ID';
                    ToolTip = 'Specifies the unique identifier for the unit.';
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Name';
                    ToolTip = 'Specifies the name assigned to the unit.';
                }
                field("Unit Number"; Rec."Unit Number")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Number';
                    ToolTip = 'Specifies the number assigned to the unit.';
                }
                field("Floor Number"; Rec."Floor Number")
                {
                    ApplicationArea = All;
                    Caption = 'Floor Number';
                    ToolTip = 'Specifies the floor on which the unit is located.';
                }
                field("Usage Type"; Rec."Usage Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the usage type of the unit (e.g., residential, commercial).';
                }
                field(Status; Rec."Unit Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the current status of the unit (e.g., Free, Occupied).';
                }
            }
        }
    }

}
