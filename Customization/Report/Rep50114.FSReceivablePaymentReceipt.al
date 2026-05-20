namespace BREPropertyManagementMargi.BREPropertyManagementMargi;
using Microsoft.Foundation.Company;
using Microsoft.Sales.Customer;
using System.Text;
report 73209581 FS_Receivable_PaymentReceipt
{
    ApplicationArea = All;
    Caption = 'FS_Receivable_PaymentReceipt';
    UsageCategory = ReportsAndAnalysis;
    DefaultRenderingLayout = "FS_Receivable_PaymentReceipt.docx";
    dataset
    {
        dataitem(FinalSettlement; FinalSettlement)
        {
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(Receipt__; "Payment Receipt")
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
            column(CurrentDate; Format(CurrentDateTime, 0, '<Day,2>/<Month,2>/<Year4>'))  // Add a column to hold the current date
            {
            }
            column(Contract_ID; "Contract ID")
            {
            }
            column(Payment_mode; "Receivable Payment mode")
            {
            }
            column(Cheque_No_; "Receivable Cheque No.")
            {
            }
            column(Total_Amount; "Receivable Total Amount")
            {
            }
            column(Invoice_ID; "Invoice ID")
            {
            }
            column(Final_Settlement_Words; ConvertFinalSettlementToWords("Receivable Total Amount"))
            {
            }
            // column(Contract_Start_Date; "Contract Start Date")
            // {
            // }
            // column(Contract_End_Date; "Contract End Date")
            // {
            // }
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
                column(VAT_Registration_No_; "VAT Registration No.")
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
            }
            dataitem("Final Calculation"; "Final Calculation")
            {
                DataItemLink = "Contract ID" = field("Contract ID");
                column(Contract_Start_Date; "Contract Start Date")
                {
                }
                column(Contract_End_Date; "Contract End Date")
                {
                }
                // column(Payment_mode; "Receivable Payment mode")
                // {
                // }
                // column(Cheque_No_; "Receivable Cheque No.")
                // {
                // }
                // column(Total_Amount; "Receivable Total Amount")
                // {
                // }
                // column(AmountInWords; AmountInWordsText)
                // {
                // }
                // trigger OnAfterGetRecord()
                // begin
                //     // Convert amount to words and store in variable
                //     AmountToWords("Receivable Total Amount");
                // end;
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
        layout("FS_Receivable_PaymentReceipt.docx")
        {
            Type = Word;
            LayoutFile = './FS_Receivable_PaymentReceipt.docx';
            Caption = 'FS_Receivable_PaymentReceipt (Word)';
            Summary = 'The FS_Receivable_PaymentReceipt (Word) provides a simple layout that is also relatively easy for an end-user to modify.';
        }
    }
    trigger OnInitReport()
    begin
        if not CompanyInfo.Get() then begin
            Error('Company Information not found.');
        end else begin
            // CompanyAddress := CompanyInfo.City + ', ' + CompanyInfo.County + ' ' + CompanyInfo."Post Code";
            CompanyInfo.CalcFields(Picture);
        end;
    end;

    var
        CompanyInfo: Record "Company Information";
        TotalAmountInclVAT: Decimal;
        AutoFormat: Codeunit "Auto Format";

    // Function to convert number to words
    procedure ConvertFinalSettlementToWords(Amount: Decimal): Text
    var
        WholeNumber: Integer;
        Decimals: Integer;
        WholePart: Text;
        DecimalPart: Text;
        FinalText: Text;
    begin
        // Take absolute value to handle negative amounts
        Amount := Abs(Amount);

        // Split into whole number and decimal parts
        WholeNumber := Round(Amount, 1, '<');  // Rounds down to nearest integer
        Decimals := Round((Amount - WholeNumber) * 100, 1);

        // Convert whole number to words
        WholePart := ConvertNumberToWords(WholeNumber);

        // Convert decimal part to words if exists
        if Decimals > 0 then begin
            DecimalPart := ' and ' + ConvertNumberToWords(Decimals) + ' fils';
        end;

        // Combine whole and decimal parts, and add 'Only'
        FinalText := WholePart + DecimalPart + ' Only';

        // Ensure first letter is capitalized
        exit(UpperCaseFirstLetter(FinalText));
    end;

    local procedure UpperCaseFirstLetter(InputText: Text): Text
    var
        FirstChar: Text[1];
        RemainingText: Text;
    begin
        if StrLen(InputText) = 0 then
            exit(InputText);

        FirstChar := UpperCase(InputText[1]);
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
        // Initialize arrays for number words
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

        // Handle zero
        if N = 0 then
            exit('Zero');

        // Process billions
        if N div 1000000000 > 0 then begin
            Result += ConvertNumberToWords(N div 1000000000) + ' Billion ';
            N := N mod 1000000000;
        end;

        // Process millions
        if N div 1000000 > 0 then begin
            Result += ConvertNumberToWords(N div 1000000) + ' Million ';
            N := N mod 1000000;
        end;

        // Process thousands
        if N div 1000 > 0 then begin
            Result += ConvertNumberToWords(N div 1000) + ' Thousand ';
            N := N mod 1000;
        end;

        // Process hundreds
        if N div 100 > 0 then begin
            Result += Ones[N div 100] + ' Hundred ';
            N := N mod 100;
        end;

        // Process tens and ones
        if N > 0 then begin
            if N <= 19 then
                Result += Ones[N]
            else begin
                Result += Tens[N div 10];
                if N mod 10 > 0 then
                    Result += ' ' + Ones[N mod 10];
            end;
        end;

        exit(Result.Trim());
    end;

}
