pageextension 73209587 SalesInvoice extends "Sales Invoice"
{

    layout
    {
        addafter(General)
        {
            group("Contract Details")
            {
                field("Contract ID"; Rec."Contract ID")
                {
                    Caption = 'Contract ID';
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'The Contract ID field is used to link the sales invoice to a specific tenancy contract.';
                    TableRelation = "Tenancy Contract"."Contract ID";


                    trigger OnValidate()
                    var
                        tenancyContract: Record "Tenancy Contract";
                        customercard: Record Customer;
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
                        end;

                        customercard.SetRange("No.", Rec."Sell-to Customer No.");
                        if customercard.FindSet() then
                            if Rec."Property Classification" <> '' then begin
                                customercard.Validate("Gen. Bus. Posting Group", Rec."Property Classification");
                                customercard.Validate("Customer Posting Group", Rec."Property Classification");
                                customercard.Modify();
                            end;

                        if Rec."Property Classification" <> '' then begin
                            Rec.Validate("Gen. Bus. Posting Group", Rec."Property Classification");
                            Rec.Validate("Customer Posting Group", Rec."Property Classification");
                            Rec.Modify();
                        end;
                    end;
                }
                field("Property Name"; Rec."Property Name")
                {
                    Caption = 'Property Name';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The Property Name field displays the name of the property associated with the tenancy contract.';
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    Caption = 'Unit Name';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The Unit Name field displays the name of the unit associated with the tenancy contract.';
                }
                field("Contract Tenure"; Rec."Contract Tenure")
                {
                    Caption = 'Contract Tenure';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The Contract Tenure field displays the duration of the tenancy contract.';
                }
                field("Sell-to Phone No."; Rec."Sell-to Phone No.")
                {
                    Caption = 'Customer Phone No.';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The Sell-to Phone No. field displays the phone number of the customer associated with the sales invoice.';
                }
                field("Sell-to E-Mail"; Rec."Sell-to E-Mail")
                {
                    Caption = 'Customer Email';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The Sell-to E-Mail field displays the email address of the customer associated with the sales invoice.';
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    Caption = 'Customer No.';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The Bill-to Customer No. field displays the customer number of the customer associated with the sales invoice.';
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The Tenant Name field displays the name of the tenant associated with the tenancy contract.';
                }
                field("Customer P.O"; Rec."Customer P.O")
                {
                    ApplicationArea = All;
                    Caption = 'Customer P.O';
                    Editable = NotAccessFieldFM;
                    ToolTip = 'The Customer P.O field is used to enter the purchase order number provided by the customer for the sales invoice.';
                }
                field("Customer P.O Date"; Rec."Customer P.O Date")
                {
                    ApplicationArea = All;
                    Caption = 'Customer P.O Date';
                    Editable = NotAccessFieldFM;
                    ToolTip = 'The Customer P.O Date field is used to enter the date of the purchase order provided by the customer for the sales invoice.';
                }
                field("Contract Period"; Rec."Contract Period")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Period';
                    Editable = false;
                    ToolTip = 'The Contract Period field displays the start and end dates of the tenancy contract.';
                }
                field("Reason for Rejection"; Rec."Reason for Rejection")
                {
                    Caption = 'Reason For Rejection';
                    ApplicationArea = All;
                    Editable = approvaleditable;
                    ToolTip = 'The Reason for Rejection field is used to specify the reason for rejecting the sales invoice during the approval process.';
                }

                field("Approval Status"; Rec."Approval Status")
                {
                    Caption = 'Approval Status';
                    ApplicationArea = All;
                    Editable = approvaleditable;
                    ToolTip = 'The Approval Status field indicates the current approval status of the sales invoice. It can be Approved, Pending, or Rejected.';

                    trigger OnValidate()
                    var
                        ShowDialogBox: Codeunit ShowDialogboxRejctionInvoice;
                        SalesPost: Codeunit "Sales-Post";
                    begin
                        if Rec."Approval Status" = Rec."Approval Status"::Approved then begin
                            CurrPage.SaveRecord();
                            SalesPost.Run(Rec);
                            CurrPage.Close();
                        end else
                            if Rec."Approval Status" = Rec."Approval Status"::Rejected then
                                ShowDialogBox.DialogboxForRejection(Rec);
                        UpdateInvoiceApprovalStatus();
                    end;
                }
                field("Overdue Invoice"; Rec."Overdue Invoice")
                {
                    Caption = 'Overdue Invoice';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The Overdue Invoice field indicates whether the sales invoice is overdue. It is set to true if the invoice is past its due date.';
                }
                field("Property Classification"; Rec."Property Classification")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The Property Classification field displays the classification of the property associated with the tenancy contract.';
                }
            }
        }

        addlast(General)
        {
            field("FC ID"; Rec."FC ID")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'The FC ID field is used to store the unique identifier for the financial controller associated with the sales invoice.';
            }
            field("View Document URL"; Rec."View Document URL")
            {
                ApplicationArea = All;
                Caption = 'View Document URL';
                ToolTip = 'The View Document URL field contains the URL to view the document associated with the sales invoice.';
            }
            field("View Invoice"; Rec."View Invoice")
            {
                ApplicationArea = All;
                Caption = 'View Invoice';
                Editable = false;
                DrillDown = true;
                ToolTip = 'The View Invoice field contains the name of the invoice document. Click to view the document in a web browser.';
                trigger OnDrillDown()
                var
                    FileURL: Text;
                begin

                    FileURL := Rec."View Document URL";

                    if FileURL = '' then
                        Error('No document is available to view.');

                    OpenFileInBrowser(FileURL);
                end;
            }
        }
    }

    actions
    {
        addafter(Release)
        {
            action("Run Report")
            {
                Caption = 'Run Report';
                ApplicationArea = All;
                ToolTip = 'Run the Sales Invoice report for the current invoice.';

                trigger OnAction()
                var
                    SalesInvoice: Record "Sales Header";
                    SalesInvoiceReport: Report InvoiceTemplate;
                begin
                    Commit();
                    SalesInvoice.SetRange("No.", Rec."No.");
                    SalesInvoiceReport.SetTableView(SalesInvoice);
                    SalesInvoiceReport.Run();
                end;
            }

        }
        addafter(Action9)
        {
            action(ResendForApproval)
            {
                ApplicationArea = All;
                Caption = 'Resend For Approval';
                Image = SendMail;
                ToolTip = 'Resend the sales invoice for approval.';
                trigger OnAction()
                var
                    ResendInvoiceMail: Codeunit ResendUpdateInvoiceFM;
                begin
                    ResendInvoiceMail.ResendUpdateInvoice(Rec);
                end;
            }
        }

        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                if Rec."Approval Status" <> Rec."Approval Status"::Approved then
                    Error('The Sales Invoice cannot be posted because the approval status is not "Approved".');
            end;
        }


    }
    procedure OpenFileInBrowser(URL: Text)
    begin
        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
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

    procedure NotAccessFieldFinanceManager(): Boolean
    var
        UserPersonalization1: Record "User Personalization";
    begin

        if UserPersonalization1.Get(UserSecurityId()) then
            case UserPersonalization1."Profile ID" of
                'PROPERTY MANAGER':
                    exit(false);
                'LEASE MANAGER':
                    exit(false);
                'FINANCE MANAGER':
                    exit(true);
            end;

    end;

    trigger OnAfterGetRecord()
    var
        tenancyContract: Record "Tenancy Contract";
        customer: Record Customer;
    begin
        approvaleditable := GetUserEditableStatus();
        NotAccessFieldFM := NotAccessFieldFinanceManager();
        customer.SetRange("No.", Rec."Sell-to Customer No.");

        if customer.FindFirst() then begin
            Rec."Sell-to Customer Name" := customer.Name;
            Rec."Sell-to Address" := customer.Address;
            Rec."Sell-to Phone No." := customer."Phone No.";
            Rec."Sell-to E-Mail" := customer."E-Mail";
            Rec."Bill-to Customer No." := customer."No.";
            Rec."Bill-to Name" := customer.Name;
            Rec."Bill-to Address" := customer.Address;
            Rec.Modify();
        end;

        tenancyContract.SetRange("Contract ID", Rec."Contract ID");
        if tenancyContract.FindFirst() then begin
            Rec."Property Name" := tenancyContract."Property Name";
            Rec."Unit Name" := tenancyContract."Unit Name";
            Rec."Contract Tenure" := tenancyContract."Contract Tenor";
            Rec."Tenant Name" := tenancyContract."Customer Name";
            Rec."Contract Period" := Format(tenancyContract."Contract Start Date", 0, '<Day,2>/<Month,2>/<Year4>') + '  To  ' + Format(tenancyContract."Contract End Date", 0, '<Day,2>/<Month,2>/<Year4>')
        end else begin
            rec."Property Name" := '';
            Rec."Unit Name" := '';
            Rec."Contract Tenure" := '';
            Rec."Contract Period" := '';
        end;

    end;

    var
        approvaleditable: Boolean;
        NotAccessFieldFM: Boolean;

    procedure UpdateInvoiceApprovalStatus()
    var
        PaymentSchedule2: Record "Payment Schedule2";
    begin
        PaymentSchedule2.SetRange("Invoice ID", Rec."No.");
        if PaymentSchedule2.FindSet() then
            repeat
                PaymentSchedule2.Validate("Invoice Approval Status", Rec."Approval Status");
                PaymentSchedule2.Modify();
            until PaymentSchedule2.Next() = 0;
    end;

}

