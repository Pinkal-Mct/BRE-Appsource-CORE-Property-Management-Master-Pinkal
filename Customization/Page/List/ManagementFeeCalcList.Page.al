page 73209782 "BLRManagement Fee Calc. List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "BLRManagementFeeCalcHeader";
    Caption = 'Management Fee Calculation List';
    CardPageId = 73209698;
    ModifyAllowed = false;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(MgtFeeCalcList)
            {
                field("Entry No."; Rec."BLREntry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                    ToolTip = 'Specifies the entry number of the management fee calculation record.';
                }
                field("Report Date"; Rec."BLRReport Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the management fee report.';
                }
                field("Owner Name"; Rec."BLROwner Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the owner for whom the management fee is calculated.';
                }
                field("All Owners"; Rec."BLRAll Owners")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether the management fee calculation applies to all owners.';
                }
                field(Property; Rec."BLRProperty")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the property associated with the management fee calculation.';
                }
                field("All Properties"; Rec."BLRAll Properties")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether the management fee calculation applies to all properties.';
                }
                field("Financial Year"; Rec."BLRFinancial Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the financial year for the management fee calculation.';
                }
                field("Period From"; Rec."BLRPeriod From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the starting period for the management fee calculation.';
                }
                field("Period To"; Rec."BLRPeriod To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ending period for the management fee calculation.';
                }
            }
        }
    }
}