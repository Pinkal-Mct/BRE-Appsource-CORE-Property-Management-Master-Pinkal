page 73209682 "BLRCRMergeDifferentSqSubPage"
{
    PageType = ListPart;
    SourceTable = "BLRCRMergeDifferentSqSubPage";
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
                    ToolTip = 'The ID of the merged unit associated with this record.';
                }
                field("MD_Unit ID"; rec."BLRMD_Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Unit ID';
                    Editable = false;
                    ToolTip = 'The ID of the unit associated with this record.';
                }
                field("MD_Year"; rec."BLRMD_Year")
                {
                    ApplicationArea = All;
                    Caption = 'Year';
                    Editable = false;
                    ToolTip = 'The year for which this record is applicable.';
                }
                field("MD_Start Date"; rec."BLRMD_Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    Editable = false;
                    ToolTip = 'The start date of the contract or lease for this record.';
                }
                field("MD_End Date"; rec."BLRMD_End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    Editable = false;
                    ToolTip = 'The end date of the contract or lease for this record.';
                }
                field("MD_Number of Days"; rec."BLRMD_Number of Days")
                {
                    ApplicationArea = All;
                    Caption = 'Number of Days';
                    Editable = false;
                    ToolTip = 'The number of days in the contract or lease for this record.';

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
                    ToolTip = 'The square footage of the unit associated with this record.';

                    trigger OnValidate()
                    begin
                        RecalculateAnnualAmount();
                    end;
                }
                field("MD_Rate per Sq.Ft"; rec."BLRMD_Rate per Sq.Ft")
                {
                    ApplicationArea = All;
                    Caption = 'Rate per Sq.Ft';
                    ToolTip = 'The rate per square foot for the unit associated with this record.';

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
                    ToolTip = 'The rent increase percentage for the unit associated with this record.';

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
                    ToolTip = 'The annual amount calculated based on the rate per square foot and unit size.';
                }
                field("MD_Round off"; rec."BLRMD_Round off")
                {
                    ApplicationArea = All;
                    Caption = 'Round off';
                    Editable = true;
                    ToolTip = 'The amount to round off the final annual amount.';

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
                    ToolTip = 'The final annual amount after applying any round off.';

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
                    ToolTip = 'The per day rent calculated based on the final annual amount and number of days.';
                }

            }

            group("Total Rent Caculation")
            {

                field("TotalAnnualAmount"; rec."BLRTotalAnnualAmount")
                {
                    Caption = 'Total Contract Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Total Contract Amount for all years based on the calculated annual amounts.';
                }

                field("TotalRoundOff"; rec."BLRTotalRoundOff")
                {
                    Caption = 'Round Off';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Total Round Off amount for all years based on the calculated round off values.';
                }

                field("TotalFinalAmount"; rec."BLRTotalFinalAmount")
                {
                    Caption = 'Total Final Contract Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Total Final Contract Amount for all years after applying round off.';
                }

                field("TotalFirstAnnualAmount"; rec."BLRTotalFirstAnnualAmount")
                {
                    Caption = 'Total Annual Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Total Annual Amount for the first year based on the calculated annual amounts.';
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
                ToolTip = 'Insert Data from Merge Different Square SubPage';
                ApplicationArea = All;
                Caption = 'Insert Data';
                Image = NewDocument; // Optionally, define an icon

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
            LeaseProposalRec."BLRContract Amount" := lTotalFinalAmount; // Update Annual Rent Amount with the total of all years' Final Annual Amounts

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
    begin
        if Rec."BLRMD_Round off" = 0 then
            Rec."BLRMD_Final Annual Amount" := Rec."BLRMD_Annual Amount"
        else
            Rec."BLRMD_Final Annual Amount" := Rec."BLRMD_Annual Amount" + Rec."BLRMD_Round off";

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
}

