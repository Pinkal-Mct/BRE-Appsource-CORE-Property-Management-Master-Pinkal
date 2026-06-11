namespace PropertyManagement.PropertyManagement;
using Microsoft.Foundation.Company;

report 73209591 "BLRTenancyContract"
{
    ApplicationArea = All;
    Caption = 'Tenancy Contract';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "TenancyContract.docx";
    dataset
    {
        dataitem(TenancyContract; "BLRTenancyContract")
        {
            column(Contract_ID; "BLRContract ID")
            {
            }
            column(Contract_Type; "BLRContract Type")
            {
            }
            column(Proposal_ID; "BLRProposal ID")
            {
            }
            column(Renewal_Proposal_ID; "BLRRenewal Proposal ID")
            {
            }
            column(OwnersName; "BLROwner's Name")
            {
            }
            column(LessorsName; "BLRLessor's Name")
            {
            }
            column(LessorsEmiratesID; "BLRLessor's Emirates ID")
            {
            }
            column(LicenseNo; "BLRLicense No.")
            {
            }
            column(LicensingAuthority; "BLRLicensing Authority")
            {
            }
            column(LessorsEmail; "BLRLessor's Email")
            {
            }
            column(LessorsPhone; "BLRLessor's Phone")
            {
            }
            column(EmiratesID; "BLREmirates ID")
            {
            }
            column(EmailAddress; "BLREmail Address")
            {
            }
            column(TenantID; "BLRTenant ID")
            {
            }
            column(PropertyClassification; "BLRProperty Classification")
            {
            }
            column(PropertyName; "BLRProperty Name")
            {
            }
            column(PropertyType; "BLRProperty Type")
            {
            }
            column(PropertyID; "BLRProperty ID")
            {
            }
            column(CustomerName; "BLRCustomer Name")
            {
            }
            column(AnnualRentAmount; "BLRAnnual Rent Amount")
            {
            }
            column(ContractTenor; "BLRContract Tenor")
            {
            }
            column(Contact_Number; "BLRContact Number")
            {
            }
            column(Customer_Name; "BLRCustomer Name")
            {
            }
            column(Contract_Tenor; "BLRContract Tenor")
            {
            }
            column(Rent_Amount; "BLRAnnual Rent Amount")
            {
            }
            column(Annual_Rent_Amount; "BLRRent Amount")
            {
            }
            column(Payment_Frequency; "BLRPayment Frequency")
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(Tenant_License_No_; "BLRTenant_License No.")
            {
            }
            column(Tenant_Licensing_Authority; "BLRTenant_Licensing Authority")
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
            column(Emirate; BLREmirate)
            {
            }
            column(Community; BLRCommunity)
            {
            }
            column(Security_Deposit_Amount; "BLRSecurity Deposit Amount")
            {
            }
            column(Property_Size; Format("BLRUnit Sq. Feet", 0, '<Precision,0:0><Integer>'))
            {
            }
            column(Base_Unit_of_Measure; "BLRBase Unit of Measure")
            {
            }
            column(Payment_Method; "BLRPayment Method")
            {
            }
            column(Contract_Start_Date; Format("BLRContract Start Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }

            column(Contract_End_Date; Format("BLRContract End Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }

            column(No_of_Installments; "BLRNo of Installments")
            {
            }
            column(Res; GetRadioButton("BLRProperty Classification" = 'Residential'))
            { }
            column(Comm; GetRadioButton("BLRProperty Classification" = 'Commercial'))
            { }
            column(Ind; GetRadioButton("BLRProperty Classification" = 'Industrial'))
            { }

            dataitem("TC Additional Terms"; "BLRTCAdditionalTerms")
            {
                DataItemLink = "BLRDocument No." = field("BLRContract ID");
                DataItemLinkReference = TenancyContract;
                column(Description; BLRDescription)
                {
                }
                column(no; number)
                { }
                column(arb; arabicNos)
                { }

                trigger OnAfterGetRecord()
                begin
                    number += 1;
                    arabicNos := GetArabicNumbers(number);
                end;
            }
            // column(p1; )
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
        layout("TenancyContract.docx")
        {
            Type = Word;
            LayoutFile = './TenancyContract.docx';
            Caption = 'TenancyContract (Word)';
            Summary = 'The TenancyContract (Word) provides a simple layout that is also relatively easy for an end-user to modify.';
        }

    }
    trigger OnInitReport()
    begin
        if not CompanyInfo.Get() then
            Error('Company Information not found.')
        else
            // CompanyAddress := CompanyInfo.City + ', ' + CompanyInfo.County + ' ' + CompanyInfo."Post Code";
            CompanyInfo.CalcFields(Picture);
        number := 0;
    end;

    var
        CompanyInfo: Record "Company Information";
        number: Integer;
        arabicNos: Text;

    procedure GetPropertyClassification(Selected: Boolean): Text
    begin
        if Selected then
            exit('◉')
        else
            exit('○');
    end;

    procedure GetArabicNumbers(Input: Integer): Text
    begin
        case
            Input of
            0:
                exit('٠');
            1:
                exit('١');
            2:
                exit('٢');
            3:
                exit('٣');
            4:
                exit('٤');
            5:
                exit('٥');
            6:
                exit('٦');
            7:
                exit('٧');
            8:
                exit('٨');
            9:
                exit('٩');
            else
                exit('');
        end;
    end;

    local procedure GetRadioButton(Selected: Boolean): Text
    begin
        if Selected then
            exit('◉')
        else
            exit('○');
    end;
}
