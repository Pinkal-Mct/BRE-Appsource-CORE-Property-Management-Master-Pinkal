namespace PropertyManagement.PropertyManagement;
using Microsoft.Foundation.Company;
report 73209579 "BLRContractRenewal"
{
    ApplicationArea = All;
    Caption = 'Contract Renewal';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "ContractRenewalTemplate.docx";
    dataset
    {
        dataitem(ContractRenewal; "BLRContractRenewal")
        {
            column(Contract_Date; "BLRContract Date")
            {
            }
            column(Property_Name; "BLRProperty Name")
            {
            }
            column(Unit_Number; "BLRUnit Number")
            {
            }
            column(Tenant_Full_Name; "BLRTenant Full Name")
            {
            }
            column(Annual_Rent_Amount; "BLRAnnual Rent Amount")
            {
            }
            column(Contract_Amount; "BLRContract Amount")
            {
            }
            column(Rera; BLRRera)
            {
            }
            column(Ejari_Processing_Charges; "BLREjari Processing Charges")
            {
            }
            column(Renewal_Charges; "BLRRenewal Charges")
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(Community; BLRCommunity)
            {
            }
            column(Contract_End_Date; Format("BLRContract End Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CurrentDate; Format(CurrentDateTime, 0, '<Day,2>/<Month,2>/<Year4>'))
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
        layout("ContractRenewalTemplate.docx")
        {
            Type = Word;
            LayoutFile = './ContractRenewalTemplate.docx';
            Caption = 'ContractRenewalTemplate (Word)';
            Summary = 'The ContractRenewalTemplate (Word) provides a simple layout that is also relatively easy for an end-user to modify.';
        }
    }
    trigger OnInitReport()
    var
    begin
        if not CompanyInfo.Get() then
            Error('Company Information not found.')
        else
            CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
}
