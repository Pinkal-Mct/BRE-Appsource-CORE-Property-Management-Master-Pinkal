namespace BREPropertyManagementMargi.BREPropertyManagementMargi;
using Microsoft.Finance.GeneralLedger.Journal;
using Microsoft.Sales.Customer;
using Microsoft.Sales.Receivables;
using Microsoft.Sales.History;
using Microsoft.Foundation.Company;
report 50112 PaymentReceipt
{
    ApplicationArea = All;
    Caption = 'Payment Receipt';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "PaymentReceipt.docx";
    dataset
    {
        dataitem("Payment Mode2"; "Payment Mode2")
        {
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(Receipt__; "Receipt #")
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
            column(Contract_ID; "Contract ID")
            {
            }
            column(Tenant_Name; "Tenant Name")
            {
            }
            column(Tenant_Email; "Tenant Email")
            {
            }
            column(Receipt_Date; Format("Receipt Date", 0, '<Day,2>/<Month,2>/<Year4>'))  // Add a column to hold the current date
            {
            }
            dataitem("Payment Schedule2"; "Payment Schedule2")
            {
                DataItemLink = "Contract ID" = field("Contract ID");
                DataItemTableView = SORTING("Payment Series");
                column(Pay_S; "Payment Mode2"."Payment Series")
                {
                }
                column(I_ID; "Payment Mode2"."Invoice #")
                {
                }
                column(Pay_M; "Payment Mode2"."Payment Mode")
                {
                }
                column(Che_N; "Payment Mode2"."Cheque Number")
                {
                }
                column(Secondary_Item_Type; "Secondary Item Type")
                {
                }
                column(Amount; Amount)
                {
                }
                column(V_A; "VAT Amount")
                {
                }
                column(A_I_V; "Amount Including VAT")
                {
                }
                trigger OnPreDataItem()
                begin
                    SetRange("Payment Series", "Payment Mode2"."Payment Series");
                end;

                trigger OnAfterGetRecord()
                begin
                    TotalAmount += Amount;
                    TotalVATAmount += "VAT Amount";
                    TotalAmountIncludingVAT += "Amount Including VAT";
                end;
            }
            dataitem(TotalSection; System.Utilities.Integer)
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(T_A; TotalAmount)
                {
                }
                column(T_V_A; TotalVATAmount)
                {
                }
                column(T_AIV; TotalAmountIncludingVAT)
                {
                }
                column(AmountInWords; AmountInWordsText)
                {
                }
                trigger OnAfterGetRecord()
                begin
                    AmountToWords(TotalAmountIncludingVAT);
                end;
            }
            dataitem(Customer; Customer)
            {
                DataItemLink = "No." = field("Tenant Id");
                column(Address; Address)
                {
                }
                column(Phone_No_; "Phone No.")
                {
                }
                column(Cus_TRN; "VAT Registration No.")
                {
                }
            }
            dataitem("Tenancy Contract"; "Tenancy Contract")
            {
                DataItemLink = "Contract ID" = field("Contract ID");
                column(Property_Name; "Property Name")
                {
                }
                column(Unit_Name; "Unit Name")
                {
                }
                column(Contract_Tenor; "Contract Tenor")
                {
                }
                column(Contract_Start_Date; "Contract Start Date")
                {
                }
                column(Contract_End_Date; "Contract End Date")
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
        layout("PaymentReceipt.docx")
        {
            Type = Word;
            LayoutFile = './PaymentReceipt.docx';
            Caption = 'PaymentReceipt (Word)';
            Summary = 'The PaymentReceipt (Word) provides a simple layout that is also relatively easy for an end-user to modify.';
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
        TotalAmount: Decimal;
        TotalVATAmount: Decimal;
        TotalAmountIncludingVAT: Decimal;
        AmountInWordsText: Text;

    procedure AmountToWords(Amount: Decimal)
    var
        AmtInWords: Text;
        Ones: array[20] of Text[30];
        Tens: array[10] of Text[30];
        Thousands: array[5] of Text[30];
        DecimalPart: Integer;
        IntegerPart: Integer;
        TensValue: Integer;
        OnesValue: Integer;
        ExponentVal: Integer;
        Hundreds: Integer;
        TensOnes: Integer;
        FinalText: Text;
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
        if Amount = 0 then begin
            AmountInWordsText := 'Zero AED Only';
            exit;
        end;
        AmtInWords := '';
        IntegerPart := Round(Amount, 1, '<');
        DecimalPart := Round((Amount - IntegerPart) * 100, 1);
        if IntegerPart >= 1000000000 then begin
            ExponentVal := IntegerPart div 1000000000;
            IntegerPart := IntegerPart mod 1000000000;
            Hundreds := ExponentVal div 100;
            ExponentVal := ExponentVal mod 100;
            if Hundreds > 0 then
                AmtInWords += Ones[Hundreds] + ' Hundred ';
            if ExponentVal > 0 then
                if ExponentVal < 20 then
                    AmtInWords += Ones[ExponentVal] + ' '
                else begin
                    TensValue := ExponentVal div 10;
                    OnesValue := ExponentVal mod 10;
                    AmtInWords += Tens[TensValue];
                    if OnesValue > 0 then
                        AmtInWords += ' ' + Ones[OnesValue];
                    AmtInWords += ' ';
                end;
            AmtInWords += 'Billion ';
        end;
        if IntegerPart >= 1000000 then begin
            ExponentVal := IntegerPart div 1000000;
            IntegerPart := IntegerPart mod 1000000;
            Hundreds := ExponentVal div 100;
            ExponentVal := ExponentVal mod 100;
            if Hundreds > 0 then
                AmtInWords += Ones[Hundreds] + ' Hundred ';
            if ExponentVal > 0 then
                if ExponentVal < 20 then
                    AmtInWords += Ones[ExponentVal] + ' '
                else begin
                    TensValue := ExponentVal div 10;
                    OnesValue := ExponentVal mod 10;
                    AmtInWords += Tens[TensValue];
                    if OnesValue > 0 then
                        AmtInWords += ' ' + Ones[OnesValue];
                    AmtInWords += ' ';
                end;
            AmtInWords += 'Million ';
        end;
        if IntegerPart >= 1000 then begin
            ExponentVal := IntegerPart div 1000;
            IntegerPart := IntegerPart mod 1000;
            Hundreds := ExponentVal div 100;
            ExponentVal := ExponentVal mod 100;
            if Hundreds > 0 then
                AmtInWords += Ones[Hundreds] + ' Hundred ';
            if ExponentVal > 0 then
                if ExponentVal < 20 then
                    AmtInWords += Ones[ExponentVal] + ' '
                else begin
                    TensValue := ExponentVal div 10;
                    OnesValue := ExponentVal mod 10;
                    AmtInWords += Tens[TensValue];
                    if OnesValue > 0 then
                        AmtInWords += ' ' + Ones[OnesValue];
                    AmtInWords += ' ';
                end;
            AmtInWords += 'Thousand ';
        end;
        Hundreds := IntegerPart div 100;
        TensOnes := IntegerPart mod 100;
        if Hundreds > 0 then
            AmtInWords += Ones[Hundreds] + ' Hundred ';
        if TensOnes > 0 then
            if TensOnes < 20 then
                AmtInWords += Ones[TensOnes] + ' '
            else begin
                TensValue := TensOnes div 10;
                OnesValue := TensOnes mod 10;
                AmtInWords += Tens[TensValue];
                if OnesValue > 0 then
                    AmtInWords += ' ' + Ones[OnesValue];
                AmtInWords += ' ';
            end;
        FinalText := DelChr(AmtInWords, '>', ' ');
        if DecimalPart > 0 then
            if DecimalPart < 20 then
                FinalText += ' and ' + Ones[DecimalPart] + ' Fils'
            else begin
                TensValue := DecimalPart div 10;
                OnesValue := DecimalPart mod 10;
                FinalText += ' and ' + Tens[TensValue];
                if OnesValue > 0 then
                    FinalText += ' ' + Ones[OnesValue];
                FinalText += ' Fils';
            end;
        AmountInWordsText := FinalText + ' Only';
    end;
}
