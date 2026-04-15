page 50909 "Revenue Item SubPage Card"
{
    PageType = ListPart;
    ApplicationArea = All;
    // UsageCategory = Administration;
    SourceTable = "Revenue Item Subpage";
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
                        if Rec."Secondary Item Type" = '' then
                            Error('Please select the Secondary Item Type before entering an Amount.');

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

                    trigger OnValidate()
                    begin
                        UpdateLeaseProposalAmount();
                    end;
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

                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Type';
                    ToolTip = 'Enter the Payment Type.';
                    Visible = false;
                }

                field(ProposalID; Rec.ProposalID)
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'Enter the Proposal ID.';
                }
                field("Property Name"; Rec."Property Name")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'Enter the Property Name.';
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'Enter the Unit Name.';
                }
                field("Unit Size"; Rec."Unit Size")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'Enter the Unit Size.';
                }
                field(Customer_Name; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'Enter the Customer Name.';
                }

                field("Generate Payment Schedule"; Rec."Generate Payment Schedule")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    Visible = false;
                    ToolTip = 'Generate Payment Schedule for the selected item.';

                    trigger OnDrillDown()
                    var
                        RevenueStructure: Record "Revenue Structure Subpage";

                        TargetRecord: Record "Revenue Structure"; // Replace with the actual table name
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
                    ToolTip = 'Navigate to the related Revenue Structure Card.';

                    trigger OnDrillDown()
                    var
                        RevenueStructureRec: Record "Revenue Structure";
                    begin
                        if Rec."Payment Type" = Rec."Payment Type"::Installment then begin
                            // Navigate to the Revenue Structure Card page
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

    procedure SetProposalID(pProposalID: Integer)
    begin
        proposalID := pProposalID;
    end;

    procedure SetTenantID(pTenantID: Code[20])
    begin
        tenantID := pTenantID;
    end;

    procedure SetStartEndDate(pStartDate: Date; pEndDate: Date; pUnitName: Code[100]; pPropertyName: Text[100]; pUnitSize: Decimal; pCustomerName: Text[100])
    begin
        startDate := pStartDate;
        endDate := pEndDate;
        unitname := pUnitName;
        propertyname := pPropertyName;
        unitsize := pUnitSize;
        customerName := pCustomerName;

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.ProposalID := proposalID;
        Rec.TenantID := tenantID;
        Rec."Start Date" := startDate;
        Rec."End Date" := endDate;
        Rec."Unit Name" := unitname;
        Rec."Property Name" := propertyname;
        Rec."Unit Size" := unitsize;
        Rec."Customer Name" := customerName;
    end;

    trigger OnAfterGetRecord()
    begin
        Rec."Unit Name" := unitname;
        Rec."Property Name" := propertyname;
        Rec."Unit Size" := unitsize;
        Rec."Customer Name" := customerName;
    end;

    var
        proposalID: Integer;
        tenantID: Code[20];
        startDate: Date;
        endDate: Date;
        unitname: Code[100];
        propertyname: Text[100];
        unitsize: Decimal;
        customerName: Text[100];

    procedure UpdateLeaseProposalAmount()
    var
        LeaseProposal: Record "Lease Proposal Details";
    // Replace with your actual Lease Proposal table name
    begin
        // Apply a filter on the ProposalID to find matching Lease Proposal records
        if rec."Secondary Item Type" = 'Security Deposit' then begin

            LeaseProposal.SetRange("Proposal ID", Rec.ProposalID); // Adjust the field names to your table schema

            if LeaseProposal.FindSet() then begin
                // Loop through all matching records if there are multiple
                LeaseProposal."Security Deposit Amount" := Rec.Amount;
                LeaseProposal.Modify(); // Save the changes
            end;
        end;
    end;
}