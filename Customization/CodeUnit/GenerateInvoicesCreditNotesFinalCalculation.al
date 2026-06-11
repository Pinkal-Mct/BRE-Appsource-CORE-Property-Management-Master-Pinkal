codeunit 73209628 BLRGenerateInvoiceCreditNoteFC
{
    procedure GenerateBillingInvoice(var pInvoiceCreditNoteSummaryRec: Record BLRInvoiceCreditNoteSummary)
    var
        BillingCalcGrid: Record "BLRFinalBillingCalculationGrid";
        InvoiceCreditNoteSummaryRec: Record BLRInvoiceCreditNoteSummary;
        InvoiceCreditNoteSummaryRec1: Record BLRInvoiceCreditNoteSummary;
        newsalesheader: Record "Sales Header";
        customercard: Record Customer;
        TerminatonAdditionalCharges: Record "BLRAdditionalChargesSub";
    begin
        InvoiceCreditNoteSummaryRec.SetRange("BLRContract No.", pInvoiceCreditNoteSummaryRec."BLRContract No.");
        InvoiceCreditNoteSummaryRec.SetRange("BLRInvoiced", false);
        if InvoiceCreditNoteSummaryRec.FindFirst() then begin
            InvoiceCreditNoteSummaryRec.CalcFields("BLRTotal Invoice");
            if InvoiceCreditNoteSummaryRec."BLRTotal Invoice" > 0 then begin

                BillingCalcGrid.SetRange("BLRContract ID", InvoiceCreditNoteSummaryRec."BLRContract No.");
                if BillingCalcGrid.FindFirst() then begin
                    newsalesheader := CreateSalesHeader(BillingCalcGrid."BLRContract ID", BillingCalcGrid."BLRTenant ID", BillingCalcGrid."BLRProperty Classification");
                    customercard.SetRange("No.", newsalesheader."Sell-to Customer No.");
                    if customercard.FindSet() then
                        if newsalesheader."BLRProperty Classification" <> '' then begin
                            customercard.Validate("Gen. Bus. Posting Group", newsalesheader."BLRProperty Classification");
                            customercard.Validate("Customer Posting Group", newsalesheader."BLRProperty Classification");
                            customercard.Modify();
                        end;
                    if newsalesheader."BLRProperty Classification" <> '' then begin
                        newsalesheader.Validate("Gen. Bus. Posting Group", newsalesheader."BLRProperty Classification");
                        newsalesheader.Validate("Customer Posting Group", newsalesheader."BLRProperty Classification");
                        newsalesheader.Modify();
                    end;
                end;

                BillingCalcGrid.SetRange("BLRContract ID", pInvoiceCreditNoteSummaryRec."BLRContract No.");
                BillingCalcGrid.SetFilter("BLRDifferenceAmountInclVAT", '<%1', 0);
                if BillingCalcGrid.FindSet() then
                    repeat
                        Saleslinecreate(newsalesheader, BillingCalcGrid);
                        BillingCalcGrid."BLRInvoice ID" := newsalesheader."No.";
                        BillingCalcGrid."BLRPosted Invoice ID" := newsalesheader."No.";
                        BillingCalcGrid.Modify();
                    until BillingCalcGrid.Next() = 0;

                TerminatonAdditionalCharges.SetRange("BLRContract ID", pInvoiceCreditNoteSummaryRec."BLRContract No.");
                TerminatonAdditionalCharges.SetFilter("BLRAmount", '<>%1', 0);
                if TerminatonAdditionalCharges.FindSet() then
                    repeat
                        AdditionalchargesSaleslinecreate(newsalesheader, TerminatonAdditionalCharges);
                        TerminatonAdditionalCharges."BLRInvoiced ID" := newsalesheader."No.";
                        TerminatonAdditionalCharges."BLRPosted Invoice ID" := newsalesheader."No.";
                        TerminatonAdditionalCharges.Modify();
                    until TerminatonAdditionalCharges.Next() = 0;

                InvoiceCreditNoteSummaryRec1.SetRange("BLRContract No.", pInvoiceCreditNoteSummaryRec."BLRContract No.");
                if InvoiceCreditNoteSummaryRec1.FindSet() then
                    repeat
                        InvoiceCreditNoteSummaryRec1."BLRInvoice ID" := NewSalesHeader."No.";
                        InvoiceCreditNoteSummaryRec1.BLRInvoiced := true;
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
        SalesReceivables: Record "Sales & Receivables Setup";
        noseries: Codeunit "No. Series";

    begin
        salesHeader.Init();
        if SalesReceivables.Get() then
            salesHeader."No." := noseries.GetNextNo(SalesReceivables."Invoice Nos.", Today, true);
        salesHeader."Document Type" := SalesInvoiceHeader."Document Type"::Invoice;
        salesHeader.Validate("Sell-to Customer No.", pTenantID);
        salesHeader."Document Date" := Today;
        salesHeader.Validate("BLRContract ID", pcontractid);
        //   salesHeader."Document Date" := Today;
        salesHeader."Posting Date" := Today;
        salesHeader."Due Date" := Today;
        salesHeader."BLRProperty Classification" := PropertyClassification;
        salesHeader."Posting No. Series" := SalesReceivables."Posted Invoice Nos.";
        salesHeader.Insert();
        exit(salesHeader);
    end;


    procedure Saleslinecreate(salesheader1: Record "Sales Header"; Billingcalculation: Record "BLRFinalBillingCalculationGrid")
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
        saleline."BLRContract ID" := salesheader1."BLRContract ID";
        saleline.Type := saleline.Type::Item;
        saleline."Sell-to Customer No." := salesheader1."Sell-to Customer No.";
        item.SetRange(Description, Billingcalculation.BLRRevenueDescription);
        item.SetFilter("BLRCharges Status", '<>%1', item."BLRCharges Status"::" ");
        if item.FindFirst() then
            saleline.Validate("No.", item."No.");

        saleline.Validate("Quantity (Base)", 1);
        saleline.Validate(Quantity, 1);
        RoundDecimal := Abs(Round(Billingcalculation.BLRDifferenceAmount, 0.01));
        saleline.Validate("Unit Price", RoundDecimal);
        saleline."BLRContract ID" := Billingcalculation."BLRContract ID";
        saleline.Insert();
        Clear(saleline);

    end;

    procedure AdditionalchargesSaleslinecreate(salesheader1: Record "Sales Header"; TerminationchargesGrid: Record "BLRAdditionalChargesSub")
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
        saleline."BLRContract ID" := salesheader1."BLRContract ID";
        saleline.Type := saleline.Type::Item;
        saleline."Sell-to Customer No." := salesheader1."Sell-to Customer No.";
        item.SetRange(Description, TerminationchargesGrid."BLRSecondary Item Type");
        item.SetFilter("BLRCharges Status", '<>%1', item."BLRCharges Status"::" ");
        if item.FindFirst() then
            saleline.Validate("No.", item."No.");

        saleline.Validate("Quantity (Base)", 1);
        saleline.Validate(Quantity, 1);
        RoundDecimal := Abs(Round(TerminationchargesGrid."BLRAmount", 0.01));
        saleline.Validate("Unit Price", RoundDecimal);
        saleline."BLRContract ID" := TerminationchargesGrid."BLRContract ID";
        saleline.Insert();
        Clear(saleline);

    end;

    procedure GenerateFinalAdjtContractReductionCreditNote(var pInvoiceCreditNoteSummaryRec: Record BLRInvoiceCreditNoteSummary)
    var

        InvoiceCreditNoteSummaryRec: Record BLRInvoiceCreditNoteSummary;
        InvoiceCreditNoteSummaryRec1: Record BLRInvoiceCreditNoteSummary;

        CustomerRec: Record Customer;

        finalAdjContractRec: Record BLRFinAdjContractReduction;
        BillingCalcGrid: Record "BLRFinalBillingCalculationGrid";
        BillingCalcGridRec: Record "BLRFinalBillingCalculationGrid";
        NewSalesHeader: Record "Sales Header";

    begin
        InvoiceCreditNoteSummaryRec.SetRange("BLRContract No.", pInvoiceCreditNoteSummaryRec."BLRContract No.");
        InvoiceCreditNoteSummaryRec.SetRange("BLRCredit Noted", false);
        if InvoiceCreditNoteSummaryRec.FindFirst() then
            InvoiceCreditNoteSummaryRec.CalcFields("BLRTotal Credit Note");
        if InvoiceCreditNoteSummaryRec."BLRTotal Credit Note" > 0 then begin
            BillingCalcGrid.SetRange("BLRContract ID", InvoiceCreditNoteSummaryRec."BLRContract No.");
            if BillingCalcGrid.FindFirst() then begin
                NewSalesHeader := CreateCreditMemoSalesHeader(BillingCalcGrid."BLRContract ID", BillingCalcGrid."BLRTenant ID", BillingCalcGrid."BLRProperty Classification");

                CustomerRec.SetRange("No.", NewSalesHeader."Sell-to Customer No.");
                if CustomerRec.FindSet() then
                    if NewSalesHeader."BLRProperty Classification" <> '' then begin
                        CustomerRec.Validate("Gen. Bus. Posting Group", NewSalesHeader."BLRProperty Classification");
                        CustomerRec.Validate("Customer Posting Group", NewSalesHeader."BLRProperty Classification");
                        CustomerRec.Modify();
                    end;

                if NewSalesHeader."BLRProperty Classification" <> '' then begin

                    NewSalesHeader.Validate("Gen. Bus. Posting Group", NewSalesHeader."BLRProperty Classification");
                    NewSalesHeader.Validate("Customer Posting Group", NewSalesHeader."BLRProperty Classification");
                    NewSalesHeader.Modify();
                end;

            end;

            BillingCalcGridRec.SetRange("BLRContract ID", pInvoiceCreditNoteSummaryRec."BLRContract No.");
            BillingCalcGridRec.SetFilter("BLRDifferenceAmountInclVAT", '>%1', 0);
            if BillingCalcGridRec.FindSet() then
                repeat
                    CrditMemoSaleslinecreate(NewSalesHeader, BillingCalcGridRec);
                    BillingCalcGridRec.Modify();
                until BillingCalcGridRec.Next() = 0;

            if BillingCalcGridRec.Count() > 0 then begin
                BillingCalcGridRec.Reset();
                BillingCalcGridRec.SetRange("BLRContract ID", pInvoiceCreditNoteSummaryRec."BLRContract No.");
                if BillingCalcGridRec.FindSet() then
                    repeat
                        BillingCalcGridRec."BLRCredit Note ID" := NewSalesHeader."No.";
                        BillingCalcGridRec.Modify();
                    until BillingCalcGridRec.Next() = 0;

            end;

            finalAdjContractRec.SetRange("BLRContract No.", pInvoiceCreditNoteSummaryRec."BLRContract No.");
            finalAdjContractRec.SetFilter(BLRAmount, '<>%1', 0);
            if finalAdjContractRec.FindSet() then
                repeat
                    CrditMemoSaleslinecreate1(NewSalesHeader, finalAdjContractRec);
                    finalAdjContractRec."BLRCredit Note ID" := NewSalesHeader."No.";
                    finalAdjContractRec.Modify();
                until finalAdjContractRec.Next() = 0;

            Message('Sales Credit Memo created');

            InvoiceCreditNoteSummaryRec1.SetRange("BLRContract No.", pInvoiceCreditNoteSummaryRec."BLRContract No.");
            if InvoiceCreditNoteSummaryRec1.FindSet() then
                repeat
                    InvoiceCreditNoteSummaryRec1."BLRCredit Note ID" := NewSalesHeader."No.";
                    InvoiceCreditNoteSummaryRec1."BLRCredit Noted" := true;
                    InvoiceCreditNoteSummaryRec1.Modify();
                until InvoiceCreditNoteSummaryRec1.Next() = 0;
            // SalesPost.Run(NewSalesHeader);
        end;

    end;

    procedure CreateCreditMemoSalesHeader(pContractID: Integer; pTenantID: Code[50]; pUnitType: Text[50]): Record "Sales Header";
    var
        SalesHeader: Record "Sales Header";
        SalesReceivables: Record "Sales & Receivables Setup";
        noseries: Codeunit "No. Series";
    begin
        salesHeader.Init();
        if SalesReceivables.Get() then
            salesHeader."No." := noseries.GetNextNo(SalesReceivables."Credit Memo Nos.", Today, true);
        salesHeader."Document Type" := SalesHeader."Document Type"::"Credit Memo";

        salesHeader.Validate("Sell-to Customer No.", pTenantID);
        salesHeader."Document Date" := Today;
        salesHeader.Validate("BLRContract ID", pcontractid);
        //   salesHeader."Document Date" := Today;
        salesHeader."Posting Date" := Today;
        salesHeader."Due Date" := Today;
        salesHeader."BLRProperty Classification" := pUnitType;
        SalesHeader."Posting No. Series" := SalesReceivables."Posted Credit Memo Nos.";
        // SalesHeader."Approval Status for CreditNote" := SalesHeader."Approval Status for CreditNote"::Approved;
        SalesHeader."BLRTerminated Credit Note" := true;
        salesHeader.Insert();
        exit(salesHeader);
    end;

    procedure CrditMemoSaleslinecreate(salesheader1: Record "Sales Header"; BillingCalcSub: Record "BLRFinalBillingCalculationGrid");
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
        //newSaleslines.SetRange("BLRContract ID", salesheader1."Contract ID");
        newSaleslines.SetCurrentKey("Line No.");
        if newSaleslines.FindLast() then
            saleline."Line No." := newSaleslines."Line No." + 1000
        else
            saleline."Line No." := 1000;

        saleline."Document No." := salesheader1."No.";
        // saleline."Contract ID" := salesheader1."Contract ID";
        saleline.Type := saleline.Type::Item;
        saleline."Sell-to Customer No." := salesheader1."Sell-to Customer No.";
        item.SetRange(Description, BillingCalcSub.BLRRevenueDescription);
        item.SetFilter("BLRCharges Status", '<>%1', item."BLRCharges Status"::" ");
        if item.FindFirst() then
            saleline.Validate("No.", item."No.");
        saleline.Validate(Quantity, 1);
        RoundAmount := Abs(Round(BillingCalcSub.BLRDifferenceAmount, 0.01));
        saleline.Validate("Unit Price", RoundAmount);
        saleline."BLRContract ID" := BillingCalcSub."BLRContract ID";
        saleline."BLRFC ID" := salesheader1."BLRFC ID";
        saleline.Insert();
    end;

    procedure CrditMemoSaleslinecreate1(salesheader1: Record "Sales Header"; financialAdjustReductionRec: Record BLRFinAdjContractReduction);
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
        //newSaleslines.SetRange("BLRContract ID", salesheader1."Contract ID");
        newSaleslines.SetCurrentKey("Line No.");
        if newSaleslines.FindLast() then
            saleline."Line No." := newSaleslines."Line No." + 1000

        else
            saleline."Line No." := 1000;
        saleline."Document No." := salesheader1."No.";
        saleline.Type := saleline.Type::Item;
        saleline."Sell-to Customer No." := salesheader1."Sell-to Customer No.";
        item.SetRange(Description, financialAdjustReductionRec."BLRRevenue Description");
        item.SetFilter("BLRCharges Status", '<>%1', item."BLRCharges Status"::" ");
        if item.FindFirst() then
            saleline.Validate("No.", item."No.");

        saleline.Validate("Quantity (Base)", 1);
        saleline.Validate(Quantity, 1);
        RoundAmount := Abs(Round(financialAdjustReductionRec.BLRAmount, 0.01));
        saleline.Validate("Unit Price", RoundAmount);
        saleline."BLRContract ID" := financialAdjustReductionRec."BLRContract No.";
        saleline."BLRFC ID" := salesheader1."BLRFC ID";
        saleline.Insert();
    end;

}