page 73209741 "BLRTCMergeSameSqureSubPage"
{
    PageType = ListPart;
    SourceTable = "BLRTCMergeSameSqureSubPage";
    ApplicationArea = All;
    Caption = 'Merge SameSqure SubPage';

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
                field("MS_Merged Unit ID"; rec."BLRMS_Merged Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Merged Unit ID';
                    Editable = false;
                    ToolTip = 'Unique identifier for the merged unit.';
                }
                field("MS_Unit ID"; rec."BLRMS_Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Unit ID';
                    Editable = false;
                    ToolTip = 'Identifier for the unit associated with the merged unit.';
                }
                field("MS_Year"; rec."BLRMS_Year")
                {
                    ApplicationArea = All;
                    Caption = 'Year';
                    Editable = false;
                    ToolTip = 'The year for which the merged unit is applicable.';
                }
                field("MS_Start Date"; rec."BLRMS_Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    Editable = false;
                    ToolTip = 'Start date of the merged unit period.';
                }
                field("MS_End Date"; rec."BLRMS_End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    Editable = false;
                    ToolTip = 'End date of the merged unit period.';
                }
                field("MS_Number of Days"; rec."BLRMS_Number of Days")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Number of Days';
                    ToolTip = 'Displays the total number of days for the period. Accounts for leap years.';
                    trigger OnValidate()
                    begin
                        RecalculateNumberOfDays();
                    end;
                }
                field("MS_Unit Sq Ft"; rec."BLRMS_Unit Sq Ft")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Sq Ft';
                    Editable = false;
                    ToolTip = 'Enter the size of the unit in square feet.';
                    trigger OnValidate()
                    begin
                        RecalculateAnnualAmount();
                    end;
                }

                field("MS_Rate per Sq.Ft"; rec."BLRMS_Rate per Sq.Ft")
                {
                    ApplicationArea = All;
                    Caption = 'Rate per Sq.Ft';
                    ToolTip = 'Enter the rate per square foot for the merged unit.';

                    trigger OnValidate()
                    var
                        PreviousYearRecord: Record "BLRCRMergeSameSqureSubPage";
                        PreviousRate: Decimal;
                    begin
                        // Ensure the value is not negative
                        if Rec."BLRMS_Rate per Sq.Ft" < 0 then
                            Error('Rate per Sq.Ft cannot be negative.');

                        // Fetch the previous year's record to calculate Rent Increase %
                        PreviousYearRecord.SetRange("BLRID", Rec."BLRID");
                        PreviousYearRecord.SetRange("BLRMS_Year", Rec."BLRMS_Year" - 1);

                        if PreviousYearRecord.FindFirst() then begin
                            PreviousRate := PreviousYearRecord."BLRMS_Rate per Sq.Ft";

                            // Ensure previous rate is greater than 0 to avoid division by zero
                            if PreviousRate > 0 then
                                Rec."BLRMS_Rent Increase %" :=
                                    ((Rec."BLRMS_Rate per Sq.Ft" - PreviousRate) / PreviousRate) * 100
                            else
                                Rec."BLRMS_Rent Increase %" := 0; // No increase if previous rate is 0
                        end else
                            Rec."BLRMS_Rent Increase %" := 0; // No increase for the first year or no previous record

                        // Recalculate Annual Amount
                        if (Rec."BLRMS_Rate per Sq.Ft" > 0) and (Rec."BLRMS_Unit Sq Ft" > 0) then
                            Rec."BLRMS_Annual Amount" := Rec."BLRMS_Rate per Sq.Ft" * Rec."BLRMS_Unit Sq Ft"
                        else
                            Rec."BLRMS_Annual Amount" := 0;

                        // Set Final Annual Amount equal to Annual Amount
                        Rec."BLRMS_Final Annual Amount" := Rec."BLRMS_Annual Amount";

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

                field("MS_Rent Increase %"; rec."BLRMS_Rent Increase %")
                {
                    ApplicationArea = All;
                    Caption = 'Rent Increase %';
                    ToolTip = 'Enter the rent increase percentage for this year.';

                    trigger OnValidate()
                    var
                        PreviousYearRecord: Record "BLRCRMergeSameSqureSubPage";
                        IncreaseFactor: Decimal;
                    begin
                        // Ensure that Rent Increase % is not negative
                        if Rec."BLRMS_Rent Increase %" < 0 then
                            Error('Rent Increase % cannot be negative.');

                        // Skip calculation for the first year
                        if Rec."BLRMS_Year" = 1 then
                            exit;

                        // Fetch the previous year's record
                        PreviousYearRecord.SetRange("BLRID", Rec."BLRID");
                        PreviousYearRecord.SetRange("BLRMS_Year", Rec."BLRMS_Year" - 1);

                        if PreviousYearRecord.FindFirst() then begin
                            // Calculate the new rate for the current year
                            IncreaseFactor := 1 + (Rec."BLRMS_Rent Increase %" / 100);
                            Rec."BLRMS_Rate per Sq.Ft" := PreviousYearRecord."BLRMS_Rate per Sq.Ft" * IncreaseFactor;

                            // Recalculate Annual Amount
                            Rec."BLRMS_Annual Amount" := Rec."BLRMS_Rate per Sq.Ft" * Rec."BLRMS_Unit Sq Ft";

                            // Update Final Annual Amount to match Annual Amount
                            Rec."BLRMS_Final Annual Amount" := Rec."BLRMS_Annual Amount";
                            RecalculateFinalAnnualAmount();

                            // Recalculate Per Day Rent
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
                field("MS_Annual Amount"; rec."BLRMS_Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Annual Amount';
                    Editable = false;
                    ToolTip = 'Displays the calculated annual amount for the year.';
                    DecimalPlaces = 2 : 2;
                }
                field("MS_Round off"; rec."BLRMS_Round off")
                {
                    ApplicationArea = All;
                    Caption = 'Round off';
                    ToolTip = 'Enter the round off value. The Final Annual Amount will be recalculated automatically.';
                    trigger OnValidate()
                    begin
                        RecalculateFinalAnnualAmount();
                        RecalculatePerDayRent(); // Update Per Day Rent when Round Off changes
                        RecalculateTotals();     // Update totals dynamically
                    end;
                }

                field("MS_Final Annual Amount"; rec."BLRMS_Final Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Final Annual Amount';
                    Editable = false;
                    ToolTip = 'Displays the calculated final annual amount after applying the round off.';
                    DecimalPlaces = 2 : 2;
                    trigger OnValidate()
                    begin
                        RecalculatePerDayRent(); // Update Per Day Rent when Final Annual Amount changes
                        RecalculateTotals();     // Update totals dynamically
                    end;
                }
                field("MS_Per Day Rent"; rec."BLRMS_Per Day Rent")
                {
                    ApplicationArea = All;
                    Caption = 'Per Day Rent';
                    Editable = false;
                    ToolTip = 'Displays the calculated per day rent based on the final annual amount and the number of days.';
                    DecimalPlaces = 2 : 2;

                }
                field("Contract ID"; rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Identifier for the associated contract.';
                }

            }

            group("Total Rent Caculation")
            {

                field("TotalAnnualAmount"; rec."BLRTotalAnnualAmount")
                {
                    Caption = 'Total Contract Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Total annual amount for the contract.';
                }

                field("TotalRoundOff"; rec."BLRTotalRoundOff")
                {
                    Caption = 'Round Off';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Total round off amount for the contract.';
                }

                field("TotalFinalAmount"; rec."BLRTotalFinalAmount")
                {
                    Caption = 'Total Final Contract Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Total final annual amount for the contract.';
                }

                field("TotalFirstAnnualAmount"; rec."BLRTotalFirstAnnualAmount")
                {
                    Caption = 'Total Annual Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Total annual amount for the first year of the contract.';
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
                ToolTip = 'Insert Data from Merge SameSqure SubPage and Sub Lease Merged Units';
                ApplicationArea = All;
                Caption = 'Insert Data';
                Image = NewDocument; // Optionally, define an icon

                trigger OnAction()
                var
                    MergeSameSquareRec: Record "BLRCRMergeSameSqureSubPage";
                    SubLeaseMergeRec: Record "BLRCRSubLeaseMergedUnits";
                    PerDayRevnue: Record "BLRCRPerDayRentforRevenue";
                    PerDayRevenueCalc: Decimal; // Variable to store the calculated revenue
                begin
                    if Rec."BLRID" = 0 then
                        Error('Proposal ID is missing or not assigned.');

                    // Fetch data from the Merge SameSqure SubPage table
                    MergeSameSquareRec.SetRange("BLRID", Rec."BLRID");

                    // Fetch data from the Sub Lease Merged Units table
                    SubLeaseMergeRec.SetRange("BLRID", Rec."BLRID");

                    // Fetch the first record from the Merge SameSqure SubPage table
                    if MergeSameSquareRec.FindSet() then
                        repeat
                            // Loop through Sub Lease Merged Units and fetch relevant data
                            if SubLeaseMergeRec.FindSet() then
                                repeat
                                    PerDayRevnue.Init();

                                    // Initialize the record in the current grid with data from both tables
                                    PerDayRevnue."BLRContract Renewal Id" := MergeSameSquareRec."BLRID";
                                    PerDayRevnue."BLRYear" := MergeSameSquareRec."BLRMS_Year"; // From Merge SameSqure SubPage
                                    PerDayRevnue."BLRSq.Ft" := SubLeaseMergeRec."BLRUnit Size"; // From Sub Lease Merged Units
                                    PerDayRevnue."BLRUnit ID" := CopyStr(SubLeaseMergeRec."BLRSingle Unit Name", 1, strlen(SubLeaseMergeRec."BLRSingle Unit Name")); // From Sub Lease Merged Units

                                    // Calculate Per Day Revenue using the updated formula
                                    if MergeSameSquareRec."BLRMS_Unit Sq Ft" = 0 then
                                        Error('MS Unit Sq Ft cannot be zero for Proposal ID %1.', MergeSameSquareRec."BLRID");

                                    // Directly calculate without rounding
                                    PerDayRevenueCalc := MergeSameSquareRec."BLRMS_Per Day Rent" * SubLeaseMergeRec."BLRUnit Size" / MergeSameSquareRec."BLRMS_Unit Sq Ft";
                                    PerDayRevnue."BLRPer Day Rent Per Unit" := PerDayRevenueCalc; // Assign the calculated value

                                    // Check if the record already exists to prevent duplicates
                                    PerDayRevnue.SetRange(BLRYear, PerDayRevnue."BLRYear");
                                    PerDayRevnue.SetRange("BLRID", PerDayRevnue."BLRID");
                                    PerDayRevnue.SetRange("BLRUnit ID", PerDayRevnue."BLRUnit ID");

                                    // Find if a record with the same ID and Unit ID already exists
                                    if PerDayRevnue.FindFirst() then
                                        // Record exists, so skip inserting
                                        Clear(PerDayRevnue)
                                    else begin
                                        // Insert the new record only if it doesn't exist
                                        PerDayRevnue.Insert();
                                        Clear(PerDayRevnue);
                                    end;

                                until SubLeaseMergeRec.Next() = 0;

                        until MergeSameSquareRec.Next() = 0

                    else
                        Error('No matching records found in Merge SameSqure SubPage for the given Proposal ID.');

                    // Refresh the current page to display updated data
                    CurrPage.Update();
                end;
            }
        }
    }
    //-----------------Calculate Total Days in Months's-----------------//

    local procedure RecalculateTotals()
    var
        LeaseProposalRec: Record "BLRContractRenewal"; // Replace with your actual Lease Proposal table name
        RecordTemp: Record "BLRCRMergeSameSqureSubPage";
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
                lTotalAnnualAmount += RecordTemp."BLRMS_Annual Amount";
                lTotalRoundOff += RecordTemp."BLRMS_Round off";
                lTotalFinalAmount += RecordTemp."BLRMS_Final Annual Amount";

                // Check for the first year and assign its Final Annual Amount
                if RecordTemp."BLRMS_Year" = 1 then
                    FirstYearAnnualAmount := RecordTemp."BLRMS_Final Annual Amount";
            until RecordTemp.Next() = 0;

        // Assign the calculated totals to the respective fields
        Rec."BLRTotalAnnualAmount" := lTotalAnnualAmount;
        Rec."BLRTotalRoundOff" := lTotalRoundOff;
        Rec."BLRTotalFinalAmount" := lTotalFinalAmount;
        Rec."BLRTotalFirstAnnualAmount" := FirstYearAnnualAmount;

        // Update Lease Proposal Details with calculated totals
        LeaseProposalRec.SetRange("BLRID", Rec."BLRID");
        if LeaseProposalRec.FindSet() then begin
            LeaseProposalRec."BLRRent Amount" := FirstYearAnnualAmount; // Update Rent Amount with the first year's Final Annual Amount
            LeaseProposalRec."BLRAnnual Rent Amount" := lTotalFinalAmount; // Update Annual Rent Amount with the Total Final Amount

            if LeaseProposalRec."BLRRent Amount VAT %" = LeaseProposalRec."BLRRent Amount VAT %"::"5%" then
                vatPer := 5
            else
                vatPer := 0;

            LeaseProposalRec."BLRRent VAT Amount" := LeaseProposalRec."BLRAnnual Rent Amount" * (vatPer / 100);
            LeaseProposalRec."BLRRent Amount Including VAT" := LeaseProposalRec."BLRAnnual Rent Amount" + LeaseProposalRec."BLRRent VAT Amount";

            LeaseProposalRec.Modify(); // Save the changes to the Lease Proposal record
        end;

        // Update the page
        CurrPage.Update();
    end;

    //-----------------Calculate No. Of Days -----------------//

    local procedure RecalculateNumberOfDays()
    var
        CurrentDate: Date;
        TotalDays: Integer;
    begin
        // Check if Start Date and End Date are valid
        if Rec."BLRMS_Start Date" = 0D then
            Error('Start Date is not valid.');
        if Rec."BLRMS_End Date" = 0D then
            Error('End Date is not valid.');
        if Rec."BLRMS_End Date" < Rec."BLRMS_Start Date" then
            Error('End Date cannot be earlier than Start Date.');

        // Initialize TotalDays
        TotalDays := 0;

        // Loop through each day between Start Date and End Date
        CurrentDate := Rec."BLRMS_Start Date";
        while CurrentDate <= Rec."BLRMS_End Date" do begin
            // Check if the current date is in a leap year and is February 29
            if IsLeapYear(Date2DMY(CurrentDate, 3)) and (Date2DMY(CurrentDate, 2) = 2) and (Date2DMY(CurrentDate, 1) = 29) then
                TotalDays += 1; // Add an extra day for February 29

            CurrentDate += 1; // Move to the next day
        end;

        // Calculate total number of days
        Rec."BLRMS_Number of Days" := Rec."BLRMS_End Date" - Rec."BLRMS_Start Date" + 1;

        // Add extra day if leap year logic applies
        Rec."BLRMS_Number of Days" += TotalDays;

        Rec.Modify();
    end;

    //-----------------Calculate No. Of Days -----------------//

    //-----------------Calculate Leap Year -----------------//

    local procedure IsLeapYear(Year: Integer): Boolean
    begin
        if (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0)) then
            exit(true);
        exit(false);
    end;

    //-----------------Calculate Leap Year -----------------//

    //-----------------Calculate Annual Amount -----------------//

    local procedure RecalculateAnnualAmount()
    begin
        if Rec."BLRMS_Year" = 1 then begin
            if (Rec."BLRMS_Rate per Sq.Ft" > 0) and (Rec."BLRMS_Unit Sq Ft" > 0) then
                Rec."BLRMS_Annual Amount" := Rec."BLRMS_Rate per Sq.Ft" * Rec."BLRMS_Unit Sq Ft"
            else
                Rec."BLRMS_Annual Amount" := 0;
        end else
            if (Rec."BLRMS_Rate per Sq.Ft" > 0) and (Rec."BLRMS_Unit Sq Ft" > 0) then
                Rec."BLRMS_Annual Amount" := Rec."BLRMS_Rate per Sq.Ft" * Rec."BLRMS_Unit Sq Ft"
            else
                Rec."BLRMS_Annual Amount" := 0;

        Rec.Modify();
        CurrPage.Update();
    end;

    //-----------------Calculate Annual Amount -----------------//

    //-----------------Calculate Final Annual Amount -----------------//


    //-----------------Calculate Final Annual Amount -----------------//

    //-----------------Calculate Per Day Rent -----------------//
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
    begin
        ProratedAmount := 0;

        // If dates are not set, set Final Annual Amount to Annual Amount + Round off
        if (Rec."BLRMS_Start Date" = 0D) or (Rec."BLRMS_End Date" = 0D) then begin
            Rec."BLRMS_Final Annual Amount" := Rec."BLRMS_Annual Amount" + Rec."BLRMS_Round off";
            Rec.Modify();
            CurrPage.Update();
            exit;
        end;

        if Rec."BLRMS_End Date" < Rec."BLRMS_Start Date" then
            Error('End Date cannot be earlier than Start Date.');

        YearStart := Date2DMY(Rec."BLRMS_Start Date", 3);
        YearEnd := Date2DMY(Rec."BLRMS_End Date", 3);

        // Loop through each calendar year overlapping the period
        for CurrYear := YearStart to YearEnd do begin
            YearStartDate := DMY2Date(1, 1, CurrYear);
            YearEndDate := DMY2Date(31, 12, CurrYear);

            OverlapStart := Rec."BLRMS_Start Date";
            if OverlapStart < YearStartDate then
                OverlapStart := YearStartDate;

            OverlapEnd := Rec."BLRMS_End Date";
            if OverlapEnd > YearEndDate then
                OverlapEnd := YearEndDate;

            if OverlapEnd >= OverlapStart then begin
                DaysInPeriod := OverlapEnd - OverlapStart + 1;
                if IsLeapYear(CurrYear) then
                    DaysInYear := 366
                else
                    DaysInYear := 365;

                ProratedAmount += (Rec."BLRMS_Annual Amount" * DaysInPeriod) / DaysInYear;
            end;
        end;

        // Apply round off on top of the prorated sum
        Rec."BLRMS_Final Annual Amount" := ProratedAmount + Rec."BLRMS_Round off";

        Rec.Modify();
        CurrPage.Update();
    end;


    local procedure RecalculatePerDayRent()
    begin
        if Rec."BLRMS_Number of Days" > 0 then
            Rec."BLRMS_Per Day Rent" := Rec."BLRMS_Final Annual Amount" / Rec."BLRMS_Number of Days"
        else
            Rec."BLRMS_Per Day Rent" := 0;

        Rec.Modify();
        CurrPage.Update();
    end;

    //-----------------Calculate Per Day Rent -----------------//

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
