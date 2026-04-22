page 73209716 "Per Day Rent for Revenue Card"
{

    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Per Day Rent for Revenue";
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
                    ToolTip = 'Unique identifier for the record.';
                }
                field("Proposal Id"; rec."Proposal Id")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the record.';
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
                    ToolTip = 'Unique identifier for the unit.';
                }

                field("Sq.Ft"; rec."Sq.Ft")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Square footage of the unit.';
                }

                field("Per Day Rent Per Unit"; rec."Per Day Rent Per Unit")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Per Day Rent Per Unit';
                }

            }

        }

    }
}