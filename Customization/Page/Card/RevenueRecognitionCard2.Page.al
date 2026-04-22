page 73209728 "Revenue Recognition Card2"
{
    PageType = ListPart;
    SourceTable = "Revenue Recognition Subpage";
    ApplicationArea = All;
    Caption = 'Revenue Recognition-Rent';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Month"; Rec."Month")
                {
                    ApplicationArea = All;
                    ToolTip = 'The month for which the revenue recognition is calculated.';
                }

                field("No. of Days"; Rec."No. of Days")
                {
                    ApplicationArea = All;
                    ToolTip = 'The number of days in the month for which the revenue recognition is calculated.';
                }

                field("RR - Method 1 (Day)"; Rec."RR - Method 1 (Day)")
                {
                    ApplicationArea = All;
                    ToolTip = 'The revenue recognition amount calculated using Method 1 for the day.';
                }

                field("RR - Method 2 (Month)"; Rec."RR - Method 2 (Month)")
                {
                    ApplicationArea = All;
                    ToolTip = 'The revenue recognition amount calculated using Method 2 for the month.';
                }
            }

            group(TotalAmountCalculation)
            {
                field("Total Amount(Day)"; Rec."Total Amount(Day)")
                {
                    Caption = 'Total Amount(Day)';
                    ToolTip = 'The total amount calculated for the day based on the revenue recognition method.';
                }
                field("Total Amount(Month)"; Rec."Total Amount(Month)")
                {
                    Caption = 'Total Amount(Month)';
                    ToolTip = 'The total amount calculated for the month based on the revenue recognition method.';
                }

            }
        }
    }


}