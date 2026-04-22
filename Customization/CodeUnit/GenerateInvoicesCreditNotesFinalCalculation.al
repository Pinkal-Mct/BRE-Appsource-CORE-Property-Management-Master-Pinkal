codeunit 73209628 GenerateInvoiceCreditNoteFC
{
    procedure GenerateBillingInvoice(var pInvoiceCreditNoteSummaryRec: Record InvoiceCreditNoteSummary)
    var
        BillingCalcGrid: Record "Final Billing Calculation Grid";
        InvoiceCreditNoteSummaryRec: Record InvoiceCreditNoteSummary;
        InvoiceCreditNoteSummaryRec1: Record InvoiceCreditNoteSummary;
        newsalesheader: Record "Sales Header";
        customercard: Record Customer;
        TerminatonAdditionalCharges: Record "Additional Charges Sub";
    begin
        InvoiceCreditNoteSummaryRec.SetRange("Contract No.", pInvoiceCreditNoteSummaryRec."Contract No.");
        InvoiceCreditNoteSummaryRec.SetRange(Invoiced, false);
        if InvoiceCreditNoteSummaryRec.FindFirst() then begin
            InvoiceCreditNoteSummaryRec.CalcFields("Total Invoice");
            if InvoiceCreditNoteSummaryRec."Total Invoice" > 0 then begin

                BillingCalcGrid.SetRange("Contract ID", InvoiceCreditNoteSummaryRec."Contract No.");
                if BillingCalcGrid.FindFirst() then begin
                    newsalesheader := CreateSalesHeader(BillingCalcGrid."Contract ID", BillingCalcGrid."Tenant ID", BillingCalcGrid."Property Classification");
                    customercard.SetRange("No.", newsalesheader."Sell-to Customer No.");
                    if customercard.FindSet() then
                        if newsalesheader."Property Classification" <> '' then begin
                            customercard.Validate("Gen. Bus. Posting Group", newsalesheader."Property Classification");
                            customercard.Validate("Customer Posting Group", newsalesheader."Property Classification");
                            customercard.Modify();
                        end;
                    if newsalesheader."Property Classification" <> '' then begin
                        newsalesheader.Validate("Gen. Bus. Posting Group", newsalesheader."Property Classification");
                        newsalesheader.Validate("Customer Posting Group", newsalesheader."Property Classification");
                        newsalesheader.Modify();
                    end;
                end;

                BillingCalcGrid.SetRange("Contract ID", pInvoiceCreditNoteSummaryRec."Contract No.");
                BillingCalcGrid.SetFilter("DifferenceAmountInclVAT", '<%1', 0);
                if BillingCalcGrid.FindSet() then
                    repeat
                        Saleslinecreate(newsalesheader, BillingCalcGrid);
                        BillingCalcGrid."Invoice ID" := newsalesheader."No.";
                        BillingCalcGrid."Posted Invoice ID" := newsalesheader."No.";
                        BillingCalcGrid.Modify();
                    until BillingCalcGrid.Next() = 0;

                TerminatonAdditionalCharges.SetRange("Contract ID", pInvoiceCreditNoteSummaryRec."Contract No.");
                TerminatonAdditionalCharges.SetFilter(Amount, '<>%1', 0);
                if TerminatonAdditionalCharges.FindSet() then
                    repeat
                        AdditionalchargesSaleslinecreate(newsalesheader, TerminatonAdditionalCharges);
                        TerminatonAdditionalCharges."Invoiced ID" := newsalesheader."No.";
                        TerminatonAdditionalCharges."Posted Invoice ID" := newsalesheader."No.";
                        TerminatonAdditionalCharges.Modify();
                    until TerminatonAdditionalCharges.Next() = 0;

                InvoiceCreditNoteSummaryRec1.SetRange("Contract No.", pInvoiceCreditNoteSummaryRec."Contract No.");
                if InvoiceCreditNoteSummaryRec1.FindSet() then
                    repeat
                        InvoiceCreditNoteSummaryRec1."Invoice ID" := NewSalesHeader."No.";
                        InvoiceCreditNoteSummaryRec1.Invoiced := true;
                        InvoiceCreditNoteSummaryRec1.Modify();
                    until InvoiceCreditNoteSummaryRec1.Next() = 0;
                Message('Invoice has been generated, please click on the Invoice ID to proceed further');
            end
        end;

    end;

    procedure CreateSalesHeader(pContractID: Integer; pTenantID: Code[50]; PropertyClassification: Text[50]): Record "Sales Header"
    var
        salesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Header";
        salesReciveable: Record "Sales & Receivables Setup";
        noseries: Codeunit "No. Series";

    begin
        salesHeader.Init();
        if not salesReciveable.IsEmpty() then
            salesHeader."No." := noseries.GetNextNo(salesReciveable."Invoice Nos.", Today, true);
        salesHeader."Document Type" := SalesInvoiceHeader."Document Type"::Invoice;
        salesHeader.Validate("Sell-to Customer No.", pTenantID);
        salesHeader."Document Date" := Today;
        salesHeader.Validate("Contract ID", pcontractid);
        //   salesHeader."Document Date" := Today;
        salesHeader."Posting Date" := Today;
        salesHeader."Due Date" := Today;
        salesHeader."Property Classification" := PropertyClassification;
        salesHeader."Posting No. Series" := salesReciveable."Posted Invoice Nos.";
        salesHeader.Insert();
        exit(salesHeader);
    end;


    procedure Saleslinecreate(salesheader1: Record "Sales Header"; Billingcalculation: Record "Final Billing Calculation Grid")
    var
        saleline: Record "Sales Line";
        newSaleslines: Record "Sales Line";
        item: Record Item;
        RoundDecimal: Decimal;
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
        if not item.IsEmpty() then
            saleline.Validate("No.", item."No.");

        saleline.Validate("Quantity (Base)", 1);
        saleline.Validate(Quantity, 1);
        RoundDecimal := Abs(Round(Billingcalculation.DifferenceAmount, 0.01));
        saleline.Validate("Unit Price", RoundDecimal);
        saleline."Contract ID" := Billingcalculation."Contract ID";
        saleline.Insert();
        Clear(saleline);

    end;

    procedure AdditionalchargesSaleslinecreate(salesheader1: Record "Sales Header"; TerminationchargesGrid: Record "Additional Charges Sub")
    var
        saleline: Record "Sales Line";
        newSaleslines: Record "Sales Line";
        item: Record Item;
        RoundDecimal: Decimal;
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
        item.SetRange(Description, TerminationchargesGrid."Secondary Item Type");
        item.SetFilter("Charges Status", '<>%1', item."Charges Status"::" ");
        if not item.IsEmpty() then
            saleline.Validate("No.", item."No.");

        saleline.Validate("Quantity (Base)", 1);
        saleline.Validate(Quantity, 1);
        RoundDecimal := Abs(Round(TerminationchargesGrid.Amount, 0.01));
        saleline.Validate("Unit Price", RoundDecimal);
        saleline."Contract ID" := TerminationchargesGrid."Contract ID";
        saleline.Insert();
        Clear(saleline);

    end;

    procedure GenerateFinalAdjtContractReductionCreditNote(var pInvoiceCreditNoteSummaryRec: Record InvoiceCreditNoteSummary)
    var

        InvoiceCreditNoteSummaryRec: Record InvoiceCreditNoteSummary;
        InvoiceCreditNoteSummaryRec1: Record InvoiceCreditNoteSummary;

        CustomerRec: Record Customer;

        finalAdjContractRec: Record FinancialAdjContractReduction;
        BillingCalcGrid: Record "Final Billing Calculation Grid";
        BillingCalcGridRec: Record "Final Billing Calculation Grid";
        NewSalesHeader: Record "Sales Header";

    begin
        InvoiceCreditNoteSummaryRec.SetRange("Contract No.", pInvoiceCreditNoteSummaryRec."Contract No.");
        InvoiceCreditNoteSummaryRec.SetRange("Credit Noted", false);
        if InvoiceCreditNoteSummaryRec.FindFirst() then
            InvoiceCreditNoteSummaryRec.CalcFields("Total Credit Note");
        if InvoiceCreditNoteSummaryRec."Total Credit Note" > 0 then begin
            BillingCalcGrid.SetRange("Contract ID", InvoiceCreditNoteSummaryRec."Contract No.");
            if BillingCalcGrid.FindFirst() then begin
                NewSalesHeader := CreateCreditMemoSalesHeader(BillingCalcGrid."Contract ID", BillingCalcGrid."Tenant ID", BillingCalcGrid."Property Classification");

                CustomerRec.SetRange("No.", NewSalesHeader."Sell-to Customer No.");
                if CustomerRec.FindSet() then
                    if NewSalesHeader."Property Classification" <> '' then begin
                        CustomerRec.Validate("Gen. Bus. Posting Group", NewSalesHeader."Property Classification");
                        CustomerRec.Validate("Customer Posting Group", NewSalesHeader."Property Classification");
                        CustomerRec.Modify();
                    end;

                if NewSalesHeader."Property Classification" <> '' then begin

                    NewSalesHeader.Validate("Gen. Bus. Posting Group", NewSalesHeader."Property Classification");
                    NewSalesHeader.Validate("Customer Posting Group", NewSalesHeader."Property Classification");
                    NewSalesHeader.Modify();
                end;

            end;

            BillingCalcGridRec.SetRange("Contract ID", pInvoiceCreditNoteSummaryRec."Contract No.");
            BillingCalcGridRec.SetFilter("DifferenceAmountInclVAT", '>%1', 0);
            if BillingCalcGridRec.FindSet() then
                repeat
                    CrditMemoSaleslinecreate(NewSalesHeader, BillingCalcGridRec);
                    BillingCalcGridRec.Modify();
                until BillingCalcGridRec.Next() = 0;

            if BillingCalcGridRec.Count() > 0 then begin
                BillingCalcGridRec.Reset();
                BillingCalcGridRec.SetRange("Contract ID", pInvoiceCreditNoteSummaryRec."Contract No.");
                if BillingCalcGridRec.FindSet() then
                    repeat
                        BillingCalcGridRec."Credit Note ID" := NewSalesHeader."No.";
                        BillingCalcGridRec.Modify();
                    until BillingCalcGridRec.Next() = 0;

            end;

            finalAdjContractRec.SetRange("Contract No.", pInvoiceCreditNoteSummaryRec."Contract No.");
            finalAdjContractRec.SetFilter(Amount, '<>%1', 0);
            if finalAdjContractRec.FindSet() then
                repeat
                    CrditMemoSaleslinecreate1(NewSalesHeader, finalAdjContractRec);
                    finalAdjContractRec."Credit Note ID" := NewSalesHeader."No.";
                    finalAdjContractRec.Modify();
                until finalAdjContractRec.Next() = 0;

            Message('Sales Credit Memo created');

            InvoiceCreditNoteSummaryRec1.SetRange("Contract No.", pInvoiceCreditNoteSummaryRec."Contract No.");
            if InvoiceCreditNoteSummaryRec1.FindSet() then
                repeat
                    InvoiceCreditNoteSummaryRec1."Credit Note ID" := NewSalesHeader."No.";
                    InvoiceCreditNoteSummaryRec1."Credit Noted" := true;
                    InvoiceCreditNoteSummaryRec1.Modify();
                until InvoiceCreditNoteSummaryRec1.Next() = 0;
            // SalesPost.Run(NewSalesHeader);
        end;

    end;

    procedure CreateCreditMemoSalesHeader(pContractID: Integer; pTenantID: Code[50]; pUnitType: Text[50]): Record "Sales Header";
    var
        SalesHeader: Record "Sales Header";
        salesReciveable: Record "Sales & Receivables Setup";
        noseries: Codeunit "No. Series";
    begin
        salesHeader.Init();
        if not salesReciveable.IsEmpty() then
            salesHeader."No." := noseries.GetNextNo(salesReciveable."Credit Memo Nos.", Today, true);
        salesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";

        salesHeader.Validate("Sell-to Customer No.", pTenantID);
        salesHeader."Document Date" := Today;
        salesHeader.Validate("Contract ID", pcontractid);
        //   salesHeader."Document Date" := Today;
        salesHeader."Posting Date" := Today;
        salesHeader."Due Date" := Today;
        salesHeader."Property Classification" := pUnitType;
        SalesHeader."Posting No. Series" := salesReciveable."Posted Credit Memo Nos.";
        // SalesHeader."Approval Status for CreditNote" := SalesHeader."Approval Status for CreditNote"::Approved;
        SalesHeader."Terminated Credit Note" := true;
        salesHeader.Insert();
        exit(salesHeader);
    end;

    procedure CrditMemoSaleslinecreate(salesheader1: Record "Sales Header"; BillingCalcSub: Record "Final Billing Calculation Grid");
    var
        saleline: Record "Sales Line";
        newSaleslines: Record "Sales Line";
        item: Record Item;
        RoundAmount: Decimal;
    begin

        saleline.Init();
        saleline."Document Type" := saleline."Document Type"::"Credit Memo";

        newSaleslines.SetRange("Document No.", salesheader1."No.");
        newSaleslines.SetRange("Document Type", Enum::"Sales Document Type"::"Credit Memo");
        //newSaleslines.SetRange("Contract ID", salesheader1."Contract ID");
        newSaleslines.SetCurrentKey("Line No.");
        if newSaleslines.FindLast() then
            saleline."Line No." := newSaleslines."Line No." + 1000
        else
            saleline."Line No." := 1000;

        saleline."Document No." := salesheader1."No.";
        // saleline."Contract ID" := salesheader1."Contract ID";
        saleline.Type := saleline.Type::Item;
        saleline."Sell-to Customer No." := salesheader1."Sell-to Customer No.";
        item.SetRange(Description, BillingCalcSub.RevenueDescription);
        item.SetFilter("Charges Status", '<>%1', item."Charges Status"::" ");
        if not item.IsEmpty() then
            saleline.Validate("No.", item."No.");
        saleline.Validate("Quantity (Base)", 1);
        saleline.Validate(Quantity, 1);
        RoundAmount := Abs(Round(BillingCalcSub.DifferenceAmount, 0.01));
        saleline.Validate("Unit Price", RoundAmount);
        saleline."Contract ID" := BillingCalcSub."Contract ID";
        saleline."FC ID" := salesheader1."FC ID";
        saleline.Insert();
    end;

    procedure CrditMemoSaleslinecreate1(salesheader1: Record "Sales Header"; financialAdjustReductionRec: Record FinancialAdjContractReduction);
    var
        saleline: Record "Sales Line";
        newSaleslines: Record "Sales Line";
        item: Record Item;

        RoundAmount: Decimal;
    begin

        saleline.Init();
        saleline."Document Type" := saleline."Document Type"::"Credit Memo";

        newSaleslines.SetRange("Document No.", salesheader1."No.");
        newSaleslines.SetRange("Document Type", Enum::"Sales Document Type"::"Credit Memo");
        //newSaleslines.SetRange("Contract ID", salesheader1."Contract ID");
        newSaleslines.SetCurrentKey("Line No.");
        if newSaleslines.FindLast() then
            saleline."Line No." := newSaleslines."Line No." + 1000

        else
            saleline."Line No." := 1000;
        saleline."Document No." := salesheader1."No.";
        saleline.Type := saleline.Type::Item;
        saleline."Sell-to Customer No." := salesheader1."Sell-to Customer No.";
        item.SetRange(Description, financialAdjustReductionRec."Revenue Description");
        item.SetFilter("Charges Status", '<>%1', item."Charges Status"::" ");
        if not item.IsEmpty() then
            saleline.Validate("No.", item."No.");

        saleline.Validate("Quantity (Base)", 1);
        saleline.Validate(Quantity, 1);
        RoundAmount := Abs(Round(financialAdjustReductionRec.Amount, 0.01));
        saleline.Validate("Unit Price", RoundAmount);
        saleline."Contract ID" := financialAdjustReductionRec."Contract No.";
        saleline."FC ID" := salesheader1."FC ID";
        saleline.Insert();
    end;

}