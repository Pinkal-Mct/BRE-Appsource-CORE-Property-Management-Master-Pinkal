page 50329 "Single Unit Rent SubPage"
{
    PageType = ListPart;
    SourceTable = "Single Unit Rent SubPage";
    ApplicationArea = All;
    Caption = 'Single Unit Rent SubPage';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Proposal ID"; rec."Proposal ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays the ID of the lease proposal associated with the single unit rent subpage record.';
                }
                field("Merged Unit ID"; rec."Merged Unit ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Unique identifier for the merged unit associated with this single unit rent subpage record.';
                }
                field("Unit ID"; rec."Unit ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the unit associated with this single unit rent subpage record.';
                }
                field("Year"; rec.Year)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Year for which the rent is being calculated.';
                }
                field("Start Date"; rec."Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Start date of the rent period for this single unit rent subpage record.';
                }
                field("End Date"; rec."End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'End date of the rent period for this single unit rent subpage record.';
                }
                field("Number of Days"; Rec."Number of Days")
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
                field("Unit Sq Ft"; rec."Unit Sq Ft")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays the total number of square feet for the unit.';

                    trigger OnValidate()
                    begin
                        RecalculateAnnualAmount();
                    end;
                }

                field("Rate per Sq.Ft"; rec."Rate per Sq.Ft")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Enter the rate per square foot for the unit.';

                    trigger OnValidate()
                    var
                        PreviousYearRecord: Record "Single Unit Rent SubPage";
                        PreviousRate: Decimal;
                    begin
                        // Ensure the value is not negative
                        if Rec."Rate per Sq.Ft" < 0 then
                            Error('Rate per Sq.Ft cannot be negative.');

                        // Fetch the previous year's record to calculate Rent Increase %
                        PreviousYearRecord.SetRange("Proposal ID", Rec."Proposal ID");
                        PreviousYearRecord.SetRange("Year", Rec."Year" - 1);

                        if PreviousYearRecord.FindFirst() then begin
                            PreviousRate := PreviousYearRecord."Rate per Sq.Ft";

                            // Ensure previous rate is greater than 0 to avoid division by zero
                            if PreviousRate > 0 then
                                Rec."Rent Increase %" :=
                                    ((Rec."Rate per Sq.Ft" - PreviousRate) / PreviousRate) * 100
                            else
                                Rec."Rent Increase %" := 0; // No increase if previous rate is 0
                        end else
                            Rec."Rent Increase %" := 0; // No increase for the first year or no previous record

                        // Recalculate Annual Amount
                        if (Rec."Rate per Sq.Ft" > 0) and (Rec."Unit Sq Ft" > 0) then
                            Rec."Annual Amount" := Rec."Rate per Sq.Ft" * Rec."Unit Sq Ft"
                        else
                            Rec."Annual Amount" := 0;

                        // Set Final Annual Amount equal to Annual Amount
                        Rec."Final Annual Amount" := Rec."Annual Amount";
                        RecalculateFinalAnnualAmount();
                        // Recalculate Per Day Rent
                        RecalculatePerDayRent();

                        // Update totals
                        RecalculateTotals();

                        // Save changes
                        Rec.Modify();
                        CurrPage.Update();
                    end;
                }

                field("Rent Increase %"; Rec."Rent Increase %")
                {
                    ApplicationArea = All;
                    Caption = 'Rent Increase %';
                    ToolTip = 'Enter the rent increase percentage for this year.';

                    trigger OnValidate()
                    var
                        PreviousYearRecord: Record "Single Unit Rent SubPage";
                        IncreaseFactor: Decimal;
                    begin
                        // Ensure that Rent Increase % is not negative
                        if Rec."Rent Increase %" < 0 then
                            Error('Rent Increase % cannot be negative.');

                        // Skip calculation for the first year
                        if Rec."Year" = 1 then
                            exit;

                        // Fetch the previous year's record
                        PreviousYearRecord.SetRange("Proposal ID", Rec."Proposal ID");
                        PreviousYearRecord.SetRange("Year", Rec."Year" - 1);

                        if PreviousYearRecord.FindFirst() then begin
                            // Calculate the new rate for the current year
                            IncreaseFactor := 1 + (Rec."Rent Increase %" / 100);
                            Rec."Rate per Sq.Ft" := PreviousYearRecord."Rate per Sq.Ft" * IncreaseFactor;

                            // Recalculate Annual Amount
                            Rec."Annual Amount" := Rec."Rate per Sq.Ft" * Rec."Unit Sq Ft";

                            // Update Final Annual Amount to match Annual Amount
                            Rec."Final Annual Amount" := Rec."Annual Amount";

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


                field("Annual Amount"; Rec."Annual Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Annual Amount';
                    ToolTip = 'Displays the calculated annual amount for the year.';
                    DecimalPlaces = 2 : 2;
                }

                field("Round off"; rec."Round off")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the round off value. The Final Annual Amount will be recalculated automatically.';

                    trigger OnValidate()
                    begin
                        RecalculateFinalAnnualAmount();
                        RecalculatePerDayRent(); // Update Per Day Rent when Round Off changes
                        RecalculateTotals();     // Update totals dynamically
                    end;
                }

                field("Final Annual Amount"; Rec."Final Annual Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Final Annual Amount';
                    ToolTip = 'Displays the calculated final annual amount after applying the round off.';
                    DecimalPlaces = 2 : 2;

                    trigger OnValidate()
                    begin
                        RecalculatePerDayRent(); // Update Per Day Rent when Final Annual Amount changes
                        RecalculateTotals();     // Update totals dynamically
                    end;
                }
                field("Per Day Rent"; Rec."Per Day Rent")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Per Day Rent';
                    ToolTip = 'Displays the calculated per day rent based on the final annual amount and the number of days.';
                    DecimalPlaces = 2 : 2;
                }

            }
            group("Total Rent Caculation")
            {

                field("TotalAnnualAmount"; rec.TotalAnnualAmount)
                {
                    Caption = 'Total Contract Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Total annual amount for the contract, calculated from all entries in the subpage.';
                }

                field("TotalRoundOff"; rec.TotalRoundOff)
                {
                    Caption = 'Round Off';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Total round off amount for the contract, calculated from all entries in the subpage.';
                }

                field("TotalFinalAmount"; rec.TotalFinalAmount)
                {
                    Caption = 'Total Final Contract Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Total final annual amount for the contract, calculated from all entries in the subpage.';
                }


                field("TotalFirstAnnualAmount"; rec.TotalFirstAnnualAmount)
                {
                    Caption = 'Total Annual Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Total annual amount for the first year of the contract, calculated from all entries in the subpage.';
                }
            }
        }
    }

    local procedure RecalculateTotals()
    var

        LeaseProposalRec: Record "Lease Proposal Details";
        RecordTemp: Record "Single Unit Rent SubPage";
        lTotalAnnualAmount: Decimal;
        LTotalRoundOff: Decimal;
        LTotalFinalAmount: Decimal;
        FirstYearAnnualAmount: Decimal; // Variable for the first year's annual amount
        vatPer: Integer;
    begin
        lTotalAnnualAmount := 0;
        LTotalRoundOff := 0;
        LTotalFinalAmount := 0;
        FirstYearAnnualAmount := 0; // Initialize to 0

        // Filter records based on the current Proposal ID
        RecordTemp.SetRange("Proposal ID", Rec."Proposal ID");

        // Iterate over the filtered records
        if RecordTemp.FindSet() then
            repeat
                lTotalAnnualAmount += RecordTemp."Annual Amount";
                LTotalRoundOff += RecordTemp."Round off";
                LTotalFinalAmount += RecordTemp."Final Annual Amount";

                // Check for the first year and assign its Annual Amount
                if RecordTemp."Year" = 1 then
                    FirstYearAnnualAmount := RecordTemp."Final Annual Amount";
            until RecordTemp.Next() = 0;

        // Assign calculated totals to the fields
        Rec.TotalAnnualAmount := lTotalAnnualAmount;
        Rec.TotalRoundOff := LTotalRoundOff;
        Rec.TotalFinalAmount := LTotalFinalAmount;
        Rec.TotalFirstAnnualAmount := FirstYearAnnualAmount; // Assign the first year's annual amount

        // Update Lease Proposal Details with calculated totals
        LeaseProposalRec.SetRange("Proposal ID", Rec."Proposal ID");
        if LeaseProposalRec.FindSet() then begin
            LeaseProposalRec."Rent Amount" := FirstYearAnnualAmount; // Update Rent Amount with the first year's Final Annual Amount
            LeaseProposalRec."Annual Rent Amount" := LTotalFinalAmount; // Update Annual Rent Amount with the Total Final Amount


            if LeaseProposalRec."Rent Amount VAT %" = LeaseProposalRec."Rent Amount VAT %"::"5%" then
                vatPer := 5
            else
                vatPer := 0;

            LeaseProposalRec."Rent VAT Amount" := LeaseProposalRec."Annual Rent Amount" * (vatPer / 100);
            LeaseProposalRec."Rent Amount Including VAT" := LeaseProposalRec."Annual Rent Amount" + LeaseProposalRec."Rent VAT Amount";
            LeaseProposalRec.Modify(); // Save the changes to the Lease Proposal record
        end;

        // Modify and refresh the page
        CurrPage.Update();
    end;



    local procedure RecalculateNumberOfDays()
    var
        StartYear: Integer;
        EndYear: Integer;
        CurrentYear: Integer;
        TotalDays: Integer;
        IsLeapYearInRange: Boolean;
    begin
        // Validate Start Date and End Date
        if Rec."Start Date" = 0D then
            Error('Start Date is not valid.');
        if Rec."End Date" = 0D then
            Error('End Date is not valid.');
        if Rec."End Date" < Rec."Start Date" then
            Error('End Date cannot be earlier than Start Date.');

        // Initialize variables
        StartYear := Date2DMY(Rec."Start Date", 3); // Extract year of Start Date
        EndYear := Date2DMY(Rec."End Date", 3);    // Extract year of End Date
        TotalDays := Rec."End Date" - Rec."Start Date" + 1;
        IsLeapYearInRange := false;

        // Check each year in the range for leap year
        for CurrentYear := StartYear to EndYear do
            if IsLeapYear(CurrentYear) then
                // Ensure the leap day (Feb 29) falls within the Start and End Date
                if (DMY2Date(29, 2, CurrentYear) >= Rec."Start Date") and
                   (DMY2Date(29, 2, CurrentYear) <= Rec."End Date") then begin
                    IsLeapYearInRange := true;
                    break; // Stop checking further once a leap year is found
                end;

        // If a leap year is in range, ensure at least one year has 366 days
        if IsLeapYearInRange then
            TotalDays := TotalDays + 1;

        // Set the calculated number of days
        Rec."Number of Days" := TotalDays;

        Rec.Modify();
    end;

    local procedure IsLeapYear(pYear: Integer): Boolean
    begin
        if (pYear mod 4 = 0) and ((pYear mod 100 <> 0) or (pYear mod 400 = 0)) then
            exit(true);
        exit(false);
    end;

    local procedure RecalculateAnnualAmount()
    begin
        if Rec."Year" = 1 then begin
            if (Rec."Rate per Sq.Ft" > 0) and (Rec."Unit Sq Ft" > 0) then
                Rec."Annual Amount" := Rec."Rate per Sq.Ft" * Rec."Unit Sq Ft"
            else
                Rec."Annual Amount" := 0;
        end else
            if (Rec."Rate per Sq.Ft" > 0) and (Rec."Unit Sq Ft" > 0) then
                Rec."Annual Amount" := Rec."Rate per Sq.Ft" * Rec."Unit Sq Ft"
            else
                Rec."Annual Amount" := 0;

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
        if (Rec."Start Date" = 0D) or (Rec."End Date" = 0D) then begin
            Rec."Final Annual Amount" := Rec."Annual Amount" + Rec."Round off";
            Rec.Modify();
            CurrPage.Update();
            exit;
        end;

        if Rec."End Date" < Rec."Start Date" then
            Error('End Date cannot be earlier than Start Date.');

        YearStart := Date2DMY(Rec."Start Date", 3);
        YearEnd := Date2DMY(Rec."End Date", 3);

        // Loop through each calendar year overlapping the period
        for CurrYear := YearStart to YearEnd do begin
            YearStartDate := DMY2Date(1, 1, CurrYear);
            YearEndDate := DMY2Date(31, 12, CurrYear);

            OverlapStart := Rec."Start Date";
            if OverlapStart < YearStartDate then
                OverlapStart := YearStartDate;

            OverlapEnd := Rec."End Date";
            if OverlapEnd > YearEndDate then
                OverlapEnd := YearEndDate;

            if OverlapEnd >= OverlapStart then begin
                DaysInPeriod := OverlapEnd - OverlapStart + 1;
                // Use 366 only if the overlap for this calendar year actually includes Feb 29.
                if IsLeapYear(CurrYear) then begin
                    LeapDay := DMY2Date(29, 2, CurrYear);
                    if (OverlapStart <= LeapDay) and (OverlapEnd >= LeapDay) then
                        DaysInYear := 366
                    else
                        DaysInYear := 365;
                end else
                    DaysInYear := 365;

                ProratedAmount += (Rec."Annual Amount" * DaysInPeriod) / DaysInYear;
            end;
        end;

        // Apply round off on top of the prorated sum
        Rec."Final Annual Amount" := ProratedAmount + Rec."Round off";

        Rec.Modify();
        CurrPage.Update();
    end;

    local procedure RecalculatePerDayRent()
    begin
        if Rec."Number of Days" > 0 then
            Rec."Per Day Rent" := Rec."Final Annual Amount" / Rec."Number of Days"
        else
            Rec."Per Day Rent" := 0;

        Rec.Modify();
        CurrPage.Update();
    end;
}
