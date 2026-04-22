page 73209795 "Payment Transaction List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Payment Transaction List';
    SourceTable = "Payment Transaction";
    CardPageId = 73209712;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("PT Id"; Rec."PT Id") { ToolTip = 'Unique identifier for the payment transaction.'; }
                field("Tenant Id"; Rec."Tenant Id") { ToolTip = 'Identifier for the tenant associated with the payment transaction.'; }
                field("Tenant Name"; Rec."Tenant Name") { ToolTip = 'Name of the tenant associated with the payment transaction.'; }
                field("Contract Id"; Rec."Contract Id") { ToolTip = 'Identifier for the contract associated with the payment transaction.'; }
                field("Approval Status"; Rec."Approval Status") { ToolTip = 'Current approval status of the payment transaction.'; }
            }
        }
    }


}