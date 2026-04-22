page 73209753 "Management Fee Calc Grid"
{
    PageType = ListPart;
    SourceTable = "Management Fee Calc. Line";
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
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                    ToolTip = 'System-generated entry number for the management fee record.';
                    Editable = false;
                    Visible = false;

                }
                field("Vendor ID"; Rec."Vendor ID")
                {
                    ApplicationArea = All;
                    Caption = 'PMC Vendor ID';
                    ToolTip = 'Specifies the vendor ID of the property management company.';
                    Editable = false;
                    Visible = false;
                }
                field("Owner ID"; Rec."Owner ID")
                {
                    ApplicationArea = All;
                    Caption = 'Owner ID';
                    Visible = false;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the property owner. This field is used when the management fee agreement is specific to a single owner.';
                }
                field("Property Management Company"; Rec."Property Management Company")
                {
                    ApplicationArea = All;
                    Caption = 'Property Management Company';
                    ToolTip = 'Specifies the name of the property management company responsible for managing the property.';
                    Editable = false;
                }
                field("Company/Owner Name"; Rec."Company/Owner Name")
                {
                    ApplicationArea = All;
                    Caption = 'Company / Owner Name';
                    ToolTip = 'Specifies the legal owner of the property.';
                    Editable = false;


                }

                field("Property Name"; Rec."Property Name")
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    ToolTip = 'Specifies the name of the property for which the management fee is defined.';
                    Editable = false;
                }

                field("Property Type"; Rec."Property Type")
                {
                    ApplicationArea = All;
                    Caption = 'Property Type';
                    ToolTip = 'Specifies whether the property is Residential or Commercial.';
                    Editable = false;
                }

                field("Calculation Method"; Rec."Calculation Method")
                {
                    ApplicationArea = All;
                    Caption = 'Calculation Method';
                    ToolTip = 'Specifies how the management fee is calculated, such as percentage of revenue, annual rent, collections, per unit, or hybrid.';
                    Editable = false;

                }

                field("Calculation Sub-Type"; Rec."Calculation Sub-Type")
                {
                    ApplicationArea = All;
                    Caption = 'Calculation Sub-Type';
                    ToolTip = 'Specifies whether the calculation is percentage-based or a fixed amount.';
                    Editable = false;
                }

                field("Percentage Type"; Rec."Percentage Type")
                {
                    ApplicationArea = All;
                    Caption = 'Percentage Type';
                    ToolTip = 'Specifies whether the percentage applied is fixed or variable.';
                    Editable = false;
                }
                field(Percentage; Rec.Percentage)
                {
                    ApplicationArea = All;
                    Caption = 'Percentage';
                    ToolTip = 'Specifies the agreed Percentage for management fee calculation.';
                    Editable = false;
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the agreed fixed amount for management fee calculation.';
                    Editable = false;
                }

                field("Base Amount Source"; Rec."Base Amount Source")
                {
                    ApplicationArea = All;
                    Caption = 'Base Amount Source';
                    ToolTip = 'Specifies the base amount used for fee calculation, such as revenue, collections, or annual rent.';
                    Editable = false;
                }

                field("Base Amount"; Rec."Base Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Base Amount';
                    Editable = false;
                    ToolTip = 'Specifies the calculated base amount used for management fee calculation based on the selected source.';
                }
                field("Management Fee"; Rec."Management Fee")
                {
                    ApplicationArea = All;
                    Caption = 'Management Fee';
                    Editable = false;
                    ToolTip = 'Specifies the calculated management fee based on the calculation method, percentage, and base amount.';
                }
                field("Base Amount Details"; Rec."Base Amount Details")
                {
                    ApplicationArea = All;
                    Caption = 'Base Amount Details';
                    ToolTip = 'Provides additional details about the base amount used for management fee calculation.';
                    Editable = false;

                    trigger OnDrillDown()
                    var
                        baseAmountHeader: Record "Base Amount Data Header";
                        baseAmountDetailsPage: Page "Base Amount Card";
                    begin
                        baseAmountHeader.SetRange("Header No.", Rec."Header No.");
                        baseAmountHeader.SetRange("Line No.", Rec."Entry No.");
                        baseAmountDetailsPage.SetTableView(baseAmountHeader);
                        baseAmountDetailsPage.Run();
                    end;
                }
                field("Validity Period"; Rec."Validity Period")
                {
                    ApplicationArea = All;
                    Caption = 'Validity Period';
                    Editable = false;
                    ToolTip = 'Specifies the date range during which this management fee agreement is valid.';
                    Visible = false;
                }
                field("Valid From"; Rec."Valid From")
                {
                    ApplicationArea = All;
                    Caption = 'Valid From';
                    ToolTip = 'Specifies the start date from which this management fee agreement is applicable.';
                    Editable = false;
                    Visible = false;
                }

                field("Valid To"; Rec."Valid To")
                {
                    ApplicationArea = All;
                    Caption = 'Valid To';
                    ToolTip = 'Specifies the end date until which this management fee agreement is applicable.';
                    Editable = false;
                    Visible = false;
                }

                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Status';
                    ToolTip = 'Indicates whether the management fee contract is active or expired.';
                    Editable = false;
                    Visible = false;
                }
            }

            field("Total Mgt. Fee"; Rec."Total Mgt. Fee")
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
                    MgtFeeCalc: Record "Management Fee Calc. Header";
                begin
                    // if MgtFeeCalc.Get(Rec."Header No.") then
                    //     Report.Run(50119, false, false, MgtFeeCalc);
                    // MgtFeeCalc.Reset();
                    MgtFeeCalc.SetRange("Entry No.", Rec."Header No.");
                    Report.Run(73209584, false, false, MgtFeeCalc);
                end;

            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        Rec.CalcFields("Total Mgt. Fee");
    end;

    trigger OnOpenPage()
    begin
        if Rec.IsEmpty() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
