page 50903 "Final Calculation Card"
{
    PageType = Card;
    SourceTable = "Final Calculation";
    ApplicationArea = All;
    Caption = 'Final Calculation Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group("Contract Details")
            {
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Unique identifier for the contract.';
                }
                field("FC ID"; Rec."FC ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Unique identifier for the final calculation.';
                }
                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                    ToolTip = 'Enter the Contract Start Date.';
                    Editable = false;
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
                    ToolTip = 'Enter the Contract End Date.';
                    Editable = false;
                }
                field("Unit Type"; Rec."Unit Type")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Type';
                    ToolTip = 'Enter the Unit Type.';
                    Editable = false;
                }
                field("Contract Amount"; Rec."Contract Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Amount';
                    ToolTip = 'Enter the Contract Amount.';
                    Editable = false;
                }
                field("Intimation Date"; Rec."Intimation Date")
                {
                    ApplicationArea = All;
                    Caption = 'Intimation Date';
                    ToolTip = 'Enter the Initmation Date.';
                }
                field("Termination Date"; Rec."Termination Date")
                {
                    ApplicationArea = All;
                    Caption = 'Termination Date';
                    ToolTip = 'Enter the Termination Date.';

                    trigger OnValidate()
                    var
                        FinalCalculation: Record "Final Calculation";
                        TerminateDate: Date;
                        DaysCal: Integer;
                        StartDate: Date;

                    begin
                        FinalCalculation.SetRange("FC ID", Rec."FC ID");
                        FinalCalculation.SetRange("Contract ID", Rec."Contract ID");
                        if not FinalCalculation.IsEmpty() then begin

                            StartDate := Rec."Contract Start Date";
                            TerminateDate := Rec."Termination Date";
                            DaysCal := TerminateDate - StartDate + 1;
                            Rec."Actual Contract Tenure" := DaysCal;
                            Rec.Modify();

                        end;
                        // CurrPage.Update();

                        GetContractTerminationYear();

                        Fetchperdayrent();
                        PopulateRevenueCalculationGrid();
                        GetDataTenancyContract();
                        BillingCalcGridRentCalc();
                        BillingCalcridTenancyContractSubpge();
                        ReciveableCalcGridRentCalc();
                        ReciveableCalcridTenancyContractSubpge();
                        RentCalculate();
                        OtherPaymentCalculate();
                        RevenueCalculateOneTime();
                        RevenueCalculate();
                        PaymentDetailsFromPaymentSchedule2();

                    end;
                }
                field("ContractYear(Termination Date)"; Rec."ContractYear(Termination Date)")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Year On Termination Date';
                    ToolTip = 'Enter the ContractYear(Termination Date).';
                    Editable = false;
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'Enter the Tenant ID.';
                }
                field("Tenant Email"; Rec."Tenant Email")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Email';
                    Editable = false;
                    ToolTip = 'Enter the Tenant Email.';
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Name';
                    Editable = false;
                    ToolTip = 'Enter the Tenant Name.';
                }
                field("Original Contract Tenure"; Rec."Original Contract Tenure")
                {
                    ApplicationArea = All;
                    Caption = 'Original Contract Tenure';
                    ToolTip = 'Enter the Original Contract Tenure.';
                    Editable = false;
                }

                field("Actual Contract Tenure"; Rec."Actual Contract Tenure")
                {
                    ApplicationArea = All;
                    Caption = 'Actual Contract Tenure';
                    ToolTip = 'Enter the Actual Contract Tenure.';
                    Editable = false;
                }
                field("Total No. Of Days"; Rec."Total No. Of Days")
                {
                    ApplicationArea = All;
                    Caption = 'Total No. Of Days(Termination Year)';
                    ToolTip = 'Enter the Total No. Of Days.';
                    Editable = false;
                }
                field("Per Day Rent"; Rec."Per Day Rent")
                {
                    ApplicationArea = All;
                    Caption = 'Per Day Rent(Termination Year)';
                    ToolTip = 'Enter the Per Day Rent.';
                    Editable = false;
                }
                field("Annual Rent Amount TermiYear"; Rec."Annual Rent Amount TermiYear")
                {
                    ApplicationArea = All;
                    Caption = 'Annual Rent Amount of Termination Year';
                    Editable = false;
                    ToolTip = 'Enter the Annual Rent Amount of Termination Year.';
                }
                field("Status"; Rec.Status)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    Editable = false;
                    ToolTip = 'Status of the final calculation, indicating whether it is pending, approved, or rejected.';
                }

                field("Termination Status"; Rec."Termination Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Termination Type';
                    ToolTip = 'Type of termination for the contract, such as Normal Termination or Early Termination.';
                }
                field("Final Calculation Document"; Rec."Final Calculation Document")
                {
                    ApplicationArea = All;
                    Caption = 'Final Calculation Document';
                    DrillDown = true;
                    Editable = false;
                    ToolTip = 'Upload the final calculation document for the contract.';

                    trigger OnDrillDown()
                    var
                        azureBlobUploader: Codeunit "Azure AD Blob Storage";
                        fileName: Text;
                        uploadResult: Text;
                        folderName: Text;
                    begin
                        folderName := 'finalcalculationdocument';
                        fileName := azureBlobUploader.ValidateDocument(uploadResult, folderName);
                        if fileName <> '' then begin
                            Rec."Final Calculation Document" := CopyStr(fileName, 1, StrLen(fileName));
                            Rec."Final Calculation URL" := CopyStr(uploadResult, 1, StrLen(uploadResult));
                            Rec.Modify();
                            Message('File uploaded successfully: %1', fileName);
                        end;
                    end;
                }

                field("Credit Note Document"; Rec."Credit Note Document")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Note Document';
                    DrillDown = true;
                    Editable = false;
                    ToolTip = 'Upload the credit note document for the contract.';

                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin
                        // Get the URL of the uploaded document
                        FileURL := Rec."Credit Note URL";

                        // Check if the file URL is not empty
                        if FileURL = '' then
                            Error('No document is available to view.');

                        // Open the file URL in the browser (new tab)
                        OpenFileInBrowser(FileURL);

                    end;
                }

                field("Credit Note URL"; Rec."Credit Note URL")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'URL of the credit note document associated with the final calculation.';
                }

            }

            part("FinalRevenueCalculation"; "Final Revenue Calculation Grid")
            {
                SubPageLink = "Contract ID" = FIELD("Contract ID");
                ApplicationArea = All;
            }

            part("BillingCalculation"; "Final Billing Calculation")
            {
                SubPageLink = "Contract ID" = FIELD("Contract ID");
                ApplicationArea = All;
            }

            part("Pendingreceivable/Payable"; "Pending Recevieable Grid")
            {
                SubPageLink = "Contract ID" = FIELD("Contract ID");
                ApplicationArea = All;
            }

            group("Termination Additional Charges")
            {
                part("Additional Charges"; "Additional Charges Sub Card")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }
            group("Rent-Calculation")
            {
                part("Rent Calculation"; "Rent Calculate Sub Card")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }
            group("Revenue-structure")
            {
                part("Other Payment"; "OtherPayment Calculate SubCard")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }
            group("Revenue structure - Yearly break-down")
            {
                part("Revenue Structure"; "Revenue Calculate Sub Card")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }


            part(PaymentDetails; "Payment Details")
            {
                SubPageLink = "Contract ID" = FIELD("Contract ID");
                ApplicationArea = All;
            }
            group("Adjust Security Deposit")
            {
                group("Carry Forward the Security Deposit From")
                {
                    field("ContractID"; Rec."Contract ID")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Unique identifier for the contract from which the security deposit is carried forward.';

                    }
                    field("Security Deposit"; Rec."Security Deposit")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Total security deposit amount carried forward from the previous contract.';
                    }
                    field("Adjustment Security Deposit"; Rec."Adjustment Security Deposit")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Adjustment amount for the security deposit, indicating any changes made to the original deposit.';
                    }
                    field("Net Balance"; Rec."Net Balance")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Net balance of the security deposit after applying adjustments.';
                    }
                }
                group("Carry Forward the Security Deposit To")
                {
                    part("Carry Forward"; "Carry Forward Grid")
                    {
                        SubPageLink = "Contract ID" = FIELD("Contract ID"); // Link to filter attachments for this owner only
                        ApplicationArea = All;
                        // Visible = isVisible;
                    }
                }
                group("Refundable Deposits")
                {
                    field("NetBalance"; Rec."Net Balance")
                    {
                        ApplicationArea = All;
                        Caption = 'Security Deposit';
                        Editable = false;
                        ToolTip = 'Total security deposit amount after adjustments.';
                    }
                    field("Chiller Deposit"; Rec."Chiller Deposit")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Chiller deposit amount associated with the contract.';
                    }
                    field("Other Deposit"; Rec."Other Deposit")
                    {
                        ApplicationArea = All;
                        Editable = false;
                        ToolTip = 'Other deposit amount associated with the contract.';
                    }
                    field("Total Net Balance"; Rec."Total Refundable Deposit")
                    {
                        ApplicationArea = All;
                        Caption = 'Total Refundable Deposit';
                        Editable = false;
                        ToolTip = 'Total refundable deposit amount after adjustments.';
                    }
                }
            }
            group("Summary")
            {
                field("Total Claim"; Rec."Total Claim")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Total claim amount for the final calculation, including all charges and adjustments.';
                }
                field("Total Adjustment"; Rec."Total Adjustment")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Total adjustment amount applied to the final calculation, including any corrections or modifications.';
                }
                field("Total Refund"; Rec."Total Refund")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Total refund amount calculated for the tenant, based on the final calculation and any adjustments made.';
                }
                field("Total Receive"; Rec."Total Receive")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Total amount to be received from the tenant after final calculation, including all charges and adjustments.';
                }
                field("Summery Net Balance"; Rec."Summery Net Balance")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Net balance summary after all calculations, including total claims, adjustments, refunds, and receivables.';
                }
                field("Amount Refundable"; Rec."Amount Refundable")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Amount refundable to the tenant after final calculation, including any security deposits and adjustments.';
                    trigger OnValidate()
                    begin
                        if Rec."Amount Refundable" <> 0 then
                            IsRefundable := true
                        else
                            IsReceivable := true;
                        UpdateCanPost();
                    end;
                }
                field("Net Receivable From The Tenant"; Rec."Net Receivable From The Tenant")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Net amount receivable from the tenant after final calculation, including all charges and adjustments.';

                    trigger OnValidate()
                    begin
                        if Rec."Net Receivable From The Tenant" <> 0 then
                            IsReceivable := true
                        else
                            IsRefundable := true;
                        UpdateCanPost();
                    end;
                }
            }

            group("FinalSettlemt")
            {
                Caption = 'Final Settlement';
                Visible = IsReceivable;
                part("FinalSettelemts"; "FinalSettlemtCard")
                {
                    SubPageLink = "FC ID" = FIELD("FC ID");
                    //  "Tenant ID" = FIELD("Tenant ID");
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }

            group("FinalSettlemts")
            {
                Caption = 'Final Settlement';
                Visible = IsRefundable;
                part("FinalSettelemtss"; "FinalSettlemtRefundCard")
                {
                    SubPageLink = "FC ID" = FIELD("FC ID");
                    // "Tenant ID" = FIELD("Tenant ID");
                    ApplicationArea = All;
                    // Visible = isVisible;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FinalCalculation)
            {
                ToolTip = 'Post Final Calculation';
                ApplicationArea = All;
                Caption = 'Final Calculation';
                Image = PostDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Enabled = CanPost;
                trigger OnAction()
                var
                    ApprovalFinalCalculation: Record "Approval Final Calculation";
                begin
                    // Validate required fields
                    if Rec."Contract ID" = 0 then
                        Error('Contract ID must be specified');

                    ApprovalFinalCalculation.SetRange("Contract ID", Rec."Contract ID");
                    ApprovalFinalCalculation.SetRange("Tenant ID", Rec."Tenant ID");
                    ApprovalFinalCalculation.SetRange("FC ID", Rec."FC ID");
                    if ApprovalFinalCalculation.FindSet() then begin
                        ApprovalFinalCalculation."FC ID" := Rec."FC ID";
                        ApprovalFinalCalculation."Contract ID" := Rec."Contract ID";
                        ApprovalFinalCalculation."Tenant ID" := Rec."Tenant ID";
                        ApprovalFinalCalculation."Status" := Rec."Status";
                        ApprovalFinalCalculation."Contract Start Date" := Rec."Contract Start Date";
                        ApprovalFinalCalculation."Contract End Date" := Rec."Contract End Date";
                        ApprovalFinalCalculation."Termination Date" := Rec."Termination Date";
                        ApprovalFinalCalculation."Contract Amount" := Rec."Contract Amount";
                        ApprovalFinalCalculation."Link" := Rec."FC ID";
                        ApprovalFinalCalculation.Modify();
                        Message('Approval Request Modify successfully!');
                    end else begin

                        // Create new entry
                        ApprovalFinalCalculation.Init();
                        ApprovalFinalCalculation."FC ID" := Rec."FC ID";
                        ApprovalFinalCalculation."Contract ID" := Rec."Contract ID";
                        ApprovalFinalCalculation."Tenant ID" := Rec."Tenant ID";
                        ApprovalFinalCalculation."Status" := Rec."Status";
                        ApprovalFinalCalculation."Contract Start Date" := Rec."Contract Start Date";
                        ApprovalFinalCalculation."Contract End Date" := Rec."Contract End Date";
                        ApprovalFinalCalculation."Termination Date" := Rec."Termination Date";
                        ApprovalFinalCalculation."Contract Amount" := Rec."Contract Amount";
                        ApprovalFinalCalculation."Link" := Rec."FC ID";
                        ApprovalFinalCalculation.Insert(true);

                        Message('Approval Request Send successfully!');
                    end;
                end;
            }
        }
        area(Reporting)
        {
            action("Run Report")
            {
                ToolTip = 'Run Report';
                ApplicationArea = All;
                trigger OnAction()
                var
                    Finalcalculation: Record "Final Calculation";
                    TerminationReport: Report "Termination Template";
                begin
                    Finalcalculation.SetRange("Contract ID", Rec."Contract ID");  // Set appropriate filters
                    TerminationReport.SetTableView(Finalcalculation);
                    TerminationReport.RunModal();
                end;
            }
        }
    }

    //////////////////  START Final Revenue Calculation Grid ////////////////////
    procedure PopulateRevenueCalculationGrid()
    var
        FinalRevCalcGrid: Record "Final Revenue Calculation Grid";
        RentCalc: Record "Rent Calculation";
    begin
        // Clear existing lines in Final Revenue Calculation Grid for this contract
        FinalRevCalcGrid.SetRange("Contract ID", Rec."Contract ID");
        if FinalRevCalcGrid.FindSet() then
            FinalRevCalcGrid.DeleteAll();

        // Step 1: Get main rent amount from Rent Calculation table
        // RentCalc.Reset();
        RentCalc.SetRange("Contract ID", Rec."Contract ID");
        if RentCalc.FindSet() then
            repeat
                FinalRevCalcGrid.Init();
                FinalRevCalcGrid."Contract ID" := RentCalc."Contract ID";
                FinalRevCalcGrid."Revenue Description" := RentCalc."Secondary Item Type";
                FinalRevCalcGrid."Original Amount" := RentCalc."Amount";
                FinalRevCalcGrid."Original VAT" := RentCalc."VAT Amount";
                FinalRevCalcGrid."Original Amount Incl." := RentCalc."Amount Including VAT";
                FinalRevCalcGrid."Actual Contract Tenure" := Rec."Actual Contract Tenure";
                // FinalRevCalcGrid."Per Day Rent" := Rec."Per Day Rent";
                FinalRevCalcGrid."ContractYear(Termination Date)" := Rec."ContractYear(Termination Date)";
                // FinalRevCalcGrid."Annual Rent Amount TermiYear" := Rec."Annual Rent Amount TermiYear";
                FinalRevCalcGrid."Total No. Of Days" := Rec."Total No. Of Days";
                FinalRevCalcGrid.Insert();
                Clear(FinalRevCalcGrid);
            until RentCalc.Next() = 0;

    end;


    procedure GetDataTenancyContract()
    var
        FinalRevCalcGrid1: Record "Final Revenue Calculation Grid";
        TenancyContractLine1: Record "Tenancy Contract Subpage";

    begin

        // TenancyContractLine.Reset();
        TenancyContractLine1.SetRange("ContractID", Rec."Contract ID");
        if TenancyContractLine1.FindSet() then
            repeat
                FinalRevCalcGrid1.Init();
                FinalRevCalcGrid1."Contract ID" := Rec."Contract ID";
                FinalRevCalcGrid1."Revenue Description" := TenancyContractLine1."Secondary Item Type";
                FinalRevCalcGrid1."Original Amount" := TenancyContractLine1.Amount;

                // Calculate VAT amount based on percentage
                FinalRevCalcGrid1."Original VAT" := TenancyContractLine1."VAT Amount";

                FinalRevCalcGrid1."Original Amount Incl." := TenancyContractLine1."Amount Including VAT";
                FinalRevCalcGrid1."Actual Contract Tenure" := Rec."Actual Contract Tenure";
                //   FinalRevCalcGrid1."Per Day Rent" := Rec."Per Day Rent";
                FinalRevCalcGrid1."ContractYear(Termination Date)" := Rec."ContractYear(Termination Date)";
                //  FinalRevCalcGrid1."Annual Rent Amount TermiYear" := Rec."Annual Rent Amount TermiYear";
                FinalRevCalcGrid1."Total No. Of Days" := Rec."Total No. Of Days";
                FinalRevCalcGrid1."Payment Type" := Format(TenancyContractLine1."Payment Type");
                FinalRevCalcGrid1.Insert();
                Clear(FinalRevCalcGrid1);
            until TenancyContractLine1.Next() = 0;

    end;

    procedure GetContractTerminationYear()
    var
        RentCalculationSub: Record "Rent Calculation Subpage";
        UserYear: Integer;
        Terminationdate: Date;
    begin
        UserYear := 0;
        Terminationdate := Rec."Termination Date";
        RentCalculationSub.SetRange("Contract ID", Rec."Contract ID");
        if RentCalculationSub.FindSet() then
            repeat
                if (Terminationdate >= RentCalculationSub."Period Start Date") and (Terminationdate <= RentCalculationSub."Period End Date") then
                    UserYear := RentCalculationSub.Year;
            until (RentCalculationSub.Next() = 0) or (UserYear <> 0);

        Rec."ContractYear(Termination Date)" := UserYear;
        Rec.Modify();
    end;

    procedure Fetchperdayrent()
    var
        RentCalculation1: Record "Rent Calculation Subpage";
        DifferenceDays: Integer;
    begin
        RentCalculation1.SetRange("Contract ID", Rec."Contract ID");
        RentCalculation1.SetRange("Year", Rec."ContractYear(Termination Date)");

        if RentCalculation1.FindSet() then
            repeat
                Rec."Per Day Rent" := RentCalculation1."Per Day Rent";
                DifferenceDays := Rec."Termination Date" - RentCalculation1."Period Start Date";
                Rec."Total No. Of Days" := DifferenceDays + 1;
                Rec."Annual Rent Amount TermiYear" := RentCalculation1."Final Annual Amount";
                Rec.Modify();
            until RentCalculation1.Next() = 0;
    end;

    procedure RentCalculate()
    var
        RentCalculationSub: Record "Rent Calculation Subpage";
        lRentCalculate: Record "Rent Calculate Sub";
    begin

        lRentCalculate.SetRange("Contract ID", Rec."Contract ID");
        if lRentCalculate.FindSet() then
            lRentCalculate.DeleteAll();


        // TenancyContractLine.Reset();
        RentCalculationSub.SetRange("Contract ID", Rec."Contract ID");
        RentCalculationSub.SetRange("Tenant ID", Rec."Tenant ID");
        if RentCalculationSub.FindSet() then
            repeat
                lRentCalculate.Init();
                lRentCalculate."Contract ID" := Rec."Contract ID";
                lRentCalculate."Tenant ID" := Rec."Tenant ID";
                // Calculate VAT amount based on percentage
                lRentCalculate."Year" := RentCalculationSub."Year";
                lRentCalculate."Period Start Date" := RentCalculationSub."Period Start Date";
                lRentCalculate."Period End Date" := RentCalculationSub."Period End Date";
                lRentCalculate."Number Of Days" := RentCalculationSub."Number Of Days";
                lRentCalculate."Final Annual Amount" := RentCalculationSub."Final Annual Amount";
                lRentCalculate."Per Day Rent" := RentCalculationSub."Per Day Rent";
                lRentCalculate.Insert();
                Clear(lRentCalculate);
            until RentCalculationSub.Next() = 0;

    end;

    procedure OtherPaymentCalculate()
    var
        TenancyContractSub: Record "Tenancy Contract Subpage";
        OtherPaymentCalculateSub: Record "Other Payment Calculate Sub";

    begin
        OtherPaymentCalculateSub.SetRange("Contract ID", Rec."Contract ID");
        if OtherPaymentCalculateSub.FindSet() then
            OtherPaymentCalculateSub.DeleteAll();

        TenancyContractSub.SetRange("ContractID", Rec."Contract ID");
        if TenancyContractSub.FindSet() then
            repeat
                OtherPaymentCalculateSub.Init();
                OtherPaymentCalculateSub."Contract ID" := Rec."Contract ID";
                OtherPaymentCalculateSub."Tenant ID" := Rec."Tenant ID";
                OtherPaymentCalculateSub."Secondary Item Type" := TenancyContractSub."Secondary Item Type";
                OtherPaymentCalculateSub."Amount" := TenancyContractSub."Amount";
                OtherPaymentCalculateSub."VAT Amount" := TenancyContractSub."VAT Amount";
                OtherPaymentCalculateSub."Amount Including VAT" := TenancyContractSub."Amount Including VAT";
                OtherPaymentCalculateSub."Start Date" := TenancyContractSub."Start Date";
                OtherPaymentCalculateSub."End Date" := TenancyContractSub."End Date";
                OtherPaymentCalculateSub.Insert();
                Clear(OtherPaymentCalculateSub);
            until TenancyContractSub.Next() = 0;

    end;

    procedure RevenueCalculateOneTime()
    var
        TenancyContractSub: Record "Tenancy Contract Subpage";
        lRevenueCalculate: Record "Revenue Calculate Sub";
    begin

        lRevenueCalculate.SetRange("Contract ID", Rec."Contract ID");
        if lRevenueCalculate.FindSet() then
            lRevenueCalculate.DeleteAll();

        TenancyContractSub.SetRange("ContractID", Rec."Contract ID");
        TenancyContractSub.SetRange("TenantID", Rec."Tenant ID");

        TenancyContractSub.SetRange("Payment Type", 1);
        if TenancyContractSub.FindSet() then
            repeat
                lRevenueCalculate.Init();
                lRevenueCalculate."Contract ID" := TenancyContractSub."ContractID";
                lRevenueCalculate."Tenant ID" := TenancyContractSub."TenantId";
                lRevenueCalculate."Secondary Item Type" := TenancyContractSub."Secondary Item Type";
                lRevenueCalculate.Amount := TenancyContractSub.Amount;
                lRevenueCalculate."VAT Amount" := TenancyContractSub."VAT Amount";
                lRevenueCalculate."Amount Including VAT" := TenancyContractSub."Amount Including VAT";
                lRevenueCalculate."Installment Start Date" := TenancyContractSub."Start Date";
                lRevenueCalculate."Installment End Date" := TenancyContractSub."End Date";
                lRevenueCalculate.Insert();
                Clear(lRevenueCalculate);
            until TenancyContractSub.Next() = 0;
    end;

    procedure RevenueCalculate()
    var
        RevenueStructureSub: Record "Revenue Structure Subpage";
        RevenueCalculateSub: Record "Revenue Calculate Sub";
    begin

        // TenancyContractLine.Reset();
        RevenueStructureSub.SetRange("Contract ID", Rec."Contract ID");
        RevenueStructureSub.SetRange("Tenant ID", Rec."Tenant ID");
        if RevenueStructureSub.FindSet() then
            repeat
                RevenueCalculateSub.Init();
                RevenueCalculateSub."Contract ID" := Rec."Contract ID";
                RevenueCalculateSub."Tenant ID" := Rec."Tenant ID";
                // Calculate VAT amount based on percentage
                RevenueCalculateSub."Secondary Item Type" := RevenueStructureSub."Secondary Item Type";
                RevenueCalculateSub."Amount" := RevenueStructureSub."Final Annual Amount";
                RevenueCalculateSub."VAT Amount" := RevenueStructureSub."VAT Amount";
                RevenueCalculateSub."Amount Including VAT" := RevenueStructureSub."Amount Including VAT";
                RevenueCalculateSub."Installment Start Date" := RevenueStructureSub."Period Start Date";
                RevenueCalculateSub."Installment End Date" := RevenueStructureSub."Period End Date";
                RevenueCalculateSub.Insert();
                Clear(RevenueCalculateSub);
            until RevenueStructureSub.Next() = 0;

    end;

    //----------------------------------Fetch Security Deposit-------------------------------//


    //-----------------------------------Fetch total claim---------------------------------//    

    trigger OnAfterGetRecord()
    begin
        CurrPage."Additional Charges".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."Additional Charges".Page.SetContractID(Rec."Contract ID");
        CurrPage."Additional Charges".Page.SetStartEndDate(Rec."Contract Start Date", Rec."Contract End Date");
        CurrPage."Additional Charges".Page.SetUnitType(Rec."Unit Type");
        CurrPage."FinalSettelemts".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."FinalSettelemts".Page.SetContractID(Rec."Contract ID");
        CurrPage."FinalSettelemtss".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."FinalSettelemtss".Page.SetContractID(Rec."Contract ID");
        // FetchSecurityDepositInfo();
        // UpdateTotalClaim(); // Add this line to calculate the total
        FinalSettlementVisible();
        if Rec."Amount Refundable" <> 0 then
            IsRefundable := true
        else
            IsReceivable := true;

        if Rec."Net Receivable From The Tenant" <> 0 then
            IsReceivable := true
        else
            IsRefundable := true;
        UpdateCanPost();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        CurrPage."Additional Charges".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."Additional Charges".Page.SetContractID(Rec."Contract ID");
        CurrPage."Additional Charges".Page.SetStartEndDate(Rec."Contract Start Date", Rec."Contract End Date");
        CurrPage."Additional Charges".Page.SetUnitType(Rec."Unit Type");
        CurrPage."FinalSettelemts".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."FinalSettelemts".Page.SetContractID(Rec."Contract ID");
        CurrPage."FinalSettelemtss".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."FinalSettelemtss".Page.SetContractID(Rec."Contract ID");
        // UpdateTotalClaim(); // Add this line to calculate the total
        FinalSettlementVisible();
        if Rec."Amount Refundable" <> 0 then
            IsRefundable := true
        else
            IsReceivable := true;

        if Rec."Net Receivable From The Tenant" <> 0 then
            IsReceivable := true
        else
            IsRefundable := true;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage."Additional Charges".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."Additional Charges".Page.SetContractID(Rec."Contract ID");
        CurrPage."Additional Charges".Page.SetStartEndDate(Rec."Contract Start Date", Rec."Contract End Date");
        CurrPage."Additional Charges".Page.SetUnitType(Rec."Unit Type");
        CurrPage."FinalSettelemts".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."FinalSettelemts".Page.SetContractID(Rec."Contract ID");
        CurrPage."FinalSettelemtss".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."FinalSettelemtss".Page.SetContractID(Rec."Contract ID");
        FinalSettlementVisible();
        if Rec."Amount Refundable" <> 0 then
            IsRefundable := true
        else
            IsReceivable := true;

        if Rec."Net Receivable From The Tenant" <> 0 then
            IsReceivable := true
        else
            IsRefundable := true;
    end;

    procedure BillingCalcGridRentCalc()
    var

        BillinCalcGrid: Record "Final Billing Calculation Grid";
        RentCalc1: Record "Rent Calculation";
        vatper: Integer;

    begin
        // Clear existing lines in Final Revenue Calculation Grid for this contract
        BillinCalcGrid.SetRange("Contract ID", Rec."Contract ID");
        if BillinCalcGrid.FindSet() then
            BillinCalcGrid.DeleteAll();

        // Step 1: Get main rent amount from Rent Calculation table
        // RentCalc.Reset();
        RentCalc1.SetRange("Contract ID", Rec."Contract ID");
        if RentCalc1.FindSet() then
            repeat
                BillinCalcGrid.Init();
                BillinCalcGrid."Contract ID" := RentCalc1."Contract ID";
                BillinCalcGrid."RevenueDescription" := RentCalc1."Secondary Item Type";
                BillinCalcGrid."Termination Date" := Rec."Termination Date";
                BillinCalcGrid."Property Classification" := CopyStr(Rec."Unit Type", 1, StrLen(Rec."Unit Type"));
                BillinCalcGrid."Tenant ID" := Rec."Tenant ID";
                // BillinCalcGrid."VAT %" := RentCalc1."VAT %";
                if RentCalc1."VAT %" = RentCalc1."VAT %"::"5" then
                    vatper := 5
                else
                    vatper := 0;
                BillinCalcGrid."VAT %" := vatper;
                BillinCalcGrid.Insert();
                Clear(BillinCalcGrid);
            until RentCalc1.Next() = 0;

    end;


    procedure BillingCalcridTenancyContractSubpge()
    var
        BillingCalc1: Record "Final Billing Calculation Grid";
        TenancyContractLine2: Record "Tenancy Contract Subpage";
        vatper: Integer;

    begin
        // TenancyContractLine.Reset();
        TenancyContractLine2.SetRange("ContractID", Rec."Contract ID");
        if TenancyContractLine2.FindSet() then
            repeat
                BillingCalc1.Init();
                BillingCalc1."Contract ID" := Rec."Contract ID";
                BillingCalc1."RevenueDescription" := TenancyContractLine2."Secondary Item Type";
                BillingCalc1."Termination Date" := Rec."Termination Date";
                BillingCalc1."Payment Type" := Format(TenancyContractLine2."Payment Type");
                BillingCalc1."Property Classification" := CopyStr(Rec."Unit Type", 1, StrLen(Rec."Unit Type"));
                BillingCalc1."Tenant ID" := Rec."Tenant ID";
                // BillingCalc1."VAT %" := TenancyContractLine2."VAT %";
                if TenancyContractLine2."VAT %" = TenancyContractLine2."VAT %"::"5%" then
                    vatper := 5
                else
                    vatper := 0;
                BillingCalc1."VAT %" := vatper;
                BillingCalc1.Insert();
                Clear(BillingCalc1);
            until TenancyContractLine2.Next() = 0;

    end;

    /////// START POPULATED DATA IN PENDING RECIVEABLE //////////////////////

    procedure ReciveableCalcGridRentCalc()
    var

        RecvieableCalcGrid: Record "Pending Receviable Grid";
        RentCalc2: Record "Rent Calculation";

    begin
        // Clear existing lines in Final Revenue Calculation Grid for this contract
        RecvieableCalcGrid.SetRange("Contract ID", Rec."Contract ID");
        if RecvieableCalcGrid.FindSet() then
            RecvieableCalcGrid.DeleteAll();

        // Step 1: Get main rent amount from Rent Calculation table
        // RentCalc.Reset();
        RentCalc2.SetRange("Contract ID", Rec."Contract ID");
        if RentCalc2.FindSet() then
            repeat
                RecvieableCalcGrid.Init();
                RecvieableCalcGrid."Contract ID" := RentCalc2."Contract ID";
                RecvieableCalcGrid."RevenueDescription" := RentCalc2."Secondary Item Type";
                RecvieableCalcGrid."Termination Date" := Rec."Termination Date";
                RecvieableCalcGrid."Tenant ID" := Rec."Tenant ID";
                RecvieableCalcGrid."Unit Type" := CopyStr(Rec."Unit Type", 1, StrLen(Rec."Unit Type"));
                RecvieableCalcGrid.Insert();
                Clear(RecvieableCalcGrid);
            until RentCalc2.Next() = 0;


    end;


    procedure ReciveableCalcridTenancyContractSubpge()
    var
        RecvieableCalcGrid1: Record "Pending Receviable Grid";
        TenancyContractLine3: Record "Tenancy Contract Subpage";

    begin


        // TenancyContractLine.Reset();
        TenancyContractLine3.SetRange("ContractID", Rec."Contract ID");
        if TenancyContractLine3.FindSet() then
            repeat
                RecvieableCalcGrid1.Init();
                RecvieableCalcGrid1."Contract ID" := Rec."Contract ID";
                RecvieableCalcGrid1."RevenueDescription" := TenancyContractLine3."Secondary Item Type";
                RecvieableCalcGrid1."Termination Date" := Rec."Termination Date";
                RecvieableCalcGrid1."Payment Type" := Format(TenancyContractLine3."Payment Type");
                RecvieableCalcGrid1.Insert();
                Clear(RecvieableCalcGrid1);
            until TenancyContractLine3.Next() = 0;

    end;

    ////////////////// END /////////////////////////


    ///////////// START Payment Details Grid ////////////////////////////

    procedure PaymentDetailsFromPaymentSchedule2()
    var
        paymentschedule2Card: Record "Payment Schedule2";
        lPaymentdetails: Record "Payment Details";
    begin
        lPaymentdetails.SetRange("Contract ID", Rec."Contract ID");
        if lPaymentdetails.FindSet() then
            lPaymentdetails.DeleteAll();

        paymentschedule2Card.SetRange("Contract ID", Rec."Contract ID");
        if paymentschedule2Card.FindSet() then
            repeat
                lPaymentdetails.Init();
                lPaymentdetails."Contract ID" := paymentschedule2Card."Contract ID";
                lPaymentdetails."Item Description" := paymentschedule2Card."Secondary Item Type";
                lPaymentdetails.Amount := paymentschedule2Card.Amount;
                lPaymentdetails."VAT Amount" := paymentschedule2Card."VAT Amount";
                lPaymentdetails."Amount Including VAT" := paymentschedule2Card."Amount Including VAT";
                lPaymentdetails."Payment Status" := paymentschedule2Card."Payment Status";
                lPaymentdetails."Payment Date" := paymentschedule2Card."Due Date";
                lPaymentdetails."Termination Date" := Rec."Termination Date";
                lPaymentdetails.Insert();
                Clear(lPaymentdetails);
            until paymentschedule2Card.Next() = 0;

    end;

    //////////// END //////////////////////////////////////////


    procedure OpenFileInBrowser(URL: Text)
    begin
        // Use the Hyperlink method to open the file in the browser
        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;

    procedure UpdateCanPost()
    begin
        CanPost := (Rec."Amount Refundable" <> 0) or (Rec."Net Receivable From The Tenant" <> 0);
    end;

    procedure FinalSettlementVisible()
    begin
        if (Rec."Amount Refundable" = 0) and (Rec."Net Receivable From The Tenant" = 0) then begin
            IsReceivable := false;
            IsRefundable := false;
        end;
    end;

    var
        IsReceivable: Boolean;
        IsRefundable: Boolean;
        CanPost: Boolean;
}