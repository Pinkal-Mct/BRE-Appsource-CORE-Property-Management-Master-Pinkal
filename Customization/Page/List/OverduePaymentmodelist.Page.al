page 73209788 "BLROverduePaymentmodelist"
{
    PageType = List;
    SourceTable = "BLROverDuePaymentmode";
    ApplicationArea = All;
    Caption = 'Overdue Payment Approval List';
    UsageCategory = Lists;
    DeleteAllowed = true;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field("ID"; Rec."BLRID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'ID';
                }
                field("Status"; Rec."BLRStatus")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Status';
                }
                field("Tenant Id"; Rec."BLRTenant Id")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Tenant Id';
                }

                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Contract ID';
                }
                field("Payment Series"; Rec."BLRPayment Series")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Payment Series';
                }

                field("Due Date"; Rec."BLRDue Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Due Date';
                }
                field("Payment Status"; Rec."BLRPayment Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Payment Status';
                }
                field("Tenant Name"; Rec."BLRTenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Tenant Name';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Approved)
            {
                Caption = 'Approved';
                ToolTip = 'Approved';
                ApplicationArea = All;
                Image = Approval;
                Visible = IsFinanceManager;

                trigger OnAction()
                var
                    SelectedRecs: Record "BLROverDuePaymentmode";
                    emailsrec: Codeunit "BLRSendEmailPaymentmodeOverdue";
                    ApproveCount: Integer;
                    ErrorCount: Integer;
                    approvalstatus: Enum "BLRApproval Status Enum";
                begin
                    CurrPage.SetSelectionFilter(SelectedRecs);

                    if SelectedRecs.IsEmpty() then begin
                        Message('No records selected for approval.');
                        exit;
                    end;

                    ApproveCount := 0;
                    ErrorCount := 0;

                    if SelectedRecs.FindSet() then
                        repeat
                            if SelectedRecs."BLRStatus" = approvalstatus::Pending then begin
                                SelectedRecs."BLRStatus" := approvalstatus::Approved;
                                emailsrec.SendEmailOverdue(Rec);
                                SelectedRecs.Modify();
                                ApproveCount += 1;
                            end else
                                ErrorCount += 1;
                        until SelectedRecs.Next() = 0;

                    Commit();
                    CurrPage.Update(false);
                    Message('%1 record(s) approved. %2 record(s) were not in "Pending" status.', ApproveCount, ErrorCount);
                end;
            }
            action(Rejected)
            {
                Caption = 'Rejected';
                ToolTip = 'Rejected';
                ApplicationArea = All;
                Image = Reject;
                Visible = IsFinanceManager;

                trigger OnAction()
                var
                    SelectedRecs: Record "BLROverDuePaymentmode";
                    RejectCount: Integer;
                    ErrorCount: Integer;
                    approvalstatus: Enum "BLRApproval Status Enum";
                begin
                    CurrPage.SetSelectionFilter(SelectedRecs);

                    if SelectedRecs.IsEmpty() then begin
                        Message('No records selected for rejection.');
                        exit;
                    end;

                    RejectCount := 0;
                    ErrorCount := 0;

                    if SelectedRecs.FindSet() then
                        repeat
                            if SelectedRecs."BLRStatus" = approvalstatus::Pending then begin
                                SelectedRecs."BLRStatus" := approvalstatus::Rejected;
                                SelectedRecs.Modify();
                                RejectCount += 1;
                            end else
                                ErrorCount += 1;
                        until SelectedRecs.Next() = 0;
                    Commit();
                    CurrPage.Update(false);
                    Message('%1 record(s) rejected. %2 record(s) were not in "Pending" status.', RejectCount, ErrorCount);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        IsFinanceManager := VisibleApproveAction();
    end;

    procedure VisibleApproveAction(): Boolean
    var
        UserPersonalization: Record "User Personalization";
    begin
        if UserPersonalization.Get(UserSecurityId()) then
            case UserPersonalization."Profile ID" of
                'PROPERTY MANAGER':
                    exit(false);
                'LEASE MANAGER':
                    exit(false);
                'FINANCE MANAGER':
                    exit(true);
            end;

        exit(false);
    end;

    var
        IsFinanceManager: Boolean;
}