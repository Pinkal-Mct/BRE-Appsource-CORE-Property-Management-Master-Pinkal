page 73209780 "Lease Proposal List"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "Lease Proposal Details";
    Caption = 'Lease Proposals';
    CardPageId = 73209697;
    UsageCategory = Lists;

    layout
    {

        area(content)
        {
            repeater(Group)
            {
                field("Proposal ID"; Rec."Proposal ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the lease proposal.';
                }

                field("Unit ID"; rec."Unit ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the unit associated with the lease proposal.';

                }

                field("Merge Unit ID"; Rec."Merge Unit ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the merged unit associated with the lease proposal.';

                }

                field("Property Name"; rec."Property Name")
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    ToolTip = 'Name of the property associated with the lease proposal.';
                }

                field("Property Address"; Rec."Unit Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Address of the property associated with the lease proposal.';
                }
                field("Tenant Full Name"; Rec."Tenant Full Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Full name of the tenant associated with the lease proposal.';
                }
                field("Rent Amount"; Rec."Rent Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Total rent amount proposed for the unit.';

                }
                field("Lease Start Date"; Rec."Lease Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Start date of the lease for the unit associated with the proposal.';

                }
                field("Lease End Date"; Rec."Lease End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'End date of the lease for the unit associated with the proposal.';

                }

                field("Property Size"; Rec."Unit Size")
                {
                    ApplicationArea = All;
                    ToolTip = 'Size of the unit in square feet or square meters associated with the lease proposal.';

                }
                field("Proposal Status"; rec."Proposal Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Current status of the lease proposal, indicating whether it is pending, approved, or rejected.';
                }

                field("License No."; Rec."License No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'License number associated with the lease proposal, if applicable.';
                }

                field("Licensing Authority"; Rec."Licensing Authority")
                {
                    ApplicationArea = All;
                    ToolTip = 'Authority that issued the license for the lease proposal, if applicable.';
                }
            }
        }
    }


}

