page 73209730 "BLRRevenue Structure Card"
{
    PageType = Card;
    SourceTable = "BLRRevenueStructure";
    ApplicationArea = All;
    Caption = 'Revenue Structure Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                    ToolTip = 'The Contract ID is auto-generated and not editable.';
                }

                field("RS ID"; Rec."BLRRS ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The RS ID is auto-generated and not editable.';
                }

                field("Secondary Item Type"; Rec."BLRSecondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                    ToolTip = 'Enter the Secondary Item Type.';
                }
                field("Amount"; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Enter the Amount.';
                }
                field("Contract Start Date"; Rec."BLRContract Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                    ToolTip = 'Enter the Contract Start Date.';
                }
                field("Contract End Date"; Rec."BLRContract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
                    ToolTip = 'Enter the Contract End Date.';
                }
                field("Number of Installments"; Rec."BLRNumber of Installments")
                {
                    ApplicationArea = All;
                    Caption = 'Number of Instalments';
                    ToolTip = 'Enter the Number of Instalments.';
                    Editable = false;
                }
                field("VAT Amount"; Rec."BLRVAT Amount")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Amount';
                    ToolTip = 'Enter the VAT Amount.';
                }

                field("Amount Including VAT"; Rec."BLRAmount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Including VAT';
                    ToolTip = 'Enter the Amount Including VAT.';
                }

                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'The Tenant ID is auto-generated and not editable.';
                }
                field("VAT %"; Rec."BLRVAT %")
                {
                    ApplicationArea = All;
                    Caption = 'VAT %';
                    ToolTip = 'Enter the VAT %.';
                    Editable = false;
                }
            }


            group("BLRPaymentSchedule")
            {
                part("BLRRevenueStructure"; "BLRPaymentSchedule")
                {
                    SubPageLink = "BLRRS ID" = FIELD("BLRRS ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                }
            }
            group("Revenue Payment Schedule")
            {
                part("Revenue Structure2";
                "BLRRevenue Payment Schedule")
                {
                    SubPageLink = "BLRRS ID" = FIELD("BLRRS ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                }
            }

            group("Revenue Recognition Other Charges")
            {
                part("BLRRevenueRecognition"; "BLRRevenueRecognitionOthChg")
                {
                    SubPageLink = "BLRRS ID" = FIELD("BLRRS ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CreditNote)
            {
                ApplicationArea = All;
                Caption = 'Revenue Recognition';
                Image = PostDocument;
                ToolTip = 'Calculate Monthly Revenue for Other Charges';

                trigger OnAction()
                var
                begin
                    CalculateMonthlyRevenue();
                    Message('Revenue Other charges is Calculated');
                end;
            }
        }
    }

    local procedure CalculateMonthlyRevenue()
    var
        SubpageRec: Record "BLRRevenueRecognitionOthChg";
        TempSubpageRecs: array[1000] of Record "BLRRevenueRecognitionOthChg" temporary;
        revenueStructureSubPage: Record "BLRRevenueStructureSubpage";
        TotalDays: Integer;
        CurrentDate: Date;
        MonthDays: Integer;
        DailyRate: Decimal;
        MonthlyRate: Decimal;
        AllocatedAmount: Decimal;
        FirstDayNextMonth: Date;
        LastDayOfMonth: Date;
        TotalMonths: Integer;
        ActualDaysInMonth: Integer;
        LastEntryNo: Integer;
        Method2Total: Decimal;
        RecCount: Integer;
        RemainingAmount: Decimal;
    begin
        // Clear existing records in the subpage table
        SubpageRec.SetRange("BLRRS Id", Rec."BLRRS ID");
        if SubpageRec.FindSet() then
            SubpageRec.DeleteAll();

        // Ensure Start and End Dates are valid
        if (Rec."BLRContract Start Date" = 0D) or (Rec."BLRContract End Date" = 0D) then
            exit;

        RecCount := 0;

        revenueStructureSubPage.SetRange("BLRContract ID", Rec."BLRContract ID");
        revenueStructureSubPage.SetRange("BLRRS ID", Rec."BLRRS ID");
        if revenueStructureSubPage.FindSet() then
            repeat
                Method2Total := 0;
                TotalMonths := CalculateTotalMonths(revenueStructureSubPage."BLRPeriod Start Date", revenueStructureSubPage."BLRPeriod End Date");

                TotalDays := revenueStructureSubPage."BLRNumber of Days";
                DailyRate := revenueStructureSubPage."BLRFinal Annual Amount" / TotalDays;

                CurrentDate := revenueStructureSubPage."BLRPeriod Start Date";
                MonthlyRate := Round(revenueStructureSubPage."BLRFinal Annual Amount" / TotalMonths);

                // First pass - calculate all monthly values
                while CurrentDate <= revenueStructureSubPage."BLRPeriod End Date" do begin
                    RecCount += 1;

                    // Initialize temporary record to store calculations
                    TempSubpageRecs[RecCount].Init();
                    TempSubpageRecs[RecCount]."BLRRS Id" := Rec."BLRRS ID";
                    TempSubpageRecs[RecCount]."BLRContract ID" := Rec."BLRContract ID";
                    TempSubpageRecs[RecCount]."BLRTenant Id" := Rec."BLRTenant Id";

                    // Format Month-Year
                    TempSubpageRecs[RecCount]."BLRMonth" := FORMAT(CurrentDate, 0, '<Month Text>') + '-' + FORMAT(CurrentDate, 0, '<Year>');

                    // Calculate the first day of the next month
                    if DATE2DMY(CurrentDate, 2) = 12 then
                        FirstDayNextMonth := DMY2DATE(1, 1, DATE2DMY(CurrentDate, 3) + 1)// January of next year
                    else
                        FirstDayNextMonth := DMY2DATE(1, DATE2DMY(CurrentDate, 2) + 1, DATE2DMY(CurrentDate, 3)); // Next month of the same year


                    LastDayOfMonth := FirstDayNextMonth - 1;


                    if revenueStructureSubPage."BLRPeriod End Date" < LastDayOfMonth then
                        MonthDays := revenueStructureSubPage."BLRPeriod End Date" - CurrentDate + 1
                    else
                        MonthDays := LastDayOfMonth - CurrentDate + 1;


                    if CurrentDate = revenueStructureSubPage."BLRPeriod Start Date" then
                        if MonthDays > (revenueStructureSubPage."BLRPeriod End Date" - CurrentDate + 1) then
                            MonthDays := (revenueStructureSubPage."BLRPeriod End Date" - CurrentDate + 1);

                    ActualDaysInMonth := GetDaysInMonthss(CurrentDate);

                    AllocatedAmount := MonthDays * DailyRate;
                    TempSubpageRecs[RecCount]."BLRRR - Method 1 (Day)" := AllocatedAmount;


                    TempSubpageRecs[RecCount]."BLRRR - Method 2 (Month)" := MonthlyRate * (MonthDays / ActualDaysInMonth);
                    Method2Total += TempSubpageRecs[RecCount]."BLRRR - Method 2 (Month)";
                    TempSubpageRecs[RecCount]."BLRNo. of Days" := MonthDays;

                    CurrentDate := FirstDayNextMonth;
                end;

                // Adjust the last month's amount for Method 2 to ensure total matches contract amount
                RemainingAmount := revenueStructureSubPage."BLRFinal Annual Amount" - (Method2Total - TempSubpageRecs[RecCount]."BLRRR - Method 2 (Month)");
                TempSubpageRecs[RecCount]."BLRRR - Method 2 (Month)" := RemainingAmount;
            until revenueStructureSubPage.Next() = 0;

        // Insert all records into the actual table
        for LastEntryNo := 1 to RecCount do begin
            SubpageRec.Init();
            SubpageRec."BLRRS Id" := TempSubpageRecs[RecCount]."BLRRS Id";
            SubpageRec."BLRContract ID" := TempSubpageRecs[LastEntryNo]."BLRContract ID";
            SubpageRec."BLRTenant Id" := TempSubpageRecs[LastEntryNo]."BLRTenant Id";
            SubpageRec."BLRMonth" := TempSubpageRecs[LastEntryNo]."BLRMonth";
            SubpageRec."BLRNo. of Days" := TempSubpageRecs[LastEntryNo]."BLRNo. of Days";
            SubpageRec."BLRRR - Method 1 (Day)" := TempSubpageRecs[LastEntryNo]."BLRRR - Method 1 (Day)";
            SubpageRec."BLRRR - Method 2 (Month)" := TempSubpageRecs[LastEntryNo]."BLRRR - Method 2 (Month)";
            SubpageRec.Insert();
            Clear(SubpageRec);
        end;
    end;
    //-----------------Calculate Monthly Revenue-----------------//

    //-----------------Calculate Leap year-----------------//
    local procedure IsLeapYear(Year: Integer): Boolean
    begin
        if (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0)) then
            exit(true);
        exit(false);
    end;

    //-----------------Calculate Total Months-----------------//
    local procedure CalculateTotalMonths(StartDate: Date; EndDate: Date) Result: Integer
    var
        StartYear, StartMonth : Integer;
        EndYear, EndMonth, EndDay : Integer;
        DaysInEndMonth: Integer;
        FirstDayOfNextMonth: Date;
    begin
        // Extract the year, month, and day from the start and end dates
        StartYear := DATE2DMY(StartDate, 3); // Year
        StartMonth := DATE2DMY(StartDate, 2); // Month

        EndYear := DATE2DMY(EndDate, 3); // Year
        EndMonth := DATE2DMY(EndDate, 2); // Month
        EndDay := DATE2DMY(EndDate, 1); // Day

        // Calculate the difference in months
        Result := ((EndYear - StartYear) * 12) + (EndMonth - StartMonth);

        // Calculate the number of days in the end month
        if EndMonth = 12 then
            FirstDayOfNextMonth := DMY2DATE(1, 1, EndYear + 1) // January of the next year
        else
            FirstDayOfNextMonth := DMY2DATE(1, EndMonth + 1, EndYear); // First day of the next month

        DaysInEndMonth := FirstDayOfNextMonth - DMY2DATE(1, EndMonth, EndYear);

        // Check if EndDate includes the full final month
        if EndDay = DaysInEndMonth then
            Result := Result + 1;
    end;
    //-----------------Calculate Total Months-----------------//

    //-----------------Calculate Total Days in Months's-----------------//
    local procedure GetDaysInMonthss(CurrentDate: Date): Integer
    var
        Year: Integer;
        Month: Integer;
        IsLeap: Boolean;
    begin
        Year := DATE2DMY(CurrentDate, 3); // Extract Year from CurrentDate
        Month := DATE2DMY(CurrentDate, 2); // Extract Month from CurrentDate
        IsLeap := IsLeapYear(Year);

        case Month of
            1, 3, 5, 7, 8, 10, 12: // 31-day months
                exit(31);
            4, 6, 9, 11: // 30-day months
                exit(30);
            2: // February
                if IsLeap then
                    exit(29) // Leap year February has 29 days
                else
                    exit(28); // Non-leap year February has 28 days
        end;
    end;
    //-----------------Calculate Total Days in Months's-----------------//

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        ClearSubgridData();
    end;

    procedure ClearSubgridData()
    var
        REVENUESTRUCTURE: Record "BLRRevenueStructureSubpage1";
    begin
        REVENUESTRUCTURE.Reset();
        REVENUESTRUCTURE.SetRange("BLRRS ID", Rec."BLRRS ID");
        REVENUESTRUCTURE.DeleteAll();
    end;

}