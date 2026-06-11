page 73209772 "BLRContract EndProcessApproval"
{
    PageType = List;
    SourceTable = BLRContractEndProcessApproval;
    ApplicationArea = All;
    Caption = 'Contract End Process Approval';
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID"; Rec."BLRID")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the unique identifier for the contract end process approval record.';
                }

                field("Lease_M Status"; Rec."BLRLease_M Status")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the current status of the lease management process for this contract.';
                }

                field("Lease Manager Remark"; Rec."BLRLease Manager Remark")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the remark provided by the lease manager regarding this contract end process approval.';
                }


                field("Property_M Status"; Rec."BLRProperty_M Status")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the current status of the property management process for this contract.';
                }

                field("Property Manager Remark"; Rec."BLRProperty Manager Remark")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the remark provided by the property manager regarding this contract end process approval.';
                }

                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the unique identifier for the tenant associated with this contract end process approval.';
                }
                field("Tenant Name"; Rec."BLRTenant Name")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the name of the tenant associated with this contract end process approval.';
                }
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the unique identifier for the contract associated with this contract end process approval.';
                }
                field("Contract Start Date"; Rec."BLRStart Date")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the start date of the contract associated with this contract end process approval.';
                }
                field("Contract End Date"; Rec."BLREnd Date")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the end date of the contract associated with this contract end process approval.';
                }
                field("Tenant Email"; Rec."BLRTenant Email")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the email address of the tenant associated with this contract end process approval.';
                }

                field("Value"; Rec."BLRValue")
                {
                    ApplicationArea = All;
                    Editable = true;
                    Visible = true;
                    ToolTip = 'Specifies the value indicating whether the tenant has been notified about the contract end process.';
                }

                field("Renewal Notification to Tenant"; Rec."BLRRenewalNotiftoTenant")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the number of days before the contract end date when the tenant should be notified about the renewal options.';

                }

            }
        }
    }


    actions
    {
        area(processing)
        {

            action(ApproveProperty)
            {
                Caption = 'Approve';
                ApplicationArea = All;
                Image = Approve;
                Visible = IsPropertyManager;
                ToolTip = 'Approve selected records for Property Management.';

                trigger OnAction()
                var
                    SelectedRecs: Record "BLRContractEndProcessApproval";
                    SendTenantMail: Codeunit "BLRSendTenantMail";
                    ApproveCount: Integer;
                    ErrorCount: Integer;
                    LeaseNotApprovedCount: Integer;
                    TodayDate: Date;
                    DaysRemaining: Integer;
                begin
                    CurrPage.SetSelectionFilter(SelectedRecs);

                    if SelectedRecs.IsEmpty() then begin
                        Message('No records selected for approval.');
                        exit;
                    end;

                    ApproveCount := 0;
                    ErrorCount := 0;
                    LeaseNotApprovedCount := 0;
                    TodayDate := Today;

                    if SelectedRecs.FindSet() then
                        repeat
                            if SelectedRecs."BLRLease_M Status" = 'Approved' then begin
                                if SelectedRecs."BLRProperty_M Status" = 'Pending' then begin
                                    SelectedRecs."BLRProperty_M Status" := 'Approved';

                                    // Calculate remaining days until contract end date
                                    DaysRemaining := SelectedRecs."BLREnd Date" - TodayDate;

                                    if DaysRemaining <= SelectedRecs."BLRRenewalNotiftoTenant" then begin

                                        SelectedRecs."BLRValue" := 'true'; // Set Value to text 'true'
                                        SendTenantMail.SendEmailToTenant(SelectedRecs); // Send email to tenant
                                    end else
                                        SelectedRecs."BLRValue" := 'False'; // Set Value to text 'false'


                                    SelectedRecs.Modify();
                                    ApproveCount += 1;
                                end else
                                    ErrorCount += 1;
                            end else
                                LeaseNotApprovedCount += 1;
                        until SelectedRecs.Next() = 0;

                    Commit();
                    CurrPage.Update(false);

                    Message('%1 record(s) approved for Property. %2 record(s) were not in "Pending" status. %3 record(s) were skipped as Lease_M Status was not "Approved".',
                        ApproveCount, ErrorCount, LeaseNotApprovedCount);
                end;
            }


            action(ApproveLease)
            {
                Caption = 'Approve';
                ApplicationArea = All;
                Image = Approve;
                Visible = IsLeaseManager;
                ToolTip = 'Approve selected records for Lease Management.';

                trigger OnAction()
                var
                    SelectedRecs: Record "BLRContractEndProcessApproval";
                    EmailSender: Codeunit 73209610;
                    ApproveCount: Integer;
                    ErrorCount: Integer;
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
                            if SelectedRecs."BLRLease_M Status" = 'Pending' then begin
                                SelectedRecs."BLRLease_M Status" := 'Approved';
                                SelectedRecs.Modify();
                                ApproveCount += 1;

                                // Send Email After Approval
                                EmailSender.SendEmail(SelectedRecs);
                            end else
                                ErrorCount += 1;
                        until SelectedRecs.Next() = 0;

                    Commit();
                    CurrPage.Update(false);

                    Message('%1 record(s) approved for Lease. %2 record(s) were not in "Pending" status.', ApproveCount, ErrorCount);
                end;
            }


            // Decline Action for Property_M Status
            action(DeclineProperty)
            {
                Caption = 'Decline';
                ApplicationArea = All;
                Image = Cancel;
                Visible = IsPropertyManager; // Button visible only for Property Manager
                ToolTip = 'Decline selected records for Property Management.';

                trigger OnAction()
                var
                    SelectedRecs: Record "BLRContractEndProcessApproval";
                    DeclineCount: Integer;
                    ErrorCount: Integer;
                begin
                    CurrPage.SetSelectionFilter(SelectedRecs);

                    if SelectedRecs.IsEmpty() then begin
                        Message('No records selected for decline.');
                        exit;
                    end;

                    DeclineCount := 0;
                    ErrorCount := 0;

                    if SelectedRecs.FindSet() then
                        repeat
                            if SelectedRecs."BLRProperty_M Status" = 'Pending' then begin
                                SelectedRecs."BLRProperty_M Status" := 'Declined';
                                SelectedRecs.Modify();
                                DeclineCount += 1;
                            end else
                                ErrorCount += 1;
                        until SelectedRecs.Next() = 0;

                    Commit();
                    CurrPage.Update(false);

                    Message('%1 record(s) declined for Property. %2 record(s) were not in "Pending" status.', DeclineCount, ErrorCount);
                end;
            }

            // Decline Action for Lease_M Status
            action(DeclineLease)
            {
                Caption = 'Decline';
                ApplicationArea = All;
                Image = Cancel;
                Visible = IsLeaseManager; // Button visible only for Lease Manager
                ToolTip = 'Decline selected records for Lease Management.';

                trigger OnAction()
                var
                    SelectedRecs: Record "BLRContractEndProcessApproval";
                    DeclineCount: Integer;
                    ErrorCount: Integer;
                begin
                    CurrPage.SetSelectionFilter(SelectedRecs);

                    if SelectedRecs.IsEmpty() then begin
                        Message('No records selected for decline.');
                        exit;
                    end;

                    DeclineCount := 0;
                    ErrorCount := 0;

                    if SelectedRecs.FindSet() then
                        repeat
                            if SelectedRecs."BLRLease_M Status" = 'Pending' then begin
                                SelectedRecs."BLRLease_M Status" := 'Declined';
                                SelectedRecs.Modify();
                                DeclineCount += 1;
                            end else
                                ErrorCount += 1;
                        until SelectedRecs.Next() = 0;

                    Commit();
                    CurrPage.Update(false);

                    Message('%1 record(s) declined for Lease. %2 record(s) were not in "Pending" status.', DeclineCount, ErrorCount);
                end;
            }
        }
    }


    trigger OnOpenPage()
    begin
        IsPropertyManager := CheckUserRole();
        IsLeaseManager := CheckUserRole1();
    end;

    procedure CheckUserRole(): Boolean
    var
        UserPersonalization: Record "User Personalization";
    begin
        if UserPersonalization.Get(UserSecurityId()) then
            case UserPersonalization."Profile ID" of
                'PROPERTY MANAGER':
                    exit(true);  // Only property managers can approve/reject
                else
                    exit(false);
            end;

        exit(false);
    end;

    procedure CheckUserRole1(): Boolean
    var
        UserPersonalization: Record "User Personalization";
    begin
        if UserPersonalization.Get(UserSecurityId()) then
            case UserPersonalization."Profile ID" of
                'LEASE MANAGER':
                    exit(true);  // Only property managers can approve/reject
                else
                    exit(false);
            end;
        exit(false);
    end;

    var
        IsPropertyManager: Boolean;
        IsLeaseManager: Boolean;

}






