page 73209812 BLRSuspendReasonList
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = BLRSuspendReasonTable;
    Caption = 'Suspend Reason List';
    CardPageId = 73209738;

    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ID; Rec.BLRID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the suspend reason.';
                }
                field(DateEffective; Rec.BLRDateEffective)
                {
                    ApplicationArea = All;
                    ToolTip = 'The date from which the suspend reason is effective.';
                }
                field(Reason; Rec.BLRReason)
                {
                    ApplicationArea = All;
                    ToolTip = 'The reason for suspending the contract.';
                }
                field(Description; Rec.BLRDescription)
                {
                    ApplicationArea = All;
                    ToolTip = 'A detailed description of the suspend reason.';
                }

                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'The identifier of the contract associated with this suspend reason.';
                }

                field("Tenant Contract Status"; Rec."BLRTenant Contract Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'The status of the tenant contract when this suspend reason is applied.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(NewSuspendReason)
            {
                Caption = 'New Suspend Reason';
                ApplicationArea = All;
                Image = New;
                ToolTip = 'Create a new suspend reason.';

                trigger OnAction()
                begin
                    PAGE.Run(PAGE::"BLRSuspend Reason Card");
                end;
            }
        }
    }
}
