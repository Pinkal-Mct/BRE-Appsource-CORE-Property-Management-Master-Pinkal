namespace BREPropertyManagementMargi.BREPropertyManagementMargi;
using Microsoft.Foundation.Company;
using System.Text;
using Microsoft.Sales.Customer;
report 73209593 "BLRTermination Template"
{
    ApplicationArea = All;
    Caption = 'Termination Template';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "TerminationTemplate.docx";
    dataset
    {
        dataitem(FinalCalculation; "BLRFinalCalculation")
        {
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(CompanyAddress; CompanyInfo.Address)
            {
            }
            column(CompanyCity; CompanyInfo.City)
            {
            }
            column(CompanyPostcode; CompanyInfo."Post Code")
            {
            }
            column(CompanyCountry; CompanyInfo."Country/Region Code")
            {
            }
            column(CompanyPhone; CompanyInfo."Phone No.")
            {
            }
            column(CompanyEmail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyTRN; CompanyInfo."VAT Registration No.")
            {
            }
            column(CurrentDate; Format(CurrentDateTime, 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(Contract_ID; "BLRContract ID")
            {
            }
            column(Contract_Start_Date; "BLRContract Start Date")
            {
            }
            column(Contract_End_Date; "BLRContract End Date")
            {
            }
            column(Intimation_Date; "BLRIntimation Date")
            {
            }
            column(Termination_Date; "BLRTermination Date")
            {
            }
            column(Original_Contract_Tenure; "BLROriginal Contract Tenure")
            {
            }
            column(Actual_Contract_Tenure; "BLRActual Contract Tenure")
            {
            }
            column(T_I_R; GetTotalReceiptsAmount("BLRContract ID"))
            {
            }
            column(TRA_IV; GetTotalReceiptsAmountIncludingVAT("BLRContract ID"))
            {
            }
            column(TIR_TRAIV; GetTotalReceiptsAmount("BLRContract ID") - GetTotalReceiptsAmountIncludingVAT("BLRContract ID"))
            {
            }
            column(Sec_De; "BLRSecurity Deposit")
            {
            }
            column(Ad_Sec_De; "BLRAdjustment Security Deposit")
            {
            }
            column(Net_Ba; ("BLRSecurity Deposit" - "BLRAdjustment Security Deposit"))
            {
            }
            column(Oth_De; "BLRChiller Deposit" + "BLROther Deposit")
            {
            }
            column(T_Deposit; "BLRSecurity Deposit" + "BLRChiller Deposit" + "BLROther Deposit")
            {
            }
            column(T_RE_Deposit; -(("BLRSecurity Deposit" - "BLRAdjustment Security Deposit") + "BLRChiller Deposit" + "BLROther Deposit"))
            {
            }
            column(Total_Settlement;
            GetRentBalancePending("BLRContract ID") +
                GetTotalReceiptsAmount("BLRContract ID") - GetTotalReceiptsAmountIncludingVAT("BLRContract ID") +
                GetTotalAdditionalCharges("BLRContract ID") +
                -(("BLRSecurity Deposit" - "BLRAdjustment Security Deposit") + "BLRChiller Deposit" + "BLROther Deposit")
            )
            {
            }
            column(Final_Settlement;
            -(GetRentBalancePending("BLRContract ID") +
                GetTotalReceiptsAmount("BLRContract ID") - GetTotalReceiptsAmountIncludingVAT("BLRContract ID") +
                GetTotalAdditionalCharges("BLRContract ID") +
                -(("BLRSecurity Deposit" - "BLRAdjustment Security Deposit") + "BLRChiller Deposit" + "BLROther Deposit"))
            )
            {
            }
            column(Final_Settlement_Words;
            ConvertFinalSettlementToWords(
                    -(GetRentBalancePending("BLRContract ID") +
                      GetTotalReceiptsAmount("BLRContract ID") - GetTotalReceiptsAmountIncludingVAT("BLRContract ID") +
                      GetTotalAdditionalCharges("BLRContract ID") +
                      -(("BLRSecurity Deposit" - "BLRAdjustment Security Deposit") + "BLRChiller Deposit" + "BLROther Deposit"))
                )
            )
            {
            }
            column(Total_AdC; GetTotalAdditionalCharges("BLRContract ID"))
            {
            }
            column(Settlement_Status; GetSettlementStatus())
            {
            }
            dataitem(Customer; Customer)
            {
                DataItemLink = "No." = field("BLRTenant ID");
                column(Name; Name)
                {
                }
                column(Address; Address)
                {
                }
                column(Phone_No_; "Phone No.")
                {
                }
                column(E_Mail; "E-Mail")
                {
                }
                column(VAT_Registration_No_; "VAT Registration No.")
                {
                }
            }
            dataitem("BLRTenancyContract"; "BLRTenancyContract")
            {
                DataItemLink = "BLRContract ID" = field("BLRContract ID");
                column(Property_Name; "BLRProperty Name")
                {
                }
                column(Unit_Name; "BLRUnit Name")
                {
                }
                column(Contract_Tenor; "BLRContract Tenor")
                {
                }
            }
            dataitem("BLRRentCalculateSub"; "BLRRentCalculateSub")
            {
                DataItemLink = "BLRContract ID" = field("BLRContract ID");
                column(Year; BLRYear)
                {
                }
                column(Period_Start_Date; "BLRPeriod Start Date")
                {
                }
                column(Period_End_Date; "BLRPeriod End Date")
                {
                }
                column(Final_Annual_Amount; "BLRFinal Annual Amount")
                {
                }
                column(Per_Day_Rent; "BLRPer Day Rent")
                {
                }
                column(Total_F_A_A; "BLRTotal Final Annual Amount")
                {
                }
            }
            dataitem("BLRPendingReceviableGrid"; "BLRPendingReceviableGrid")
            {
                DataItemLink = "BLRContract ID" = field("BLRContract ID");
                DataItemTableView = where(BLRRevenueDescription = filter('Rent'));
                column(Rev_AIV; BLRRevisedAmountInclVAT)
                {
                }
                column(Rec_AIV; BLRReceiptsAmountInclVAT)
                {
                }
                column(Rent_BP; BLRRevisedAmountInclVAT - BLRReceiptsAmountInclVAT)
                {
                }
            }
            dataitem("BLRAdditionalChargesSub"; "BLRAdditionalChargesSub")
            {
                DataItemLink = "BLRContract ID" = field("BLRContract ID");
                column(Secondary_Item_Type; "BLRSecondary Item Type")
                {
                }
                column(Amount_IV; "BLRAmount Including VAT")
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
        layout("TerminationTemplate.docx")
        {
            Type = Word;
            LayoutFile = './TerminationTemplate.docx';
            Caption = 'TerminationTemplate (Word)';
            Summary = 'The TerminationTemplate (Word) provides a simple layout that is also relatively easy for an end-user to modify.';
        }
    }
    trigger OnInitReport()
    begin
        if not CompanyInfo.Get() then
            Error('Company Information not found.')
        else
            CompanyInfo.CalcFields(Picture)
    end;

    procedure GetSettlementStatus(): Text
    begin
        if FinalCalculation."BLRNetRecvFromTheTenant" > 0 then
            exit('Claim');

        if FinalCalculation."BLRAmount Refundable" > 0 then
            exit('Refund');

        exit(' ');
    end;


    procedure GetTotalReceiptsAmount(ContractID: Integer): Decimal
    var
        PendingReceivableGrid: Record "BLRPendingReceviableGrid";
        TotalAmount: Decimal;
    begin
        PendingReceivableGrid.Reset();
        PendingReceivableGrid.SetRange("BLRContract ID", ContractID);
        PendingReceivableGrid.SetRange("BLRPayment Type", 'Installment');
        if PendingReceivableGrid.FindSet() then
            repeat
                TotalAmount += PendingReceivableGrid.BLRRevisedAmountInclVAT;
            until PendingReceivableGrid.Next() = 0;
        exit(TotalAmount);
    end;

    procedure GetTotalReceiptsAmountIncludingVAT(ContractID: Integer): Decimal
    var
        PendingReceivableGrid: Record "BLRPendingReceviableGrid";
        TotalAmount: Decimal;
    begin
        PendingReceivableGrid.Reset();
        PendingReceivableGrid.SetRange("BLRContract ID", ContractID);
        PendingReceivableGrid.SetRange("BLRPayment Type", 'Installment');
        if PendingReceivableGrid.FindSet() then
            repeat
                TotalAmount += PendingReceivableGrid.BLRReceiptsAmountInclVAT;
            until PendingReceivableGrid.Next() = 0;
        exit(TotalAmount);
    end;

    procedure GetTotalAdditionalCharges(ContractID: Integer): Decimal
    var
        AdditionalChargesGrid: Record "BLRAdditionalChargesSub";
        TotalAmount: Decimal;
    begin
        AdditionalChargesGrid.Reset();
        AdditionalChargesGrid.SetRange("BLRContract ID", ContractID);
        if AdditionalChargesGrid.FindSet() then
            repeat
                TotalAmount += AdditionalChargesGrid."BLRAmount Including VAT";
            until AdditionalChargesGrid.Next() = 0;
        exit(TotalAmount);
    end;

    procedure GetRentBalancePending(ContractID: Integer): Decimal
    var
        PendingReceivableGrid: Record "BLRPendingReceviableGrid";
        TotalPending: Decimal;
    begin
        PendingReceivableGrid.Reset();
        PendingReceivableGrid.SetRange("BLRContract ID", ContractID);
        PendingReceivableGrid.SetRange(BLRRevenueDescription, 'Rent');
        if PendingReceivableGrid.FindFirst() then
            TotalPending := PendingReceivableGrid.BLRRevisedAmountInclVAT - PendingReceivableGrid.BLRReceiptsAmountInclVAT;
        exit(TotalPending);
    end;

    procedure ConvertFinalSettlementToWords(Amount: Decimal): Text
    var
        WholeNumber: Integer;
        Decimals: Integer;
        WholePart: Text;
        DecimalPart: Text;
        FinalText: Text;
    begin
        Amount := Abs(Amount);
        WholeNumber := Round(Amount, 1, '<');
        Decimals := Round((Amount - WholeNumber) * 100, 1);
        WholePart := ConvertNumberToWords(WholeNumber);
        if Decimals > 0 then
            DecimalPart := ' and ' + ConvertNumberToWords(Decimals) + ' fils';
        FinalText := WholePart + DecimalPart + ' Only';
        exit(UpperCaseFirstLetter(FinalText));
    end;

    local procedure UpperCaseFirstLetter(InputText: Text): Text
    var
        FirstChar: Text[1];
        RemainingText: Text;
    begin
        if StrLen(InputText) = 0 then
            exit(InputText);
        FirstChar := Format(UpperCase(InputText[1]));
        RemainingText := CopyStr(InputText, 2);
        exit(FirstChar + RemainingText);
    end;

    local procedure ConvertNumberToWords(Number: Integer): Text
    var
        Ones: array[20] of Text;
        Tens: array[10] of Text;
        Thousands: array[5] of Text;
        N: Integer;
        Result: Text;
    begin
        Ones[1] := 'One';
        Ones[2] := 'Two';
        Ones[3] := 'Three';
        Ones[4] := 'Four';
        Ones[5] := 'Five';
        Ones[6] := 'Six';
        Ones[7] := 'Seven';
        Ones[8] := 'Eight';
        Ones[9] := 'Nine';
        Ones[10] := 'Ten';
        Ones[11] := 'Eleven';
        Ones[12] := 'Twelve';
        Ones[13] := 'Thirteen';
        Ones[14] := 'Fourteen';
        Ones[15] := 'Fifteen';
        Ones[16] := 'Sixteen';
        Ones[17] := 'Seventeen';
        Ones[18] := 'Eighteen';
        Ones[19] := 'Nineteen';
        Tens[2] := 'Twenty';
        Tens[3] := 'Thirty';
        Tens[4] := 'Forty';
        Tens[5] := 'Fifty';
        Tens[6] := 'Sixty';
        Tens[7] := 'Seventy';
        Tens[8] := 'Eighty';
        Tens[9] := 'Ninety';
        Thousands[1] := '';
        Thousands[2] := 'Thousand';
        Thousands[3] := 'Million';
        Thousands[4] := 'Billion';
        N := Number;
        if N = 0 then
            exit('Zero');
        if N div 1000000000 > 0 then begin
            Result += ConvertNumberToWords(N div 1000000000) + ' Billion ';
            N := N mod 1000000000;
        end;
        if N div 1000000 > 0 then begin
            Result += ConvertNumberToWords(N div 1000000) + ' Million ';
            N := N mod 1000000;
        end;
        if N div 1000 > 0 then begin
            Result += ConvertNumberToWords(N div 1000) + ' Thousand ';
            N := N mod 1000;
        end;
        if N div 100 > 0 then begin
            Result += Ones[N div 100] + ' Hundred ';
            N := N mod 100;
        end;
        if N > 0 then
            if N <= 19 then
                Result += Ones[N]
            else begin
                Result += Tens[N div 10];
                if N mod 10 > 0 then
                    Result += ' ' + Ones[N mod 10];
            end;
        exit(Result.Trim());
    end;

    var
        CompanyInfo: Record "Company Information";
}
