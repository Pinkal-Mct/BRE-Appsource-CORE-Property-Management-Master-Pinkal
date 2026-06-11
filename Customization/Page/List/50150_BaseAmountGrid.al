page 73209751 "BLRBase Amount Report Grid"
{
    PageType = ListPart;
    SourceTable = "BLRBaseAmountData";
    ApplicationArea = All;
    Caption = 'Base Amount Report';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Report Date"; Rec."BLRReport Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the report.';
                }

                field("Financial Year"; Rec."BLRFinancial Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the financial year for the report.';
                }

                field("Period From"; Rec."BLRPeriod From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the starting date of the period for the report.';
                }

                field("Period To"; Rec."BLRPeriod To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ending date of the period for the report.';
                }

                field("Property Management Company"; Rec."BLRProperty Management Company")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the property management company.';
                }

                field("Company Owner Name"; Rec."BLRCompany Owner Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the company owner.';
                }

                field("Property Name"; Rec."BLRProperty Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the property.';
                }

                field("BLRPropertyType"; Rec."BLRProperty Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of the property (e.g., Residential, Commercial).';
                }

                field("Unit Number"; Rec."BLRUnit Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit number of the property.';
                }

                field("Unit Status"; Rec."BLRUnit Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status of the unit (e.g., Occupied, Vacant).';
                }

                field("Contract Id"; Rec."BLRContract Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier for the contract associated with the property.';
                }

                field("Receipt Date"; Rec."BLRReceipt Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the payment was received.';
                }

                field("Receipt No."; Rec."BLRReceipt No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the receipt number for the payment.';
                }
                field("Multi Year Start Date"; Rec."BLRMulti Year Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the starting date of the multi-year period for the report.';
                }

                field("Multi Year End Date"; Rec."BLRMulti Year End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ending date of the multi-year period for the report.';
                }

                field("Annual Rent Amount"; Rec."BLRAnnual Rent Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the annual rent amount for the property.';
                }

                field("Contract Status"; Rec."BLRContract Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status of the contract (e.g., Active, Terminated).';
                }

                field("Month"; Rec."BLRMonth")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the month for which the base amount is calculated.';
                }

                field("Base Amount Source"; Rec."BLRBase Amount Source")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source used for calculating the base amount (e.g., Rent, Market Value).';
                }

                field("Quantity"; Rec."BLRQuantity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the quantity for the base amount calculation.';
                }
                field("Base Amount"; Rec."BLRBase Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Base Amount';
                    ToolTip = 'Specifies the calculated base amount used for management fee calculation based on the selected source.';
                }
            }
            field("Total Amount"; Rec."BLRTotal Amount")
            {
                ApplicationArea = All;
                Caption = 'Total Amount';
                ToolTip = 'Specifies the total amount calculated for the report.';
            }

        }
    }

}