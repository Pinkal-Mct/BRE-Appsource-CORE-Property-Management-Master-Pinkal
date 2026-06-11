page 73209784 "BLRMerged Units List"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "BLRMergedUnits";
    Caption = 'Merged Units';
    UsageCategory = Lists;
    CardPageId = 73209700;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Merged Unit ID"; Rec."BLRMerged Unit ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the merged unit.';
                }

                field("Property ID"; Rec."BLRProperty ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the property associated with the merged unit.';
                }

                field("Property Name"; Rec."BLRProperty Name") // Custom Field
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the property associated with the merged unit.';

                }

                field("Unit ID"; Rec."BLRUnit ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the unit within the merged unit.';
                }

                field("Merged Unit Name"; Rec."BLRMerged Unit Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the merged unit, which may include multiple units.';
                }

                field("Unit Size"; Rec."BLRUnit Size")
                {
                    ApplicationArea = All;
                    ToolTip = 'Size of the unit in square feet or square meters.';
                }


                field("Amount"; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Total amount associated with the merged unit, which may include costs or revenue.';
                }

                field("BLRPropertyType"; Rec."BLRProperty Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Type of property associated with the merged unit, such as residential, commercial, etc.';
                }

                field("Status"; Rec."BLRStatus")
                {
                    ApplicationArea = All;
                    ToolTip = 'Current status of the merged unit, indicating whether it is active, inactive, or under maintenance.';
                }

                field("Splitting Status"; Rec."BLRSpliting Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether the merged unit is currently being split into individual units or remains merged.';
                }



            }
        }
    }

    actions
    {
        area(processing)
        {
#pragma warning disable AW0011
            action("Open Card")
#pragma warning restore AW0011
            {
                ApplicationArea = All;
                Caption = 'Open Card';
                Image = Open;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Open the card page for the selected merged unit to view or edit details.';

                trigger OnAction()
                begin
                    PAGE.Run(PAGE::"BLRMerged Units Card", Rec);
                end;
            }
        }
    }
}
