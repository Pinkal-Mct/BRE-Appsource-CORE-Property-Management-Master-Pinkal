page 73209687 "BLRCRSingleUnitRentSubPage"
{
    PageType = ListPart;
    SourceTable = "BLRCRSingleUnitRentSubPage";
    ApplicationArea = All;
    Caption = 'Single Unit Rent SubPage';

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
                field("Merged Unit ID"; rec."BLRMerged Unit ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Unique identifier for the merged unit.';
                }
                field("Unit ID"; rec."BLRUnit ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the unit associated with this rent record.';
                }
                field("Year"; rec."BLRYear")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Year for which the rent is calculated.';
                }
                field("Start Date"; rec."BLRStart Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Start date of the rent period.';
                }
                field("End Date"; rec."BLREnd Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'End date of the rent period. This is calculated based on the start date and number of days.';
                }
                field("Number of Days"; Rec."BLRNumber of Days")
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
                field("Unit Sq Ft"; rec."BLRUnit Sq Ft")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Square footage of the unit for which the rent is calculated.';

                    trigger OnValidate()
                    begin
                        RecalculateAnnualAmount();
                    end;
                }

                field("Rate per Sq.Ft"; rec."BLRRate per Sq.Ft")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Enter the rate per square foot for the unit. This will be used to calculate the annual amount.';

                    trigger OnValidate()
                    var
                        PreviousYearRecord: Record "BLRCRSingleUnitRentSubPage";
                        PreviousRate: Decimal;
                    begin
                        // Ensure the value is not negative
                        if Rec."BLRRate per Sq.Ft" < 0 then
                            Error('Rate per Sq.Ft cannot be negative.');

                        // Fetch the previous year's record to calculate Rent Increase %
                        PreviousYearRecord.SetRange("BLRID", Rec."BLRID");
                        PreviousYearRecord.SetRange("BLRYear", Rec."BLRYear" - 1);

                        if PreviousYearRecord.FindFirst() then begin
                            PreviousRate := PreviousYearRecord."BLRRate per Sq.Ft";

                            // Ensure previous rate is greater than 0 to avoid division by zero
                            if PreviousRate > 0 then
                                Rec."BLRRent Increase %" :=
                                    ((Rec."BLRRate per Sq.Ft" - PreviousRate) / PreviousRate) * 100
                            else
                                Rec."BLRRent Increase %" := 0; // No increase if previous rate is 0
                        end else
                            Rec."BLRRent Increase %" := 0; // No increase for the first year or no previous record

                        // Recalculate Annual Amount
                        if (Rec."BLRRate per Sq.Ft" > 0) and (Rec."BLRUnit Sq Ft" > 0) then
                            Rec."BLRAnnual Amount" := Rec."BLRRate per Sq.Ft" * Rec."BLRUnit Sq Ft"
                        else
                            Rec."BLRAnnual Amount" := 0;

                        // Set Final Annual Amount equal to Annual Amount
                        Rec."BLRFinal Annual Amount" := Rec."BLRAnnual Amount";

                        // Recalculate Per Day Rent
                        RecalculatePerDayRent();

                        // Update totals
                        RecalculateTotals();

                        // Save changes
                        Rec.Modify();
                        CurrPage.Update();
                    end;
                }

                field("Rent Increase %"; Rec."BLRRent Increase %")
                {
                    ApplicationArea = All;
                    Caption = 'Rent Increase %';
                    ToolTip = 'Enter the rent increase percentage for this year.';

                    trigger OnValidate()
                    var
                        PreviousYearRecord: Record "BLRCRSingleUnitRentSubPage";
                        IncreaseFactor: Decimal;
                    begin
                        // Ensure that Rent Increase % is not negative
                        if Rec."BLRRent Increase %" < 0 then
                            Error('Rent Increase % cannot be negative.');

                        // Skip calculation for the first year
                        if Rec."BLRYear" = 1 then
                            exit;

                        // Fetch the previous year's record
                        PreviousYearRecord.SetRange("BLRID", Rec."BLRID");
                        PreviousYearRecord.SetRange("BLRYear", Rec."BLRYear" - 1);

                        if PreviousYearRecord.FindFirst() then begin
                            // Calculate the new rate for the current year
                            IncreaseFactor := 1 + (Rec."BLRRent Increase %" / 100);
                            Rec."BLRRate per Sq.Ft" := PreviousYearRecord."BLRRate per Sq.Ft" * IncreaseFactor;

                            // Recalculate Annual Amount
                            Rec."BLRAnnual Amount" := Rec."BLRRate per Sq.Ft" * Rec."BLRUnit Sq Ft";

                            // Update Final Annual Amount to match Annual Amount
                            Rec."BLRFinal Annual Amount" := Rec."BLRAnnual Amount";

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


                field("Annual Amount"; Rec."BLRAnnual Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Annual Amount';
                    ToolTip = 'Displays the calculated annual amount for the year.';
                    DecimalPlaces = 2 : 2;
                }

                field("Round off"; rec."BLRRound off")
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

                field("Final Annual Amount"; Rec."BLRFinal Annual Amount")
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
                field("Per Day Rent"; Rec."BLRPer Day Rent")
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

                field("TotalAnnualAmount"; rec."BLRTotalAnnualAmount")
                {
                    Caption = 'Total Contract Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Displays the total annual amount for all records in the current proposal.';
                }

                field("TotalRoundOff"; rec."BLRTotalRoundOff")
                {
                    Caption = 'Round Off';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Displays the total round off amount for all records in the current proposal.';
                }

                field("TotalFinalAmount"; rec."BLRTotalFinalAmount")
                {
                    Caption = 'Total Final Contract Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Displays the total final annual amount for all records in the current proposal.';
                }

                field("TotalFirstAnnualAmount"; rec."BLRTotalFirstAnnualAmount")
                {
                    Caption = 'Total Annual Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Displays the total first year annual amount for all records in the current proposal.';
                }
            }
        }
    }

    local procedure RecalculateTotals()
    var

        LeaseProposalRec: Record "BLRContractRenewal";
        RecordTemp: Record "BLRCRSingleUnitRentSubPage";
        lTotalAnnualAmount: Decimal;
        lTotalRoundOff: Decimal;
        lTotalFinalAmount: Decimal;
        FirstYearAnnualAmount: Decimal; // Variable for the first year's annual amount

    begin
        lTotalAnnualAmount := 0;
        lTotalRoundOff := 0;
        lTotalFinalAmount := 0;
        FirstYearAnnualAmount := 0; // Initialize to 0

        // Filter records based on the current Proposal ID
        RecordTemp.SetRange("BLRID", Rec."BLRID");

        // Iterate over the filtered records
        if RecordTemp.FindSet() then
            repeat
                lTotalAnnualAmount += RecordTemp."BLRAnnual Amount";
                lTotalRoundOff += RecordTemp."BLRRound off";
                lTotalFinalAmount += RecordTemp."BLRFinal Annual Amount";

                // Check for the first year and assign its Annual Amount
                if RecordTemp."BLRYear" = 1 then
                    FirstYearAnnualAmount := RecordTemp."BLRFinal Annual Amount";
            until RecordTemp.Next() = 0;

        // Assign calculated totals to the fields
        Rec."BLRTotalAnnualAmount" := lTotalAnnualAmount;
        Rec."BLRTotalRoundOff" := lTotalRoundOff;
        Rec."BLRTotalFinalAmount" := lTotalFinalAmount;
        Rec."BLRTotalFirstAnnualAmount" := FirstYearAnnualAmount; // Assign the first year's annual amount

        // Update Lease Proposal Details with calculated totals
        LeaseProposalRec.SetRange("BLRID", Rec."BLRID");
        if LeaseProposalRec.FindSet() then begin
            LeaseProposalRec."BLRRent Amount" := FirstYearAnnualAmount; // Update Rent Amount with the first year's Final Annual Amount
            LeaseProposalRec."BLRContract Amount" := lTotalFinalAmount; // Update Annual Rent Amount with the Total Final Amount

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
        if Rec."BLRStart Date" = 0D then
            Error('Start Date is not valid.');
        if Rec."BLREnd Date" = 0D then
            Error('End Date is not valid.');
        if Rec."BLREnd Date" < Rec."BLRStart Date" then
            Error('End Date cannot be earlier than Start Date.');

        // Initialize variables
        StartYear := Date2DMY(Rec."BLRStart Date", 3); // Extract year of Start Date
        EndYear := Date2DMY(Rec."BLREnd Date", 3);    // Extract year of End Date
        TotalDays := Rec."BLREnd Date" - Rec."BLRStart Date" + 1;
        IsLeapYearInRange := false;

        // Check each year in the range for leap year
        for CurrentYear := StartYear to EndYear do
            if IsLeapYear(CurrentYear) then
                // Ensure the leap day (Feb 29) falls within the Start and End Date
                if (DMY2Date(29, 2, CurrentYear) >= Rec."BLRStart Date") and
                   (DMY2Date(29, 2, CurrentYear) <= Rec."BLREnd Date") then begin
                    IsLeapYearInRange := true;
                    break; // Stop checking further once a leap year is found
                end;

        // If a leap year is in range, ensure at least one year has 366 days
        if IsLeapYearInRange then
            TotalDays := TotalDays + 1;

        // Set the calculated number of days
        Rec."BLRNumber of Days" := TotalDays;

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
        if Rec."BLRYear" = 1 then begin
            if (Rec."BLRRate per Sq.Ft" > 0) and (Rec."BLRUnit Sq Ft" > 0) then
                Rec."BLRAnnual Amount" := Rec."BLRRate per Sq.Ft" * Rec."BLRUnit Sq Ft"
            else
                Rec."BLRAnnual Amount" := 0;
        end else
            if (Rec."BLRRate per Sq.Ft" > 0) and (Rec."BLRUnit Sq Ft" > 0) then
                Rec."BLRAnnual Amount" := Rec."BLRRate per Sq.Ft" * Rec."BLRUnit Sq Ft"
            else
                Rec."BLRAnnual Amount" := 0;

        Rec.Modify();
        CurrPage.Update();
    end;

    local procedure RecalculateFinalAnnualAmount()
    begin
        if Rec."BLRRound off" = 0 then
            Rec."BLRFinal Annual Amount" := Rec."BLRAnnual Amount"
        else
            Rec."BLRFinal Annual Amount" := Rec."BLRAnnual Amount" + Rec."BLRRound off";

        Rec.Modify();
        CurrPage.Update();
    end;

    local procedure RecalculatePerDayRent()
    begin
        if Rec."BLRNumber of Days" > 0 then
            Rec."BLRPer Day Rent" := Rec."BLRFinal Annual Amount" / Rec."BLRNumber of Days"
        else
            Rec."BLRPer Day Rent" := 0;

        Rec.Modify();
        CurrPage.Update();
    end;
}