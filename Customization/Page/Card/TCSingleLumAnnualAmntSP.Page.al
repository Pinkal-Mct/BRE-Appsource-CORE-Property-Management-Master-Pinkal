page 73209743 "BLRTCSingleLumAnnualAmntSP"
{
    PageType = ListPart;
    SourceTable = "BLRTCSingleLumAnnualAmntSP";
    ApplicationArea = All;
    Caption = 'Single Lum_AnnualAmount SubPage';

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
                field("Contract ID"; rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'The ID of the contract associated with this record.';
                }
                field("SL_Merged Unit ID"; rec."BLRSL_Merged Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Merged Unit ID';
                    Visible = false;
                    ToolTip = 'The ID of the merged unit associated with this record.';
                }
                field("SL_Unit ID"; rec."BLRSL_Unit ID")
                {
                    ApplicationArea = All;
                    Caption = 'Unit ID';
                    Editable = false;
                    ToolTip = 'The ID of the unit associated with this record.';
                }
                field("SL_Year"; rec."BLRSL_Year")
                {
                    ApplicationArea = All;
                    Caption = 'Year';
                    Editable = false;
                    ToolTip = 'The year for which the annual amount is calculated.';
                }
                field("SL_Start Date"; rec."BLRSL_Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    Editable = false;
                    ToolTip = 'The start date for the annual amount calculation.';
                    trigger OnValidate()
                    begin
                        // Recalculate Number of Days
                        RecalculateNumberOfDays();
                    end;
                }

                field("SL_End Date"; rec."BLRSL_End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    Editable = false;
                    ToolTip = 'The end date for the annual amount calculation.';
                    trigger OnValidate()
                    begin
                        // Recalculate Number of Days
                        RecalculateNumberOfDays();
                    end;
                }
                field("SL_Number of Days"; rec."BLRSL_Number of Days")
                {
                    ApplicationArea = All;
                    Caption = 'Number of Days';
                    Editable = false;
                    ToolTip = 'The total number of days between the start and end date.';
                }
                field("SL_Unit Sq Ft"; rec."BLRSL_Unit Sq Ft")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Sq Ft';
                    Editable = false;
                    ToolTip = 'The square footage of the unit associated with this record.';
                    trigger OnValidate()
                    begin
                        // RecalculateAnnualAmount();
                    end;
                }
                field("SL_Rate per Sq.Ft"; rec."BLRSL_Rate per Sq.Ft")
                {
                    ApplicationArea = All;
                    Caption = 'Rate per Sq.Ft';
                    Editable = false;
                    ToolTip = 'The rate per square foot for the unit.';
                    trigger OnValidate()
                    begin
                        // RecalculateAnnualAmount();
                    end;
                }
                field("SL_Rent Increase %"; rec."BLRSL_Rent Increase %")
                {
                    ApplicationArea = All;
                    Caption = 'Rent Increase %';
                    Editable = false;
                    ToolTip = 'The percentage increase in rent for the current year compared to the previous year.';
                    trigger OnValidate()
                    begin
                        if Rec."BLRSL_Rent Increase %" < 0 then
                            Error('Rent Increase % cannot be negative.');

                        // Calculate the annual amount and final annual amount based on rent increase
                        if Rec."BLRSL_Year" > 1 then
                            RecalculateRentIncrease();

                        Rec.Modify();
                        // Recalculate totals
                        RecalculateTotals();
                    end;
                }

                field("SL_Annual Amount"; rec."BLRSL_Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Annual Amount';
                    ToolTip = 'Enter the annual amount manually or let it be calculated based on rate per sq.ft.';
                    DecimalPlaces = 2 : 2;
                    Editable = false;
                    trigger OnValidate()
                    var
                        PreviousYearRecord: Record "BLRCRSingleLumAnnualAmntSP";
                        RentIncreasePercentage: Decimal;
                    begin
                        // Set Final Annual Amount to the entered Annual Amount
                        Rec."BLRSL_Final Annual Amount" := Rec."BLRSL_Annual Amount";

                        // If this is the 2nd year or later, calculate the rent increase percentage
                        if Rec."BLRSL_Year" > 1 then begin
                            // Fetch the previous year's record
                            PreviousYearRecord.SetRange("BLRID", Rec."BLRID");
                            PreviousYearRecord.SetRange(BLRSL_Year, Rec."BLRSL_Year" - 1);

                            if PreviousYearRecord.FindFirst() then begin
                                // Calculate the rent increase percentage based on the entered annual amount
                                if PreviousYearRecord."BLRSL_Final Annual Amount" > 0 then
                                    RentIncreasePercentage :=
                                        ((Rec."BLRSL_Annual Amount" - PreviousYearRecord."BLRSL_Final Annual Amount") /
                                        PreviousYearRecord."BLRSL_Final Annual Amount") * 100
                                else
                                    RentIncreasePercentage := 0;

                                // Update the Rent Increase % field with precise decimal value
                                Rec."BLRSL_Rent Increase %" := RentIncreasePercentage;
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
                field("SL_Round off"; rec."BLRSL_Round off")
                {
                    ApplicationArea = All;
                    Caption = 'Round off';
                    ToolTip = 'Enter the round off value. The Final Annual Amount will be recalculated automatically.';
                    Editable = false;
                    trigger OnValidate()
                    begin
                        // Recalculate the final annual amount
                        RecalculateFinalAnnualAmount();
                        Rec.Modify();
                        // Recalculate totals
                        RecalculateTotals();
                    end;
                }
                field("SL_Final Annual Amount"; rec."BLRSL_Final Annual Amount")
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
                field("SL_Per Day Rent"; rec."BLRSL_Per Day Rent")
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
                    ToolTip = 'The total annual amount for the contract, calculated from all records.';
                }

                field("TotalRoundOff"; rec."BLRTotalRoundOff")
                {
                    Caption = 'Round Off';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'The total round off amount for the contract, calculated from all records.';
                }

                field("TotalFinalAmount"; rec."BLRTotalFinalAmount")
                {
                    Caption = 'Total Final Contract Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'The total final contract amount, including all adjustments and round offs.';
                }


                field("TotalFirstAnnualAmount"; rec."BLRTotalFirstAnnualAmount")
                {
                    Caption = 'Total Annual Amount';
                    ApplicationArea = All;
                    Editable = false; // Make it read-only
                    ToolTip = 'The total annual amount for the first year, calculated from all records.';
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
        if Rec."BLRSL_Start Date" = 0D then
            Error('Start Date is not valid.');
        if Rec."BLRSL_End Date" = 0D then
            Error('End Date is not valid.');
        if Rec."BLRSL_End Date" < Rec."BLRSL_Start Date" then
            Error('End Date cannot be earlier than Start Date.');

        // Initialize variables
        StartYear := Date2DMY(Rec."BLRSL_Start Date", 3); // Extract year of Start Date
        EndYear := Date2DMY(Rec."BLRSL_End Date", 3);    // Extract year of End Date
        TotalDays := Rec."BLRSL_End Date" - Rec."BLRSL_Start Date" + 1;
        IsLeapYearInRange := false;

        // Check each year in the range for leap year
        for CurrentYear := StartYear to EndYear do
            if IsLeapYear(CurrentYear) then
                // Ensure the leap day (Feb 29) falls within the Start and End Date
                if (DMY2Date(29, 2, CurrentYear) >= Rec."BLRSL_Start Date") and
                   (DMY2Date(29, 2, CurrentYear) <= Rec."BLRSL_End Date") then begin
                    IsLeapYearInRange := true;
                    break; // Stop checking further once a leap year is found
                end;


        // If a leap year is in range, ensure at least one year has 366 days
        if IsLeapYearInRange then
            TotalDays := TotalDays + 1;

        // Set the calculated number of days
        Rec."BLRSL_Number of Days" := TotalDays;

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
        if Rec."BLRSL_Number of Days" > 0 then
            Rec."BLRSL_Per Day Rent" := Rec."BLRSL_Final Annual Amount" / Rec."BLRSL_Number of Days"
        else
            Rec."BLRSL_Per Day Rent" := 0;

        Rec.Modify();
        CurrPage.Update();
    end;


    local procedure RecalculateRentIncrease()
    var
        PreviousYearRecord: Record "BLRCRSingleLumAnnualAmntSP";
        IncreaseFactor: Decimal;
    begin
        // Fetch the previous year's record
        PreviousYearRecord.SetRange("BLRID", Rec."BLRID");
        PreviousYearRecord.SetRange(BLRSL_Year, Rec."BLRSL_Year" - 1);

        if PreviousYearRecord.FindFirst() then begin
            IncreaseFactor := 1 + (Rec."BLRSL_Rent Increase %" / 100);
            Rec."BLRSL_Annual Amount" := PreviousYearRecord."BLRSL_Final Annual Amount" * IncreaseFactor;
            Rec."BLRSL_Final Annual Amount" := Rec."BLRSL_Annual Amount";

            // Recalculate Per Day Rent
            RecalculatePerDayRent();
        end else
            Error('No record found for the previous year to base the calculation.');
    end;


    local procedure RecalculateTotals()
    var

        LeaseProposalRec: Record "BLRContractRenewal";
        RecordTemp: Record "BLRCRSingleLumAnnualAmntSP";
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
        RecordTemp.SetRange("BLRID", Rec."BLRID");
        if RecordTemp.FindSet() then
            repeat
                TotalAnnual += RecordTemp."BLRSL_Annual Amount";
                TotalFinal += RecordTemp."BLRSL_Final Annual Amount";
                lTotalRoundOff += RecordTemp."BLRSL_Round off";

                // Check for the first year and assign its Annual Amount
                if RecordTemp."BLRSL_Year" = 1 then
                    FirstYearAnnualAmount := RecordTemp."BLRSL_Final Annual Amount";
            until RecordTemp.Next() = 0;

        // Update the totals in the current record
        Rec."BLRTotalAnnualAmount" := TotalAnnual;
        Rec."BLRTotalFinalAmount" := TotalFinal;
        Rec."BLRTotalRoundOff" := lTotalRoundOff;
        Rec."BLRTotalFirstAnnualAmount" := FirstYearAnnualAmount; // Assign the first year's annual amount

        // Update Lease Proposal Details with calculated totals
        LeaseProposalRec.SetRange("BLRID", Rec."BLRID");
        if LeaseProposalRec.FindSet() then begin
            LeaseProposalRec."BLRRent Amount" := FirstYearAnnualAmount; // Update Rent Amount with the first year's Final Annual Amount
            LeaseProposalRec."BLRAnnual Rent Amount" := TotalFinal; // Update Annual Rent Amount with the Total Final Amount

            if LeaseProposalRec."BLRRent Amount VAT %" = LeaseProposalRec."BLRRent Amount VAT %"::"5%" then
                vatPer := 5
            else
                vatPer := 0;

            LeaseProposalRec."BLRRent VAT Amount" := LeaseProposalRec."BLRAnnual Rent Amount" * (vatPer / 100);
            LeaseProposalRec."BLRRent Amount Including VAT" := LeaseProposalRec."BLRAnnual Rent Amount" + LeaseProposalRec."BLRRent VAT Amount";

            LeaseProposalRec.Modify(); // Save the changes to the Lease Proposal record
        end;

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
        if (Rec."BLRSL_Start Date" = 0D) or (Rec."BLRSL_End Date" = 0D) then begin
            Rec."BLRSL_Final Annual Amount" := Rec."BLRSL_Annual Amount" + Rec."BLRSL_Round off";
            Rec.Modify();
            CurrPage.Update();
            exit;
        end;

        if Rec."BLRSL_End Date" < Rec."BLRSL_Start Date" then
            Error('End Date cannot be earlier than Start Date.');

        YearStart := Date2DMY(Rec."BLRSL_Start Date", 3);
        YearEnd := Date2DMY(Rec."BLRSL_End Date", 3);

        // Loop through each calendar year overlapping the period
        for CurrYear := YearStart to YearEnd do begin
            YearStartDate := DMY2Date(1, 1, CurrYear);
            YearEndDate := DMY2Date(31, 12, CurrYear);

            OverlapStart := Rec."BLRSL_Start Date";
            if OverlapStart < YearStartDate then
                OverlapStart := YearStartDate;

            OverlapEnd := Rec."BLRSL_End Date";
            if OverlapEnd > YearEndDate then
                OverlapEnd := YearEndDate;

            if OverlapEnd >= OverlapStart then begin
                DaysInPeriod := OverlapEnd - OverlapStart + 1;
                if IsLeapYear(CurrYear) then begin
                    LeapDay := DMY2Date(29, 2, CurrYear);
                    if (OverlapStart <= LeapDay) and (OverlapEnd >= LeapDay) then
                        DaysInYear := 366
                    else
                        DaysInYear := 365;
                end else
                    DaysInYear := 365;

                ProratedAmount += (Rec."BLRSL_Annual Amount" * DaysInPeriod) / DaysInYear;
            end;
        end;

        // Apply round off on top of the prorated sum
        Rec."BLRSL_Final Annual Amount" := ProratedAmount + Rec."BLRSL_Round off";

        Rec.Modify();
        CurrPage.Update();
    end;

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
