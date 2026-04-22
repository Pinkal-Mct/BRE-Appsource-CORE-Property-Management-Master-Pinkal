page 73209758 "Active Contract List"
{
    PageType = List;
    SourceTable = "Tenancy Contract";
    ApplicationArea = All;
    Caption = 'Active Contract List';
    UsageCategory = Lists;
    SourceTableView = where("Tenant Contract Status" = const(Active));  // Use option value without quotes

    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Caption = 'Contract ID';
                    ToolTip = 'The unique identifier for the tenancy contract.';
                }
                field("Proposal ID"; Rec."Proposal ID")
                {
                    ApplicationArea = All;
                    Caption = 'Proposal ID';
                    ToolTip = 'The unique identifier for the proposal associated with this contract.';
                }
                field("Renewal Proposal ID"; Rec."Renewal Proposal ID")
                {
                    ApplicationArea = All;
                    Caption = 'Renewal Proposal ID';
                    ToolTip = 'The unique identifier for the renewal proposal associated with this contract.';
                }
                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    Caption = 'Property ID';
                    ToolTip = 'The unique identifier for the property associated with this contract.';
                }
                field("Unit ID"; Rec."Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Single Unit ID';
                    ToolTip = 'The unique identifier for the unit associated with this contract.';
                }
                field("Merge Unit ID"; Rec."Merge Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Merge Unit ID';
                    ToolTip = 'The unique identifier for the merged unit associated with this contract.';
                }
                field("Property Name"; Rec."Property Name")
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    ToolTip = 'The name of the property associated with this contract.';
                }
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Customer ID';
                    ToolTip = 'The unique identifier for the tenant associated with this contract.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';
                    ToolTip = 'The name of the tenant associated with this contract.';
                }
                field("Annual Rent Amount"; Rec."Annual Rent Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Annual Rent Amount';
                    ToolTip = 'The annual rent amount for the tenancy contract.';
                }
                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                    ToolTip = 'The start date of the tenancy contract.';
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
                    ToolTip = 'The end date of the tenancy contract.';
                }
                field("Tenant Contract Status"; Rec."Tenant Contract Status")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Contract Status';
                    ToolTip = 'The current status of the tenant contract.';
                }
            }
        }
    }

    trigger OnOpenPage();
    begin
        Rec.SetRange("Tenant Contract Status", Rec."Tenant Contract Status"::Active);  // Use option reference
    end;
}