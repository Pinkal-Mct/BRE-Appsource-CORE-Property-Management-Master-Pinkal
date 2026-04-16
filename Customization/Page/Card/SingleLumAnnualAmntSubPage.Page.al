page 50333 "Single Lum_AnnualAmnt SubPage"
{
    PageType = ListPart;
    SourceTable = "Single Lum_AnnualAmnt SubPage";
    ApplicationArea = All;
    Caption = 'Single Lum_AnnualAmount SubPage';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Proposal ID"; rec."Proposal ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'ID of the proposal';
                }
                field("SL_Merged Unit ID"; rec."SL_Merged Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Merged Unit ID';
                    Visible = false;
                    ToolTip = 'ID of the merged unit';
                }
                field("SL_Unit ID"; rec."SL_Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Unit ID';
                    ToolTip = 'ID of the unit';
                }
                field("SL_Year"; rec.SL_Year)
                {
                    ApplicationArea = All;
                    Caption = 'Year';
                    ToolTip = 'Year of the annual amount';
                }
                field("SL_Start Date"; rec."SL_Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    ToolTip = 'Start date of the lease period for this annual amount.';
                    trigger OnValidate()
                    begin
                        // Recalculate Number of Days
                        RecalculateNumberOfDays();
                    end;
                }

                field("SL_End Date"; rec."SL_End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    ToolTip = 'End date of the lease period for this annual amount.';
                    trigger OnValidate()
                    begin
                        // Recalculate Number of Days
                        RecalculateNumberOfDays();
                    end;
                }
                field("SL_Number of Days"; rec."SL_Number of Days")
                {
                    ApplicationArea = All;
                    Caption = 'Number of Days';
                    ToolTip = 'Number of days in the lease period for this annual amount.';
                }
                field("SL_Unit Sq Ft"; rec."SL_Unit Sq Ft")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Sq Ft';
                    Editable = false;
                    ToolTip = 'Size of the unit in square feet or square meters.';
                }
                field("SL_Rate per Sq.Ft"; rec."SL_Rate per Sq.Ft")
                {
                    ApplicationArea = All;
                    Caption = 'Rate per Sq.Ft';
                    Editable = false;
                    ToolTip = 'Rate per square foot or square meter for the unit.';
                }
                field("SL_Rent Increase %"; rec."SL_Rent Increase %")
                {
                    ApplicationArea = All;
                    Caption = 'Rent Increase %';
                    ToolTip = 'Percentage increase in rent for the next year.';
                    trigger OnValidate()
                    begin
                        if Rec."SL_Rent Increase %" < 0 then
                            Error('Rent Increase % cannot be negative.');

                        // Calculate the annual amount and final annual amount based on rent increase
                        if Rec.SL_Year > 1 then
                            RecalculateRentIncrease();

                        Rec.Modify();
                        // Recalculate totals
                        RecalculateTotals();
                    end;
                }

                field("SL_Annual Amount"; rec."SL_Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Annual Amount';
                    ToolTip = 'Enter the annual amount manually or let it be calculated based on rate per sq.ft.';
                    DecimalPlaces = 2 : 2;
                    trigger OnValidate()
                    var
                        PreviousYearRecord: Record "Single Lum_AnnualAmnt SubPage";
                        RentIncreasePercentage: Decimal;
                    begin
                        // Set Final Annual Amount to the entered Annual Amount
                        Rec."SL_Final Annual Amount" := Rec."SL_Annual Amount";

                        // If this is the 2nd year or later, calculate the rent increase percentage
                        if Rec.SL_Year > 1 then begin
                            // Fetch the previous year's record
                            PreviousYearRecord.SetRange("Proposal ID", Rec."Proposal ID");
                            PreviousYearRecord.SetRange(SL_Year, Rec.SL_Year - 1);

                            if PreviousYearRecord.FindFirst() then begin
                                // Calculate the rent increase percentage based on the entered annual amount
                                if PreviousYearRecord."SL_Final Annual Amount" > 0 then
                                    RentIncreasePercentage :=
                                        ((Rec."SL_Annual Amount" - PreviousYearRecord."SL_Final Annual Amount") /
                                        PreviousYearRecord."SL_Final Annual Amount") * 100
                                else
                                    RentIncreasePercentage := 0;

                                // Update the Rent Increase % field with precise decimal value
                                Rec."SL_Rent Increase %" := RentIncreasePercentage;
                            end else
                                Error('No record found for the previous year to base the calculation.');
                        end;

                        Rec.Modify();
                        RecalculateFinalAnnualAmount();
                        // Recalculate totals and per day rent
                        RecalculateTotals();
                        RecalculatePerDayRent();
                    end;
                }
                field("SL_Round off"; rec."SL_Round off")
                {
                    ApplicationArea = All;
                    Caption = 'Round off';
                    ToolTip = 'Enter the round off value. The Final Annual Amount will be recalculated automatically.';
                    trigger OnValidate()
                    begin
                        // Recalculate the final annual amount
                        if Rec."SL_Round off" = 0 then
                            Rec."SL_Final Annual Amount" := Rec."SL_Annual Amount"
                        else
                            Rec."SL_Final Annual Amount" := Rec."SL_Annual Amount" + Rec."SL_Round off";

                        Rec.Modify();
                        // Recalculate totals
                        RecalculateFinalAnnualAmount();
                        RecalculatePerDayRent();
                        RecalculateTotals();
                    end;
                }
                field("SL_Final Annual Amount"; rec."SL_Final Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Final Annual Amount';
                    Editable = false;
                    ToolTip = 'Displays the calculated final annual amount after applying the round off.';
                    DecimalPlaces = 2 : 2;
                    trigger OnValidate()
                    begin
                        RecalculatePerDayRent(); // Update Per Day Rent when Final Annual Amount changes
                                                 // Recalculate totals
                        RecalculateTotals();
                    end;
                }
                field("SL_Per Day Rent"; rec."SL_Per Day Rent")
                {
                    ApplicationArea = All;
                    Caption = 'Per Day Rent';
                    Editable = false;
                    ToolTip = 'Displays the calculated per day rent based on the final annual amount and the number of days.';
                    DecimalPlaces = 2 : 2;

                    trigger OnValidate()
                    begin
                        RecalculatePerDayRent(); // Update Per Day Rent when Final Annual Amount changes
                                                 // Recalculate totals
                        RecalculateTotals();
                    end;
                }

            }

            group("Total Rent Caculation")
            {

                field("TotalAnnualAmount"; rec.TotalAnnualAmount)
                {
                    Caption = 'Total Contract Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Total contract amount for the proposal based on all annual amounts.';
                }

                field("TotalRoundOff"; rec.TotalRoundOff)
                {
                    Caption = 'Round Off';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Total round off amount for the proposal based on all annual amounts.';
                }

                field("TotalFinalAmount"; rec.TotalFinalAmount)
                {
                    Caption = 'Total Final Contract Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Total final contract amount for the proposal after applying round off.';
                }

                field("TotalFirstAnnualAmount"; rec.TotalFirstAnnualAmount)
                {
                    Caption = 'Total Annual Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Total annual amount for the first year of the proposal.';
                }
            }
        }
    }

    local procedure RecalculateNumberOfDays()
    var
        StartYear: Integer;
        EndYear: Integer;
        CurrentYear: Integer;
        TotalDays: Integer;
        IsLeapYearInRange: Boolean;
    begin
        // Validate Start Date and End Date
        if Rec."SL_Start Date" = 0D then
            Error('Start Date is not valid.');
        if Rec."SL_End Date" = 0D then
            Error('End Date is not valid.');
        if Rec."SL_End Date" < Rec."SL_Start Date" then
            Error('End Date cannot be earlier than Start Date.');

        // Initialize variables
        StartYear := Date2DMY(Rec."SL_Start Date", 3); // Extract year of Start Date
        EndYear := Date2DMY(Rec."SL_End Date", 3);    // Extract year of End Date
        TotalDays := Rec."SL_End Date" - Rec."SL_Start Date" + 1;
        IsLeapYearInRange := false;

        // Check each year in the range for leap year
        for CurrentYear := StartYear to EndYear do
            if IsLeapYear(CurrentYear) then
                // Ensure the leap day (Feb 29) falls within the Start and End Date
                if (DMY2Date(29, 2, CurrentYear) >= Rec."SL_Start Date") and
                   (DMY2Date(29, 2, CurrentYear) <= Rec."SL_End Date") then begin
                    IsLeapYearInRange := true;
                    break; // Stop checking further once a leap year is found
                end;


        // If a leap year is in range, ensure at least one year has 366 days
        if IsLeapYearInRange then
            TotalDays := TotalDays + 1;

        // Set the calculated number of days
        Rec."SL_Number of Days" := TotalDays;

        Rec.Modify();
    end;

    // Helper function to determine if a year is a leap year
    local procedure IsLeapYear(Year: Integer): Boolean
    begin
        if (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0)) then
            exit(true);
        exit(false);
    end;

    local procedure RecalculatePerDayRent()
    begin
        if Rec."SL_Number of Days" > 0 then
            Rec."SL_Per Day Rent" := Rec."SL_Final Annual Amount" / Rec."SL_Number of Days"
        else
            Rec."SL_Per Day Rent" := 0;

        Rec.Modify();
        CurrPage.Update();
    end;


    local procedure RecalculateRentIncrease()
    var
        PreviousYearRecord: Record "Single Lum_AnnualAmnt SubPage";
        IncreaseFactor: Decimal;
    begin
        // Fetch the previous year's record
        PreviousYearRecord.SetRange("Proposal ID", Rec."Proposal ID");
        PreviousYearRecord.SetRange(SL_Year, Rec.SL_Year - 1);

        if PreviousYearRecord.FindFirst() then begin
            IncreaseFactor := 1 + (Rec."SL_Rent Increase %" / 100);
            Rec."SL_Annual Amount" := PreviousYearRecord."SL_Final Annual Amount" * IncreaseFactor;
            Rec."SL_Final Annual Amount" := Rec."SL_Annual Amount";

            // Recalculate Per Day Rent
            RecalculatePerDayRent();
        end else
            Error('No record found for the previous year to base the calculation.');
    end;

    local procedure RecalculateFinalAnnualAmount()
    var
        DaysInYear: Integer;
        DaysInPeriod: Integer;
        ProratedAmount: Decimal;
        LeapDay: Date;
    begin
        ProratedAmount := 0;

        // If dates are not set, set Final Annual Amount to Annual Amount + Round off
        if (Rec."SL_Start Date" = 0D) or (Rec."SL_End Date" = 0D) then begin
            Rec."SL_Final Annual Amount" := Rec."SL_Annual Amount" + Rec."SL_Round off";
            Rec.Modify();
            CurrPage.Update();
            exit;
        end;

        if Rec."SL_End Date" < Rec."SL_Start Date" then
            Error('End Date cannot be earlier than Start Date.');

        DaysInPeriod := Rec."SL_End Date" - Rec."SL_Start Date" + 1;

        DaysInYear := 365;

        if IsLeapYear(Date2DMY(Rec."SL_Start Date", 3)) then begin
            LeapDay := DMY2Date(29, 2, Date2DMY(Rec."SL_Start Date", 3));

            if (LeapDay >= Rec."SL_Start Date") and (LeapDay <= Rec."SL_End Date") then
                DaysInYear := 366;
        end;

        ProratedAmount := (Rec."SL_Annual Amount" * DaysInPeriod) / DaysInYear;

        // Apply round off on top of the prorated sum
        Rec."SL_Final Annual Amount" := ProratedAmount + Rec."SL_Round off";

        Rec.Modify();
        CurrPage.Update();
    end;


    local procedure RecalculateTotals()
    var

        LeaseProposalRec: Record "Lease Proposal Details";
        RecordTemp: Record "Single Lum_AnnualAmnt SubPage";
        TotalAnnual: Decimal;
        TotalFinal: Decimal;
        lTotalRoundOff: Decimal;
        FirstYearAnnualAmount: Decimal; // Variable for the first year's annual amount
        vatPer: Integer;
    begin
        // Initialize totals
        TotalAnnual := 0;
        TotalFinal := 0;
        lTotalRoundOff := 0;
        FirstYearAnnualAmount := 0; // Initialize to 0

        // Loop through all records for the same Proposal ID to calculate totals
        RecordTemp.SetRange("Proposal ID", Rec."Proposal ID");
        if RecordTemp.FindSet() then
            repeat
                TotalAnnual += RecordTemp."SL_Annual Amount";
                TotalFinal += RecordTemp."SL_Final Annual Amount";
                lTotalRoundOff += RecordTemp."SL_Round off";

                // Check for the first year and assign its Annual Amount
                if RecordTemp."SL_Year" = 1 then
                    FirstYearAnnualAmount := RecordTemp."SL_Final Annual Amount";
            until RecordTemp.Next() = 0;

        // Update the totals in the current record
        Rec.TotalAnnualAmount := TotalAnnual;
        Rec.TotalFinalAmount := TotalFinal;
        Rec.TotalRoundOff := lTotalRoundOff;
        Rec.TotalFirstAnnualAmount := FirstYearAnnualAmount; // Assign the first year's annual amount

        // Update Lease Proposal Details with calculated totals
        LeaseProposalRec.SetRange("Proposal ID", Rec."Proposal ID");
        if LeaseProposalRec.FindSet() then begin
            LeaseProposalRec."Rent Amount" := FirstYearAnnualAmount; // Update Rent Amount with the first year's Final Annual Amount
            LeaseProposalRec."Annual Rent Amount" := TotalFinal; // Update Annual Rent Amount with the Total Final Amount

            if LeaseProposalRec."Rent Amount VAT %" = LeaseProposalRec."Rent Amount VAT %"::"5%" then
                vatPer := 5
            else
                vatPer := 0;

            LeaseProposalRec."Rent VAT Amount" := LeaseProposalRec."Annual Rent Amount" * (vatPer / 100);
            LeaseProposalRec."Rent Amount Including VAT" := LeaseProposalRec."Annual Rent Amount" + LeaseProposalRec."Rent VAT Amount";

            LeaseProposalRec.Modify(); // Save the changes to the Lease Proposal record
        end;

        Rec.Modify();
        CurrPage.Update();
    end;

}