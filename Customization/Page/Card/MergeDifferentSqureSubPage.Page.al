page 50119 "Merge DifferentSqure SubPage"
{
    PageType = ListPart;
    SourceTable = "Merge DifferentSqure SubPage";
    ApplicationArea = All;
    Caption = 'Merge DifferentSqure SubPage';

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
                    ToolTip = 'The unique identifier for the proposal associated with this record.';
                }
                field("MD_Merged Unit ID"; rec."MD_Merged Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Merged Unit ID';
                    Editable = false;
                    ToolTip = 'The unique identifier for the merged unit associated with this record.';
                }
                field("MD_Unit ID"; rec."MD_Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Unit ID';
                    Editable = false;
                    ToolTip = 'The unique identifier for the unit associated with this record.';
                }
                field("MD_Year"; rec.MD_Year)
                {
                    ApplicationArea = All;
                    Caption = 'Year';
                    Editable = false;
                    ToolTip = 'The year associated with this record. It indicates the financial year for the rent calculation.';
                }
                field("MD_Start Date"; rec."MD_Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    Editable = false;
                    ToolTip = 'The start date for the rent calculation. It should be the first day of the financial year.';
                }
                field("MD_End Date"; rec."MD_End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    Editable = false;
                    ToolTip = 'The end date for the rent calculation. It should be the last day of the financial year.';
                }
                field("MD_Number of Days"; rec."MD_Number of Days")
                {
                    ApplicationArea = All;
                    Caption = 'Number of Days';
                    Editable = false;
                    ToolTip = 'The total number of days in the financial year for which the rent is calculated. This should be 365 or 366 for leap years.';

                    trigger OnValidate()
                    begin
                        RecalculateNumberOfDays();
                    end;
                }
                field("MD_Unit Sq Ft"; rec."MD_Unit Sq Ft")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Sq Ft';
                    Editable = false;
                    ToolTip = 'The size of the unit in square feet. This is used to calculate the rent based on the rate per square foot.';

                    trigger OnValidate()
                    begin
                        RecalculateAnnualAmount();
                    end;
                }
                field("MD_Rate per Sq.Ft"; rec."MD_Rate per Sq.Ft")
                {
                    ApplicationArea = All;
                    Caption = 'Rate per Sq.Ft';
                    ToolTip = 'The rate per square foot for the unit. This is used to calculate the rent based on the rate per square foot.';

                    trigger OnValidate()
                    var
                        PreviousYearRecord: Record "Merge DifferentSqure SubPage";
                        PreviousRate: Decimal;
                    begin
                        // Ensure the value is not negative
                        if Rec."MD_Rate per Sq.Ft" < 0 then
                            Error('Rate per Sq.Ft cannot be negative.');

                        // Fetch the previous year's record to calculate Rent Increase %
                        PreviousYearRecord.SetRange("Proposal ID", Rec."Proposal ID");
                        PreviousYearRecord.SetRange("MD_Year", Rec.MD_Year - 1);
                        PreviousYearRecord.SetRange("MD_Unit ID", Rec."MD_Unit ID");

                        if PreviousYearRecord.FindFirst() then begin
                            PreviousRate := PreviousYearRecord."MD_Rate per Sq.Ft";

                            // Ensure previous rate is greater than 0 to avoid division by zero
                            if PreviousRate > 0 then
                                Rec."MD_Rent Increase %" :=
                                    ((Rec."MD_Rate per Sq.Ft" - PreviousRate) / PreviousRate) * 100
                            else
                                Rec."MD_Rent Increase %" := 0; // No increase if previous rate is 0
                        end else
                            Rec."MD_Rent Increase %" := 0; // No increase for the first year or no previous record

                        // Recalculate Annual Amount
                        if (Rec."MD_Rate per Sq.Ft" > 0) and (Rec."MD_Unit Sq Ft" > 0) then
                            Rec."MD_Annual Amount" := Rec."MD_Rate per Sq.Ft" * Rec."MD_Unit Sq Ft"
                        else
                            Rec."MD_Annual Amount" := 0;

                        // Set Final Annual Amount equal to Annual Amount
                        Rec."MD_Final Annual Amount" := Rec."MD_Annual Amount";

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

                field("MD_Rent Increase %"; rec."MD_Rent Increase %")
                {
                    ApplicationArea = All;
                    Caption = 'Rent Increase %';
                    ToolTip = 'The percentage increase in the rate per square foot for the unit. This is used to calculate the rent based on the rate per square foot.';

                    trigger OnValidate()
                    var
                        PreviousYearRecord: Record "Merge DifferentSqure SubPage";
                        IncreaseFactor: Decimal;
                    begin
                        // Ensure that Rent Increase % is not negative
                        if Rec."MD_Rent Increase %" < 0 then
                            Error('Rent Increase % cannot be negative.');

                        // Skip calculation for the first year
                        if Rec.MD_Year = 1 then
                            exit;

                        // Fetch the previous year's record
                        PreviousYearRecord.SetRange("Proposal ID", Rec."Proposal ID");
                        PreviousYearRecord.SetRange("MD_Year", Rec.MD_Year - 1);
                        PreviousYearRecord.SetRange("MD_Unit ID", Rec."MD_Unit ID");

                        if PreviousYearRecord.FindFirst() then begin
                            // Calculate the new rate for the current year
                            IncreaseFactor := 1 + (Rec."MD_Rent Increase %" / 100);
                            Rec."MD_Rate per Sq.Ft" := PreviousYearRecord."MD_Rate per Sq.Ft" * IncreaseFactor;

                            // Recalculate Annual Amount
                            Rec."MD_Annual Amount" := Rec."MD_Rate per Sq.Ft" * Rec."MD_Unit Sq Ft";

                            // Update Final Annual Amount to match Annual Amount
                            Rec."MD_Final Annual Amount" := Rec."MD_Annual Amount";

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
                field("MD_Annual Amount"; rec."MD_Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Annual Amount';
                    Editable = false;
                    ToolTip = 'The total annual amount for the unit. This is calculated as the rate per square foot multiplied by the unit square footage.';
                }
                field("MD_Round off"; rec."MD_Round off")
                {
                    ApplicationArea = All;
                    Caption = 'Round off';
                    Editable = true;
                    ToolTip = 'The amount to be rounded off for the unit. This is used to calculate the final annual amount.';

                    trigger OnValidate()
                    begin
                        RecalculateFinalAnnualAmount();
                        RecalculatePerDayRent(); // Update Per Day Rent when Round Off changes
                        RecalculateTotals();     // Update totals dynamically
                    end;
                }
                field("MD_Final Annual Amount"; rec."MD_Final Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Final Annual Amount';
                    Editable = false;
                    ToolTip = 'The final annual amount after applying the round off. This is the amount that will be used for invoicing.';

                    trigger OnValidate()
                    begin
                        RecalculatePerDayRent(); // Update Per Day Rent when Final Annual Amount changes
                        RecalculateTotals();     // Update totals dynamically
                    end;
                }
                field("MD_Per Day Rent"; rec."MD_Per Day Rent")
                {
                    ApplicationArea = All;
                    Caption = 'Per Day Rent';
                    Editable = false;
                    DecimalPlaces = 2 : 2;
                    ToolTip = 'The rent amount per day for the unit. This is calculated based on the final annual amount divided by the number of days in the financial year.';
                }
            }

            group("Total Rent Caculation")
            {

                field("TotalAnnualAmount"; rec.TotalAnnualAmount)
                {
                    Caption = 'Total Contract Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'The total contract amount for the proposal. This is the sum of all annual amounts for the units in the proposal.';
                }

                field("TotalRoundOff"; rec.TotalRoundOff)
                {
                    Caption = 'Round Off';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'The total round off amount for the proposal. This is the sum of all round off amounts for the units in the proposal.';
                }

                field("TotalFinalAmount"; rec.TotalFinalAmount)
                {
                    Caption = 'Total Final Contract Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'The total final contract amount for the proposal. This is the sum of all final annual amounts for the units in the proposal.';
                }

                field("TotalFirstAnnualAmount"; rec.TotalFirstAnnualAmount)
                {
                    Caption = 'Total Annual Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'The total annual amount for the first year of the proposal. This is the sum of all final annual amounts for the first year of the units in the proposal.';
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
                ToolTip = 'Insert Data from Merge Different Square SubPage and Sub Lease Merged Units';
                ApplicationArea = All;
                Caption = 'Insert Data';
                Image = NewDocument; // Optionally, define an icon

                trigger OnAction()
                var
                    MergeDiffSquareRec: Record "Merge DifferentSqure SubPage";
                    MergeDiffSquareRecFromPerDayRevenue: Record "Merge DifferentSqure SubPage";
                    SubLeaseMergeRec: Record "Sub Lease Merged Units";
                    PerDayRevnue: Record "Per Day Rent for Revenue";
                    YearList: List of [Integer];
                    YearItem: Integer;
                begin
                    if Rec."Proposal ID" = 0 then
                        Error('Proposal ID is missing or not assigned.');

                    // Fetch distinct years from the Merge DifferentSqure SubPage table
                    MergeDiffSquareRec.SetRange("Proposal ID", Rec."Proposal ID");
                    if MergeDiffSquareRec.FindSet() then
                        repeat
                            if not YearList.Contains(MergeDiffSquareRec."MD_Year") then
                                YearList.Add(MergeDiffSquareRec."MD_Year");
                        until MergeDiffSquareRec.Next() = 0
                    else
                        Error('No matching records found in Merge DifferentSqure SubPage for the given Proposal ID.');

                    // Loop through each year and fetch corresponding data
                    foreach YearItem in YearList do begin
                        MergeDiffSquareRec.SetRange("Proposal ID", Rec."Proposal ID");
                        MergeDiffSquareRec.SetRange("MD_Year", YearItem);

                        if MergeDiffSquareRec.FindSet() then
                            repeat
                                // Loop through Sub Lease Merged Units and fetch relevant data
                                SubLeaseMergeRec.SetRange("Proposal ID", Rec."Proposal ID");
                                if SubLeaseMergeRec.FindSet() then
                                    repeat
                                        PerDayRevnue.Init();

                                        // Initialize the record in the current grid with data from both tables
                                        PerDayRevnue."Proposal ID" := MergeDiffSquareRec."Proposal ID";
                                        PerDayRevnue."Year" := MergeDiffSquareRec."MD_Year"; // From Merge DifferentSquare SubPage
                                        PerDayRevnue."Sq.Ft" := SubLeaseMergeRec."Unit Size"; // From Sub Lease Merged Units
                                        PerDayRevnue."Unit ID" := CopyStr(SubLeaseMergeRec."Single Unit Name", 1, StrLen(SubLeaseMergeRec."Single Unit Name")); // From Sub Lease Merged Units

                                        MergeDiffSquareRecFromPerDayRevenue.SetRange("MD_Unit ID", PerDayRevnue."Unit ID");
                                        if MergeDiffSquareRecFromPerDayRevenue.FindFirst() then
                                            // Directly assign the Per Day Rent value from MergeDiffSquareRec table to PerDayRevnue
                                            PerDayRevnue."Per Day Rent Per Unit" := MergeDiffSquareRecFromPerDayRevenue."MD_Per Day Rent";

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
        LeaseProposalRec: Record "Lease Proposal Details"; // Replace with your actual Lease Proposal table name
        MergeDifferentSquareSubPage: Record "Merge DifferentSqure SubPage";
        lTotalFinalAmount: Decimal;
        FirstYearAnnualAmount: Decimal; // Variable for the first year's annual amount
        vatPer: Integer;
    begin
        lTotalFinalAmount := 0;
        FirstYearAnnualAmount := 0; // Initialize to 0

        // Filter records by the current Proposal ID
        MergeDifferentSquareSubPage.SetRange("Proposal ID", Rec."Proposal ID");

        // Sum up the values for the filtered records
        if MergeDifferentSquareSubPage.FindSet() then
            repeat
                lTotalFinalAmount += MergeDifferentSquareSubPage."MD_Final Annual Amount";

                // Check for the first year and add its Final Annual Amount to FirstYearAnnualAmount
                if MergeDifferentSquareSubPage.MD_Year = 1 then
                    FirstYearAnnualAmount += MergeDifferentSquareSubPage."MD_Final Annual Amount"; // Sum all Final Annual Amounts for 1st Year
            until MergeDifferentSquareSubPage.Next() = 0;

        // Update Lease Proposal Details with calculated totals
        LeaseProposalRec.SetRange("Proposal ID", Rec."Proposal ID");
        if LeaseProposalRec.FindSet() then begin
            LeaseProposalRec."Rent Amount" := FirstYearAnnualAmount; // Update Rent Amount with the sum of first year's Final Annual Amount
            LeaseProposalRec."Annual Rent Amount" := lTotalFinalAmount; // Update Annual Rent Amount with the total of all years' Final Annual Amounts

            if LeaseProposalRec."Rent Amount VAT %" = LeaseProposalRec."Rent Amount VAT %"::"5%" then
                vatPer := 5
            else
                vatPer := 0;

            LeaseProposalRec."Rent VAT Amount" := LeaseProposalRec."Annual Rent Amount" * (vatPer / 100);
            LeaseProposalRec."Rent Amount Including VAT" := LeaseProposalRec."Annual Rent Amount" + LeaseProposalRec."Rent VAT Amount";

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
        if Rec."MD_Start Date" = 0D then
            Error('Start Date is not valid.');
        if Rec."MD_End Date" = 0D then
            Error('End Date is not valid.');
        if Rec."MD_End Date" < Rec."MD_Start Date" then
            Error('End Date cannot be earlier than Start Date.');

        // Initialize TotalDays
        TotalDays := 0;

        // Loop through each day between Start Date and End Date
        CurrentDate := Rec."MD_Start Date";
        while CurrentDate <= Rec."MD_End Date" do begin
            // Check if the current date is in a leap year and is February 29
            if IsLeapYear(Date2DMY(CurrentDate, 3)) and (Date2DMY(CurrentDate, 2) = 2) and (Date2DMY(CurrentDate, 1) = 29) then
                TotalDays += 1; // Add an extra day for February 29

            CurrentDate += 1; // Move to the next day
        end;

        // Calculate total number of days
        Rec."MD_Number of Days" := Rec."MD_End Date" - Rec."MD_Start Date" + 1;

        // Add extra day if leap year logic applies
        Rec."MD_Number of Days" += TotalDays;

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
        if Rec.MD_Year = 1 then begin
            if (Rec."MD_Rate per Sq.Ft" > 0) and (Rec."MD_Unit Sq Ft" > 0) then
                Rec."MD_Annual Amount" := Rec."MD_Rate per Sq.Ft" * Rec."MD_Unit Sq Ft"
            else
                Rec."MD_Annual Amount" := 0;
        end else
            if (Rec."MD_Rate per Sq.Ft" > 0) and (Rec."MD_Unit Sq Ft" > 0) then
                Rec."MD_Annual Amount" := Rec."MD_Rate per Sq.Ft" * Rec."MD_Unit Sq Ft"
            else
                Rec."MD_Annual Amount" := 0;

        Rec.Modify();
        CurrPage.Update();
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
        if (Rec."MD_Start Date" = 0D) or (Rec."MD_End Date" = 0D) then begin
            Rec."MD_Final Annual Amount" := Rec."MD_Annual Amount" + Rec."MD_Round off";
            Rec.Modify();
            CurrPage.Update();
            exit;
        end;

        if Rec."MD_End Date" < Rec."MD_Start Date" then
            Error('End Date cannot be earlier than Start Date.');

        DaysInPeriod := Rec."MD_End Date" - Rec."MD_Start Date" + 1;

        DaysInYear := 365;

        if IsLeapYear(Date2DMY(Rec."MD_Start Date", 3)) then begin
            LeapDay := DMY2Date(29, 2, Date2DMY(Rec."MD_Start Date", 3));

            if (LeapDay >= Rec."MD_Start Date") and (LeapDay <= Rec."MD_End Date") then
                DaysInYear := 366;
        end;

        ProratedAmount := (Rec."MD_Annual Amount" * DaysInPeriod) / DaysInYear;
        // Apply round off on top of the prorated sum
        Rec."MD_Final Annual Amount" := ProratedAmount + Rec."MD_Round off";

        Rec.Modify();
        CurrPage.Update();
    end;

    local procedure RecalculatePerDayRent()
    begin
        if Rec."MD_Number of Days" > 0 then
            Rec."MD_Per Day Rent" := Rec."MD_Final Annual Amount" / Rec."MD_Number of Days"
        else
            Rec."MD_Per Day Rent" := 0;

        Rec.Modify();
        CurrPage.Update();
    end;
}

