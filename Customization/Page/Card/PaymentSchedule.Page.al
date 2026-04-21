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
                field("Payment Frequency"; Rec."Payment Frequency")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Frequency';
                    Editable = true;
                    ShowMandatory = true;
                }
                field("Yearly No. of Installment"; Rec."Yearly No. of Installment")
                {
                    ApplicationArea = All;
                    Caption = 'Yearly No. of Instalment';
                    Editable = true;
                    ShowMandatory = true;
                    NotBlank = true;
                    ToolTip = 'Enter the Yearly Number of Installments.';


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
                        rentCalcSubCard: Page "Rent Calculation SubCard";
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

                        RevenueStructure1.SetRange("RS ID", Rec."RS ID");
                        if not RevenueStructure1.IsEmpty() then
                            if RevenueStructure1.Amount <> Rec."Total Amount" then
                                Error('Total Amount (%1) must match the Amount field (%2). Please correct the values.', Rec."Total Amount", RevenueStructure1.Amount)
                            else begin

                                InstallmentStructure.SetRange("RS ID", Rec."RS ID");
                                if InstallmentStructure.FindSet() then
                                    InstallmentStructure.DeleteAll();


                                tenancyContract.Get(Rec."Contract ID");
                                InstallmentStartDate := rentCalcSubCard.GetStartDate(tenancyContract."Contract Start Date", tenancyContract."Contract End Date", isMonthEnd, isMonthStart);


                                InstallmentEndDate := 0D;

                                // Set filters to fetch related records
                                // RevenueStructure.SetRange("Proposal ID", Rec."Proposal ID");

                                RevenueStructure.SetRange("Tenant ID", Rec."Tenant ID");
                                RevenueStructure.SetRange("Contract ID", Rec."Contract ID");
                                RevenueStructure.SetRange("RS ID", Rec."RS ID");
                                //TargetRecord.SetRange("Proposal ID", Rec."Proposal ID");
                                TargetRecord.SetRange("Contract ID", Rec."Contract ID");
                                TargetRecord.SetRange("Tenant ID", Rec."Tenant ID");
                                TargetRecord.SetRange("RS ID", Rec."RS ID");


                                if RevenueStructure.FindSet() then begin
                                    // Loop through Revenue Structure to calculate and populate or update Installment Structure
                                    repeat



                                        StartDate := RevenueStructure."Period Start Date";
                                        EndDate := RevenueStructure."Period End Date";
                                        //VATAmount := RevenueStructure."VAT Amount";
                                        VATPer := RevenueStructure."VAT %";
                                        TotalYears := RevenueStructure."Year";
                                        TargetPageID := RevenueStructure."RS ID";
                                        if TargetRecord.FindSet() then
                                            Installment := TargetRecord."Number of Installments";



                                        //  InstallmentAmount := RevenueStructure."Final Annual Amount" / RevenueStructure."Yearly No. of Installment";

                                        InstallmentAmount := ROUND(RevenueStructure."Final Annual Amount" / RevenueStructure."Yearly No. of Installment", 0.01);

                                        TotalCalculatedAmount := InstallmentAmount * RevenueStructure."Yearly No. of Installment";  // 1666.67*3 = 5000.01
                                        LastInstallmentAmount := TotalCalculatedAmount - RevenueStructure."Final Annual Amount"; // 5000.01 - 5000 = 0.01
                                        InstallmentAmount2 := InstallmentAmount - LastInstallmentAmount;   // 1666.67 - 0.01 = 1666.66


                                        NoOfInstallments := RevenueStructure."Yearly No. of Installment";
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
                                            InstallmentStructure.SetRange("RS ID", TargetPageID);
                                            InstallmentStructure.SetRange("Year", TotalYears);
                                            InstallmentStructure.SetRange("Installment No.", InstallmentNumber);

                                            if InstallmentStructure.FindFirst() then begin

                                                if InstallmentNumber = NoOfInstallments then
                                                    InstallmentStructure.Amount := InstallmentAmount2
                                                else
                                                    InstallmentStructure.Amount := InstallmentAmount;

                                                InstallmentStructure."Installment Start Date" := InstallmentStartDate;
                                                InstallmentStructure."Installment End Date" := InstallmentEndDate;

                                                InstallmentStructure.Modify();

                                            end else begin

                                                InstallmentStructure.Init();
                                                InstallmentStructure."RS ID" := TargetPageID;
                                                InstallmentStructure."Tenant ID" := RevenueStructure."Tenant ID";
                                                InstallmentStructure."Contract ID" := RevenueStructure."Contract ID";
                                                InstallmentStructure."VAT %" := VATPer;
                                                InstallmentStructure."Secondary Item Type" := RevenueStructure."Secondary Item Type";
                                                InstallmentStructure."Year" := TotalYears;
                                                InstallmentStructure."Installment No." := InstallmentNumber;

                                                // Amount
                                                if InstallmentNumber = NoOfInstallments then
                                                    InstallmentStructure.Amount := InstallmentAmount2
                                                else
                                                    InstallmentStructure.Amount := InstallmentAmount;

                                                // VAT
                                                if InstallmentStructure."VAT %" = 1 then
                                                    InstallmentStructure."VAT %" := 5
                                                else
                                                    InstallmentStructure."VAT %" := 0;

                                                InstallmentStructure."VAT Amount" :=
                                                    InstallmentStructure.Amount * (InstallmentStructure."VAT %" / 100);

                                                InstallmentStructure."Amount Including VAT" :=
                                                    InstallmentStructure.Amount + InstallmentStructure."VAT Amount";

                                                // Dates
                                                InstallmentStructure."Installment Start Date" := InstallmentStartDate;
                                                InstallmentStructure."Installment End Date" := InstallmentEndDate;

                                                InstallmentStructure."Due Date" := InstallmentStartDate;

                                                InstallmentStructure.Insert();
                                            end;




                                            TargetRecord.SetRange("Contract ID", Rec."Contract ID");
                                            // TargetRecord.SetRange("Proposal ID", RevenueStructure."Proposal ID"); 
                                            TargetRecord.SetRange("RS ID", RevenueStructure."RS ID");
                                            TargetRecord.SetRange("Secondary Item Type", RevenueStructure."Secondary Item Type");



                                            if TargetRecord.FindSet() then
                                                repeat
                                                    // Calculate or retrieve the Installment value

                                                    Installment := TargetRecord."Number of Installments";
                                                    // Update the existing record
                                                    TargetRecord."Number of Installments" := Installment;
                                                    TargetRecord.Modify();
                                                until TargetRecord.Next() = 0
                                            else begin
                                                // If no records exist, insert a new record
                                                TargetRecord.Init();
                                                // TargetRecord."Proposal ID" := RevenueStructure."Proposal ID";
                                                TargetRecord."Contract ID" := RevenueStructure."Contract ID";
                                                TargetRecord."RS ID" := RevenueStructure."RS ID";
                                                TargetRecord."Secondary Item Type" := RevenueStructure."Secondary Item Type";
                                                TargetRecord."Number of Installments" := Installment; // Ensure Installment is correctly initialized or calculated
                                                TargetRecord.Insert();
                                                Clear(TargetRecord);
                                            end;

                                            Clear(InstallmentStructure);


                                        end;

                                        YearNo := RevenueStructure.Year;
                                    until RevenueStructure.Next() = 0;



                                    // if InstallmentStructure.FindSet() then begin
                                    //     repeat
                                    //         if InstallmentStructure."Installment No." > RevenueStructure."Yearly No. of Installment" then
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
        Rec."Contract ID" := ContractID;
        Rec."Tenant ID" := tenantID;
    end;

    var
        ContractID: Integer;

        tenantID: Code[20];
}
