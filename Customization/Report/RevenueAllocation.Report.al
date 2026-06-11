namespace PropertyManagement.PropertyManagement;
report 73209589 "BLRRevenue Allocation"
{
    ApplicationArea = All;
    Caption = 'Revenue Allocation';
    UsageCategory = ReportsAndAnalysis;
    ExcelLayout = 'Revenue Allocation.xlsx';
    DefaultLayout = Excel;
    dataset
    {
        dataitem(TenancyContract; "BLRTenancyContract")
        {
            column(Property_Name; "BLRProperty Name")
            {
            }
            column(Contract_ID; "BLRContract ID")
            {
            }
            column(Contract_Tenor; "BLRContract Tenor")
            {
            }
            column(Tenant_ID; "BLRTenant ID")
            {
            }
            column(Customer_Name; "BLRCustomer Name")
            {
            }
            column(Contract_Start_Date; "BLRContract Start Date")
            {
            }
            column(Contract_End_Date; "BLRContract End Date")
            {
            }
            column(Grace_Period; "BLRGrace Period")
            {
            }
            column(Rent_Amount; "BLRRent Amount")
            {
            }
            column(Annual_Rent_Amount; "BLRAnnual Rent Amount")
            {
            }
            column(Owner_s_Name; "BLROwner's Name")
            {
            }
            trigger OnAfterGetRecord()
            var
                StartDateIsInRange: Boolean;
                EndDateIsInRange: Boolean;
            begin
                StartDateIsInRange := ("BLRContract Start Date" >= gCustomStartDate) and ("BLRContract Start Date" <= gCustomEndDate);
                EndDateIsInRange := ("BLRContract End Date" >= gCustomStartDate) and ("BLRContract End Date" <= gCustomEndDate);
                if not (StartDateIsInRange or EndDateIsInRange) then
                    CurrReport.SKIP();
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(DateFilter)
                {
                    field(CustomStartDate; gCustomStartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Custom Start Date';
                        ToolTip = 'Custom Start Date';
                    }
                    field(CustomEndDate; gCustomEndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Custom End Date';
                        ToolTip = 'Cutom End Date';
                    }
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var
        gCustomStartDate: Date;
        gCustomEndDate: Date;
}
