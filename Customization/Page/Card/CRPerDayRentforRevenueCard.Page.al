page 73209685 "BLRCR PerDayRentforRevenueCard"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "BLRCRPerDayRentforRevenue";
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
                    ToolTip = 'Unique identifier for the Per Day Rent record.';
                }

                field("Contract Renewal Id"; rec."BLRContract Renewal Id")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Identifier for the associated contract renewal.';
                }

                field("Proposal Id"; rec."BLRProposal Id")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Identifier for the associated proposal.';
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
                    ToolTip = 'Identifier for the unit associated with the per day rent.';
                }

                field("Sq.Ft"; rec."BLRSq.Ft")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The square footage of the unit for which the per day rent is calculated.';
                }

                field("Per Day Rent Per Unit"; rec."BLRPer Day Rent Per Unit")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The per day rent amount for the unit.';
                }
            }
        }
    }
}