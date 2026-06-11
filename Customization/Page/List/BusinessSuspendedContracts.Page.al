page 73209766 "BLRBusiness SuspendedContracts" // Use an appropriate page number
{
    PageType = List;
    SourceTable = BLRSuspendReasonTable;
    ApplicationArea = All;
    Caption = 'Business Suspended Contracts';
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
                    ToolTip = 'Unique identifier for the suspended contract.';
                }
                field(TenantID; Rec."BLRTenantID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the tenant associated with the suspended contract.';
                }
                field(TenantName; Rec."BLRTenantName")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the tenant associated with the suspended contract.';
                }
                field("Contract Type"; Rec."BLRContract Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Type of the contract associated with the suspended contract.';
                }
                field(ID; Rec."BLRID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the suspended contract record.';
                }
                field(SuspensionEffectiveDate; Rec."BLRSuspensionEffectiveDate") // Adjust field name as needed
                {
                    ApplicationArea = All;
                    ToolTip = 'Effective date of the suspension for the contract.';
                }
                field(SuspensionEndDate; Rec."BLRSuspensionEndDate") // Adjust field name as needed
                {
                    ApplicationArea = All;
                    ToolTip = 'End date of the suspension for the contract.';
                }
                field(Reason; Rec."BLRReason") // Adjust field name as needed
                {
                    ApplicationArea = All;
                    ToolTip = 'Reason for the suspension of the contract.';
                }
                field("Tenant Contract Status"; Rec."BLRTenant Contract Status") // Adjust field name as needed
                {
                    ApplicationArea = All;
                    ToolTip = 'Status of the tenant contract, indicating it is suspended.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetRange("BLRTenant Contract Status", Rec."BLRTenant Contract Status"::Suspended);
        Rec.SetRange(BLRReason, Rec.BLRReason::"Business Reason"); // Adjust field name and value as needed
        Rec.SetFilter(BLRSuspensionEndDate, '%1', 0D); // Filter for empty date
    end;
}