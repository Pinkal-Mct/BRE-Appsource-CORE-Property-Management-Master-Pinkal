page 73209804 "Revenue Recognition List"
{
    PageType = List;
    SourceTable = "Revenue Recognition";
    ApplicationArea = All;
    Caption = 'Revenue Recognition Rent List';
    UsageCategory = Lists;
    CardPageId = 73209727;


    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("RR Id"; Rec."RR Id")
                {
                    ApplicationArea = All;
                    Caption = 'RR Id';
                    ToolTip = 'Specifies the unique identifier for the revenue recognition entry.';
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Caption = 'Contract ID';
                    ToolTip = 'Specifies the unique identifier for the contract associated with the revenue recognition entry.';
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    ToolTip = 'Specifies the unique identifier for the tenant associated with the revenue recognition entry.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    ToolTip = 'Specifies the start date for the revenue recognition period.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    ToolTip = 'Specifies the end date for the revenue recognition period.';
                }
                field("Contract Amount"; Rec."Contract Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Amount';
                    ToolTip = 'Specifies the total amount of the contract associated with the revenue recognition entry.';
                }



            }
        }
    }

}
