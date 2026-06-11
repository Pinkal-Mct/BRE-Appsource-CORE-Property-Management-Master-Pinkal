page 73209757 "BLROccupied Merged Unit list"
{
    PageType = List;
    SourceTable = "BLRMergedUnits";
    ApplicationArea = All;
    Caption = 'Occupied Merged Unit List';
    UsageCategory = Lists;
    // CardPageId = 31;
    SourceTableView = where(BLRStatus = const(Occupied));

    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Merged Unit ID"; Rec."BLRMerged Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Merged Unit ID';
                    ToolTip = 'Specifies the unique identifier for the merged unit.';
                }
                field("Property Name"; Rec."BLRProperty Name")
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    ToolTip = 'Specifies the name of the property where the merged unit is located.';
                }
                field("Merged Unit Name"; Rec."BLRMerged Unit Name")
                {
                    ApplicationArea = All;
                    Caption = 'Merged Unit Name';
                    ToolTip = 'Specifies the name assigned to the merged unit.';
                }
                field("Unit Size"; Rec."BLRUnit Size")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Size';
                    ToolTip = 'Specifies the size of the merged unit.';
                }
                field("Unit Number"; Rec."BLRUnit Number")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Number';
                    ToolTip = 'Specifies the number assigned to the merged unit.';
                }

            }
        }
    }

}