page 73209795 "BLRPayment Transaction List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Payment Transaction List';
    SourceTable = "BLRPaymentTransaction";
    CardPageId = 73209712;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("PT Id"; Rec."BLRPT Id") { ToolTip = 'Unique identifier for the payment transaction.'; }
                field("Tenant Id"; Rec."BLRTenant Id") { ToolTip = 'Identifier for the tenant associated with the payment transaction.'; }
                field("Tenant Name"; Rec."BLRTenant Name") { ToolTip = 'Name of the tenant associated with the payment transaction.'; }
                field("Contract Id"; Rec."BLRContract Id") { ToolTip = 'Identifier for the contract associated with the payment transaction.'; }
                field("Approval Status"; Rec."BLRApproval Status") { ToolTip = 'Current approval status of the payment transaction.'; }
            }
        }
    }


}