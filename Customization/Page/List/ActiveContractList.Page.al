page 73209758 "BLRActive Contract List"
{
    PageType = List;
    SourceTable = "BLRTenancyContract";
    ApplicationArea = All;
    Caption = 'Active Contract List';
    UsageCategory = Lists;
    SourceTableView = where("BLRTenant Contract Status" = const(Active));  // Use option value without quotes

    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Caption = 'Contract ID';
                    ToolTip = 'The unique identifier for the tenancy contract.';
                }
                field("Proposal ID"; Rec."BLRProposal ID")
                {
                    ApplicationArea = All;
                    Caption = 'Proposal ID';
                    ToolTip = 'The unique identifier for the proposal associated with this contract.';
                }
                field("Renewal Proposal ID"; Rec."BLRRenewal Proposal ID")
                {
                    ApplicationArea = All;
                    Caption = 'Renewal Proposal ID';
                    ToolTip = 'The unique identifier for the renewal proposal associated with this contract.';
                }
                field("Property ID"; Rec."BLRProperty ID")
                {
                    ApplicationArea = All;
                    Caption = 'Property ID';
                    ToolTip = 'The unique identifier for the property associated with this contract.';
                }
                field("Unit ID"; Rec."BLRUnit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Single Unit ID';
                    ToolTip = 'The unique identifier for the unit associated with this contract.';
                }
                field("Merge Unit ID"; Rec."BLRMerge Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Merge Unit ID';
                    ToolTip = 'The unique identifier for the merged unit associated with this contract.';
                }
                field("Property Name"; Rec."BLRProperty Name")
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    ToolTip = 'The name of the property associated with this contract.';
                }
                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Customer ID';
                    ToolTip = 'The unique identifier for the tenant associated with this contract.';
                }
                field("Customer Name"; Rec."BLRCustomer Name")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';
                    ToolTip = 'The name of the tenant associated with this contract.';
                }
                field("Annual Rent Amount"; Rec."BLRAnnual Rent Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Annual Rent Amount';
                    ToolTip = 'The annual rent amount for the tenancy contract.';
                }
                field("Contract Start Date"; Rec."BLRContract Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                    ToolTip = 'The start date of the tenancy contract.';
                }
                field("Contract End Date"; Rec."BLRContract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
                    ToolTip = 'The end date of the tenancy contract.';
                }
                field("Tenant Contract Status"; Rec."BLRTenant Contract Status")
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
        Rec.SetRange("BLRTenant Contract Status", Rec."BLRTenant Contract Status"::Active);  // Use option reference
    end;
}