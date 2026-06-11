page 73209688 "BLRCR Sub LeaseMergedUnitsCard"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "BLRCRSubLeaseMergedUnits";
    Caption = 'Sub Lease Merged Unit Card';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID"; rec."BLRID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the record.';
                }

                field("Merge Unit ID"; Rec."BLRMerge Unit ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Identifier for the merged unit.';
                }

                field("Unit ID"; Rec."BLRUnit ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Visible = true;
                    ToolTip = 'Identifier for the unit associated with the merged unit.';
                }

                field("Base Unit of Measure"; rec."BLRBase Unit of Measure")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'Base unit of measure for the merged unit.';
                }

                field("Unit Size"; Rec."BLRUnit Size")
                {
                    ApplicationArea = All;
                    ToolTip = 'Size of the unit in square feet or other measurement.';
                }

                field("Market Rate per Square"; Rec."BLRMarket Rate per Square")
                {
                    ApplicationArea = All;
                    ToolTip = 'Market rate per square foot for the unit.';
                }

                field("Amount"; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Total amount for the merged unit based on the market rate and size.';
                }

                field("Single Unit Name"; Rec."BLRSingle Unit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Name of the single unit associated with the merged unit.';
                }
            }
        }
    }

}






