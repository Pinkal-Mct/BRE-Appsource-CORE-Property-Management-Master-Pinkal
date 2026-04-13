page 50952 "Pending Recevieable Grid"
{
    PageType = ListPart;
    SourceTable = "Pending Receviable Grid";
    ApplicationArea = All;
    Caption = 'Pending Receivable/Payable List';
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Contract ID"; Rec."Contract ID")
                {
                    ToolTip = 'The unique identifier for the contract.';
                    ApplicationArea = All;
                    Caption = 'Contract ID';
                    Editable = false;
                    Visible = false;
                }
                field("Entry No"; Rec."Entry No")
                {
                    ToolTip = 'The unique identifier for the entry.';
                    Caption = 'Entry No.';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field(RevenueDescription; Rec.RevenueDescription)
                {
                    ToolTip = 'The description of the revenue item.';
                    ApplicationArea = All;
                    Caption = 'Revenue Description';
                    Editable = false;
                }
                field(RevisedAmount; Rec.RevisedAmount)
                {
                    ToolTip = 'The revised amount for the revenue item.';
                    ApplicationArea = All;
                    Caption = 'Revised Amount';
                    Editable = false;
                }
                field(RevisedVAT; Rec.RevisedVAT)
                {
                    ToolTip = 'The VAT applied to the revised amount.';
                    ApplicationArea = All;
                    Caption = 'Revised VAT';
                    Editable = false;
                }
                field(RevisedAmountInclVAT; Rec.RevisedAmountInclVAT)
                {
                    ToolTip = 'The revised amount including VAT.';
                    ApplicationArea = All;
                    Caption = 'Revised Amount Incl. VAT';
                    Editable = false;
                }
                field(ReceiptsAmount; Rec.ReceiptsAmount)
                {
                    ToolTip = 'The total amount received for the revenue item.';
                    ApplicationArea = All;
                    Caption = 'Receipts Amount';
                    Editable = false;
                }
                field(ReceiptsVAT; Rec.ReceiptsVAT)
                {
                    ToolTip = 'The VAT applied to the receipts amount.';
                    ApplicationArea = All;
                    Caption = 'Receipts VAT';
                    Editable = false;
                }
                field(ReceiptsAmountInclVAT; Rec.ReceiptsAmountInclVAT)
                {
                    ToolTip = 'The total amount received including VAT.';
                    ApplicationArea = All;
                    Caption = 'Receipts Amount Incl. VAT';
                    Editable = false;
                }
                field(DifferenceAmount; Rec.DifferenceAmount)
                {
                    ToolTip = 'The difference between the revised amount and the receipts amount.';
                    ApplicationArea = All;
                    Caption = 'Difference Amount';
                    Editable = false;
                }
                field(DifferenceVAT; Rec.DifferenceVAT)
                {
                    ToolTip = 'The difference in VAT between the revised amount and the receipts amount.';
                    ApplicationArea = All;
                    Caption = 'Difference VAT';
                    Editable = false;
                }
                field(DifferenceAmountInclVAT; Rec.DifferenceAmountInclVAT)
                {
                    ToolTip = 'The difference in total amount including VAT between the revised amount and the receipts amount.';
                    ApplicationArea = All;
                    Caption = 'Difference Amount Incl. VAT';
                    Editable = false;
                }
                field("Termination Date"; Rec."Termination Date")
                {
                    ToolTip = 'The date when the contract is terminated.';
                    ApplicationArea = All;
                    Caption = 'Termination Date';
                    Editable = false;
                    Visible = false;
                }
                field("Payment Type"; Rec."Payment Type")
                {
                    ToolTip = 'The type of payment associated with the revenue item.';
                    ApplicationArea = All;
                    Caption = 'Payment Type';
                    Editable = false;
                    Visible = false;
                }
            }
            group(" ")
            {
                grid(SummaryGrid)
                {
                    GridLayout = Columns;
                    group("Revised Values")
                    {
                        field("Total Revised Amount"; Rec."Total Revised Amount")
                        {
                            ToolTip = 'The total revised amount for the revenue item.';
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total Revised VAT"; Rec."Total Revised VAT")
                        {
                            ToolTip = 'The total VAT applied to the revised amount.';
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total Revised AmountIncl. VAT"; Rec."Total Revised AmountIncl. VAT")
                        {
                            ToolTip = 'The total revised amount including VAT.';
                            ApplicationArea = All;
                            Editable = false;
                        }
                    }
                    group("Receipts Values")
                    {
                        field("Total Receipts Amount"; Rec."Total Receipts Amount")
                        {
                            ToolTip = 'The total amount received for the revenue item.';
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total Receipts VAT"; Rec."Total Receipts VAT")
                        {
                            ToolTip = 'The total VAT applied to the receipts amount.';
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total Receipts AmountIncl. VAT"; Rec."Total Receipts AmountIncl. VAT")
                        {
                            ToolTip = 'The total amount received including VAT.';
                            ApplicationArea = All;
                            Editable = false;
                        }
                    }
                    group("Difference & Summary")
                    {
                        field("Total Difference Amount"; Rec."Total Difference Amount")
                        {
                            ToolTip = 'The total difference between the revised amount and the receipts amount.';
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total Difference VAT"; Rec."Total Difference VAT")
                        {
                            ToolTip = 'The total difference in VAT between the revised amount and the receipts amount.';
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total DifferenceAmountIncl.VAT"; Rec."Total DifferenceAmountIncl.VAT")
                        {
                            ToolTip = 'The total difference in total amount including VAT between the revised amount and the receipts amount.';
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total Refundable"; Rec."Total Refundable")
                        {
                            ToolTip = 'The total refundable amount based on the difference in amounts.';
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total Receivable"; Rec."Total Receivable")
                        {
                            ToolTip = 'The total receivable amount based on the difference in amounts.';
                            ApplicationArea = All;
                            Editable = false;
                        }
                    }
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
    begin
        FetchDataFromRevenueCalcGrid();
        Recvieableamountfrompaymentscheule();
        DifferenceAmountCalculation();
        GetpositiveAmount();
    end;

    procedure FetchDataFromRevenueCalcGrid()
    var
        RevenueGrid: Record "Final Revenue Calculation Grid";
    begin
        RevenueGrid.SetRange("Contract ID", Rec."Contract ID");
        RevenueGrid.SetRange("Revenue Description", Rec.RevenueDescription);
        if RevenueGrid.FindSet() then
            repeat
                Rec.RevisedAmount := RevenueGrid."Revised Amount";
                Rec.RevisedVAT := RevenueGrid."Revised VAT";
                Rec.RevisedAmountInclVAT := RevenueGrid."Revised Amount Incl.";
                Rec.Modify();
            until RevenueGrid.Next() = 0;
    end;

    procedure Recvieableamountfrompaymentscheule()
    var
        PaymentScheduleRec: Record "Payment Schedule2";
        Totalamount: Decimal;
        VATAmount: Decimal;
        AmountIncVAT: Decimal;
    begin
        Totalamount := 0;
        PaymentScheduleRec.Reset();
        PaymentScheduleRec.SetRange("Contract ID", Rec."Contract ID");
        PaymentScheduleRec.SetFilter("Due Date", '<=%1', Rec."Termination Date");
        PaymentScheduleRec.SetRange("Payment Status", 'Received');
        PaymentScheduleRec.SetRange("Secondary Item Type", Rec.RevenueDescription);
        if PaymentScheduleRec.FindSet() then
            repeat
                Totalamount += PaymentScheduleRec.Amount;
                VATAmount += PaymentScheduleRec."VAT Amount";
                AmountIncVAT += PaymentScheduleRec."Amount Including VAT";
            until PaymentScheduleRec.Next() = 0;
        PaymentScheduleRec.SetRange("Contract ID", Rec."Contract ID");
        PaymentScheduleRec.SetRange("Secondary Item Type", Rec.RevenueDescription);
        if PaymentScheduleRec.FindSet() then
            repeat
                Rec.ReceiptsAmount := Totalamount;
                Rec.ReceiptsVAT := VATAmount;
                Rec.ReceiptsAmountInclVAT := AmountIncVAT;
                Rec.Modify();
            until PaymentScheduleRec.Next() = 0;
    end;

    procedure DifferenceAmountCalculation()
    var
    begin
        Rec."DifferenceAmount" := Rec.RevisedAmount - Rec.ReceiptsAmount;
        Rec."DifferenceVAT" := Rec.RevisedVAT - Rec.ReceiptsVAT;
        Rec.DifferenceAmountInclVAT := Rec.RevisedAmountInclVAT - Rec.ReceiptsAmountInclVAT;
        Rec.Modify();
    end;

    procedure GetpositiveAmount()
    begin
        if Rec."Total DifferenceAmountIncl.VAT" < 0 then begin
            Rec."Total Refundable" := Abs(Rec."Total DifferenceAmountIncl.VAT");
            Rec.Modify();
        end else begin
            Rec."Total Receivable" := Rec."Total DifferenceAmountIncl.VAT";
            Rec.Modify();
        end;
    end;
}