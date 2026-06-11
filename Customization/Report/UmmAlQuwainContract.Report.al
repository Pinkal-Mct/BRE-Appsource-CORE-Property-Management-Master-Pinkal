namespace BREPropertyManagementMargi.BREPropertyManagementMargi;
using Microsoft.Foundation.Company;
using Microsoft.Inventory.Item;
using Microsoft.Sales.Customer;
report 73209594 BLRUmmAlQuwainContract
{
    ApplicationArea = All;
    Caption = 'Umm Al Quwain Contract';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "UmmAlQuwainContract.docx";
    dataset
    {
        dataitem(TenancyContract; "BLRTenancyContract")
        {
            column(Customer_Name; "BLRCustomer Name")
            {
            }
            column(Emirates_ID; "BLREmirates ID")
            {
            }
            column(Contact_Number; "BLRContact Number")
            {
            }
            column(Email_Address; "BLREmail Address")
            {
            }
            column(Owner_s_Name; "BLROwner's Name")
            {
            }
            column(Lessor_s_Name; "BLRLessor's Name")
            {
            }
            column(Lessor_s_Emirates_ID; "BLRLessor's Emirates ID")
            {
            }
            column(Lessor_s_Phone; "BLRLessor's Phone")
            {
            }
            column(Lessor_s_Email; "BLRLessor's Email")
            {
            }
            column(Contract_Start_Date; "BLRContract Start Date")
            {
            }
            column(Contract_End_Date; "BLRContract End Date")
            {
            }
            column(Property_Size; "BLRProperty Size")
            {
            }
            column(B_U_o_M; "BLRBase Unit of Measure")
            {
            }
            column(Unit_Number; "BLRUnit Number")
            {
            }
            column(Property_Type; "BLRProperty Type")
            {
            }
            column(Unit_Name; "BLRUnit Name")
            {
            }
            column(Property_Name; "BLRProperty Name")
            {
            }
            column(Property_Classification; "BLRProperty Classification")
            {
            }
            column(Contract_Tenor; "BLRContract Tenor")
            {
            }
            column(Lessor_s_Nationality; "BLRLessor's Nationality")
            {
            }
            column(Lessor_s_Address; "BLRLessor's Address")
            {
            }
            column(Rent_Amount; "BLRRent Amount")
            {
            }
            column(Community; "BLRCommunity")
            {
            }
            column(DEWA_Number; "BLRDEWA Number")
            {
            }
            dataitem(Customer; Customer)
            {
                DataItemLink = "No." = field("BLRTenant ID");
                column(Nationality; BLRNationality)
                {
                }
                column(P_O_Box; "BLRP.O.Box")
                {
                }
            }
            dataitem(Item; Item)
            {
                DataItemLink = "No." = field("BLRUnit ID");
                column(Floor_Number; "BLRFloor Number")
                {
                }
            }
            dataitem("BLRPropertyRegistration"; "BLRPropertyRegistration")
            {
                DataItemLink = "BLRProperty ID" = field("BLRProperty ID");
                column(Address; BLRAddress)
                {
                }
            }
            dataitem("BLROwnerProfile"; "BLROwnerProfile")
            {
                DataItemLink = "BLROwner ID" = field("BLROwner ID");
                column(O_P_O_Box; "BLRP.O.Box")
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
