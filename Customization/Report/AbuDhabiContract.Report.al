namespace PropertyManagement.PropertyManagement;
using Microsoft.Foundation.Company;
report 73209578 AbuDhabi_Contract
{
    ApplicationArea = All;
    Caption = 'AbuDhabi_Contract';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "AbuDhabiContract.docx";
    dataset
    {
        dataitem(TenancyContract; "Tenancy Contract")
        {
            column(Emirate; Emirate)
            {
            }
            column(Community; Community)
            {
            }
            column(PropertyClassification; "Property Classification")
            {
            }
            column(Unit_Number; "Unit Number")
            {
            }
            column(Makani_Number; "Makani Number")
            {
            }
            column(DEWA_Number; "DEWA Number")
            {
            }
            column(PropertyName; "Property Name")
            {
            }
            column(PropertyType; "Property Type")
            {
            }
            column(Property_Size; "Property Size")
            {
            }
            column(Base_Unit_of_Measure; "Base Unit of Measure")
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
