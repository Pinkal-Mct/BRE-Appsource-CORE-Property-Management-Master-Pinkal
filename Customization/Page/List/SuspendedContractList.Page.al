page 73209811 "Suspended Contract List"
{
    PageType = List;
    SourceTable = SuspendReasonTable;
    ApplicationArea = All;
    Caption = 'Suspended Contract List';
    UsageCategory = Lists;
    SourceTableView = where("Tenant Contract Status" = const(Suspended));  // Use option value without quotes

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
                    ToolTip = 'The unique identifier for the suspended contract.';
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
                field("Tenant Contract Status"; Rec."Tenant Contract Status")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Contract Status';
                    ToolTip = 'The current status of the tenant contract.';
                }
                field(Reason; Rec.Reason)
                {
                    ApplicationArea = All;
                    Caption = 'Suspension Reason';
                    ToolTip = 'The reason for the suspension of the contract.';
                }
            }
        }
    }

    trigger OnOpenPage();
    begin
        Rec.SetRange("Tenant Contract Status", Rec."Tenant Contract Status"::Suspended);
        Rec.SetFilter(SuspensionEndDate, '%1', 0D); // Filter for empty date
    end;
}