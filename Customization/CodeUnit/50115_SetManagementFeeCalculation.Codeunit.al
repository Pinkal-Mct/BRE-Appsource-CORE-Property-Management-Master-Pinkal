codeunit 50115 "SetManagementFeeCalculation"
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

    procedure PopulateManagementFeeLines(MgtFeeHeader: Record "Management Fee Calc. Header")
    var
        MgtFeeGrid: Record "Management Fee Grid";
        MgtFeeLine: Record "Management Fee Calc. Line";
        monthFilter: Text;
    begin
        monthFilter := GetMonthFilter(MgtFeeHeader."Period From", MgtFeeHeader."Period To");

        MgtFeeLine.Reset();
        MgtFeeLine.SetRange("Header No.", MgtFeeHeader."Entry No.");
        if MgtFeeLine.FindSet() then
            MgtFeeLine.DeleteAll(true);

        MgtFeeGrid.Reset();

        if not MgtFeeHeader."All Owners" then
            MgtFeeGrid.SetRange("Owner ID", MgtFeeHeader."Owner ID");

        if not MgtFeeHeader."All Properties" then
            MgtFeeGrid.SetFilter("Property Name", BuildPropertyFilter(MgtFeeHeader.Property));

        MgtFeeGrid.SetFilter("Valid From", '<=%1', MgtFeeHeader."Period To");

        MgtFeeGrid.SetFilter("Valid To", '>=%1', MgtFeeHeader."Period From");

        if MgtFeeGrid.FindSet() then
            repeat
                InsertMgtFeeLine(MgtFeeHeader, MgtFeeGrid, monthFilter);
            until MgtFeeGrid.Next() = 0;
    end;

    procedure InsertMgtFeeLine(MgtFeeHeader: Record "Management Fee Calc. Header"; MgtFeeGrid: Record "Management Fee Grid"; pMonthFilter: Text)
    var
        MgtFeeCalcLine: Record "Management Fee Calc. Line";
        BaseAmountHeader: Record "Base Amount Data Header";
    begin
        MgtFeeCalcLine.Init();
        MgtFeeCalcLine."Header No." := MgtFeeHeader."Entry No.";
        MgtFeeCalcLine."Entry No." := GetNextLineNo(MgtFeeHeader."Entry No.");
        // Copy fields
        MgtFeeCalcLine."Property Management Company" := MgtFeeGrid."Property Management Company";
        MgtFeeCalcLine."Owner ID" := MgtFeeGrid."Owner ID";
        MgtFeeGrid.CalcFields("Company/Owner Name");
        MgtFeeCalcLine."Company/Owner Name" := MgtFeeGrid."Company/Owner Name";
        MgtFeeCalcLine."Property Name" := MgtFeeGrid."Property Name";
        MgtFeeCalcLine."Property Type" := MgtFeeGrid."Property Type";
        MgtFeeCalcLine."Calculation Method" := MgtFeeGrid."Calculation Method";
        MgtFeeCalcLine."Calculation Sub-Type" := MgtFeeGrid."Calculation Sub-Type";
        MgtFeeCalcLine."Percentage Type" := MgtFeeGrid."Percentage Type";
        MgtFeeCalcLine."Percentage" := MgtFeeGrid."Percentage";
        MgtFeeCalcLine."Amount" := MgtFeeGrid."Amount";
        MgtFeeCalcLine."Base Amount Source" := MgtFeeGrid."Base Amount Source";
        MgtFeeCalcLine."Valid From" := MgtFeeGrid."Valid From";
        MgtFeeCalcLine."Valid To" := MgtFeeGrid."Valid To";
        MgtFeeCalcLine.Insert();
        BaseAmountHeader := CreateBaseAmountDetails(MgtFeeCalcLine);
        MgtFeeCalcLine."Base Amount" := FetchBaseAmount(MgtFeeCalcLine, MgtFeeHeader, BaseAmountHeader, pMonthFilter);
        MgtFeeCalcLine."Management Fee" := CalculateManagementFee(MgtFeeCalcLine, MgtFeeHeader, BaseAmountHeader);
        MgtFeeCalcLine.Modify();
    end;

    procedure GetNextLineNo(PrimaryKeyNo: Integer): Integer
    var
        MgtFeeLine: Record "Management Fee Calc. Line";
    begin
        MgtFeeLine.Reset();
        MgtFeeLine.SetRange("Header No.", PrimaryKeyNo);
        if MgtFeeLine.FindLast() then
            exit(MgtFeeLine."Entry No." + 10000);

        exit(10000);
    end;

    procedure FetchBaseAmount(var MgtFeeCalcLine: Record "Management Fee Calc. Line"; MgtFeeHeader: Record "Management Fee Calc. Header"; var pBaseAmountHeader: Record "Base Amount Data Header"; pMonthFilter: Text): Decimal
    var
        baseAmount: Decimal;
    begin
        case
            MgtFeeCalcLine."Base Amount Source" of
            MgtFeeCalcLine."Base Amount Source"::Revenue:
                baseAmount := FetchBaseAmountFromRevenue(MgtFeeCalcLine, MgtFeeHeader, pBaseAmountHeader, pMonthFilter);
            MgtFeeCalcLine."Base Amount Source"::"Annual Rent":
                baseAmount := FetchBaseAmountFromAnnualRent(MgtFeeCalcLine, MgtFeeHeader, pBaseAmountHeader, pMonthFilter);
            MgtFeeCalcLine."Base Amount Source"::Collections:
                baseAmount := FetchBaseAmountFromCollections(MgtFeeCalcLine, MgtFeeHeader, pBaseAmountHeader, pMonthFilter);
            MgtFeeCalcLine."Base Amount Source"::"Number of Units":
                PopulateBaseAmountDetailsFromPerUnitFee(MgtFeeCalcLine, MgtFeeHeader, pBaseAmountHeader, pMonthFilter);
        end;

        if MgtFeeCalcLine."Calculation Method" = MgtFeeCalcLine."Calculation Method"::Hybrid then
            PopulateBaseAmountDetailsFromPerUnitFee(MgtFeeCalcLine, MgtFeeHeader, pBaseAmountHeader, pMonthFilter);

        exit(baseAmount);
    end;

    procedure FetchBaseAmountFromRevenue(var MgtFeeCalcLine: Record "Management Fee Calc. Line"; MgtFeeHeader: Record "Management Fee Calc. Header"; var pBaseAmountHeader: Record "Base Amount Data Header"; pMonthFilter: Text): Decimal
    var
        revenueAllocationSubGrid: Record "Revenue Allocation SubGrid";
        totalAmount: Decimal;
    begin
        totalAmount := 0;
        revenueAllocationSubGrid.SetRange("Property Name", MgtFeeCalcLine."Property Name");
        revenueAllocationSubGrid.SetRange("Owner Name", MgtFeeCalcLine."Company/Owner Name");
        revenueAllocationSubGrid.SetRange(Description, 'Regular');
        revenueAllocationSubGrid.SetRange("Posting Year", MgtFeeHeader."Financial Year");
        revenueAllocationSubGrid.SetFilter("Contract Start Date", '<=%1', MgtFeeHeader."Period To");
        revenueAllocationSubGrid.SetFilter("Contract End Date", '>=%1|%2', MgtFeeHeader."Period From", 0D);
        revenueAllocationSubGrid.SetFilter("Posting Month", pMonthFilter);
        if revenueAllocationSubGrid.FindSet() then
            repeat
                totalAmount += revenueAllocationSubGrid."Total Value";
                PopulateBaseAmountDetailsFromRevenueAndAnnualRent(pBaseAmountHeader, MgtFeeCalcLine, MgtFeeHeader, revenueAllocationSubGrid, pMonthFilter);
            until revenueAllocationSubGrid.Next() = 0;
        exit(totalAmount);
    end;

    procedure FetchBaseAmountFromAnnualRent(var MgtFeeCalcLine: Record "Management Fee Calc. Line"; MgtFeeHeader: Record "Management Fee Calc. Header"; var pBaseAmountHeader: Record "Base Amount Data Header"; pMonthFilter: Text): Decimal
    var
        revenueAllocationSubGrid: Record "Revenue Allocation SubGrid";
        annualRentPerMonth: Decimal;
        totalAmount: Decimal;
    begin
        totalAmount := 0;
        revenueAllocationSubGrid.SetRange("Property Name", MgtFeeCalcLine."Property Name");
        revenueAllocationSubGrid.SetRange("Owner Name", MgtFeeCalcLine."Company/Owner Name");
        revenueAllocationSubGrid.SetRange(Description, 'Regular');
        revenueAllocationSubGrid.SetRange("Posting Year", MgtFeeHeader."Financial Year");
        revenueAllocationSubGrid.SetFilter("Contract Start Date", '<=%1', MgtFeeHeader."Period To");
        revenueAllocationSubGrid.SetFilter("Contract End Date", '>=%1|%2', MgtFeeHeader."Period From", 0D);
        revenueAllocationSubGrid.SetFilter("Posting Month", pMonthFilter);
        if revenueAllocationSubGrid.FindSet() then
            repeat
                annualRentPerMonth := revenueAllocationSubGrid."Annual Amount" / 12;
                totalAmount += annualRentPerMonth;
                PopulateBaseAmountDetailsFromRevenueAndAnnualRent(pBaseAmountHeader, MgtFeeCalcLine, MgtFeeHeader, revenueAllocationSubGrid, pMonthFilter);
            until revenueAllocationSubGrid.Next() = 0;
        exit(totalAmount);
    end;

    procedure FetchBaseAmountFromCollections(var MgtFeeCalcLine: Record "Management Fee Calc. Line"; MgtFeeHeader: Record "Management Fee Calc. Header"; var pBaseAmountHeader: Record "Base Amount Data Header"; pMonthFilter: Text): Decimal
    var
        Tenancycontract: Record "Tenancy Contract";
        PaymentShceduleLine: Record "Payment Schedule2";
        paymentmode2: Record "Payment Mode2";
        totalamount: Decimal;
    begin
        totalamount := 0;
        Tenancycontract.Reset();
        Tenancycontract.SetRange("Property Name", MgtFeeCalcLine."Property Name");
        if Tenancycontract.FindSet() then
            repeat
                paymentmode2.SetRange("Contract ID", Tenancycontract."Contract ID");
                paymentmode2.SetFilter("Receipt Date", '%1..%2', MgtFeeHeader."Period From", MgtFeeHeader."Period To");
                if paymentmode2.FindSet() then
                    repeat
                        PaymentShceduleLine.Reset();
                        PaymentShceduleLine.SetRange("Contract ID", Tenancycontract."Contract ID");
                        PaymentShceduleLine.SetRange("Payment Series", paymentmode2."Payment Series");
                        PaymentShceduleLine.SetRange("Secondary Item Type", 'Rent');
                        if PaymentShceduleLine.FindSet() then
                            repeat
                                totalamount += PaymentShceduleLine.Amount;
                                PopulateBaseAmountDetailsFromCollections(pBaseAmountHeader, MgtFeeCalcLine, MgtFeeHeader, PaymentShceduleLine, paymentmode2, Tenancycontract, pMonthFilter);
                            until PaymentShceduleLine.Next() = 0;

                    until paymentmode2.Next() = 0;

            until Tenancycontract.Next() = 0;
        exit(totalamount);
    end;

    procedure CalculateManagementFee(var MgtFeeCalcLine: Record "Management Fee Calc. Line"; MgtFeeHeader: Record "Management Fee Calc. Header"; BaseAmountHeader: Record "Base Amount Data Header"): Decimal
    var
        finalMgtFee: Decimal;
    begin
        case
            MgtFeeCalcLine."Calculation Method" of
            MgtFeeCalcLine."Calculation Method"::"Percentage of Annual Rent", MgtFeeCalcLine."Calculation Method"::"Percentage of Collections", MgtFeeCalcLine."Calculation Method"::"Percentage of Monthly Revenue":
                finalMgtFee := (MgtFeeCalcLine."Base Amount" * MgtFeeCalcLine.Percentage) / 100;
            MgtFeeCalcLine."Calculation Method"::"Per Unit Fee":
                finalMgtFee := CalculateMgtFeeFromFixedAmount(MgtFeeCalcLine, MgtFeeHeader, BaseAmountHeader);
            MgtFeeCalcLine."Calculation Method"::Hybrid:
                finalMgtFee := ((MgtFeeCalcLine."Base Amount" * MgtFeeCalcLine.Percentage) / 100) + CalculateMgtFeeFromFixedAmount(MgtFeeCalcLine, MgtFeeHeader, BaseAmountHeader);
        end;
        exit(finalMgtFee);
    end;

    procedure GetMonthFilter(pStartDate: Date; pEndDate: Date): Text
    var
        fetchMonth: Codeunit "Fetch Month";
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
        exit(monthFilter);
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

    procedure CalculateMgtFeeFromFixedAmount(var MgtFeeCalcLine: Record "Management Fee Calc. Line"; MgtFeeHeader: Record "Management Fee Calc. Header"; BaseAmountHeader: Record "Base Amount Data Header"): Decimal
    var
        tenancyContract: Record "Tenancy Contract";
        baseAmountData: Record "Base Amount Data Unit Wise";
        unitCount: Integer;
        totalAmount: Decimal;
    begin
        unitCount := 0;

        baseAmountData.SetRange("Header No.", BaseAmountHeader."Header No.");
        baseAmountData.SetRange("Line No.", BaseAmountHeader."Line No.");
        if baseAmountData.FindFirst() then begin
            baseAmountData.CalcFields("Total Quantity");
            unitCount := baseAmountData."Total Quantity";
            if unitCount <> 0 then
                totalAmount := (unitCount * MgtFeeCalcLine.Amount);
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

    procedure CreateBaseAmountDetails(pMgtFeeCalcLine: Record "Management Fee Calc. Line"): Record "Base Amount Data Header"
    var
        baseAmountHeader: Record "Base Amount Data Header";
    begin
        baseAmountHeader.Init();
        baseAmountHeader."Header No." := pMgtFeeCalcLine."Header No.";
        baseAmountHeader."Line No." := pMgtFeeCalcLine."Entry No.";

        if (pMgtFeeCalcLine."Calculation Method" = pMgtFeeCalcLine."Calculation Method"::"Per Unit Fee") or (pMgtFeeCalcLine."Calculation Method" = pMgtFeeCalcLine."Calculation Method"::Hybrid) then
            baseAmountHeader."Base Amount Type" := Format(pMgtFeeCalcLine."Calculation Method")
        else
            baseAmountHeader."Base Amount Type" := Format(pMgtFeeCalcLine."Base Amount Source");

        baseAmountHeader.Insert();
        exit(baseAmountHeader);
    end;

    procedure PopulateBaseAmountDetailsFromRevenueAndAnnualRent(var pBaseAmountHeader: Record "Base Amount Data Header"; pMgtFeeCalcLine: Record "Management Fee Calc. Line"; MgtFeeHeader: Record "Management Fee Calc. Header"; pRevenueAllocationSubgrid: Record "Revenue Allocation SubGrid"; pMonthFilter: Text)
    var
        baseAmountDetails: Record "Base Amount Data";
    begin
        if (pMgtFeeCalcLine."Calculation Method" <> pMgtFeeCalcLine."Calculation Method"::"Per Unit Fee") then begin
            baseAmountDetails.Init();
            InsertBaseAmountDetails(baseAmountDetails, pBaseAmountHeader, pMgtFeeCalcLine, MgtFeeHeader, pRevenueAllocationSubgrid, pMonthFilter);
            case
                pMgtFeeCalcLine."Base Amount Source" of
                pMgtFeeCalcLine."Base Amount Source"::Revenue:
                    baseAmountDetails."Base Amount" := pRevenueAllocationSubgrid."Total Value";
                pMgtFeeCalcLine."Base Amount Source"::"Annual Rent":
                    baseAmountDetails."Base Amount" := pRevenueAllocationSubgrid."Annual Amount" / 12;
            end;
            baseAmountDetails.Insert();
            Clear(baseAmountDetails);
        end;
    end;

    procedure PopulateBaseAmountDetailsFromCollections(var pBaseAmountHeader: Record "Base Amount Data Header"; pMgtFeeCalcLine: Record "Management Fee Calc. Line"; MgtFeeHeader: Record "Management Fee Calc. Header"; pPaymentShceduleLine: Record "Payment Schedule2"; pPaymentMode: Record "Payment Mode2"; pTenancyContract: Record "Tenancy Contract"; pMonthFilter: Text)
    var
        baseAmountDetails: Record "Base Amount Data";
        rentCalcSubPage: Record "Rent Calculation Subpage";
        rentCalcSubPage2: Record "Rent Calculation Subpage2";
    begin
        if (pMgtFeeCalcLine."Calculation Method" <> pMgtFeeCalcLine."Calculation Method"::"Per Unit Fee") then begin
            baseAmountDetails.Init();
            baseAmountDetails."Header No." := pBaseAmountHeader."Header No.";
            baseAmountDetails."Line No." := pBaseAmountHeader."Line No.";
            baseAmountDetails."Report Date" := MgtFeeHeader."Report Date";
            baseAmountDetails."Financial Year" := MgtFeeHeader."Financial Year";
            baseAmountDetails."Period From" := MgtFeeHeader."Period From";
            baseAmountDetails."Period To" := MgtFeeHeader."Period To";
            baseAmountDetails."Property Management Company" := pMgtFeeCalcLine."Property Management Company";
            baseAmountDetails."Company Owner Name" := pMgtFeeCalcLine."Company/Owner Name";
            baseAmountDetails."Property Name" := pMgtFeeCalcLine."Property Name";
            baseAmountDetails."Property Type" := pMgtFeeCalcLine."Property Type";
            baseAmountDetails."Contract Id" := pTenancyContract."Contract Id";
            baseAmountDetails."Receipt Date" := pPaymentMode."Receipt Date";
            baseAmountDetails."Receipt No." := pPaymentMode."Receipt #";

            rentCalcSubPage2.SetRange("Contract ID", pPaymentShceduleLine."Contract ID");
            rentCalcSubPage2.SetRange("Installment Start Date", pPaymentShceduleLine."Installment Start Date");
            rentCalcSubPage2.SetRange("Installment End Date", pPaymentShceduleLine."Installment End Date");
            if rentCalcSubPage2.FindFirst() then begin
                rentCalcSubPage.SetRange("Contract ID", rentCalcSubPage2."Contract ID");
                rentCalcSubPage.SetRange(Year, rentCalcSubPage2.Year);
                if rentCalcSubPage.FindFirst() then begin
                    baseAmountDetails."Multi Year Start Date" := rentCalcSubPage."Period Start Date";
                    baseAmountDetails."Multi Year End Date" := rentCalcSubPage."Period End Date";
                    baseAmountDetails."Annual Rent Amount" := rentCalcSubPage."Final Annual Amount";
                end;
            end;

            baseAmountDetails."Base Amount Source" := pBaseAmountHeader."Base Amount Type";
            baseAmountDetails."Unit Status" := 'Occupied';
            baseAmountDetails."Contract Status" := Format(pTenancyContract."Contract Status"::Active);
            if pTenancyContract."Unit ID" <> '' then begin
                baseAmountDetails.Quantity := 1;
                baseAmountDetails."Unit Number" := CopyStr(pTenancyContract."Unit ID", 1, 30);
            end
            else begin
                baseAmountDetails.Quantity := MergeUnitCount(pTenancyContract."Unit Number");
                baseAmountDetails."Unit Number" := CopyStr(pTenancyContract."Unit Number", 1, 30);
            end;
            baseAmountDetails.Month := '-';
            baseAmountDetails."Base Amount" := pPaymentShceduleLine."Amount Including VAT";
            baseAmountDetails.Insert();
            Clear(baseAmountDetails);
        end;
    end;

    procedure PopulateBaseAmountDetailsFromPerUnitFee(var pMgtFeeCalcLine: Record "Management Fee Calc. Line"; MgtFeeHeader: Record "Management Fee Calc. Header"; var pBaseAmountHeader: Record "Base Amount Data Header"; pMonthFilter: Text)
    var
        baseAmountDetails: Record "Base Amount Data Unit Wise";
        tenancyContract: Record "Tenancy Contract";
        finalCalculation: Record "Final Calculation";
        suspRec: Record SuspendReasonTable;
        fetchMonth: Codeunit "Fetch Month";
        tempDate: Date;
        effStart: Date;
        effEnd: Date;
        unitCount: Integer;
        suspFirstDay: Date;
        suspLastDay: Date;
    begin
        // Fetch contracts for the property/owner that overlap the selected period
        tenancyContract.SetRange("Property Name", pMgtFeeCalcLine."Property Name");
        tenancyContract.SetRange("Owner's Name", pMgtFeeCalcLine."Company/Owner Name");
        tenancyContract.SetFilter("Contract Start Date", '<=%1', MgtFeeHeader."Period To");
        tenancyContract.SetFilter("Contract End Date", '>=%1|%2', MgtFeeHeader."Period From", 0D);
        tenancyContract.SetFilter(tenancyContract."Tenant Contract Status", '%1|%2|%3', tenancyContract."Tenant Contract Status"::Active, tenancyContract."Tenant Contract Status"::Terminated, tenancyContract."Tenant Contract Status"::Suspended);
        if tenancyContract.FindSet() then
            repeat
                // effective start = later of contract start and report start
                if tenancyContract."Contract Start Date" > MgtFeeHeader."Period From" then
                    effStart := tenancyContract."Contract Start Date"
                else
                    effStart := MgtFeeHeader."Period From";

                // if effective start is after period end, skip this contract
                if effStart > MgtFeeHeader."Period To" then
                    continue;

                // effective end = earlier of contract end (if set) and report end
                if (tenancyContract."Contract End Date" = 0D) or (tenancyContract."Contract End Date" > MgtFeeHeader."Period To") then
                    effEnd := MgtFeeHeader."Period To"
                else
                    effEnd := tenancyContract."Contract End Date";

                // cap effective end at period end
                if effEnd > MgtFeeHeader."Period To" then
                    effEnd := MgtFeeHeader."Period To";

                // if contract is terminated, lookup final calculation and use its termination date if earlier
                if tenancyContract."Tenant Contract Status" = tenancyContract."Tenant Contract Status"::Terminated then begin
                    finalCalculation.SetRange("Contract ID", tenancyContract."Contract ID");
                    if finalCalculation.FindFirst() then
                        if (finalCalculation."Termination Date" <> 0D) and (finalCalculation."Termination Date" < effEnd) then
                            effEnd := finalCalculation."Termination Date";
                end;

                if effStart > effEnd then
                    continue;

                // determine unit count for this contract
                if tenancyContract."Unit ID" <> '' then
                    unitCount := 1
                else
                    unitCount := MergeUnitCount(tenancyContract."Unit Number");

                // iterate month-by-month within effective range and insert a record per month
                tempDate := DMY2DATE(1, Date2DMY(effStart, 2), Date2DMY(effStart, 3));
                while tempDate <= effEnd do begin
                    // check if this entire month is suspended
                    suspFirstDay := tempDate;
                    suspLastDay := CalcDate('<1M>', tempDate) - 1;
                    suspRec.SetRange("Contract ID", tenancyContract."Contract ID");
                    suspRec.SetFilter(DateEffective, '<=%1', suspFirstDay);
                    suspRec.SetFilter(SuspensionEndDate, '>=%1|%2', suspLastDay, 0D);
                    if suspRec.FindFirst() then begin
                        // entire month is suspended, skip it
                        tempDate := CalcDate('<1M>', tempDate);
                        continue;
                    end;

                    baseAmountDetails.Init();
                    baseAmountDetails."Header No." := pBaseAmountHeader."Header No.";
                    baseAmountDetails."Line No." := pBaseAmountHeader."Line No.";
                    baseAmountDetails."Report Date" := MgtFeeHeader."Report Date";
                    baseAmountDetails."Financial Year" := MgtFeeHeader."Financial Year";
                    baseAmountDetails."Period From" := MgtFeeHeader."Period From";
                    baseAmountDetails."Period To" := MgtFeeHeader."Period To";
                    baseAmountDetails."Property Management Company" := pMgtFeeCalcLine."Property Management Company";
                    baseAmountDetails."Company Owner Name" := pMgtFeeCalcLine."Company/Owner Name";
                    baseAmountDetails."Property Name" := pMgtFeeCalcLine."Property Name";
                    baseAmountDetails."Property Type" := pMgtFeeCalcLine."Property Type";
                    baseAmountDetails."Contract Id" := tenancyContract."Contract Id";
                    baseAmountDetails."Base Amount Source" := pBaseAmountHeader."Base Amount Type";
                    baseAmountDetails."Unit Status" := 'Occupied';
                    baseAmountDetails."Contract Status" := Format(tenancyContract."Tenant Contract Status");
                    if tenancyContract."Unit ID" <> '' then begin
                        baseAmountDetails.Quantity := 1;
                        baseAmountDetails."Unit Number" := CopyStr(tenancyContract."Unit ID", 1, 30);
                    end else begin
                        baseAmountDetails.Quantity := unitCount;
                        baseAmountDetails."Unit Number" := CopyStr(tenancyContract."Unit Number", 1, 30);
                    end;
                    baseAmountDetails.Month := CopyStr(fetchMonth.GetMonthName(Date2DMY(tempDate, 2)), 1, 20);
                    baseAmountDetails.Insert();
                    Clear(baseAmountDetails);

                    tempDate := CalcDate('<1M>', tempDate);
                end;
            until tenancyContract.Next() = 0;
    end;

    procedure InsertBaseAmountDetails(var pBaseAmountDetails: Record "Base Amount Data"; var pBaseAmountHeader: Record "Base Amount Data Header"; pMgtFeeCalcLine: Record "Management Fee Calc. Line"; MgtFeeHeader: Record "Management Fee Calc. Header"; pRevenueAllocationSubgrid: Record "Revenue Allocation SubGrid"; pMonthFilter: Text)
    var
        tenancyContract: Record "Tenancy Contract";
    begin
        pBaseAmountDetails."Header No." := pBaseAmountHeader."Header No.";
        pBaseAmountDetails."Line No." := pBaseAmountHeader."Line No.";
        pBaseAmountDetails."Report Date" := MgtFeeHeader."Report Date";
        pBaseAmountDetails."Financial Year" := MgtFeeHeader."Financial Year";
        pBaseAmountDetails."Period From" := MgtFeeHeader."Period From";
        pBaseAmountDetails."Period To" := MgtFeeHeader."Period To";
        pBaseAmountDetails."Property Management Company" := pMgtFeeCalcLine."Property Management Company";
        pBaseAmountDetails."Company Owner Name" := pMgtFeeCalcLine."Company/Owner Name";
        pBaseAmountDetails."Property Name" := pMgtFeeCalcLine."Property Name";
        pBaseAmountDetails."Property Type" := pMgtFeeCalcLine."Property Type";
        pBaseAmountDetails."Contract Id" := pRevenueAllocationSubgrid."Contract Id";
        pBaseAmountDetails."Multi Year Start Date" := pRevenueAllocationSubgrid."Multi Year Start Date";
        pBaseAmountDetails."Multi Year End Date" := pRevenueAllocationSubgrid."Multi Year End Date";
        pBaseAmountDetails."Annual Rent Amount" := pRevenueAllocationSubgrid."Annual Amount";
        pBaseAmountDetails."Base Amount Source" := pBaseAmountHeader."Base Amount Type";
        pBaseAmountDetails."Unit Status" := 'Occupied';
        if tenancyContract.Get(pRevenueAllocationSubgrid."Contract Id") then begin
            pBaseAmountDetails."Contract Status" := Format(tenancyContract."Contract Status"::Active);
            if tenancyContract."Unit ID" <> '' then begin
                pBaseAmountDetails.Quantity := 1;
                pBaseAmountDetails."Unit Number" := CopyStr(tenancyContract."Unit ID", 1, 30);
            end
            else begin
                pBaseAmountDetails.Quantity := MergeUnitCount(tenancyContract."Unit Number");
                pBaseAmountDetails."Unit Number" := CopyStr(tenancyContract."Unit Number", 1, 30);
            end;
        end;
        pBaseAmountDetails.Month := Format(pRevenueAllocationSubgrid."Posting Month");
    end;
}