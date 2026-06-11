page 73209805 "BLRRevenue Structure List"
{
    PageType = List;
    SourceTable = "BLRRevenueStructure";
    ApplicationArea = All;
    Caption = 'Revenue Structure List';
    UsageCategory = Lists;
    CardPageId = 73209730;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Caption = 'Contract ID';
                    ToolTip = 'Specifies the unique identifier for the contract associated with this revenue structure.';
                }
                field("RS_ID"; Rec."BLRRS ID")
                {
                    ApplicationArea = All;
                    Caption = 'RS_ID';
                    ToolTip = 'Specifies the unique identifier for the revenue structure.';
                }
                field("Secondary Item Type"; Rec."BLRSecondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                    ToolTip = 'Specifies the type of secondary item associated with this revenue structure.';
                }
                field("Amount"; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the amount associated with this revenue structure.';
                }

                field("Contract Start Date"; Rec."BLRContract Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                    ToolTip = 'Specifies the start date of the contract associated with this revenue structure.';
                }
                field("Contract End Date"; Rec."BLRContract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
                    ToolTip = 'Specifies the end date of the contract associated with this revenue structure.';
                }

                field("Number of Installments"; Rec."BLRNumber of Installments")
                {
                    ApplicationArea = All;
                    Caption = 'Number of Instalments';
                    ToolTip = 'Specifies the number of installments for the revenue structure.';
                }

            }
        }
    }

}
