page 73209811 "BLRSuspended Contract List"
{
    PageType = List;
    SourceTable = BLRSuspendReasonTable;
    ApplicationArea = All;
    Caption = 'Suspended Contract List';
    UsageCategory = Lists;
    SourceTableView = where("BLRTenant Contract Status" = const(Suspended));  // Use option value without quotes

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
                    ToolTip = 'The unique identifier for the suspended contract.';
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
                field("Tenant Contract Status"; Rec."BLRTenant Contract Status")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Contract Status';
                    ToolTip = 'The current status of the tenant contract.';
                }
                field(Reason; Rec.BLRReason)
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
        Rec.SetRange("BLRTenant Contract Status", Rec."BLRTenant Contract Status"::Suspended);
        Rec.SetFilter(BLRSuspensionEndDate, '%1', 0D); // Filter for empty date
    end;
}