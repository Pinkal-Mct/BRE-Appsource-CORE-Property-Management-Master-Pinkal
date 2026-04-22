page 73209781 "Legal Suspended Contracts" // Use an appropriate page number
{
    PageType = List;
    SourceTable = SuspendReasonTable;
    ApplicationArea = All;
    Caption = 'Legally Suspended Contracts';
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
                    ToolTip = 'Unique identifier for the suspended contract.';
                }
                field(TenantID; Rec.TenantID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the tenant associated with the suspended contract.';
                }
                field(TenantName; Rec.TenantName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the tenant associated with the suspended contract.';
                }
                field("Contract Type"; Rec."Contract Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Type of the contract associated with the suspended contract.';
                }
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the suspended contract record.';
                }
                field(SuspensionEffectiveDate; Rec.SuspensionEffectiveDate)
                {
                    ApplicationArea = All;
                    StyleExpr = 'Attention';
                    ToolTip = 'Effective date of the suspension for the contract.';
                }
                field(SuspensionEndDate; Rec.SuspensionEndDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'End date of the suspension for the contract.';
                }
                field(Reason; Rec.Reason)
                {
                    ApplicationArea = All;
                    ToolTip = 'Reason for the suspension of the contract.';
                }
                field("Tenant Contract Status"; Rec."Tenant Contract Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Status of the tenant contract, indicating it is suspended.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("Tenant Contract Status", Rec."Tenant Contract Status"::Suspended);
        Rec.SetRange(Reason, Rec.Reason::"Legal Reason"); // Adjust field name and value as needed
        Rec.SetFilter(SuspensionEndDate, '%1', 0D); // Filter for empty date
    end;
}