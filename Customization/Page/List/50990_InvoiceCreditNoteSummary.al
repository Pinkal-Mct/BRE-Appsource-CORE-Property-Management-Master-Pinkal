page 73209755 "BLRInvoiceCreditNoteSummary"
{
    PageType = ListPart;
    SourceTable = BLRInvoiceCreditNoteSummary;
    ApplicationArea = All;
    Caption = 'Invoice / Credit Note Summary';
    UsageCategory = None;
    InsertAllowed = false;
    DeleteAllowed = false;


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Description; Rec.BLRDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Revenue Description';
                    ToolTip = 'Specifies the description';
                    Editable = false;
                }
                field("Revenue Description"; Rec."BLRRevenue Description")
                {
                    ApplicationArea = All;
                    Caption = 'Detailed Revenue Description';
                    ToolTip = 'Specifies the detailed revenue description';
                    Editable = false;
                }
                field(Invoice; Rec.BLRInvoice)
                {
                    ApplicationArea = All;
                    Caption = 'Invoice (Amount incl. VAT)';
                    ToolTip = 'Specifies the invoice amount.';
                    Editable = false;
                }
                field(CreditNote; Rec."BLRCredit Note")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Note (Amount incl. VAT)';
                    ToolTip = 'Specifies the credit note amount.';
                    Editable = false;
                }

            }
            field(Invoiced; Rec.BLRInvoiced)
            {
                ApplicationArea = All;
                Caption = 'Invoiced';
                ToolTip = 'Specifies the invoiced amount.';
                Editable = false;
                Visible = false;
            }

            field("Credit Noted"; Rec."BLRCredit Noted")
            {
                ApplicationArea = All;
                Caption = 'Credit Noted';
                ToolTip = 'Specifies the credited amount.';
                Editable = false;
                Visible = false;
            }
            field("Invoice ID"; Rec."BLRInvoice ID")
            {
                ApplicationArea = All;
                Caption = 'Invoice ID';
                Editable = false;
                ToolTip = 'Specifies the invoice identification number.';

                trigger OnDrillDown()
                var
                    SalesHeader: Record "Sales Header";
                    postedsalesinvoice: Record "Sales Invoice Header";
                begin
                    SalesHeader.SetRange("No.", Rec."BLRInvoice ID");
                    if SalesHeader.FindFirst() then
                        PAGE.Run(PAGE::"Sales Invoice", SalesHeader)
                    else begin
                        postedsalesinvoice.SetRange("No.", Rec."BLRInvoice ID");
                        if postedsalesinvoice.FindFirst() then
                            PAGE.Run(PAGE::"Posted Sales Invoice", postedsalesinvoice);

                    end;
                end;
            }
            field("Credit Note ID"; Rec."BLRCredit Note ID")
            {
                ApplicationArea = All;
                Caption = 'Credit Note ID';
                Editable = false;
                ToolTip = 'Specifies the credit note identification number.';

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
            field(TotalInvoice; Rec."BLRTotal Invoice")
            {
                ApplicationArea = All;
                Caption = 'Total Invoice';
                ToolTip = 'Specifies the total invoice amount.';
                Editable = false;
            }
            field(TotalCreditNote; Rec."BLRTotal Credit Note")
            {
                ApplicationArea = All;
                Caption = 'Total Credit Note';
                ToolTip = 'Specifies the total credit note amount.';
                Editable = false;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(GenerateInvoice)
            {
                ApplicationArea = All;
                Caption = 'Generate Invoice';
                ToolTip = 'Generate the invoice';
                Image = Invoice;
                trigger OnAction()
                var
                    GenerateInvoicesCreditNotesFinalCalculation: Codeunit "BLRGenerateInvoiceCreditNoteFC";
                begin
                    GenerateInvoicesCreditNotesFinalCalculation.GenerateBillingInvoice(Rec);
                    // GenerateInvoicesCreditNotesFinalCalculation.GenerateAdditionalChargesInvoice(Rec);
                end;
            }
            action(GenerateCreditNote)
            {
                ApplicationArea = All;
                Caption = 'Generate Credit Note';
                ToolTip = 'Generate the credit note';
                Image = CreditMemo;
                trigger OnAction()
                var
                    GenerateInvoicesCreditNotesFinalCalculation: Codeunit "BLRGenerateInvoiceCreditNoteFC";
                    CustLedgerEntry: Record "Cust. Ledger Entry";
                begin
                    // GenerateInvoicesCreditNotesFinalCalculation.GenerateBillingCreditNote(Rec);
                    GenerateInvoicesCreditNotesFinalCalculation.GenerateFinalAdjtContractReductionCreditNote(Rec);

                end;
            }
            action(ApplyEntries)
            {
                ApplicationArea = All;
                Caption = 'Apply Entries';
                ToolTip = 'Apply Entries';
                Image = ApplyEntries;
                trigger OnAction()
                var
                    CustLedgerEntry: Record "Cust. Ledger Entry";
                begin
                    CustLedgerEntry.SetRange("BLRContract ID", Rec."BLRContract No.");
                    PAGE.RUN(PAGE::"Customer Ledger Entries", CustLedgerEntry);
                end;
            }
        }
    }


    procedure SetContractNo(pContractNo: Integer)
    begin
        ContractNo := pContractNo;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."BLRContract No." := ContractNo;
    end;

    var
        ContractNo: Integer;
}