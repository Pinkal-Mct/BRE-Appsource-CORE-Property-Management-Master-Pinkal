page 73209703 "OtherPayment Calculate SubCard"
{
    PageType = ListPart;
    ApplicationArea = All;
    DeleteAllowed = true;
    // UsageCategory = Administration;
    SourceTable = "Other Payment Calculate Sub";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Visible = false;
                    ToolTip = 'The Tenant ID is used to identify the tenant associated with this record.';
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Visible = false;
                    ToolTip = 'The Contract ID is used to identify the contract associated with this record.';
                }

                field("Secondary Item Type"; Rec."Secondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                    ToolTip = 'Enter the Secondary Item Type.';
                }

                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The Amount is the monetary value associated with this record.';
                }

                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The VAT Amount is the value-added tax applied to the amount.';
                }

                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The Amount Including VAT is the total amount after adding VAT.';
                }

                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The Start Date indicates when the payment period begins.';
                }

                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The End Date indicates when the payment period ends.';
                }
            }

            group(" ")
            {
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'The Total Amount is the sum of all amounts in this record.';
                }

                field("Total VAT Amount"; Rec."Total VAT Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'The Total VAT Amount is the sum of all VAT amounts in this record.';
                }

                field("Total Amount Including VAT"; Rec."Total Amount Including VAT")
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
        Rec."Contract ID" := ContractID;
        Rec."Tenant ID" := tenantID;
    end;

    var
        ContractID: Integer;
        tenantID: Code[20];

}