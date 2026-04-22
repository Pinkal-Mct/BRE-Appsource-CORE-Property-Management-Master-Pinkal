namespace PropertyManagement.PropertyManagement;
report 73209589 "Revenue Allocation"
{
    ApplicationArea = All;
    Caption = 'Revenue Allocation';
    UsageCategory = ReportsAndAnalysis;
    ExcelLayout = 'Revenue Allocation.xlsx';
    DefaultLayout = Excel;
    dataset
    {
        dataitem(TenancyContract; "Tenancy Contract")
        {
            column(Property_Name; "Property Name")
            {
            }
            column(Contract_ID; "Contract ID")
            {
            }
            column(Contract_Tenor; "Contract Tenor")
            {
            }
            column(Tenant_ID; "Tenant ID")
            {
            }
            column(Customer_Name; "Customer Name")
            {
            }
            column(Contract_Start_Date; "Contract Start Date")
            {
            }
            column(Contract_End_Date; "Contract End Date")
            {
            }
            column(Grace_Period; "Grace Period")
            {
            }
            column(Rent_Amount; "Rent Amount")
            {
            }
            column(Annual_Rent_Amount; "Annual Rent Amount")
            {
            }
            column(Owner_s_Name; "Owner's Name")
            {
            }
            trigger OnAfterGetRecord()
            var
                StartDateIsInRange: Boolean;
                EndDateIsInRange: Boolean;
            begin
                StartDateIsInRange := ("Contract Start Date" >= gCustomStartDate) and ("Contract Start Date" <= gCustomEndDate);
                EndDateIsInRange := ("Contract End Date" >= gCustomStartDate) and ("Contract End Date" <= gCustomEndDate);
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
