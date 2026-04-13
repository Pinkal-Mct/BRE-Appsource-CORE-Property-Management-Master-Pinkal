page 50951 "Final Billing Calculation"
{
    PageType = ListPart;
    ApplicationArea = All;
    Caption = 'Final Billing Calculation Grid';
    SourceTable = "Final Billing Calculation Grid";
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(RevenueDescription; Rec.RevenueDescription)
                {
                    Caption = 'Revenue Description';
                    ApplicationArea = All;
                    ToolTip = 'The description of the revenue item.';
                    Editable = false;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    Caption = 'Contract ID';
                    ApplicationArea = All;
                    ToolTip = 'The unique identifier for the contract associated with this billing calculation.';
                    Editable = false;
                    Visible = false;
                }
                field("Entry No"; Rec."Entry No")
                {
                    Caption = 'Entry No.';
                    ApplicationArea = All;
                    ToolTip = 'The unique entry number for this billing calculation.';
                    Editable = false;
                    Visible = false;
                }
                field(InvoicedAmount; Rec.InvoicedAmount)
                {
                    Caption = 'Invoiced Amount';
                    ToolTip = 'The total amount that has been invoiced for this billing calculation.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(InvoicedVAT; Rec.InvoicedVAT)
                {
                    ToolTip = 'The total VAT amount that has been invoiced for this billing calculation.';
                    Caption = 'Invoiced VAT';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(InvoicedAmountInclVAT; Rec.InvoicedAmountInclVAT)
                {
                    ToolTip = 'The total amount including VAT that has been invoiced for this billing calculation.';
                    Caption = 'Invoiced Amount Incl. VAT';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(RevisedAmount; Rec.RevisedAmount)
                {
                    ToolTip = 'The revised amount for this billing calculation, which may differ from the invoiced amount.';
                    Caption = 'Revised Amount';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(RevisedVAT; Rec.RevisedVAT)
                {
                    ToolTip = 'The revised VAT amount for this billing calculation, which may differ from the invoiced VAT.';
                    Caption = 'Revised VAT';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(RevisedAmountInclVAT; Rec.RevisedAmountInclVAT)
                {
                    ToolTip = 'The revised amount including VAT for this billing calculation, which may differ from the invoiced amount including VAT.';
                    Caption = 'Revised Amount Incl. VAT';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(DifferenceAmount; Rec.DifferenceAmount)
                {
                    ToolTip = 'The difference amount calculated as the difference between the invoiced amount and the revised amount.';
                    Caption = 'Difference Amount';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(DifferenceVAT; Rec.DifferenceVAT)
                {
                    ToolTip = 'The difference VAT calculated as the difference between the invoiced VAT and the revised VAT.';
                    Caption = 'Difference VAT';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(DifferenceAmountInclVAT; Rec.DifferenceAmountInclVAT)
                {
                    ToolTip = 'The difference amount including VAT calculated as the difference between the invoiced amount including VAT and the revised amount including VAT.';
                    Caption = 'Difference Amount Incl. VAT';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Termination Date"; Rec."Termination Date")
                {
                    ToolTip = 'The termination date of the contract associated with this billing calculation.';
                    Caption = 'Termination Date';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ToolTip = 'The type of payment associated with this billing calculation, such as "Rent" or "Service Charge".';
                    ApplicationArea = All;
                    Caption = 'Payment Type';
                    Editable = false;
                    Visible = false;
                }
                field("Property Classification"; Rec."Property Classification")
                {
                    ToolTip = 'The classification of the property associated with this billing calculation, such as "Residential" or "Commercial".';
                    ApplicationArea = All;
                    Caption = 'Property Classification';
                    Editable = false;
                    Visible = false;
                }
                field("Invoiced"; Rec.Invoiced)
                {
                    ToolTip = 'Indicates whether this billing calculation has been invoiced.';
                    ApplicationArea = All;
                    Caption = 'Invoiced';
                }
            }
            group(" ")
            {
                grid(SummaryGrid)
                {
                    GridLayout = Columns;
                    group("Invoice Values")
                    {
                        field("Total Invoiced Amount"; Rec."Total Invoiced Amount")
                        {
                            ApplicationArea = All;
                            ToolTip = 'The total amount that has been invoiced for this billing calculation.';
                            Editable = false;
                            Caption = 'Total Invoiced Amount';
                        }
                        field("Total Invoiced VAT"; Rec."Total Invoiced VAT")
                        {
                            ToolTip = 'The total VAT amount that has been invoiced for this billing calculation.';
                            ApplicationArea = All;
                            Editable = false;
                            Caption = 'Total Invoiced VAT';
                        }
                        field("Total Invoiced AmountIncl. VAT"; Rec."Total Invoiced AmountIncl. VAT")
                        {
                            ToolTip = 'The total amount including VAT that has been invoiced for this billing calculation.';
                            ApplicationArea = All;
                            Editable = false;
                            Caption = 'Total Invoiced Amount Incl. VAT';
                        }
                    }
                    group("Revised Values")
                    {
                        field("Total Revised Amount"; Rec."Total Revised Amount")
                        {
                            ToolTip = 'The total revised amount for this billing calculation, which may differ from the invoiced amount.';
                            ApplicationArea = All;
                            Caption = 'Total Revised Amount';
                            Editable = false;
                        }
                        field("Total Revised VAT"; Rec."Total Revised VAT")
                        {
                            ToolTip = 'The total revised VAT amount for this billing calculation, which may differ from the invoiced VAT.';
                            ApplicationArea = All;
                            Caption = 'Total Revised VAT';
                            Editable = false;
                        }
                        field("Total Revised AmountIncl.VAT"; Rec."Total Revised AmountIncl.VAT")
                        {
                            ToolTip = 'The total revised amount including VAT for this billing calculation, which may differ from the invoiced amount including VAT.';
                            ApplicationArea = All;
                            Caption = 'Total Revised Amount Incl. VAT';
                            Editable = false;
                        }
                    }
                    group("Summary")
                    {
                        field("Invoice To Be Raised"; Rec."Invoice To Be Raised")
                        {
                            ToolTip = 'The total amount to be raised as an invoice for this billing calculation.';
                            ApplicationArea = All;
                            Caption = 'Invoice To Be Raised';
                            Editable = false;
                        }
                        field("Credit Note To Be Raised"; Rec."Credit Note To Be Raised")
                        {
                            ToolTip = 'The total amount to be raised as a credit note for this billing calculation.';
                            ApplicationArea = All;
                            Caption = 'Credit Note To Be Raised';
                            Editable = false;
                        }
                        field("Creditnote"; Rec."Creditnote")
                        {
                            ToolTip = 'Indicates whether a credit note is applicable for this billing calculation.';
                            ApplicationArea = All;
                            Caption = 'Creditnote';
                            Editable = false;
                            Visible = false;
                        }
                        field("Total Differnece Amount"; Rec."Total Differnece Amount")
                        {
                            ApplicationArea = All;
                            ToolTip = 'The total difference amount calculated for this billing calculation.';
                            Caption = 'Total Differnece Amount';
                            Editable = false;
                            Visible = false;
                        }
                        field("Total Difference VAT"; Rec."Total Difference VAT")
                        {
                            ApplicationArea = All;
                            ToolTip = 'The total difference VAT calculated for this billing calculation.';
                            Caption = 'Total Difference VAT';
                            Editable = false;
                            Visible = false;
                        }
                        field("Total DifferenceAmountIncl.VAT"; Rec."Total DifferenceAmountIncl.VAT")
                        {
                            ApplicationArea = All;
                            ToolTip = 'The total difference amount including VAT calculated for this billing calculation.';
                            Caption = 'Total Difference Amount Incl. VAT';
                            Editable = false;
                            Visible = false;
                        }
                    }
                }
            }
            group("Final Billing Details")
            {
                grid(BillingDetail)
                {
                    GridLayout = Columns;
                    group("Invoice Details")
                    {
                        field("Invoice Amount"; Rec."Invoice Amount")
                        {
                            ToolTip = 'The total amount to be invoiced for this billing calculation.';
                            ApplicationArea = All;
                            Caption = 'Invoice Amount';
                            Editable = false;
                        }
                        field("Posted Invoice ID"; Rec."Posted Invoice ID")
                        {
                            ApplicationArea = All;
                            Editable = false;
                            Caption = 'Invoice ID';
                            DrillDown = true;
                            ToolTip = 'Click to view the invoice.';
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
                            ToolTip = 'The document associated with the invoice for this billing calculation.';
                            ApplicationArea = All;
                            Editable = false;
                            Caption = 'Invoice Document';
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
                            ToolTip = 'The URL of the document associated with the invoice for this billing calculation.';
                            ApplicationArea = All;
                            Caption = 'Invoice Document URL';
                            Editable = false;
                            Visible = false;
                        }
                    }
                    group("Credit Note Details")
                    {
                        field("Credit Note Amount"; Rec."Credit Note Amount")
                        {
                            ToolTip = 'The total amount to be credited for this billing calculation.';
                            ApplicationArea = All;
                            Caption = 'Credit Note Amount';
                            Editable = false;
                        }
                        field("Credit Note ID"; Rec."Credit Note ID")
                        {
                            ToolTip = 'The unique identifier for the credit note associated with this billing calculation.';
                            ApplicationArea = All;
                            Caption = 'Credit Note ID';
                            Editable = false;
                            DrillDown = true;
                            trigger OnDrillDown()
                            var
                                creditnote: Record "Credit Note";
                            begin
                                creditnote.SetRange("Credit Note No.", Rec."Credit Note ID");
                                if creditnote.FindFirst() then
                                    Page.Run(Page::"Credit Note Card", creditnote)
                                else
                                    Message('No Credit Note found with this ID.');
                            end;
                        }
                        field("Credit Note Document"; Rec."Credit Note Document")
                        {
                            ToolTip = 'The document associated with the credit note for this billing calculation.';
                            ApplicationArea = All;
                            Editable = false;
                            Caption = 'Credit Note Document';
                            DrillDown = true;
                            trigger OnDrillDown()
                            var
                                FileURL: Text;
                            begin
                                FileURL := Rec."Credit Note Document URL";
                                if FileURL = '' then
                                    Error('No document is available to view.');
                                OpenFileInBrowser(FileURL);
                            end;
                        }
                        field("Credit Note Document URL"; Rec."Credit Note Document URL")
                        {
                            ToolTip = 'The URL of the document associated with the credit note for this billing calculation.';
                            ApplicationArea = All;
                            Caption = 'Credit Note Document URL';
                            Editable = false;
                            Visible = false;
                        }
                    }
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
                ToolTip = 'Generate an invoice based on the billing calculation details.';
                ApplicationArea = All;
                Caption = 'Generate Invoice';
                Image = NewInvoice;
                trigger OnAction()
                var
                    newsalesheader: Record "Sales Header";
                    BillingCalculationGrid: Record "Final Billing Calculation Grid";
                    customercard: Record Customer;
                    userConfirmed: Boolean;
                begin
                    if Rec."Invoice To Be Raised" > 0 then begin
                        if Rec.Invoiced = false then begin
                            userConfirmed := Confirm('Do you want to create the invoice?', false);
                            if not userConfirmed then
                                exit;
                            newsalesheader := CreateSalesHeader(Rec."Contract ID", Rec."Tenant ID", Rec."Property Classification");
                            customercard.SetRange("No.", newsalesheader."Sell-to Customer No.");
                            if customercard.FindSet() then
                                if newsalesheader."Property Classification" <> '' then begin
                                    customercard.Validate("Gen. Bus. Posting Group", newsalesheader."Property Classification");
                                    customercard.Validate("Customer Posting Group", newsalesheader."Property Classification");
                                    customercard.Modify();
                                end;
                            if newsalesheader."Property Classification" <> '' then begin
                                newsalesheader."Gen. Bus. Posting Group" := CopyStr(newsalesheader."Property Classification", 1, StrLen(newsalesheader."Gen. Bus. Posting Group"));
                                newsalesheader."Customer Posting Group" := CopyStr(newsalesheader."Property Classification", 1, StrLen(newsalesheader."Customer Posting Group"));
                                newsalesheader.Modify();
                            end;
                            BillingCalculationGrid.SetRange("Contract ID", Rec."Contract ID");
                            BillingCalculationGrid.SetFilter("DifferenceAmountInclVAT", '<%1', 0);
                            if BillingCalculationGrid.FindSet() then
                                repeat
                                    Saleslinecreate(newsalesheader, BillingCalculationGrid);
                                    BillingCalculationGrid.Invoiced := true;
                                    BillingCalculationGrid."Invoice ID" := newsalesheader."No.";
                                    BillingCalculationGrid."Posted Invoice ID" := newsalesheader."No.";
                                    BillingCalculationGrid."Invoice To Be Raised" := 0;

                                    BillingCalculationGrid.Modify();
                                until BillingCalculationGrid.Next() = 0;
                            Message('Invoice has been generated, please click on the Invoice ID to proceed further');
                        end else
                            Message('Already Invoiced is created');
                    end else
                        Message('Need to create Credit Note');
                end;
            }
            action(GenerateCreditNote)
            {
                ToolTip = 'Generate a credit note based on the billing calculation details.';
                ApplicationArea = All;
                Caption = 'Generate Credit Note';
                Image = PostDocument;
                trigger OnAction()
                begin
                    PAGE.Run(PAGE::"Credit Note List");
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

    procedure Saleslinecreate(salesheader1: Record "Sales Header"; Billingcalculation: Record "Final Billing Calculation Grid")
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
        item.SetRange(Description, Billingcalculation.RevenueDescription);
        item.SetFilter("Charges Status", '<>%1', item."Charges Status"::" ");
        if item.FindFirst() then
            saleline.Validate("No.", item."No.");
        saleline.Validate("Quantity (Base)", 1);
        saleline.Validate(Quantity, 1);
        saleline.Validate("Unit Price", Abs(Billingcalculation.DifferenceAmount));
        saleline."Contract ID" := Billingcalculation."Contract ID";
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


}
