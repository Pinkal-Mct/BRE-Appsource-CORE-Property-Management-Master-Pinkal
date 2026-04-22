page 73209737 "Sub Merged Units Card"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Sub Merged Units";
    Caption = 'Sub Merged Unit Card';

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Merged Unit ID"; Rec."Merged Unit ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The Merged Unit ID field displays the unique identifier for the merged unit.';
                }

                field("Unit ID"; Rec."Unit ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Visible = true;
                    ToolTip = 'The Unit ID field displays the unique identifier for the unit.';
                }

                field("Base Unit of Measure"; rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'The Base Unit of Measure field displays the unit of measure for the base unit.';
                }

                field("Unit Size"; Rec."Unit Size")
                {
                    ApplicationArea = All;
                    ToolTip = 'The Unit Size field displays the size of the unit in square feet or square meters.';
                }

                field("Market Rate per Square"; Rec."Market Rate per Square")
                {
                    ApplicationArea = All;
                    ToolTip = 'The Market Rate per Square field displays the market rate for the unit per square foot or square meter.';
                }

                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'The Amount field displays the total amount for the unit based on the market rate and size.';
                }

                field("Single Unit Name"; Rec."Single Unit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The Single Unit Name field displays the name of the single unit associated with the merged unit.';
                }

            }
        }
    }
}