namespace BREPropertyManagementMargi.BREPropertyManagementMargi;
using Microsoft.Foundation.Company;
using Microsoft.Sales.Document;
using Microsoft.Sales.Customer;
using System.Text;
report 73209592 "Terminated Credit Note"
{
    ApplicationArea = All;
    Caption = 'Terminated Credit Note';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "TerminatedCreditNote.docx";
    dataset
    {
        dataitem(CreditNote; "Credit Note")
        {
            column(CurrentDate; Format(CurrentDateTime, 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
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
            column(BankAccountName; CompanyInfo."Bank Name")
            {
            }
            column(BankAccountNo; CompanyInfo."Bank Account No.")
            {
            }
            column(BankIBAN; CompanyInfo.IBAN)
            {
            }
            column(BankSwiftCode; CompanyInfo."SWIFT Code")
            {
            }
            column(BankBranch; CompanyInfo."Bank Branch No.")
            {
            }
            column(Contract_ID; "Contract ID")
            {
            }
            column(Contract_Start_Date; "Contract Start Date")
            {
            }
            column(Contract_End_Date; "Contract End Date")
            {
            }
            column(Credit_Note_No_; "Credit Note No.")
            {
            }
            dataitem("Billing Calculation CN"; "Billing Calculation CN")
            {
                DataItemLink = "Contract ID" = field("Contract ID");
                column(Serial_No; SerialNo)
                {
                }
                column(Item; Item)
                {
                }
                column(Amount; Amount)
                {
                }
                column(VAT_Amount; "VAT Amount")
                {
                }
                column(AInVAT; "Amount Including VAT")
                {
                }
                column(VAT__; "VAT %")
                {
                }
                trigger OnAfterGetRecord()
                begin
                    SerialNo := SerialNo + 1;
                    TotalAmountInclVAT += "Amount Including VAT";
                end;

                trigger OnPreDataItem()
                begin
                    SerialNo := 0;
                end;
            }
            dataitem(Totals; System.Utilities.Integer)
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(TAInclVAT; Format(TotalAmountInclVAT, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, "Billing Calculation CN".SystemId)))
                { }
                column(AmountInWords; AmountInWordsText)
                {
                }
                trigger OnAfterGetRecord()
                begin
                    AmountToWords(TotalAmountInclVAT);
                end;
            }
            dataitem("Tenancy Contract"; "Tenancy Contract")
            {
                DataItemLink = "Contract ID" = field("Contract ID");
                column(Property_Name; "Property Name")
                {
                }
                column(unit_Name; "Unit Name")
                {
                }
                column(Contract_Tenor; "Contract Tenor")
                {
                }
            }
            dataitem(Customer; Customer)
            {
                DataItemLink = "No." = field("Tenant ID");
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
                column(Cus_TRN; "VAT Registration No.")
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
        layout("TerminatedCreditNote.docx")
        {
            Type = Word;
            LayoutFile = './TerminatedCreditNote.docx';
            Caption = 'TerminatedCreditNote (Word)';
            Summary = 'The TerminatedCreditNote (Word) provides a simple layout that is also relatively easy for an end-user to modify.';
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
        AutoFormat: Codeunit "Auto Format";
        SerialNo: Integer;
        TotalAmountInclVAT: Decimal;
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
