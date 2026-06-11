page 73209703 "BLROtherPaymentCalSubCard"
{
    PageType = ListPart;
    ApplicationArea = All;
    DeleteAllowed = true;
    // UsageCategory = Administration;
    SourceTable = "BLROtherPaymentCalculateSub";

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
                    ToolTip = 'The Tenant ID is used to identify the tenant associated with this record.';
                }

                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Visible = false;
                    ToolTip = 'The Contract ID is used to identify the contract associated with this record.';
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
                    ToolTip = 'The Amount is the monetary value associated with this record.';
                }

                field("VAT Amount"; Rec."BLRVAT Amount")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The VAT Amount is the value-added tax applied to the amount.';
                }

                field("Amount Including VAT"; Rec."BLRAmount Including VAT")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The Amount Including VAT is the total amount after adding VAT.';
                }

                field("Start Date"; Rec."BLRStart Date")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The Start Date indicates when the payment period begins.';
                }

                field("End Date"; Rec."BLREnd Date")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The End Date indicates when the payment period ends.';
                }
            }

            group(" ")
            {
                field("Total Amount"; Rec."BLRTotal Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'The Total Amount is the sum of all amounts in this record.';
                }

                field("Total VAT Amount"; Rec."BLRTotal VAT Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'The Total VAT Amount is the sum of all VAT amounts in this record.';
                }

                field("Total Amount Including VAT"; Rec."BLRTotal Amount Including VAT")
                {
                    ApplicationArea = All;
                    ToolTip = 'The Total Amount Including VAT is the sum of all amounts including VAT in this record.';
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