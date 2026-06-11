page 73209691 "BLRFinalBillingCalculation"
{
    PageType = ListPart;
    ApplicationArea = All;
    Caption = 'Final Billing Calculation Grid';
    SourceTable = "BLRFinalBillingCalculationGrid";
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(RevenueDescription; Rec.BLRRevenueDescription)
                {
                    Caption = 'Revenue Description';
                    ApplicationArea = All;
                    ToolTip = 'The description of the revenue item.';
                    Editable = false;
                }
                field("Contract ID"; Rec."BLRContract ID")
                {
                    Caption = 'Contract ID';
                    ApplicationArea = All;
                    ToolTip = 'The unique identifier for the contract associated with this billing calculation.';
                    Editable = false;
                    Visible = false;
                }
                field("Entry No"; Rec."BLREntry No")
                {
                    Caption = 'Entry No.';
                    ApplicationArea = All;
                    ToolTip = 'The unique entry number for this billing calculation.';
                    Editable = false;
                    Visible = false;
                }
                field(InvoicedAmount; Rec."BLRInvoicedAmount")
                {
                    Caption = 'Invoiced Amount';
                    ToolTip = 'The total amount that has been invoiced for this billing calculation.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(InvoicedVAT; Rec."BLRInvoicedVAT")
                {
                    ToolTip = 'The total VAT amount that has been invoiced for this billing calculation.';
                    Caption = 'Invoiced VAT';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(InvoicedAmountInclVAT; Rec."BLRInvoicedAmountInclVAT")
                {
                    ToolTip = 'The total amount including VAT that has been invoiced for this billing calculation.';
                    Caption = 'Invoiced Amount Incl. VAT';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(RevisedAmount; Rec."BLRRevisedAmount")
                {
                    ToolTip = 'The revised amount for this billing calculation, which may differ from the invoiced amount.';
                    Caption = 'Revised Amount';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(RevisedVAT; Rec."BLRRevisedVAT")
                {
                    ToolTip = 'The revised VAT amount for this billing calculation, which may differ from the invoiced VAT.';
                    Caption = 'Revised VAT';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(RevisedAmountInclVAT; Rec."BLRRevisedAmountInclVAT")
                {
                    ToolTip = 'The revised amount including VAT for this billing calculation, which may differ from the invoiced amount including VAT.';
                    Caption = 'Revised Amount Incl. VAT';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(DifferenceAmount; Rec."BLRDifferenceAmount")
                {
                    ToolTip = 'The difference amount calculated as the difference between the invoiced amount and the revised amount.';
                    Caption = 'Difference Amount';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(DifferenceVAT; Rec."BLRDifferenceVAT")
                {
                    ToolTip = 'The difference VAT calculated as the difference between the invoiced VAT and the revised VAT.';
                    Caption = 'Difference VAT';
                    ApplicationArea = All;
                    Editable = false;
                }
                field(DifferenceAmountInclVAT; Rec."BLRDifferenceAmountInclVAT")
                {
                    ToolTip = 'The difference amount including VAT calculated as the difference between the invoiced amount including VAT and the revised amount including VAT.';
                    Caption = 'Difference Amount Incl. VAT';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Termination Date"; Rec."BLRTermination Date")
                {
                    ToolTip = 'The termination date of the contract associated with this billing calculation.';
                    Caption = 'Termination Date';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("BLRPaymentType"; Rec."BLRPayment Type")
                {
                    ToolTip = 'The type of payment associated with this billing calculation, such as "Rent" or "Service Charge".';
                    ApplicationArea = All;
                    Caption = 'Payment Type';
                    Editable = false;
                    Visible = false;
                }
                field("Property Classification"; Rec."BLRProperty Classification")
                {
                    ToolTip = 'The classification of the property associated with this billing calculation, such as "Residential" or "Commercial".';
                    ApplicationArea = All;
                    Caption = 'Property Classification';
                    Editable = false;
                    Visible = false;
                }
                field("Invoiced"; Rec."BLRInvoiced")
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
                        field("Total Invoiced Amount"; Rec."BLRTotal Invoiced Amount")
                        {
                            ApplicationArea = All;
                            ToolTip = 'The total amount that has been invoiced for this billing calculation.';
                            Editable = false;
                            Caption = 'Total Invoiced Amount';
                        }
                        field("Total Invoiced VAT"; Rec."BLRTotal Invoiced VAT")
                        {
                            ToolTip = 'The total VAT amount that has been invoiced for this billing calculation.';
                            ApplicationArea = All;
                            Editable = false;
                            Caption = 'Total Invoiced VAT';
                        }
                        field("Total Invoiced AmountIncl. VAT"; Rec."BLRTotalInvdAmtInclVAT")
                        {
                            ToolTip = 'The total amount including VAT that has been invoiced for this billing calculation.';
                            ApplicationArea = All;
                            Editable = false;
                            Caption = 'Total Invoiced Amount Incl. VAT';
                        }
                    }
                    group("Revised Values")
                    {
                        field("Total Revised Amount"; Rec."BLRTotal Revised Amount")
                        {
                            ToolTip = 'The total revised amount for this billing calculation, which may differ from the invoiced amount.';
                            ApplicationArea = All;
                            Caption = 'Total Revised Amount';
                            Editable = false;
                        }
                        field("Total Revised VAT"; Rec."BLRTotal Revised VAT")
                        {
                            ToolTip = 'The total revised VAT amount for this billing calculation, which may differ from the invoiced VAT.';
                            ApplicationArea = All;
                            Caption = 'Total Revised VAT';
                            Editable = false;
                        }
                        field("Total Revised AmountIncl.VAT"; Rec."BLRTotalRevAmtInclVAT")
                        {
                            ToolTip = 'The total revised amount including VAT for this billing calculation, which may differ from the invoiced amount including VAT.';
                            ApplicationArea = All;
                            Caption = 'Total Revised Amount Incl. VAT';
                            Editable = false;
                        }
                    }
                    group("Summary")
                    {
                        field("Invoice To Be Raised"; Rec."BLRInvoice To Be Raised")
                        {
                            ToolTip = 'The total amount to be raised as an invoice for this billing calculation.';
                            ApplicationArea = All;
                            Caption = 'Invoice To Be Raised';
                            Editable = false;
                        }
                        field("Credit Note To Be Raised"; Rec."BLRCredit Note To Be Raised")
                        {
                            ToolTip = 'The total amount to be raised as a credit note for this billing calculation.';
                            ApplicationArea = All;
                            Caption = 'Credit Note To Be Raised';
                            Editable = false;
                        }
                        field("Creditnote"; Rec."BLRCreditnote")
                        {
                            ToolTip = 'Indicates whether a credit note is applicable for this billing calculation.';
                            ApplicationArea = All;
                            Caption = 'Creditnote';
                            Editable = false;
                            Visible = false;
                        }
                        field("Total Differnece Amount"; Rec."BLRTotal Differnece Amount")
                        {
                            ApplicationArea = All;
                            ToolTip = 'The total difference amount calculated for this billing calculation.';
                            Caption = 'Total Differnece Amount';
                            Editable = false;
                            Visible = false;
                        }
                        field("Total Difference VAT"; Rec."BLRTotal Difference VAT")
                        {
                            ApplicationArea = All;
                            ToolTip = 'The total difference VAT calculated for this billing calculation.';
                            Caption = 'Total Difference VAT';
                            Editable = false;
                            Visible = false;
                        }
                        field("Total DifferenceAmountIncl.VAT"; Rec."BLRTotalDiffAmtInclVAT")
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
                        field("Invoice Amount"; Rec."BLRInvoice Amount")
                        {
                            ToolTip = 'The total amount to be invoiced for this billing calculation.';
                            ApplicationArea = All;
                            Caption = 'Invoice Amount';
                            Editable = false;
                        }
                        field("Posted Invoice ID"; Rec."BLRPosted Invoice ID")
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
                                SalesHeader.SetRange("No.", Rec."BLRPosted Invoice ID");
                                if SalesHeader.FindFirst() then
                                    PAGE.Run(PAGE::"Sales Invoice", SalesHeader)
                                else begin
                                    postedsalesinvoice.SetRange("No.", Rec."BLRPosted Invoice ID");
                                    if postedsalesinvoice.FindFirst() then
                                        PAGE.Run(PAGE::"Posted Sales Invoice", postedsalesinvoice);
                                end;
                            end;
                        }
                        field("Invoice Document"; Rec."BLRInvoice Document")
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
                                FileURL := Rec."BLRInvoice Document URL";
                                if FileURL = '' then
                                    Error('No document is available to view.');
                                OpenFileInBrowser(FileURL);
                            end;
                        }
                        field("Invoice Document URL"; Rec."BLRInvoice Document URL")
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
                        field("Credit Note Amount"; Rec."BLRCredit Note Amount")
                        {
                            ToolTip = 'The total amount to be credited for this billing calculation.';
                            ApplicationArea = All;
                            Caption = 'Credit Note Amount';
                            Editable = false;
                        }
                        field("Credit Note ID"; Rec."BLRCredit Note ID")
                        {
                            ToolTip = 'The unique identifier for the credit note associated with this billing calculation.';
                            ApplicationArea = All;
                            Caption = 'Credit Note ID';
                            Editable = false;
                            DrillDown = true;
                            trigger OnDrillDown()
                            var
                                SalesHeader: Record "Sales Header";

                                PostedSalesCreditMemo: Record "Sales Cr.Memo Header";
                            begin
                                SalesHeader.SetRange("No.", Rec."BLRCredit Note ID");
                                if SalesHeader.FindFirst() then
                                    PAGE.Run(PAGE::"Sales Credit Memo", SalesHeader)
                                else begin
                                    PostedSalesCreditMemo.SetRange("No.", Rec."BLRCredit Note ID");
                                    if PostedSalesCreditMemo.FindFirst() then
                                        PAGE.Run(PAGE::"Posted Sales Credit Memo", PostedSalesCreditMemo);

                                end;
                            end;
                        }
                        field("Credit Note Document"; Rec."BLRCredit Note Document")
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
                                FileURL := Rec."BLRCredit Note Document URL";
                                if FileURL = '' then
                                    Error('No document is available to view.');
                                OpenFileInBrowser(FileURL);
                            end;
                        }
                        field("Credit Note Document URL"; Rec."BLRCredit Note Document URL")
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


    procedure OpenFileInBrowser(URL: Text)
    begin
        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;


}
