page 73209729 "BLRRevenueRecognitionOthChg"
{
    PageType = ListPart;
    SourceTable = "BLRRevenueRecognitionOthChg";
    ApplicationArea = All;
    Caption = 'Revenue Recognition Other Charges';
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("RS Id"; Rec."BLRRS Id")
                {
                    ToolTip = 'The unique identifier for the revenue recognition record.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Month"; Rec."BLRMonth")
                {
                    ToolTip = 'The month for which the revenue recognition is calculated.';
                    ApplicationArea = All;
                }
                field("No. of Days"; Rec."BLRNo. of Days")
                {
                    ToolTip = 'The number of days in the month for which the revenue recognition is calculated.';
                    ApplicationArea = All;
                }
                field("RR - Method 1 (Day)"; Rec."BLRRR - Method 1 (Day)")
                {
                    ToolTip = 'The revenue recognition amount calculated using Method 1 based on days.';
                    ApplicationArea = All;
                }
                field("RR - Method 2 (Month)"; Rec."BLRRR - Method 2 (Month)")
                {
                    ToolTip = 'The revenue recognition amount calculated using Method 2 based on months.';
                    ApplicationArea = All;
                }
            }
            group(TotalAmountCalculation)
            {
                field("Total Amount(Day)"; Rec."BLRTotal Amount(Day)")
                {
                    ToolTip = 'The total amount calculated for revenue recognition based on days.';
                    Caption = 'Total Amount(Day)';
                }
                field("Total Amount(Month)"; Rec."BLRTotal Amount(Month)")
                {
                    ToolTip = 'The total amount calculated for revenue recognition based on months.';
                    Caption = 'Total Amount(Month)';
                }
            }
        }
    }
}
