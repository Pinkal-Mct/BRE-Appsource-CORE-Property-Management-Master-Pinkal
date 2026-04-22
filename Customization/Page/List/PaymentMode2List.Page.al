page 73209790 "Payment Mode2 List"
{
    PageType = List;
    SourceTable = "Payment Mode2";
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
                field("Payment Series"; Rec."Payment Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'The series used for the payment mode.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'The amount associated with the payment mode.';
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'The VAT amount associated with the payment mode.';
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    ToolTip = 'The total amount including VAT for the payment mode.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
