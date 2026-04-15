page 50941 "Contract Renewal SubPage Card"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Contract Renewal Subpage";
    Caption = 'Other Payments';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Secondary Item Type"; Rec."Secondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                    ToolTip = 'Enter the Secondary Item Type.';
                    ShowMandatory = true;
                    NotBlank = true;
                }
                field("Amount"; Rec.Amount)
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

                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the VAT percentage.';
                    trigger OnValidate()
                    begin
                        CurrPage.Update(); // Refresh the page to apply changes immediately
                    end;
                }

                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Amount';
                    ToolTip = 'Enter the VAT Amount.';
                }

                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Including VAT';
                    ToolTip = 'Enter the Amount Including VAT.';
                }

                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    Lookup = true;
                    ToolTip = 'Enter the Start Date.';
                }

                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    Lookup = true;
                    ToolTip = 'Enter the End Date.';
                }
                field("Generate Payment Schedule"; Rec."Generate Payment Schedule")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    Visible = false;
                    ToolTip = 'Click to generate the payment schedule for installment payments.';
                    trigger OnDrillDown()
                    var
                        RevenueStructure: Record "Revenue Structure Subpage";
                        TargetRecord: Record "Revenue Structure";
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

                        if Rec."Payment Type" = Rec."Payment Type"::Installment then begin

                            TargetRecord.SetRange("Secondary Item Type", Rec."Secondary Item Type");
                            TargetRecord.SetRange("Tenant ID", Rec."TenantID");

                            if TargetRecord.FindSet() then begin
                                TargetRecord."Contract Start Date" := Rec."Start Date";
                                TargetRecord."Contract End Date" := Rec."End Date";
                                TargetRecord."Amount" := Rec."Amount";
                                TargetRecord."VAT Amount" := Rec."VAT Amount";
                                TargetRecord."Amount Including VAT" := Rec."Amount Including VAT";
                                TargetRecord."VAT %" := Rec."VAT %";
                                TargetRecord.Modify();
                            end else begin
                                TargetRecord.Init();
                                TargetRecord."Tenant ID" := Rec."TenantID";
                                TargetRecord."Secondary Item Type" := Rec."Secondary Item Type";
                                TargetRecord."Contract Start Date" := Rec."Start Date";
                                TargetRecord."Contract End Date" := Rec."End Date";
                                TargetRecord."Amount" := Rec."Amount";
                                TargetRecord."VAT Amount" := Rec."VAT Amount";
                                TargetRecord."Amount Including VAT" := Rec."Amount Including VAT";
                                TargetRecord."VAT %" := Rec."VAT %";
                                TargetRecord.Insert();

                                StartDate := TargetRecord."Contract Start Date";
                                EndDate := TargetRecord."Contract End Date";
                                AnnualAmount := TargetRecord."Amount";

                                if (StartDate = 0D) or (EndDate = 0D) or (AnnualAmount = 0) then
                                    Error('Start Date, End Date, and Amount must be populated.');

                                YearCounter := 1;
                                PeriodStartDate := StartDate;

                                while PeriodStartDate <= EndDate do begin
                                    RevenueStructure.Init();
                                    RevenueStructure."RS ID" := TargetRecord."RS ID";
                                    RevenueStructure."Tenant Id" := TargetRecord."Tenant ID";
                                    RevenueStructure."Year" := YearCounter;
                                    RevenueStructure."Period Start Date" := PeriodStartDate;
                                    RevenueStructure."VAT Amount" := TargetRecord."VAT Amount";
                                    RevenueStructure."Amount Including VAT" := TargetRecord."Amount Including VAT";
                                    RevenueStructure."Secondary Item Type" := TargetRecord."Secondary Item Type";
                                    RevenueStructure."VAT %" := TargetRecord."VAT %";

                                    if PeriodStartDate + 365 > EndDate then
                                        PeriodEndDate := EndDate
                                    else
                                        PeriodEndDate := PeriodStartDate + 365 - 1;

                                    RevenueStructure."Period End Date" := PeriodEndDate;

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


                                    RevenueStructure."Number of Days" := NumDays;

                                    RevenueStructure.Insert();
                                    RevenueStructure.Modify();
                                    Clear(RevenueStructure);

                                    PeriodStartDate := PeriodEndDate + 1;
                                    YearCounter += 1;

                                    if TargetRecord.FindLast() then
                                        Revenuestructureid := TargetRecord."RS ID"
                                    else begin
                                        // If no record is found, create a new Revenue Structure record
                                        TargetRecord.Init();
                                        TargetRecord.Insert(true);
                                        TargetRecord.Modify(true);  // Insert the new record and generate the RS ID

                                        // Get the newly created RS ID
                                        Revenuestructureid := TargetRecord."RS ID";
                                    end;

                                    Rec."Link" := Revenuestructureid;

                                end;


                            end;

                            Message('Record are updated in Revenue Structure.Click on the respective link to View the details');


                        end
                        else
                            Message('Installment cannot be set for One-Time payment');

                    end;
                }

                field("Link"; Rec."Link")
                {
                    ApplicationArea = All;
                    Caption = 'Link';
                    DrillDown = true;
                    Visible = false;
                    ToolTip = 'Click to navigate to the Revenue Structure Card page.';

                    trigger OnDrillDown()
                    var
                        RevenueStructureRec: Record "Revenue Structure";
                    begin
                        if Rec."Payment Type" = Rec."Payment Type"::Installment then begin

                            if RevenueStructureRec.Get(Rec."Link") then
                                PAGE.RUN(PAGE::"Revenue Structure Card", RevenueStructureRec)
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
        Rec.Id := Id;
        Rec.TenantID := tenantID;

        Rec."Start Date" := startDate;
        Rec."End Date" := endDate;

    end;

    var
        Id: Integer;
        tenantID: Code[20];
        startDate: Date;
        endDate: Date;

    procedure UpdateLeaseProposalAmount()
    var
        LeaseProposal: Record "Contract Renewal";
    begin

        if (Rec."Secondary Item Type" = 'Security Deposit') or
           (Rec."Secondary Item Type" = 'Rera Fees') or
           (Rec."Secondary Item Type" = 'Ejari Processing Fees') or
           (Rec."Secondary Item Type" = 'Renewal Amount') then begin
            LeaseProposal.SetRange("ID", Rec."ID");

            if LeaseProposal.FindSet() then begin

                case Rec."Secondary Item Type" of
                    'Security Deposit':
                        LeaseProposal."Security Deposit Amount" := Rec."Amount Including VAT";
                    'Rera Fees':
                        LeaseProposal."Rera" := Rec."Amount Including VAT";
                    'Ejari Processing Fees':
                        LeaseProposal."Ejari Processing Charges" := Rec."Amount Including VAT";
                    'Renewal Amount':
                        LeaseProposal."Renewal Charges" := Rec."Amount Including VAT";
                end;

                LeaseProposal.Modify();
            end;
        end;
    end;
}