page 50118 "Merge SameSqure SubPage"
{
    PageType = ListPart;
    SourceTable = "Merge SameSqure SubPage";
    ApplicationArea = All;
    Caption = 'Merge SameSqure SubPage';

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
                    ToolTip = 'Specifies the unique identifier for the proposal.';
                }
                field("MS_Merged Unit ID"; rec."MS_Merged Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Merged Unit ID';
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the merged unit.';
                }
                field("MS_Unit ID"; rec."MS_Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Unit ID';
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the unit.';
                }
                field("MS_Year"; rec.MS_Year)
                {
                    ApplicationArea = All;
                    Caption = 'Year';
                    Editable = false;
                    ToolTip = 'Specifies the year for the record.';
                }
                field("MS_Start Date"; rec."MS_Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    Editable = false;
                    ToolTip = 'Specifies the start date for the period.';
                }
                field("MS_End Date"; rec."MS_End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    Editable = false;
                    ToolTip = 'Specifies the end date for the period.';
                }
                field("MS_Number of Days"; rec."MS_Number of Days")
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
                field("MS_Unit Sq Ft"; rec."MS_Unit Sq Ft")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Sq Ft';
                    Editable = false;
                    ToolTip = 'Specifies the unit square footage for the unit.';
                    trigger OnValidate()
                    begin
                        RecalculateAnnualAmount();
                    end;
                }

                field("MS_Rate per Sq.Ft"; rec."MS_Rate per Sq.Ft")
                {
                    ApplicationArea = All;
                    Caption = 'Rate per Sq.Ft';
                    ToolTip = 'Enter the rate per square foot for this year.';

                    trigger OnValidate()
                    var
                        PreviousYearRecord: Record "Merge SameSqure SubPage";
                        PreviousRate: Decimal;
                    begin
                        // Ensure the value is not negative
                        if Rec."MS_Rate per Sq.Ft" < 0 then
                            Error('Rate per Sq.Ft cannot be negative.');

                        // Fetch the previous year's record to calculate Rent Increase %
                        PreviousYearRecord.SetRange("Proposal ID", Rec."Proposal ID");
                        PreviousYearRecord.SetRange("MS_Year", Rec.MS_Year - 1);

                        if PreviousYearRecord.FindFirst() then begin
                            PreviousRate := PreviousYearRecord."MS_Rate per Sq.Ft";

                            // Ensure previous rate is greater than 0 to avoid division by zero
                            if PreviousRate > 0 then
                                Rec."MS_Rent Increase %" :=
                                    ((Rec."MS_Rate per Sq.Ft" - PreviousRate) / PreviousRate) * 100
                            else
                                Rec."MS_Rent Increase %" := 0; // No increase if previous rate is 0
                        end else
                            Rec."MS_Rent Increase %" := 0; // No increase for the first year or no previous record

                        // Recalculate Annual Amount
                        if (Rec."MS_Rate per Sq.Ft" > 0) and (Rec."MS_Unit Sq Ft" > 0) then
                            Rec."MS_Annual Amount" := Rec."MS_Rate per Sq.Ft" * Rec."MS_Unit Sq Ft"
                        else
                            Rec."MS_Annual Amount" := 0;

                        // Set Final Annual Amount equal to Annual Amount
                        Rec."MS_Final Annual Amount" := Rec."MS_Annual Amount";

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

                field("MS_Rent Increase %"; rec."MS_Rent Increase %")
                {
                    ApplicationArea = All;
                    Caption = 'Rent Increase %';
                    ToolTip = 'Enter the rent increase percentage for this year.';

                    trigger OnValidate()
                    var
                        PreviousYearRecord: Record "Merge SameSqure SubPage";
                        IncreaseFactor: Decimal;
                    begin
                        // Ensure that Rent Increase % is not negative
                        if Rec."MS_Rent Increase %" < 0 then
                            Error('Rent Increase % cannot be negative.');

                        // Skip calculation for the first year
                        if Rec.MS_Year = 1 then
                            exit;

                        // Fetch the previous year's record
                        PreviousYearRecord.SetRange("Proposal ID", Rec."Proposal ID");
                        PreviousYearRecord.SetRange("MS_Year", Rec.MS_Year - 1);

                        if PreviousYearRecord.FindFirst() then begin
                            // Calculate the new rate for the current year
                            IncreaseFactor := 1 + (Rec."MS_Rent Increase %" / 100);
                            Rec."MS_Rate per Sq.Ft" := PreviousYearRecord."MS_Rate per Sq.Ft" * IncreaseFactor;

                            // Recalculate Annual Amount
                            Rec."MS_Annual Amount" := Rec."MS_Rate per Sq.Ft" * Rec."MS_Unit Sq Ft";

                            // Update Final Annual Amount to match Annual Amount
                            Rec."MS_Final Annual Amount" := Rec."MS_Annual Amount";

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
                field("MS_Annual Amount"; rec."MS_Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Annual Amount';
                    Editable = false;
                    ToolTip = 'Displays the calculated annual amount for the year.';
                    DecimalPlaces = 2 : 2;
                }
                field("MS_Round off"; rec."MS_Round off")
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

                field("MS_Final Annual Amount"; rec."MS_Final Annual Amount")
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
                field("MS_Per Day Rent"; rec."MS_Per Day Rent")
                {
                    ApplicationArea = All;
                    Caption = 'Per Day Rent';
                    Editable = false;
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
                    ToolTip = 'Displays the total contract amount calculated from all merged units.';
                }

                field("TotalRoundOff"; rec.TotalRoundOff)
                {
                    Caption = 'Round Off';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Displays the total round off amount applied to the contract.';
                }

                field("TotalFinalAmount"; rec.TotalFinalAmount)
                {
                    Caption = 'Total Final Contract Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Displays the total final contract amount after applying round off to all merged units.';
                }

                field("TotalFirstAnnualAmount"; rec.TotalFirstAnnualAmount)
                {
                    Caption = 'Total Annual Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Displays the total annual amount for the first year of the contract.';
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
                    MergeSameSquareRec: Record "Merge SameSqure SubPage";
                    SubLeaseMergeRec: Record "Sub Lease Merged Units";
                    PerDayRevnue: Record "Per Day Rent for Revenue";
                    PerDayRevenueCalc: Decimal; // Variable to store the calculated revenue
                begin
                    if Rec."Proposal ID" = 0 then
                        Error('Proposal ID is missing or not assigned.');

                    // Fetch data from the Merge SameSqure SubPage table
                    MergeSameSquareRec.SetRange("Proposal ID", Rec."Proposal ID");

                    // Fetch data from the Sub Lease Merged Units table
                    SubLeaseMergeRec.SetRange("Proposal ID", Rec."Proposal ID");

                    // Fetch the first record from the Merge SameSqure SubPage table
                    if MergeSameSquareRec.FindSet() then
                        repeat
                            // Loop through Sub Lease Merged Units and fetch relevant data
                            if SubLeaseMergeRec.FindSet() then
                                repeat
                                    PerDayRevnue.Init();

                                    // Initialize the record in the current grid with data from both tables
                                    PerDayRevnue."Proposal ID" := MergeSameSquareRec."Proposal ID";
                                    PerDayRevnue."Year" := MergeSameSquareRec."MS_Year"; // From Merge SameSqure SubPage
                                    PerDayRevnue."Sq.Ft" := SubLeaseMergeRec."Unit Size"; // From Sub Lease Merged Units
                                    PerDayRevnue."Unit ID" := CopyStr(SubLeaseMergeRec."Single Unit Name", 1, StrLen(SubLeaseMergeRec."Single Unit Name")); // From Sub Lease Merged Units

                                    // Calculate Per Day Revenue using the updated formula
                                    if MergeSameSquareRec."MS_Unit Sq Ft" = 0 then
                                        Error('MS Unit Sq Ft cannot be zero for Proposal ID %1.', MergeSameSquareRec."Proposal ID");

                                    // Directly calculate without rounding
                                    PerDayRevenueCalc := MergeSameSquareRec."MS_Per Day Rent" * SubLeaseMergeRec."Unit Size" / MergeSameSquareRec."MS_Unit Sq Ft";
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
        LeaseProposalRec: Record "Lease Proposal Details"; // Replace with your actual Lease Proposal table name
        MergeSameSquareSubPage: Record "Merge SameSqure SubPage";
        lTotalFinalAmount: Decimal;
        FirstYearAnnualAmount: Decimal; // Variable for the first year's annual amount
        vatPer: Integer;
    begin
        lTotalFinalAmount := 0;
        FirstYearAnnualAmount := 0; // Initialize to 0

        // Filter records by the current Proposal ID
        MergeSameSquareSubPage.SetRange("Proposal ID", Rec."Proposal ID");

        // Sum up the values for the filtered records
        if MergeSameSquareSubPage.FindSet() then
            repeat
                lTotalFinalAmount += MergeSameSquareSubPage."MS_Final Annual Amount";

                // Check for the first year and assign its Final Annual Amount
                if MergeSameSquareSubPage.MS_Year = 1 then
                    FirstYearAnnualAmount := MergeSameSquareSubPage."MS_Final Annual Amount";
            until MergeSameSquareSubPage.Next() = 0;

        // Update Lease Proposal Details with calculated totals
        LeaseProposalRec.SetRange("Proposal ID", Rec."Proposal ID");
        if LeaseProposalRec.FindSet() then begin
            LeaseProposalRec."Rent Amount" := FirstYearAnnualAmount; // Update Rent Amount with the first year's Final Annual Amount
            LeaseProposalRec."Annual Rent Amount" := lTotalFinalAmount; // Update Annual Rent Amount with the Total Final Amount

            if LeaseProposalRec."Rent Amount VAT %" = LeaseProposalRec."Rent Amount VAT %"::"5%" then
                vatPer := 5
            else
                vatPer := 0;

            LeaseProposalRec."Rent VAT Amount" := LeaseProposalRec."Annual Rent Amount" * (vatPer / 100);
            LeaseProposalRec."Rent Amount Including VAT" := LeaseProposalRec."Annual Rent Amount" + LeaseProposalRec."Rent VAT Amount";

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
        if Rec."MS_Start Date" = 0D then
            Error('Start Date is not valid.');
        if Rec."MS_End Date" = 0D then
            Error('End Date is not valid.');
        if Rec."MS_End Date" < Rec."MS_Start Date" then
            Error('End Date cannot be earlier than Start Date.');

        // Initialize TotalDays
        TotalDays := 0;

        // Loop through each day between Start Date and End Date
        CurrentDate := Rec."MS_Start Date";
        while CurrentDate <= Rec."MS_End Date" do begin
            // Check if the current date is in a leap year and is February 29
            if IsLeapYear(Date2DMY(CurrentDate, 3)) and (Date2DMY(CurrentDate, 2) = 2) and (Date2DMY(CurrentDate, 1) = 29) then
                TotalDays += 1; // Add an extra day for February 29

            CurrentDate += 1; // Move to the next day
        end;

        // Calculate total number of days
        Rec."MS_Number of Days" := Rec."MS_End Date" - Rec."MS_Start Date" + 1;

        // Add extra day if leap year logic applies
        Rec."MS_Number of Days" += TotalDays;

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
        if Rec.MS_Year = 1 then begin
            if (Rec."MS_Rate per Sq.Ft" > 0) and (Rec."MS_Unit Sq Ft" > 0) then
                Rec."MS_Annual Amount" := Rec."MS_Rate per Sq.Ft" * Rec."MS_Unit Sq Ft"
            else
                Rec."MS_Annual Amount" := 0;
        end else
            if (Rec."MS_Rate per Sq.Ft" > 0) and (Rec."MS_Unit Sq Ft" > 0) then
                Rec."MS_Annual Amount" := Rec."MS_Rate per Sq.Ft" * Rec."MS_Unit Sq Ft"
            else
                Rec."MS_Annual Amount" := 0;

        Rec.Modify();
        CurrPage.Update();
    end;

    //-----------------Calculate Annual Amount -----------------//

    //-----------------Calculate Final Annual Amount -----------------//

    local procedure RecalculateFinalAnnualAmount()
    var
        DaysInYear: Integer;
        DaysInPeriod: Integer;
        ProratedAmount: Decimal;
        LeapDay: Date;
    begin
        ProratedAmount := 0;

        // If dates are not set, set Final Annual Amount to Annual Amount + Round off
        if (Rec."MS_Start Date" = 0D) or (Rec."MS_End Date" = 0D) then begin
            Rec."MS_Final Annual Amount" := Rec."MS_Annual Amount" + Rec."MS_Round off";
            Rec.Modify();
            CurrPage.Update();
            exit;
        end;

        if Rec."MS_End Date" < Rec."MS_Start Date" then
            Error('End Date cannot be earlier than Start Date.');

        DaysInPeriod := Rec."MS_End Date" - Rec."MS_Start Date" + 1;

        DaysInYear := 365;

        if IsLeapYear(Date2DMY(Rec."MS_Start Date", 3)) then begin
            LeapDay := DMY2Date(29, 2, Date2DMY(Rec."MS_Start Date", 3));

            if (LeapDay >= Rec."MS_Start Date") and (LeapDay <= Rec."MS_End Date") then
                DaysInYear := 366;
        end;

        ProratedAmount := (Rec."MS_Annual Amount" * DaysInPeriod) / DaysInYear;

        // Apply round off on top of the prorated sum
        Rec."MS_Final Annual Amount" := ProratedAmount + Rec."MS_Round off";

        Rec.Modify();
        CurrPage.Update();
    end;



    //-----------------Calculate Final Annual Amount -----------------//

    //-----------------Calculate Per Day Rent -----------------//

    local procedure RecalculatePerDayRent()
    begin
        if Rec."MS_Number of Days" > 0 then
            Rec."MS_Per Day Rent" := Rec."MS_Final Annual Amount" / Rec."MS_Number of Days"
        else
            Rec."MS_Per Day Rent" := 0;

        Rec.Modify();
        CurrPage.Update();
    end;

    //-----------------Calculate Per Day Rent -----------------//
}
