page 73209724 "BLRRevenue Calculate Sub Card"
{
    PageType = ListPart;
    ApplicationArea = All;
    DeleteAllowed = true;
    // UsageCategory = Administration;
    SourceTable = "BLRRevenueCalculateSub";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Visible = false;
                    ToolTip = 'The Tenant ID is auto-generated and not editable.';
                }

                field("RS ID"; Rec."BLRRS ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Visible = false;
                    ToolTip = 'The RS ID is auto-generated and not editable.';
                }

                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Visible = false;
                    ToolTip = 'The Contract ID is auto-generated and not editable.';
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
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Enter the Amount.';
                }

                field("VAT Amount"; Rec."BLRVAT Amount")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Enter the VAT Amount.';
                }

                field("Amount Including VAT"; Rec."BLRAmount Including VAT")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Enter the Amount Including VAT.';
                }

                field("Installment Start Date"; Rec."BLRInstallment Start Date")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Enter the Installment Start Date.';
                }

                field("Installment End Date"; Rec."BLRInstallment End Date")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Enter the Installment End Date.';
                }
            }

            group(" ")
            {
                field("Total Amount"; Rec."BLRTotal Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Total Amount for the period.';
                }

                field("Total VAT Amount"; Rec."BLRTotal VAT Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Total VAT Amount for the period.';
                }

                field("Total Amount Including VAT"; Rec."BLRTotal Amount Including VAT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Total Amount Including VAT for the period.';
                }
            }
        }
    }

    procedure SetContractID(pContractID: Integer)
    begin
        ContractID := pContractID;
    end;

    procedure SetProposalID(pProposalID: Integer)
    begin

    end;

    procedure SetTenantID(pTenantID: Code[20])
    begin
        tenantID := pTenantID;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."BLRContract ID" := ContractID;
        Rec."BLRTenant ID" := tenantID;

    end;

    var
        ContractID: Integer;
        tenantID: Code[20];

}