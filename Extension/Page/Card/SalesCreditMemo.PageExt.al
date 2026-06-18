pageextension 73209585 BLRSalesCreditMemo extends "Sales Credit Memo"
{
    layout
    {
        addafter(General)
        {
            group("Contract Information")
            {
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'ID of the contract related to this credit memo.';
                    TableRelation = "BLRTenancyContract"."BLRContract ID";

                    trigger OnValidate()
                    var
                        tenancyContract: Record "BLRTenancyContract";

                    begin
                        tenancyContract.SetRange("BLRContract ID", Rec."BLRContract ID");
                        if tenancyContract.FindFirst() then begin
                            Rec."BLRTenant Name" := tenancyContract."BLRCustomer Name";
                            Rec."BLRProperty Name" := tenancyContract."BLRProperty Name";
                            Rec."BLRUnit Name" := tenancyContract."BLRUnit Name";
                            Rec."BLRContract Tenure" := tenancyContract."BLRContract Tenor";
                            Rec."BLRContract Period" := Format(tenancyContract."BLRContract Start Date", 0, '<Day,2>/<Month,2>/<Year4>') + ' To ' + Format(tenancyContract."BLRContract End Date", 0, '<Day,2>/<Month,2>/<Year4>');
                            Rec."BLRProperty Classification" := tenancyContract."BLRProperty Classification";
                            Rec."BLRContract Amount" := Round(tenancyContract."BLRAnnual Rent Amount");
                        end else begin
                            Rec."BLRTenant Name" := '';
                            rec."BLRProperty Name" := '';
                            Rec."BLRUnit Name" := '';
                            Rec."BLRContract Tenure" := '';
                            Rec."BLRContract Period" := '';
                            Rec."BLRProperty Classification" := '';

                            // Rec."Tenant Name" := '';

                        end;
                    end;

                }
                field("Contract Amount"; Rec."BLRContract Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Amount of the contract related to this credit memo.';
                    Editable = false;
                }
                field("Property Name"; Rec."BLRProperty Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the property related to this credit memo.';
                    Editable = false;
                }
                field("Unit Name"; Rec."BLRUnit Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the unit related to this credit memo.';
                    Editable = false;
                }
                field("Contract Tenure"; Rec."BLRContract Tenure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Tenure of the contract related to this credit memo.';
                    Editable = false;

                }
                field("Contract Period"; Rec."BLRContract Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Period of the contract related to this credit memo.';
                    Editable = false;
                }
                field("Property Classification"; Rec."BLRProperty Classification")
                {
                    ApplicationArea = All;
                    ToolTip = 'Classification of the property related to this credit memo.';
                    Editable = false;
                }
                field("Approval Status for CreditNote"; Rec."BLRApprovalStatusforCreditNote")
                {
                    ApplicationArea = All;
                    ToolTip = 'Approval status of the credit note.';
                    Caption = 'Approval Status Credit Note';
                    Editable = approvaleditable;

                    // Editable = approvaleditable;

                    trigger OnValidate()
                    var
                        SalesCreditNotePost: Codeunit "Sales-Post";
                        ShowDialogBox: Codeunit BLRDialogboxRejecCreditMemo;
                    begin

                        if Rec."BLRApprovalStatusforCreditNote" = Rec."BLRApprovalStatusforCreditNote"::Approved then
                            SalesCreditNotePost.Run(Rec)
                        else
                            if Rec."BLRApprovalStatusforCreditNote" = Rec."BLRApprovalStatusforCreditNote"::Rejected then
                                ShowDialogBox.Dialogboxcreditmemo(Rec);

                    end;
                }
                field("Rejection Reason CreditNote"; Rec."BLRRejection Reason CreditNote")
                {
                    ApplicationArea = All;
                    ToolTip = 'Reason for rejection of the credit note.';
                    Editable = false;
                }
                field("Terminated Credit Note"; Rec."BLRTerminated Credit Note")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates if the credit note is terminated.';
                    Editable = false;
                    Visible = false;
                }

            }

        }
        addlast(General)
        {
            field("Credit Memo URL"; Rec."BLRCredit Memo URL")
            {
                ApplicationArea = All;
                Caption = 'Credit Memo Document URL';
                ToolTip = 'URL of the credit memo document stored in Azure Blob Storage.';
            }
            field("Credit Memo Document"; Rec."BLRCredit Memo Document")
            {
                ApplicationArea = All;
                Caption = 'View Invoice';
                Editable = false;
                DrillDown = true;
                ToolTip = 'Click to view the credit memo document.';
                trigger OnDrillDown()
                var
                    FileURL: Text;
                begin

                    FileURL := Rec."BLRCredit Memo URL";

                    if FileURL = '' then
                        Error('No document is available to view.');

                    OpenFileInBrowser(FileURL);
                end;

            }
        }
    }
    actions
    {
        addafter(Action7)
        {
            action("Send Approval to Finance Manager")
            {
                ApplicationArea = All;
                Caption = 'Send Approval to Finance Manager';
                ToolTip = 'Send the credit memo for approval to the finance manager.';
                trigger OnAction()
                var
                    sendMailToFMCreditNote: Codeunit "BLRSend Mail to FM Credit Note";
                begin
                    sendMailToFMCreditNote.SendMailToFM(Rec);
                end;
            }
        }
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                if Rec."BLRApprovalStatusforCreditNote" <> Rec."BLRApprovalStatusforCreditNote"::Approved then
                    Error('The Sales Credit Memo cannot be posted because the approval status is not "Approved".');
            end;
        }

    }

    trigger OnAfterGetRecord()
    var
        tenancyContract: Record "BLRTenancyContract";
    begin
        approvaleditable := GetUserEditableStatus();
        tenancyContract.SetRange("BLRContract ID", Rec."BLRContract ID");
        if tenancyContract.FindFirst() then begin

            Rec."BLRProperty Name" := tenancyContract."BLRProperty Name";
            Rec."BLRUnit Name" := tenancyContract."BLRUnit Name";
            Rec."BLRContract Tenure" := tenancyContract."BLRContract Tenor";
            Rec."BLRTenant Name" := tenancyContract."BLRCustomer Name";
            Rec."BLRContract Period" := Format(tenancyContract."BLRContract Start Date", 0, '<Day,2>/<Month,2>/<Year4>') + '  To  ' + Format(tenancyContract."BLRContract End Date", 0, '<Day,2>/<Month,2>/<Year4>');
            Rec."BLRContract Amount" := tenancyContract."BLRAnnual Rent Amount";
        end else begin
            rec."BLRProperty Name" := '';
            Rec."BLRUnit Name" := '';
            Rec."BLRContract Tenure" := '';
            Rec."BLRContract Period" := '';
        end;
    end;

    procedure GetUserEditableStatus(): Boolean
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

    procedure OpenFileInBrowser(URL: Text)
    begin

        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;

    var
        approvaleditable: Boolean;
}