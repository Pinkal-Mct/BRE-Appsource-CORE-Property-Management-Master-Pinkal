page 73209798 "Rent Calculation List"
{
    PageType = List;
    SourceTable = "Rent Calculation";
    ApplicationArea = All;
    Caption = 'Rent Calculation List';
    UsageCategory = Lists;
    CardPageId = 73209720;


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
                    ToolTip = 'Specifies the unique identifier for the contract associated with the rent calculation.';
                }
                field("RC_ID"; Rec."RC ID")
                {
                    ApplicationArea = All;
                    Caption = 'RC_ID';
                    ToolTip = 'Specifies the unique identifier for the rent calculation.';
                }
                field("Secondary Item Type"; Rec."Secondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                    ToolTip = 'Specifies the type of secondary item associated with the rent calculation, such as Maintenance or Utilities.';
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the amount associated with the rent calculation, which can be a fixed amount or a percentage of the contract amount.';
                }

                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                    ToolTip = 'Specifies the start date of the contract associated with the rent calculation.';
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
                    ToolTip = 'Specifies the end date of the contract associated with the rent calculation.';
                }

                field("Number of Installments"; Rec."Number of Installments")
                {
                    ApplicationArea = All;
                    Caption = 'Number of Instalments';
                    ToolTip = 'Specifies the number of installments for the rent calculation, indicating how many payments are to be made.';
                }

            }
        }
    }

}
