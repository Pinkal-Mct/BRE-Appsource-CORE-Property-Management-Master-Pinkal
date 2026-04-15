page 50939 "Tenancy Contract SubPage Card"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Tenancy Contract Subpage";
    Caption = 'Other Payments';
    DeleteAllowed = false;

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
                }
                field("Amount"; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Enter the Amount.';
                    Editable = isEditable;
                }

                field("VAT %"; Rec."VAT %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the VAT percentage.';
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
                field(Invoiced; Rec.Invoiced)
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced';
                    ToolTip = 'Indicates whether the amount has been invoiced.';
                }
                field("Invoiced and Paid"; Rec."Invoiced and Paid")
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced and Paid';
                    ToolTip = 'Indicates whether the amount has been invoiced and paid.';
                }

                field("Payment Type"; Rec."Payment Type")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Type';
                    ToolTip = 'Enter the Payment Type.';
                    ShowMandatory = true;
                    NotBlank = true;

                }

                field("Generate Payment Schedule"; Rec."Generate Payment Schedule")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        RevenueStructure: Record "Revenue Structure Subpage";
                        TargetRecord: Record "Revenue Structure"; // Replace with the actual table name
                        StartDate: Date;
                        EndDate: Date;
                        AnnualAmount: Decimal;
                        NumInstallments: Integer;
                        PeriodStartDate: Date;
                        PeriodEndDate: Date;
                        YearCounter: Integer;
                        NumDays: Integer;

                        Revenuestructureid: Integer;
                    //LeaseRecord: Record "Lease Proposal Details";


                    begin

                        if Rec."Payment Type" = Rec."Payment Type"::Installment then begin



                            TargetRecord.SetRange("Contract ID", Rec."ContractID");
                            TargetRecord.SetRange("Secondary Item Type", Rec."Secondary Item Type");
                            TargetRecord.SetRange("Tenant ID", Rec."TenantID");

                            if TargetRecord.FindSet() then begin
                                TargetRecord."Contract Start Date" := Rec."Start Date";
                                TargetRecord."Contract End Date" := Rec."End Date";
                                TargetRecord."Amount" := Rec."Amount";
                                TargetRecord."VAT Amount" := Rec."VAT Amount";
                                TargetRecord."Amount Including VAT" := Rec."Amount Including VAT";
                                TargetRecord."VAT %" := Rec."VAT %";
                                TargetRecord."Entry No" := Rec."Entry No.";
                                TargetRecord.Modify();
                            end else begin
                                TargetRecord.Init();
                                // TargetRecord."Proposal ID" := Rec."ProposalID";
                                TargetRecord."Contract ID" := Rec."ContractID";
                                TargetRecord."Tenant ID" := Rec."TenantID";
                                TargetRecord."Secondary Item Type" := Rec."Secondary Item Type";
                                TargetRecord."Contract Start Date" := Rec."Start Date";
                                TargetRecord."Contract End Date" := Rec."End Date";
                                TargetRecord."Amount" := Rec."Amount";
                                TargetRecord."VAT Amount" := Rec."VAT Amount";
                                TargetRecord."Amount Including VAT" := Rec."Amount Including VAT";
                                TargetRecord."VAT %" := Rec."VAT %";
                                TargetRecord."Entry No" := Rec."Entry No.";
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
                                    RevenueStructure."Contract ID" := TargetRecord."Contract ID";
                                    RevenueStructure."Year" := YearCounter;
                                    RevenueStructure."Period Start Date" := PeriodStartDate;

                                    RevenueStructure."VAT Amount" := TargetRecord."VAT Amount";
                                    RevenueStructure."Amount Including VAT" := TargetRecord."Amount Including VAT";
                                    RevenueStructure."Secondary Item Type" := TargetRecord."Secondary Item Type";
                                    RevenueStructure."VAT %" := TargetRecord."VAT %";



                                    PeriodEndDate := CalcDate('<1Y>', PeriodStartDate) - 1;



                                    if PeriodEndDate > EndDate then
                                        PeriodEndDate := EndDate;

                                    RevenueStructure."Period End Date" := PeriodEndDate;

                                    NumDays := PeriodEndDate - PeriodStartDate + 1;


                                    RevenueStructure."Number of Days" := NumDays;

                                    RevenueStructure.Insert();
                                    RevenueStructure.Modify();
                                    Clear(RevenueStructure);



                                    PeriodStartDate := PeriodEndDate + 1;
                                    YearCounter += 1;

                                    if TargetRecord.FindLast() then
                                        // If found, get the latest RS ID
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
                    Caption = 'Revenue Structure Link';
                    DrillDown = true;
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
                field("Contract Renewal ID"; Rec."Contract Renewal ID")
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
        revenueStructure: Record "Revenue Structure";
        PaymentSchedule: Record "Payment Schedule2";
        SumInvoicedAmount: Decimal;
    begin
        revenueStructure.SetRange("RS ID", Rec.Link);
        if revenueStructure.IsEmpty() then
            Rec.Link := 0;

        // Calculate total invoiced amount for this secondary item type
        SumInvoicedAmount := 0;
        PaymentSchedule.SetRange("Contract ID", Rec.ContractID);
        PaymentSchedule.SetRange("Tenant ID", Rec.TenantID);
        PaymentSchedule.SetRange("Secondary Item Type", Rec."Secondary Item Type");
        // Only consider lines that are marked Invoiced and have an Invoice ID
        PaymentSchedule.SetFilter(Invoiced, '=true');
        PaymentSchedule.SetFilter("Invoice ID", '<>%1', '');
        if PaymentSchedule.FindSet() then begin
            repeat
                SumInvoicedAmount += PaymentSchedule.Amount;
            until PaymentSchedule.Next() = 0;

            // Update the displayed Invoiced amount on the Tenancy Subpage record
            Rec.Invoiced := SumInvoicedAmount;
        end else
            Rec.Invoiced := 0;

        Rec.Modify();
        CheckRefundableDeposit();

    end;


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.ContractID := ContractID;
        Rec.TenantID := tenantID;
        Rec.ProposalID := (proposalID);
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
        item.SetRange(Description, Rec."Secondary Item Type");
        if item.FindFirst() then
            if item."Category Types" = 'Refundable Deposit' then
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