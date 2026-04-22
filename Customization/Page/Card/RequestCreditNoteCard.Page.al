page 73209723 "Request Credit Note Card"
{
    PageType = Card;
    SourceTable = "Request Credit Note";
    ApplicationArea = All;
    Caption = 'Request Credit Note Card';
    UsageCategory = Administration;
    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Request No."; Rec."Request No.")
                {
                    ToolTip = 'The unique identifier for the request credit note.';
                    ApplicationArea = All;
                    Caption = 'Request No.';
                    Editable = false;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ToolTip = 'The unique identifier for the contract associated with the request credit note.';
                    ApplicationArea = All;
                    Caption = 'Contract ID';
                    TableRelation = "Tenancy Contract";
                    trigger OnValidate()
                    var
                        TenancyContract: Record "Tenancy Contract";
                    begin
                        if Rec."Contract ID" <> 0 then begin
                            if not TenancyContract.Get(Rec."Contract ID") then
                                Error('The specified Contract ID does not exist.');
                            Rec."Tenant No." := TenancyContract."Tenant ID";
                            Rec."Customer Name" := TenancyContract."Customer Name";
                            Rec."Payment Frequency" := Format(TenancyContract."Payment Frequency");
                            Rec."Property Name" := TenancyContract."Property Name";
                            Rec."Property Classification" := COPYSTR(TenancyContract."Property Classification", 1, StrLen(TenancyContract."Property Classification"));
                        end else begin
                            Rec."Tenant No." := '';
                            Rec."Customer Name" := '';
                            Rec."Payment Frequency" := '';
                            Rec."Property Name" := '';
                            Rec."Property Classification" := '';
                        end;
                    end;
                }
                field("Property Name"; Rec."Property Name")
                {
                    ToolTip = 'The name of the property associated with the request credit note.';
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    Editable = false;
                }
                field("Tenant No."; Rec."Tenant No.")
                {
                    ToolTip = 'The unique identifier for the tenant associated with the request credit note.';
                    ApplicationArea = All;
                    Caption = 'Tenant No.';
                    Editable = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'The name of the customer associated with the request credit note.';
                    ApplicationArea = All;
                    Caption = 'Tenant Name';
                    Editable = false;
                }
                field("Request Date"; Rec."Request Date")
                {
                    ToolTip = 'The date when the request credit note was created.';
                    ApplicationArea = All;
                    Caption = 'Request Date';
                }
                field(Reason; Rec.Reason)
                {
                    ToolTip = 'The reason for the request credit note.';
                    ApplicationArea = All;
                    Caption = 'Reason';
                }
                field("Request Source"; Rec."Request Source")
                {
                    ToolTip = 'The source of the request credit note.';
                    ApplicationArea = All;
                    Caption = 'Request Source';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'The status of the request credit note.';
                    ApplicationArea = All;
                    Caption = 'Status';
                    Editable = IsFinanceManager;
                }
                field(Remark; Rec."Reason for Rejection")
                {
                    ToolTip = 'The reason for rejection of the request credit note.';
                    ApplicationArea = All;
                    Caption = 'Reason for Rejection';
                    MultiLine = true;
                    Editable = false;
                }
                field("Adjust with Invoice"; Rec."Adjust with Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'Adjust with Invoice';
                }
            }
            part("Request Credit Note Lines"; "Request CreditNote Grid")
            {
                SubPageLink = "Request No." = FIELD("Request No.");
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
                    RequestCreditnoteapproval: Codeunit "Approval Request Crdit note ";
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
        CurrPage."Request Credit Note Lines".Page.SetContractID(Rec."Contract ID");
    end;

    trigger OnAfterGetRecord()
    var
    begin
        CurrPage."Request Credit Note Lines".Page.SetContractID(Rec."Contract ID");
        IsFinanceManager := CheckUserRole();
        CanSubmitForApproval := (Rec.Status in [Rec.Status::" ", Rec.Status::Rejected]);
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