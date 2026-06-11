page 73209709 "BLRPayment Schedule Card"
{
    PageType = Card;
    SourceTable = "BLRPaymentSchedule";
    ApplicationArea = All;
    Caption = 'Payment Schedule Card';

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = true; // The ID is not editable since it's auto-incrementing
                    ShowMandatory = true;
                    NotBlank = true;
                    ToolTip = 'Enter the Contract ID.';
                }

                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                    ToolTip = 'The ID of the tenant associated with this payment schedule.';
                }

                field("Tenant Name"; Rec."BLRTenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The name of the tenant associated with this payment schedule.';
                }
                field("Contract Status"; Rec."BLRContract Status")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Status';
                    Editable = false;
                    ToolTip = 'The status of the contract associated with this payment schedule.';
                }
                field("Contract Start date"; Rec."BLRContract Start date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The start date of the contract associated with this payment schedule.';
                }
                field("Contract End date"; Rec."BLRContract End date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The end date of the contract associated with this payment schedule.';
                }
                field("Property ID"; Rec."BLRProperty ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The ID of the property associated with this payment schedule.';
                }

            }

            part("PaymentSchedule"; "BLRPayment Schedule Card2")
            {
                SubPageLink = "BLRContract ID" = FIELD("BLRContract ID"),
                  "BLRTenant ID" = FIELD("BLRTenant ID");
                ApplicationArea = All;
                Caption = 'Payment Schedule';

            }

            group(TotalAmountCalculation)
            {
                Caption = 'Total Amount Calculation';
                field("Total Amount"; Rec."BLRTotal Amount")
                {
                    Caption = 'Total Amount';
                    Editable = false;
                    ToolTip = 'The total amount for the payment schedule.';
                }
                field("Total VAT Amount"; Rec."BLRTotal VAT Amount")
                {
                    Caption = 'Total VAT Amount';
                    Editable = false;
                    ToolTip = 'The total VAT amount for the payment schedule.';
                }
                field("Total Amount Including VAT"; Rec."BLRTotal Amount Including VAT")
                {
                    Caption = 'Total Amount Including VAT';
                    Editable = false;
                    ToolTip = 'The total amount including VAT for the payment schedule.';
                }
            }

        }
    }

}