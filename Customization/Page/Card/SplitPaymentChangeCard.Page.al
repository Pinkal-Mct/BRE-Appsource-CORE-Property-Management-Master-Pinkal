page 73209734 "BLRSplit Payment Change Card"
{
    PageType = ListPart;
    SourceTable = "BLRSplitPaymentChange";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'Contract ID';
                    ToolTip = 'The ID of the contract associated with this split payment change.';
                }

                field("Split Payment Series"; Rec."BLRSplit Payment Series")
                {
                    ApplicationArea = All;
                    Caption = 'Split Payment Series';
                    ToolTip = 'The series of the split payment associated with this change.';

                    // Trasfer from Table Start
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PaymentMode2Rec: Record "BLRPaymentMode2";
                        SplitPayChange: Record "BLRSplitPaymentChange";
                        Selection: Page "BLRPayment Mode2 List";
                        ExistingSeries: Text;

                    begin
                        // Ensure Contract ID is selected first
                        if Rec."BLRContract ID" = 0 then
                            Error('Please select a Contract ID first');

                        SplitPayChange.Reset();
                        SplitPayChange.SetRange("BLRContract ID", Rec."BLRContract ID");
                        if SplitPayChange.FindFirst() then
                            ExistingSeries := SplitPayChange."BLRSplit Payment Series";

                        // Filter Payment Mode2 records based on Contract ID
                        PaymentMode2Rec.Reset();
                        PaymentMode2Rec.SetRange("BLRContract ID", Rec."BLRContract ID");
                        PaymentMode2Rec.SetFilter("BLRPayment Status", '<> %1 & <> %2', PaymentMode2Rec."BLRPayment Status"::Cancelled, PaymentMode2Rec."BLRPayment Status"::Received);

                        Selection.LookupMode(true);
                        Selection.SetTableView(PaymentMode2Rec);

                        if Selection.RunModal() = ACTION::LookupOK then begin
                            Selection.SetSelectionFilter(PaymentMode2Rec);

                            if PaymentMode2Rec.FindFirst() then
                                if (ExistingSeries <> '') and (ExistingSeries <> PaymentMode2Rec."BLRPayment Series") then
                                    Error(
                                      'You can only select the same Payment Series (%1) for all lines.',
                                      ExistingSeries);

                            if PaymentMode2Rec.FindFirst() then
                                Rec."BLRSplit Payment Series" := PaymentMode2Rec."BLRPayment Series";

                        end;
                    end;
                    // Trasfer from Table End
                }
                field("Secondary Item Type"; Rec."BLRSecondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';

                    // Trasfer from Table Star

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PaymentSchedule2Rec: Record "BLRPaymentSchedule2";
                        SelectedSchedule: Record "BLRPaymentSchedule2";
                        AlreadySelected: Record "BLRSplitPaymentChange";
                        Selection: Page "BLRPayment Schedule2 List";
                        TotalAmount: Decimal;
                        TotalVATAmount: Decimal;
                        TotalAmountInclVAT: Decimal;
                        SelectedPaymentSeries: Text[250];
                        TotalExisting: Integer;
                        AlreadyUsed: Integer;
                    begin
                        if Rec."BLRContract ID" = 0 then
                            Error('Please select a Contract ID first');

                        // -----------------------------------------
                        // 1. Prepare PaymentSchedule table
                        // -----------------------------------------
                        PaymentSchedule2Rec.Reset();
                        PaymentSchedule2Rec.SetRange("BLRContract ID", Rec."BLRContract ID");
                        PaymentSchedule2Rec.SetRange("BLRPayment Series", Rec."BLRSplit Payment Series");

                        // -----------------------------------------
                        // 2. Run Lookup
                        // -----------------------------------------
                        Selection.LookupMode(true);
                        Selection.SetTableView(PaymentSchedule2Rec);

                        if Selection.RunModal() = ACTION::LookupOK then begin
                            Clear(TotalAmount);
                            Clear(TotalVATAmount);
                            Clear(TotalAmountInclVAT);
                            Clear(SelectedPaymentSeries);

                            Selection.SetSelectionFilter(SelectedSchedule);

                            if SelectedSchedule.FindSet() then
                                repeat
                                    PaymentSchedule2Rec.Reset();
                                    PaymentSchedule2Rec.SetRange("BLRContract ID", Rec."BLRContract ID");
                                    PaymentSchedule2Rec.SetRange("BLRPayment Series", Rec."BLRSplit Payment Series");
                                    PaymentSchedule2Rec.SetRange("BLRSecondary Item Type", SelectedSchedule."BLRSecondary Item Type");
                                    TotalExisting := PaymentSchedule2Rec.Count();

                                    // Already used in Split Payment Change
                                    AlreadySelected.Reset();
                                    AlreadySelected.SetRange("BLRContract ID", Rec."BLRContract ID");
                                    AlreadySelected.SetRange("BLRSplit Payment Series", Rec."BLRSplit Payment Series");
                                    AlreadySelected.SetRange("BLRSecondary Item Type", SelectedSchedule."BLRSecondary Item Type");
                                    AlreadyUsed := AlreadySelected.Count();

                                    if AlreadyUsed >= TotalExisting then
                                        Error('All "%1" items have already been selected. You cannot select more.', SelectedSchedule."BLRSecondary Item Type");

                                    // -----------------------------------------
                                    // 3. Update totals & concatenated string
                                    // -----------------------------------------
                                    if SelectedPaymentSeries <> '' then SelectedPaymentSeries += ', ';
                                    SelectedPaymentSeries += SelectedSchedule."BLRSecondary Item Type";

                                    TotalAmount += SelectedSchedule."BLRAmount";
                                    TotalVATAmount += SelectedSchedule."BLRVAT Amount";
                                    TotalAmountInclVAT += SelectedSchedule."BLRAmount Including VAT";
                                until SelectedSchedule.Next() = 0;

                            // -----------------------------------------
                            // 4. Assign values to current record
                            // -----------------------------------------
                            Rec."BLRSecondary Item Type" := SelectedPaymentSeries;
                            Rec."BLRSplit Amount" := TotalAmount;
                            Rec."BLRSplit VAT Amount" := TotalVATAmount;
                            Rec."BLRSplit Amount Including VAT" := TotalAmountInclVAT;
                            // persist the change now so the handler can read it
                            Rec.Modify(true);
                            CurrPage.Update();
                            // call the same handler used by OnModifyRecord so the
                            // second (remaining) line is created immediately

                        end;
                    end;

                }
                field("Split Due Date"; Rec."BLRSplit Due Date")
                {
                    ApplicationArea = All;
                    Caption = 'Split Due Date';
                    ToolTip = 'The due date for the split payment change.';
                }
                field("Split Payment Mode"; Rec."BLRSplit Payment Mode")
                {
                    ApplicationArea = All;
                    Caption = 'Split Payment Mode';
                    ToolTip = 'The payment mode for the split payment change.';
                }
                field("Deposit Bank Name"; Rec."BLRDeposit Bank Name")
                {
                    ApplicationArea = All;
                    Editable = (Rec."BLRSplit Payment Mode" <> 'Cash');
                }

                field("Split Amount"; Rec."BLRSplit Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Split Amount';
                    ToolTip = 'The amount of the split payment change.';
                }

                field("Split VAT Amount"; Rec."BLRSplit VAT Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Split VAT Amount';
                    ToolTip = 'The VAT amount of the split payment change.';
                }

                field("Split Amount Including VAT"; Rec."BLRSplit Amount Including VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Split Amount Including VAT';
                    ToolTip = 'The total amount including VAT for the split payment change.';
                }

                field("Entry No."; Rec."BLREntry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'The unique entry number for the split payment change.';
                }

                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                    Visible = false;
                    Caption = 'Tenant ID';
                    ToolTip = 'The ID of the tenant associated with this split payment change.';
                }
            }
        }
    }

    procedure SetTenantID(pTenantID: Code[20])
    begin
        tenantID := pTenantID;
    end;

    procedure SetContractID(pContractID: Integer)
    begin
        ContractID := pContractID;
    end;


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        Rec."BLRTenant ID" := tenantID;
        Rec."BLRContract ID" := ContractID;
    end;

    var
        tenantID: Code[20];
        ContractID: Integer;

}