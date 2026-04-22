page 73209722 "Rent Calculation SubCard2"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Rent Calculation Subpage2";
    Caption = 'Rent Calculation Card';

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
                    Editable = false;
                }
                field("Installment No."; Rec."Installment No.")
                {
                    ApplicationArea = All;
                    Caption = 'Instalment No.';
                    Editable = false;
                    ToolTip = 'Enter the Instalment No.';
                }

                field("Installment Start Date"; Rec."Installment Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Instalment Start Date';
                    Editable = false;
                    ToolTip = 'Enter the Instalment Start Date.';
                }

                field("Installment End Date"; Rec."Installment End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Instalment End Date';
                    Editable = false;
                    ToolTip = 'Enter the Instalment End Date.';
                }

                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Caption = 'Due Date';
                    Editable = false;
                    ToolTip = 'Enter the Due Date.';
                }

                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    Editable = false;
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
                    Editable = false;
                    ToolTip = 'Enter the Amount Including VAT.';
                }

                field("Secondary Item Type"; Rec."Secondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                    Visible = false;
                    Editable = false;
                    ToolTip = 'Enter the Secondary Item Type.';
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'The Tenant ID is auto-generated and not editable.';
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'The Contract ID is auto-generated and not editable.';
                }


                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = All;
                    Caption = 'VAT %';
                    ToolTip = 'Enter the VAT %.';
                    Editable = false;
                    Visible = false;
                }
                field("Primary Classification"; Rec."Primary Classification")
                {
                    ApplicationArea = All;
                    Caption = 'Primary Classification';
                    Editable = false;
                    Visible = false;
                    ToolTip = 'The classification of the property associated with this rent calculation.';
                }


            }
            group(TotalAmount)
            {
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Total Amount';
                    ToolTip = 'Enter the Total Amount.';
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
