namespace BREPropertyManagementMargi.BREPropertyManagementMargi;
using Microsoft.Foundation.Company;
using Microsoft.Inventory.Item;
using Microsoft.Sales.Customer;
report 73209594 UmmAlQuwainContract
{
    ApplicationArea = All;
    Caption = 'Umm Al Quwain Contract';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "UmmAlQuwainContract.docx";
    dataset
    {
        dataitem(TenancyContract; "Tenancy Contract")
        {
            column(Customer_Name; "Customer Name")
            {
            }
            column(Emirates_ID; "Emirates ID")
            {
            }
            column(Contact_Number; "Contact Number")
            {
            }
            column(Email_Address; "Email Address")
            {
            }
            column(Owner_s_Name; "Owner's Name")
            {
            }
            column(Lessor_s_Name; "Lessor's Name")
            {
            }
            column(Lessor_s_Emirates_ID; "Lessor's Emirates ID")
            {
            }
            column(Lessor_s_Phone; "Lessor's Phone")
            {
            }
            column(Lessor_s_Email; "Lessor's Email")
            {
            }
            column(Contract_Start_Date; "Contract Start Date")
            {
            }
            column(Contract_End_Date; "Contract End Date")
            {
            }
            column(Property_Size; "Property Size")
            {
            }
            column(B_U_o_M; "Base Unit of Measure")
            {
            }
            column(Unit_Number; "Unit Number")
            {
            }
            column(Property_Type; "Property Type")
            {
            }
            column(Unit_Name; "Unit Name")
            {
            }
            column(Property_Name; "Property Name")
            {
            }
            column(Property_Classification; "Property Classification")
            {
            }
            column(Contract_Tenor; "Contract Tenor")
            {
            }
            column(Lessor_s_Nationality; "Lessor's Nationality")
            {
            }
            column(Lessor_s_Address; "Lessor's Address")
            {
            }
            column(Rent_Amount; "Rent Amount")
            {
            }
            column(Community; Community)
            {
            }
            column(DEWA_Number; "DEWA Number")
            {
            }
            dataitem(Customer; Customer)
            {
                DataItemLink = "No." = field("Tenant ID");
                column(Nationality; Nationality)
                {
                }
                column(P_O_Box; "P.O.Box")
                {
                }
            }
            dataitem(Item; Item)
            {
                DataItemLink = "No." = field("Unit ID");
                column(Floor_Number; "Floor Number")
                {
                }
            }
            dataitem("Property Registration"; "Property Registration")
            {
                DataItemLink = "Property ID" = field("Property ID");
                column(Address; Address)
                {
                }
            }
            dataitem("Owner Profile"; "Owner Profile")
            {
                DataItemLink = "Owner ID" = field("Owner ID");
                column(O_P_O_Box; "P.O.Box")
                {
                }
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
        layout("UmmAlQuwainContract.docx")
        {
            Type = Word;
            LayoutFile = './UmmAlQuwainContract.docx';
            Caption = 'UmmAlQuwainContract (Word)';
            Summary = 'The UmmAlQuwainContract (Word) provides a simple layout that is also relatively easy for an end-user to modify.';
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
