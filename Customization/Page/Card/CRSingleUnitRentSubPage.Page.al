page 73209687 "CR Single Unit Rent SubPage"
{
    PageType = ListPart;
    SourceTable = "CR Single Unit Rent SubPage";
    ApplicationArea = All;
    Caption = 'Single Unit Rent SubPage';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID"; rec."ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the record.';
                }
                field("Merged Unit ID"; rec."Merged Unit ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Unique identifier for the merged unit.';
                }
                field("Unit ID"; rec."Unit ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the unit associated with this rent record.';
                }
                field("Year"; rec.Year)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Year for which the rent is calculated.';
                }
                field("Start Date"; rec."Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Start date of the rent period.';
                }
                field("End Date"; rec."End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'End date of the rent period. This is calculated based on the start date and number of days.';
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
                    ToolTip = 'Square footage of the unit for which the rent is calculated.';

                    trigger OnValidate()
                    begin
                        RecalculateAnnualAmount();
                    end;
                }

                field("Rate per Sq.Ft"; rec."Rate per Sq.Ft")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Enter the rate per square foot for the unit. This will be used to calculate the annual amount.';

                    trigger OnValidate()
                    var
                        PreviousYearRecord: Record "CR Single Unit Rent SubPage";
                        PreviousRate: Decimal;
                    begin
                        // Ensure the value is not negative
                        if Rec."Rate per Sq.Ft" < 0 then
                            Error('Rate per Sq.Ft cannot be negative.');

                        // Fetch the previous year's record to calculate Rent Increase %
                        PreviousYearRecord.SetRange("ID", Rec."ID");
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
                        PreviousYearRecord: Record "CR Single Unit Rent SubPage";
                        IncreaseFactor: Decimal;
                    begin
                        // Ensure that Rent Increase % is not negative
                        if Rec."Rent Increase %" < 0 then
                            Error('Rent Increase % cannot be negative.');

                        // Skip calculation for the first year
                        if Rec."Year" = 1 then
                            exit;

                        // Fetch the previous year's record
                        PreviousYearRecord.SetRange("ID", Rec."ID");
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
                    ToolTip = 'Displays the total annual amount for all records in the current proposal.';
                }

                field("TotalRoundOff"; rec.TotalRoundOff)
                {
                    Caption = 'Round Off';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Displays the total round off amount for all records in the current proposal.';
                }

                field("TotalFinalAmount"; rec.TotalFinalAmount)
                {
                    Caption = 'Total Final Contract Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Displays the total final annual amount for all records in the current proposal.';
                }

                field("TotalFirstAnnualAmount"; rec.TotalFirstAnnualAmount)
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

        LeaseProposalRec: Record "Contract Renewal";
        RecordTemp: Record "CR Single Unit Rent SubPage";
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
        RecordTemp.SetRange("ID", Rec."ID");

        // Iterate over the filtered records
        if RecordTemp.FindSet() then
            repeat
                lTotalAnnualAmount += RecordTemp."Annual Amount";
                lTotalRoundOff += RecordTemp."Round off";
                lTotalFinalAmount += RecordTemp."Final Annual Amount";

                // Check for the first year and assign its Annual Amount
                if RecordTemp."Year" = 1 then
                    FirstYearAnnualAmount := RecordTemp."Final Annual Amount";
            until RecordTemp.Next() = 0;

        // Assign calculated totals to the fields
        Rec.TotalAnnualAmount := lTotalAnnualAmount;
        Rec.TotalRoundOff := lTotalRoundOff;
        Rec.TotalFinalAmount := lTotalFinalAmount;
        Rec.TotalFirstAnnualAmount := FirstYearAnnualAmount; // Assign the first year's annual amount

        // Update Lease Proposal Details with calculated totals
        LeaseProposalRec.SetRange("ID", Rec."ID");
        if LeaseProposalRec.FindSet() then begin
            LeaseProposalRec."Rent Amount" := FirstYearAnnualAmount; // Update Rent Amount with the first year's Final Annual Amount
            LeaseProposalRec."Contract Amount" := lTotalFinalAmount; // Update Annual Rent Amount with the Total Final Amount

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
    begin
        if Rec."Round off" = 0 then
            Rec."Final Annual Amount" := Rec."Annual Amount"
        else
            Rec."Final Annual Amount" := Rec."Annual Amount" + Rec."Round off";

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