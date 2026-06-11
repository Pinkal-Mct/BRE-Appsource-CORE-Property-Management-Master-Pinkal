page 73209720 "BLRRent Calculation Card"
{
    PageType = Card;
    SourceTable = "BLRRentCalculation";
    ApplicationArea = All;
    Caption = 'Rent Calculation Card';

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Lookup = true;
                    ToolTip = 'The unique identifier for the contract associated with this rent calculation.';
                }

                field("RC ID"; Rec."BLRRC ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The unique identifier for the rent calculation.';
                }

                field("Secondary Item Type"; Rec."BLRSecondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                    ToolTip = 'Enter the Secondary Item Type.';
                }
                field("Amount"; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Enter the Amount.';
                }

                field("Contract Start Date"; Rec."BLRContract Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                    ToolTip = 'Enter the Contract Start Date.';
                }
                field("Contract End Date"; Rec."BLRContract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
                    ToolTip = 'Enter the Contract End Date.';
                }

                field("Number of Installments"; Rec."BLRNumber of Installments")
                {
                    ApplicationArea = All;
                    Caption = 'Number of Instalments';
                    ToolTip = 'Enter the Number of Instalments.';
                    Editable = false;
                }

                field("VAT Amount"; Rec."BLRVAT Amount")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Amount';
                    ToolTip = 'Enter the VAT Amount.';
                }

                field("Amount Including VAT"; Rec."BLRAmount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Including VAT';
                    ToolTip = 'Enter the Amount Including VAT.';
                }

                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'The unique identifier for the tenant associated with this rent calculation.';
                }
                field("Rent Calculation Type"; Rec."BLRRent Calculation Type")
                {
                    ApplicationArea = All;
                    Caption = 'Rent Calculation Type';
                    ToolTip = 'Enter the Rent Calculation Type.';
                }

                field("VAT %"; Rec."BLRVAT %")
                {
                    ApplicationArea = All;
                    Caption = 'VAT %';
                    ToolTip = 'Enter the VAT %.';
                    Editable = false;
                }

                field("Property Classification"; Rec."BLRProperty Classification")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The classification of the property associated with this rent calculation.';
                }
            }

            group("BLRPaymentSchedule")
            {
                part("BLRRentCalculation"; "BLRRent Calculation SubCard")
                {
                    SubPageLink = "BLRRC ID" = FIELD("BLRRC ID");
                    ApplicationArea = All;
                }
            }
            group("Rent Payment Schedule")
            {
                part("Rent Calculation2";
                "BLRRent Calculation SubCard2")
                {
                    SubPageLink = "BLRRC ID" = FIELD("BLRRC ID");
                    ApplicationArea = All;
                }
            }
        }
    }
}