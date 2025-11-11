pageextension 50503 salesinvoiceext extends "Sales Invoice List"
{
    layout
    {
        addafter(Amount)
        {
            field("Contract ID"; Rec."Contract ID")
            {
                ApplicationArea = All;
                Caption = 'Contract ID';
                ToolTip = 'Specifies the contract ID associated with the sales invoice.';
                trigger OnValidate()
                var
                    tenancyContract: Record "Tenancy Contract";
                begin
                    tenancyContract.SetRange("Contract ID", Rec."Contract ID");
                    if tenancyContract.FindFirst() then begin
                        Rec."Property Name" := tenancyContract."Property Name";
                        Rec."Unit Name" := tenancyContract."Unit Name";
                        Rec."Contract Tenure" := tenancyContract."Contract Tenor";
                        Rec."Contract Period" := Format(tenancyContract."Contract Start Date") + 'To' + Format(tenancyContract."Contract End Date");
                    end else begin
                        rec."Property Name" := '';
                        Rec."Unit Name" := '';
                        Rec."Contract Tenure" := '';
                        Rec."Contract Period" := ''
                    end;
                end;
            }
            field("Property Name"; Rec."Property Name")
            {
                Caption = 'Property Name';
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the name of the property associated with the sales invoice.';
            }
            field("Unit Name"; Rec."Unit Name")
            {
                Caption = 'Unit Name';
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the name of the unit associated with the sales invoice.';
            }
            field("Contract Tenure"; Rec."Contract Tenure")
            {
                Caption = 'Contract Tenure';
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the tenure of the contract associated with the sales invoice.';
            }
            field("Sell-to Phone No."; Rec."Sell-to Phone No.")
            {
                Caption = 'Customer Phone No.';
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the phone number of the customer associated with the sales invoice.';
            }
            field("Sell-to E-Mail"; Rec."Sell-to E-Mail")
            {
                Caption = 'Customer Email';
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the email address of the customer associated with the sales invoice.';
            }
            field("Contract Period"; Rec."Contract Period")
            {
                Caption = 'Contract Period';
                ApplicationArea = All;
                ToolTip = 'Specifies the period of the contract associated with the sales invoice.';
            }
            field("Reason for Rejection"; Rec."Reason for Rejection")
            {
                Caption = 'Reason For Rejection';
                ApplicationArea = All;
                ToolTip = 'The Reason for Rejection field is used to specify the reason for rejecting the sales invoice during the approval process.';
            }
            field("Approval Status"; Rec."Approval Status")
            {
                Caption = 'Approval Status';
                ApplicationArea = All;
                ToolTip = 'Specifies the approval status of the sales invoice.';
            }
            field("Tenant Name"; Rec."Tenant Name")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the name of the tenant associated with the sales invoice.';
            }
            field("Customer P.O"; Rec."Customer P.O")
            {
                ApplicationArea = All;
                Caption = 'Customer P.O';
                ToolTip = 'Specifies the customer purchase order number associated with the sales invoice.';
            }
            field("Customer P.O Date"; Rec."Customer P.O Date")
            {
                ApplicationArea = All;
                Caption = 'Customer P.O Date';
                ToolTip = 'Specifies the date of the customer purchase order associated with the sales invoice.';
            }
        }
    }
    actions
    {
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                if Rec."Approval Status" <> Rec."Approval Status"::Approved then
                    Error('The Sales Invoice cannot be posted because the approval status is not "Approved".');
            end;
        }
    }
    trigger OnAfterGetRecord()
    var
        tenancyContract: Record "Tenancy Contract";
        customer: Record Customer;
        salesline: Record "Sales Line";
    begin
        customer.SetRange("No.", Rec."Sell-to Customer No.");
        if customer.FindFirst() then begin
            Rec."Sell-to Customer Name" := customer.Name;
            Rec."Sell-to Address" := customer.Address;
            Rec."Gen. Bus. Posting Group" := customer."Gen. Bus. Posting Group";
            Rec."VAT Bus. Posting Group" := customer."VAT Bus. Posting Group";
            Rec."Customer Posting Group" := customer."Customer Posting Group";
            Rec."Sell-to Phone No." := customer."Phone No.";
            Rec."Sell-to E-Mail" := customer."E-Mail";
            Rec."Bill-to Customer No." := customer."No.";
            Rec."Bill-to Name" := customer.Name;
            Rec."Bill-to Address" := customer.Address;
            Rec.Modify();
        end;
        salesline.SetRange("Document No.", Rec."No.");
        if salesline.FindSet() then
            repeat
                salesline."Gen. Bus. Posting Group" := Rec."Gen. Bus. Posting Group";
                salesline."Customer Price Group" := Rec."Customer Price Group";
                salesline."VAT Bus. Posting Group" := Rec."VAT Bus. Posting Group";
                salesline.Modify();
            until salesline.Next() = 0;
        tenancyContract.SetRange("Contract ID", Rec."Contract ID");
        if tenancyContract.FindFirst() then begin
            Rec."Property Name" := tenancyContract."Property Name";
            Rec."Unit Name" := tenancyContract."Unit Name";
            Rec."Contract Tenure" := tenancyContract."Contract Tenor";
            Rec."Contract Period" := Format(tenancyContract."Contract Start Date") + ' To ' + Format(tenancyContract."Contract End Date")
        end else begin
            rec."Property Name" := '';
            Rec."Unit Name" := '';
            Rec."Contract Tenure" := '';
            Rec."Contract Period" := '';
        end;
    end;
}