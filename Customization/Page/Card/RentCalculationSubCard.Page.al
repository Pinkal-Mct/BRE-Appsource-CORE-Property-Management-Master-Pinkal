page 73209721 "BLRRent Calculation SubCard"
{
    PageType = ListPart;
    ApplicationArea = All;
    DeleteAllowed = true;
    SourceTable = "BLRRentCalculationSubpage";
    Caption = 'Rent Calculation';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Year"; Rec."BLRYear")
                {
                    ApplicationArea = All;
                    Caption = 'Year';
                    ToolTip = 'Enter the Year.';
                    Editable = false;
                }
                field("Period Start Date"; Rec."BLRPeriod Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    Editable = false;
                    ToolTip = 'Enter the Period Start Date.';
                }

                field("Period End Date"; Rec."BLRPeriod End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    Editable = false;
                    ToolTip = 'Enter the Period End Date.';
                }

                field("Number of Days"; Rec."BLRNumber of Days")
                {
                    ApplicationArea = All;
                    Caption = 'Number of Days';
                    Editable = false;
                    ToolTip = 'Enter the Number of Days in the period.';
                }

                field("Final Annual Amount"; Rec."BLRFinal Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Final Annual Amount';
                    Editable = false;
                    ToolTip = 'Enter the Final Annual Amount for the rent calculation.';
                }

                field("Yearly No. of Installment"; Rec."BLRYearly No. of Installment")
                {
                    ApplicationArea = All;
                    Caption = 'Yearly No. of Instalment';
                    Editable = false;
                    ToolTip = 'Enter the Yearly No. of Installment for the rent calculation.';
                }

                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'The unique identifier for the tenant associated with this rent calculation.';
                }

                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'The unique identifier for the contract associated with this rent calculation.';
                }


                field("VAT %"; Rec."BLRVAT %")
                {
                    ApplicationArea = All;
                    Caption = 'VAT %';
                    ToolTip = 'Enter the VAT %.';
                    Editable = false;
                    Visible = false;
                }

                field("Per Day Rent"; Rec."BLRPer Day Rent")
                {
                    ApplicationArea = All;
                    Caption = 'Per Day Rent';
                    ToolTip = 'Enter the Per Day Rent.';
                    Editable = false;
                }
                field("Propety Classification"; Rec."BLRPropety Classification")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Property Classification';
                    Visible = false;
                    ToolTip = 'The classification of the property associated with this rent calculation.';
                }
            }

            group(" ")
            {
                field("Total Amount"; Rec."BLRTotal Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Total Amount';
                    ToolTip = 'Enter the Total Amount.';
                    Editable = false;
                }
                field("VAT Amount"; Rec."BLRVAT Amount")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Amount';
                    ToolTip = 'Enter the VAT Amount.';
                    Visible = false;
                    Editable = false;
                }

                field("Amount Including VAT"; Rec."BLRAmount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Including VAT';
                    ToolTip = 'Enter the Amount Including VAT.';
                    Visible = false;
                    Editable = false;
                }

                field("Secondary Item Type"; Rec."BLRSecondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                    ToolTip = 'Enter the Secondary Item Type.';
                    Visible = false;
                    Editable = false;
                }

                field("Link"; Rec."BLRLink")
                {
                    ApplicationArea = All;
                    Caption = 'Link';
                    ToolTip = 'Enter the Link.';
                    Editable = false;
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        tenancyContract: Record "BLRTenancyContract";
                        TargetRecord: Record "BLRRentCalculation";
                        RevenueStructure: Record "BLRRentCalculationSubpage";
                        InstallmentStructure: Record "BLRRentCalculationSubpage2";
                        fetchMonth: Codeunit "BLRFetch Month";
                        TargetPageID: Integer;
                        isMonthEnd: Boolean;
                        OffsetMonths: Integer;
                        InstallmentAmount: Decimal;
                        InstallmentStartDate: Date;
                        InstallmentEndDate: Date;
                        InstallmentNumber: Integer;
                        TotalYears: Integer;
                        Installment: Integer;
                        VATPer: Integer;
                        TotalCalculatedAmount: Decimal;
                        LastInstallmentAmount: Decimal;
                        InstallmentAmount2: Decimal;
                        NumInstallments: Integer;
                        OriginalStartDate: Date;
                        YearNo: Integer;
                        UnitId: Code[20];
                        isMonthStart: Boolean;
                    begin
                        YearNo := 0;
                        UnitId := '';
                        tenancyContract.Get(Rec."BLRContract ID");
                        InstallmentStructure.SetRange("BLRRC ID", Rec."BLRRC ID");
                        if InstallmentStructure.FindSet() then
                            InstallmentStructure.DeleteAll();

                        InstallmentStartDate := GetStartDate(tenancyContract."BLRContract Start Date", tenancyContract."BLRContract End Date", isMonthEnd, isMonthStart);

                        OriginalStartDate := InstallmentStartDate;

                        OffsetMonths := fetchMonth.GetNoofMonthsFromFrequency(Format(tenancyContract."BLRPayment Frequency"));
                        InstallmentEndDate := 0D;
                        RevenueStructure.SetRange("BLRTenant ID", Rec."BLRTenant ID");
                        RevenueStructure.SetRange("BLRContract ID", Rec."BLRContract ID");
                        RevenueStructure.SetRange("BLRRC ID", Rec."BLRRC ID");
                        TargetRecord.SetRange("BLRContract ID", Rec."BLRContract ID");
                        TargetRecord.SetRange("BLRTenant ID", Rec."BLRTenant ID");
                        TargetRecord.SetRange("BLRRC ID", Rec."BLRRC ID");

                        if RevenueStructure.FindSet() then begin
                            repeat

                                if RevenueStructure."BLRYear" < YearNo then begin
                                    InstallmentStartDate := OriginalStartDate;
                                    InstallmentEndDate := 0D;
                                end;
                                if RevenueStructure."BLRUnit ID" <> UnitId then begin
                                    InstallmentStartDate := OriginalStartDate;
                                    InstallmentEndDate := 0D;
                                end;
                                VATPer := RevenueStructure."BLRVAT %";
                                TotalYears := RevenueStructure."BLRYear";
                                TargetPageID := RevenueStructure."BLRRC ID";
                                if TargetRecord.FindSet() then
                                    Installment := TargetRecord."BLRNumber of Installments";

                                InstallmentAmount := ROUND(RevenueStructure."BLRFinal Annual Amount" / RevenueStructure."BLRYearly No. of Installment", 0.01);
                                TotalCalculatedAmount := InstallmentAmount * RevenueStructure."BLRYearly No. of Installment";  // 1666.67*3 = 5000.01
                                LastInstallmentAmount := TotalCalculatedAmount - RevenueStructure."BLRFinal Annual Amount"; // 5000.01 - 5000 = 0.01
                                InstallmentAmount2 := InstallmentAmount - LastInstallmentAmount;   // 1666.67 - 0.01 = 1666.66

                                for InstallmentNumber := 1 to RevenueStructure."BLRYearly No. of Installment" do begin

                                    if InstallmentEndDate > tenancyContract."BLRContract Start Date" then begin
                                        InstallmentStartDate := CalcDate('<' + Format(OffsetMonths) + 'M>', InstallmentStartDate);
                                        if isMonthEnd then begin
                                            InstallmentStartDate := CalcDate('<CM>', InstallmentStartDate);
                                            InstallmentEndDate := CalcDate('<-1D>', CalcDate('<CM>', CalcDate('<' + Format(OffsetMonths) + 'M>', InstallmentStartDate)));
                                        end
                                        else
                                            InstallmentEndDate := CalcDate('<-1D>', CalcDate('<' + Format(OffsetMonths) + 'M>', InstallmentStartDate));
                                    end
                                    else
                                        InstallmentEndDate := CalcDate('<-1D>', CalcDate('<' + Format(OffsetMonths) + 'M>', InstallmentStartDate));

                                    if InstallmentEndDate > tenancyContract."BLRContract End Date" then
                                        InstallmentEndDate := tenancyContract."BLRContract End Date";

                                    InstallmentStructure.SetRange("BLRRC ID", TargetPageID);
                                    InstallmentStructure.SetRange("BLRYear", TotalYears);
                                    InstallmentStructure.SetRange("BLRInstallment No.", InstallmentNumber);
                                    InstallmentStructure.SetRange("BLRRevStrSubpageEntryNo", RevenueStructure."BLREntry No.");

                                    if InstallmentStructure.FindFirst() then begin

                                        if InstallmentNumber = 1 then
                                            InstallmentStructure."BLRAmount" := InstallmentAmount2
                                        else
                                            InstallmentStructure."BLRAmount" := InstallmentAmount;

                                        InstallmentStructure."BLRInstallment Start Date" := InstallmentStartDate;
                                        InstallmentStructure."BLRInstallment End Date" := InstallmentEndDate;
                                        InstallmentStructure.Modify();
                                    end else begin
                                        InstallmentStructure.Init();
                                        InstallmentStructure."BLRRC ID" := TargetPageID;
                                        InstallmentStructure."BLRRevStrSubpageEntryNo" := RevenueStructure."BLREntry No.";
                                        InstallmentStructure."BLRTenant ID" := RevenueStructure."BLRTenant ID";
                                        InstallmentStructure."BLRContract ID" := RevenueStructure."BLRContract ID";
                                        InstallmentStructure."BLRPrimary Classification" := RevenueStructure."BLRPropety Classification";
                                        InstallmentStructure."BLRVAT %" := VATPer;
                                        InstallmentStructure."BLRSecondary Item Type" := RevenueStructure."BLRSecondary Item Type";
                                        InstallmentStructure."BLRYear" := TotalYears;
                                        InstallmentStructure."BLRInstallment No." := InstallmentNumber;

                                        if InstallmentNumber = RevenueStructure."BLRYearly No. of Installment" then
                                            InstallmentStructure."BLRAmount" := InstallmentAmount2
                                        else
                                            InstallmentStructure."BLRAmount" := InstallmentAmount;

                                        if InstallmentStructure."BLRVAT %" = 1 then
                                            InstallmentStructure."BLRVAT %" := 5
                                        else
                                            InstallmentStructure."BLRVAT %" := 0;

                                        InstallmentStructure."BLRVAT Amount" := InstallmentStructure."BLRAmount" * (InstallmentStructure."BLRVAT %" / 100);
                                        InstallmentStructure."BLRAmount Including VAT" := InstallmentStructure."BLRAmount" + InstallmentStructure."BLRVAT Amount";

                                        InstallmentStructure."BLRInstallment Start Date" := InstallmentStartDate;
                                        InstallmentStructure."BLRInstallment End Date" := InstallmentEndDate;

                                        if InstallmentNumber = RevenueStructure."BLRYearly No. of Installment" then
                                            InstallmentStructure."BLRInstallment End Date" := RevenueStructure."BLRPeriod End Date";

                                        InstallmentStructure."BLRDue Date" := InstallmentStructure."BLRInstallment Start Date";
                                        InstallmentStructure.Insert();

                                    end;

                                    TargetRecord.SetRange("BLRContract ID", Rec."BLRContract ID");
                                    TargetRecord.SetRange("BLRRC ID", RevenueStructure."BLRRC ID");
                                    TargetRecord.SetRange("BLRSecondary Item Type", RevenueStructure."BLRSecondary Item Type");

                                    if TargetRecord.FindSet() then
                                        repeat
                                            Installment := TargetRecord."BLRNumber of Installments";
                                            TargetRecord."BLRNumber of Installments" := Installment;
                                            TargetRecord.Modify();
                                        until TargetRecord.Next() = 0
                                    else begin
                                        TargetRecord.Init();
                                        TargetRecord."BLRContract ID" := RevenueStructure."BLRContract ID";
                                        TargetRecord."BLRRC ID" := RevenueStructure."BLRRC ID";
                                        TargetRecord."BLRSecondary Item Type" := RevenueStructure."BLRSecondary Item Type";
                                        TargetRecord."BLRNumber of Installments" := Installment;
                                        TargetRecord.Insert();
                                        Clear(TargetRecord);
                                    end;

                                    Clear(InstallmentStructure);
                                end;
                                UnitId := RevenueStructure."BLRUnit ID";
                                YearNo := RevenueStructure."BLRYear";
                            until RevenueStructure.Next() = 0;
                            Message('Data Create Successfully!');
                        end else
                            Error('No records found in the Revenue Structure.');
                    end;
                }
            }
        }
    }

    procedure SetContractID(pContractID: Integer)
    begin
        ContractID := pContractID;
    end;

    procedure SetProposalID(pProposalID: Integer)
    begin

    end;

    procedure SetTenantID(pTenantID: Code[20])
    begin
        tenantID := pTenantID;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."BLRContract ID" := ContractID;
        Rec."BLRTenant ID" := tenantID;
    end;

    var
        ContractID: Integer;
        tenantID: Code[20];

    procedure GetStartDate(pContractStartDate: Date; pContractEndDate: Date; var isMonthEnd: Boolean; var isMonthStart: Boolean): Date
    var
        StartDate: Date;
    begin
        isMonthEnd := false;
        isMonthStart := false;
        if pContractStartDate = CalcDate('<-CM>', pContractStartDate) then begin
            StartDate := CalcDate('<-CM>', pContractStartDate);
            isMonthStart := true;
        end
        else
            if pContractStartDate = CalcDate('<CM>', pContractStartDate) then begin
                StartDate := CalcDate('<CM>', pContractStartDate);
                isMonthEnd := true;
            end
            else
                StartDate := pContractStartDate;

        exit(StartDate);
    end;
}