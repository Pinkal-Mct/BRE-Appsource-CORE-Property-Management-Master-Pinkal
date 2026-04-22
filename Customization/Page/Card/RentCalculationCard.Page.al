page 73209720 "Rent Calculation Card"
{
    PageType = Card;
    SourceTable = "Rent Calculation";
    ApplicationArea = All;
    Caption = 'Rent Calculation Card';

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Lookup = true;
                    ToolTip = 'The unique identifier for the contract associated with this rent calculation.';
                }

                field("RC ID"; Rec."RC ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The unique identifier for the rent calculation.';
                }

                field("Secondary Item Type"; Rec."Secondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                    ToolTip = 'Enter the Secondary Item Type.';
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Enter the Amount.';
                }

                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                    ToolTip = 'Enter the Contract Start Date.';
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
                    ToolTip = 'Enter the Contract End Date.';
                }

                field("Number of Installments"; Rec."Number of Installments")
                {
                    ApplicationArea = All;
                    Caption = 'Number of Instalments';
                    ToolTip = 'Enter the Number of Instalments.';
                    Editable = false;
                }

                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Amount';
                    ToolTip = 'Enter the VAT Amount.';
                }

                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Including VAT';
                    ToolTip = 'Enter the Amount Including VAT.';
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'The unique identifier for the tenant associated with this rent calculation.';
                }
                field("Rent Calculation Type"; Rec."Rent Calculation Type")
                {
                    ApplicationArea = All;
                    Caption = 'Rent Calculation Type';
                    ToolTip = 'Enter the Rent Calculation Type.';
                }

                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = All;
                    Caption = 'VAT %';
                    ToolTip = 'Enter the VAT %.';
                    Editable = false;
                }

                field("Property Classification"; Rec."Property Classification")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The classification of the property associated with this rent calculation.';
                }
            }

            group("Payment Schedule")
            {
                part("Rent Calculation"; "Rent Calculation SubCard")
                {
                    SubPageLink = "RC ID" = FIELD("RC ID");
                    ApplicationArea = All;
                }
            }
            group("Rent Payment Schedule")
            {
                part("Rent Calculation2";
                "Rent Calculation SubCard2")
                {
                    SubPageLink = "RC ID" = FIELD("RC ID");
                    ApplicationArea = All;
                }
            }
        }
    }
}