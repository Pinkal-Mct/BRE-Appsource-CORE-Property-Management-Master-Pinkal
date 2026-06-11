page 73209746 "BLRTenancy ContractSubPageCard"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "BLRTenancyContractSubpage";
    Caption = 'Other Payments';
    DeleteAllowed = false;

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
                }
                field("Amount"; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Enter the Amount.';
                    Editable = isEditable;
                }

                field("VAT %"; Rec."BLRVAT %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the VAT percentage.';
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
                field(Invoiced; Rec.BLRInvoiced)
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced';
                    ToolTip = 'Indicates whether the amount has been invoiced.';
                }
                field("Invoiced and Paid"; Rec."BLRInvoiced and Paid")
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced and Paid';
                    ToolTip = 'Indicates whether the amount has been invoiced and paid.';
                }

                field("BLRPaymentType"; Rec."BLRPayment Type")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Type';
                    ToolTip = 'Enter the Payment Type.';
                    ShowMandatory = true;
                    NotBlank = true;

                }

                field("Generate Payment Schedule"; Rec."BLRGenerate Payment Schedule")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        RevenueStructure: Record "BLRRevenueStructureSubpage";
                        TargetRecord: Record "BLRRevenueStructure"; // Replace with the actual table name
                        StartDate: Date;
                        EndDate: Date;
                        AnnualAmount: Decimal;
                        NumInstallments: Integer;
                        PeriodStartDate: Date;
                        PeriodEndDate: Date;
                        YearCounter: Integer;
                        NumDays: Integer;

                        Revenuestructureid: Integer;
                    //LeaseRecord: Record "BLRLeaseProposalDetails";


                    begin

                        if Rec."BLRPayment Type" = Rec."BLRPayment Type"::Installment then begin



                            TargetRecord.SetRange("BLRContract ID", Rec."BLRContractID");
                            TargetRecord.SetRange("BLRSecondary Item Type", Rec."BLRSecondary Item Type");
                            TargetRecord.SetRange("BLRTenant ID", Rec."BLRTenantID");

                            if TargetRecord.FindSet() then begin
                                TargetRecord."BLRContract Start Date" := Rec."BLRStart Date";
                                TargetRecord."BLRContract End Date" := Rec."BLREnd Date";
                                TargetRecord."BLRAmount" := Rec."BLRAmount";
                                TargetRecord."BLRVAT Amount" := Rec."BLRVAT Amount";
                                TargetRecord."BLRAmount Including VAT" := Rec."BLRAmount Including VAT";
                                TargetRecord."BLRVAT %" := Rec."BLRVAT %";
                                TargetRecord."BLREntry No" := Rec."BLREntry No.";
                                TargetRecord.Modify();
                            end else begin
                                TargetRecord.Init();
                                // TargetRecord."Proposal ID" := Rec."BLRProposalID";
                                TargetRecord."BLRContract ID" := Rec."BLRContractID";
                                TargetRecord."BLRTenant ID" := Rec."BLRTenantID";
                                TargetRecord."BLRSecondary Item Type" := Rec."BLRSecondary Item Type";
                                TargetRecord."BLRContract Start Date" := Rec."BLRStart Date";
                                TargetRecord."BLRContract End Date" := Rec."BLREnd Date";
                                TargetRecord."BLRAmount" := Rec."BLRAmount";
                                TargetRecord."BLRVAT Amount" := Rec."BLRVAT Amount";
                                TargetRecord."BLRAmount Including VAT" := Rec."BLRAmount Including VAT";
                                TargetRecord."BLRVAT %" := Rec."BLRVAT %";
                                TargetRecord."BLREntry No" := Rec."BLREntry No.";
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
                                    RevenueStructure."BLRContract ID" := TargetRecord."BLRContract ID";
                                    RevenueStructure."BLRYear" := YearCounter;
                                    RevenueStructure."BLRPeriod Start Date" := PeriodStartDate;

                                    RevenueStructure."BLRVAT Amount" := TargetRecord."BLRVAT Amount";
                                    RevenueStructure."BLRAmount Including VAT" := TargetRecord."BLRAmount Including VAT";
                                    RevenueStructure."BLRSecondary Item Type" := TargetRecord."BLRSecondary Item Type";
                                    RevenueStructure."BLRVAT %" := TargetRecord."BLRVAT %";



                                    PeriodEndDate := CalcDate('<1Y>', PeriodStartDate) - 1;



                                    if PeriodEndDate > EndDate then
                                        PeriodEndDate := EndDate;

                                    RevenueStructure."BLRPeriod End Date" := PeriodEndDate;

                                    NumDays := PeriodEndDate - PeriodStartDate + 1;


                                    RevenueStructure."BLRNumber of Days" := NumDays;

                                    RevenueStructure.Insert();
                                    RevenueStructure.Modify();
                                    Clear(RevenueStructure);



                                    PeriodStartDate := PeriodEndDate + 1;
                                    YearCounter += 1;

                                    if TargetRecord.FindLast() then
                                        // If found, get the latest RS ID
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
                    Caption = 'Revenue Structure Link';
                    DrillDown = true;
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
                field("Contract Renewal ID"; Rec."BLRContract Renewal ID")
                {
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Displays the Contract Renewal ID.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        revenueStructure: Record "BLRRevenueStructure";
        PaymentSchedule: Record "BLRPaymentSchedule2";
        SumInvoicedAmount: Decimal;
    begin
        revenueStructure.SetRange("BLRRS ID", Rec."BLRLink");
        if revenueStructure.IsEmpty() then
            Rec."BLRLink" := 0;

        // Calculate total invoiced amount for this secondary item type
        SumInvoicedAmount := 0;
        PaymentSchedule.SetRange("BLRContract ID", Rec."BLRContractID");
        PaymentSchedule.SetRange("BLRTenant ID", Rec."BLRTenantID");
        PaymentSchedule.SetRange("BLRSecondary Item Type", Rec."BLRSecondary Item Type");
        // Only consider lines that are marked Invoiced and have an Invoice ID
        PaymentSchedule.SetFilter(BLRInvoiced, '=true');
        PaymentSchedule.SetFilter("BLRInvoice ID", '<>%1', '');
        if PaymentSchedule.FindSet() then begin
            repeat
                SumInvoicedAmount += PaymentSchedule."BLRAmount";
            until PaymentSchedule.Next() = 0;

            // Update the displayed Invoiced amount on the Tenancy Subpage record
            Rec.BLRInvoiced := SumInvoicedAmount;
        end else
            Rec.BLRInvoiced := 0;

        Rec.Modify();
        CheckRefundableDeposit();

    end;


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."BLRContractID" := ContractID;
        Rec."BLRTenantID" := tenantID;
        Rec."BLRProposalID" := (proposalID);
    end;

    var
        ContractID: Integer;
        proposalID: Integer;
        tenantID: Code[20];
        isEditable: Boolean;

    procedure CheckRefundableDeposit()
    var
        item: Record Item;
    begin
        item.SetRange(Description, Rec."BLRSecondary Item Type");
        if item.FindFirst() then
            if item."BLRCategory Types" = 'Refundable Deposit' then
                isEditable := true
            else
                isEditable := false;

    end;

    procedure SetContractID(pContractID: Integer)
    begin
        ContractID := pContractID;
    end;

    procedure SetProposalID(pProposalID: Integer)
    begin
        proposalID := pProposalID;
    end;

    procedure SetTenantID(pTenantID: Code[20])
    begin
        tenantID := pTenantID;
    end;

}