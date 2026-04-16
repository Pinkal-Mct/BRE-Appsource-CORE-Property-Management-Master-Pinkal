page 50915 "Payment Schedule"
{
    PageType = ListPart;
    ApplicationArea = All;
    DeleteAllowed = true;
    SourceTable = "Revenue Structure Subpage";
    Caption = 'Payment Schedule';
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
                }
                field("Period Start Date"; Rec."Period Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    ToolTip = 'Enter the Start Date.';
                }
                field("Period End Date"; Rec."Period End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    ToolTip = 'Enter the End Date.';
                }
                field("Number of Days"; Rec."Number of Days")
                {
                    ApplicationArea = All;
                    Caption = 'Number of Days';
                    ToolTip = 'Enter the Number of Days.';
                }
                field("Final Annual Amount"; Rec."Final Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Final Annual Amount';
                    Editable = true;
                    ShowMandatory = true;
                    NotBlank = true;
                    ToolTip = 'Enter the Final Annual Amount.';
                }
                field("Yearly No. of Installment"; Rec."Yearly No. of Installment")
                {
                    ApplicationArea = All;
                    Caption = 'Yearly No. of Instalment';
                    Editable = true;
                    ShowMandatory = true;
                    NotBlank = true;
                    ToolTip = 'Enter the Yearly Number of Installments.';
                    trigger OnValidate()
                    var
                        calculateinstallmentstotal: Codeunit CalculateNumberOfInstallments;
                    begin
                        if Rec."Yearly No. of Installment" < 1 then
                            Error('Yearly No. of Installment must be at least 1.');

                        calculateinstallmentstotal.CalculateInstallments(Rec);
                    end;

                }
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'The Tenant ID is used to identify the tenant associated with this record.';
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'The Contract ID is used to identify the contract associated with this record.';
                }
                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = All;
                    Caption = 'VAT %';
                    ToolTip = 'Enter the VAT %.';
                    Editable = false;
                }
            }
            group(" ")
            {
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Total Amount';
                    ToolTip = 'Enter the Total Amount.';
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
                        TargetRecord: Record "Revenue Structure";
                        RevenueStructure1: Record "Revenue Structure";
                        RevenueStructure: Record "Revenue Structure Subpage"; // Main table
                        InstallmentStructure: Record "Revenue Structure Subpage1"; // Second subgrid table
                        fetchMonth: Codeunit "Fetch Month";
                        rentCalcSubCard: Page "Rent Calculation SubCard";
                        TargetPageID: Integer;

                        NumInstallments: Integer;
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
                        OffsetMonths: Integer;
                        OriginalStartDate: Date;
                        isMonthEnd: Boolean;
                        isMonthStart: Boolean;
                        YearNo: Integer;
                    begin
                        RevenueStructure1.SetRange("RS ID", Rec."RS ID");
                        if RevenueStructure1.FindFirst() then
                            if RevenueStructure1.Amount <> Rec."Total Amount" then
                                Error('Total Amount (%1) must match the Amount field (%2). Please correct the values.', Rec."Total Amount", RevenueStructure1.Amount)
                            else begin
                                InstallmentStructure.SetRange("RS ID", Rec."RS ID");
                                if InstallmentStructure.FindSet() then
                                    InstallmentStructure.DeleteAll();

                                tenancyContract.Get(Rec."Contract ID");
                                InstallmentStartDate := rentCalcSubCard.GetStartDate(tenancyContract."Contract Start Date", tenancyContract."Contract End Date", isMonthEnd, isMonthStart);
                                OriginalStartDate := InstallmentStartDate;
                                InstallmentEndDate := 0D;
                                NumInstallments := RevenueStructure."Yearly No. of Installment";

                                RevenueStructure.SetRange("Tenant ID", Rec."Tenant ID");
                                RevenueStructure.SetRange("Contract ID", Rec."Contract ID");
                                RevenueStructure.SetRange("RS ID", Rec."RS ID");
                                TargetRecord.SetRange("Contract ID", Rec."Contract ID");
                                TargetRecord.SetRange("Tenant ID", Rec."Tenant ID");
                                TargetRecord.SetRange("RS ID", Rec."RS ID");
                                if RevenueStructure.FindSet() then begin
                                    repeat
                                        OffsetMonths := fetchMonth.GetNoofMonthsFromNoofInstallment(RevenueStructure."Yearly No. of Installment");

                                        if RevenueStructure.Year < YearNo then begin
                                            InstallmentStartDate := OriginalStartDate;
                                            InstallmentEndDate := 0D;
                                        end;

                                        VATPer := RevenueStructure."VAT %";
                                        TotalYears := RevenueStructure."Year";
                                        TargetPageID := RevenueStructure."RS ID";
                                        if TargetRecord.FindSet() then
                                            Installment := TargetRecord."Number of Installments";
                                        InstallmentAmount := ROUND(RevenueStructure."Final Annual Amount" / RevenueStructure."Yearly No. of Installment", 0.01);
                                        TotalCalculatedAmount := InstallmentAmount * RevenueStructure."Yearly No. of Installment";
                                        LastInstallmentAmount := TotalCalculatedAmount - RevenueStructure."Final Annual Amount";
                                        InstallmentAmount2 := InstallmentAmount - LastInstallmentAmount;
                                        for InstallmentNumber := 1 to RevenueStructure."Yearly No. of Installment" do begin


                                            if InstallmentEndDate > tenancyContract."Contract Start Date" then begin
                                                if InstallmentNumber = 1 then
                                                    InstallmentStartDate := RevenueStructure."Period Start Date"
                                                else
                                                    InstallmentStartDate := CalcDate('<' + Format(OffsetMonths) + 'M>', InstallmentStartDate);

                                                if isMonthEnd then begin
                                                    InstallmentStartDate := CalcDate('<CM>', InstallmentStartDate);
                                                    // fetchMonth.GetNoofDaysInMonth(Date2DMY(InstallmentStartDate, 2), Date2DMY(InstallmentStartDate, 3));
                                                    InstallmentEndDate := CalcDate('<-1D>', CalcDate('<CM>', CalcDate('<' + Format(OffsetMonths) + 'M>', InstallmentStartDate)));
                                                end

                                                else
                                                    InstallmentEndDate := CalcDate('<-1D>', CalcDate('<' + Format(OffsetMonths) + 'M>', InstallmentStartDate));
                                            end
                                            else
                                                InstallmentEndDate := CalcDate('<-1D>', CalcDate('<' + Format(OffsetMonths) + 'M>', InstallmentStartDate));

                                            if InstallmentEndDate > tenancyContract."Contract End Date" then
                                                InstallmentEndDate := tenancyContract."Contract End Date";

                                            InstallmentStructure.SetRange("RS ID", TargetPageID);
                                            InstallmentStructure.SetRange("Year", TotalYears);
                                            InstallmentStructure.SetRange("Installment No.", InstallmentNumber);
                                            if InstallmentStructure.FindFirst() then begin
                                                if InstallmentNumber = 1 then
                                                    InstallmentStructure.Amount := InstallmentAmount2
                                                else begin
                                                    InstallmentStructure.Amount := InstallmentAmount;
                                                    InstallmentStructure."Installment Start Date" := InstallmentStartDate;
                                                    InstallmentStructure."Installment End Date" := InstallmentEndDate;

                                                    InstallmentStructure.Modify();
                                                end;

                                            end else begin
                                                InstallmentStructure.Init();
                                                InstallmentStructure."RS ID" := TargetPageID;
                                                InstallmentStructure."Tenant ID" := RevenueStructure."Tenant ID";
                                                InstallmentStructure."Contract ID" := RevenueStructure."Contract ID";
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


                                                IF InstallmentNumber = RevenueStructure."Yearly No. of Installment" THEN
                                                    InstallmentStructure."Installment End Date" := RevenueStructure."Period End Date";
                                                InstallmentStructure."Due Date" := InstallmentStructure."Installment Start Date";
                                                InstallmentStructure.Insert();
                                            end;
                                            TargetRecord.SetRange("Contract ID", Rec."Contract ID");
                                            TargetRecord.SetRange("RS ID", RevenueStructure."RS ID");
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
                                                TargetRecord."RS ID" := RevenueStructure."RS ID";
                                                TargetRecord."Secondary Item Type" := RevenueStructure."Secondary Item Type";
                                                TargetRecord."Number of Installments" := Installment;
                                                TargetRecord.Insert();
                                                Clear(TargetRecord);
                                            end;
                                            Clear(InstallmentStructure);
                                        end;
                                        YearNo := RevenueStructure.Year;
                                    until RevenueStructure.Next() = 0;
                                    Message('Data Create Successfully!');
                                end else
                                    Error('No records found in the Revenue Structure.');
                            end
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
}
