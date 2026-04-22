pageextension 73209582 PostedSalesInvoiceHeader extends "Posted Sales Invoice"
{
    layout
    {
        addafter(General)
        {
            group("Contract Details")
            {
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Caption = 'Contract ID';
                    ToolTip = 'Specifies the contract associated with this posted sales invoice.';
                }
                field("Property Name"; Rec."Property Name")
                {
                    Caption = 'Property Name';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the property associated with this posted sales invoice.';
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    Caption = 'Unit Name';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the unit associated with this posted sales invoice.';
                }
                field("Contract Tenure"; Rec."Contract Tenure")
                {
                    Caption = 'Contract Tenure';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the tenure of the contract associated with this posted sales invoice.';
                }
                field("Sell-to Phone No."; Rec."Sell-to Phone No.")
                {
                    Caption = 'Customer Phone No.';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the phone number of the customer associated with this posted sales invoice.';
                }
                field("Sell-to E-Mail"; Rec."Sell-to E-Mail")
                {
                    Caption = 'Customer Email';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the email address of the customer associated with this posted sales invoice.';
                }
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    Caption = 'Customer No.';
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the customer number associated with this posted sales invoice.';
                }
                field("Contract Period"; Rec."Contract Period")
                {
                    Caption = 'Contract Period';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the period of the contract associated with this posted sales invoice.';
                }
                field("Reason for Rejection"; Rec."Reason for Rejection")
                {
                    Caption = 'Reason For Rejection';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the reason for rejection of this posted sales invoice, if applicable.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Caption = 'Approval Status';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the approval status of this posted sales invoice.';
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the tenant associated with this posted sales invoice.';
                }
                field("Customer P.O"; Rec."Customer P.O")
                {
                    ApplicationArea = All;
                    Caption = 'Customer P.O';
                    ToolTip = 'Specifies the purchase order number provided by the customer for this posted sales invoice.';
                }
                field("Customer P.O Date"; Rec."Customer P.O Date")
                {
                    ApplicationArea = All;
                    Caption = 'Customer P.O Date';
                    ToolTip = 'Specifies the date of the purchase order provided by the customer for this posted sales invoice.';
                }
            }
        }

        addlast(General)
        {
            field("View Invoice"; Rec."View Invoice")
            {
                ToolTip = 'Click to view the invoice document associated with this posted sales invoice.';
                ApplicationArea = All;
                Caption = 'View Invoice';
                Editable = false;
                DrillDown = true;
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
            field("View Document URL"; Rec."View Document URL")
            {
                ApplicationArea = All;
                Caption = 'View Document URL';
                ToolTip = 'Specifies the URL to view the document associated with this posted sales invoice.';
            }
            field("FC ID"; Rec."FC ID")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the financial charge associated with this posted sales invoice.';
            }
        }
    }
    procedure OpenFileInBrowser(URL: Text)
    begin

        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;
}