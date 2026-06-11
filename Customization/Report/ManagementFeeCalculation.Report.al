report 73209584 "BLRManagement Fee Calculation"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = "ManagementFeeCalculation.docx";

    dataset
    {
        dataitem("BLRManagementFeeCalcHeader"; "BLRManagementFeeCalcHeader")
        {
            column(Report_Date; "BLRReport Date")
            { }
            column(Owner_Name; OwnerName)
            { }
            column(Property; PropertyName)
            { }
            column(Financial_Year; "BLRFinancial Year")
            { }
            column(Period_From; "BLRPeriod From")
            { }
            column(Period_To; "BLRPeriod To")
            { }
            column(Total_Management_Fee; TotalMgtFee)
            { }

            dataitem("BLRManagementFeeCalcLine"; "BLRManagementFeeCalcLine")
            {
                DataItemLink = "BLRHeader No." = field("BLREntry No.");

                column(Property_Management_Company; "BLRProperty Management Company")
                { }
                column(Company_Owner_Name; "BLRCompany/Owner Name")
                { }
                column(Property_Name; "BLRProperty Name")
                { }
                column(Property_Type; "BLRProperty Type")
                { }
                column(Calculation_Method; "BLRCalculation Method")
                { }
                column(Calculation_Sub_Type; "BLRCalculation Sub-Type")
                { }
                column(Percentage_Type; "BLRPercentage Type")
                { }
                column(Percentage; "BLRPercentage")
                { }
                column(Amount; "BLRAmount")
                { }
                column(Base_Amount_Source; "BLRBase Amount Source")
                { }
                column(Base_Amount; "BLRBase Amount")
                { }
                column(Management_Fee; "BLRManagement Fee")
                { }
                column(Validity_Period; "BLRValidity Period")
                { }
                column(Contract_Status; "BLRContract Status")
                { }

                column(Total_Mgt__Fee; "BLRTotal Mgt. Fee")
                { }
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("BLROwner Name");
                if "BLRAll Owners" then
                    OwnerName := 'All'
                else
                    OwnerName := "BLROwner Name";

                if "BLRAll Properties" then
                    PropertyName := 'All'
                else
                    PropertyName := BLRProperty;
            end;
        }

    }

    rendering
    {
        layout("ManagementFeeCalculation.docx")
        {
            Type = Word;
            LayoutFile = './ManagementFeeCalculation.docx';
            Caption = 'Management Fee Calculation (Word)';
            Summary = 'The Management Fee Calculation (Word) provides a simple layout that is also relatively easy for an end-user to modify.';
        }
    }

    var
        OwnerName: Text;
        PropertyName: Text;
        TotalMgtFee: Decimal;
}