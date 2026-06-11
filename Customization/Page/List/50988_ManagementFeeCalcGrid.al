page 73209753 "BLRManagement Fee Calc Grid"
{
    PageType = ListPart;
    SourceTable = "BLRManagementFeeCalcLine";
    ApplicationArea = All;
    Caption = 'Management Fee Agreements';
    UsageCategory = None;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."BLREntry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                    ToolTip = 'System-generated entry number for the management fee record.';
                    Editable = false;
                    Visible = false;

                }
                field("Vendor ID"; Rec."BLRVendor ID")
                {
                    ApplicationArea = All;
                    Caption = 'PMC Vendor ID';
                    ToolTip = 'Specifies the vendor ID of the property management company.';
                    Editable = false;
                    Visible = false;
                }
                field("Owner ID"; Rec."BLROwner ID")
                {
                    ApplicationArea = All;
                    Caption = 'Owner ID';
                    Visible = false;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the property owner. This field is used when the management fee agreement is specific to a single owner.';
                }
                field("Property Management Company"; Rec."BLRProperty Management Company")
                {
                    ApplicationArea = All;
                    Caption = 'Property Management Company';
                    ToolTip = 'Specifies the name of the property management company responsible for managing the property.';
                    Editable = false;
                }
                field("Company/Owner Name"; Rec."BLRCompany/Owner Name")
                {
                    ApplicationArea = All;
                    Caption = 'Company / Owner Name';
                    ToolTip = 'Specifies the legal owner of the property.';
                    Editable = false;


                }

                field("Property Name"; Rec."BLRProperty Name")
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    ToolTip = 'Specifies the name of the property for which the management fee is defined.';
                    Editable = false;
                }

                field("BLRPropertyType"; Rec."BLRProperty Type")
                {
                    ApplicationArea = All;
                    Caption = 'Property Type';
                    ToolTip = 'Specifies whether the property is Residential or Commercial.';
                    Editable = false;
                }

                field("Calculation Method"; Rec."BLRCalculation Method")
                {
                    ApplicationArea = All;
                    Caption = 'Calculation Method';
                    ToolTip = 'Specifies how the management fee is calculated, such as percentage of revenue, annual rent, collections, per unit, or hybrid.';
                    Editable = false;

                }

                field("Calculation Sub-Type"; Rec."BLRCalculation Sub-Type")
                {
                    ApplicationArea = All;
                    Caption = 'Calculation Sub-Type';
                    ToolTip = 'Specifies whether the calculation is percentage-based or a fixed amount.';
                    Editable = false;
                }

                field("Percentage Type"; Rec."BLRPercentage Type")
                {
                    ApplicationArea = All;
                    Caption = 'Percentage Type';
                    ToolTip = 'Specifies whether the percentage applied is fixed or variable.';
                    Editable = false;
                }
                field(Percentage; Rec.BLRPercentage)
                {
                    ApplicationArea = All;
                    Caption = 'Percentage';
                    ToolTip = 'Specifies the agreed Percentage for management fee calculation.';
                    Editable = false;
                }
                field("Amount"; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the agreed fixed amount for management fee calculation.';
                    Editable = false;
                }

                field("Base Amount Source"; Rec."BLRBase Amount Source")
                {
                    ApplicationArea = All;
                    Caption = 'Base Amount Source';
                    ToolTip = 'Specifies the base amount used for fee calculation, such as revenue, collections, or annual rent.';
                    Editable = false;
                }

                field("Base Amount"; Rec."BLRBase Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Base Amount';
                    Editable = false;
                    ToolTip = 'Specifies the calculated base amount used for management fee calculation based on the selected source.';
                }
                field("Management Fee"; Rec."BLRManagement Fee")
                {
                    ApplicationArea = All;
                    Caption = 'Management Fee';
                    Editable = false;
                    ToolTip = 'Specifies the calculated management fee based on the calculation method, percentage, and base amount.';
                }
                field("Base Amount Details"; Rec."BLRBase Amount Details")
                {
                    ApplicationArea = All;
                    Caption = 'Base Amount Details';
                    ToolTip = 'Provides additional details about the base amount used for management fee calculation.';
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        baseAmountHeader: Record "BLRBaseAmountDataHeader";
                        baseAmountDetailsPage: Page "BLRBase Amount Card";
                    begin
                        baseAmountHeader.SetRange("BLRHeader No.", Rec."BLRHeader No.");
                        baseAmountHeader.SetRange("BLRLine No.", Rec."BLREntry No.");
                        baseAmountDetailsPage.SetTableView(baseAmountHeader);
                        baseAmountDetailsPage.Run();
                    end;
                }
                field("Validity Period"; Rec."BLRValidity Period")
                {
                    ApplicationArea = All;
                    Caption = 'Validity Period';
                    Editable = false;
                    ToolTip = 'Specifies the date range during which this management fee agreement is valid.';
                    Visible = false;
                }
                field("Valid From"; Rec."BLRValid From")
                {
                    ApplicationArea = All;
                    Caption = 'Valid From';
                    ToolTip = 'Specifies the start date from which this management fee agreement is applicable.';
                    Editable = false;
                    Visible = false;
                }

                field("Valid To"; Rec."BLRValid To")
                {
                    ApplicationArea = All;
                    Caption = 'Valid To';
                    ToolTip = 'Specifies the end date until which this management fee agreement is applicable.';
                    Editable = false;
                    Visible = false;
                }

                field("Contract Status"; Rec."BLRContract Status")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Status';
                    ToolTip = 'Indicates whether the management fee contract is active or expired.';
                    Editable = false;
                    Visible = false;
                }
            }

            field("Total Mgt. Fee"; Rec."BLRTotal Mgt. Fee")
            {
                ApplicationArea = All;
                ToolTip = 'Indicates the Total Managment Fee';
            }

        }

    }
    actions
    {
        area(Processing)
        {
            action(GenerateReport)
            {
                Caption = 'Generate Report';
                ToolTip = 'Generate a detailed report of management fee calculations.';
                Image = Report;
                trigger OnAction()
                var
                    MgtFeeCalc: Record "BLRManagementFeeCalcHeader";
                begin
                    // if MgtFeeCalc.Get(Rec."BLRHeader No.") then
                    //     Report.Run(50119, false, false, MgtFeeCalc);
                    // MgtFeeCalc.Reset();
                    MgtFeeCalc.SetRange("BLREntry No.", Rec."BLRHeader No.");
                    Report.Run(73209584, false, false, MgtFeeCalc);
                end;

            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        Rec.CalcFields("BLRTotal Mgt. Fee");
    end;

    trigger OnOpenPage()
    begin
        if Rec.IsEmpty() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
