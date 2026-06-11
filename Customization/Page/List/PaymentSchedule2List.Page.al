page 73209792 "BLRPayment Schedule2 List"
{
    PageType = List;
    SourceTable = "BLRPaymentSchedule2";
    ApplicationArea = All;
    Caption = 'Payment Schedule Grid List';
    //  UsageCategory = Lists;
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
                    ToolTip = 'Specifies the payment series or reference number used to group related payment transactions.';
                }
                field("Secondary Item Type"; Rec."BLRSecondary Item Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the secondary item associated with this record, if applicable.';
                }
                field("Amount"; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the net amount before VAT for this record.';
                }
                field("VAT Amount"; Rec."BLRVAT Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the calculated VAT amount for this transaction.';
                }
                field("Amount Including VAT"; Rec."BLRAmount Including VAT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total amount including VAT.';
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
