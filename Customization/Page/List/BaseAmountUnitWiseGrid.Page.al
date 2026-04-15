page 50151 "Base Amount Unit Wise Grid"
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
                }

                field("Financial Year"; Rec."Financial Year")
                {
                    ApplicationArea = All;
                }

                field("Period From"; Rec."Period From")
                {
                    ApplicationArea = All;
                }

                field("Period To"; Rec."Period To")
                {
                    ApplicationArea = All;
                }

                field("Property Management Company"; Rec."Property Management Company")
                {
                    ApplicationArea = All;
                }

                field("Company Owner Name"; Rec."Company Owner Name")
                {
                    ApplicationArea = All;
                }

                field("Property Name"; Rec."Property Name")
                {
                    ApplicationArea = All;
                }

                field("Property Type"; Rec."Property Type")
                {
                    ApplicationArea = All;
                }

                field("Unit Number"; Rec."Unit Number")
                {
                    ApplicationArea = All;
                }

                field("Unit Status"; Rec."Unit Status")
                {
                    ApplicationArea = All;
                }

                field("Contract Id"; Rec."Contract Id")
                {
                    ApplicationArea = All;
                }
                field("Multi Year Start Date"; Rec."Multi Year Start Date")
                {
                    ApplicationArea = All;
                }

                field("Multi Year End Date"; Rec."Multi Year End Date")
                {
                    ApplicationArea = All;
                }

                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                }

                field("Month"; Rec."Month")
                {
                    ApplicationArea = All;
                }

                field("Base Amount Source"; Rec."Base Amount Source")
                {
                    ApplicationArea = All;
                }

                field("Quantity"; Rec."Quantity")
                {
                    ApplicationArea = All;
                }
            }
            field("Total Quantity"; Rec."Total Quantity")
            {
                ApplicationArea = All;
            }

        }
    }

}