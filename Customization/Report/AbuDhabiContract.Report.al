namespace PropertyManagement.PropertyManagement;
using Microsoft.Foundation.Company;
report 73209578 BLRAbuDhabi_Contract
{
    ApplicationArea = All;
    Caption = 'AbuDhabi_Contract';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "AbuDhabiContract.docx";
    dataset
    {
        dataitem(TenancyContract; "BLRTenancyContract")
        {
            column(Emirate; BLREmirate)
            {
            }
            column(Community; BLRCommunity)
            {
            }
            column(PropertyClassification; "BLRProperty Classification")
            {
            }
            column(Unit_Number; "BLRUnit Number")
            {
            }
            column(Makani_Number; "BLRMakani Number")
            {
            }
            column(DEWA_Number; "BLRDEWA Number")
            {
            }
            column(PropertyName; "BLRProperty Name")
            {
            }
            column(PropertyType; "BLRProperty Type")
            {
            }
            column(Property_Size; "BLRProperty Size")
            {
            }
            column(Base_Unit_of_Measure; "BLRBase Unit of Measure")
            {
            }
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
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
    rendering
    {
        layout("AbuDhabiContract.docx")
        {
            Type = Word;
            LayoutFile = './AbuDhabiContract.docx';
            Caption = 'AbuDhabiContract (Word)';
            Summary = 'The AbuDhabiContract (Word) provides a simple layout that is also relatively easy for an end-user to modify.';
        }
    }
    trigger OnInitReport()
    begin
        if not CompanyInfo.Get() then
            Error('Company Information not found.')
        else
            CompanyInfo.CalcFields(Picture)
    end;

    var
        CompanyInfo: Record "Company Information";
}
