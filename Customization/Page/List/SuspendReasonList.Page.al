page 73209812 SuspendReasonList
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = SuspendReasonTable;
    Caption = 'Suspend Reason List';
    CardPageId = 73209738;

    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the suspend reason.';
                }
                field(DateEffective; Rec.DateEffective)
                {
                    ApplicationArea = All;
                    ToolTip = 'The date from which the suspend reason is effective.';
                }
                field(Reason; Rec.Reason)
                {
                    ApplicationArea = All;
                    ToolTip = 'The reason for suspending the contract.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'A detailed description of the suspend reason.';
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'The identifier of the contract associated with this suspend reason.';
                }

                field("Tenant Contract Status"; Rec."Tenant Contract Status")
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
                    PAGE.Run(PAGE::"Suspend Reason Card");
                end;
            }
        }
    }
}
