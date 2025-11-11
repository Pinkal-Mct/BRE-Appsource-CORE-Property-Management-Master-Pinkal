page 50906 "Additional Charges Sub Card"
{
    PageType = ListPart;
    ApplicationArea = All;
    // UsageCategory = Administration;
    SourceTable = "Additional Charges Sub";
    Caption = 'Termination Additional Charges';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                field("Secondary Item Type"; Rec."Secondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                    ToolTip = 'Enter the Secondary Item Type.';
                    ShowMandatory = true;
                    NotBlank = true;
                }
                field("Amount"; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ShowMandatory = true;
                    NotBlank = true;
                    ToolTip = 'Enter the amount for the additional charge.';
                }

                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the VAT percentage for the additional charge.';
                    trigger OnValidate()
                    begin
                        CurrPage.Update(); // Refresh the page to apply changes immediately
                    end;
                }

                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Amount';
                    ToolTip = 'Enter the VAT amount for the additional charge.';
                }

                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Including VAT';
                    ToolTip = 'Enter the total amount including VAT for the additional charge.';
                }

                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'Enter the start date for the additional charge.';
                }

                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'Enter the end date for the additional charge.';
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'Enter the Contract ID associated with the additional charge.';
                    Editable = false;
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'Enter the Tenant ID associated with the additional charge.';
                    Editable = false;
                }
                field(Invoiced; Rec.Invoiced)
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether the additional charge has been invoiced.';
                }
                field("Invoiced ID"; Rec."Invoiced ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'The ID of the invoice to which this additional charge is linked.';
                    Editable = false;
                }
                field("Unit Type"; Rec."Unit Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the Unit Type associated with the additional charge.';
                    Editable = false;
                    Visible = false;
                }
            }

            group(TotalAmount)
            {
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the total amount for the additional charge.';
                }
                field("Posted Invoice ID"; Rec."Posted Invoice ID")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    Caption = 'Invoice ID';
                    Editable = false;
                    ToolTip = 'Click to view the invoice.';
                    //  DrillDownPageId = "Sales Invoice";
                    trigger OnDrillDown()
                    var
                        SalesHeader: Record "Sales Header";

                        postedsalesinvoice: Record "Sales Invoice Header";
                    begin
                        SalesHeader.SetRange("No.", Rec."Posted Invoice ID");
                        if SalesHeader.FindFirst() then
                            PAGE.Run(PAGE::"Sales Invoice", SalesHeader)
                        else begin
                            postedsalesinvoice.SetRange("No.", Rec."Posted Invoice ID");
                            if postedsalesinvoice.FindFirst() then
                                PAGE.Run(PAGE::"Posted Sales Invoice", postedsalesinvoice);

                        end;
                    end;

                }
                field("Invoice Document"; Rec."Invoice Document")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Invoice Document';
                    ToolTip = 'Click to view the invoice document.';

                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin
                        FileURL := Rec."Invoice Document URL";
                        if FileURL = '' then
                            Error('No document is available to view.');
                        OpenFileInBrowser(FileURL);
                    end;
                }
                field("Invoice Document URL"; Rec."Invoice Document URL")
                {
                    ApplicationArea = All;
                    Caption = 'Invoice Document URL';
                    ToolTip = 'Click to view the invoice document.';
                    Editable = false;
                    Visible = false;
                }

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Invoice)
            {
                ToolTip = 'Generate Invoice for Additional Charges';
                ApplicationArea = All;
                Caption = 'Generate Invoice';
                Image = NewInvoice;
                trigger OnAction()
                var
                    newsalesheader: Record "Sales Header";

                    additionalchargesgrid: Record "Additional Charges Sub";
                    customercard: Record Customer;

                    userConfirmed: Boolean;
                begin
                    if Rec.Invoiced = false then begin
                        userConfirmed := Confirm('Do you want to create the invoice?', false);
                        if not userConfirmed then
                            exit;
                        newsalesheader := CreateSalesHeader(Rec."Contract ID", Rec."Tenant ID", Rec."Unit Type");
                        customercard.SetRange("No.", newsalesheader."Sell-to Customer No.");
                        if customercard.FindSet() then
                            if newsalesheader."Property Classification" <> '' then begin
                                customercard.Validate("Gen. Bus. Posting Group", newsalesheader."Property Classification");
                                customercard.Validate("Customer Posting Group", newsalesheader."Property Classification");
                                customercard.Modify();
                            end;

                        if newsalesheader."Property Classification" <> '' then begin
                            newsalesheader."Gen. Bus. Posting Group" := CopyStr(newsalesheader."Property Classification", 1, StrLen(newsalesheader."Property Classification"));
                            newsalesheader."Customer Posting Group" := CopyStr(newsalesheader."Property Classification", 1, StrLen(newsalesheader."Property Classification"));
                            newsalesheader.Modify();
                        end;

                        additionalchargesgrid.SetRange("Contract ID", Rec."Contract ID");
                        if additionalchargesgrid.FindSet() then
                            repeat
                                Saleslinecreate(newsalesheader, additionalchargesgrid);
                                additionalchargesgrid.Invoiced := true;
                                additionalchargesgrid."Invoiced ID" := newsalesheader."No.";
                                additionalchargesgrid."Posted Invoice ID" := newsalesheader."No.";
                                additionalchargesgrid.Modify();
                            until additionalchargesgrid.Next() = 0;

                        Message('Invoice has been generated, please click on the Invoice ID to proceed further');
                    end else
                        Message('Already Create invoice for the contract id');

                end;
            }
        }
    }
    procedure CreateSalesHeader(pContractID: Integer; pTenantID: Code[50]; pUnitType: Text[50]): Record "Sales Header";
    var
        salesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Header";
        salesReciveable: Record "Sales & Receivables Setup";
        noseries: Codeunit "No. Series";

    begin
        salesHeader.Init();
        if salesReciveable.FindFirst() then
            salesHeader."No." := noseries.GetNextNo(salesReciveable."Invoice Nos.", Today, true);
        salesHeader."Document Type" := SalesInvoiceHeader."Document Type"::Invoice;
        salesHeader.Validate("Sell-to Customer No.", pTenantID);
        salesHeader."Document Date" := Today;
        salesHeader.Validate("Contract ID", pcontractid);
        salesHeader."Posting Date" := Today;
        salesHeader."Due Date" := Today;
        salesHeader."Property Classification" := pUnitType;
        salesHeader."Posting No. Series" := salesReciveable."Posted Invoice Nos.";
        salesHeader.Insert();
        exit(salesHeader);
    end;

    procedure Saleslinecreate(salesheader1: Record "Sales Header"; additionalchargessub: Record "Additional Charges Sub")
    var
        saleline: Record "Sales Line";
        newSaleslines: Record "Sales Line";
        item: Record Item;
    begin

        saleline.Init();
        saleline."Document Type" := saleline."Document Type"::Invoice;

        newSaleslines.SetRange("Document No.", salesheader1."No.");
        newSaleslines.SetRange("Document Type", Enum::"Sales Document Type"::Invoice);
        newSaleslines.SetCurrentKey("Line No.");
        if newSaleslines.FindLast() then
            saleline."Line No." := newSaleslines."Line No." + 1000
        else
            saleline."Line No." := 1000;

        saleline."Document No." := salesheader1."No.";
        saleline."Contract ID" := salesheader1."Contract ID";
        saleline.Type := saleline.Type::Item;
        saleline."Sell-to Customer No." := salesheader1."Sell-to Customer No.";
        item.SetRange(Description, additionalchargessub."Secondary Item Type");
        item.SetFilter("Charges Status", '<>%1', item."Charges Status"::" ");
        if item.FindFirst() then
            saleline.Validate("No.", item."No.");

        saleline.Validate("Quantity (Base)", 1);
        saleline.Validate(Quantity, 1);
        saleline.Validate("Unit Price", Abs(additionalchargessub.Amount));
        saleline."Contract ID" := additionalchargessub."Contract ID";
        saleline."FC ID" := salesheader1."FC ID";
        saleline.Insert();
        Clear(saleline);
    end;

    procedure OpenFileInBrowser(URL: Text)
    begin

        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;

    procedure SetContractID(pContractID: Integer)
    begin
        contractID := pContractID;
    end;

    procedure SetTenantID(pTenantID: Code[20])
    begin
        tenantID := pTenantID;
    end;


    procedure SetStartEndDate(pStartDate: Date; pEndDate: Date)
    begin
        startDate := pStartDate;
        endDate := pEndDate;

    end;

    procedure SetUnitType(punittype: Text[100])
    begin
        unittype := punittype;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."Contract ID" := ContractID;
        Rec."Tenant ID" := tenantID;

        Rec."Start Date" := startDate;
        Rec."End Date" := endDate;
        Rec."Unit Type" := CopyStr(unittype, 1, StrLen(unittype));
    end;


    var
        contractID: Integer;
        tenantID: Code[20];
        startDate: Date;
        endDate: Date;

        unittype: Text[100];

}