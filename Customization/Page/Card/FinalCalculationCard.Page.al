page 73209692 "BLRFinalCalculationCard"
{
    PageType = Card;
    SourceTable = "BLRFinalCalculation";
    ApplicationArea = All;
    Caption = 'Final Calculation Card';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group("Contract Details")
            {
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Specifies the unique identifier for the contract.';
                }
                field("FC ID"; Rec."BLRFC ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Specifies the Final Calculation or related reference for the contract.';
                }
                field("Contract Start Date"; Rec."BLRContract Start Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Start Date';
                    ToolTip = 'Enter the Contract Start Date.';
                    Editable = false;
                }
                field("Contract End Date"; Rec."BLRContract End Date")
                {
                    ApplicationArea = All;
                    Caption = 'Contract End Date';
                    ToolTip = 'Enter the Contract End Date.';
                    Editable = false;
                }
                field("Unit Type"; Rec."BLRUnit Type")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Type';
                    ToolTip = 'Enter the Unit Type.';
                    Editable = false;
                }
                field("Contract Amount"; Rec."BLRContract Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Amount';
                    ToolTip = 'Enter the Contract Amount.';
                    Editable = false;
                }
                field("Intimation Date"; Rec."BLRIntimation Date")
                {
                    ApplicationArea = All;
                    Caption = 'Intimation Date';
                    ToolTip = 'Enter the Initmation Date.';
                }
                field("Termination Date"; Rec."BLRTermination Date")
                {
                    ApplicationArea = All;
                    Caption = 'Termination Date';
                    ToolTip = 'Enter the Termination Date.';

                    trigger OnValidate()
                    var
                    begin


                        GetContractTerminationYear();
                        Fetchperdayrent();
                        PopulateRevenueCalculationGrid();
                        GetDataTenancyContract();
                        PopulateRevisedCalculationGrid();

                        BillingCalcGridRentCalc();
                        BillingCalcridTenancyContractSubpge();
                        PopulateBillingCalculationGrid();
                        ReciveableCalcGridRentCalc();
                        ReciveableCalcridTenancyContractSubpge();
                        PopulatePendingReceivableGrid();
                        TotalRefundableAmount();
                        TotalReceivableAmount();
                        GetBillingCharges();
                        RentCalculate();
                        OtherPaymentCalculate();
                        RevenueCalculateOneTime();
                        RevenueCalculate();
                        PaymentDetailsFromPaymentSchedule2();
                        PopulateFinalAdjtCaontractRedGrid();


                        Rec.CalculateFinalSummary(Rec);
                        CurrPage.UPDATE(false);
                        CurrPage."FinalRevenueCalculation".Page.UPDATE();
                        CurrPage."BillingCalculation".Page.UPDATE();
                        CurrPage."Pendingreceivable/Payable".Page.UPDATE();
                        CurrPage."BLRRentCalculation".Page.UPDATE();
                        CurrPage."Other Payment".Page.UPDATE();
                        CurrPage."BLRRevenueStructure".Page.UPDATE();
                        CurrPage.PaymentDetails.Page.UPDATE();

                    end;
                }
                field("ContractYear(Termination Date)"; Rec."BLRContYearTermDate")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Year On Termination Date';
                    ToolTip = 'Enter the ContractYear(Termination Date).';
                    Editable = false;
                }

                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant ID';
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier of the tenant associated with the contract.';
                }
                field("Tenant Email"; Rec."BLRTenant Email")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Email';
                    Editable = false;
                    ToolTip = 'Displays the email address of the tenant.';
                }
                field("Tenant Name"; Rec."BLRTenant Name")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Name';
                    Editable = false;
                    ToolTip = 'Shows the full name of the tenant.';
                }
                field("Original Contract Tenure"; Rec."BLROriginal Contract Tenure")
                {
                    ApplicationArea = All;
                    Caption = 'Original Contract Tenure';
                    ToolTip = 'Enter the Original Contract Tenure.';
                    Editable = false;
                }

                field("Actual Contract Tenure"; Rec."BLRActual Contract Tenure")
                {
                    ApplicationArea = All;
                    Caption = 'Actual Contract Tenure';
                    ToolTip = 'Enter the Actual Contract Tenure.';
                    Editable = false;
                }
                field("Total No. Of Days"; Rec."BLRTotal No. Of Days")
                {
                    ApplicationArea = All;
                    Caption = 'Total No. Of Days(Termination Year)';
                    ToolTip = 'Enter the Total No. Of Days.';
                    Editable = false;
                }
                field("Per Day Rent"; Rec."BLRPer Day Rent")
                {
                    ApplicationArea = All;
                    Caption = 'Per Day Rent(Termination Year)';
                    ToolTip = 'Enter the Per Day Rent.';
                    Editable = false;
                }
                field("Annual Rent Amount TermiYear"; Rec."BLRAnnualRentAmtTermiYear")
                {
                    ApplicationArea = All;
                    Caption = 'Annual Rent Amount of Termination Year';
                    Editable = false;
                    ToolTip = 'Displays the annual rent amount applicable for the year of termination.';
                }
                field("Status"; Rec.BLRStatus)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    Editable = false;
                    ToolTip = 'Indicates the current status of the record.';
                }

                field("Termination Status"; Rec."BLRTermination Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Termination Type';
                    ToolTip = 'Shows the type of termination for the contract.';
                }
                field("Final Calculation Document"; Rec."BLRFinal Calculation Document")
                {
                    ApplicationArea = All;
                    Caption = 'Final Calculation Document';
                    DrillDown = true;
                    Editable = false;
                    ToolTip = 'Click to upload or view the final calculation document related to this record.';

                    trigger OnDrillDown()
                    var
                        azureBlobUploader: Codeunit "BLRAzure AD Blob Storage";
                        fileName: Text;
                        uploadResult: Text;
                        folderName: Text;
                    begin
                        folderName := 'finalcalculationdocument';
                        fileName := azureBlobUploader.ValidateDocument(uploadResult, folderName);
                        if fileName <> '' then begin
                            Rec."BLRFinal Calculation Document" := CopyStr(fileName, 1, StrLen(fileName));
                            Rec."BLRFinal Calculation URL" := CopyStr(uploadResult, 1, StrLen(uploadResult));
                            Rec.Modify();
                            Message('File uploaded successfully: %1', fileName);
                        end;
                    end;
                }

                field("Credit Note Document"; Rec."BLRCredit Note Document")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Note Document';
                    DrillDown = true;
                    Editable = false;
                    ToolTip = 'Click to view the credit note document in your browser.';

                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin
                        // Get the URL of the uploaded document
                        FileURL := Rec."BLRCredit Note URL";

                        // Check if the file URL is not empty
                        if FileURL = '' then
                            Error('No document is available to view.');

                        // Open the file URL in the browser (new tab)
                        OpenFileInBrowser(FileURL);

                    end;
                }

                field("Credit Note URL"; Rec."BLRCredit Note URL")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Stores the URL for the credit note document.';
                }


            }


            part("FinalRevenueCalculation"; "BLRFinalRevenueCalculationGrid")
            {
                SubPageLink = "BLRContract ID" = FIELD("BLRContract ID");
                ApplicationArea = All;
                UpdatePropagation = Both;

            }

            part("BillingCalculation"; "BLRFinalBillingCalculation")
            {
                SubPageLink = "BLRContract ID" = FIELD("BLRContract ID");
                ApplicationArea = All;
                UpdatePropagation = Both;
            }



            part("Pendingreceivable/Payable"; "BLRPendingRecevieableGrid")
            {
                SubPageLink = "BLRContract ID" = FIELD("BLRContract ID");
                ApplicationArea = All;
                UpdatePropagation = Both;
            }

            group("Termination Additional Charges")
            {
                part("Additional Charges"; "BLRAdditional Charges Sub Card")
                {
                    SubPageLink = "BLRContract ID" = FIELD("BLRContract ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    UpdatePropagation = Both;
                    // Visible = isVisible;
                }
            }
            group("Carry Forward the Security Deposit From")
            {
                field("ContractID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the contract.';
                    // trigger OnValidate()
                    // begin
                    //     FetchSecurityDepositInfo();
                    // end;
                }
                field("BLRSecurityDeposit"; Rec."BLRSecurity Deposit")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Shows the amount of the carried forward security deposit.';
                }

            }
            part("Carry Forward"; "BLRCarryForwardGrid")
            {
                SubPageLink = "BLRContract ID" = FIELD("BLRContract ID"); // Link to filter attachments for this owner only
                ApplicationArea = All;
                Caption = 'Carry Forward the Security Deposit To';
                UpdatePropagation = Both;
                Editable = false;
            }
            group("Refundable Deposits")
            {
                field("NetBalance"; Rec."BLRSecurity Deposit")
                {
                    ApplicationArea = All;
                    Caption = 'Security Deposit';
                    Editable = false;
                    ToolTip = 'Displays the refundable security deposit amount.';
                }
                field("Chiller Deposit"; Rec."BLRChiller Deposit")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Shows the refundable chiller deposit amount.';
                }
                field("Other Deposit"; Rec."BLROther Deposit")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays other refundable deposits.';
                }
                field("Total Net Balance"; Rec."BLRTotal Refundable Deposit")
                {
                    ApplicationArea = All;
                    Caption = 'Total Refundable Deposit';
                    Editable = false;
                    ToolTip = 'Shows the total amount of refundable deposits.';
                }
            }
            part("Final Adjustment / Contract Reductions"; "BLRFinalAdjuContractReduction")
            {
                SubPageLink = "BLRContract No." = FIELD("BLRContract ID");
                ApplicationArea = All;
                UpdatePropagation = Both;
            }
            field("Credit Not To Be Raised"; Rec."BLRCredit Not To Be Raised")
            {
                ApplicationArea = All;
                Caption = 'Credit Not To Be Raised';
                Editable = false;
                ToolTip = 'Displays the total amount of credit notes';
            }
            part("BLRInvoiceCreditNoteSummary"; "BLRInvoiceCreditNoteSummary")
            {
                SubPageLink = "BLRContract No." = FIELD("BLRContract ID");
                ApplicationArea = All;
                Caption = 'Invoice / Credit Note Summary';
                UpdatePropagation = Both;
            }


            group("Summary")
            {
                field("Total Claim"; Rec."BLRTotal Claim")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays the total claim amount.';
                }
                field("Total Adjustment"; Rec."BLRTotal Adjustment")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Shows the total adjustment amount.';
                }
                field("Total Refund"; Rec."BLRTotal Refund")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays the total refund amount to the tenant.';
                }
                field("Summery Net Balance"; Rec."BLRSummery Net Balance")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays the final net balance summary.';
                }
                field("Amount Refundable"; Rec."BLRAmount Refundable")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Shows the amount refundable to the tenant.';
                    trigger OnValidate()
                    begin
                        if Rec."BLRAmount Refundable" <> 0 then
                            IsRefundable := true
                        else
                            IsReceivable := true;
                        UpdateCanPost();
                    end;
                }
                field("Net Receivable From The Tenant"; Rec."BLRNetRecvFromTheTenant")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays the amount receivable from the tenant.';

                    trigger OnValidate()
                    begin
                        if Rec."BLRNetRecvFromTheTenant" <> 0 then
                            IsReceivable := true
                        else
                            IsRefundable := true;
                        UpdateCanPost();
                    end;
                }
                field("Remaining Security Deposit"; Rec."BLRRemaining Security Deposit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the remaining security deposit after adjustments.';
                    Visible = false;
                }
                field("Remaining Chiller Deposit"; Rec."BLRRemaining Chiller Deposit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the remaining chiller deposit after adjustments.';
                    Visible = false;
                }
                field("Remaining Other Deposit"; Rec."BLRRemaining Other Deposit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows the remaining other deposit after adjustments.';
                    Visible = false;
                }
            }
            part("BLRAdjustmentDeposits"; "BLRAdjustmentDeposits")
            {
                SubPageLink = "BLRContract ID" = FIELD("BLRContract ID");
                ApplicationArea = All;
                UpdatePropagation = Both;
            }
            group("FinalSettlemt")
            {
                Caption = 'Final Settlement';
                Visible = IsReceivable;
                part("FinalSettelemts"; "BLRFinalSettlemtCard")
                {
                    SubPageLink = "BLRFC ID" = FIELD("BLRFC ID");
                    //  "Tenant ID" = FIELD("BLRTenant ID");
                    ApplicationArea = All;
                    UpdatePropagation = Both;
                    // Visible = isVisible;
                }
            }

            group("FinalSettlemts")
            {
                Caption = 'Final Settlement';
                Visible = IsRefundable;
                part("FinalSettelemtss"; "BLRFinalSettlemtRefundCard")
                {
                    SubPageLink = "BLRFC ID" = FIELD("BLRFC ID");
                    // "Tenant ID" = FIELD("BLRTenant ID");
                    ApplicationArea = All;
                    UpdatePropagation = Both;
                    // Visible = isVisible;
                }
            }
            group("Rent-Calculation")
            {
                part("BLRRentCalculation"; "BLRRent Calculate Sub Card")
                {
                    SubPageLink = "BLRContract ID" = FIELD("BLRContract ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    UpdatePropagation = Both;
                    // Visible = isVisible;
                }
            }
            group("Revenue-structure")
            {
                part("Other Payment"; "BLROtherPaymentCalSubCard")
                {
                    SubPageLink = "BLRContract ID" = FIELD("BLRContract ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    UpdatePropagation = Both;
                    // Visible = isVisible;
                }
            }
            group("Revenue structure - Yearly break-down")
            {
                part("BLRRevenueStructure"; "BLRRevenue Calculate Sub Card")
                {
                    SubPageLink = "BLRContract ID" = FIELD("BLRContract ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    UpdatePropagation = Both;
                    // Visible = isVisible;
                }
            }

            // part("PaymentSchedule"; "Payment Schedule Card2")
            // {
            //     SubPageLink = "BLRContract ID" = FIELD("BLRContract ID"),
            //   "Tenant ID" = FIELD("BLRTenant ID");
            //     ApplicationArea = All;
            // }
            part(PaymentDetails; "BLRPaymentDetails")
            {
                SubPageLink = "BLRContract ID" = FIELD("BLRContract ID");
                ApplicationArea = All;
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(FinalCalculation)
            {
                ApplicationArea = All;
                Caption = 'Approval Final Calculation';
                Image = PostDocument;
                Enabled = CanPost;
                ToolTip = 'Perform the final calculation for this record before posting.';

                trigger OnAction()
                var
                    ApprovalFinalCalculation: Record "BLRApprovalFinalCalculation";
                    FinalCalculation: Record "BLRFinalCalculation";
                    FinalCalculationid: Integer;
                begin
                    // Validate required fields
                    if Rec."BLRContract ID" = 0 then
                        Error('Contract ID must be specified');

                    ApprovalFinalCalculation.SetRange("BLRContract ID", Rec."BLRContract ID");
                    ApprovalFinalCalculation.SetRange("BLRTenant ID", Rec."BLRTenant ID");
                    ApprovalFinalCalculation.SetRange("BLRFC ID", Rec."BLRFC ID");

                    if ApprovalFinalCalculation.FindSet() then begin
                        ApprovalFinalCalculation."BLRFC ID" := Rec."BLRFC ID";
                        ApprovalFinalCalculation."BLRContract ID" := Rec."BLRContract ID";
                        ApprovalFinalCalculation."BLRTenant ID" := Rec."BLRTenant ID";
                        ApprovalFinalCalculation."BLRStatus" := Rec."BLRStatus";
                        ApprovalFinalCalculation."BLRContract Start Date" := Rec."BLRContract Start Date";
                        ApprovalFinalCalculation."BLRContract End Date" := Rec."BLRContract End Date";
                        ApprovalFinalCalculation."BLRTermination Date" := Rec."BLRTermination Date";
                        ApprovalFinalCalculation."BLRContract Amount" := Rec."BLRContract Amount";
                        ApprovalFinalCalculation."BLRLink" := Rec."BLRFC ID";
                        ApprovalFinalCalculation.Modify();
                        Message('Approval Request Modify successfully!');
                    end else begin

                        // Create new entry
                        ApprovalFinalCalculation.Init();
                        ApprovalFinalCalculation."BLRFC ID" := Rec."BLRFC ID";
                        ApprovalFinalCalculation."BLRContract ID" := Rec."BLRContract ID";
                        ApprovalFinalCalculation."BLRTenant ID" := Rec."BLRTenant ID";
                        ApprovalFinalCalculation."BLRStatus" := Rec."BLRStatus";
                        ApprovalFinalCalculation."BLRContract Start Date" := Rec."BLRContract Start Date";
                        ApprovalFinalCalculation."BLRContract End Date" := Rec."BLRContract End Date";
                        ApprovalFinalCalculation."BLRTermination Date" := Rec."BLRTermination Date";
                        ApprovalFinalCalculation."BLRContract Amount" := Rec."BLRContract Amount";
                        ApprovalFinalCalculation."BLRLink" := Rec."BLRFC ID";
                        ApprovalFinalCalculation.Insert(true);

                        Message('Approval Request Send successfully!');
                    end;
                end;
            }
            action(RefreshData)
            {
                ApplicationArea = All;
                Caption = 'Refresh';
                Image = PostDocument;
                Enabled = CanPost;
                ToolTip = 'Refresh Final Calculation Data';

                trigger OnAction()
                var
                    FinalCalculation: Record "BLRFinalCalculation";
                    TerminateDate: Date;
                    DaysCal: Integer;
                    StartDate: Date;
                begin
                    FinalCalculation.SetRange("BLRFC ID", Rec."BLRFC ID");
                    FinalCalculation.SetRange("BLRContract ID", Rec."BLRContract ID");
                    if not FinalCalculation.IsEmpty() then begin

                        StartDate := Rec."BLRContract Start Date";
                        TerminateDate := Rec."BLRTermination Date";
                        DaysCal := TerminateDate - StartDate + 1;
                        Rec."BLRActual Contract Tenure" := DaysCal;
                        Rec.Modify();

                    end;
                    // CurrPage.Update();

                    GetContractTerminationYear();
                    Fetchperdayrent();
                    PopulateRevenueCalculationGrid();
                    GetDataTenancyContract();
                    PopulateRevisedCalculationGrid();

                    BillingCalcGridRentCalc();
                    BillingCalcridTenancyContractSubpge();
                    PopulateBillingCalculationGrid();
                    ReciveableCalcGridRentCalc();
                    ReciveableCalcridTenancyContractSubpge();
                    PopulatePendingReceivableGrid();
                    TotalRefundableAmount();
                    TotalReceivableAmount();
                    GetBillingCharges();
                    RentCalculate();
                    OtherPaymentCalculate();
                    RevenueCalculateOneTime();
                    RevenueCalculate();
                    PaymentDetailsFromPaymentSchedule2();
                    PopulateFinalAdjtCaontractRedGrid();


                    Rec.CalculateFinalSummary(Rec);
                    CurrPage.UPDATE(false);
                    CurrPage."FinalRevenueCalculation".Page.UPDATE();
                    CurrPage."BillingCalculation".Page.UPDATE();
                    CurrPage."Pendingreceivable/Payable".Page.UPDATE();
                    CurrPage."BLRRentCalculation".Page.UPDATE();
                    CurrPage."Other Payment".Page.UPDATE();
                    CurrPage."BLRRevenueStructure".Page.UPDATE();
                    CurrPage.PaymentDetails.Page.UPDATE();

                end;
            }
        }
        area(Reporting)
        {
            action("Run Report")
            {
                ApplicationArea = All;
                Image = Report;
                ToolTip = 'Execute the selected report to view or analyze the related data.';
                trigger OnAction()
                var
                    Finalcalculation: Record "BLRFinalCalculation";
                    TerminationReport: Report "BLRTermination Template";
                begin
                    Finalcalculation.SetRange("BLRContract ID", Rec."BLRContract ID");  // Set appropriate filters
                    TerminationReport.SetTableView(Finalcalculation);
                    TerminationReport.RunModal();
                end;
            }
        }

        area(Promoted)
        {
            actionref(FinalCalculation_; FinalCalculation)
            { }

            actionref(RefreshData_; RefreshData)
            { }

            actionref(Reporting_; "Run Report")
            { }

        }
    }

    //////////////////  START Final Revenue Calculation Grid ////////////////////
    procedure PopulateRevenueCalculationGrid()
    var
        FinalRevCalcGrid: Record "BLRFinalRevenueCalculationGrid";
        RentCalc: Record "BLRRentCalculation";
    begin
        // Clear existing lines in Final Revenue Calculation Grid for this contract
        FinalRevCalcGrid.SetRange("BLRContract ID", Rec."BLRContract ID");
        if FinalRevCalcGrid.FindSet() then
            FinalRevCalcGrid.DeleteAll();


        // Step 1: Get main rent amount from Rent Calculation table
        // RentCalc.Reset();
        RentCalc.SetRange("BLRContract ID", Rec."BLRContract ID");
        if RentCalc.FindSet() then
            repeat
                FinalRevCalcGrid.Init();
                FinalRevCalcGrid."BLRContract ID" := RentCalc."BLRContract ID";
                FinalRevCalcGrid."BLRRevenue Description" := RentCalc."BLRSecondary Item Type";
                FinalRevCalcGrid."BLROriginal Amount" := RentCalc."BLRAmount";
                FinalRevCalcGrid."BLROriginal VAT" := RentCalc."BLRVAT Amount";
                FinalRevCalcGrid."BLROriginal Amount Incl." := RentCalc."BLRAmount Including VAT";
                FinalRevCalcGrid."BLRActual Contract Tenure" := Rec."BLRActual Contract Tenure";
                // FinalRevCalcGrid."BLRPer Day Rent" := Rec."BLRPer Day Rent";
                FinalRevCalcGrid."BLRContYearTermDate" := Rec."BLRContYearTermDate";
                // FinalRevCalcGrid."BLRAnnualRentAmtTermiYear" := Rec."BLRAnnualRentAmtTermiYear";
                FinalRevCalcGrid."BLRTotal No. Of Days" := Rec."BLRTotal No. Of Days";
                FinalRevCalcGrid.Insert();
                Clear(FinalRevCalcGrid);
            until RentCalc.Next() = 0;
    end;


    procedure GetDataTenancyContract()
    var
        FinalRevCalcGrid1: Record "BLRFinalRevenueCalculationGrid";
        TenancyContractLine1: Record "BLRTenancyContractSubpage";

    begin

        // TenancyContractLine.Reset();
        TenancyContractLine1.SetRange("BLRContractID", Rec."BLRContract ID");
        TenancyContractLine1.SetFilter("BLRAmount Including VAT", '<>%1', 0);
        if TenancyContractLine1.FindSet() then
            repeat
                FinalRevCalcGrid1.Init();
                FinalRevCalcGrid1."BLRContract ID" := Rec."BLRContract ID";
                FinalRevCalcGrid1."BLRRevenue Description" := TenancyContractLine1."BLRSecondary Item Type";
                FinalRevCalcGrid1."BLROriginal Amount" := TenancyContractLine1."BLRAmount";

                // Calculate VAT amount based on percentage
                FinalRevCalcGrid1."BLROriginal VAT" := TenancyContractLine1."BLRVAT Amount";

                FinalRevCalcGrid1."BLROriginal Amount Incl." := TenancyContractLine1."BLRAmount Including VAT";
                FinalRevCalcGrid1."BLRActual Contract Tenure" := Rec."BLRActual Contract Tenure";
                //   FinalRevCalcGrid1."BLRPer Day Rent" := Rec."BLRPer Day Rent";
                FinalRevCalcGrid1."BLRContYearTermDate" := Rec."BLRContYearTermDate";
                //  FinalRevCalcGrid1."BLRAnnualRentAmtTermiYear" := Rec."BLRAnnualRentAmtTermiYear";
                FinalRevCalcGrid1."BLRTotal No. Of Days" := Rec."BLRTotal No. Of Days";
                FinalRevCalcGrid1."BLRPayment Type" := Format(TenancyContractLine1."BLRPayment Type");
                FinalRevCalcGrid1.Insert();
                Clear(FinalRevCalcGrid1);
            until TenancyContractLine1.Next() = 0;
    end;
    /////////////////////////////// Revised Calculation /////////////////

    procedure PopulateRevisedCalculationGrid()
    var
        FinalRevCalcGridRec2: Record "BLRFinalRevenueCalculationGrid";
    begin
        FinalRevCalcGridRec2.SetRange("BLRContract ID", Rec."BLRContract ID");
        if FinalRevCalcGridRec2.FindSet() then
            repeat
                GetAnnualRentAmountOfTerminationDateFromRentCalculation(FinalRevCalcGridRec2);
                GetAnnualAmountFromRevenueStructure(FinalRevCalcGridRec2);
                OneTimePaymentTypeRevisedRecalculatedAmount(FinalRevCalcGridRec2);
                GetRentAmountFromRentCalculation(FinalRevCalcGridRec2);
                GetRevisedAmountcalculatrefromRevenueStructuresubpage(FinalRevCalcGridRec2);
                DifferenceAmountCalculation(FinalRevCalcGridRec2);

            until FinalRevCalcGridRec2.Next() = 0;
    end;

    procedure GetAnnualRentAmountOfTerminationDateFromRentCalculation(var FinalRevenueCalculationGridRec: Record "BLRFinalRevenueCalculationGrid")
    var
        RentCalculation2: Record "BLRRentCalculationSubpage";
    // FinalRevenueCalculationGridRec: Record "BLRFinalRevenueCalculationGrid";
    begin
        RentCalculation2.SetRange("BLRContract ID", FinalRevenueCalculationGridRec."BLRContract ID");
        RentCalculation2.SetRange("BLRYear", FinalRevenueCalculationGridRec."BLRContYearTermDate");
        RentCalculation2.SetRange("BLRSecondary Item Type", FinalRevenueCalculationGridRec."BLRRevenue Description");
        if RentCalculation2.FindSet() then
            FinalRevenueCalculationGridRec."BLRAnnualRentAmtTermiYear" := 0;
        FinalRevenueCalculationGridRec."BLRPer Day Rent" := 0;
        repeat
            FinalRevenueCalculationGridRec."BLRAnnualRentAmtTermiYear" += RentCalculation2."BLRFinal Annual Amount";
            FinalRevenueCalculationGridRec."BLRPer Day Rent" += RentCalculation2."BLRPer Day Rent";
            FinalRevenueCalculationGridRec.Modify();
        until RentCalculation2.Next() = 0;
    end;

    procedure GetAnnualAmountFromRevenueStructure(var FinalRevenueCalculationGridRec1: Record "BLRFinalRevenueCalculationGrid")
    var
        RevenueStructureSubpage: Record "BLRRevenueStructureSubpage";

    begin
        RevenueStructureSubpage.SetRange("BLRContract ID", FinalRevenueCalculationGridRec1."BLRContract ID");
        RevenueStructureSubpage.SetRange("BLRYear", FinalRevenueCalculationGridRec1."BLRContYearTermDate");
        RevenueStructureSubpage.SetRange("BLRSecondary Item Type", FinalRevenueCalculationGridRec1."BLRRevenue Description");

        if RevenueStructureSubpage.FindSet() then
            repeat

                FinalRevenueCalculationGridRec1."BLRAnnualRentAmtTermiYear" := RevenueStructureSubpage."BLRFinal Annual Amount";
                FinalRevenueCalculationGridRec1."BLRPer Day Rent" := RevenueStructureSubpage."BLRFinal Annual Amount" / RevenueStructureSubpage."BLRNumber of Days";
                FinalRevenueCalculationGridRec1.Modify();
            until RevenueStructureSubpage.Next() = 0;

    end;

    procedure OneTimePaymentTypeRevisedRecalculatedAmount(var FinalRevenueCalculationGridRec2: Record "BLRFinalRevenueCalculationGrid")
    var
        TenancyContractsubpage: Record "BLRTenancyContractSubpage";
    begin
        TenancyContractsubpage.SetRange("BLRContractID", FinalRevenueCalculationGridRec2."BLRContract ID");
        TenancyContractsubpage.SetRange("BLRPayment Type", 1);
        TenancyContractsubpage.SetRange("BLRSecondary Item Type", FinalRevenueCalculationGridRec2."BLRRevenue Description");
        if TenancyContractsubpage.FindSet() then
            repeat
                FinalRevenueCalculationGridRec2."BLRRevised Amount" := TenancyContractsubpage."BLRAmount";
                FinalRevenueCalculationGridRec2."BLRRevised VAT %" := TenancyContractsubpage."BLRVAT %";
                if FinalRevenueCalculationGridRec2."BLRRevised VAT %" = 1 then
                    FinalRevenueCalculationGridRec2."BLRRevised VAT %" := 5
                else
                    FinalRevenueCalculationGridRec2."BLRRevised VAT %" := 0;
                FinalRevenueCalculationGridRec2."BLRRevised VAT" := TenancyContractsubpage."BLRVAT Amount";
                FinalRevenueCalculationGridRec2."BLRRevised Amount Incl." := TenancyContractsubpage."BLRAmount Including VAT";
                FinalRevenueCalculationGridRec2.Modify();
            //  Clear(FinalRevenueCalculation);
            until TenancyContractsubpage.Next() = 0;

    end;


    procedure GetRentAmountFromRentCalculation(var FinalRevenueCalculationGridRec3: Record "BLRFinalRevenueCalculationGrid")
    var
        RentCalculation1: Record "BLRRentCalculationSubpage";
        RentCalculation: Record "BLRRentCalculationSubpage";
        Totalamount: Decimal;
        TotalVATAmount: Decimal;
        calculateteminationamount: Decimal;
        FinalReviseAmount: Decimal;

    begin
        Totalamount := 0;
        RentCalculation.Reset();
        RentCalculation.SetRange("BLRContract ID", FinalRevenueCalculationGridRec3."BLRContract ID");
        RentCalculation.SetFilter(BLRYear, '1..%1', FinalRevenueCalculationGridRec3."BLRContYearTermDate");

        if RentCalculation.FindSet() then
            repeat
                // Sum up Final Annual Amount values
                TotalAmount += RentCalculation."BLRFinal Annual Amount";
                TotalVATAmount += RentCalculation."BLRVAT Amount"
            until RentCalculation.Next() = 0;

        RentCalculation1.SetRange("BLRContract ID", FinalRevenueCalculationGridRec3."BLRContract ID");
        RentCalculation1.SetRange("BLRSecondary Item Type", FinalRevenueCalculationGridRec3."BLRRevenue Description");
        if RentCalculation1.FindSet() then
            repeat
                FinalReviseAmount := Totalamount - FinalRevenueCalculationGridRec3."BLRAnnualRentAmtTermiYear";
                calculateteminationamount := FinalRevenueCalculationGridRec3."BLRPer Day Rent" * FinalRevenueCalculationGridRec3."BLRTotal No. Of Days"; // 3rd year 365 days - termination 71 days = 294 so calculate 294 * per day rent 122.67 = FinalReviseAmount variable 
                FinalRevenueCalculationGridRec3."BLRRevised Amount" := FinalReviseAmount + calculateteminationamount;
                FinalRevenueCalculationGridRec3."BLRRevised VAT %" := RentCalculation1."BLRVAT %";

                if FinalRevenueCalculationGridRec3."BLRRevised VAT %" = 1 then
                    FinalRevenueCalculationGridRec3."BLRRevised VAT %" := 5
                else
                    FinalRevenueCalculationGridRec3."BLRRevised VAT %" := 0;
                // TotalVATAmount := FinalRevenueCalculationGridRec3."BLRRevised Amount" - (FinalRevenueCalculationGridRec3."BLRRevised Amount" / (1 + (FinalRevenueCalculationGridRec3."BLRRevised VAT %" / 100)));
                // TotalVATAmount := Round(TotalVATAmount, 0.01);
                TotalVATAmount := (FinalRevenueCalculationGridRec3."BLRRevised Amount" * FinalRevenueCalculationGridRec3."BLRRevised VAT %") / 100;

                FinalRevenueCalculationGridRec3."BLRRevised VAT" := TotalVATAmount;
                FinalRevenueCalculationGridRec3."BLRRevised Amount Incl." := FinalRevenueCalculationGridRec3."BLRRevised Amount" + FinalRevenueCalculationGridRec3."BLRRevised VAT";
                FinalRevenueCalculationGridRec3.Modify();
            until RentCalculation1.Next() = 0;
    end;

    procedure GetRevisedAmountcalculatrefromRevenueStructuresubpage(var FinalRevenueCalculationGridRec4: Record "BLRFinalRevenueCalculationGrid")
    var
        RevenueStructureSubpage1: Record "BLRRevenueStructureSubpage";
        RevenueStructureSubpage2: Record "BLRRevenueStructureSubpage";
        ChargesItemTotalamount: Decimal;
        ChargesItemTotalVATAmount: Decimal;
        calculateteminationamount1: Decimal;
        FinalReviseAmount: Decimal;


    begin
        ChargesItemTotalamount := 0;
        RevenueStructureSubpage1.Reset();
        RevenueStructureSubpage1.SetRange("BLRContract ID", FinalRevenueCalculationGridRec4."BLRContract ID");
        RevenueStructureSubpage1.SetRange("BLRSecondary Item Type", FinalRevenueCalculationGridRec4."BLRRevenue Description");
        RevenueStructureSubpage1.SetFilter(BLRYear, '1..%1', FinalRevenueCalculationGridRec4."BLRContYearTermDate");


        if RevenueStructureSubpage1.FindSet() then
            repeat
                // Sum up Final Annual Amount values
                ChargesItemTotalamount += RevenueStructureSubpage1."BLRFinal Annual Amount";
                ChargesItemTotalVATAmount += RevenueStructureSubpage1."BLRVAT Amount"
            until RevenueStructureSubpage1.Next() = 0;

        RevenueStructureSubpage2.SetRange("BLRContract ID", FinalRevenueCalculationGridRec4."BLRContract ID");
        RevenueStructureSubpage2.SetRange("BLRSecondary Item Type", FinalRevenueCalculationGridRec4."BLRRevenue Description");
        if RevenueStructureSubpage2.FindSet() then
            repeat
                FinalReviseAmount := ChargesItemTotalamount - FinalRevenueCalculationGridRec4."BLRAnnualRentAmtTermiYear";
                calculateteminationamount1 := FinalRevenueCalculationGridRec4."BLRPer Day Rent" * FinalRevenueCalculationGridRec4."BLRTotal No. Of Days"; // 3rd year 365 days - termination 71 days = 294 so calculate 294 * per day rent 122.67 = FinalReviseAmount variable 
                FinalRevenueCalculationGridRec4."BLRRevised Amount" := FinalReviseAmount + calculateteminationamount1;
                FinalRevenueCalculationGridRec4."BLRRevised VAT %" := RevenueStructureSubpage2."BLRVAT %";
                if FinalRevenueCalculationGridRec4."BLRRevised VAT %" = 1 then
                    FinalRevenueCalculationGridRec4."BLRRevised VAT %" := 5
                else
                    FinalRevenueCalculationGridRec4."BLRRevised VAT %" := 0;

                // ChargesItemTotalVATAmount := FinalRevenueCalculationGridRec4."BLRRevised Amount" - (FinalRevenueCalculationGridRec4."BLRRevised Amount" / (1 + (FinalRevenueCalculationGridRec4."BLRRevised VAT %" / 100)));
                // ChargesItemTotalVATAmount := Round(ChargesItemTotalVATAmount, 0.01);
                ChargesItemTotalVATAmount := (FinalRevenueCalculationGridRec4."BLRRevised Amount" * FinalRevenueCalculationGridRec4."BLRRevised VAT %") / 100;

                FinalRevenueCalculationGridRec4."BLRRevised VAT" := ChargesItemTotalVATAmount;
                FinalRevenueCalculationGridRec4."BLRRevised Amount Incl." := FinalRevenueCalculationGridRec4."BLRRevised Amount" + FinalRevenueCalculationGridRec4."BLRRevised VAT";
                FinalRevenueCalculationGridRec4.Modify();

            until RevenueStructureSubpage2.Next() = 0;
    end;

    procedure DifferenceAmountCalculation(var FinalRevenueCalculationGridRec5: Record "BLRFinalRevenueCalculationGrid")
    var

    begin


        FinalRevenueCalculationGridRec5."BLRDifference Amount" := FinalRevenueCalculationGridRec5."BLROriginal Amount" - FinalRevenueCalculationGridRec5."BLRRevised Amount";
        FinalRevenueCalculationGridRec5."BLRDifference VAT" := FinalRevenueCalculationGridRec5."BLROriginal VAT" - FinalRevenueCalculationGridRec5."BLRRevised VAT";
        FinalRevenueCalculationGridRec5."BLRDifference Amount Incl." := FinalRevenueCalculationGridRec5."BLROriginal Amount Incl." - FinalRevenueCalculationGridRec5."BLRRevised Amount Incl.";
        FinalRevenueCalculationGridRec5.Modify();


    end;


    ////////////////////// END REVISED CALCULATION ////////////////////////














    procedure GetContractTerminationYear()
    var
        RentCalculationSub: Record "BLRRentCalculationSubpage";
        UserYear: Integer;
        Terminationdate: Date;
    begin
        UserYear := 0;
        Terminationdate := Rec."BLRTermination Date";
        RentCalculationSub.SetRange("BLRContract ID", Rec."BLRContract ID");
        if RentCalculationSub.FindSet() then
            repeat
                if (Terminationdate >= RentCalculationSub."BLRPeriod Start Date") and (Terminationdate <= RentCalculationSub."BLRPeriod End Date") then
                    UserYear := RentCalculationSub."BLRYear";
            until (RentCalculationSub.Next() = 0) or (UserYear <> 0);

        Rec."BLRContYearTermDate" := UserYear;
        Rec.Modify();
    end;

    procedure Fetchperdayrent()
    var
        RentCalculation1: Record "BLRRentCalculationSubpage";
        DifferenceDays: Integer;
    begin
        RentCalculation1.SetRange("BLRContract ID", Rec."BLRContract ID");
        RentCalculation1.SetRange("BLRYear", Rec."BLRContYearTermDate");

        if RentCalculation1.FindSet() then
            Rec."BLRPer Day Rent" := 0;
        Rec."BLRAnnualRentAmtTermiYear" := 0;
        repeat
            Rec."BLRPer Day Rent" += RentCalculation1."BLRPer Day Rent";
            DifferenceDays := Rec."BLRTermination Date" - RentCalculation1."BLRPeriod Start Date";
            Rec."BLRTotal No. Of Days" := DifferenceDays + 1;
            Rec."BLRAnnualRentAmtTermiYear" += RentCalculation1."BLRFinal Annual Amount";
            Rec.Modify();
        until RentCalculation1.Next() = 0;
    end;

    procedure RentCalculate()
    var
        RentCalculationSub: Record "BLRRentCalculationSubpage";
        RentCalculates: Record "BLRRentCalculateSub";
    begin


        RentCalculates.SetRange("BLRContract ID", Rec."BLRContract ID");
        if RentCalculates.FindSet() then
            RentCalculates.DeleteAll();

        // TenancyContractLine.Reset();
        RentCalculationSub.SetRange("BLRContract ID", Rec."BLRContract ID");
        RentCalculationSub.SetRange("BLRTenant ID", Rec."BLRTenant ID");
        if RentCalculationSub.FindSet() then
            repeat
                RentCalculates.Init();
                RentCalculates."BLRContract ID" := Rec."BLRContract ID";
                RentCalculates."BLRTenant ID" := Rec."BLRTenant ID";
                // Calculate VAT amount based on percentage
                RentCalculates."BLRYear" := RentCalculationSub."BLRYear";
                RentCalculates."BLRPeriod Start Date" := RentCalculationSub."BLRPeriod Start Date";
                RentCalculates."BLRPeriod End Date" := RentCalculationSub."BLRPeriod End Date";
                RentCalculates."BLRNumber Of Days" := RentCalculationSub."BLRNumber Of Days";
                RentCalculates."BLRFinal Annual Amount" := RentCalculationSub."BLRFinal Annual Amount";
                RentCalculates."BLRPer Day Rent" := RentCalculationSub."BLRPer Day Rent";
                RentCalculates.Insert();
                Clear(RentCalculates);
            until RentCalculationSub.Next() = 0;
    end;

    procedure OtherPaymentCalculate()
    var
        TenancyContractSub: Record "BLRTenancyContractSubpage";
        OtherPaymentCalculateSub: Record "BLROtherPaymentCalculateSub";

    begin
        OtherPaymentCalculateSub.SetRange("BLRContract ID", Rec."BLRContract ID");
        if OtherPaymentCalculateSub.FindSet() then
            OtherPaymentCalculateSub.DeleteAll();


        TenancyContractSub.SetRange("BLRContractID", Rec."BLRContract ID");
        if TenancyContractSub.FindSet() then
            repeat
                OtherPaymentCalculateSub.Init();
                OtherPaymentCalculateSub."BLRContract ID" := Rec."BLRContract ID";
                OtherPaymentCalculateSub."BLRTenant ID" := Rec."BLRTenant ID";
                OtherPaymentCalculateSub."BLRSecondary Item Type" := TenancyContractSub."BLRSecondary Item Type";
                OtherPaymentCalculateSub."BLRAmount" := TenancyContractSub."BLRAmount";
                OtherPaymentCalculateSub."BLRVAT Amount" := TenancyContractSub."BLRVAT Amount";
                OtherPaymentCalculateSub."BLRAmount Including VAT" := TenancyContractSub."BLRAmount Including VAT";
                OtherPaymentCalculateSub."BLRStart Date" := TenancyContractSub."BLRStart Date";
                OtherPaymentCalculateSub."BLREnd Date" := TenancyContractSub."BLREnd Date";
                OtherPaymentCalculateSub.Insert();
                Clear(OtherPaymentCalculateSub);
            until TenancyContractSub.Next() = 0;

    end;

    procedure RevenueCalculateOneTime()
    var
        TenancyContractSub: Record "BLRTenancyContractSubpage";
        //PaymentSchedule2: Record "BLRPaymentSchedule2";
        RevenueCalculates: Record "BLRRevenueCalculateSub";

    begin

        RevenueCalculates.SetRange("BLRContract ID", Rec."BLRContract ID");
        if RevenueCalculates.FindSet() then
            RevenueCalculates.DeleteAll();


        TenancyContractSub.SetRange("BLRContractID", Rec."BLRContract ID");
        TenancyContractSub.SetRange("BLRTenantID", Rec."BLRTenant ID");

        TenancyContractSub.SetRange("BLRPayment Type", 1);
        if TenancyContractSub.FindSet() then
            repeat
                RevenueCalculates.Init();
                RevenueCalculates."BLRContract ID" := TenancyContractSub."BLRContractID";
                RevenueCalculates."BLRTenant ID" := TenancyContractSub."BLRTenantId";
                RevenueCalculates."BLRSecondary Item Type" := TenancyContractSub."BLRSecondary Item Type";
                RevenueCalculates."BLRAmount" := TenancyContractSub."BLRAmount";
                RevenueCalculates."BLRVAT Amount" := TenancyContractSub."BLRVAT Amount";
                RevenueCalculates."BLRAmount Including VAT" := RevenueCalculates."BLRAmount" + RevenueCalculates."BLRVAT Amount";
                RevenueCalculates."BLRInstallment Start Date" := TenancyContractSub."BLRStart Date";
                RevenueCalculates."BLRInstallment End Date" := TenancyContractSub."BLREnd Date";
                RevenueCalculates.Insert();
                Clear(RevenueCalculates);
            until TenancyContractSub.Next() = 0;
    end;

    procedure RevenueCalculate()
    var
        RevenueStructureSub: Record "BLRRevenueStructureSubpage";
        RevenueCalculateSub: Record "BLRRevenueCalculateSub";
    begin

        // TenancyContractLine.Reset();
        RevenueStructureSub.SetRange("BLRContract ID", Rec."BLRContract ID");
        RevenueStructureSub.SetRange("BLRTenant ID", Rec."BLRTenant ID");
        if RevenueStructureSub.FindSet() then
            repeat
                RevenueCalculateSub.Init();
                RevenueCalculateSub."BLRContract ID" := Rec."BLRContract ID";
                RevenueCalculateSub."BLRTenant ID" := Rec."BLRTenant ID";
                // Calculate VAT amount based on percentage
                RevenueCalculateSub."BLRSecondary Item Type" := RevenueStructureSub."BLRSecondary Item Type";
                RevenueCalculateSub."BLRAmount" := RevenueStructureSub."BLRFinal Annual Amount";
                RevenueCalculateSub."BLRVAT Amount" := RevenueStructureSub."BLRVAT Amount";
                RevenueCalculateSub."BLRAmount Including VAT" := RevenueCalculateSub."BLRAmount" + RevenueStructureSub."BLRVAT Amount";
                RevenueCalculateSub."BLRInstallment Start Date" := RevenueStructureSub."BLRPeriod Start Date";
                RevenueCalculateSub."BLRInstallment End Date" := RevenueStructureSub."BLRPeriod End Date";
                RevenueCalculateSub.Insert();
                Clear(RevenueCalculateSub);
            until RevenueStructureSub.Next() = 0;

    end;

    //----------------------------------Fetch Security Deposit-------------------------------//
    // procedure FetchSecurityDepositInfo()
    // var
    //     ContractRec: Record "BLRTenancyContract";
    // begin
    //     if Rec."BLRContract ID" <> 0 then begin
    //         ContractRec.Reset();
    //         ContractRec.SetRange("BLRContract ID", Rec."BLRContract ID");

    //         if ContractRec.FindFirst() then begin
    //             // Update the fields without showing messages (this is automatic)
    //             Rec."BLRSecurityDeposit" := ContractRec."BLRSecurity Deposit Amount";
    //             Rec."BLRAdjustmentSecurityDeposit" := ContractRec."BLRSecurity Balanced Amount";
    //             Rec."BLRNet Balance" := ContractRec."BLRSecurity Deposit Amount" - ContractRec."BLRSecurity Balanced Amount";
    //             Rec.Modify(false);  // false means don't trigger validation
    //         end;
    //     end;
    // end;

    //-----------------------------------Fetch total claim---------------------------------//

    // Add this procedure to calculate the total from the Additional Charges grid
    // procedure UpdateTotalClaim()
    // var
    //     AdditionalCharges: Record "BLRAdditionalChargesSub";
    //     TotalAmount: Decimal;
    // begin
    //     AdditionalCharges.Reset();
    //     AdditionalCharges.SetRange("BLRContract ID", Rec."BLRContract ID");

    //     if AdditionalCharges.FindSet() then begin
    //         repeat
    //             TotalAmount += AdditionalCharges."BLRAmount Including VAT";
    //         until AdditionalCharges.Next() = 0;
    //     end;

    //     Rec."BLRTotal Claim" := TotalAmount;
    //     Rec.Modify(false);
    //     CurrPage.Update(false);
    // end;

    // Also add a method that the subpage can call when its data changes
    // procedure UpdateTotalsFromSubpage()
    // begin
    //     UpdateTotalClaim();
    // end;

    trigger OnAfterGetRecord()
    begin
        CurrPage."Additional Charges".Page.SetTenantID(Rec."BLRTenant ID");
        CurrPage."Additional Charges".Page.SetContractID(Rec."BLRContract ID");
        CurrPage."Additional Charges".Page.SetStartEndDate(Rec."BLRContract Start Date", Rec."BLRContract End Date");
        CurrPage."Additional Charges".Page.SetUnitType(Rec."BLRUnit Type");
        CurrPage."FinalSettelemts".Page.SetTenantID(Rec."BLRTenant ID");
        CurrPage."FinalSettelemts".Page.SetContractID(Rec."BLRContract ID");
        CurrPage."FinalSettelemtss".Page.SetTenantID(Rec."BLRTenant ID");
        CurrPage."FinalSettelemtss".Page.SetContractID(Rec."BLRContract ID");
        CurrPage."Carry Forward".Page.SetContractId(Rec."BLRContract ID");
        CurrPage."Final Adjustment / Contract Reductions".Page.SetContractNo(Rec."BLRContract ID");
        CurrPage.BLRInvoiceCreditNoteSummary.Page.SetContractNo(Rec."BLRContract ID");
        // FetchSecurityDepositInfo();
        // UpdateTotalClaim(); // Add this line to calculate the total
        FinalSettlementVisible();
        if Rec."BLRAmount Refundable" <> 0 then
            IsRefundable := true
        else
            IsReceivable := true;

        if Rec."BLRNetRecvFromTheTenant" <> 0 then
            IsReceivable := true
        else
            IsRefundable := true;
        UpdateCanPost();
        CurrPage."Carry Forward".Page.SetContractId(Rec."BLRContract ID");
    end;



    trigger OnModifyRecord(): Boolean
    begin
        CurrPage."Additional Charges".Page.SetTenantID(Rec."BLRTenant ID");
        CurrPage."Additional Charges".Page.SetContractID(Rec."BLRContract ID");
        CurrPage."Additional Charges".Page.SetStartEndDate(Rec."BLRContract Start Date", Rec."BLRContract End Date");
        CurrPage."Additional Charges".Page.SetUnitType(Rec."BLRUnit Type");
        CurrPage."FinalSettelemts".Page.SetTenantID(Rec."BLRTenant ID");
        CurrPage."FinalSettelemts".Page.SetContractID(Rec."BLRContract ID");
        CurrPage."FinalSettelemtss".Page.SetTenantID(Rec."BLRTenant ID");
        CurrPage."FinalSettelemtss".Page.SetContractID(Rec."BLRContract ID");
        CurrPage."Carry Forward".Page.SetContractId(Rec."BLRContract ID");
        CurrPage."Final Adjustment / Contract Reductions".Page.SetContractNo(Rec."BLRContract ID");
        CurrPage.BLRInvoiceCreditNoteSummary.Page.SetContractNo(Rec."BLRContract ID");
        // UpdateTotalClaim(); // Add this line to calculate the total
        FinalSettlementVisible();
        if Rec."BLRAmount Refundable" <> 0 then
            IsRefundable := true
        else
            IsReceivable := true;

        if Rec."BLRNetRecvFromTheTenant" <> 0 then
            IsReceivable := true
        else
            IsRefundable := true;

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage."Additional Charges".Page.SetTenantID(Rec."BLRTenant ID");
        CurrPage."Additional Charges".Page.SetContractID(Rec."BLRContract ID");
        CurrPage."Additional Charges".Page.SetStartEndDate(Rec."BLRContract Start Date", Rec."BLRContract End Date");
        CurrPage."Additional Charges".Page.SetUnitType(Rec."BLRUnit Type");
        CurrPage."FinalSettelemts".Page.SetTenantID(Rec."BLRTenant ID");
        CurrPage."FinalSettelemts".Page.SetContractID(Rec."BLRContract ID");
        CurrPage."FinalSettelemtss".Page.SetTenantID(Rec."BLRTenant ID");
        CurrPage."FinalSettelemtss".Page.SetContractID(Rec."BLRContract ID");
        CurrPage."Carry Forward".Page.SetContractId(Rec."BLRContract ID");
        CurrPage."Final Adjustment / Contract Reductions".Page.SetContractNo(Rec."BLRContract ID");
        CurrPage.BLRInvoiceCreditNoteSummary.Page.SetContractNo(Rec."BLRContract ID");
        FinalSettlementVisible();
        if Rec."BLRAmount Refundable" <> 0 then
            IsRefundable := true
        else
            IsReceivable := true;

        if Rec."BLRNetRecvFromTheTenant" <> 0 then
            IsReceivable := true
        else
            IsRefundable := true;

    end;

    procedure BillingCalcGridRentCalc()
    var

        BillinCalcGrid: Record "BLRFinalBillingCalculationGrid";
        RentCalc1: Record "BLRRentCalculation";
        vatper: Integer;

    begin
        // Clear existing lines in Final Revenue Calculation Grid for this contract
        BillinCalcGrid.SetRange("BLRContract ID", Rec."BLRContract ID");
        if BillinCalcGrid.FindSet() then
            BillinCalcGrid.DeleteAll();


        // Step 1: Get main rent amount from Rent Calculation table
        // RentCalc.Reset();
        RentCalc1.SetRange("BLRContract ID", Rec."BLRContract ID");
        if RentCalc1.FindSet() then
            repeat
                BillinCalcGrid.Init();
                BillinCalcGrid."BLRContract ID" := RentCalc1."BLRContract ID";
                BillinCalcGrid."BLRRevenueDescription" := RentCalc1."BLRSecondary Item Type";
                BillinCalcGrid."BLRTermination Date" := Rec."BLRTermination Date";
                BillinCalcGrid."BLRProperty Classification" := Rec."BLRUnit Type";
                BillinCalcGrid."BLRTenant ID" := Rec."BLRTenant ID";
                // BillinCalcGrid."BLRVAT %" := RentCalc1."BLRVAT %";
                if RentCalc1."BLRVAT %" = RentCalc1."BLRVAT %"::"5" then
                    vatper := 5
                else
                    vatper := 0;
                BillinCalcGrid."BLRVAT %" := vatper;
                BillinCalcGrid.Insert();
                Clear(BillinCalcGrid);
            until RentCalc1.Next() = 0;

    end;


    procedure BillingCalcridTenancyContractSubpge()
    var
        BillingCalc1: Record "BLRFinalBillingCalculationGrid";
        TenancyContractLine2: Record "BLRTenancyContractSubpage";
        vatper: Integer;

    begin
        // TenancyContractLine.Reset();
        TenancyContractLine2.SetRange("BLRContractID", Rec."BLRContract ID");
        TenancyContractLine2.SetFilter("BLRAmount Including VAT", '<>%1', 0);
        if TenancyContractLine2.FindSet() then
            repeat
                BillingCalc1.Init();
                BillingCalc1."BLRContract ID" := Rec."BLRContract ID";
                BillingCalc1."BLRRevenueDescription" := TenancyContractLine2."BLRSecondary Item Type";
                BillingCalc1."BLRTermination Date" := Rec."BLRTermination Date";
                BillingCalc1."BLRPayment Type" := Format(TenancyContractLine2."BLRPayment Type");
                BillingCalc1."BLRProperty Classification" := Rec."BLRUnit Type";
                BillingCalc1."BLRTenant ID" := Rec."BLRTenant ID";
                // BillingCalc1."BLRVAT %" := TenancyContractLine2."BLRVAT %";
                if TenancyContractLine2."BLRVAT %" = TenancyContractLine2."BLRVAT %"::"5%" then
                    vatper := 5
                else
                    vatper := 0;
                BillingCalc1."BLRVAT %" := vatper;
                BillingCalc1.Insert();
                Clear(BillingCalc1);
            until TenancyContractLine2.Next() = 0;
    end;


    ////////////////// END /////////////////////////


    ///////////////////////// Billing Invoiced Calculation //////////////////////


    procedure PopulateBillingCalculationGrid()
    var
        FinalBillingGridRec: Record "BLRFinalBillingCalculationGrid";
    begin
        FinalBillingGridRec.SetRange("BLRContract ID", Rec."BLRContract ID");
        if FinalBillingGridRec.FindSet() then
            repeat
                FetchDataFromRevenueCalcGrid(FinalBillingGridRec);
                Invoiceamountfrompaymentscheule(FinalBillingGridRec);
                DifferenceAmountCalculationBilling(FinalBillingGridRec);
                CreditNoteTotalAmount(FinalBillingGridRec);
                InvoiceTotalAmount(FinalBillingGridRec);
            until FinalBillingGridRec.Next() = 0;
    end;

    procedure FetchDataFromRevenueCalcGrid(var BillingCalcGrid: Record "BLRFinalBillingCalculationGrid")
    var
        RevenueGrid: Record "BLRFinalRevenueCalculationGrid";
    begin
        RevenueGrid.SetRange("BLRContract ID", BillingCalcGrid."BLRContract ID");
        RevenueGrid.SetRange("BLRRevenue Description", BillingCalcGrid."BLRRevenueDescription");
        if RevenueGrid.FindSet() then
            repeat
                BillingCalcGrid.BLRRevisedAmount := RevenueGrid."BLRRevised Amount";
                BillingCalcGrid.BLRRevisedVAT := RevenueGrid."BLRRevised VAT";
                BillingCalcGrid.BLRRevisedAmountInclVAT := RevenueGrid."BLRRevised Amount Incl.";
                BillingCalcGrid.Modify();
            until RevenueGrid.Next() = 0;

    end;


    procedure Invoiceamountfrompaymentscheule(var BillingCalcGrid: Record "BLRFinalBillingCalculationGrid")
    var
        PaymentScheduleRec: Record "BLRPaymentSchedule2";
        Totalamount: Decimal;
        VATAmount: Decimal;
        AmountIncVAT: Decimal;
    begin
        Totalamount := 0;
        PaymentScheduleRec.Reset();
        PaymentScheduleRec.SetRange("BLRContract ID", BillingCalcGrid."BLRContract ID");
        //PaymentScheduleRec.SetFilter("BLRDue Date", '<%1', Rec."BLRTermination Date");
        PaymentScheduleRec.SetFilter("BLRWorkflow frequency date", '<=%1', BillingCalcGrid."BLRTermination Date");
        PaymentScheduleRec.SetRange(BLRInvoiced, true);
        PaymentScheduleRec.SetFilter("BLRInvoice Approval Status", 'Approved');
        PaymentScheduleRec.SetRange("BLRSecondary Item Type", BillingCalcGrid.BLRRevenueDescription);

        if PaymentScheduleRec.FindSet() then
            repeat
                Totalamount += PaymentScheduleRec."BLRAmount";
                VATAmount += PaymentScheduleRec."BLRVAT Amount";
                AmountIncVAT += PaymentScheduleRec."BLRAmount Including VAT";

            until PaymentScheduleRec.Next() = 0;

        PaymentScheduleRec.SetRange("BLRContract ID", BillingCalcGrid."BLRContract ID");
        PaymentScheduleRec.SetRange("BLRSecondary Item Type", BillingCalcGrid.BLRRevenueDescription);

        if PaymentScheduleRec.FindSet() then
            repeat
                BillingCalcGrid.BLRInvoicedAmount := Totalamount;
                BillingCalcGrid.BLRInvoicedVAT := VATAmount;
                BillingCalcGrid.BLRInvoicedAmountInclVAT := AmountIncVAT;
                BillingCalcGrid.Modify();
            until PaymentScheduleRec.Next() = 0;
    end;




    procedure CreditNoteTotalAmount(var BillingCalcGrid: Record "BLRFinalBillingCalculationGrid")
    var
        billingcalculationgird1: Record "BLRFinalBillingCalculationGrid";
        billingcalculationgird2: Record "BLRFinalBillingCalculationGrid";
        InvoiceCreditNoteSummaryRec: Record BLRInvoiceCreditNoteSummary;
        TotalPositiveAmount: Decimal;
    begin
        // Calculate total positive difference for the whole contract
        TotalPositiveAmount := 0;
        billingcalculationgird1.SetRange("BLRContract ID", BillingCalcGrid."BLRContract ID");
        billingcalculationgird1.SetFilter("BLRDifferenceAmountInclVAT", '>%1', 0);
        if billingcalculationgird1.FindSet() then
            repeat
                TotalPositiveAmount += billingcalculationgird1."BLRDifferenceAmountInclVAT";
            until billingcalculationgird1.Next() = 0;

        // Write the same (absolute) total to every grid record for this contract
        billingcalculationgird2.SetRange("BLRContract ID", BillingCalcGrid."BLRContract ID");
        if billingcalculationgird2.FindSet() then
            repeat
                billingcalculationgird2."BLRCredit Note To Be Raised" := Abs(TotalPositiveAmount);
                billingcalculationgird2."BLRCredit Note Amount" := Abs(TotalPositiveAmount);
                billingcalculationgird2.Modify();
            until billingcalculationgird2.Next() = 0;

        InvoiceCreditNoteSummaryRec.SetRange("BLRContract No.", BillingCalcGrid."BLRContract ID");
        InvoiceCreditNoteSummaryRec.SetRange(BLRDescription, 'Final Billing Calculation');
        if InvoiceCreditNoteSummaryRec.FindFirst() then begin
            InvoiceCreditNoteSummaryRec."BLRCredit Note" := Abs(TotalPositiveAmount);
            InvoiceCreditNoteSummaryRec.Modify();
        end;

    end;


    procedure InvoiceTotalAmount(var BillingCalcGrid: Record "BLRFinalBillingCalculationGrid")
    var
        billingcalculationgird1: Record "BLRFinalBillingCalculationGrid";
        billingcalculationgird2: Record "BLRFinalBillingCalculationGrid";
        InvoiceCreditNoteSummaryRec: Record BLRInvoiceCreditNoteSummary;
        TotalNegativeDifference: Decimal;
    begin
        // Calculate total negative difference for the whole contract
        TotalNegativeDifference := 0;
        billingcalculationgird1.SetRange("BLRContract ID", BillingCalcGrid."BLRContract ID");
        billingcalculationgird1.SetFilter("BLRDifferenceAmountInclVAT", '<%1', 0);
        if billingcalculationgird1.FindSet() then
            repeat
                TotalNegativeDifference += billingcalculationgird1."BLRDifferenceAmountInclVAT";
            until billingcalculationgird1.Next() = 0;

        // Write the same (absolute) total to every grid record for this contract
        billingcalculationgird2.SetRange("BLRContract ID", BillingCalcGrid."BLRContract ID");
        if billingcalculationgird2.FindSet() then
            repeat
                // Keep already invoiced lines at zero (existing business rule)
                if billingcalculationgird2."BLRInvoiced" then
                    billingcalculationgird2."BLRInvoice To Be Raised" := 0
                else
                    billingcalculationgird2."BLRInvoice To Be Raised" := Abs(TotalNegativeDifference);
                billingcalculationgird2."BLRInvoice Amount" := Abs(TotalNegativeDifference);
                billingcalculationgird2.Modify();
            until billingcalculationgird2.Next() = 0;


        // InvoiceCreditNoteSummaryRec.SetRange("BLRContract No.", BillingCalcGrid."BLRContract ID");
        // InvoiceCreditNoteSummaryRec.SetRange(Description, 'Final Billing Calculation');
        // if InvoiceCreditNoteSummaryRec.FindFirst() then begin
        //     InvoiceCreditNoteSummaryRec.Invoice := Abs(TotalNegativeDifference);
        //     InvoiceCreditNoteSummaryRec.Modify();
        // end;
    end;

    procedure DifferenceAmountCalculationBilling(var BillingCalcGrid: Record "BLRFinalBillingCalculationGrid")
    begin

        BillingCalcGrid."BLRDifferenceAmount" := BillingCalcGrid."BLRInvoicedAmount" - BillingCalcGrid."BLRRevisedAmount";
        BillingCalcGrid."BLRDifferenceVAT" := BillingCalcGrid."BLRInvoicedVAT" - BillingCalcGrid."BLRRevisedVAT";
        BillingCalcGrid."BLRDifferenceAmountInclVAT" := BillingCalcGrid."BLRInvoicedAmountInclVAT" - BillingCalcGrid."BLRRevisedAmountInclVAT";
        BillingCalcGrid.Modify();
    end;



    ////////////////////// End Billing Invoiced Calculation //////////////////////


    /////// START POPULATED DATA IN PENDING RECIVEABLE //////////////////////

    procedure ReciveableCalcGridRentCalc()
    var

        RecvieableCalcGrid: Record "BLRPendingReceviableGrid";
        RentCalc2: Record "BLRRentCalculation";

    begin
        // Clear existing lines in Final Revenue Calculation Grid for this contract
        RecvieableCalcGrid.SetRange("BLRContract ID", Rec."BLRContract ID");
        if RecvieableCalcGrid.FindSet() then
            RecvieableCalcGrid.DeleteAll();


        // Step 1: Get main rent amount from Rent Calculation table
        // RentCalc.Reset();
        RentCalc2.SetRange("BLRContract ID", Rec."BLRContract ID");
        if RentCalc2.FindSet() then
            repeat
                RecvieableCalcGrid.Init();
                RecvieableCalcGrid."BLRContract ID" := RentCalc2."BLRContract ID";
                RecvieableCalcGrid."BLRRevenueDescription" := RentCalc2."BLRSecondary Item Type";
                RecvieableCalcGrid."BLRTermination Date" := Rec."BLRTermination Date";
                RecvieableCalcGrid."BLRTenant ID" := Rec."BLRTenant ID";
                RecvieableCalcGrid."BLRUnit Type" := Rec."BLRUnit Type";
                RecvieableCalcGrid.Insert();
                Clear(RecvieableCalcGrid);
            until RentCalc2.Next() = 0;
    end;


    procedure ReciveableCalcridTenancyContractSubpge()
    var
        RecvieableCalcGrid1: Record "BLRPendingReceviableGrid";
        TenancyContractLine3: Record "BLRTenancyContractSubpage";

    begin
        // TenancyContractLine.Reset();
        TenancyContractLine3.SetRange("BLRContractID", Rec."BLRContract ID");
        TenancyContractLine3.SetFilter("BLRAmount Including VAT", '<>%1', 0);
        if TenancyContractLine3.FindSet() then
            repeat
                RecvieableCalcGrid1.Init();
                RecvieableCalcGrid1."BLRContract ID" := Rec."BLRContract ID";
                RecvieableCalcGrid1."BLRRevenueDescription" := TenancyContractLine3."BLRSecondary Item Type";
                RecvieableCalcGrid1."BLRTermination Date" := Rec."BLRTermination Date";
                RecvieableCalcGrid1."BLRPayment Type" := Format(TenancyContractLine3."BLRPayment Type");
                RecvieableCalcGrid1.Insert();
                Clear(RecvieableCalcGrid1);
            until TenancyContractLine3.Next() = 0;
    end;

    ////////////////// END /////////////////////////


    ///////////// START Payment Details Grid ////////////////////////////

    procedure PaymentDetailsFromPaymentSchedule2()
    var
        paymentschedule2Card: Record "BLRPaymentSchedule2";
        paymentdetail: Record "BLRPaymentDetails";
    begin
        paymentdetail.SetRange("BLRContract ID", Rec."BLRContract ID");
        if paymentdetail.FindSet() then
            paymentdetail.DeleteAll();


        paymentschedule2Card.SetRange("BLRContract ID", Rec."BLRContract ID");
        if paymentschedule2Card.FindSet() then
            repeat
                paymentdetail.Init();
                paymentdetail."BLRContract ID" := paymentschedule2Card."BLRContract ID";
                paymentdetail."BLRItem Description" := paymentschedule2Card."BLRSecondary Item Type";
                paymentdetail."BLRAmount" := paymentschedule2Card."BLRAmount";
                paymentdetail."BLRVAT Amount" := paymentschedule2Card."BLRVAT Amount";
                paymentdetail."BLRAmount Including VAT" := paymentschedule2Card."BLRAmount Including VAT";
                paymentdetail."BLRPayment Status" := paymentschedule2Card."BLRPayment Status";
                paymentdetail."BLRPayment Date" := paymentschedule2Card."BLRDue Date";
                paymentdetail."BLRTermination Date" := Rec."BLRTermination Date";
                paymentdetail.Insert();
                Clear(paymentdetail);
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
        CanPost := (Rec."BLRAmount Refundable" <> 0) or (Rec."BLRNetRecvFromTheTenant" <> 0);
    end;

    procedure FinalSettlementVisible()
    begin
        if (Rec."BLRAmount Refundable" = 0) and (Rec."BLRNetRecvFromTheTenant" = 0) then begin
            IsReceivable := false;
            IsRefundable := false;
        end;
    end;

    //////////////////////// START PENDING RECIVEABLE CALCULATION //////////////////////

    procedure PopulatePendingReceivableGrid()
    var
        PendingReceivableGrid: Record "BLRPendingReceviableGrid";
    begin
        PendingReceivableGrid.SetRange("BLRContract ID", Rec."BLRContract ID");
        if PendingReceivableGrid.FindSet() then
            repeat
                FetchDataFromRevenueCalcGrid(PendingReceivableGrid);
                Recvieableamountfrompaymentscheule(PendingReceivableGrid);
                DifferenceAmountCalculationReceivable(PendingReceivableGrid);
            //  RecevieablePositiveamount(PendingReceivableGrid);
            until PendingReceivableGrid.Next() = 0;


    end;

    procedure FetchDataFromRevenueCalcGrid(var pendingReceiveable: Record "BLRPendingReceviableGrid")
    var
        RevenueGrid: Record "BLRFinalRevenueCalculationGrid";
    begin
        RevenueGrid.SetRange("BLRContract ID", pendingReceiveable."BLRContract ID");
        RevenueGrid.SetRange("BLRRevenue Description", pendingReceiveable.BLRRevenueDescription);
        if RevenueGrid.FindSet() then
            repeat
                pendingReceiveable.BLRRevisedAmount := RevenueGrid."BLRRevised Amount";
                pendingReceiveable.BLRRevisedVAT := RevenueGrid."BLRRevised VAT";
                pendingReceiveable.BLRRevisedAmountInclVAT := RevenueGrid."BLRRevised Amount Incl.";
                pendingReceiveable.Modify();
            until RevenueGrid.Next() = 0;

    end;

    procedure Recvieableamountfrompaymentscheule(var pendingReceiveable: Record "BLRPendingReceviableGrid")
    var
        PaymentScheduleRec: Record "BLRPaymentSchedule2";
        Totalamount: Decimal;
        VATAmount: Decimal;
        AmountIncVAT: Decimal;
    begin
        Totalamount := 0;
        PaymentScheduleRec.Reset();
        PaymentScheduleRec.SetRange("BLRContract ID", pendingReceiveable."BLRContract ID");
        PaymentScheduleRec.SetFilter("BLRDue Date", '<=%1', pendingReceiveable."BLRTermination Date");
        PaymentScheduleRec.SetRange("BLRPayment Status", 'Received');
        PaymentScheduleRec.SetRange("BLRSecondary Item Type", pendingReceiveable.BLRRevenueDescription);
        if PaymentScheduleRec.FindSet() then
            repeat
                Totalamount += PaymentScheduleRec."BLRAmount";
                VATAmount += PaymentScheduleRec."BLRVAT Amount";
                AmountIncVAT += PaymentScheduleRec."BLRAmount Including VAT";

            until PaymentScheduleRec.Next() = 0;

        PaymentScheduleRec.SetRange("BLRContract ID", pendingReceiveable."BLRContract ID");
        PaymentScheduleRec.SetRange("BLRSecondary Item Type", pendingReceiveable.BLRRevenueDescription);
        if PaymentScheduleRec.FindSet() then
            repeat
                pendingReceiveable.BLRReceiptsAmount := Totalamount;
                pendingReceiveable.BLRReceiptsVAT := VATAmount;
                pendingReceiveable.BLRReceiptsAmountInclVAT := AmountIncVAT;
                pendingReceiveable.Modify();
            until PaymentScheduleRec.Next() = 0;
    end;

    procedure DifferenceAmountCalculationReceivable(var RecvieableCalcGrid: Record "BLRPendingReceviableGrid")

    begin

        RecvieableCalcGrid.BLRDifferenceAmount := RecvieableCalcGrid.BLRRevisedAmount - RecvieableCalcGrid.BLRReceiptsAmount;
        RecvieableCalcGrid.BLRDifferenceVAT := RecvieableCalcGrid.BLRRevisedVAT - RecvieableCalcGrid.BLRReceiptsVAT;
        RecvieableCalcGrid.BLRDifferenceAmountInclVAT := RecvieableCalcGrid.BLRRevisedAmountInclVAT - RecvieableCalcGrid.BLRReceiptsAmountInclVAT;
        RecvieableCalcGrid.Modify();

    end;

    // procedure RecevieablePositiveamount()
    // var
    //     pendingReceieableRecGrid: Record "BLRPendingReceviableGrid";
    // begin
    //     pendingReceieableRecGrid.SetRange("BLRContract ID", Rec."BLRContract ID");
    //     if pendingReceieableRecGrid.FindSet() then
    //         repeat
    //             pendingReceieableRecGrid.CalcFields("BLRTotalDiffAmtInclVAT");
    //             if pendingReceieableRecGrid.DifferenceAmountInclVAT < 0 then begin
    //                 pendingReceieableRecGrid."BLRTotal Refundable" := Abs(pendingReceieableRecGrid.DifferenceAmountInclVAT);
    //                 pendingReceieableRecGrid.Modify();
    //             end else begin
    //                 pendingReceieableRecGrid."BLRTotal Receivable" := pendingReceieableRecGrid.DifferenceAmountInclVAT;
    //                 pendingReceieableRecGrid.Modify();

    //             end;
    //         until pendingReceieableRecGrid.Next() = 0;
    // end;

    procedure TotalRefundableAmount()
    var
        pendingreceivablegrid1: Record "BLRPendingReceviableGrid";
        pendingreceivablegrid2: Record "BLRPendingReceviableGrid";
        TotalNegativeAmount: Decimal;
    begin
        // Calculate total positive difference for the whole contract
        TotalNegativeAmount := 0;
        pendingreceivablegrid1.SetRange("BLRContract ID", Rec."BLRContract ID");
        pendingreceivablegrid1.SetFilter("BLRDifferenceAmountInclVAT", '<%1', 0);
        if pendingreceivablegrid1.FindSet() then
            repeat
                TotalNegativeAmount += pendingreceivablegrid1."BLRDifferenceAmountInclVAT";
            until pendingreceivablegrid1.Next() = 0;

        // Write the same (absolute) total to every grid record for this contract
        pendingreceivablegrid2.SetRange("BLRContract ID", Rec."BLRContract ID");
        if pendingreceivablegrid2.FindSet() then
            repeat
                pendingreceivablegrid2."BLRTotal Refundable" := Abs(TotalNegativeAmount);
                pendingreceivablegrid2.Modify();
            until pendingreceivablegrid2.Next() = 0;

    end;


    procedure TotalReceivableAmount()
    var
        pendingreceivablegrid1: Record "BLRPendingReceviableGrid";
        pendingreceivablegrid2: Record "BLRPendingReceviableGrid";
        TotalPositiveAmount: Decimal;
    begin
        // Calculate total negative difference for the whole contract
        TotalPositiveAmount := 0;
        pendingreceivablegrid1.SetRange("BLRContract ID", Rec."BLRContract ID");
        pendingreceivablegrid1.SetFilter("BLRDifferenceAmountInclVAT", '>%1', 0);
        if pendingreceivablegrid1.FindSet() then
            repeat
                TotalPositiveAmount += pendingreceivablegrid1."BLRDifferenceAmountInclVAT";
            until pendingreceivablegrid1.Next() = 0;

        // Write the same (absolute) total to every grid record for this contract
        pendingreceivablegrid2.SetRange("BLRContract ID", Rec."BLRContract ID");
        if pendingreceivablegrid2.FindSet() then
            repeat
                // Keep already invoiced lines at zero (existing business rule)
                pendingreceivablegrid2."BLRTotal Receivable" := Abs(TotalPositiveAmount);
                pendingreceivablegrid2.Modify();
            until pendingreceivablegrid2.Next() = 0;



    end;

    procedure GetBillingCharges()
    var
        BillingCalcGrid: Record "BLRFinalBillingCalculationGrid";
    begin
        BillingCalcGrid.SetRange("BLRContract ID", Rec."BLRContract ID");
        if BillingCalcGrid.FindSet() then
            repeat
                InvoiceCreditNoteSummaryData(BillingCalcGrid)
                       until BillingCalcGrid.Next() = 0;
    end;

    procedure InvoiceCreditNoteSummaryData(var BillingCalcGrid: Record "BLRFinalBillingCalculationGrid")
    var
        BillingCalcGrid1: Record "BLRFinalBillingCalculationGrid";
        InvoiceCreditNoteSummaryRec: Record BLRInvoiceCreditNoteSummary;
        DescriptionList: List of [Text];
        Description: Text;
    begin
        BillingCalcGrid1.SetRange("BLRContract ID", BillingCalcGrid."BLRContract ID");
        BillingCalcGrid1.SetFilter(BillingCalcGrid1."BLRDifferenceAmountInclVAT", '<>%1', 0);
        if BillingCalcGrid1.FindSet() then
            repeat
                InvoiceCreditNoteSummaryRec.SetRange("BLRContract No.", Rec."BLRContract ID");
                InvoiceCreditNoteSummaryRec.SetRange(BLRDescription, 'Final Billing Calculation');
                InvoiceCreditNoteSummaryRec.SetRange("BLRRevenue Description", BillingCalcGrid1.BLRRevenueDescription);
                if InvoiceCreditNoteSummaryRec.FindFirst() then begin
                    InvoiceCreditNoteSummaryRec.BLRInvoice := 0;
                    InvoiceCreditNoteSummaryRec."BLRCredit Note" := 0;
                    if BillingCalcGrid1."BLRDifferenceAmountInclVAT" > 0 then
                        InvoiceCreditNoteSummaryRec."BLRCredit Note" := Abs(BillingCalcGrid1."BLRDifferenceAmountInclVAT")
                    else
                        InvoiceCreditNoteSummaryRec.BLRInvoice := Abs(BillingCalcGrid1."BLRDifferenceAmountInclVAT");
                    InvoiceCreditNoteSummaryRec.Modify(true);
                end
                else begin
                    Clear(InvoiceCreditNoteSummaryRec);
                    InvoiceCreditNoteSummaryRec.Init();
                    InvoiceCreditNoteSummaryRec."BLRContract No." := Rec."BLRContract ID";
                    InvoiceCreditNoteSummaryRec.BLRDescription := 'Final Billing Calculation';
                    InvoiceCreditNoteSummaryRec."BLRRevenue Description" := BillingCalcGrid1.BLRRevenueDescription;
                    if BillingCalcGrid1."BLRDifferenceAmountInclVAT" > 0 then
                        InvoiceCreditNoteSummaryRec."BLRCredit Note" := Abs(BillingCalcGrid1."BLRDifferenceAmountInclVAT")
                    else
                        InvoiceCreditNoteSummaryRec.BLRInvoice := Abs(BillingCalcGrid1."BLRDifferenceAmountInclVAT");
                    InvoiceCreditNoteSummaryRec.Insert(true);
                end;
            until BillingCalcGrid1.Next() = 0;

        // Clear existing lines in Final Revenue Calculation Grid for this contract
        // InvoiceCreditNoteSummaryRec.SetRange("BLRContract No.", Rec."BLRContract ID");
        // if not InvoiceCreditNoteSummaryRec.IsEmpty() then
        //     exit;

        // DescriptionList.Add('Final Billing Calculation');
        // DescriptionList.Add('Termination Additional Charges');
        // DescriptionList.Add('Financial Adjustments / Contract Reductions');

        // foreach Description in DescriptionList do begin
        //     InvoiceCreditNoteSummaryRec.Init();
        //     InvoiceCreditNoteSummaryRec."Contract No." := Rec."BLRContract ID";
        //     InvoiceCreditNoteSummaryRec.Description := Description;
        //     InvoiceCreditNoteSummaryRec.Insert();
        //     Clear(InvoiceCreditNoteSummaryRec);
        // end;


    end;

    procedure PopulateFinalAdjtCaontractRedGrid()
    var
        tenancyContractSub: Record "BLRTenancyContractSubpage";
        item: Record Item;
        finalAdj: Record BLRFinAdjContractReduction;
        pendingReceiveable: Record "BLRPendingReceviableGrid";
    begin
        finalAdj.SetRange("BLRContract No.", Rec."BLRContract ID");
        if finalAdj.FindFirst() then
            exit;
        tenancyContractSub.SetRange("BLRContractID", Rec."BLRContract ID");
        if tenancyContractSub.FindSet() then
            repeat
                item.SetRange(Description, tenancyContractSub."BLRSecondary Item Type");
                item.SetRange("BLRItem type template", item."BLRItem type template"::"Secondary Item");
                item.SetFilter("BLRCategory Types", '%1|%2|%3|%4', 'Refundable Deposit', 'Government fees', 'Govt. Fees', 'Government Fees');
                if item.FindFirst() then begin
                    pendingReceiveable.SetRange("BLRContract ID", Rec."BLRContract ID");
                    pendingReceiveable.SetRange(BLRRevenueDescription, item.Description);
                    if pendingReceiveable.FindFirst() then begin
                        finalAdj.Init();
                        finalAdj."BLRContract No." := Rec."BLRContract ID";
                        finalAdj."BLRRevenue Description" := item.Description;
                        finalAdj.Insert(true);
                        finalAdj.Validate(BLRAmount, pendingReceiveable.BLRDifferenceAmount);
                        finalAdj.Validate("BLRVAT %", item."BLRVAT %");
                        // finalAdj."VAT Amount" := pendingReceiveable.DifferenceVAT;
                        // finalAdj."Amount Incl. VAT" := pendingReceiveable.DifferenceAmountInclVAT;
                        Clear(finalAdj);
                    end;
                end;

            until tenancyContractSub.Next() = 0;
    end;

    //////////////////////// END PENDING RECIVEABLE CALCULATION //////////////////////

    var
        carryForwardGrid: Page "BLRCarryForwardGrid";
        IsReceivable: Boolean;
        IsRefundable: Boolean;
        CanPost: Boolean;
}