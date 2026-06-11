page 73209739 "BLRTCMergeDifferentSqSubPage"
{
    PageType = ListPart;
    SourceTable = "BLRTCMergeDifferentSqSubPage";
    ApplicationArea = All;
    Caption = 'Merge DifferentSqure SubPage';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID"; rec."BLRID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the record.';
                }
                field("MD_Merged Unit ID"; rec."BLRMD_Merged Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Merged Unit ID';
                    Editable = false;
                    ToolTip = 'Unique identifier for the merged unit.';
                }
                field("MD_Unit ID"; rec."BLRMD_Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Unit ID';
                    Editable = false;
                    ToolTip = 'Unique identifier for the unit.';
                }
                field("MD_Year"; rec."BLRMD_Year")
                {
                    ApplicationArea = All;
                    Caption = 'Year';
                    Editable = false;
                    ToolTip = 'Year for which the record is applicable.';
                }
                field("MD_Start Date"; rec."BLRMD_Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    Editable = false;
                    ToolTip = 'Start date of the period for which the record is applicable.';
                }
                field("MD_End Date"; rec."BLRMD_End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    Editable = false;
                    ToolTip = 'End date of the period for which the record is applicable.';
                }
                field("MD_Number of Days"; rec."BLRMD_Number of Days")
                {
                    ApplicationArea = All;
                    Caption = 'Number of Days';
                    Editable = false;
                    ToolTip = 'Total number of days in the period defined by Start Date and End Date.';

                    trigger OnValidate()
                    begin
                        RecalculateNumberOfDays();
                    end;
                }
                field("MD_Unit Sq Ft"; rec."BLRMD_Unit Sq Ft")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Sq Ft';
                    Editable = false;
                    ToolTip = 'Size of the unit in square feet.';

                    trigger OnValidate()
                    begin
                        RecalculateAnnualAmount();
                    end;
                }
                field("MD_Rate per Sq.Ft"; rec."BLRMD_Rate per Sq.Ft")
                {
                    ApplicationArea = All;
                    Caption = 'Rate per Sq.Ft';
                    ToolTip = 'Rate per square foot for the unit.';

                    trigger OnValidate()
                    var
                        PreviousYearRecord: Record "BLRCRMergeDifferentSqSubPage";
                        PreviousRate: Decimal;
                    begin
                        // Ensure the value is not negative
                        if Rec."BLRMD_Rate per Sq.Ft" < 0 then
                            Error('Rate per Sq.Ft cannot be negative.');

                        // Fetch the previous year's record to calculate Rent Increase %
                        PreviousYearRecord.SetRange("BLRID", Rec."BLRID");
                        PreviousYearRecord.SetRange("BLRMD_Year", Rec."BLRMD_Year" - 1);
                        PreviousYearRecord.SetRange("BLRMD_Unit ID", Rec."BLRMD_Unit ID");

                        if PreviousYearRecord.FindFirst() then begin
                            PreviousRate := PreviousYearRecord."BLRMD_Rate per Sq.Ft";

                            // Ensure previous rate is greater than 0 to avoid division by zero
                            if PreviousRate > 0 then
                                Rec."BLRMD_Rent Increase %" :=
                                    ((Rec."BLRMD_Rate per Sq.Ft" - PreviousRate) / PreviousRate) * 100
                            else
                                Rec."BLRMD_Rent Increase %" := 0; // No increase if previous rate is 0
                        end else
                            Rec."BLRMD_Rent Increase %" := 0; // No increase for the first year or no previous record

                        // Recalculate Annual Amount
                        if (Rec."BLRMD_Rate per Sq.Ft" > 0) and (Rec."BLRMD_Unit Sq Ft" > 0) then
                            Rec."BLRMD_Annual Amount" := Rec."BLRMD_Rate per Sq.Ft" * Rec."BLRMD_Unit Sq Ft"
                        else
                            Rec."BLRMD_Annual Amount" := 0;

                        // Set Final Annual Amount equal to Annual Amount
                        Rec."BLRMD_Final Annual Amount" := Rec."BLRMD_Annual Amount";

                        // Recalculate Per Day Rent
                        RecalculateFinalAnnualAmount();

                        RecalculatePerDayRent();

                        // Recalculate totals dynamically
                        RecalculateTotals();

                        // Save changes
                        Rec.Modify();
                        CurrPage.Update();
                    end;
                }

                field("MD_Rent Increase %"; rec."BLRMD_Rent Increase %")
                {
                    ApplicationArea = All;
                    Caption = 'Rent Increase %';
                    ToolTip = 'Percentage increase in rent compared to the previous year.';

                    trigger OnValidate()
                    var
                        PreviousYearRecord: Record "BLRCRMergeDifferentSqSubPage";
                        IncreaseFactor: Decimal;
                    begin
                        // Ensure that Rent Increase % is not negative
                        if Rec."BLRMD_Rent Increase %" < 0 then
                            Error('Rent Increase % cannot be negative.');

                        // Skip calculation for the first year
                        if Rec."BLRMD_Year" = 1 then
                            exit;

                        // Fetch the previous year's record
                        PreviousYearRecord.SetRange("BLRID", Rec."BLRID");
                        PreviousYearRecord.SetRange("BLRMD_Year", Rec."BLRMD_Year" - 1);
                        PreviousYearRecord.SetRange("BLRMD_Unit ID", Rec."BLRMD_Unit ID");

                        if PreviousYearRecord.FindFirst() then begin
                            // Calculate the new rate for the current year
                            IncreaseFactor := 1 + (Rec."BLRMD_Rent Increase %" / 100);
                            Rec."BLRMD_Rate per Sq.Ft" := PreviousYearRecord."BLRMD_Rate per Sq.Ft" * IncreaseFactor;

                            // Recalculate Annual Amount
                            Rec."BLRMD_Annual Amount" := Rec."BLRMD_Rate per Sq.Ft" * Rec."BLRMD_Unit Sq Ft";

                            // Update Final Annual Amount to match Annual Amount
                            Rec."BLRMD_Final Annual Amount" := Rec."BLRMD_Annual Amount";

                            // Recalculate Per Day Rent
                            RecalculateFinalAnnualAmount();

                            RecalculatePerDayRent();
                        end else
                            Error('No record found for the previous year to base the calculation.');

                        // Recalculate totals dynamically
                        RecalculateTotals();

                        // Save changes
                        Rec.Modify();
                        CurrPage.Update();
                    end;
                }
                field("MD_Annual Amount"; rec."BLRMD_Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Annual Amount';
                    Editable = false;
                    ToolTip = 'Total annual amount calculated based on Rate per Sq.Ft and Unit Size.';
                }
                field("MD_Round off"; rec."BLRMD_Round off")
                {
                    ApplicationArea = All;
                    Caption = 'Round off';
                    Editable = false;
                    ToolTip = 'Round off amount to adjust the final annual amount.';

                    trigger OnValidate()
                    begin
                        RecalculateFinalAnnualAmount();
                        RecalculatePerDayRent(); // Update Per Day Rent when Round Off changes
                        RecalculateTotals();     // Update totals dynamically
                    end;
                }
                field("MD_Final Annual Amount"; rec."BLRMD_Final Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Final Annual Amount';
                    Editable = false;
                    ToolTip = 'Final annual amount after adding the round off amount.';

                    trigger OnValidate()
                    begin
                        RecalculatePerDayRent(); // Update Per Day Rent when Final Annual Amount changes
                        RecalculateTotals();     // Update totals dynamically
                    end;
                }
                field("MD_Per Day Rent"; rec."BLRMD_Per Day Rent")
                {
                    ApplicationArea = All;
                    Caption = 'Per Day Rent';
                    Editable = false;
                    DecimalPlaces = 2 : 2;
                    ToolTip = 'Per day rent calculated based on Final Annual Amount and Number of Days.';
                }

                field("Contract ID"; rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Identifier for the contract associated with this record.';
                }
            }

            group("Total Rent Caculation")
            {
                field("TotalAnnualAmount"; rec."BLRTotalAnnualAmount")
                {
                    Caption = 'Total Contract Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Total annual amount for all years in the contract.';
                }

                field("TotalRoundOff"; rec."BLRTotalRoundOff")
                {
                    Caption = 'Round Off';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Total round off amount for all years in the contract.';
                }

                field("TotalFinalAmount"; rec."BLRTotalFinalAmount")
                {
                    Caption = 'Total Final Contract Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Total final annual amount for all years in the contract after applying round off.';
                }

                field("TotalFirstAnnualAmount"; rec."BLRTotalFirstAnnualAmount")
                {
                    Caption = 'Total Annual Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Total annual amount for the first year in the contract.';
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(InsertData)
            {
                ApplicationArea = All;
                Caption = 'Insert Data';
                Image = NewDocument; // Optionally, define an icon
                ToolTip = 'Insert data from Merge DifferentSquare SubPage and Sub Lease Merged Units into Per Day Rent for Revenue.';

                trigger OnAction()
                var
                    MergeDiffSquareRec: Record "BLRCRMergeDifferentSqSubPage";
                    MergeDiffSquareRecFromPerDayRevenue: Record "BLRCRMergeDifferentSqSubPage";
                    SubLeaseMergeRec: Record "BLRCRSubLeaseMergedUnits";
                    PerDayRevnue: Record "BLRCRPerDayRentforRevenue";
                    YearList: List of [Integer];
                    YearItem: Integer;
                begin
                    if Rec."BLRID" = 0 then
                        Error('Proposal ID is missing or not assigned.');

                    // Fetch distinct years from the Merge DifferentSqure SubPage table
                    MergeDiffSquareRec.SetRange("BLRID", Rec."BLRID");
                    if MergeDiffSquareRec.FindSet() then
                        repeat
                            if not YearList.Contains(MergeDiffSquareRec."BLRMD_Year") then
                                YearList.Add(MergeDiffSquareRec."BLRMD_Year");
                        until MergeDiffSquareRec.Next() = 0
                    else
                        Error('No matching records found in Merge DifferentSqure SubPage for the given Proposal ID.');

                    // Loop through each year and fetch corresponding data
                    foreach YearItem in YearList do begin
                        MergeDiffSquareRec.SetRange("BLRID", Rec."BLRID");
                        MergeDiffSquareRec.SetRange("BLRMD_Year", YearItem);

                        if MergeDiffSquareRec.FindSet() then
                            repeat
                                // Loop through Sub Lease Merged Units and fetch relevant data
                                SubLeaseMergeRec.SetRange("BLRID", Rec."BLRID");
                                if SubLeaseMergeRec.FindSet() then
                                    repeat
                                        PerDayRevnue.Init();

                                        // Initialize the record in the current grid with data from both tables
                                        PerDayRevnue."BLRContract Renewal Id" := MergeDiffSquareRec."BLRID";
                                        PerDayRevnue."BLRYear" := MergeDiffSquareRec."BLRMD_Year"; // From Merge DifferentSquare SubPage
                                        PerDayRevnue."BLRSq.Ft" := SubLeaseMergeRec."BLRUnit Size"; // From Sub Lease Merged Units
                                        PerDayRevnue."BLRUnit ID" := CopyStr(SubLeaseMergeRec."BLRSingle Unit Name", 1, strlen(SubLeaseMergeRec."BLRSingle Unit Name")); // From Sub Lease Merged Units

                                        MergeDiffSquareRecFromPerDayRevenue.SetRange("BLRMD_Unit ID", PerDayRevnue."BLRUnit ID");
                                        if MergeDiffSquareRecFromPerDayRevenue.FindFirst() then
                                            // Directly assign the Per Day Rent value from MergeDiffSquareRec table to PerDayRevnue
                                            PerDayRevnue."BLRPer Day Rent Per Unit" := MergeDiffSquareRecFromPerDayRevenue."BLRMD_Per Day Rent";

                                        // Check if the record already exists to prevent duplicates
                                        PerDayRevnue.SetRange(BLRYear, PerDayRevnue."BLRYear");
                                        PerDayRevnue.SetRange("BLRID", PerDayRevnue."BLRID");
                                        PerDayRevnue.SetRange("BLRUnit ID", PerDayRevnue."BLRUnit ID");
                                        if not PerDayRevnue.FindFirst() then begin
                                            // Insert the new record only if it doesn't exist
                                            PerDayRevnue.Insert();
                                            Clear(PerDayRevnue);
                                        end;

                                    until SubLeaseMergeRec.Next() = 0;

                            until MergeDiffSquareRec.Next() = 0;

                    end;

                    // Refresh the current page to display updated data
                    CurrPage.Update();
                end;
            }
        }
    }


    local procedure RecalculateTotals()
    var
        LeaseProposalRec: Record "BLRContractRenewal"; // Replace with your actual Lease Proposal table name
        RecordTemp: Record "BLRCRMergeDifferentSqSubPage";
        lTotalAnnualAmount: Decimal;
        lTotalRoundOff: Decimal;
        lTotalFinalAmount: Decimal;
        FirstYearAnnualAmount: Decimal; // Variable for the first year's annual amount
        vatPer: Integer;
    begin
        lTotalAnnualAmount := 0;
        lTotalRoundOff := 0;
        lTotalFinalAmount := 0;
        FirstYearAnnualAmount := 0; // Initialize to 0

        // Filter records by the current Proposal ID
        RecordTemp.SetRange("BLRID", Rec."BLRID");

        // Sum up the values for the filtered records
        if RecordTemp.FindSet() then
            repeat
                lTotalAnnualAmount += RecordTemp."BLRMD_Annual Amount";
                lTotalRoundOff += RecordTemp."BLRMD_Round off";
                lTotalFinalAmount += RecordTemp."BLRMD_Final Annual Amount";

                // Check for the first year and add its Final Annual Amount to FirstYearAnnualAmount
                if RecordTemp."BLRMD_Year" = 1 then
                    FirstYearAnnualAmount += RecordTemp."BLRMD_Final Annual Amount"; // Sum all Final Annual Amounts for 1st Year
            until RecordTemp.Next() = 0;

        // Assign the calculated totals to the respective fields
        Rec."BLRTotalAnnualAmount" := lTotalAnnualAmount;
        Rec."BLRTotalRoundOff" := lTotalRoundOff;
        Rec."BLRTotalFinalAmount" := lTotalFinalAmount;
        Rec."BLRTotalFirstAnnualAmount" := FirstYearAnnualAmount;
        rec.Modify();

        // Update Lease Proposal Details with calculated totals
        LeaseProposalRec.SetRange("BLRID", Rec."BLRID");
        if LeaseProposalRec.FindSet() then begin
            LeaseProposalRec."BLRRent Amount" := FirstYearAnnualAmount; // Update Rent Amount with the sum of first year's Final Annual Amount
            LeaseProposalRec."BLRAnnual Rent Amount" := lTotalFinalAmount; // Update Annual Rent Amount with the total of all years' Final Annual Amounts

            if LeaseProposalRec."BLRRent Amount VAT %" = LeaseProposalRec."BLRRent Amount VAT %"::"5%" then
                vatPer := 5
            else
                vatPer := 0;

            LeaseProposalRec."BLRRent VAT Amount" := LeaseProposalRec."BLRAnnual Rent Amount" * (vatPer / 100);
            LeaseProposalRec."BLRRent Amount Including VAT" := LeaseProposalRec."BLRAnnual Rent Amount" + LeaseProposalRec."BLRRent VAT Amount";

            LeaseProposalRec.Modify(); // Save the changes to the Lease Proposal record
        end;

        // Update the page to reflect changes
        CurrPage.Update();
    end;

    local procedure RecalculateNumberOfDays()
    var
        CurrentDate: Date;
        TotalDays: Integer;
    begin
        // Check if Start Date and End Date are valid
        if Rec."BLRMD_Start Date" = 0D then
            Error('Start Date is not valid.');
        if Rec."BLRMD_End Date" = 0D then
            Error('End Date is not valid.');
        if Rec."BLRMD_End Date" < Rec."BLRMD_Start Date" then
            Error('End Date cannot be earlier than Start Date.');

        // Initialize TotalDays
        TotalDays := 0;

        // Loop through each day between Start Date and End Date
        CurrentDate := Rec."BLRMD_Start Date";
        while CurrentDate <= Rec."BLRMD_End Date" do begin
            // Check if the current date is in a leap year and is February 29
            if IsLeapYear(Date2DMY(CurrentDate, 3)) and (Date2DMY(CurrentDate, 2) = 2) and (Date2DMY(CurrentDate, 1) = 29) then
                TotalDays += 1; // Add an extra day for February 29

            CurrentDate += 1; // Move to the next day
        end;

        // Calculate total number of days
        Rec."BLRMD_Number of Days" := Rec."BLRMD_End Date" - Rec."BLRMD_Start Date" + 1;

        // Add extra day if leap year logic applies
        Rec."BLRMD_Number of Days" += TotalDays;

        Rec.Modify();
    end;

    local procedure IsLeapYear(Year: Integer): Boolean
    begin
        if (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0)) then
            exit(true);
        exit(false);
    end;

    local procedure RecalculateAnnualAmount()
    begin
        if Rec."BLRMD_Year" = 1 then begin
            if (Rec."BLRMD_Rate per Sq.Ft" > 0) and (Rec."BLRMD_Unit Sq Ft" > 0) then
                Rec."BLRMD_Annual Amount" := Rec."BLRMD_Rate per Sq.Ft" * Rec."BLRMD_Unit Sq Ft"
            else
                Rec."BLRMD_Annual Amount" := 0;
        end else
            if (Rec."BLRMD_Rate per Sq.Ft" > 0) and (Rec."BLRMD_Unit Sq Ft" > 0) then
                Rec."BLRMD_Annual Amount" := Rec."BLRMD_Rate per Sq.Ft" * Rec."BLRMD_Unit Sq Ft"
            else
                Rec."BLRMD_Annual Amount" := 0;

        Rec.Modify();
        CurrPage.Update();
    end;

    local procedure RecalculateFinalAnnualAmount()
    var
        YearStart: Integer;
        YearEnd: Integer;
        CurrYear: Integer;
        YearStartDate: Date;
        YearEndDate: Date;
        OverlapStart: Date;
        OverlapEnd: Date;
        DaysInYear: Integer;
        DaysInPeriod: Integer;
        ProratedAmount: Decimal;
        LeapDay: Date;
    begin
        ProratedAmount := 0;

        // If dates are not set, set Final Annual Amount to Annual Amount + Round off
        if (Rec."BLRMD_Start Date" = 0D) or (Rec."BLRMD_End Date" = 0D) then begin
            Rec."BLRMD_Final Annual Amount" := Rec."BLRMD_Annual Amount" + Rec."BLRMD_Round off";
            Rec.Modify();
            CurrPage.Update();
            exit;
        end;

        if Rec."BLRMD_End Date" < Rec."BLRMD_Start Date" then
            Error('End Date cannot be earlier than Start Date.');

        YearStart := Date2DMY(Rec."BLRMD_Start Date", 3);
        YearEnd := Date2DMY(Rec."BLRMD_End Date", 3);

        // Loop through each calendar year overlapping the period
        for CurrYear := YearStart to YearEnd do begin
            YearStartDate := DMY2Date(1, 1, CurrYear);
            YearEndDate := DMY2Date(31, 12, CurrYear);

            OverlapStart := Rec."BLRMD_Start Date";
            if OverlapStart < YearStartDate then
                OverlapStart := YearStartDate;

            OverlapEnd := Rec."BLRMD_End Date";
            if OverlapEnd > YearEndDate then
                OverlapEnd := YearEndDate;

            if OverlapEnd >= OverlapStart then begin
                DaysInPeriod := OverlapEnd - OverlapStart + 1;
                if IsLeapYear(CurrYear) then begin
                    LeapDay := DMY2Date(29, 2, CurrYear);
                    if (OverlapStart <= LeapDay) and (OverlapEnd >= LeapDay) then
                        DaysInYear := 366
                    else
                        DaysInYear := 365;
                end else
                    DaysInYear := 365;

                ProratedAmount += (Rec."BLRMD_Annual Amount" * DaysInPeriod) / DaysInYear;
            end;
        end;

        // Apply round off on top of the prorated sum
        Rec."BLRMD_Final Annual Amount" := ProratedAmount + Rec."BLRMD_Round off";

        Rec.Modify();
        CurrPage.Update();
    end;


    local procedure RecalculatePerDayRent()
    begin
        if Rec."BLRMD_Number of Days" > 0 then
            Rec."BLRMD_Per Day Rent" := Rec."BLRMD_Final Annual Amount" / Rec."BLRMD_Number of Days"
        else
            Rec."BLRMD_Per Day Rent" := 0;

        Rec.Modify();
        CurrPage.Update();
    end;

    procedure SetContractIDs(pContractID: Integer)
    begin
        ContractID := pContractID;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."BLRContract ID" := ContractID;

    end;

    var
        ContractID: Integer;

}