page 73209763 "Base Amount Unit Wise Grid"
{
    PageType = ListPart;
    SourceTable = "Base Amount Data Unit Wise";
    ApplicationArea = All;
    Caption = 'Base Amount Report';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Report Date"; Rec."Report Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the report.';
                }

                field("Financial Year"; Rec."Financial Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the financial year for the report.';
                }

                field("Period From"; Rec."Period From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the starting date of the period for the report.';
                }

                field("Period To"; Rec."Period To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ending date of the period for the report.';
                }

                field("Property Management Company"; Rec."Property Management Company")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the property management company.';
                }

                field("Company Owner Name"; Rec."Company Owner Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the company owner.';
                }

                field("Property Name"; Rec."Property Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the property.';
                }

                field("Property Type"; Rec."Property Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of the property (e.g., Residential, Commercial).';
                }

                field("Unit Number"; Rec."Unit Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unit number of the property.';
                }

                field("Unit Status"; Rec."Unit Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the unit (e.g., Occupied, Vacant).';
                }

                field("Contract Id"; Rec."Contract Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier for the contract associated with the unit.';
                }
                field("Multi Year Start Date"; Rec."Multi Year Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the starting date of the multi-year period for the report.';
                }

                field("Multi Year End Date"; Rec."Multi Year End Date")
                {
                    ApplicationArea = All;
                        ToolTip = 'Specifies the ending date of the multi-year period for the report.';
                }

                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status of the contract (e.g., Active, Inactive).';
                }

                field("Month"; Rec."Month")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the month for the report.';
                }

                field("Base Amount Source"; Rec."Base Amount Source")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the source of the base amount, such as Rent, Service Charge, or Other.';
                }

                field("Quantity"; Rec."Quantity")
                {
                    ApplicationArea = All;
                        ToolTip = 'Specifies the quantity used for calculating the base amount, such as the number of units or square footage.';
                }
            }
            field("Total Quantity"; Rec."Total Quantity")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the total quantity for the report, calculated as the sum of the Quantity field for all lines.';
            }

        }
    }

}