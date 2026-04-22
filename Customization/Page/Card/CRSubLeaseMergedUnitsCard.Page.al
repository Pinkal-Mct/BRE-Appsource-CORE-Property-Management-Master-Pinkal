page 73209688 "CR Sub Lease Merged Units Card"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "CR Sub Lease Merged Units";
    Caption = 'Sub Lease Merged Unit Card';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID"; rec."ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the record.';
                }

                field("Merge Unit ID"; Rec."Merge Unit ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Identifier for the merged unit.';
                }

                field("Unit ID"; Rec."Unit ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Visible = true;
                    ToolTip = 'Identifier for the unit associated with the merged unit.';
                }

                field("Base Unit of Measure"; rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'Base unit of measure for the merged unit.';
                }

                field("Unit Size"; Rec."Unit Size")
                {
                    ApplicationArea = All;
                    ToolTip = 'Size of the unit in square feet or other measurement.';
                }

                field("Market Rate per Square"; Rec."Market Rate per Square")
                {
                    ApplicationArea = All;
                    ToolTip = 'Market rate per square foot for the unit.';
                }

                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Total amount for the merged unit based on the market rate and size.';
                }

                field("Single Unit Name"; Rec."Single Unit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Name of the single unit associated with the merged unit.';
                }
            }
        }
    }

}






