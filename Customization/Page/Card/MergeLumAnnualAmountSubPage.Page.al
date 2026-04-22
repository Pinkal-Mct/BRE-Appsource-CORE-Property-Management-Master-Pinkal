page 73209701 "Merge Lum_AnnualAmount SubPage"
{
    PageType = ListPart;
    SourceTable = "Merge Lum_AnnualAmount SubPage";
    ApplicationArea = All;
    Caption = 'Merge Lum_AnnualAmount SubPage';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Proposal ID"; rec."Proposal ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the Proposal ID for the merged unit.';
                }
                field("ML_Merged Unit ID"; rec."ML_Merged Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Merged Unit ID';
                    ToolTip = 'Enter the Merged Unit ID for the merged unit.';
                }
                field("ML_Unit ID"; rec."ML_Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Unit ID';
                    ToolTip = 'Enter the Unit ID for the merged unit.';
                }
                field("ML_Year"; rec.ML_Year)
                {
                    ApplicationArea = All;
                    Caption = 'Year';
                    ToolTip = 'Enter the year for the merged unit.';
                }
                field("ML_Start Date"; rec."ML_Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    ToolTip = 'Enter the start date for the merged unit.';
                    trigger OnValidate()
                    begin
                        // Recalculate Number of Days
                        RecalculateNumberOfDays();
                    end;
                }

                field("ML_End Date"; rec."ML_End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    ToolTip = 'Enter the end date for the merged unit.';
                    trigger OnValidate()
                    begin
                        // Recalculate Number of Days
                        RecalculateNumberOfDays();
                    end;
                }
                field("ML_Number of Days"; rec."ML_Number of Days")
                {
                    ApplicationArea = All;
                    Caption = 'Number of Days';
                    ToolTip = 'Displays the number of days between the start and end date.';
                }
                field("ML_Unit Sq Ft"; rec."ML_Unit Sq Ft")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Sq Ft';
                    Editable = false;
                    ToolTip = 'Displays the size of the unit in square feet.';
                    trigger OnValidate()
                    begin
                        // RecalculateAnnualAmount();
                    end;
                }
                field("ML_Rate per Sq.Ft"; rec."ML_Rate per Sq.Ft")
                {
                    ApplicationArea = All;
                    Caption = 'Rate per Sq.Ft';
                    Editable = false;
                    ToolTip = 'Displays the rate per square foot for the merged unit.';
                    trigger OnValidate()
                    begin
                        // RecalculateAnnualAmount();
                    end;
                }
                field("ML_Rent Increase %"; rec."ML_Rent Increase %")
                {
                    ApplicationArea = All;
                    Caption = 'Rent Increase %';
                    ToolTip = 'Enter the rent increase percentage for the merged unit.';
                    trigger OnValidate()
                    begin
                        if Rec."ML_Rent Increase %" < 0 then
                            Error('Rent Increase % cannot be negative.');

                        // Calculate the annual amount and final annual amount based on rent increase
                        if Rec.ML_Year > 1 then
                            RecalculateRentIncrease();

                        Rec.Modify();
                        // Recalculate totals
                        RecalculateTotals();
                    end;
                }

                field("ML_Annual Amount"; rec."ML_Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Annual Amount';
                    ToolTip = 'Enter the annual amount manually or let it be calculated based on rate per sq.ft.';
                    DecimalPlaces = 2 : 2;
                    trigger OnValidate()
                    var
                        PreviousYearRecord: Record "Merge Lum_AnnualAmount SubPage";
                        RentIncreasePercentage: Decimal;
                    begin
                        // Set Final Annual Amount to the entered Annual Amount
                        Rec."ML_Final Annual Amount" := Rec."ML_Annual Amount";

                        // If this is the 2nd year or later, calculate the rent increase percentage
                        if Rec.ML_Year > 1 then begin
                            // Fetch the previous year's record
                            PreviousYearRecord.SetRange("Proposal ID", Rec."Proposal ID");
                            PreviousYearRecord.SetRange(ML_Year, Rec.ML_Year - 1);

                            if PreviousYearRecord.FindFirst() then begin
                                // Calculate the rent increase percentage based on the entered annual amount
                                if PreviousYearRecord."ML_Final Annual Amount" > 0 then
                                    RentIncreasePercentage :=
                                        ((Rec."ML_Annual Amount" - PreviousYearRecord."ML_Final Annual Amount") /
                                        PreviousYearRecord."ML_Final Annual Amount") * 100
                                else
                                    RentIncreasePercentage := 0;

                                // Update the Rent Increase % field with precise decimal value
                                Rec."ML_Rent Increase %" := RentIncreasePercentage;
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
                field("ML_Round off"; rec."ML_Round off")
                {
                    ApplicationArea = All;
                    Caption = 'Round off';
                    ToolTip = 'Enter the round off value. The Final Annual Amount will be recalculated automatically.';
                    trigger OnValidate()
                    begin
                        // Recalculate the final annual amount
                        RecalculateFinalAnnualAmount();
                        RecalculatePerDayRent();
                        Rec.Modify();
                        // Recalculate totals
                        RecalculateTotals();
                    end;
                }
                field("ML_Final Annual Amount"; rec."ML_Final Annual Amount")
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
                field("ML_Per Day Rent"; rec."ML_Per Day Rent")
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
                    ToolTip = 'Displays the total contract amount for all merged units.';
                }

                field("TotalRoundOff"; rec.TotalRoundOff)
                {
                    Caption = 'Round Off';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Displays the total round off amount for all merged units.';
                }

                field("TotalFinalAmount"; rec.TotalFinalAmount)
                {
                    Caption = 'Total Final Contract Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Displays the total final contract amount for all merged units.';
                }

                field("TotalFirstAnnualAmount"; rec.TotalFirstAnnualAmount)
                {
                    Caption = 'Total Annual Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Displays the total annual amount for the first year of all merged units.';
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
                ToolTip = 'Insert Data';
                ApplicationArea = All;
                Caption = 'Insert Data';
                Image = NewDocument; // Optionally, define an icon

                trigger OnAction()
                var
                    MergeLumSquareRec: Record "Merge Lum_AnnualAmount SubPage";
                    SubLeaseMergeRec: Record "Sub Lease Merged Units";
                    PerDayRevnue: Record "Per Day Rent for Revenue";
                    PerDayRevenueCalc: Decimal; // Variable to store the calculated revenue
                begin
                    if Rec."Proposal ID" = 0 then
                        Error('Proposal ID is missing or not assigned.');

                    // Fetch data from the Merge Lum_AnnualAmount SubPage table
                    MergeLumSquareRec.SetRange("Proposal ID", Rec."Proposal ID");

                    // Fetch data from the Sub Lease Merged Units table
                    SubLeaseMergeRec.SetRange("Proposal ID", Rec."Proposal ID");

                    // Fetch the first record from the Merge Lum_AnnualAmount SubPage table
                    if MergeLumSquareRec.FindSet() then
                        repeat
                            // Loop through Sub Lease Merged Units and fetch relevant data
                            if SubLeaseMergeRec.FindSet() then
                                repeat
                                    PerDayRevnue.Init();
                                    // Initialize the record in the current grid with data from both tables
                                    PerDayRevnue."Proposal ID" := MergeLumSquareRec."Proposal ID";
                                    PerDayRevnue."Year" := MergeLumSquareRec."ML_Year"; // From Merge Lum_AnnualAmount SubPage
                                    PerDayRevnue."Sq.Ft" := SubLeaseMergeRec."Unit Size"; // From Sub Lease Merged Units
                                    PerDayRevnue."Unit ID" := SubLeaseMergeRec."Single Unit Name"; // From Sub Lease Merged Units

                                    // Calculate Per Day Revenue using the updated formula
                                    if MergeLumSquareRec."ML_Unit Sq Ft" = 0 then
                                        Error('ML Unit Sq Ft cannot be zero for Proposal ID %1.', MergeLumSquareRec."Proposal ID");

                                    PerDayRevenueCalc := MergeLumSquareRec."ML_Per Day Rent" * SubLeaseMergeRec."Unit Size" / MergeLumSquareRec."ML_Unit Sq Ft";
                                    PerDayRevnue."Per Day Rent Per Unit" := PerDayRevenueCalc; // Assign the calculated value

                                    // Check if the record already exists to prevent duplicates
                                    PerDayRevnue.SetRange(Year, PerDayRevnue.Year);
                                    PerDayRevnue.SetRange("Proposal ID", PerDayRevnue."Proposal ID");
                                    PerDayRevnue.SetRange("Unit ID", PerDayRevnue."Unit ID");
                                    if not PerDayRevnue.FindFirst() then begin
                                        // Insert the new record only if it doesn't exist
                                        PerDayRevnue.Insert();
                                        Clear(PerDayRevnue);
                                    end;

                                until SubLeaseMergeRec.Next() = 0;

                        until MergeLumSquareRec.Next() = 0

                    else
                        Error('No matching records found in Merge Lum_AnnualAmount SubPage for the given Proposal ID.');

                    // Refresh the current page to display updated data
                    CurrPage.Update();
                end;
            }
        }
    }


    //-----------------Calculate No. Of Days -----------------//

    local procedure RecalculateNumberOfDays()
    var
        StartYear: Integer;
        EndYear: Integer;
        CurrentYear: Integer;
        TotalDays: Integer;
        IsLeapYearInRange: Boolean;
    begin
        // Validate Start Date and End Date
        if Rec."ML_Start Date" = 0D then
            Error('Start Date is not valid.');
        if Rec."ML_End Date" = 0D then
            Error('End Date is not valid.');
        if Rec."ML_End Date" < Rec."ML_Start Date" then
            Error('End Date cannot be earlier than Start Date.');

        // Initialize variables
        StartYear := Date2DMY(Rec."ML_Start Date", 3); // Extract year of Start Date
        EndYear := Date2DMY(Rec."ML_End Date", 3);    // Extract year of End Date
        TotalDays := Rec."ML_End Date" - Rec."ML_Start Date" + 1;
        IsLeapYearInRange := false;

        // Check each year in the range for leap year
        for CurrentYear := StartYear to EndYear do
            if IsLeapYear(CurrentYear) then
                // Ensure the leap day (Feb 29) falls within the Start and End Date
                if (DMY2Date(29, 2, CurrentYear) >= Rec."ML_Start Date") and
                   (DMY2Date(29, 2, CurrentYear) <= Rec."ML_End Date") then begin
                    IsLeapYearInRange := true;
                    break; // Stop checking further once a leap year is found
                end;

        // If a leap year is in range, ensure at least one year has 366 days
        if IsLeapYearInRange then
            TotalDays := TotalDays + 1;

        // Set the calculated number of days
        Rec."ML_Number of Days" := TotalDays;

        Rec.Modify();
    end;

    //-----------------Calculate No. Of Days -----------------//


    //-----------------Calculate Leap Year -----------------//

    // Helper function to determine if a year is a leap year
    local procedure IsLeapYear(Year: Integer): Boolean
    begin
        if (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0)) then
            exit(true);
        exit(false);
    end;

    //-----------------Calculate Leap Year -----------------//


    // local procedure RecalculateAnnualAmount()
    // begin
    //     if Rec.ML_Year = 1 then begin
    //         if (Rec."ML_Rate per Sq.Ft" > 0) and (Rec."ML_Unit Sq Ft" > 0) then
    //             Rec."ML_Annual Amount" := Rec."ML_Rate per Sq.Ft" * Rec."ML_Unit Sq Ft"
    //         else
    //             Rec."ML_Annual Amount" := 0;
    //     end else begin
    //         if (Rec."ML_Rate per Sq.Ft" > 0) and (Rec."ML_Unit Sq Ft" > 0) then
    //             Rec."ML_Annual Amount" := Rec."ML_Rate per Sq.Ft" * Rec."ML_Unit Sq Ft"
    //         else
    //             Rec."ML_Annual Amount" := 0;
    //     end;
    //     Rec.Modify();
    //     CurrPage.Update();
    // end;

    // local procedure RecalculateFinalAnnualAmount()
    // begin
    //     if Rec."ML_Round off" = 0 then
    //         Rec."ML_Final Annual Amount" := Rec."ML_Annual Amount"
    //     else
    //         Rec."ML_Final Annual Amount" := Rec."ML_Annual Amount" + Rec."ML_Round off";

    //     Rec.Modify();
    //     CurrPage.Update();
    // end;

    //-----------------Calculate Per Day Rent -----------------//

    local procedure RecalculatePerDayRent()
    begin
        if Rec."ML_Number of Days" > 0 then
            Rec."ML_Per Day Rent" := Rec."ML_Final Annual Amount" / Rec."ML_Number of Days"
        else
            Rec."ML_Per Day Rent" := 0;

        Rec.Modify();
        CurrPage.Update();
    end;

    //-----------------Calculate Per Day Rent -----------------//


    //-----------------Calculate Rent Increase -----------------//


    local procedure RecalculateRentIncrease()
    var
        PreviousYearRecord: Record "Merge Lum_AnnualAmount SubPage";
        IncreaseFactor: Decimal;
    begin
        // Fetch the previous year's record
        PreviousYearRecord.SetRange("Proposal ID", Rec."Proposal ID");
        PreviousYearRecord.SetRange(ML_Year, Rec.ML_Year - 1);

        if PreviousYearRecord.FindFirst() then begin
            IncreaseFactor := 1 + (Rec."ML_Rent Increase %" / 100);
            Rec."ML_Annual Amount" := PreviousYearRecord."ML_Final Annual Amount" * IncreaseFactor;
            Rec."ML_Final Annual Amount" := Rec."ML_Annual Amount";

            // Recalculate Per Day Rent
            RecalculatePerDayRent();
        end else
            Error('No record found for the previous year to base the calculation.');
    end;



    //-----------------Calculate Rent Increase -----------------//



    //-----------------Calculate Total -----------------//


    local procedure RecalculateTotals()
    var

        LeaseProposalRec: Record "Lease Proposal Details";
        MergeLumRecord: Record "Merge Lum_AnnualAmount SubPage";
        TotalFinal: Decimal;

        FirstYearAnnualAmount: Decimal; // Variable for the first year's annual amount
        vatPer: Integer;
    begin
        // Initialize totals

        TotalFinal := 0;

        FirstYearAnnualAmount := 0; // Initialize to 0

        // Loop through all records for the same Proposal ID to calculate totals
        MergeLumRecord.SetRange("Proposal ID", Rec."Proposal ID");
        if MergeLumRecord.FindSet() then
            repeat

                TotalFinal += MergeLumRecord."ML_Final Annual Amount";


                // Check for the first year and assign its Annual Amount
                if MergeLumRecord."ML_Year" = 1 then
                    FirstYearAnnualAmount := MergeLumRecord."ML_Final Annual Amount";
            until MergeLumRecord.Next() = 0;


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
    //-----------------Calculate Total -----------------//
    local procedure RecalculateFinalAnnualAmount()
    var
        DaysInYear: Integer;
        DaysInPeriod: Integer;
        ProratedAmount: Decimal;
        LeapDay: Date;
    begin
        ProratedAmount := 0;

        // If dates are not set, set Final Annual Amount to Annual Amount + Round off
        if (Rec."ML_Start Date" = 0D) or (Rec."ML_End Date" = 0D) then begin
            Rec."ML_Final Annual Amount" := Rec."ML_Annual Amount" + Rec."ML_Round off";
            Rec.Modify();
            CurrPage.Update();
            exit;
        end;

        if Rec."ML_End Date" < Rec."ML_Start Date" then
            Error('End Date cannot be earlier than Start Date.');

        DaysInPeriod := Rec."ML_End Date" - Rec."ML_Start Date" + 1;

        DaysInYear := 365;

        if IsLeapYear(Date2DMY(Rec."ML_Start Date", 3)) then begin
            LeapDay := DMY2Date(29, 2, Date2DMY(Rec."ML_Start Date", 3));

            if (LeapDay >= Rec."ML_Start Date") and (LeapDay <= Rec."ML_End Date") then
                DaysInYear := 366;
        end;

        ProratedAmount := (Rec."ML_Annual Amount" * DaysInPeriod) / DaysInYear;
        // Apply round off on top of the prorated sum
        Rec."ML_Final Annual Amount" := ProratedAmount + Rec."ML_Round off";

        Rec.Modify();
        CurrPage.Update();
    end;
}

