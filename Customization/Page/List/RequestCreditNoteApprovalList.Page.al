page 73209799 "BLRReqCreditNoteApprovalList"
{
    PageType = List;
    SourceTable = BLRReqCreditNoteApprovalList;
    ApplicationArea = All;
    Caption = 'Request Credit Note Approval List';
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ID; Rec.BLRID)
                {
                    ApplicationArea = All;
                    Caption = 'ID';
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the approval record.';
                }
                field("Request No."; Rec."BLRRequest No.")
                {
                    ApplicationArea = All;
                    Caption = 'Request No.';
                    Editable = false;
                    ToolTip = 'Specifies the unique number of the credit note request.';
                    trigger OnDrillDown()
                    var
                        RequestCreditNote: Record "BLRRequestCreditNote";
                    begin
                        RequestCreditNote.SetRange("BLRRequest No.", Rec."BLRRequest No.");
                        if RequestCreditNote.FindSet() then
                            PAGE.RunModal(PAGE::"BLRRequest Credit Note Card", RequestCreditNote)
                        else
                            Message('No Request Credit Note found using FindFirst either.');
                    end;
                }
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Caption = 'Contract ID';
                    Editable = false;
                    ToolTip = 'Specifies the contract associated with this credit note request.';
                }
                field("Tenant No."; Rec."BLRTenant No.")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant No.';
                    Editable = false;
                    ToolTip = 'Specifies the tenant related to this credit note request.';
                }
                field("Request Date"; Rec."BLRRequest Date")
                {
                    ApplicationArea = All;
                    Caption = 'Request Date';
                    Editable = false;
                    ToolTip = 'Specifies the date when the credit note was requested.';
                }
                field(Status; Rec.BLRStatus)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    Editable = false;
                    ToolTip = 'Shows the current status of the credit note approval request.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Approve)
            {
                ApplicationArea = All;
                Caption = 'Approve';
                ToolTip = 'Approve the selected credit note request.';
                Visible = IsFinanceManager;
                Image = Approve;
                trigger OnAction()
                var
                    SelectedRec: Record BLRReqCreditNoteApprovalList;
                    RequestCreditNote: Record "BLRRequestCreditNote";
                begin
                    if Rec.BLRStatus = 'Pending' then begin
                        SelectedRec := Rec;
                        SelectedRec."BLRStatus" := 'Approved';
                        SelectedRec.Modify();
                        RequestCreditNote.SetRange("BLRRequest No.", SelectedRec."BLRRequest No.");
                        RequestCreditNote.SetRange("BLRContract ID", SelectedRec."BLRContract ID");
                        if RequestCreditNote.FindSet() then
                            repeat
                                RequestCreditNote."BLRStatus" := RequestCreditNote."BLRStatus"::Approved;
                                RequestCreditNote.Modify();
                            until RequestCreditNote.Next() = 0;
                        Commit();
                        CurrPage.Update();
                        Message('Request Approved Successfully with Remarks for Contract ID: %1', SelectedRec."BLRContract ID");
                    end else
                        Message('Selected record is not in "Pending" status.');
                end;
            }
            action(Reject)
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Visible = IsFinanceManager;
                Image = Reject;
                ToolTip = 'Reject the selected credit note request and provide a remark.';
                trigger OnAction()
                var
                    SelectedRec: Record "BLRReqCreditNoteApprovalList";
                    RequestCreditNote1: Record "BLRRequestCreditNote";
                    RemarkDialog: Page "BLRDialogBoxInvoiceRejection";
                    RemarkText: Text[250];
                    DialogResult: Action;
                begin
                    if Rec.BLRStatus = 'Pending' then begin
                        DialogResult := RemarkDialog.RunModal();
                        if DialogResult = Action::OK then begin
                            RemarkText := Format(RemarkDialog.GetReason());
                            if RemarkText <> '' then begin
                                SelectedRec := Rec;
                                SelectedRec."BLRStatus" := 'Rejected';
                                SelectedRec.BLRRemark := RemarkText;
                                SelectedRec.Modify();
                                RequestCreditNote1.SetRange("BLRRequest No.", SelectedRec."BLRRequest No.");
                                RequestCreditNote1.SetRange("BLRContract ID", SelectedRec."BLRContract ID");
                                if RequestCreditNote1.FindSet() then
                                    repeat
                                        RequestCreditNote1."BLRReason for Rejection" := RemarkText;
                                        RequestCreditNote1.BLRStatus := RequestCreditNote1.BLRStatus::Rejected;
                                        RequestCreditNote1.Modify();
                                        RequestCreditNote1.Modify();
                                    until RequestCreditNote1.Next() = 0;
                                Commit();
                                CurrPage.Update();
                                Message('Request Rejected with Remark.');
                            end;
                        end;
                    end else
                        Message('Selected record is not in "Pending" status.');
                end;
            }
        }
        area(Promoted)
        {
            actionref(ApproveRecrord; Approve)
            {
            }
            actionref(RejectRecord; Reject)
            {
            }
        }
    }
    trigger OnOpenPage()
    begin
        IsFinanceManager := CheckUserRole();
    end;

    procedure CheckUserRole(): Boolean
    var
        UserPersonalization: Record "User Personalization";
    begin
        if UserPersonalization.Get(UserSecurityId()) then
            case UserPersonalization."Profile ID" of
                'FINANCE MANAGER':
                    exit(true);
                else
                    exit(false);
            end;
        exit(false);
    end;

    var
        IsFinanceManager: Boolean;
}