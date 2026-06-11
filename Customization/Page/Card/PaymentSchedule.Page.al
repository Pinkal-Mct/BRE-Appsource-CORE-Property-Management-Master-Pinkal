page 73209708 "BLRPaymentSchedule"
{
    PageType = ListPart;
    ApplicationArea = All;
    DeleteAllowed = true;
    SourceTable = "BLRRevenueStructureSubpage";
    Caption = 'Payment Schedule';
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
                }
                field("Period Start Date"; Rec."BLRPeriod Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    ToolTip = 'Enter the Start Date.';
                }
                field("Period End Date"; Rec."BLRPeriod End Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    ToolTip = 'Enter the End Date.';
                }
                field("Number of Days"; Rec."BLRNumber of Days")
                {
                    ApplicationArea = All;
                    Caption = 'Number of Days';
                    ToolTip = 'Enter the Number of Days.';
                }
                field("Final Annual Amount"; Rec."BLRFinal Annual Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Final Annual Amount';
                    Editable = true;
                    ShowMandatory = true;
                    NotBlank = true;
                    ToolTip = 'Enter the Final Annual Amount.';
                }
                field("Payment Frequency"; Rec."BLRPayment Frequency")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Frequency';
                    Editable = true;
                    ShowMandatory = true;
                }
                field("Yearly No. of Installment"; Rec."BLRYearly No. of Installment")
                {
                    ApplicationArea = All;
                    Caption = 'Yearly No. of Instalment';
                    Editable = true;
                    ShowMandatory = true;
                    NotBlank = true;
                    ToolTip = 'Enter the Yearly Number of Installments.';


                }
                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'The Tenant ID is used to identify the tenant associated with this record.';
                }
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'The Contract ID is used to identify the contract associated with this record.';
                }
                field("VAT %"; Rec."BLRVAT %")
                {
                    ApplicationArea = All;
                    Caption = 'VAT %';
                    ToolTip = 'Enter the VAT %.';
                    Editable = false;
                }
            }
            group(" ")
            {
                field("Total Amount"; Rec."BLRTotal Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Total Amount';
                    ToolTip = 'Enter the Total Amount.';
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
                        TargetRecord: Record "BLRRevenueStructure";
                        RevenueStructure1: Record "BLRRevenueStructure";
                        RevenueStructure: Record "BLRRevenueStructureSubpage"; // Main table
                        InstallmentStructure: Record "BLRRevenueStructureSubpage1"; // Second subgrid table
                        rentCalcSubCard: Page "BLRRent Calculation SubCard";
                        TargetPageID: Integer;
                        StartDate: Date;
                        EndDate: Date;

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
                        YearNo: Integer;
                        isMonthEnd: Boolean;
                        isMonthStart: Boolean;
                        TotalMonths: Integer;
                        NoOfInstallments: Integer;
                        BaseMonths: Integer;
                        CurrentStartDate: Date;
                        MonthsToAdd: Integer;
                        Remainder: Integer;

                        StartYear: Integer;
                        StartMonth: Integer;
                        StartDay: Integer;
                        EndYear: Integer;
                        EndMonth: Integer;
                        EndDay: Integer;

                    begin

                        RevenueStructure1.SetRange("BLRRS ID", Rec."BLRRS ID");
                        if RevenueStructure1.FindFirst() then
                            if RevenueStructure1."BLRAmount" <> Rec."BLRTotal Amount" then
                                Error('Total Amount (%1) must match the Amount field (%2). Please correct the values.', Rec."BLRTotal Amount", RevenueStructure1."BLRAmount")
                            else begin

                                InstallmentStructure.SetRange("BLRRS ID", Rec."BLRRS ID");
                                if InstallmentStructure.FindSet() then
                                    InstallmentStructure.DeleteAll();


                                tenancyContract.Get(Rec."BLRContract ID");
                                InstallmentStartDate := rentCalcSubCard.GetStartDate(tenancyContract."BLRContract Start Date", tenancyContract."BLRContract End Date", isMonthEnd, isMonthStart);


                                InstallmentEndDate := 0D;

                                // Set filters to fetch related records
                                // RevenueStructure.SetRange("BLRProposal ID", Rec."Proposal ID");

                                RevenueStructure.SetRange("BLRTenant ID", Rec."BLRTenant ID");
                                RevenueStructure.SetRange("BLRContract ID", Rec."BLRContract ID");
                                RevenueStructure.SetRange("BLRRS ID", Rec."BLRRS ID");
                                //TargetRecord.SetRange("BLRProposal ID", Rec."Proposal ID");
                                TargetRecord.SetRange("BLRContract ID", Rec."BLRContract ID");
                                TargetRecord.SetRange("BLRTenant ID", Rec."BLRTenant ID");
                                TargetRecord.SetRange("BLRRS ID", Rec."BLRRS ID");


                                if RevenueStructure.FindSet() then begin
                                    // Loop through Revenue Structure to calculate and populate or update Installment Structure
                                    repeat



                                        StartDate := RevenueStructure."BLRPeriod Start Date";
                                        EndDate := RevenueStructure."BLRPeriod End Date";
                                        //VATAmount := RevenueStructure."BLRVAT Amount";
                                        VATPer := RevenueStructure."BLRVAT %";
                                        TotalYears := RevenueStructure."BLRYear";
                                        TargetPageID := RevenueStructure."BLRRS ID";
                                        if TargetRecord.FindSet() then
                                            Installment := TargetRecord."BLRNumber of Installments";



                                        //  InstallmentAmount := RevenueStructure."BLRFinal Annual Amount" / RevenueStructure."BLRYearly No. of Installment";

                                        InstallmentAmount := ROUND(RevenueStructure."BLRFinal Annual Amount" / RevenueStructure."BLRYearly No. of Installment", 0.01);

                                        TotalCalculatedAmount := InstallmentAmount * RevenueStructure."BLRYearly No. of Installment";  // 1666.67*3 = 5000.01
                                        LastInstallmentAmount := TotalCalculatedAmount - RevenueStructure."BLRFinal Annual Amount"; // 5000.01 - 5000 = 0.01
                                        InstallmentAmount2 := InstallmentAmount - LastInstallmentAmount;   // 1666.67 - 0.01 = 1666.66


                                        NoOfInstallments := RevenueStructure."BLRYearly No. of Installment";
                                        //////////////////////////////// NEW Logic ////////////////////////////////
                                        StartYear := Date2DMY(StartDate, 3);
                                        StartMonth := Date2DMY(StartDate, 2);
                                        StartDay := Date2DMY(StartDate, 1);

                                        EndYear := Date2DMY(EndDate, 3);
                                        EndMonth := Date2DMY(EndDate, 2);
                                        EndDay := Date2DMY(EndDate, 1);

                                        // Base month difference
                                        TotalMonths := ((EndYear - StartYear) * 12) + (EndMonth - StartMonth);

                                        // 🔥 Adjust based on days
                                        if EndDay >= StartDay then
                                            TotalMonths += 1;
                                        if NoOfInstallments > TotalMonths then
                                            Error(
                                                'Installments (%1) cannot be greater than total months (%2).',
                                                NoOfInstallments,
                                                TotalMonths
                                            );

                                        // 🔥 BALANCED LOGIC
                                        BaseMonths := TotalMonths div NoOfInstallments;
                                        Remainder := TotalMonths mod NoOfInstallments;

                                        // 🔥 Start from contract start
                                        CurrentStartDate := StartDate;

                                        for InstallmentNumber := 1 to NoOfInstallments do begin

                                            // 🔥 Balanced distribution
                                            if InstallmentNumber <= Remainder then
                                                MonthsToAdd := BaseMonths + 1
                                            else
                                                MonthsToAdd := BaseMonths;

                                            // Safety
                                            if MonthsToAdd < 1 then
                                                MonthsToAdd := 1;



                                            InstallmentStartDate := CurrentStartDate;

                                            InstallmentEndDate :=
                                                CalcDate(
                                                    '<-1D>',
                                                    CalcDate(
                                                        StrSubstNo('<%1M>', MonthsToAdd),
                                                        InstallmentStartDate
                                                    )
                                                );

                                            // Last installment safety

                                            // 🔥 Last installment takes full remaining period
                                            if InstallmentNumber = NoOfInstallments then
                                                InstallmentEndDate := EndDate;

                                            if InstallmentStartDate > InstallmentEndDate then
                                                InstallmentStartDate := InstallmentEndDate;

                                            CurrentStartDate :=
                                         CalcDate(
                                             StrSubstNo('<%1M>', MonthsToAdd),
                                             InstallmentStartDate
                                         );





                                            // 🔁 Insert (NO duplicate now)
                                            Clear(InstallmentStructure);
                                            InstallmentStructure.SetRange("BLRRS ID", TargetPageID);
                                            InstallmentStructure.SetRange("BLRYear", TotalYears);
                                            InstallmentStructure.SetRange("BLRInstallment No.", InstallmentNumber);

                                            if InstallmentStructure.FindFirst() then begin

                                                if InstallmentNumber = NoOfInstallments then
                                                    InstallmentStructure."BLRAmount" := InstallmentAmount2
                                                else
                                                    InstallmentStructure."BLRAmount" := InstallmentAmount;

                                                InstallmentStructure."BLRInstallment Start Date" := InstallmentStartDate;
                                                InstallmentStructure."BLRInstallment End Date" := InstallmentEndDate;

                                                InstallmentStructure.Modify();

                                            end else begin

                                                InstallmentStructure.Init();
                                                InstallmentStructure."BLRRS ID" := TargetPageID;
                                                InstallmentStructure."BLRTenant ID" := RevenueStructure."BLRTenant ID";
                                                InstallmentStructure."BLRContract ID" := RevenueStructure."BLRContract ID";
                                                InstallmentStructure."BLRVAT %" := VATPer;
                                                InstallmentStructure."BLRSecondary Item Type" := RevenueStructure."BLRSecondary Item Type";
                                                InstallmentStructure."BLRYear" := TotalYears;
                                                InstallmentStructure."BLRInstallment No." := InstallmentNumber;

                                                // Amount
                                                if InstallmentNumber = NoOfInstallments then
                                                    InstallmentStructure."BLRAmount" := InstallmentAmount2
                                                else
                                                    InstallmentStructure."BLRAmount" := InstallmentAmount;

                                                // VAT
                                                if InstallmentStructure."BLRVAT %" = 1 then
                                                    InstallmentStructure."BLRVAT %" := 5
                                                else
                                                    InstallmentStructure."BLRVAT %" := 0;

                                                InstallmentStructure."BLRVAT Amount" :=
                                                    InstallmentStructure."BLRAmount" * (InstallmentStructure."BLRVAT %" / 100);

                                                InstallmentStructure."BLRAmount Including VAT" :=
                                                    InstallmentStructure."BLRAmount" + InstallmentStructure."BLRVAT Amount";

                                                // Dates
                                                InstallmentStructure."BLRInstallment Start Date" := InstallmentStartDate;
                                                InstallmentStructure."BLRInstallment End Date" := InstallmentEndDate;

                                                InstallmentStructure."BLRDue Date" := InstallmentStartDate;

                                                InstallmentStructure.Insert();
                                            end;




                                            TargetRecord.SetRange("BLRContract ID", Rec."BLRContract ID");
                                            // TargetRecord.SetRange("BLRProposal ID", RevenueStructure."Proposal ID"); 
                                            TargetRecord.SetRange("BLRRS ID", RevenueStructure."BLRRS ID");
                                            TargetRecord.SetRange("BLRSecondary Item Type", RevenueStructure."BLRSecondary Item Type");



                                            if TargetRecord.FindSet() then
                                                repeat
                                                    // Calculate or retrieve the Installment value

                                                    Installment := TargetRecord."BLRNumber of Installments";
                                                    // Update the existing record
                                                    TargetRecord."BLRNumber of Installments" := Installment;
                                                    TargetRecord.Modify();
                                                until TargetRecord.Next() = 0
                                            else begin
                                                // If no records exist, insert a new record
                                                TargetRecord.Init();
                                                // TargetRecord."Proposal ID" := RevenueStructure."Proposal ID";
                                                TargetRecord."BLRContract ID" := RevenueStructure."BLRContract ID";
                                                TargetRecord."BLRRS ID" := RevenueStructure."BLRRS ID";
                                                TargetRecord."BLRSecondary Item Type" := RevenueStructure."BLRSecondary Item Type";
                                                TargetRecord."BLRNumber of Installments" := Installment; // Ensure Installment is correctly initialized or calculated
                                                TargetRecord.Insert();
                                                Clear(TargetRecord);
                                            end;

                                            Clear(InstallmentStructure);


                                        end;

                                        YearNo := RevenueStructure."BLRYear";
                                    until RevenueStructure.Next() = 0;



                                    // if InstallmentStructure.FindSet() then begin
                                    //     repeat
                                    //         if InstallmentStructure."BLRInstallment No." > RevenueStructure."BLRYearly No. of Installment" then
                                    //             InstallmentStructure.Delete();
                                    //     until InstallmentStructure.Next() = 0;
                                    // end;
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
        Rec."BLRContract ID" := ContractID;
        Rec."BLRTenant ID" := tenantID;
    end;

    var
        ContractID: Integer;

        tenantID: Code[20];
}
