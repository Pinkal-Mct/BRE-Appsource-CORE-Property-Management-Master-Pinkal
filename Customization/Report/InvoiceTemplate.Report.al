namespace PropertyManagement.PropertyManagement;
using Microsoft.Foundation.Company;
using Microsoft.Sales.Document;
using System.Text;
using Microsoft.Sales.History;
using Microsoft.Bank.Check;
report 73209583 BLRInvoiceTemplate
{
    ApplicationArea = All;
    Caption = 'InvoiceTemplate';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "SalesInvoiceTemplate.docx";
    dataset
    {
        dataitem(SalesHeader; "Sales Header")
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
            column(No_; InvoiceNo)
            {
            }
            column(Posting_Date; Format("Posting Date", 0, '<Day,2>/<Month,2>/<Year4>'))
            {
            }
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            {
            }
            column(Bill_to_Address; "Bill-to Address")
            {
            }
            column(Sell_to_Phone_No_; "Sell-to Phone No.")
            {
            }
            column(Sell_to_E_Mail; "Sell-to E-Mail")
            {
            }
            column(VAT_Registration_No_; "VAT Registration No.")
            {
            }
            column(Contract_ID; "BLRContract ID")
            {
            }
            column(Document_Date; "Document Date")
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
            column(Customer_P_O; "BLRCustomer P.O")
            {
            }
            column(Customer_P_O_Date; "BLRCustomer P.O Date")
            {
            }
            column(Contract_Period; "BLRContract Period")
            {
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
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                column(Serial_No; SerialNo)
                {
                }
                column(SaleLineNo_; "No.")
                {
                }
                column(Description; Description)
                {
                }
                column(Line_Amount; "Line Amount")
                {
                }
                column(VAT_Base_Amount; "VAT Base Amount")
                {
                }
                column(Amount_Including_VAT; "Amount Including VAT")
                {
                }
                column(VAT__; "VAT %")
                {
                }
                column(Amount; Amount)
                {
                }
                column(VAT_Amount; VATAmount)
                {
                }
                trigger OnAfterGetRecord()
                begin
                    LineAmountText := Format("Line Amount");
                    VATAmount := "Amount Including VAT" - Amount;
                    TotalDue += "Amount Including VAT";
                    TotalSubTotal += "Amount Including VAT";
                    TotalInvDiscAmount -= "Inv. Discount Amount";
                    TotalVATBaseAmount += "VAT Base Amount";
                    TotalAmountVAT += "Amount Including VAT" - Amount;
                    TotalAmountInclVAT += "Amount Including VAT";
                    SerialNo := SerialNo + 1;
                end;

                trigger OnPreDataItem()
                begin
                    // Initialize Serial No. at the start of the dataitem
                    SerialNo := 0;
                end;
            }
            dataitem(Totals; System.Utilities.Integer)
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(TotalSubTotal; Format(TotalSubTotal, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, SalesHeader."Currency Code")))
                { }
                column(TotalInvDiscAmount; Format(TotalInvDiscAmount, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, SalesHeader."Currency Code")))
                { }
                column(TotalAmount; Format(TotalAmount, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, SalesHeader."Currency Code")))
                { }
                column(TotalAmountVAT; Format(TotalAmountVAT, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, SalesHeader."Currency Code")))
                { }
                column(TotalAmountInclVAT; Format(TotalAmountInclVAT, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, SalesHeader."Currency Code")))
                { }
                column("TotalDue"; Format(TotalDue, 0, AutoFormat.ResolveAutoFormat("Auto Format"::AmountFormat, SalesHeader."Currency Code")))
                { }
                column(AmountInWords; AmountInWordsText)
                {
                }
                trigger OnAfterGetRecord()
                begin
                    AmountToWords(TotalAmountInclVAT);
                end;
            }
            trigger OnAfterGetRecord()
            var
                salesInvHeader: Record "Sales Invoice Header";
            begin
                salesInvHeader.SetRange("Pre-Assigned No.", SalesHeader."No.");
                if salesInvHeader.FindFirst() then
                    InvoiceNo := salesInvHeader."No."
                else
                    InvoiceNo := SalesHeader."No.";
            end;
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
        layout("SalesInvoiceTemplate.docx")
        {
            Type = Word;
            LayoutFile = './SalesInvoiceTemplate.docx';
            Caption = 'SalesInvoiceTemplate (Word)';
            Summary = 'The SalesInvoiceTemplate (Word) provides a simple layout that is also relatively easy for an end-user to modify.';
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
        LineAmountText: Text;
        TotalDue: Decimal;
        TotalSubTotal: Decimal;
        TotalInvDiscAmount: Decimal;
        TotalAmount: Decimal;
        TotalAmountVAT: Decimal;
        TotalAmountInclVAT: Decimal;
        SerialNo: Integer;
        AmountInWordsText: Text;
        InvoiceNo: Code[20];
        TotalVATBaseAmount: Decimal;
        VATAmount: Decimal;

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
