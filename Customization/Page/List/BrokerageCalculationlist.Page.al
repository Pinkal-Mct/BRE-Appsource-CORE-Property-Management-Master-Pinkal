page 73209764 "BLRBrokerage Calculation List"
{
    PageType = List;
    SourceTable = "BLRBrokerageCalculation";
    ApplicationArea = All;
    Caption = 'Brokerage Calculation List';
    UsageCategory = Lists;
    CardPageId = 73209675;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID"; Rec."BLRID")
                {
                    ApplicationArea = All;
                    Caption = 'ID';
                    ToolTip = 'Specifies the unique identifier for the brokerage calculation.';
                }
                field("Owner ID"; Rec."BLROwner ID")
                {
                    ApplicationArea = All;
                    Caption = 'Owner ID';
                    ToolTip = 'Specifies the unique identifier for the owner associated with the brokerage calculation.';
                }
                field("Property ID"; Rec."BLRProperty ID")
                {
                    ApplicationArea = All;
                    Caption = 'Property ID';
                    ToolTip = 'Specifies the unique identifier for the property associated with the brokerage calculation.';
                }
                field("Start Date"; Rec."BLRStart Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    ToolTip = 'Specifies the start date for the brokerage calculation period.';
                }
                field("End Date"; Rec."BLREnd Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    ToolTip = 'Specifies the end date for the brokerage calculation period.';
                }

            }
        }
    }

}
