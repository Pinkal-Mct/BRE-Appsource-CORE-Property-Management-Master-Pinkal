page 73209791 "BLRPayment Mode List"
{
    PageType = List;
    SourceTable = "BLRPaymentMode";
    ApplicationArea = All;
    Caption = 'Payment Mode List';
    UsageCategory = Lists;
    CardPageId = 73209705;


    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Caption = 'Contract_ID';
                    ToolTip = 'The ID of the contract associated with the payment mode.';
                }
                field("Contract Start date"; Rec."BLRContract Start date")
                {
                    ApplicationArea = All;
                    ToolTip = 'The start date of the contract associated with the payment mode.';
                }
                field("Contract End date"; Rec."BLRContract End date")
                {
                    ApplicationArea = All;
                    ToolTip = 'The end date of the contract associated with the payment mode.';
                }
                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    ToolTip = 'The ID of the tenant associated with the payment mode.';
                }

                field("Tenant Name"; Rec."BLRTenant Name")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Name';
                    ToolTip = 'The name of the tenant associated with the payment mode.';
                }

            }
        }
    }

}
