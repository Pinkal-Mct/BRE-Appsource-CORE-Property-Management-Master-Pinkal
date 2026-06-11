page 73209748 "BLRTermination ChargesSubCard"
{
    PageType = ListPart;
    ApplicationArea = All;
    // UsageCategory = Administration;
    SourceTable = "BLRTerminationChargesSub";
    Caption = 'Termination Additional Charges';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Secondary Item Type"; Rec."BLRSecondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                    ToolTip = 'Specifies the type of secondary item for the termination charge.';
                }
                field("Amount"; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the amount of the termination charge.';
                }
                field("VAT %"; Rec."BLRVAT %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the VAT percentage applied to the termination charge.';
                }
                field("VAT Amount"; Rec."BLRVAT Amount")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Amount';
                    ToolTip = 'Specifies the amount of VAT applied to the termination charge.';
                }
                field("Amount Including VAT"; Rec."BLRAmount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Including VAT';
                    ToolTip = 'Specifies the total amount of the termination charge including VAT.';
                }
                field("Start Date"; Rec."BLRStart Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    ToolTip = 'Specifies the start date for the termination charge.';
                }
                field("End Date"; Rec."BLREnd Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    ToolTip = 'Specifies the end date for the termination charge.';
                }
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'Specifies the contract associated with the termination charge.';
                }
                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'Specifies the tenant associated with the termination charge.';
                }
                field("Posted Invoice ID"; Rec."BLRPosted Invoice ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of the posted invoice associated with the termination charge.';
                }

            }
        }
    }
}