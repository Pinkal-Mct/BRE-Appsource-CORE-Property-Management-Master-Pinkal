page 73209775 "BLRExpiring Contract List"
{
    PageType = List;
    SourceTable = "BLRTenancyContract";
    ApplicationArea = All;
    Caption = 'Contracts Expiring Soon';
    UsageCategory = Lists;

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
                    ToolTip = 'The total annual rent amount for the contract.';
                }
                field("Contract Start Date"; Rec."BLRContract Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                    ToolTip = 'The date when the contract starts.';
                }
                field("Contract End Date"; Rec."BLRContract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
                    ToolTip = 'The date when the contract ends.';
                }
                field("Tenant Contract Status"; Rec."BLRTenant Contract Status")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Contract Status';
                    ToolTip = 'The current status of the tenant contract.';
                }
                field("Remaining Days"; CalcRemainingDays())
                {
                    ApplicationArea = All;
                    Caption = 'Remaining Days';
                    ToolTip = 'The number of days remaining until the contract ends.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        CurrentDate: Date;
        OneMonthLater: Date;
    begin
        CurrentDate := TODAY;
        OneMonthLater := CALCDATE('<+1M>', CurrentDate);

        Rec.SetRange("BLRTenant Contract Status", Rec."BLRTenant Contract Status"::Active);
        Rec.SetFilter("BLRContract End Date", '%1..%2', CurrentDate, OneMonthLater);
    end;

    local procedure CalcRemainingDays(): Integer
    begin
        if Rec."BLRContract End Date" = 0D then
            exit(0);

        exit(Rec."BLRContract End Date" - TODAY);
    end;
}