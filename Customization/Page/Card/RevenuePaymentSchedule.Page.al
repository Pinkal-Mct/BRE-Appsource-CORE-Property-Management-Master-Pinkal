page 73209726 "Revenue Payment Schedule"
{
    PageType = ListPart;
    ApplicationArea = All;
    // UsageCategory = Administration;
    SourceTable = "Revenue Structure Subpage1";
    Caption = 'Revenue Payment Schedule';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                field("Year"; Rec."Year")
                {
                    ApplicationArea = All;
                    Caption = 'Year';
                    ToolTip = 'Enter the Year.';
                }
                field("Installment No."; Rec."Installment No.")
                {
                    ApplicationArea = All;
                    Caption = 'Instalment No.';
                    ToolTip = 'Enter the Instalment No.';
                }

                field("Installment Start Date"; Rec."Installment Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Instalment Start Date';
                    ToolTip = 'Enter the Instalment Start Date.';
                }

                field("Installment End Date"; Rec."Installment End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Instalment End Date';
                    ToolTip = 'Enter the Instalment End Date.';
                }

                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Caption = 'Due Date';
                    ToolTip = 'Enter the Due Date.';
                }

                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Enter the Amount.';
                }

                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Amount';
                    Visible = false;
                    Editable = false;
                    ToolTip = 'Enter the VAT Amount.';
                }

                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Including VAT';
                    Visible = false;
                    ToolTip = 'Enter the Amount Including VAT.';
                }

                field("Secondary Item Type"; Rec."Secondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                    Visible = false;
                    ToolTip = 'Enter the Secondary Item Type.';
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'The ID of the tenant associated with this payment schedule.';
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'The ID of the contract associated with this payment schedule.';
                }


                field("VAT %"; Rec."VAT %")
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
                field("Total Amount"; Rec."Total Amount")
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
        Rec."Contract ID" := ContractID;
        Rec."Tenant ID" := tenantID;

    end;

    var
        ContractID: Integer;

        tenantID: Code[20];


}