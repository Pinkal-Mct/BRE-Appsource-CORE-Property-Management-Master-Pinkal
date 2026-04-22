page 73209775 "Expiring Contract List"
{
    PageType = List;
    SourceTable = "Tenancy Contract";
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
                    ToolTip = 'The total annual rent amount for the contract.';
                }
                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                    ToolTip = 'The date when the contract starts.';
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
                    ToolTip = 'The date when the contract ends.';
                }
                field("Tenant Contract Status"; Rec."Tenant Contract Status")
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

        Rec.SetRange("Tenant Contract Status", Rec."Tenant Contract Status"::Active);
        Rec.SetFilter("Contract End Date", '%1..%2', CurrentDate, OneMonthLater);
    end;

    local procedure CalcRemainingDays(): Integer
    begin
        if Rec."Contract End Date" = 0D then
            exit(0);

        exit(Rec."Contract End Date" - TODAY);
    end;
}