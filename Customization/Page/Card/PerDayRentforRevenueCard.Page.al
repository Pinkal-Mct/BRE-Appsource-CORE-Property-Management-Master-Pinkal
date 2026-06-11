page 73209716 "BLRPerDayRentforRevenueCard"
{

    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "BLRPerDayRentforRevenue";
    Caption = 'Per Day Rent for Revenue Allocation';

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Id"; rec."BLRId")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the record.';
                }
                field("Proposal Id"; rec."BLRProposal Id")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the record.';
                }

                field("Year"; rec."BLRYear")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The year for which the per day rent is applicable.';
                }
                field("Unit ID"; rec."BLRUnit ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the unit.';
                }

                field("Sq.Ft"; rec."BLRSq.Ft")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Square footage of the unit.';
                }

                field("Per Day Rent Per Unit"; rec."BLRPer Day Rent Per Unit")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Per Day Rent Per Unit';
                }

            }

        }

    }
}