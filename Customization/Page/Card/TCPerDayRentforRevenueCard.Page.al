page 73209742 "TC PerDayRent for Revenue Card"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "TC Per Day Rent for Revenue";
    Caption = 'Per Day Rent for Revenue Allocation';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Id"; rec."Id")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the Per Day Rent record.';
                }

                field("Contract Renewal Id"; rec."Contract Renewal Id")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Identifier for the associated contract renewal.';
                }

                field("Proposal Id"; rec."Proposal Id")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Identifier for the associated proposal.';
                }

                field("Year"; rec."Year")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The year for which the per day rent is applicable.';
                }

                field("Unit ID"; rec."Unit ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Identifier for the unit associated with the per day rent.';
                }

                field("Sq.Ft"; rec."Sq.Ft")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Size of the unit in square feet.';
                }
                field("Line No."; rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Line number for the per day rent record.';
                }

                field("Per Day Rent Per Unit"; rec."Per Day Rent Per Unit")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The per day rent amount applicable for the unit.';
                }

            }
        }
    }
}