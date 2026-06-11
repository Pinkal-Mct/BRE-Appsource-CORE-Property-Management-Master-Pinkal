page 73209683 "BLRCR MergeLum_AnnualAmountSP"
{
    PageType = ListPart;
    SourceTable = "BLRCRMergeLumAnnualAmountSP";
    ApplicationArea = All;
    Caption = 'Merge Lum_AnnualAmount SubPage';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID"; rec."BLRID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the record.';
                }
                field("ML_Merged Unit ID"; rec."BLRML_Merged Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Merged Unit ID';
                    ToolTip = 'Unique identifier for the merged unit.';
                }
                field("ML_Unit ID"; rec."BLRML_Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Unit ID';
                    ToolTip = 'Unique identifier for the unit.';
                }
                field("ML_Year"; rec."BLRML_Year")
                {
                    ApplicationArea = All;
                    Caption = 'Year';
                    ToolTip = 'Year for which the annual amount is calculated.';
                }
                field("ML_Start Date"; rec."BLRML_Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    ToolTip = 'Start date of the annual amount period.';
                    trigger OnValidate()
                    begin
                        // Recalculate Number of Days
                        RecalculateNumberOfDays();
                    end;
                }

                field("ML_End Date"; rec."BLRML_End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    ToolTip = 'End date of the annual amount period.';
                    trigger OnValidate()
                    begin
                        // Recalculate Number of Days
                        RecalculateNumberOfDays();
                    end;
                }
                field("ML_Number of Days"; rec."BLRML_Number of Days")
                {
                    ApplicationArea = All;
                    Caption = 'Number of Days';
                    ToolTip = 'Number of days in the annual amount period.';
                }
                field("ML_Unit Sq Ft"; rec."BLRML_Unit Sq Ft")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Sq Ft';
                    Editable = false;
                    ToolTip = 'Square footage of the unit.';
                    trigger OnValidate()
                    begin
                        // RecalculateAnnualAmount();
                    end;
                }
                field("ML_Rate per Sq.Ft"; rec."BLRML_Rate per Sq.Ft")
                {
                    ApplicationArea = All;
                    Caption = 'Rate per Sq.Ft';
                    Editable = false;
                    ToolTip = 'Rate per square foot for the unit.';
                    trigger OnValidate()
                    begin
                        // RecalculateAnnualAmount();
                    end;
                }
                field("ML_Rent Increase %"; rec."BLRML_Rent Increase %")
                {
                    ApplicationArea = All;
                    Caption = 'Rent Increase %';
                    ToolTip = 'Percentage increase in rent for the current year compared to the previous year.';
                    trigger OnValidate()
                    begin
                        if Rec."BLRML_Rent Increase %" < 0 then
                            Error('Rent Increase % cannot be negative.');

                        // Calculate the annual amount and final annual amount based on rent increase
                        if Rec."BLRML_Year" > 1 then
                            RecalculateRentIncrease();

                        Rec.Modify();
                        // Recalculate totals
                        RecalculateTotals();
                    end;
                }

                field("ML_Annual Amount"; rec."BLRML_Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Annual Amount';
                    ToolTip = 'Enter the annual amount manually or let it be calculated based on rate per sq.ft.';
                    DecimalPlaces = 2 : 2;
                    trigger OnValidate()
                    var
                        PreviousYearRecord: Record "BLRCRMergeLumAnnualAmountSP";
                        RentIncreasePercentage: Decimal;
                    begin
                        // Set Final Annual Amount to the entered Annual Amount
                        Rec."BLRML_Final Annual Amount" := Rec."BLRML_Annual Amount";

                        // If this is the 2nd year or later, calculate the rent increase percentage
                        if Rec."BLRML_Year" > 1 then begin
                            // Fetch the previous year's record
                            PreviousYearRecord.SetRange("BLRID", Rec."BLRID");
                            PreviousYearRecord.SetRange(BLRML_Year, Rec."BLRML_Year" - 1);

                            if PreviousYearRecord.FindFirst() then begin
                                // Calculate the rent increase percentage based on the entered annual amount
                                if PreviousYearRecord."BLRML_Final Annual Amount" > 0 then
                                    RentIncreasePercentage :=
                                        ((Rec."BLRML_Annual Amount" - PreviousYearRecord."BLRML_Final Annual Amount") /
                                        PreviousYearRecord."BLRML_Final Annual Amount") * 100
                                else
                                    RentIncreasePercentage := 0;

                                // Update the Rent Increase % field with precise decimal value
                                Rec."BLRML_Rent Increase %" := RentIncreasePercentage;
                            end else
                                Error('No record found for the previous year to base the calculation.');
                        end;

                        Rec.Modify();
                        // Recalculate totals and per day rent
                        RecalculateTotals();
                        RecalculatePerDayRent();
                    end;
                }
                field("ML_Round off"; rec."BLRML_Round off")
                {
                    ApplicationArea = All;
                    Caption = 'Round off';
                    ToolTip = 'Enter the round off value. The Final Annual Amount will be recalculated automatically.';
                    trigger OnValidate()
                    begin
                        // Recalculate the final annual amount
                        if Rec."BLRML_Round off" = 0 then
                            Rec."BLRML_Final Annual Amount" := Rec."BLRML_Annual Amount"
                        else
                            Rec."BLRML_Final Annual Amount" := Rec."BLRML_Annual Amount" + Rec."BLRML_Round off";

                        Rec.Modify();
                        // Recalculate totals
                        RecalculateTotals();
                    end;
                }
                field("ML_Final Annual Amount"; rec."BLRML_Final Annual Amount")
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
                field("ML_Per Day Rent"; rec."BLRML_Per Day Rent")
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
                field("TotalAnnualAmount"; rec."BLRTotalAnnualAmount")
                {
                    Caption = 'Total Contract Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Total annual amount for all years in the contract renewal.';
                }

                field("TotalRoundOff"; rec."BLRTotalRoundOff")
                {
                    Caption = 'Round Off';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Total round off amount for all years in the contract renewal.';
                }

                field("TotalFinalAmount"; rec."BLRTotalFinalAmount")
                {
                    Caption = 'Total Final Contract Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Total final contract amount after applying round off for all years.';
                }

                field("TotalFirstAnnualAmount"; rec."BLRTotalFirstAnnualAmount")
                {
                    Caption = 'Total Annual Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'Total annual amount for the first year of the contract renewal.';
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
                ToolTip = 'Insert data into the Per Day Rent for Revenue table based on the current record.';

                trigger OnAction()
                var
                    MergeLumSquareRec: Record "BLRCRMergeLumAnnualAmountSP";
                    SubLeaseMergeRec: Record "BLRCRSubLeaseMergedUnits";
                    PerDayRevnue: Record "BLRCRPerDayRentforRevenue";
                    PerDayRevenueCalc: Decimal; // Variable to store the calculated revenue
                begin
                    if Rec."BLRID" = 0 then
                        Error('ID is missing or not assigned.');

                    // Fetch data from the Merge Lum_AnnualAmount SubPage table
                    MergeLumSquareRec.SetRange("BLRID", Rec."BLRID");

                    // Fetch data from the Sub Lease Merged Units table
                    SubLeaseMergeRec.SetRange("BLRID", Rec."BLRID");

                    // Fetch the first record from the Merge Lum_AnnualAmount SubPage table
                    if MergeLumSquareRec.FindSet() then
                        repeat
                            // Loop through Sub Lease Merged Units and fetch relevant data
                            if SubLeaseMergeRec.FindSet() then
                                repeat
                                    PerDayRevnue.Init();
                                    // Initialize the record in the current grid with data from both tables
                                    PerDayRevnue."BLRContract Renewal Id" := MergeLumSquareRec."BLRID";
                                    PerDayRevnue."BLRYear" := MergeLumSquareRec."BLRML_Year"; // From Merge Lum_AnnualAmount SubPage
                                    PerDayRevnue."BLRSq.Ft" := SubLeaseMergeRec."BLRUnit Size"; // From Sub Lease Merged Units
                                    PerDayRevnue."BLRUnit ID" := CopyStr(SubLeaseMergeRec."BLRSingle Unit Name", 1, StrLen(SubLeaseMergeRec."BLRSingle Unit Name")); // From Sub Lease Merged Units

                                    // Calculate Per Day Revenue using the updated formula
                                    if MergeLumSquareRec."BLRML_Unit Sq Ft" = 0 then
                                        Error('ML Unit Sq Ft cannot be zero for  ID %1.', MergeLumSquareRec."BLRID");

                                    PerDayRevenueCalc := MergeLumSquareRec."BLRML_Per Day Rent" * SubLeaseMergeRec."BLRUnit Size" / MergeLumSquareRec."BLRML_Unit Sq Ft";
                                    PerDayRevnue."BLRPer Day Rent Per Unit" := PerDayRevenueCalc; // Assign the calculated value

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
        if Rec."BLRML_Start Date" = 0D then
            Error('Start Date is not valid.');
        if Rec."BLRML_End Date" = 0D then
            Error('End Date is not valid.');
        if Rec."BLRML_End Date" < Rec."BLRML_Start Date" then
            Error('End Date cannot be earlier than Start Date.');

        // Initialize variables
        StartYear := Date2DMY(Rec."BLRML_Start Date", 3); // Extract year of Start Date
        EndYear := Date2DMY(Rec."BLRML_End Date", 3);    // Extract year of End Date
        TotalDays := Rec."BLRML_End Date" - Rec."BLRML_Start Date" + 1;
        IsLeapYearInRange := false;

        // Check each year in the range for leap year
        for CurrentYear := StartYear to EndYear do
            if IsLeapYear(CurrentYear) then
                // Ensure the leap day (Feb 29) falls within the Start and End Date
                if (DMY2Date(29, 2, CurrentYear) >= Rec."BLRML_Start Date") and
                   (DMY2Date(29, 2, CurrentYear) <= Rec."BLRML_End Date") then begin
                    IsLeapYearInRange := true;
                    break; // Stop checking further once a leap year is found
                end;

        // If a leap year is in range, ensure at least one year has 366 days
        if IsLeapYearInRange then
            TotalDays := TotalDays + 1;

        // Set the calculated number of days
        Rec."BLRML_Number of Days" := TotalDays;

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


    //-----------------Calculate Per Day Rent -----------------//
    local procedure RecalculatePerDayRent()
    begin
        if Rec."BLRML_Number of Days" > 0 then
            Rec."BLRML_Per Day Rent" := Rec."BLRML_Final Annual Amount" / Rec."BLRML_Number of Days"
        else
            Rec."BLRML_Per Day Rent" := 0;

        Rec.Modify();
        CurrPage.Update();
    end;
    //-----------------Calculate Per Day Rent -----------------//


    //-----------------Calculate Rent Increase -----------------//
    local procedure RecalculateRentIncrease()
    var
        PreviousYearRecord: Record "BLRCRMergeLumAnnualAmountSP";
        IncreaseFactor: Decimal;
    begin
        // Fetch the previous year's record
        PreviousYearRecord.SetRange("BLRID", Rec."BLRID");
        PreviousYearRecord.SetRange(BLRML_Year, Rec."BLRML_Year" - 1);

        if PreviousYearRecord.FindFirst() then begin
            IncreaseFactor := 1 + (Rec."BLRML_Rent Increase %" / 100);
            Rec."BLRML_Annual Amount" := PreviousYearRecord."BLRML_Final Annual Amount" * IncreaseFactor;
            Rec."BLRML_Final Annual Amount" := Rec."BLRML_Annual Amount";

            // Recalculate Per Day Rent
            RecalculatePerDayRent();
        end else
            Error('No record found for the previous year to base the calculation.');
    end;
    //-----------------Calculate Rent Increase -----------------//

    //-----------------Calculate Total -----------------//
    local procedure RecalculateTotals()
    var

        LeaseProposalRec: Record "BLRContractRenewal";
        RecordTemp: Record "BLRCRMergeLumAnnualAmountSP";
        TotalAnnual: Decimal;
        TotalFinal: Decimal;
        lTotalRoundOff: Decimal;
        FirstYearAnnualAmount: Decimal; // Variable for the first year's annual amount

    begin
        // Initialize totals
        TotalAnnual := 0;
        TotalFinal := 0;
        lTotalRoundOff := 0;
        FirstYearAnnualAmount := 0; // Initialize to 0

        // Loop through all records for the same Proposal ID to calculate totals
        RecordTemp.SetRange("BLRID", Rec."BLRID");
        if RecordTemp.FindSet() then
            repeat
                TotalAnnual += RecordTemp."BLRML_Annual Amount";
                TotalFinal += RecordTemp."BLRML_Final Annual Amount";
                lTotalRoundOff += RecordTemp."BLRML_Round off";

                // Check for the first year and assign its Annual Amount
                if RecordTemp."BLRML_Year" = 1 then
                    FirstYearAnnualAmount := RecordTemp."BLRML_Final Annual Amount";
            until RecordTemp.Next() = 0;

        // Update the totals in the current record
        Rec."BLRTotalAnnualAmount" := TotalAnnual;
        Rec."BLRTotalFinalAmount" := TotalFinal;
        Rec."BLRTotalRoundOff" := lTotalRoundOff;
        Rec."BLRTotalFirstAnnualAmount" := FirstYearAnnualAmount; // Assign the first year's annual amount

        LeaseProposalRec.SetRange("BLRID", Rec."BLRID");
        if LeaseProposalRec.FindSet() then begin
            LeaseProposalRec."BLRRent Amount" := FirstYearAnnualAmount; // Update Rent Amount with the first year's Final Annual Amount
            LeaseProposalRec."BLRContract Amount" := TotalFinal; // Update Annual Rent Amount with the Total Final Amount

            LeaseProposalRec.Modify(); // Save the changes to the Lease Proposal record
        end;

        Rec.Modify();
        CurrPage.Update();
    end;
    //-----------------Calculate Total -----------------//

}