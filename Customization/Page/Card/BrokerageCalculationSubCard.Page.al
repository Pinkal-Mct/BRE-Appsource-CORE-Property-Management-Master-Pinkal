page 73209676 "BLRBrokerageCalculationSubCard"
{
    PageType = ListPart;
    SourceTable = "BLRBrokerageCalculationSub";
    ApplicationArea = All;
    Caption = 'Brokerage Calculation Sub Card';
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Brokerage Calculation Details';
                field("Owner ID"; Rec."BLROwner ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'The unique identifier for the owner associated with the brokerage calculation.';
                    Visible = false;
                }
                field("Owner Name"; Rec."BLROwner Name")
                {
                    ToolTip = 'The name of the owner associated with the brokerage calculation.';
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."BLRStart Date")
                {
                    ToolTip = 'The start date of the brokerage calculation period.';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."BLREnd Date")
                {
                    ToolTip = 'The end date of the brokerage calculation period.';
                    ApplicationArea = All;
                }
                field("Tenant Name"; Rec."BLRTenant Name")
                {
                    ToolTip = 'The name of the tenant associated with the brokerage calculation.';
                    ApplicationArea = All;
                }
                field("Property Name"; Rec."BLRProperty Name")
                {
                    ToolTip = 'The name of the property associated with the brokerage calculation.';
                    ApplicationArea = All;
                }
                field("Unit Name"; Rec."BLRUnit Name")
                {
                    ToolTip = 'The name of the unit associated with the brokerage calculation.';
                    ApplicationArea = All;
                }
                field("Unit Number"; Rec."BLRUnit Number")
                {
                    ToolTip = 'The number of the unit associated with the brokerage calculation.';
                    ApplicationArea = All;
                }
                field("Vendor Name"; Rec."BLRVendor Name")
                {
                    ToolTip = 'The name of the vendor associated with the brokerage calculation.';
                    ApplicationArea = All;
                }
                field("Calculation Method"; Rec."BLRCalculation Method")
                {
                    ToolTip = 'The method used for calculating the brokerage amount.';
                    ApplicationArea = All;
                }
                field("Base Amount Type"; Rec."BLRBase Amount Type")
                {
                    ToolTip = 'The type of base amount used for the brokerage calculation.';
                    ApplicationArea = All;
                }
                field("Base Amount"; Rec."BLRBase Amount")
                {
                    ToolTip = 'The base amount used for the brokerage calculation.';
                    ApplicationArea = All;
                }
                field("Brokerage Percentage"; Rec."BLRBrokerage Percentage")
                {
                    ToolTip = 'The percentage used for calculating the brokerage amount.';
                    ApplicationArea = All;
                }
                field("Brokerage Amount"; Rec."BLRBrokerage Amount")
                {
                    ToolTip = 'The calculated brokerage amount.';
                    ApplicationArea = All;
                }
                field("Paid By"; Rec."BLRPaid By")
                {
                    ToolTip = 'Indicates who paid the brokerage amount.';
                    ApplicationArea = All;
                }
                field("Remark"; Rec."BLRRemark")
                {
                    ToolTip = 'Any additional remarks or notes regarding the brokerage calculation.';
                    ApplicationArea = All;
                }
                field("Action Date"; Rec."BLRAction Date")
                {
                    ToolTip = 'The date when the brokerage calculation action was performed.';
                    ApplicationArea = All;
                }
                field("Property ID"; Rec."BLRProperty ID")
                {
                    ToolTip = 'The unique identifier for the property associated with the brokerage calculation.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ToolTip = 'The unique identifier for the contract associated with the brokerage calculation.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Vendor ID"; Rec."BLRVendor ID")
                {
                    ToolTip = 'The unique identifier for the vendor associated with the brokerage calculation.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Entry No."; Rec."BLREntry No.")
                {
                    ToolTip = 'The entry number for the brokerage calculation record.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("ID"; Rec."BLRID")
                {
                    ToolTip = 'The unique identifier for the brokerage calculation sub record.';
                    ApplicationArea = All;
                    Visible = false;
                }
            }
            field("Total brokerage Amount"; Rec."BLRTotal brokerage Amount")
            {
                ToolTip = 'The total brokerage amount calculated for the brokerage calculation.';
                ApplicationArea = All;
            }
        }
    }
}
