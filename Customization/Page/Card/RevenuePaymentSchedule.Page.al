page 73209726 "BLRRevenue Payment Schedule"
{
    PageType = ListPart;
    ApplicationArea = All;
    // UsageCategory = Administration;
    SourceTable = "BLRRevenueStructureSubpage1";
    Caption = 'Revenue Payment Schedule';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                field("Year"; Rec."BLRYear")
                {
                    ApplicationArea = All;
                    Caption = 'Year';
                    ToolTip = 'Enter the Year.';
                }
                field("Installment No."; Rec."BLRInstallment No.")
                {
                    ApplicationArea = All;
                    Caption = 'Instalment No.';
                    ToolTip = 'Enter the Instalment No.';
                }

                field("Installment Start Date"; Rec."BLRInstallment Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Instalment Start Date';
                    ToolTip = 'Enter the Instalment Start Date.';
                }

                field("Installment End Date"; Rec."BLRInstallment End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Instalment End Date';
                    ToolTip = 'Enter the Instalment End Date.';
                }

                field("Due Date"; Rec."BLRDue Date")
                {
                    ApplicationArea = All;
                    Caption = 'Due Date';
                    ToolTip = 'Enter the Due Date.';
                }

                field("Amount"; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Enter the Amount.';
                }

                field("VAT Amount"; Rec."BLRVAT Amount")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Amount';
                    Visible = false;
                    Editable = false;
                    ToolTip = 'Enter the VAT Amount.';
                }

                field("Amount Including VAT"; Rec."BLRAmount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Including VAT';
                    Visible = false;
                    ToolTip = 'Enter the Amount Including VAT.';
                }

                field("Secondary Item Type"; Rec."BLRSecondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                    Visible = false;
                    ToolTip = 'Enter the Secondary Item Type.';
                }

                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'The ID of the tenant associated with this payment schedule.';
                }

                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'The ID of the contract associated with this payment schedule.';
                }


                field("VAT %"; Rec."BLRVAT %")
                {
                    ApplicationArea = All;
                    Caption = 'VAT %';
                    ToolTip = 'Enter the VAT %.';
                    Editable = false;
                    Visible = false;
                }

            }
            group(TotalAmount)
            {
                field("Total Amount"; Rec."BLRTotal Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Total Amount';
                    ToolTip = 'The total amount of the payment schedule.';
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