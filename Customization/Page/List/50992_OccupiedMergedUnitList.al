page 73209757 "Occupied Merged Unit list"
{
    PageType = List;
    SourceTable = "Merged Units";
    ApplicationArea = All;
    Caption = 'Occupied Merged Unit List';
    UsageCategory = Lists;
    // CardPageId = 31;
    SourceTableView = where(Status = const(Occupied));

    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Merged Unit ID"; Rec."Merged Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Merged Unit ID';
                    ToolTip = 'Specifies the unique identifier for the merged unit.';
                }
                field("Property Name"; Rec."Property Name")
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    ToolTip = 'Specifies the name of the property where the merged unit is located.';
                }
                field("Merged Unit Name"; Rec."Merged Unit Name")
                {
                    ApplicationArea = All;
                    Caption = 'Merged Unit Name';
                    ToolTip = 'Specifies the name assigned to the merged unit.';
                }
                field("Unit Size"; Rec."Unit Size")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Size';
                    ToolTip = 'Specifies the size of the merged unit.';
                }
                field("Unit Number"; Rec."Unit Number")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Number';
                    ToolTip = 'Specifies the number assigned to the merged unit.';
                }

            }
        }
    }

}