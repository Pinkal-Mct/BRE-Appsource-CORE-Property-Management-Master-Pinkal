page 73209784 "Merged Units List"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "Merged Units";
    Caption = 'Merged Units';
    UsageCategory = Lists;
    CardPageId = 73209700;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Merged Unit ID"; Rec."Merged Unit ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the merged unit.';
                }

                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the property associated with the merged unit.';
                }

                field("Property Name"; Rec."Property Name") // Custom Field
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the property associated with the merged unit.';

                }

                field("Unit ID"; Rec."Unit ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the unit within the merged unit.';
                }

                field("Merged Unit Name"; Rec."Merged Unit Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the merged unit, which may include multiple units.';
                }

                field("Unit Size"; Rec."Unit Size")
                {
                    ApplicationArea = All;
                    ToolTip = 'Size of the unit in square feet or square meters.';
                }


                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Total amount associated with the merged unit, which may include costs or revenue.';
                }

                field("Property Type"; Rec."Property Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Type of property associated with the merged unit, such as residential, commercial, etc.';
                }

                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Current status of the merged unit, indicating whether it is active, inactive, or under maintenance.';
                }

                field("Splitting Status"; Rec."Spliting Status")
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
                    PAGE.Run(PAGE::"Merged Units Card", Rec);
                end;
            }
        }
    }
}
