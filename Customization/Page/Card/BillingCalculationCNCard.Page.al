page 73209674 "BLRBilling Calculation CN Card"
{
    PageType = ListPart;
    SourceTable = "BLRBillingCalculationCN";
    ApplicationArea = All;
    Caption = 'Billing Calculation CN Card';
    layout
    {
        area(content)
        {
            repeater("Contract Details")
            {
                field("Credit Note ID"; Rec."BLRCredit Note ID")
                {
                    ToolTip = 'The unique identifier for the credit note associated with the billing calculation.';
                    ApplicationArea = all;
                    Caption = 'Credit Note ID';
                    Editable = false;
                }
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ToolTip = 'The unique identifier for the contract associated with the billing calculation.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ToolTip = 'The unique identifier for the tenant associated with the billing calculation.';
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    Editable = false;
                }
                field("Item"; Rec."BLRItem")
                {
                    ToolTip = 'The name of the item associated with the billing calculation.';
                    ApplicationArea = All;
                    Caption = 'Item';
                    Editable = false;
                }
                field("Amount"; Rec."BLRAmount")
                {
                    ToolTip = 'The amount of the item associated with the billing calculation.';
                    ApplicationArea = All;
                    Caption = 'Amount';
                    Editable = false;
                }
                field("VAT Amount"; Rec."BLRVAT Amount")
                {
                    ToolTip = 'The VAT amount associated with the billing calculation.';
                    ApplicationArea = All;
                    Caption = 'VAT Amount';
                    Editable = false;
                }
                field("Amount Including VAT"; Rec."BLRAmount Including VAT")
                {
                    ToolTip = 'The total amount including VAT for the billing calculation.';
                    ApplicationArea = All;
                    Caption = 'Amount Including VAT';
                    Editable = false;
                }
                field("VAT %"; Rec."BLRVAT %")
                {
                    ToolTip = 'The VAT percentage applied to the billing calculation.';
                    ApplicationArea = All;
                    Caption = 'VAT %';
                    Editable = false;
                }
            }
            field("Total Amount"; Rec."BLRTotal Amount")
            {
                ToolTip = 'The total amount calculated for the billing calculation.';
                ApplicationArea = All;
            }
        }
    }
}