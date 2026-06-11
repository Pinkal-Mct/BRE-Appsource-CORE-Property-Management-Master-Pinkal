page 73209790 "BLRPayment Mode2 List"
{
    PageType = List;
    SourceTable = "BLRPaymentMode2";
    ApplicationArea = All;
    Caption = 'Payment Mode Grid List';
    UsageCategory = None;
    CardPageId = 73209706;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Payment Series"; Rec."BLRPayment Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'The series used for the payment mode.';
                }
                field(Amount; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    ToolTip = 'The amount associated with the payment mode.';
                }
                field("VAT Amount"; Rec."BLRVAT Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'The VAT amount associated with the payment mode.';
                }
                field("Amount Including VAT"; Rec."BLRAmount Including VAT")
                {
                    ApplicationArea = All;
                    ToolTip = 'The total amount including VAT for the payment mode.';
                }
                field("Due Date"; Rec."BLRDue Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
