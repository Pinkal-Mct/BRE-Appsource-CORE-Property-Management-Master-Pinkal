page 73209794 "Payment Schedule List"
{
    PageType = List;
    SourceTable = "Payment Schedule";
    ApplicationArea = All;
    Caption = 'Payment Schedule List';
    UsageCategory = Lists;
    CardPageId = 73209709;


    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Caption = 'Contract_ID';
                    ToolTip = 'The ID of the contract associated with the payment schedule.';
                }

                field("Contract Start Date"; Rec."Contract Start date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                    ToolTip = 'The start date of the contract associated with the payment schedule.';
                }

                field("Contract End Date"; Rec."Contract End date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
                    ToolTip = 'The end date of the contract associated with the payment schedule.';
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    ToolTip = 'The ID of the tenant associated with the payment schedule.';
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Name';
                    ToolTip = 'The name of the tenant associated with the payment schedule.';
                }

            }
        }
    }

}
