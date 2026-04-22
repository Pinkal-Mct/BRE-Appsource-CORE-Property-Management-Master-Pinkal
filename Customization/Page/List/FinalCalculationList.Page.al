page 73209776 "Final Calculation List"
{
    PageType = List;
    SourceTable = "Final Calculation";
    ApplicationArea = All;
    Caption = 'Final Calculation List';
    UsageCategory = Lists;
    CardPageId = 73209692;
    insertAllowed = false;
    modifyAllowed = false;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Caption = 'Contract ID';
                    ToolTip = 'Unique identifier for the contract.';
                }
                field("FC_ID"; Rec."FC ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the final calculation.';
                }
                field("Unit Type"; Rec."Unit Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Type of unit associated with the final calculation.';
                }
                field("Contract Amount"; Rec."Contract Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Total amount of the contract.';
                }

                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Start date of the contract.';
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'End date of the contract.';
                }

                field("Initmation Date"; Rec."Intimation Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date when the final calculation was intimated.';
                }

                field("Termination Date"; Rec."Termination Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date when the contract was terminated.';
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    ToolTip = 'Unique identifier for the tenant associated with the final calculation.';
                }

                field("Original Contract Tenure"; Rec."Original Contract Tenure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Original tenure of the contract in months.';
                }


                field("Actual Contract Tenure"; Rec."Actual Contract Tenure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Actual tenure of the contract in months.';
                }


            }
        }
    }

}
