page 73209793 "BLRPayment Schedule Grid"
{
    PageType = List;
    SourceTable = "BLRPaymentSchedule2";
    ApplicationArea = All;
    Caption = 'Payment Schedule Grid List';
    UsageCategory = None;
    CardPageId = 73209710;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Payment Series"; Rec."BLRPayment Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'The series of the payment schedule.';
                }
                field("Secondary Item Type"; Rec."BLRSecondary Item Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'The type of the secondary item associated with the payment schedule.';
                }
                field("Amount"; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    ToolTip = 'The amount of the payment schedule.';
                }
                field("VAT Amount"; Rec."BLRVAT Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'The VAT amount associated with the payment schedule.';
                }
                field("Amount Including VAT"; Rec."BLRAmount Including VAT")
                {
                    ApplicationArea = All;
                    ToolTip = 'The total amount including VAT for the payment schedule.';
                }
                field("Due Date"; Rec."BLRDue Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Due Date.';
                }
            }
        }
    }

}
