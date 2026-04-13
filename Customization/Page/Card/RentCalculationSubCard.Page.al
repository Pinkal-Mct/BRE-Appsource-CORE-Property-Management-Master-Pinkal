page 50946 "Rent Calculation SubCard"
{
    PageType = ListPart;
    ApplicationArea = All;
    DeleteAllowed = true;
    SourceTable = "Rent Calculation Subpage";
    Caption = 'Rent Calculation';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Year"; Rec."Year")
                {
                    ApplicationArea = All;
                    Caption = 'Year';
                    ToolTip = 'Enter the Year.';
                    Editable = false;
                }
                field("Period Start Date"; Rec."Period Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    Editable = false;
                    ToolTip = 'Enter the Period Start Date.';
                }

                field("Period End Date"; Rec."Period End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    Editable = false;
                    ToolTip = 'Enter the Period End Date.';
                }

                field("Number of Days"; Rec."Number of Days")
                {
                    ApplicationArea = All;
                    Caption = 'Number of Days';
                    Editable = false;
                    ToolTip = 'Enter the Number of Days in the period.';
                }

                field("Final Annual Amount"; Rec."Final Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Final Annual Amount';
                    Editable = false;
                    ToolTip = 'Enter the Final Annual Amount for the rent calculation.';
                }

                field("Yearly No. of Installment"; Rec."Yearly No. of Installment")
                {
                    ApplicationArea = All;
                    Caption = 'Yearly No. of Instalment';
                    Editable = false;
                    ToolTip = 'Enter the Yearly No. of Installment for the rent calculation.';
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'The unique identifier for the tenant associated with this rent calculation.';
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'The unique identifier for the contract associated with this rent calculation.';
                }


                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = All;
                    Caption = 'VAT %';
                    ToolTip = 'Enter the VAT %.';
                    Editable = false;
                    Visible = false;
                }

                field("Per Day Rent"; Rec."Per Day Rent")
                {
                    ApplicationArea = All;
                    Caption = 'Per Day Rent';
                    ToolTip = 'Enter the Per Day Rent.';
                    Editable = false;
                }
                field("Propety Classification"; Rec."Propety Classification")
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
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Total Amount';
                    ToolTip = 'Enter the Total Amount.';
                    Editable = false;
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Amount';
                    ToolTip = 'Enter the VAT Amount.';
                    Visible = false;
                    Editable = false;
                }

                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Including VAT';
                    ToolTip = 'Enter the Amount Including VAT.';
                    Visible = false;
                    Editable = false;
                }

                field("Secondary Item Type"; Rec."Secondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                    ToolTip = 'Enter the Secondary Item Type.';
                    Visible = false;
                    Editable = false;
                }

                field("Link"; Rec."Link")
                {
                    ApplicationArea = All;
                    Caption = 'Link';
                    ToolTip = 'Enter the Link.';
                    Editable = false;
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        tenancyContract: Record "Tenancy Contract";
                        TargetRecord: Record "Rent Calculation";
                        RevenueStructure: Record "Rent Calculation Subpage";
                        InstallmentStructure: Record "Rent Calculation Subpage2";
                        fetchMonth: Codeunit "Fetch Month";
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
                    begin
                        YearNo := 0;
                        UnitId := '';
                        tenancyContract.Get(Rec."Contract ID");
                        InstallmentStructure.SetRange("RC ID", Rec."RC ID");
                        if InstallmentStructure.FindSet() then
                            InstallmentStructure.DeleteAll();
                        InstallmentStartDate := GetStartDate(tenancyContract."Contract Start Date", tenancyContract."Contract End Date", isMonthEnd);
                        OriginalStartDate := InstallmentStartDate;

                        OffsetMonths := fetchMonth.GetNoofMonthsFromFrequency(Format(tenancyContract."Payment Frequency"));
                        InstallmentEndDate := 0D;
                        RevenueStructure.SetRange("Tenant ID", Rec."Tenant ID");
                        RevenueStructure.SetRange("Contract ID", Rec."Contract ID");
                        RevenueStructure.SetRange("RC ID", Rec."RC ID");
                        TargetRecord.SetRange("Contract ID", Rec."Contract ID");
                        TargetRecord.SetRange("Tenant ID", Rec."Tenant ID");
                        TargetRecord.SetRange("RC ID", Rec."RC ID");

                        if RevenueStructure.FindSet() then begin
                            repeat

                                if RevenueStructure.Year < YearNo then begin
                                    InstallmentStartDate := OriginalStartDate;
                                    InstallmentEndDate := 0D;
                                end;
                                if RevenueStructure."Unit ID" <> UnitId then begin
                                    InstallmentStartDate := OriginalStartDate;
                                    InstallmentEndDate := 0D;
                                end;
                                VATPer := RevenueStructure."VAT %";
                                TotalYears := RevenueStructure."Year";
                                TargetPageID := RevenueStructure."RC ID";
                                if TargetRecord.FindSet() then
                                    Installment := TargetRecord."Number of Installments";

                                InstallmentAmount := ROUND(RevenueStructure."Final Annual Amount" / RevenueStructure."Yearly No. of Installment", 0.01);
                                TotalCalculatedAmount := InstallmentAmount * RevenueStructure."Yearly No. of Installment";  // 1666.67*3 = 5000.01
                                LastInstallmentAmount := TotalCalculatedAmount - RevenueStructure."Final Annual Amount"; // 5000.01 - 5000 = 0.01
                                InstallmentAmount2 := InstallmentAmount - LastInstallmentAmount;   // 1666.67 - 0.01 = 1666.66

                                for InstallmentNumber := 1 to RevenueStructure."Yearly No. of Installment" do begin

                                    if InstallmentEndDate > tenancyContract."Contract Start Date" then begin
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

                                    if InstallmentEndDate > tenancyContract."Contract End Date" then
                                        InstallmentEndDate := tenancyContract."Contract End Date";

                                    InstallmentStructure.SetRange("RC ID", TargetPageID);
                                    InstallmentStructure.SetRange("Year", TotalYears);
                                    InstallmentStructure.SetRange("Installment No.", InstallmentNumber);
                                    InstallmentStructure.SetRange("Revenue Str. Subpage Entry No.", RevenueStructure."Entry No.");

                                    if InstallmentStructure.FindFirst() then begin

                                        if InstallmentNumber = 1 then
                                            InstallmentStructure.Amount := InstallmentAmount2
                                        else
                                            InstallmentStructure.Amount := InstallmentAmount;

                                        InstallmentStructure."Installment Start Date" := InstallmentStartDate;
                                        InstallmentStructure."Installment End Date" := InstallmentEndDate;
                                        InstallmentStructure.Modify();
                                    end else begin
                                        InstallmentStructure.Init();
                                        InstallmentStructure."RC ID" := TargetPageID;
                                        InstallmentStructure."Revenue Str. Subpage Entry No." := RevenueStructure."Entry No.";
                                        InstallmentStructure."Tenant ID" := RevenueStructure."Tenant ID";
                                        InstallmentStructure."Contract ID" := RevenueStructure."Contract ID";
                                        InstallmentStructure."Primary Classification" := RevenueStructure."Propety Classification";
                                        InstallmentStructure."VAT %" := VATPer;
                                        InstallmentStructure."Secondary Item Type" := RevenueStructure."Secondary Item Type";
                                        InstallmentStructure."Year" := TotalYears;
                                        InstallmentStructure."Installment No." := InstallmentNumber;

                                        if InstallmentNumber = RevenueStructure."Yearly No. of Installment" then
                                            InstallmentStructure.Amount := InstallmentAmount2
                                        else
                                            InstallmentStructure.Amount := InstallmentAmount;

                                        if InstallmentStructure."VAT %" = 1 then
                                            InstallmentStructure."VAT %" := 5
                                        else
                                            InstallmentStructure."VAT %" := 0;

                                        InstallmentStructure."VAT Amount" := InstallmentStructure.Amount * (InstallmentStructure."VAT %" / 100);
                                        InstallmentStructure."Amount Including VAT" := InstallmentStructure.Amount + InstallmentStructure."VAT Amount";

                                        InstallmentStructure."Installment Start Date" := InstallmentStartDate;
                                        InstallmentStructure."Installment End Date" := InstallmentEndDate;

                                        if InstallmentNumber = RevenueStructure."Yearly No. of Installment" then
                                            InstallmentStructure."Installment End Date" := RevenueStructure."Period End Date";

                                        InstallmentStructure."Due Date" := InstallmentStructure."Installment Start Date";
                                        InstallmentStructure.Insert();

                                    end;

                                    TargetRecord.SetRange("Contract ID", Rec."Contract ID");
                                    TargetRecord.SetRange("RC ID", RevenueStructure."RC ID");
                                    TargetRecord.SetRange("Secondary Item Type", RevenueStructure."Secondary Item Type");

                                    if TargetRecord.FindSet() then
                                        repeat
                                            Installment := TargetRecord."Number of Installments";
                                            TargetRecord."Number of Installments" := Installment;
                                            TargetRecord.Modify();
                                        until TargetRecord.Next() = 0
                                    else begin
                                        TargetRecord.Init();
                                        TargetRecord."Contract ID" := RevenueStructure."Contract ID";
                                        TargetRecord."RC ID" := RevenueStructure."RC ID";
                                        TargetRecord."Secondary Item Type" := RevenueStructure."Secondary Item Type";
                                        TargetRecord."Number of Installments" := Installment;
                                        TargetRecord.Insert();
                                        Clear(TargetRecord);
                                    end;

                                    Clear(InstallmentStructure);
                                end;
                                UnitId := RevenueStructure."Unit ID";
                                YearNo := RevenueStructure.Year;
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
        Rec."Contract ID" := ContractID;
        Rec."Tenant ID" := tenantID;
    end;

    var
        ContractID: Integer;
        tenantID: Code[20];

    procedure GetStartDate(pContractStartDate: Date; pContractEndDate: Date; var isMonthEnd: Boolean): Date
    var
        StartDate: Date;
    begin
        isMonthEnd := false;
        case pContractStartDate of
            CalcDate('<-CM>', pContractStartDate):
                StartDate := CalcDate('<-CM>', pContractStartDate);
            CalcDate('<CM>', pContractStartDate):
                begin
                    StartDate := CalcDate('<CM>', pContractStartDate);
                    isMonthEnd := true;
                end;
            else
                StartDate := pContractStartDate;
        end;

        exit(StartDate);
    end;
}