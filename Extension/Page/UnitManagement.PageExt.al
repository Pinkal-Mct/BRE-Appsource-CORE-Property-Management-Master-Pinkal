pageextension 73209605 BLRUnitManagement extends "O365 Activities"
{
    layout
    {

        modify("Sales This Month")
        {
            Visible = false;
        }
        modify("Overdue Sales Invoice Amount")
        {
            Visible = false;
        }
        modify("Overdue Purch. Invoice Amount")
        {
            Visible = false;
        }
        modify("Ongoing Sales")
        {
            Visible = false;
        }
        modify("Ongoing Purchases")
        {
            Visible = false;
        }
        modify(Payments)
        {
            Visible = false;
        }
        modify("Incoming Documents")
        {
            Visible = false;
        }

        addafter("Ongoing Sales")
        {
            cuegroup("BLRAll")
            {
                Caption = 'All';
                field("BLRAll Property"; BLRGetAllPropertiesCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'All Property';
                    ToolTip = 'Count of all properties.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the vacant property list page
                        PAGE.RUN(PAGE::"BLRProperty Registration List");
                    end;
                }
                field("BLRAll Unit"; BLRGetAllUnitsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'All Unit';
                    ToolTip = 'Count of all units.';

                    trigger OnDrillDown()
                    var
                        item: Record Item; // Replace with your actual Property Table
                        itemListPage: Page "Item List"; // Replace with your actual Item List Page
                    begin
                        // Assuming you have a field to filter units
                        item.SetRange("BLRItem type template", item."BLRItem type template"::"Unit Service"); // Filter by Free status
                        // Drill down to the vacant property list page
                        itemListPage.SetTableView(item); // Set the filtered view
                        // PAGE.RUN(PAGE::"Item List");
                        itemListPage.Run();
                    end;
                }
            }
            cuegroup("BLRBLRPropertyType")
            {
                Caption = 'Property Type';
                field("BLRResidential Property Count"; BLRGetResidentialPropertiesCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Residential property';
                    ToolTip = 'Count of Residential properties.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the vacant property list page
                        PAGE.RUN(PAGE::"BLRResidential Property List");
                    end;
                }
                field("BLRCommercial Property Count"; BLRGetCommercialPropertiesCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Commercial property';
                    ToolTip = 'Count of Commercial properties.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the vacant property list page
                        PAGE.RUN(PAGE::"BLRCommercial Property List");
                    end;
                }
                field("BLRCommon Property Count"; BLRGetCommonPropertiesCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Common property';
                    ToolTip = 'Count of Common properties.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the vacant property list page
                        PAGE.RUN(PAGE::"BLRCommon Property List");
                    end;
                }
            }
            cuegroup("BLRUnit Type")
            {
                Caption = 'Unit Type';
                field("BLRResidential Unit Count"; BLRGetResidentialunitsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Residential units';
                    ToolTip = 'Count of free units.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the vacant property list page
                        PAGE.RUN(PAGE::"BLRResidential Unit List");
                    end;
                }
                field("BLRCommercial Unit Count"; BLRGetCommercialunitsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Commercial units';
                    ToolTip = 'Count of free units.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the vacant property list page
                        PAGE.RUN(PAGE::"BLRCommercial Unit List");
                    end;
                }
                field("BLRCommon Unit Count"; BLRGetCommonunitsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Common units';
                    ToolTip = 'Count of free units.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the vacant property list page
                        PAGE.RUN(PAGE::"BLRCommon Unit List");
                    end;
                }
            }
            cuegroup("BLRUnit Status")
            {
                Caption = 'Unit Status'; // Adjust the caption as needed
                field("BLRFree units Count"; BLRGetFreeunitsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Free units';
                    ToolTip = 'Count of free units.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the vacant property list page
                        PAGE.RUN(PAGE::"BLRFree Unit List");
                    end;
                }
                field("BLRSelected units Count"; BLRGetSelectedunitsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Selected units';
                    ToolTip = 'Count of selected units.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the vacant property list page
                        PAGE.RUN(PAGE::"BLRSelected Unit List");
                    end;
                }
                field("BLROccupied units Count"; BLRGetOccupiedunitsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Occupied units';
                    ToolTip = 'Count of occupied units.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the vacant property list page
                        PAGE.RUN(PAGE::"BLROccupied Unit List");
                    end;
                }
            }
            cuegroup("BLRMerged Unit Status")
            {
                Caption = 'Merged Unit Status'; // Adjust the caption as needed
                field("BLRFree Merged units Count"; BLRGetFreeMergedUnitsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Free merged units';
                    ToolTip = 'Count of free merged units.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the free merged unit list page
                        PAGE.RUN(PAGE::"BLRFree Merged Unit list");
                    end;
                }
                field("BLROccupied Merged units Count"; BLRGetOccupiedMergedUnitsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Occupied merged units';
                    ToolTip = 'Count of occupied merged units.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the occupied merged unit list page
                        PAGE.RUN(PAGE::"BLROccupied Merged Unit list");
                    end;
                }
            }
            cuegroup("BLRTenancy Contracts Statistics")
            {
                field("BLRAll Proposals Count"; BLRGetAllProposalsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'All Proposals';
                    ToolTip = 'Count of all proposals.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the proposals list page
                        PAGE.RUN(PAGE::"BLRLease Proposal List");
                    end;
                }
                field("BLRActive Contracts Count"; BLRGetActiveContractsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Active Contracts';
                    ToolTip = 'Count of currently active contracts.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the active contracts list page
                        PAGE.RUN(PAGE::"BLRActive Contract List");
                    end;
                }
                field("BLRSuspended Contracts Count"; BLRGetSuspendedContractsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Suspended Contracts';
                    ToolTip = 'Count of currently suspended contracts.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the active contracts list page
                        PAGE.RUN(PAGE::"BLRSuspended Contract List");
                    end;
                }
                field("BLRContracts Expiring Soon"; BLRGetExpiringContractsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Contracts Expiring Soon';
                    ToolTip = 'Count of contracts expiring within 1 month.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the expiring contracts list page
                        PAGE.RUN(PAGE::"BLRExpiring Contract List");
                    end;
                }
            }
            cuegroup("BLRSales Credit Memo")
            {
                field("BLRSales Credit Memo Count"; BLRGetSalesCreditMemoCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Sales Credit Memo';
                    ToolTip = 'Count of Posted Sales Credit Memos.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the Sales Credit Memo list page
                        PAGE.RUN(PAGE::"Posted Sales Credit Memos");
                    end;
                }
                field("BLRFull Adjusted Credit Memo Count"; BLRGefulladjustedCreditMemoCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Full Adjusted Credit Memo';
                    ToolTip = 'Count of Sales Credit Memos with remaining amount 0.';
                    //  StyleExpr = 'Unfavorable';  // This will display the count in red to indicate attention is needed

                    trigger OnDrillDown()
                    begin
                        // Drill down to the fully adjusted credit memo list page
                        PAGE.RUN(PAGE::"Posted Sales Credit Memos");
                    end;
                }
                field("BLRUnpaid Credit Memo Count"; BLRGetunpaidcreditmemo())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Unpaid Credit Memo';
                    ToolTip = 'Count of Sales Credit Memos that are unpaid.';
                    StyleExpr = 'Unfavorable';  // This will display the count in red to indicate attention is needed

                    trigger OnDrillDown()
                    begin
                        // Drill down to the unpaid credit memo list page
                        PAGE.RUN(PAGE::"Posted Sales Credit Memos");
                    end;
                }
            }
            cuegroup("BLRPayments ")
            {
                field("BLRPayments Due Within 10 Days"; BLRGetPaymentsDueCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Payments Due Within 10 Days';
                    ToolTip = 'Count of tenant payments due within the next 10 days.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the upcoming payments list page
                        PAGE.RUN(PAGE::"BLRUpcoming Payments List");
                    end;
                }
                field("BLROverdue Payments"; BLRGetOverduePaymentsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Overdue Payments';
                    ToolTip = 'Count of tenant payments that are overdue (due date earlier than today).';
                    StyleExpr = 'Unfavorable';  // This will display the count in red to indicate attention is needed

                    trigger OnDrillDown()
                    begin
                        // Drill down to the overdue payments list page
                        PAGE.RUN(PAGE::"BLROverdue Payments List");
                    end;
                }
            }
            cuegroup("BLRSuspended Contracts")
            {
                field("BLRAll Suspended Contracts Count"; BLRGetSuspendedContractsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'All Suspended Contracts';
                    ToolTip = 'Count of currently suspended contracts.';

                    trigger OnDrillDown()
                    begin
                        // Drill down to the active contracts list page
                        PAGE.RUN(PAGE::"BLRSuspended Contract List");
                    end;
                }
                field("BLRLegally Suspended Contracts"; BLRGetLegallySuspendedContractsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Suspended Contracts-Legal';
                    ToolTip = 'Count of contracts suspended for legal reasons.';
                    StyleExpr = 'Attention';  // This will highlight the count to show it needs attention

                    trigger OnDrillDown()
                    begin
                        // Drill down to the legally suspended contracts list page
                        PAGE.RUN(PAGE::"BLRLegal Suspended Contracts");
                    end;
                }
                field("BLRBusiness Suspended Contracts"; BLRGetBusinessSuspendedContractsCount())
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Temporarily Suspended Contracts';
                    ToolTip = 'Count of contracts suspended for business reasons.';
                    StyleExpr = 'Ambiguous';  // This will highlight the count in a different color from legal suspensions

                    trigger OnDrillDown()
                    begin
                        // Drill down to the business suspended contracts list page
                        PAGE.RUN(PAGE::"BLRBusiness SuspendedContracts");
                    end;
                }

            }
        }
    }

    procedure BLRGetAllPropertiesCount(): Integer;
    var
        PropertyRec: Record "BLRPropertyRegistration"; // Replace with your actual Property Table
    begin
        exit(PropertyRec.Count()); // Return the count of vacant properties
    end;

    procedure BLRGetAllUnitsCount(): Integer;
    var
        PropertyRec: Record Item; // Replace with your actual Property Table
    begin

        propertyRec.SetRange("BLRItem type template", PropertyRec."BLRItem type template"::"Unit Service"); // Filter by Free status
        exit(PropertyRec.Count()); // Return the count of vacant properties
    end;

    procedure BLRGetResidentialPropertiesCount(): Integer;
    var
        PropertyRec: Record "BLRPropertyRegistration"; // Replace with your actual Property Table
    begin
        PropertyRec.SetRange("BLRProperty Classification", 'Residential'); // Filter by Vacant status
        exit(PropertyRec.Count()); // Return the count of vacant properties
    end;

    procedure BLRGetCommercialPropertiesCount(): Integer;
    var
        PropertyRec: Record "BLRPropertyRegistration"; // Replace with your actual Property Table
    begin
        PropertyRec.SetRange("BLRProperty Classification", 'Commercial'); // Filter by Vacant status
        exit(PropertyRec.Count()); // Return the count of vacant properties
    end;

    procedure BLRGetCommonPropertiesCount(): Integer;
    var
        PropertyRec: Record "BLRPropertyRegistration"; // Replace with your actual Property Table
    begin
        PropertyRec.SetRange("BLRProperty Classification", 'Common'); // Filter by Vacant status
        exit(PropertyRec.Count()); // Return the count of vacant properties
    end;

    procedure BLRGetResidentialunitsCount(): Integer;
    var
        PropertyRec: Record Item; // Replace with your actual Property Table
    begin
        PropertyRec.SetRange("BLRUsage Type", 'Residential'); // Filter by Vacant status
        exit(PropertyRec.Count()); // Return the count of vacant properties
    end;

    procedure BLRGetFreeMergedUnitsCount(): Integer;
    var
        MergedUnitsRec: Record "BLRMergedUnits";
    begin
        MergedUnitsRec.SetRange(BLRStatus, MergedUnitsRec."BLRStatus"::Free);
        exit(MergedUnitsRec.Count());
    end;

    procedure BLRGetOccupiedMergedUnitsCount(): Integer;
    var
        MergedUnitsRec: Record "BLRMergedUnits";
    begin
        MergedUnitsRec.SetRange(BLRStatus, MergedUnitsRec."BLRStatus"::Occupied);
        exit(MergedUnitsRec.Count());
    end;


    procedure BLRGetCommercialunitsCount(): Integer;
    var
        PropertyRec: Record Item; // Replace with your actual Property Table
    begin
        PropertyRec.SetRange("BLRUsage Type", 'Commercial'); // Filter by Vacant status
        exit(PropertyRec.Count()); // Return the count of vacant properties
    end;

    procedure BLRGetCommonunitsCount(): Integer;
    var
        PropertyRec: Record Item; // Replace with your actual Property Table
    begin
        PropertyRec.SetRange("BLRUsage Type", 'Common'); // Filter by Vacant status
        exit(PropertyRec.Count()); // Return the count of vacant properties
    end;

    procedure BLRGetFreeunitsCount(): Integer;
    var
        PropertyRec: Record Item; // Replace with your actual Property Table
    begin
        PropertyRec.SetRange("BLRUnit Status", PropertyRec."BLRUnit Status"::Free);
        PropertyRec.SetRange("BLRItem type template", "BLRItem Type Template Enum"::"Unit Service"); // Filter by Free status

        exit(PropertyRec.Count()); // Return the count of vacant properties
    end;

    procedure BLRGetSelectedunitsCount(): Integer;
    var
        PropertyRec: Record Item; // Replace with your actual Property Table
    begin
        PropertyRec.SetRange("BLRUnit Status", PropertyRec."BLRUnit Status"::Selected);

        exit(PropertyRec.Count()); // Return the count of vacant properties
    end;

    procedure BLRGetOccupiedunitsCount(): Integer;
    var
        PropertyRec: Record Item; // Replace with your actual Property Table
    begin
        PropertyRec.SetRange("BLRUnit Status", PropertyRec."BLRUnit Status"::Occupied);

        exit(PropertyRec.Count()); // Return the count of vacant properties
    end;

    procedure BLRGetAllProposalsCount(): Integer;
    var
        ProposalRec: Record "BLRLeaseProposalDetails"; // Replace with your actual Proposal Table
    begin
        // You can add filters here if needed
        exit(ProposalRec.Count()); // Return the count of all proposals
    end;

    procedure BLRGetActiveContractsCount(): Integer;
    var
        ContractRec: Record "BLRTenancyContract"; // Replace with your actual Contract Table
    begin
        ContractRec.SetRange("BLRTenant Contract Status", ContractRec."BLRTenant Contract Status"::Active); // Using the Option value instead of text
        exit(ContractRec.Count()); // Return the count of active contracts
    end;

    procedure BLRGetSuspendedContractsCount(): Integer;
    var
        ContractRec: Record BLRSuspendReasonTable; // Replace with your actual Contract Table
    begin
        ContractRec.SetRange("BLRTenant Contract Status", ContractRec."BLRTenant Contract Status"::Suspended); // Using the Option value instead of text
        ContractRec.SetFilter(BLRSuspensionEndDate, '%1', 0D); // Filter for empty date
        exit(ContractRec.Count()); // Return the count of active contracts
    end;

    procedure BLRGetExpiringContractsCount(): Integer;
    var
        ContractRec: Record "BLRTenancyContract";
        CurrentDate: Date;
        OneMonthLater: Date;
    begin
        CurrentDate := TODAY;
        OneMonthLater := CALCDATE('<+1M>', CurrentDate);

        ContractRec.SetRange("BLRTenant Contract Status", ContractRec."BLRTenant Contract Status"::Active);
        ContractRec.SetFilter("BLRContract End Date", '%1..%2', CurrentDate, OneMonthLater);
        exit(ContractRec.Count());
    end;

    procedure BLRGetPaymentsDueCount(): Integer;
    var
        PaymentRec: Record "BLRPaymentMode2"; // Replace with your actual payment table name
        CurrentDate: Date;
        TenDaysLater: Date;
    begin
        CurrentDate := TODAY;
        TenDaysLater := CALCDATE('<+10D>', CurrentDate);

        // Only filter by due date, ignore payment status
        PaymentRec.SetFilter("BLRDue Date", '%1..%2', CurrentDate, TenDaysLater);
        exit(PaymentRec.Count());
    end;

    procedure BLRGetOverduePaymentsCount(): Integer;
    var
        PaymentRec: Record "BLRPaymentMode2"; // Replace with your actual payment table name
    begin
        // Filter for payments with status Overdue
        PaymentRec.SetRange("BLRPayment Status", PaymentRec."BLRPayment Status"::Overdue);
        exit(PaymentRec.Count());
    end;

    procedure BLRGetLegallySuspendedContractsCount(): Integer;
    var
        ContractRec: Record BLRSuspendReasonTable;
    begin
        ContractRec.SetRange("BLRTenant Contract Status", ContractRec."BLRTenant Contract Status"::Suspended);
        ContractRec.SetRange(BLRReason, ContractRec.BLRReason::"Legal Reason"); // Adjust the field name and value as per your table structure
        ContractRec.SetFilter(BLRSuspensionEndDate, '%1', 0D); // Filter for empty date
        exit(ContractRec.Count());
    end;

    procedure BLRGetBusinessSuspendedContractsCount(): Integer;
    var
        ContractRec: Record BLRSuspendReasonTable;
    begin
        ContractRec.SetRange("BLRTenant Contract Status", ContractRec."BLRTenant Contract Status"::Suspended);
        ContractRec.SetRange(BLRReason, ContractRec.BLRReason::"Business Reason"); // Adjust the field name and value as per your table structure
        ContractRec.SetFilter(BLRSuspensionEndDate, '%1', 0D); // Filter for empty date
        exit(ContractRec.Count());
    end;

    procedure BLRGetSalesCreditMemoCount(): Integer;
    var
        SalesCreditMemoRec: Record "Sales Cr.Memo Header"; // Replace with your actual Sales Credit Memo Table
    begin
        exit(SalesCreditMemoRec.Count()); // Return the count of Sales Credit Memos
    end;

    procedure BLRGefulladjustedCreditMemoCount(): Integer;
    var
        SalesCreditMemoRec: Record "Sales Cr.Memo Header"; // Replace with your actual Sales Credit Memo Table
    begin
        SalesCreditMemoRec.SetRange("Remaining Amount", 0);
        exit(SalesCreditMemoRec.Count()); // Return the count of Sales Credit Memos with remaining amount 0
    end;

    procedure BLRGetunpaidcreditmemo(): Integer;
    var
        SalesCreditMemoRec: Record "Sales Cr.Memo Header"; // Replace with your actual Sales Credit Memo Table
    begin
        SalesCreditMemoRec.SetRange(Paid, false); // Assuming 'Paid' is a boolean field indicating if the credit memo is paid
        exit(SalesCreditMemoRec.Count()); // Return the count of Sales Credit Memos with remaining amount 0
    end;
}

