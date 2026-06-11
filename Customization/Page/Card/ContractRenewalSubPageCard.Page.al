page 73209681 "BLRContract RenewalSubPageCard"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "BLRContractRenewalSubpage";
    Caption = 'Other Payments';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Secondary Item Type"; Rec."BLRSecondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                    ToolTip = 'Enter the Secondary Item Type.';
                    ShowMandatory = true;
                    NotBlank = true;
                }
                field("Amount"; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ShowMandatory = true;
                    NotBlank = true;
                    ToolTip = 'Enter the Amount.';

                    trigger OnValidate()
                    begin
                        UpdateLeaseProposalAmount();
                    end;
                }

                field("VAT %"; Rec."BLRVAT %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the VAT percentage.';
                    trigger OnValidate()
                    begin
                        CurrPage.Update(); // Refresh the page to apply changes immediately
                    end;
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

                field("Start Date"; Rec."BLRStart Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    Lookup = true;
                    ToolTip = 'Enter the Start Date.';
                }

                field("End Date"; Rec."BLREnd Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    Lookup = true;
                    ToolTip = 'Enter the End Date.';
                }
                field("Generate Payment Schedule"; Rec."BLRGenerate Payment Schedule")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    Visible = false;
                    ToolTip = 'Click to generate the payment schedule for installment payments.';
                    trigger OnDrillDown()
                    var
                        RevenueStructure: Record "BLRRevenueStructureSubpage";
                        TargetRecord: Record "BLRRevenueStructure";
                        StartDate: Date;
                        EndDate: Date;
                        AnnualAmount: Decimal;
                        PeriodStartDate: Date;
                        PeriodEndDate: Date;
                        YearCounter: Integer;
                        NumDays: Integer;
                        IsLeapYearInRange: Boolean;
                        CurrentYear: Integer;
                        StartYear: Integer;
                        EndYear: Integer;
                        LeapDate: Date;
                        Revenuestructureid: Integer;

                    begin

                        if Rec."BLRPayment Type" = Rec."BLRPayment Type"::Installment then begin

                            TargetRecord.SetRange("BLRSecondary Item Type", Rec."BLRSecondary Item Type");
                            TargetRecord.SetRange("BLRTenant ID", Rec."BLRTenantID");

                            if TargetRecord.FindSet() then begin
                                TargetRecord."BLRContract Start Date" := Rec."BLRStart Date";
                                TargetRecord."BLRContract End Date" := Rec."BLREnd Date";
                                TargetRecord."BLRAmount" := Rec."BLRAmount";
                                TargetRecord."BLRVAT Amount" := Rec."BLRVAT Amount";
                                TargetRecord."BLRAmount Including VAT" := Rec."BLRAmount Including VAT";
                                TargetRecord."BLRVAT %" := Rec."BLRVAT %";
                                TargetRecord.Modify();
                            end else begin
                                TargetRecord.Init();
                                TargetRecord."BLRTenant ID" := Rec."BLRTenantID";
                                TargetRecord."BLRSecondary Item Type" := Rec."BLRSecondary Item Type";
                                TargetRecord."BLRContract Start Date" := Rec."BLRStart Date";
                                TargetRecord."BLRContract End Date" := Rec."BLREnd Date";
                                TargetRecord."BLRAmount" := Rec."BLRAmount";
                                TargetRecord."BLRVAT Amount" := Rec."BLRVAT Amount";
                                TargetRecord."BLRAmount Including VAT" := Rec."BLRAmount Including VAT";
                                TargetRecord."BLRVAT %" := Rec."BLRVAT %";
                                TargetRecord.Insert();

                                StartDate := TargetRecord."BLRContract Start Date";
                                EndDate := TargetRecord."BLRContract End Date";
                                AnnualAmount := TargetRecord."BLRAmount";

                                if (StartDate = 0D) or (EndDate = 0D) or (AnnualAmount = 0) then
                                    Error('Start Date, End Date, and Amount must be populated.');

                                YearCounter := 1;
                                PeriodStartDate := StartDate;

                                while PeriodStartDate <= EndDate do begin
                                    RevenueStructure.Init();
                                    RevenueStructure."BLRRS ID" := TargetRecord."BLRRS ID";
                                    RevenueStructure."BLRTenant Id" := TargetRecord."BLRTenant ID";
                                    RevenueStructure."BLRYear" := YearCounter;
                                    RevenueStructure."BLRPeriod Start Date" := PeriodStartDate;
                                    RevenueStructure."BLRVAT Amount" := TargetRecord."BLRVAT Amount";
                                    RevenueStructure."BLRAmount Including VAT" := TargetRecord."BLRAmount Including VAT";
                                    RevenueStructure."BLRSecondary Item Type" := TargetRecord."BLRSecondary Item Type";
                                    RevenueStructure."BLRVAT %" := TargetRecord."BLRVAT %";

                                    if PeriodStartDate + 365 > EndDate then
                                        PeriodEndDate := EndDate
                                    else
                                        PeriodEndDate := PeriodStartDate + 365 - 1;

                                    RevenueStructure."BLRPeriod End Date" := PeriodEndDate;

                                    NumDays := PeriodEndDate - PeriodStartDate + 1;

                                    // Check if February 29 falls within the range
                                    StartYear := Date2DMY(PeriodStartDate, 3); // Extract the year of PeriodStartDate
                                    EndYear := Date2DMY(PeriodEndDate, 3);    // Extract the year of PeriodEndDate

                                    IsLeapYearInRange := false;

                                    for CurrentYear := StartYear to EndYear do
                                        if IsLeapYear(CurrentYear) then begin
                                            LeapDate := DMY2Date(29, 2, CurrentYear); // Generate February 29 date
                                            if (LeapDate >= PeriodStartDate) and (LeapDate <= PeriodEndDate) then begin
                                                IsLeapYearInRange := true;
                                                break; // No need to check further if a leap year is found in range
                                            end;
                                        end;

                                    // Adjust the number of days if a leap year is in range
                                    if IsLeapYearInRange then
                                        NumDays := NumDays + 1;


                                    RevenueStructure."BLRNumber of Days" := NumDays;

                                    RevenueStructure.Insert();
                                    RevenueStructure.Modify();
                                    Clear(RevenueStructure);

                                    PeriodStartDate := PeriodEndDate + 1;
                                    YearCounter += 1;

                                    if TargetRecord.FindLast() then
                                        Revenuestructureid := TargetRecord."BLRRS ID"
                                    else begin
                                        // If no record is found, create a new Revenue Structure record
                                        TargetRecord.Init();
                                        TargetRecord.Insert(true);
                                        TargetRecord.Modify(true);  // Insert the new record and generate the RS ID

                                        // Get the newly created RS ID
                                        Revenuestructureid := TargetRecord."BLRRS ID";
                                    end;

                                    Rec."BLRLink" := Revenuestructureid;

                                end;


                            end;

                            Message('Record are updated in Revenue Structure.Click on the respective link to View the details');


                        end
                        else
                            Message('Installment cannot be set for One-Time payment');

                    end;
                }

                field("Link"; Rec."BLRLink")
                {
                    ApplicationArea = All;
                    Caption = 'Link';
                    DrillDown = true;
                    Visible = false;
                    ToolTip = 'Click to navigate to the Revenue Structure Card page.';

                    trigger OnDrillDown()
                    var
                        RevenueStructureRec: Record "BLRRevenueStructure";
                    begin
                        if Rec."BLRPayment Type" = Rec."BLRPayment Type"::Installment then begin

                            if RevenueStructureRec.Get(Rec."BLRLink") then
                                PAGE.RUN(PAGE::"BLRRevenue Structure Card", RevenueStructureRec)
                            else
                                Message('The related Revenue Structure does not exist.');
                        end
                        else
                            Message('Installment cannot be set for One-Time payment');
                    end;

                }
            }
        }
    }

    local procedure IsLeapYear(Year: Integer): Boolean
    begin
        if (Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0)) then
            exit(true);
        exit(false);
    end;

    procedure SetId(pId: Integer)
    begin
        Id := pId;
    end;

    procedure SetTenantID(pTenantID: Code[20])
    begin
        tenantID := pTenantID;
    end;

    procedure SetStartEndDate(pStartDate: Date; pEndDate: Date)
    begin
        startDate := pStartDate;
        endDate := pEndDate;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."BLRId" := Id;
        Rec."BLRTenantID" := tenantID;

        Rec."BLRStart Date" := startDate;
        Rec."BLREnd Date" := endDate;

    end;

    var
        Id: Integer;
        tenantID: Code[20];
        startDate: Date;
        endDate: Date;

    procedure UpdateLeaseProposalAmount()
    var
        LeaseProposal: Record "BLRContractRenewal";
    begin

        if (Rec."BLRSecondary Item Type" = 'Security Deposit') or
           (Rec."BLRSecondary Item Type" = 'Rera Fees') or
           (Rec."BLRSecondary Item Type" = 'Ejari Processing Fees') or
           (Rec."BLRSecondary Item Type" = 'Renewal Amount') then begin
            LeaseProposal.SetRange("BLRID", Rec."BLRID");

            if LeaseProposal.FindSet() then begin

                case Rec."BLRSecondary Item Type" of
                    'Security Deposit':
                        LeaseProposal."BLRSecurity Deposit Amount" := Rec."BLRAmount Including VAT";
                    'Rera Fees':
                        LeaseProposal."BLRRera" := Rec."BLRAmount Including VAT";
                    'Ejari Processing Fees':
                        LeaseProposal."BLREjari Processing Charges" := Rec."BLRAmount Including VAT";
                    'Renewal Amount':
                        LeaseProposal."BLRRenewal Charges" := Rec."BLRAmount Including VAT";
                end;

                LeaseProposal.Modify();
            end;
        end;
    end;
}