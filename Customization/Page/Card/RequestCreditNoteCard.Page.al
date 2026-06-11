page 73209723 "BLRRequest Credit Note Card"
{
    PageType = Card;
    SourceTable = "BLRRequestCreditNote";
    ApplicationArea = All;
    Caption = 'Request Credit Note Card';
    UsageCategory = Administration;
    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Request No."; Rec."BLRRequest No.")
                {
                    ToolTip = 'The unique identifier for the request credit note.';
                    ApplicationArea = All;
                    Caption = 'Request No.';
                    Editable = false;
                }
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ToolTip = 'The unique identifier for the contract associated with the request credit note.';
                    ApplicationArea = All;
                    Caption = 'Contract ID';
                    TableRelation = "BLRTenancyContract";
                    trigger OnValidate()
                    var
                        TenancyContract: Record "BLRTenancyContract";
                    begin
                        if Rec."BLRContract ID" <> 0 then begin
                            if not TenancyContract.Get(Rec."BLRContract ID") then
                                Error('The specified Contract ID does not exist.');
                            Rec."BLRTenant No." := TenancyContract."BLRTenant ID";
                            Rec."BLRCustomer Name" := TenancyContract."BLRCustomer Name";
                            Rec."BLRPayment Frequency" := Format(TenancyContract."BLRPayment Frequency");
                            Rec."BLRProperty Name" := TenancyContract."BLRProperty Name";
                            Rec."BLRProperty Classification" := COPYSTR(TenancyContract."BLRProperty Classification", 1, StrLen(TenancyContract."BLRProperty Classification"));
                        end else begin
                            Rec."BLRTenant No." := '';
                            Rec."BLRCustomer Name" := '';
                            Rec."BLRPayment Frequency" := '';
                            Rec."BLRProperty Name" := '';
                            Rec."BLRProperty Classification" := '';
                        end;
                    end;
                }
                field("Property Name"; Rec."BLRProperty Name")
                {
                    ToolTip = 'The name of the property associated with the request credit note.';
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    Editable = false;
                }
                field("Tenant No."; Rec."BLRTenant No.")
                {
                    ToolTip = 'The unique identifier for the tenant associated with the request credit note.';
                    ApplicationArea = All;
                    Caption = 'Tenant No.';
                    Editable = false;
                }
                field("Customer Name"; Rec."BLRCustomer Name")
                {
                    ToolTip = 'The name of the customer associated with the request credit note.';
                    ApplicationArea = All;
                    Caption = 'Tenant Name';
                    Editable = false;
                }
                field("Request Date"; Rec."BLRRequest Date")
                {
                    ToolTip = 'The date when the request credit note was created.';
                    ApplicationArea = All;
                    Caption = 'Request Date';
                }
                field(Reason; Rec."BLRReason")
                {
                    ToolTip = 'The reason for the request credit note.';
                    ApplicationArea = All;
                    Caption = 'Reason';
                }
                field("Request Source"; Rec."BLRRequest Source")
                {
                    ToolTip = 'The source of the request credit note.';
                    ApplicationArea = All;
                    Caption = 'Request Source';
                }
                field(Status; Rec."BLRStatus")
                {
                    ToolTip = 'The status of the request credit note.';
                    ApplicationArea = All;
                    Caption = 'Status';
                    Editable = IsFinanceManager;
                }
                field(Remark; Rec."BLRReason for Rejection")
                {
                    ToolTip = 'The reason for rejection of the request credit note.';
                    ApplicationArea = All;
                    Caption = 'Reason for Rejection';
                    MultiLine = true;
                    Editable = false;
                }
                field("Adjust with Invoice"; Rec."BLRAdjust with Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'Adjust with Invoice';
                }
            }
            part("Request Credit Note Lines"; "BLRRequest CreditNote Grid")
            {
                SubPageLink = "BLRRequest No." = FIELD("BLRRequest No.");
                ApplicationArea = All;
                Caption = 'Request Credit Note Lines';
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Submit for Approval")
            {
                toolTip = 'Submit the request credit note for approval.';
                ApplicationArea = All;
                Caption = 'Submit for Approval';
                Visible = CanSubmitForApproval;
                trigger OnAction()
                var
                    RequestCreditnoteapproval: Codeunit "BLRApprovalRequestCrditnote ";
                begin
                    RequestCreditnoteapproval.SubmitCreditNote(Rec);
                    Dialog.Message('Email sent for approval.');
                    Dialog.Message('Your request has been submitted successfully.');
                end;
            }
        }
        area(Promoted)
        {
            actionref(submitforapproval; "Submit for Approval")
            {
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
    begin
        CurrPage."Request Credit Note Lines".Page.SetContractID(Rec."BLRContract ID");
    end;

    trigger OnAfterGetRecord()
    var
    begin
        CurrPage."Request Credit Note Lines".Page.SetContractID(Rec."BLRContract ID");
        IsFinanceManager := CheckUserRole();
        CanSubmitForApproval := (Rec."BLRStatus" in [Rec."BLRStatus"::" ", Rec."BLRStatus"::Rejected]);
    end;

    trigger OnOpenPage()
    var
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
        CanSubmitForApproval: Boolean;
        IsFinanceManager: Boolean;
}