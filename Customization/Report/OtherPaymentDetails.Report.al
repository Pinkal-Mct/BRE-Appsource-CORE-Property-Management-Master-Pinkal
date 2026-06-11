namespace BREPropertyManagementMargi.BREPropertyManagementMargi;
using Microsoft.Foundation.Company;
report 73209585 "BLROther Payment Details"
{
    ApplicationArea = All;
    Caption = 'Other Payment Details';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "OtherPayment.docx";
    dataset
    {
        dataitem("BLRRevenueItemSubpage"; "BLRRevenueItemSubpage")
        {
            column(ProposalID; BLRProposalID)
            {
            }
            column(Property_Name; "BLRProperty Name")
            {
            }
            column(Unit_Name; "BLRUnit Name")
            {
            }
            column(Unit_Size; "BLRUnit Size")
            {
            }
            column(Customer_Name; "BLRCustomer Name")
            {
            }
            column(Entry_No_; AutoEntryNo)
            {
            }
            column(Secondary_Item_Type; "BLRSecondary Item Type")
            {
            }
            column(Amount; BLRAmount)
            {
            }
            column(VAT_Amount; "BLRVAT Amount")
            {
            }
            column(A_Including_VAT; "BLRAmount Including VAT")
            {
            }
            column(Start_Date; "BLRStart Date")
            {
            }
            column(End_Date; "BLREnd Date")
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(CurrentDate; Format(CurrentDateTime, 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            trigger OnAfterGetRecord()
            begin
                AutoEntryNo += 1;

                PropertyNameStored := "BLRProperty Name";
                UnitNameStored := "BLRUnit Name";
                CustomerNameStored := "BLRCustomer Name";

                TotalAmount += BLRAmount;
                TotalVATAmount += "BLRVAT Amount";
                TotalAmountIncludingVAT += "BLRAmount Including VAT";
            end;
        }
        dataitem(TotalSection; System.Utilities.Integer)
        {
            DataItemTableView = sorting(Number) where(Number = const(1));
            column(T_Amount; TotalAmount)
            {
            }
            column(T_VAT_A; TotalVATAmount)
            {
            }
            column(TA_Incl_VAT; TotalAmountIncludingVAT)
            {
            }
        }
        dataitem("BLRLeaseProposalDetails"; "BLRLeaseProposalDetails")
        {
            DataItemLink = "BLRProposal ID" = field(BLRProposalID);
            DataItemLinkReference = "BLRRevenueItemSubpage";
            column(ID; "BLRProposal ID")
            {
            }
            column(Rent_Amount; "BLRRent Amount")
            {
            }
            column(Annual_R_A; "BLRAnnual Rent Amount")
            {
            }
            column(Rent_VAT_A; "BLRRent VAT Amount")
            {
            }
            column(RA_Incl_VAT; "BLRRent Amount Including VAT")
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
        layout("OtherPayment.docx")
        {
            Type = Word;
            LayoutFile = './OtherPayment.docx';
            Caption = 'OtherPayment (Word)';
            Summary = 'The OtherPaymentDetails (Word) provides a simple layout that is also relatively easy for an end-user to modify.';
        }
    }
    trigger OnInitReport()
    begin
        if not CompanyInfo.Get() then
            Error('Company Information not found.')
        else
            CompanyInfo.CalcFields(Picture);
        AutoEntryNo := 0;
    end;

    var
        CompanyInfo: Record "Company Information";
        TotalAmount: Decimal;
        TotalVATAmount: Decimal;
        TotalAmountIncludingVAT: Decimal;
        PropertyNameStored: Text;
        UnitNameStored: Text;
        CustomerNameStored: Text[100];
        AutoEntryNo: Integer;
}
