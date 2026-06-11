report 73209588 "BLRUnearned Rent Revenue"
{
    ApplicationArea = All;
    Caption = 'Unearned Rent Revenue';
    UsageCategory = ReportsAndAnalysis;
    ExcelLayout = 'Unearned Rent Revenue.xlsx';
    DefaultLayout = Excel;
    dataset
    {
        dataitem("BLRSubUnearnedRevenueReport"; "BLRSubUnearnedRevenueReport")
        {
            column(Contract_ID; "BLRContract ID")
            {
            }
            column(Customer_Name; "BLRCustomer Name")
            {
            }
            column(Unit_Name; "BLRUnit Name")
            {
            }
            column(Property; BLRProperty)
            {
            }
            column(Owner_Name; "BLROwner Name")
            {
            }
            column(Start_Date; "BLRStart Date")
            {
            }
            column(End_Date; "BLREnd Date")
            {
            }
            column(Termination_Date; "BLRTermination Date")
            {
            }
            column(Suspension_Date; "BLRSuspension Date")
            {
            }
            column(Contract_Value; "BLRContract Value")
            {
            }
            column(Contract_Status; "BLRContract Status")
            {
            }
            column(Opening_Balance; "BLROpening Balance")
            {
            }
            column(Invoice_Raised_During_the_Year; "BLRInvRaisedDurtheYear")
            {
            }
            column(RevenueAllocated_DuringtheYear; "BLRRevAllocDurtheYear")
            {
            }
            column(Unearned_Revenue_Balance; "BLRUnearned Revenue Balance")
            {
            }
            column(CalculatedUnearnedRevBalance; BLRCalculatedUnearnedRevB19C1)
            {
            }
            column(Shortfall_Excess; "BLRShortfall/Excess")
            {
            }
        }
    }
}