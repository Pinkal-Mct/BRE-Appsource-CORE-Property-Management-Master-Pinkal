codeunit 73209623 "BLRSetMgtFeeCalculation"
{
    procedure BuildPropertyFilter(PropertyText: Text): Text
    var
        PropertyArr: List of [Text];
        Prop: Text;
        FilterTxt: Text;
    begin
        PropertyArr := PropertyText.Split(',');

        foreach Prop in PropertyArr do begin
            Prop := DelChr(Prop, '<>', ' ');
            // trim spaces

            if FilterTxt = '' then
                FilterTxt := Prop
            else
                FilterTxt := FilterTxt + '|' + Prop;
        end;

        exit(FilterTxt);
    end;

    procedure PopulateManagementFeeLines(MgtFeeHeader: Record "BLRManagementFeeCalcHeader")
    var
        MgtFeeGrid: Record "BLRManagementFeeGrid";
        MgtFeeLine: Record "BLRManagementFeeCalcLine";
        monthFilter: Text;
    begin
        monthFilter := GetMonthFilter(MgtFeeHeader."BLRPeriod From", MgtFeeHeader."BLRPeriod To");

        MgtFeeLine.Reset();
        MgtFeeLine.SetRange("BLRHeader No.", MgtFeeHeader."BLREntry No.");
        if MgtFeeLine.FindSet() then
            MgtFeeLine.DeleteAll(true);

        MgtFeeGrid.Reset();

        if not MgtFeeHeader."BLRAll Owners" then
            MgtFeeGrid.SetRange("BLROwner ID", MgtFeeHeader."BLROwner ID");

        if not MgtFeeHeader."BLRAll Properties" then
            MgtFeeGrid.SetFilter("BLRProperty Name", BuildPropertyFilter(MgtFeeHeader."BLRProperty"));

        MgtFeeGrid.SetFilter("BLRValid From", '<=%1', MgtFeeHeader."BLRPeriod To");

        MgtFeeGrid.SetFilter("BLRValid To", '>=%1', MgtFeeHeader."BLRPeriod From");

        if MgtFeeGrid.FindSet() then
            repeat
                InsertMgtFeeLine(MgtFeeHeader, MgtFeeGrid, monthFilter);
            until MgtFeeGrid.Next() = 0;
    end;

    procedure InsertMgtFeeLine(MgtFeeHeader: Record "BLRManagementFeeCalcHeader"; MgtFeeGrid: Record "BLRManagementFeeGrid"; pMonthFilter: Text)
    var
        MgtFeeCalcLine: Record "BLRManagementFeeCalcLine";
        BaseAmountHeader: Record "BLRBaseAmountDataHeader";
    begin
        MgtFeeCalcLine.Init();
        MgtFeeCalcLine."BLRHeader No." := MgtFeeHeader."BLREntry No.";
        MgtFeeCalcLine."BLREntry No." := GetNextLineNo(MgtFeeHeader."BLREntry No.");
        // Copy fields
        MgtFeeCalcLine."BLRProperty Management Company" := MgtFeeGrid."BLRProperty Management Company";
        MgtFeeCalcLine."BLROwner ID" := MgtFeeGrid."BLROwner ID";
        MgtFeeGrid.CalcFields("BLRCompany/Owner Name");
        MgtFeeCalcLine."BLRCompany/Owner Name" := MgtFeeGrid."BLRCompany/Owner Name";
        MgtFeeCalcLine."BLRProperty Name" := MgtFeeGrid."BLRProperty Name";
        MgtFeeCalcLine."BLRProperty Type" := MgtFeeGrid."BLRProperty Type";
        MgtFeeCalcLine."BLRCalculation Method" := MgtFeeGrid."BLRCalculation Method";
        MgtFeeCalcLine."BLRCalculation Sub-Type" := MgtFeeGrid."BLRCalculation Sub-Type";
        MgtFeeCalcLine."BLRPercentage Type" := MgtFeeGrid."BLRPercentage Type";
        MgtFeeCalcLine."BLRPercentage" := MgtFeeGrid."BLRPercentage";
        MgtFeeCalcLine."BLRAmount" := MgtFeeGrid."BLRAmount";
        MgtFeeCalcLine."BLRBase Amount Source" := MgtFeeGrid."BLRBase Amount Source";
        MgtFeeCalcLine."BLRValid From" := MgtFeeGrid."BLRValid From";
        MgtFeeCalcLine."BLRValid To" := MgtFeeGrid."BLRValid To";
        MgtFeeCalcLine.Insert();
        BaseAmountHeader := CreateBaseAmountDetails(MgtFeeCalcLine);
        MgtFeeCalcLine."BLRBase Amount" := FetchBaseAmount(MgtFeeCalcLine, MgtFeeHeader, BaseAmountHeader, pMonthFilter);
        MgtFeeCalcLine."BLRManagement Fee" := CalculateManagementFee(MgtFeeCalcLine, MgtFeeHeader, BaseAmountHeader);
        MgtFeeCalcLine.Modify();
    end;

    procedure GetNextLineNo(PrimaryKeyNo: Integer): Integer
    var
        MgtFeeLine: Record "BLRManagementFeeCalcLine";
    begin
        MgtFeeLine.Reset();
        MgtFeeLine.SetRange("BLRHeader No.", PrimaryKeyNo);
        if MgtFeeLine.FindLast() then
            exit(MgtFeeLine."BLREntry No." + 10000);

        exit(10000);
    end;

    procedure FetchBaseAmount(var MgtFeeCalcLine: Record "BLRManagementFeeCalcLine"; MgtFeeHeader: Record "BLRManagementFeeCalcHeader"; var pBaseAmountHeader: Record "BLRBaseAmountDataHeader"; pMonthFilter: Text): Decimal
    var
        baseAmount: Decimal;
    begin
        case
            MgtFeeCalcLine."BLRBase Amount Source" of
            MgtFeeCalcLine."BLRBase Amount Source"::Revenue:
                baseAmount := FetchBaseAmountFromRevenue(MgtFeeCalcLine, MgtFeeHeader, pBaseAmountHeader, pMonthFilter);
            MgtFeeCalcLine."BLRBase Amount Source"::"Annual Rent":
                baseAmount := FetchBaseAmountFromAnnualRent(MgtFeeCalcLine, MgtFeeHeader, pBaseAmountHeader, pMonthFilter);
            MgtFeeCalcLine."BLRBase Amount Source"::Collections:
                baseAmount := FetchBaseAmountFromCollections(MgtFeeCalcLine, MgtFeeHeader, pBaseAmountHeader, pMonthFilter);
            MgtFeeCalcLine."BLRBase Amount Source"::"Number of Units":
                PopulateBaseAmountDetailsFromPerUnitFee(MgtFeeCalcLine, MgtFeeHeader, pBaseAmountHeader, pMonthFilter);
        end;

        if MgtFeeCalcLine."BLRCalculation Method" = MgtFeeCalcLine."BLRCalculation Method"::Hybrid then
            PopulateBaseAmountDetailsFromPerUnitFee(MgtFeeCalcLine, MgtFeeHeader, pBaseAmountHeader, pMonthFilter);

        exit(baseAmount);
    end;

    procedure FetchBaseAmountFromRevenue(var MgtFeeCalcLine: Record "BLRManagementFeeCalcLine"; MgtFeeHeader: Record "BLRManagementFeeCalcHeader"; var pBaseAmountHeader: Record "BLRBaseAmountDataHeader"; pMonthFilter: Text): Decimal
    var
        revenueAllocationSubGrid: Record "BLRRevenueAllocationSubGrid";
        totalAmount: Decimal;
    begin
        totalAmount := 0;
        revenueAllocationSubGrid.SetRange("BLRProperty Name", MgtFeeCalcLine."BLRProperty Name");
        revenueAllocationSubGrid.SetRange("BLROwner Name", MgtFeeCalcLine."BLRCompany/Owner Name");
        revenueAllocationSubGrid.SetRange("BLRDescription", 'Regular');
        revenueAllocationSubGrid.SetRange("BLRPosting Year", MgtFeeHeader."BLRFinancial Year");
        revenueAllocationSubGrid.SetFilter("BLRContract Start Date", '<=%1', MgtFeeHeader."BLRPeriod To");
        revenueAllocationSubGrid.SetFilter("BLRContract End Date", '>=%1|%2', MgtFeeHeader."BLRPeriod From", 0D);
        revenueAllocationSubGrid.SetFilter("BLRPosting Month", pMonthFilter);
        if revenueAllocationSubGrid.FindSet() then
            repeat
                totalAmount += revenueAllocationSubGrid."BLRTotal Value";
                PopulateBaseAmountDetailsFromRevenueAndAnnualRent(pBaseAmountHeader, MgtFeeCalcLine, MgtFeeHeader, revenueAllocationSubGrid, pMonthFilter);
            until revenueAllocationSubGrid.Next() = 0;
        exit(totalAmount);
    end;

    procedure FetchBaseAmountFromAnnualRent(var MgtFeeCalcLine: Record "BLRManagementFeeCalcLine"; MgtFeeHeader: Record "BLRManagementFeeCalcHeader"; var pBaseAmountHeader: Record "BLRBaseAmountDataHeader"; pMonthFilter: Text): Decimal
    var
        revenueAllocationSubGrid: Record "BLRRevenueAllocationSubGrid";
        annualRentPerMonth: Decimal;
        totalAmount: Decimal;
    begin
        totalAmount := 0;
        revenueAllocationSubGrid.SetRange("BLRProperty Name", MgtFeeCalcLine."BLRProperty Name");
        revenueAllocationSubGrid.SetRange("BLROwner Name", MgtFeeCalcLine."BLRCompany/Owner Name");
        revenueAllocationSubGrid.SetRange("BLRDescription", 'Regular');
        revenueAllocationSubGrid.SetRange("BLRPosting Year", MgtFeeHeader."BLRFinancial Year");
        revenueAllocationSubGrid.SetFilter("BLRContract Start Date", '<=%1', MgtFeeHeader."BLRPeriod To");
        revenueAllocationSubGrid.SetFilter("BLRContract End Date", '>=%1|%2', MgtFeeHeader."BLRPeriod From", 0D);
        revenueAllocationSubGrid.SetFilter("BLRPosting Month", pMonthFilter);
        if revenueAllocationSubGrid.FindSet() then
            repeat
                annualRentPerMonth := revenueAllocationSubGrid."BLRAnnual Amount" / 12;
                totalAmount += annualRentPerMonth;
                PopulateBaseAmountDetailsFromRevenueAndAnnualRent(pBaseAmountHeader, MgtFeeCalcLine, MgtFeeHeader, revenueAllocationSubGrid, pMonthFilter);
            until revenueAllocationSubGrid.Next() = 0;
        exit(totalAmount);
    end;

    procedure FetchBaseAmountFromCollections(var MgtFeeCalcLine: Record "BLRManagementFeeCalcLine"; MgtFeeHeader: Record "BLRManagementFeeCalcHeader"; var pBaseAmountHeader: Record "BLRBaseAmountDataHeader"; pMonthFilter: Text): Decimal
    var
        Tenancycontract: Record "BLRTenancyContract";
        PaymentShceduleLine: Record "BLRPaymentSchedule2";
        paymentmode2: Record "BLRPaymentMode2";
        totalamount: Decimal;
    begin
        totalamount := 0;
        Tenancycontract.Reset();
        Tenancycontract.SetRange("BLRProperty Name", MgtFeeCalcLine."BLRProperty Name");
        if Tenancycontract.FindSet() then
            repeat
                paymentmode2.SetRange("BLRContract ID", Tenancycontract."BLRContract ID");
                paymentmode2.SetFilter("BLRReceipt Date", '%1..%2', MgtFeeHeader."BLRPeriod From", MgtFeeHeader."BLRPeriod To");
                if paymentmode2.FindSet() then
                    repeat
                        PaymentShceduleLine.Reset();
                        PaymentShceduleLine.SetRange("BLRContract ID", Tenancycontract."BLRContract ID");
                        PaymentShceduleLine.SetRange("BLRPayment Series", paymentmode2."BLRPayment Series");
                        PaymentShceduleLine.SetRange("BLRSecondary Item Type", 'Rent');
                        if PaymentShceduleLine.FindSet() then
                            repeat
                                totalamount += PaymentShceduleLine."BLRAmount";
                                PopulateBaseAmountDetailsFromCollections(pBaseAmountHeader, MgtFeeCalcLine, MgtFeeHeader, PaymentShceduleLine, paymentmode2, Tenancycontract, pMonthFilter);
                            until PaymentShceduleLine.Next() = 0;

                    until paymentmode2.Next() = 0;

            until Tenancycontract.Next() = 0;
        exit(totalamount);
    end;

    procedure CalculateManagementFee(var MgtFeeCalcLine: Record "BLRManagementFeeCalcLine"; MgtFeeHeader: Record "BLRManagementFeeCalcHeader"; BaseAmountHeader: Record "BLRBaseAmountDataHeader"): Decimal
    var
        finalMgtFee: Decimal;
    begin
        case
            MgtFeeCalcLine."BLRCalculation Method" of
            MgtFeeCalcLine."BLRCalculation Method"::"Percentage of Annual Rent", MgtFeeCalcLine."BLRCalculation Method"::"Percentage of Collections", MgtFeeCalcLine."BLRCalculation Method"::"Percentage of Monthly Revenue":
                finalMgtFee := (MgtFeeCalcLine."BLRBase Amount" * MgtFeeCalcLine.BLRPercentage) / 100;
            MgtFeeCalcLine."BLRCalculation Method"::"Per Unit Fee":
                finalMgtFee := CalculateMgtFeeFromFixedAmount(MgtFeeCalcLine, MgtFeeHeader, BaseAmountHeader);
            MgtFeeCalcLine."BLRCalculation Method"::Hybrid:
                finalMgtFee := ((MgtFeeCalcLine."BLRBase Amount" * MgtFeeCalcLine.BLRPercentage) / 100) + CalculateMgtFeeFromFixedAmount(MgtFeeCalcLine, MgtFeeHeader, BaseAmountHeader);
        end;
        exit(finalMgtFee);
    end;

    procedure GetMonthFilter(pStartDate: Date; pEndDate: Date): Text
    var
        fetchMonth: Codeunit "BLRFetch Month";
        tempDate: Date;
        monthFilter: Text;
    begin
        tempDate := pStartDate;

        while tempDate <= pEndDate do begin
            if monthFilter = '' then
                monthFilter := fetchMonth.GetMonthName(Date2DMY(tempDate, 2))
            else
                monthFilter := monthFilter + '|' + fetchMonth.GetMonthName(Date2DMY(tempDate, 2));
            tempDate := CalcDate('<1M>', tempDate);
        end;
        exit(monthFilter)
    end;

    procedure GetYearFilter(pStartDate: Date; pEndDate: Date): Text
    var
        startYear: Integer;
        endYear: Integer;
        currentYear: Integer;
        yearFilter: Text;
    begin
        startYear := Date2DMY(pStartDate, 3);
        endYear := Date2DMY(pEndDate, 3);
        currentYear := startYear;

        while currentYear <= endYear do begin
            if yearFilter = '' then
                yearFilter := Format(currentYear)
            else
                yearFilter := yearFilter + '|' + Format(currentYear);
            currentYear += 1;
        end;
        exit(yearFilter);
    end;

    procedure CalculateMgtFeeFromFixedAmount(var MgtFeeCalcLine: Record "BLRManagementFeeCalcLine"; MgtFeeHeader: Record "BLRManagementFeeCalcHeader"; BaseAmountHeader: Record "BLRBaseAmountDataHeader"): Decimal
    var

        baseAmountData: Record "BLRBaseAmountDataUnitWise";
        unitCount: Integer;
        totalAmount: Decimal;
    begin
        unitCount := 0;

        baseAmountData.SetRange("BLRHeader No.", BaseAmountHeader."BLRHeader No.");
        baseAmountData.SetRange("BLRLine No.", BaseAmountHeader."BLRLine No.");
        if baseAmountData.FindFirst() then begin
            baseAmountData.CalcFields("BLRTotal Quantity");
            unitCount := baseAmountData."BLRTotal Quantity";
            if unitCount <> 0 then
                totalAmount := (unitCount * MgtFeeCalcLine."BLRAmount");
        end;

        exit(totalAmount);
    end;

    procedure MergeUnitCount(pUnitNumber: Text[50]): Integer
    var
        UnitArr: List of [Text];
        Unit: Text;
        unitCount: Integer;
    begin
        if pUnitNumber = '' then
            exit(0);

        UnitArr := pUnitNumber.Split(',');
        unitCount := 0;

        foreach Unit in UnitArr do begin
            Unit := DelChr(Unit, '<>', ' ');
            if Unit <> '' then
                unitCount += 1;
        end;

        exit(unitCount);
    end;

    procedure CreateBaseAmountDetails(pMgtFeeCalcLine: Record "BLRManagementFeeCalcLine"): Record "BLRBaseAmountDataHeader"
    var
        baseAmountHeader: Record "BLRBaseAmountDataHeader";
    begin
        baseAmountHeader.Init();
        baseAmountHeader."BLRHeader No." := pMgtFeeCalcLine."BLRHeader No.";
        baseAmountHeader."BLRLine No." := pMgtFeeCalcLine."BLREntry No.";

        if (pMgtFeeCalcLine."BLRCalculation Method" = pMgtFeeCalcLine."BLRCalculation Method"::"Per Unit Fee") or (pMgtFeeCalcLine."BLRCalculation Method" = pMgtFeeCalcLine."BLRCalculation Method"::Hybrid) then
            baseAmountHeader."BLRBase Amount Type" := Format(pMgtFeeCalcLine."BLRCalculation Method")
        else
            baseAmountHeader."BLRBase Amount Type" := Format(pMgtFeeCalcLine."BLRBase Amount Source");

        baseAmountHeader.Insert();
        exit(baseAmountHeader);
    end;

    procedure PopulateBaseAmountDetailsFromRevenueAndAnnualRent(var pBaseAmountHeader: Record "BLRBaseAmountDataHeader"; pMgtFeeCalcLine: Record "BLRManagementFeeCalcLine"; MgtFeeHeader: Record "BLRManagementFeeCalcHeader"; pRevenueAllocationSubgrid: Record "BLRRevenueAllocationSubGrid"; pMonthFilter: Text)
    var
        baseAmountDetails: Record "BLRBaseAmountData";
    begin
        if (pMgtFeeCalcLine."BLRCalculation Method" <> pMgtFeeCalcLine."BLRCalculation Method"::"Per Unit Fee") then begin
            baseAmountDetails.Init();
            InsertBaseAmountDetails(baseAmountDetails, pBaseAmountHeader, pMgtFeeCalcLine, MgtFeeHeader, pRevenueAllocationSubgrid, pMonthFilter);
            case
                pMgtFeeCalcLine."BLRBase Amount Source" of
                pMgtFeeCalcLine."BLRBase Amount Source"::Revenue:
                    baseAmountDetails."BLRBase Amount" := pRevenueAllocationSubgrid."BLRTotal Value";
                pMgtFeeCalcLine."BLRBase Amount Source"::"Annual Rent":
                    baseAmountDetails."BLRBase Amount" := pRevenueAllocationSubgrid."BLRAnnual Amount" / 12;
            end;
            baseAmountDetails.Insert();
            Clear(baseAmountDetails);
        end;
    end;

    procedure PopulateBaseAmountDetailsFromCollections(var pBaseAmountHeader: Record "BLRBaseAmountDataHeader"; pMgtFeeCalcLine: Record "BLRManagementFeeCalcLine"; MgtFeeHeader: Record "BLRManagementFeeCalcHeader"; pPaymentShceduleLine: Record "BLRPaymentSchedule2"; pPaymentMode: Record "BLRPaymentMode2"; pTenancyContract: Record "BLRTenancyContract"; pMonthFilter: Text)
    var
        baseAmountDetails: Record "BLRBaseAmountData";
        rentCalcSubPage: Record "BLRRentCalculationSubpage";
        rentCalcSubPage2: Record "BLRRentCalculationSubpage2";
    begin
        if (pMgtFeeCalcLine."BLRCalculation Method" <> pMgtFeeCalcLine."BLRCalculation Method"::"Per Unit Fee") then begin
            baseAmountDetails.Init();
            baseAmountDetails."BLRHeader No." := pBaseAmountHeader."BLRHeader No.";
            baseAmountDetails."BLRLine No." := pBaseAmountHeader."BLRLine No.";
            baseAmountDetails."BLRReport Date" := MgtFeeHeader."BLRReport Date";
            baseAmountDetails."BLRFinancial Year" := MgtFeeHeader."BLRFinancial Year";
            baseAmountDetails."BLRPeriod From" := MgtFeeHeader."BLRPeriod From";
            baseAmountDetails."BLRPeriod To" := MgtFeeHeader."BLRPeriod To";
            baseAmountDetails."BLRProperty Management Company" := pMgtFeeCalcLine."BLRProperty Management Company";
            baseAmountDetails."BLRCompany Owner Name" := pMgtFeeCalcLine."BLRCompany/Owner Name";
            baseAmountDetails."BLRProperty Name" := pMgtFeeCalcLine."BLRProperty Name";
            baseAmountDetails."BLRProperty Type" := pMgtFeeCalcLine."BLRProperty Type";
            baseAmountDetails."BLRContract Id" := pTenancyContract."BLRContract Id";
            baseAmountDetails."BLRReceipt Date" := pPaymentMode."BLRReceipt Date";
            baseAmountDetails."BLRReceipt No." := pPaymentMode."BLRReceipt #";

            rentCalcSubPage2.SetRange("BLRContract ID", pPaymentShceduleLine."BLRContract ID");
            rentCalcSubPage2.SetRange("BLRInstallment Start Date", pPaymentShceduleLine."BLRInstallment Start Date");
            rentCalcSubPage2.SetRange("BLRInstallment End Date", pPaymentShceduleLine."BLRInstallment End Date");
            if rentCalcSubPage2.FindFirst() then begin
                rentCalcSubPage.SetRange("BLRContract ID", rentCalcSubPage2."BLRContract ID");
                rentCalcSubPage.SetRange("BLRYear", rentCalcSubPage2."BLRYear");
                if rentCalcSubPage.FindFirst() then begin
                    baseAmountDetails."BLRMulti Year Start Date" := rentCalcSubPage."BLRPeriod Start Date";
                    baseAmountDetails."BLRMulti Year End Date" := rentCalcSubPage."BLRPeriod End Date";
                    baseAmountDetails."BLRAnnual Rent Amount" := rentCalcSubPage."BLRFinal Annual Amount";
                end;
            end;

            baseAmountDetails."BLRBase Amount Source" := pBaseAmountHeader."BLRBase Amount Type";
            baseAmountDetails."BLRUnit Status" := 'Occupied';
            baseAmountDetails."BLRContract Status" := Format(pTenancyContract."BLRContract Status"::Active);
            if pTenancyContract."BLRUnit ID" <> '' then begin
                baseAmountDetails.BLRQuantity := 1;
                baseAmountDetails."BLRUnit Number" := CopyStr(pTenancyContract."BLRUnit ID", 1, 30);
            end
            else begin
                baseAmountDetails.BLRQuantity := MergeUnitCount(pTenancyContract."BLRUnit Number");
                baseAmountDetails."BLRUnit Number" := CopyStr(pTenancyContract."BLRUnit Number", 1, 30);
            end;
            baseAmountDetails."BLRMonth" := '-';
            baseAmountDetails."BLRBase Amount" := pPaymentShceduleLine."BLRAmount Including VAT";
            baseAmountDetails.Insert();
            Clear(baseAmountDetails);
        end;
    end;

    procedure PopulateBaseAmountDetailsFromPerUnitFee(var pMgtFeeCalcLine: Record "BLRManagementFeeCalcLine"; MgtFeeHeader: Record "BLRManagementFeeCalcHeader"; var pBaseAmountHeader: Record "BLRBaseAmountDataHeader"; pMonthFilter: Text)
    var
        baseAmountDetails: Record "BLRBaseAmountDataUnitWise";
        tenancyContract: Record "BLRTenancyContract";
        finalCalculation: Record "BLRFinalCalculation";
        suspRec: Record BLRSuspendReasonTable;
        fetchMonth: Codeunit "BLRFetch Month";
        tempDate: Date;
        effStart: Date;
        effEnd: Date;
        unitCount: Integer;
        suspFirstDay: Date;
        suspLastDay: Date;
    begin
        // Fetch contracts for the property/owner that overlap the selected period
        tenancyContract.SetRange("BLRProperty Name", pMgtFeeCalcLine."BLRProperty Name");
        tenancyContract.SetRange("BLROwner's Name", pMgtFeeCalcLine."BLRCompany/Owner Name");
        tenancyContract.SetFilter("BLRContract Start Date", '<=%1', MgtFeeHeader."BLRPeriod To");
        tenancyContract.SetFilter("BLRContract End Date", '>=%1|%2', MgtFeeHeader."BLRPeriod From", 0D);
        tenancyContract.SetFilter(tenancyContract."BLRTenant Contract Status", '%1|%2|%3', tenancyContract."BLRTenant Contract Status"::Active, tenancyContract."BLRTenant Contract Status"::Terminated, tenancyContract."BLRTenant Contract Status"::Suspended);
        if tenancyContract.FindSet() then
            repeat
                // effective start = later of contract start and report start
                if tenancyContract."BLRContract Start Date" > MgtFeeHeader."BLRPeriod From" then
                    effStart := tenancyContract."BLRContract Start Date"
                else
                    effStart := MgtFeeHeader."BLRPeriod From";

                // if effective start is after period end, skip this contract
                if effStart > MgtFeeHeader."BLRPeriod To" then
                    continue;

                // effective end = earlier of contract end (if set) and report end
                if (tenancyContract."BLRContract End Date" = 0D) or (tenancyContract."BLRContract End Date" > MgtFeeHeader."BLRPeriod To") then
                    effEnd := MgtFeeHeader."BLRPeriod To"
                else
                    effEnd := tenancyContract."BLRContract End Date";

                // cap effective end at period end
                if effEnd > MgtFeeHeader."BLRPeriod To" then
                    effEnd := MgtFeeHeader."BLRPeriod To";

                // if contract is terminated, lookup final calculation and use its termination date if earlier
                if tenancyContract."BLRTenant Contract Status" = tenancyContract."BLRTenant Contract Status"::Terminated then begin
                    finalCalculation.SetRange("BLRContract ID", tenancyContract."BLRContract ID");
                    if finalCalculation.FindFirst() then
                        if (finalCalculation."BLRTermination Date" <> 0D) and (finalCalculation."BLRTermination Date" < effEnd) then
                            effEnd := finalCalculation."BLRTermination Date";
                end;

                if effStart > effEnd then
                    continue;

                // determine unit count for this contract
                if tenancyContract."BLRUnit ID" <> '' then
                    unitCount := 1
                else
                    unitCount := MergeUnitCount(tenancyContract."BLRUnit Number");

                // iterate month-by-month within effective range and insert a record per month
                tempDate := DMY2DATE(1, Date2DMY(effStart, 2), Date2DMY(effStart, 3));
                while tempDate <= effEnd do begin
                    // check if this entire month is suspended
                    suspFirstDay := tempDate;
                    suspLastDay := CalcDate('<1M>', tempDate) - 1;
                    suspRec.SetRange("BLRContract ID", tenancyContract."BLRContract ID");
                    suspRec.SetFilter(BLRDateEffective, '<=%1', suspFirstDay);
                    suspRec.SetFilter(BLRSuspensionEndDate, '>=%1|%2', suspLastDay, 0D);
                    if suspRec.FindFirst() then begin
                        // entire month is suspended, skip it
                        tempDate := CalcDate('<1M>', tempDate);
                        continue;
                    end;

                    baseAmountDetails.Init();
                    baseAmountDetails."BLRHeader No." := pBaseAmountHeader."BLRHeader No.";
                    baseAmountDetails."BLRLine No." := pBaseAmountHeader."BLRLine No.";
                    baseAmountDetails."BLRReport Date" := MgtFeeHeader."BLRReport Date";
                    baseAmountDetails."BLRFinancial Year" := MgtFeeHeader."BLRFinancial Year";
                    baseAmountDetails."BLRPeriod From" := MgtFeeHeader."BLRPeriod From";
                    baseAmountDetails."BLRPeriod To" := MgtFeeHeader."BLRPeriod To";
                    baseAmountDetails."BLRProperty Management Company" := pMgtFeeCalcLine."BLRProperty Management Company";
                    baseAmountDetails."BLRCompany Owner Name" := pMgtFeeCalcLine."BLRCompany/Owner Name";
                    baseAmountDetails."BLRProperty Name" := pMgtFeeCalcLine."BLRProperty Name";
                    baseAmountDetails."BLRProperty type" := pMgtFeeCalcLine."BLRProperty Type";
                    baseAmountDetails."BLRContract Id" := tenancyContract."BLRContract Id";
                    baseAmountDetails."BLRBase Amount Source" := pBaseAmountHeader."BLRBase Amount Type";
                    baseAmountDetails."BLRUnit Status" := 'Occupied';
                    baseAmountDetails."BLRContract Status" := Format(tenancyContract."BLRTenant Contract Status");
                    if tenancyContract."BLRUnit ID" <> '' then begin
                        baseAmountDetails.BLRQuantity := 1;
                        baseAmountDetails."BLRUnit Number" := CopyStr(tenancyContract."BLRUnit ID", 1, 30);
                    end else begin
                        baseAmountDetails.BLRQuantity := unitCount;
                        baseAmountDetails."BLRUnit Number" := CopyStr(tenancyContract."BLRUnit Number", 1, 30);
                    end;
                    baseAmountDetails."BLRMonth" := CopyStr(fetchMonth.GetMonthName(Date2DMY(tempDate, 2)), 1, 20);
                    baseAmountDetails.Insert();
                    Clear(baseAmountDetails);

                    tempDate := CalcDate('<1M>', tempDate);
                end;
            until tenancyContract.Next() = 0;
    end;

    procedure InsertBaseAmountDetails(var pBaseAmountDetails: Record "BLRBaseAmountData"; var pBaseAmountHeader: Record "BLRBaseAmountDataHeader"; pMgtFeeCalcLine: Record "BLRManagementFeeCalcLine"; MgtFeeHeader: Record "BLRManagementFeeCalcHeader"; pRevenueAllocationSubgrid: Record "BLRRevenueAllocationSubGrid"; pMonthFilter: Text)
    var
        tenancyContract: Record "BLRTenancyContract";
    begin
        pBaseAmountDetails."BLRHeader No." := pBaseAmountHeader."BLRHeader No.";
        pBaseAmountDetails."BLRLine No." := pBaseAmountHeader."BLRLine No.";
        pBaseAmountDetails."BLRReport Date" := MgtFeeHeader."BLRReport Date";
        pBaseAmountDetails."BLRFinancial Year" := MgtFeeHeader."BLRFinancial Year";
        pBaseAmountDetails."BLRPeriod From" := MgtFeeHeader."BLRPeriod From";
        pBaseAmountDetails."BLRPeriod To" := MgtFeeHeader."BLRPeriod To";
        pBaseAmountDetails."BLRProperty Management Company" := pMgtFeeCalcLine."BLRProperty Management Company";
        pBaseAmountDetails."BLRCompany Owner Name" := pMgtFeeCalcLine."BLRCompany/Owner Name";
        pBaseAmountDetails."BLRProperty Name" := pMgtFeeCalcLine."BLRProperty Name";
        pBaseAmountDetails."BLRProperty type" := pMgtFeeCalcLine."BLRProperty Type";
        pBaseAmountDetails."BLRContract Id" := pRevenueAllocationSubgrid."BLRContract Id";
        pBaseAmountDetails."BLRMulti Year Start Date" := pRevenueAllocationSubgrid."BLRMulti Year Start Date";
        pBaseAmountDetails."BLRMulti Year End Date" := pRevenueAllocationSubgrid."BLRMulti Year End Date";
        pBaseAmountDetails."BLRAnnual Rent Amount" := pRevenueAllocationSubgrid."BLRAnnual Amount";
        pBaseAmountDetails."BLRBase Amount Source" := pBaseAmountHeader."BLRBase Amount Type";
        pBaseAmountDetails."BLRUnit Status" := 'Occupied';
        if tenancyContract.Get(pRevenueAllocationSubgrid."BLRContract Id") then begin
            pBaseAmountDetails."BLRContract Status" := Format(tenancyContract."BLRContract Status"::Active);
            if tenancyContract."BLRUnit ID" <> '' then begin
                pBaseAmountDetails.BLRQuantity := 1;
                pBaseAmountDetails."BLRUnit Number" := CopyStr(tenancyContract."BLRUnit ID", 1, 30);
            end
            else begin
                pBaseAmountDetails.BLRQuantity := MergeUnitCount(tenancyContract."BLRUnit Number");
                pBaseAmountDetails."BLRUnit Number" := CopyStr(tenancyContract."BLRUnit Number", 1, 30);
            end;
        end;
        pBaseAmountDetails."BLRMonth" := Format(pRevenueAllocationSubgrid."BLRPosting Month");
    end;
}