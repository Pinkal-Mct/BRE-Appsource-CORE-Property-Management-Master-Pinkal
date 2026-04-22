page 73209676 "Brokerage Calculation Sub Card"
{
    PageType = ListPart;
    SourceTable = "Brokerage Calculation Sub";
    ApplicationArea = All;
    Caption = 'Brokerage Calculation Sub Card';
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'Brokerage Calculation Details';
                field("Owner ID"; Rec."Owner ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'The unique identifier for the owner associated with the brokerage calculation.';
                    Visible = false;
                }
                field("Owner Name"; Rec."Owner Name")
                {
                    ToolTip = 'The name of the owner associated with the brokerage calculation.';
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'The start date of the brokerage calculation period.';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'The end date of the brokerage calculation period.';
                    ApplicationArea = All;
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ToolTip = 'The name of the tenant associated with the brokerage calculation.';
                    ApplicationArea = All;
                }
                field("Property Name"; Rec."Property Name")
                {
                    ToolTip = 'The name of the property associated with the brokerage calculation.';
                    ApplicationArea = All;
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ToolTip = 'The name of the unit associated with the brokerage calculation.';
                    ApplicationArea = All;
                }
                field("Unit Number"; Rec."Unit Number")
                {
                    ToolTip = 'The number of the unit associated with the brokerage calculation.';
                    ApplicationArea = All;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'The name of the vendor associated with the brokerage calculation.';
                    ApplicationArea = All;
                }
                field("Calculation Method"; Rec."Calculation Method")
                {
                    ToolTip = 'The method used for calculating the brokerage amount.';
                    ApplicationArea = All;
                }
                field("Base Amount Type"; Rec."Base Amount Type")
                {
                    ToolTip = 'The type of base amount used for the brokerage calculation.';
                    ApplicationArea = All;
                }
                field("Base Amount"; Rec."Base Amount")
                {
                    ToolTip = 'The base amount used for the brokerage calculation.';
                    ApplicationArea = All;
                }
                field("Brokerage Percentage"; Rec."Brokerage Percentage")
                {
                    ToolTip = 'The percentage used for calculating the brokerage amount.';
                    ApplicationArea = All;
                }
                field("Brokerage Amount"; Rec."Brokerage Amount")
                {
                    ToolTip = 'The calculated brokerage amount.';
                    ApplicationArea = All;
                }
                field("Paid By"; Rec."Paid By")
                {
                    ToolTip = 'Indicates who paid the brokerage amount.';
                    ApplicationArea = All;
                }
                field("Remark"; Rec."Remark")
                {
                    ToolTip = 'Any additional remarks or notes regarding the brokerage calculation.';
                    ApplicationArea = All;
                }
                field("Action Date"; Rec."Action Date")
                {
                    ToolTip = 'The date when the brokerage calculation action was performed.';
                    ApplicationArea = All;
                }
                field("Property ID"; Rec."Property ID")
                {
                    ToolTip = 'The unique identifier for the property associated with the brokerage calculation.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ToolTip = 'The unique identifier for the contract associated with the brokerage calculation.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Vendor ID"; Rec."Vendor ID")
                {
                    ToolTip = 'The unique identifier for the vendor associated with the brokerage calculation.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'The entry number for the brokerage calculation record.';
                    ApplicationArea = All;
                    Visible = false;
                }
                field("ID"; Rec."ID")
                {
                    ToolTip = 'The unique identifier for the brokerage calculation sub record.';
                    ApplicationArea = All;
                    Visible = false;
                }
            }
            field("Total brokerage Amount"; Rec."Total brokerage Amount")
            {
                ToolTip = 'The total brokerage amount calculated for the brokerage calculation.';
                ApplicationArea = All;
            }
        }
    }
}
