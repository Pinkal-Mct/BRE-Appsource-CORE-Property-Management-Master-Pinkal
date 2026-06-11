page 73209813 "BLRTenancy Contract List"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "BLRTenancyContract";
    Caption = 'Tenancy Contract List';
    UsageCategory = Lists;
    CardPageId = 73209745;

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("Contract ID"; rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Caption = 'Contract ID';
                    ToolTip = 'Unique identifier for the tenancy contract.';
                }
                field("Proposal ID"; rec."BLRProposal ID")
                {
                    ApplicationArea = All;
                    Caption = 'Proposal ID';
                    ToolTip = 'Unique identifier for the lease proposal associated with the tenancy contract.';
                }

                field("Renewal Proposal ID"; Rec."BLRRenewal Proposal ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the renewal proposal associated with the tenancy contract.';
                }

                field("Property ID"; rec."BLRProperty ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the property associated with the tenancy contract.';
                }

                field("Unit ID"; rec."BLRUnit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Single Unit ID';
                    ToolTip = 'Unique identifier for the unit associated with the tenancy contract.';
                }

                field("Merge ID"; rec."BLRMerge Unit ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the merged unit associated with the tenancy contract.';
                }
                field("Property Name"; rec."BLRProperty Name")
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    ToolTip = 'Name of the property associated with the tenancy contract.';
                }

                field("Tenant ID"; rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the tenant associated with the tenancy contract.';
                }

                field("Customer Name"; rec."BLRCustomer Name")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';
                    ToolTip = 'Name of the customer associated with the tenancy contract.';
                }

                field("Annual Rent Amount"; rec."BLRAnnual Rent Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Annual Rent Amount ';
                    ToolTip = 'Total annual rent amount for the tenancy contract.';
                }
                field("Contract Start Date"; rec."BLRContract Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    ToolTip = 'Start date of the tenancy contract.';
                }
                field("Contract End Date"; rec."BLRContract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    ToolTip = 'End date of the tenancy contract.';
                }

                field("Update Contract Status"; rec."BLRUpdate Contract Status")
                {
                    ApplicationArea = All;
                    Caption = 'Update Contract Status';
                    ToolTip = 'Status of the tenancy contract indicating whether it is active, expired, or terminated.';
                }

                field("Tenant Contract Status"; rec."BLRTenant Contract Status")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Contract Status';
                    ToolTip = 'Status of the tenant contract indicating whether it is active, expired, or terminated.';
                }

            }
        }
    }


}
