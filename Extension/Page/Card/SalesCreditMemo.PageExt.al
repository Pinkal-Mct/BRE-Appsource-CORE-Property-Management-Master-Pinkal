pageextension 73209585 SalesCreditMemo extends "Sales Credit Memo"
{
    layout
    {
        addafter(General)
        {
            group("Contract Information")
            {
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'ID of the contract related to this credit memo.';
                    TableRelation = "Tenancy Contract"."Contract ID";

                    trigger OnValidate()
                    var
                        tenancyContract: Record "Tenancy Contract";

                    begin
                        tenancyContract.SetRange("Contract ID", Rec."Contract ID");
                        if tenancyContract.FindFirst() then begin
                            Rec."Tenant Name" := tenancyContract."Customer Name";
                            Rec."Property Name" := tenancyContract."Property Name";
                            Rec."Unit Name" := tenancyContract."Unit Name";
                            Rec."Contract Tenure" := tenancyContract."Contract Tenor";
                            Rec."Contract Period" := Format(tenancyContract."Contract Start Date", 0, '<Day,2>/<Month,2>/<Year4>') + ' To ' + Format(tenancyContract."Contract End Date", 0, '<Day,2>/<Month,2>/<Year4>');
                            Rec."Property Classification" := tenancyContract."Property Classification";
                            Rec."Contract Amount" := Round(tenancyContract."Annual Rent Amount");
                        end else begin
                            Rec."Tenant Name" := '';
                            rec."Property Name" := '';
                            Rec."Unit Name" := '';
                            Rec."Contract Tenure" := '';
                            Rec."Contract Period" := '';
                            Rec."Property Classification" := '';

                            // Rec."Tenant Name" := '';

                        end;
                    end;

                }
                field("Contract Amount"; Rec."Contract Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Amount of the contract related to this credit memo.';
                    Editable = false;
                }
                field("Property Name"; Rec."Property Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the property related to this credit memo.';
                    Editable = false;
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the unit related to this credit memo.';
                    Editable = false;
                }
                field("Contract Tenure"; Rec."Contract Tenure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Tenure of the contract related to this credit memo.';
                    Editable = false;

                }
                field("Contract Period"; Rec."Contract Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Period of the contract related to this credit memo.';
                    Editable = false;
                }
                field("Property Classification"; Rec."Property Classification")
                {
                    ApplicationArea = All;
                    ToolTip = 'Classification of the property related to this credit memo.';
                    Editable = false;
                }
                field("Approval Status for CreditNote"; Rec."Approval Status for CreditNote")
                {
                    ApplicationArea = All;
                    ToolTip = 'Approval status of the credit note.';
                    Caption = 'Approval Status Credit Note';
                    Editable = approvaleditable;

                    // Editable = approvaleditable;

                    trigger OnValidate()
                    var
                        SalesCreditNotePost: Codeunit "Sales-Post";
                        ShowDialogBox: Codeunit DialogboxRejectionCreditMemo;
                    begin

                        if Rec."Approval Status for CreditNote" = Rec."Approval Status for CreditNote"::Approved then
                            SalesCreditNotePost.Run(Rec)
                        else
                            if Rec."Approval Status for CreditNote" = Rec."Approval Status for CreditNote"::Rejected then
                                ShowDialogBox.Dialogboxcreditmemo(Rec);

                    end;
                }
                field("Rejection Reason CreditNote"; Rec."Rejection Reason CreditNote")
                {
                    ApplicationArea = All;
                    ToolTip = 'Reason for rejection of the credit note.';
                    Editable = false;
                }
                field("Terminated Credit Note"; Rec."Terminated Credit Note")
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
            field("Credit Memo URL"; Rec."Credit Memo URL")
            {
                ApplicationArea = All;
                Caption = 'Credit Memo Document URL';
                ToolTip = 'URL of the credit memo document stored in Azure Blob Storage.';
            }
            field("Credit Memo Document"; Rec."Credit Memo Document")
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

                    FileURL := Rec."Credit Memo URL";

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
                    sendMailToFMCreditNote: Codeunit "Send Mail to FM Credit Note";
                begin
                    sendMailToFMCreditNote.SendMailToFM(Rec);
                end;
            }
        }
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                if Rec."Approval Status for CreditNote" <> Rec."Approval Status for CreditNote"::Approved then
                    Error('The Sales Credit Memo cannot be posted because the approval status is not "Approved".');
            end;
        }

    }

    trigger OnAfterGetRecord()
    var
        tenancyContract: Record "Tenancy Contract";
    begin
        approvaleditable := GetUserEditableStatus();
        tenancyContract.SetRange("Contract ID", Rec."Contract ID");
        if tenancyContract.FindFirst() then begin

            Rec."Property Name" := tenancyContract."Property Name";
            Rec."Unit Name" := tenancyContract."Unit Name";
            Rec."Contract Tenure" := tenancyContract."Contract Tenor";
            Rec."Tenant Name" := tenancyContract."Customer Name";
            Rec."Contract Period" := Format(tenancyContract."Contract Start Date", 0, '<Day,2>/<Month,2>/<Year4>') + '  To  ' + Format(tenancyContract."Contract End Date", 0, '<Day,2>/<Month,2>/<Year4>');
            Rec."Contract Amount" := tenancyContract."Annual Rent Amount";
        end else begin
            rec."Property Name" := '';
            Rec."Unit Name" := '';
            Rec."Contract Tenure" := '';
            Rec."Contract Period" := '';
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
                'LEASE_MANAGER':
                    exit(false);
                'finance manager':
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