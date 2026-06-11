page 73209715 "BLRPendingRecevieableGrid"
{
    PageType = ListPart;
    SourceTable = "BLRPendingReceviableGrid";
    ApplicationArea = All;
    Caption = 'Pending Receivable/Payable List';
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ToolTip = 'The unique identifier for the contract.';
                    ApplicationArea = All;
                    Caption = 'Contract ID';
                    Editable = false;
                    Visible = false;
                }
                field("Entry No"; Rec."BLREntry No")
                {
                    ToolTip = 'The unique identifier for the entry.';
                    Caption = 'Entry No.';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field(RevenueDescription; Rec.BLRRevenueDescription)
                {
                    ToolTip = 'The description of the revenue item.';
                    ApplicationArea = All;
                    Caption = 'Revenue Description';
                    Editable = false;
                }
                field(RevisedAmount; Rec.BLRRevisedAmount)
                {
                    ToolTip = 'The revised amount for the revenue item.';
                    ApplicationArea = All;
                    Caption = 'Revised Amount';
                    Editable = false;
                }
                field(RevisedVAT; Rec.BLRRevisedVAT)
                {
                    ToolTip = 'The VAT applied to the revised amount.';
                    ApplicationArea = All;
                    Caption = 'Revised VAT';
                    Editable = false;
                }
                field(RevisedAmountInclVAT; Rec.BLRRevisedAmountInclVAT)
                {
                    ToolTip = 'The revised amount including VAT.';
                    ApplicationArea = All;
                    Caption = 'Revised Amount Incl. VAT';
                    Editable = false;
                }
                field(ReceiptsAmount; Rec.BLRReceiptsAmount)
                {
                    ToolTip = 'The total amount received for the revenue item.';
                    ApplicationArea = All;
                    Caption = 'Receipts Amount';
                    Editable = false;
                }
                field(ReceiptsVAT; Rec.BLRReceiptsVAT)
                {
                    ToolTip = 'The VAT applied to the receipts amount.';
                    ApplicationArea = All;
                    Caption = 'Receipts VAT';
                    Editable = false;
                }
                field(ReceiptsAmountInclVAT; Rec.BLRReceiptsAmountInclVAT)
                {
                    ToolTip = 'The total amount received including VAT.';
                    ApplicationArea = All;
                    Caption = 'Receipts Amount Incl. VAT';
                    Editable = false;
                }
                field(DifferenceAmount; Rec.BLRDifferenceAmount)
                {
                    ToolTip = 'The difference between the revised amount and the receipts amount.';
                    ApplicationArea = All;
                    Caption = 'Difference Amount';
                    Editable = false;
                }
                field(DifferenceVAT; Rec.BLRDifferenceVAT)
                {
                    ToolTip = 'The difference in VAT between the revised amount and the receipts amount.';
                    ApplicationArea = All;
                    Caption = 'Difference VAT';
                    Editable = false;
                }
                field(DifferenceAmountInclVAT; Rec.BLRDifferenceAmountInclVAT)
                {
                    ToolTip = 'The difference in total amount including VAT between the revised amount and the receipts amount.';
                    ApplicationArea = All;
                    Caption = 'Difference Amount Incl. VAT';
                    Editable = false;
                }
                field("Termination Date"; Rec."BLRTermination Date")
                {
                    ToolTip = 'The date when the contract is terminated.';
                    ApplicationArea = All;
                    Caption = 'Termination Date';
                    Editable = false;
                    Visible = false;
                }
                field("BLRPaymentType"; Rec."BLRPayment Type")
                {
                    ToolTip = 'The type of payment associated with the revenue item.';
                    ApplicationArea = All;
                    Caption = 'Payment Type';
                    Editable = false;
                    Visible = false;
                }
                field("CrditNoteID Security Deposit"; Rec."BLRCrditNoteIDSecDep")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Note ID Security Deposit';
                    Editable = false;
                    ToolTip = 'The ID of the credit note created for the security deposit.';

                    trigger OnDrillDown()
                    var
                        postedsalesinvoice: Record "Sales Cr.Memo Header";
                    begin
                        postedsalesinvoice.SetRange("No.", Rec."BLRCrditNoteIDSecDep");
                        if postedsalesinvoice.FindFirst() then
                            PAGE.Run(PAGE::"Posted Sales Credit Memo", postedsalesinvoice);

                    end;

                }
                field(GeneratedCRMemoSD; Rec."BLRGeneratedCRMemoSD")
                {
                    ApplicationArea = All;
                    Caption = 'Generated CR Memo SD';
                    Editable = false;
                    Visible = false;
                    ToolTip = 'Indicates whether a credit memo for the security deposit has been generated.';
                }
            }
            group(" ")
            {
                grid(SummaryGrid)
                {
                    GridLayout = Columns;
                    group("Revised Values")
                    {
                        field("Total Revised Amount"; Rec."BLRTotal Revised Amount")
                        {
                            ToolTip = 'The total revised amount for the revenue item.';
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total Revised VAT"; Rec."BLRTotal Revised VAT")
                        {
                            ToolTip = 'The total VAT applied to the revised amount.';
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total Revised AmountIncl. VAT"; Rec."BLRTotalRevAmtInclVAT")
                        {
                            ToolTip = 'The total revised amount including VAT.';
                            ApplicationArea = All;
                            Editable = false;
                        }
                    }
                    group("Receipts Values")
                    {
                        field("Total Receipts Amount"; Rec."BLRTotal Receipts Amount")
                        {
                            ToolTip = 'The total amount received for the revenue item.';
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total Receipts VAT"; Rec."BLRTotal Receipts VAT")
                        {
                            ToolTip = 'The total VAT applied to the receipts amount.';
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total Receipts AmountIncl. VAT"; Rec."BLRTotalRcptsAmtInclVAT")
                        {
                            ToolTip = 'The total amount received including VAT.';
                            ApplicationArea = All;
                            Editable = false;
                        }
                    }
                    group("Difference & Summary")
                    {
                        // field("Total Difference Amount"; Rec."Total Difference Amount")
                        // {
                        //     ToolTip = 'The total difference between the revised amount and the receipts amount.';
                        //     ApplicationArea = All;
                        //     Editable = false;
                        //     Caption = 'Total Difference Amount';
                        // }
                        // field("Total Difference VAT"; Rec."Total Difference VAT")
                        // {
                        //     ToolTip = 'The total difference in VAT between the revised amount and the receipts amount.';
                        //     ApplicationArea = All;
                        //     Editable = false;
                        //     Caption = 'Total Difference VAT';
                        // }
                        // field("Total DifferenceAmountIncl.VAT"; Rec."Total DifferenceAmountIncl.VAT")
                        // {
                        //     ToolTip = 'The total difference in total amount including VAT between the revised amount and the receipts amount.';
                        //     ApplicationArea = All;
                        //     Editable = false;
                        //     Caption = 'Total Difference Amount Incl. VAT';
                        // }
                        field("Total Refundable"; Rec."BLRTotal Refundable")
                        {
                            ToolTip = 'The total refundable amount based on the difference in amounts.';
                            ApplicationArea = All;
                            Editable = false;
                        }
                        field("Total Receivable"; Rec."BLRTotal Receivable")
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








}