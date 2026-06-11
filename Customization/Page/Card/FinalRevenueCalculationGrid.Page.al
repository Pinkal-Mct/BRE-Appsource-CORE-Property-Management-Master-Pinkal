page 73209693 "BLRFinalRevenueCalculationGrid"
{
    PageType = ListPart;
    ApplicationArea = All;
    Caption = 'Final Revenue Calculation Grid';
    SourceTable = "BLRFinalRevenueCalculationGrid";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Revenue Description"; Rec."BLRRevenue Description")
                {
                    ApplicationArea = All;
                    Caption = 'Revenue Description';
                    ToolTip = 'Specifies the description of the revenue item';
                    Editable = false;
                }
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Caption = 'Contract ID';
                    Editable = false;
                    ToolTip = 'The Contract ID is auto-generated and not editable.';
                    Visible = false;
                }
                field("Entry No."; Rec."BLREntry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                    Editable = false;
                    ToolTip = 'The unique entry number for the final revenue calculation entry.';
                    Visible = false;
                }
                field("Original Amount"; Rec."BLROriginal Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Original Amount';
                    ToolTip = 'Specifies the original amount';
                    Editable = false;
                }
                field("Original VAT"; Rec."BLROriginal VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Original VAT';
                    ToolTip = 'Specifies the original VAT amount';
                    Editable = false;
                }
                field("Original Amount Incl."; Rec."BLROriginal Amount Incl.")
                {
                    ApplicationArea = All;
                    Caption = 'Original Amount Incl.';
                    ToolTip = 'Specifies the original amount including VAT';
                    Editable = false;
                }
                field("Revised Amount"; Rec."BLRRevised Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Revised Amount';
                    ToolTip = 'Specifies the revised amount after recalculation';
                    Editable = false;
                }
                field("Revised VAT"; Rec."BLRRevised VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Revised VAT';
                    ToolTip = 'Specifies the revised VAT amount';
                    Editable = false;
                }
                field("Revised Amount Incl."; Rec."BLRRevised Amount Incl.")
                {
                    ApplicationArea = All;
                    Caption = 'Revised Amount Incl.';
                    ToolTip = 'Specifies the revised amount including VAT';
                    Editable = false;
                }
                field("Difference Amount"; Rec."BLRDifference Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Difference Amount';
                    ToolTip = 'Specifies the difference in amount';
                    Editable = false;
                }
                field("Difference VAT"; Rec."BLRDifference VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Difference VAT';
                    ToolTip = 'Specifies the difference in VAT';
                    Editable = false;
                }
                field("Difference Amount Incl."; Rec."BLRDifference Amount Incl.")
                {
                    ApplicationArea = All;
                    Caption = 'Difference Amount Incl.';
                    ToolTip = 'Specifies the difference in amount including VAT';
                    Editable = false;
                }
                field("Actual Contract Tenure"; Rec."BLRActual Contract Tenure")
                {
                    ApplicationArea = All;
                    Caption = 'Actual Contract Tenure';
                    Editable = false;
                    ToolTip = 'Actual Contract Tenure';
                    Visible = false;
                }
                field("Per Day Rent"; Rec."BLRPer Day Rent")
                {
                    ApplicationArea = All;
                    Caption = 'Per Day Rent';
                    Editable = false;
                    ToolTip = 'Per Day Rent';
                    Visible = false;
                }
                field("Revised VAT %"; Rec."BLRRevised VAT %")
                {
                    ApplicationArea = All;
                    Caption = 'Reviseed VAT %';
                    Editable = false;
                    ToolTip = 'Revised VAT %';
                    Visible = false;
                }
                field("ContractYear(Termination Date)"; Rec."BLRContYearTermDate")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Year On Termination Date';
                    ToolTip = 'Enter the ContractYear(Termination Date).';
                    Editable = false;
                    Visible = false;
                }
                field("Annual Rent Amount TermiYear"; Rec."BLRAnnualRentAmtTermiYear")
                {
                    ApplicationArea = All;
                    Caption = 'Annual Rent Amount of Termination Year';
                    Editable = false;
                    ToolTip = 'Annual Rent Amount of Termination Year';
                    Visible = false;
                }
                field("Total No. Of Days"; Rec."BLRTotal No. Of Days")
                {
                    ApplicationArea = All;
                    Caption = 'Total No. Of Days(Termination Year)';
                    ToolTip = 'Enter the Total No. Of Days.';
                    Editable = false;
                    Visible = false;
                }
                field("BLRPaymentType"; Rec."BLRPayment Type")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Type';
                    Editable = false;
                    ToolTip = 'Payment Type';
                    Visible = false;
                }

            }
            group("")
            {
                grid(SummaryGrid)
                {
                    GridLayout = Columns;
                    group("Original Values")
                    {
                        field("Total Original Amount"; Rec."BLRTotal Original Amount")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Original Amount';
                            Editable = false;
                            ToolTip = 'Total Original Amount';
                        }
                        field("Total Original VAT"; Rec."BLRTotal Original VAT")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Original VAT';
                            Editable = false;
                            ToolTip = 'Total Original VAT';
                        }

                        field("Total Orgininal AmountIncl.VAT"; Rec."BLRTotalOrigAmtInclVAT")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Orgininal Amount Incl. VAT';
                            Editable = false;
                            ToolTip = 'Total Orgininal Amount Incl. VAT';
                        }
                    }
                    group("Revised Values")
                    {
                        field("Total Revised Amount"; Rec."BLRTotal Revised Amount")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Revised Amount';
                            Editable = false;
                            ToolTip = 'Total Revised Amount';
                        }
                        field("Total Revised VAT"; Rec."BLRTotal Revised VAT")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Revised VAT';
                            Editable = false;
                            ToolTip = 'Total Revised VAT';
                        }
                        field("Total Revised AmountIncl.VAT"; Rec."BLRTotalRevAmtInclVAT")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Revised Amount Incl. VAT';
                            Editable = false;
                            ToolTip = 'Total Revised Amount Incl. VAT';
                        }
                    }
                    group("Difference Values")
                    {
                        field("Total Difference Amount"; Rec."BLRTotal Difference Amount")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Difference Amount';
                            Editable = false;
                            ToolTip = 'Total Difference Amount';
                        }
                        field("Total Difference VAT"; Rec."BLRTotal Difference VAT")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Differnece VAT';
                            Editable = false;
                            ToolTip = 'Total Difference VAT';
                        }
                        field("Total DifferenceAmountIncl.VAT"; Rec."BLRTotalDiffAmtInclVAT")
                        {
                            ApplicationArea = All;
                            Caption = 'Total Difference Amount Incl. VAT';
                            Editable = false;
                            ToolTip = 'Total Difference Amount Incl. VAT';
                        }
                    }
                }
            }
        }
    }



    ////////////// END 6 ///////////////////////
}