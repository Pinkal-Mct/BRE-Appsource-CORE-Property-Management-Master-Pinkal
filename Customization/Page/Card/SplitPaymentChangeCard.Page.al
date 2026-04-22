page 73209734 "Split Payment Change Card"
{
    PageType = ListPart;
    SourceTable = "Split Payment Change";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'Contract ID';
                    ToolTip = 'The ID of the contract associated with this split payment change.';
                }

                field("Split Payment Series"; Rec."Split Payment Series")
                {
                    ApplicationArea = All;
                    Caption = 'Split Payment Series';
                    ToolTip = 'The series of the split payment associated with this change.';

                    // Trasfer from Table Start
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PaymentMode2Rec: Record "Payment Mode2";
                        SplitPayChange: Record "Split Payment Change";
                        Selection: Page "Payment Mode2 List";
                        ExistingSeries: Text;

                    begin
                        // Ensure Contract ID is selected first
                        if Rec."Contract ID" = 0 then
                            Error('Please select a Contract ID first');

                        SplitPayChange.Reset();
                        SplitPayChange.SetRange("Contract ID", Rec."Contract ID");
                        if SplitPayChange.FindFirst() then
                            ExistingSeries := SplitPayChange."Split Payment Series";

                        // Filter Payment Mode2 records based on Contract ID
                        PaymentMode2Rec.Reset();
                        PaymentMode2Rec.SetRange("Contract ID", Rec."Contract ID");
                        PaymentMode2Rec.SetFilter("Payment Status", '<> %1 & <> %2', PaymentMode2Rec."Payment Status"::Cancelled, PaymentMode2Rec."Payment Status"::Received);

                        Selection.LookupMode(true);
                        Selection.SetTableView(PaymentMode2Rec);

                        if Selection.RunModal() = ACTION::LookupOK then begin
                            Selection.SetSelectionFilter(PaymentMode2Rec);

                            if PaymentMode2Rec.FindFirst() then
                                if (ExistingSeries <> '') and (ExistingSeries <> PaymentMode2Rec."Payment Series") then
                                    Error(
                                      'You can only select the same Payment Series (%1) for all lines.',
                                      ExistingSeries);

                            if PaymentMode2Rec.FindFirst() then
                                Rec."Split Payment Series" := PaymentMode2Rec."Payment Series";

                        end;
                    end;
                    // Trasfer from Table End
                }
                field("Secondary Item Type"; Rec."Secondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';

                    // Trasfer from Table Star

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PaymentSchedule2Rec: Record "Payment Schedule2";
                        SelectedSchedule: Record "Payment Schedule2";
                        AlreadySelected: Record "Split Payment Change";
                        Selection: Page "Payment Schedule2 List";
                        TotalAmount: Decimal;
                        TotalVATAmount: Decimal;
                        TotalAmountInclVAT: Decimal;
                        SelectedPaymentSeries: Text[250];
                        TotalExisting: Integer;
                        AlreadyUsed: Integer;
                    begin
                        if Rec."Contract ID" = 0 then
                            Error('Please select a Contract ID first');

                        // -----------------------------------------
                        // 1. Prepare PaymentSchedule table
                        // -----------------------------------------
                        PaymentSchedule2Rec.Reset();
                        PaymentSchedule2Rec.SetRange("Contract ID", Rec."Contract ID");
                        PaymentSchedule2Rec.SetRange("Payment Series", Rec."Split Payment Series");

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
                                    PaymentSchedule2Rec.SetRange("Contract ID", Rec."Contract ID");
                                    PaymentSchedule2Rec.SetRange("Payment Series", Rec."Split Payment Series");
                                    PaymentSchedule2Rec.SetRange("Secondary Item Type", SelectedSchedule."Secondary Item Type");
                                    TotalExisting := PaymentSchedule2Rec.Count();

                                    // Already used in Split Payment Change
                                    AlreadySelected.Reset();
                                    AlreadySelected.SetRange("Contract ID", Rec."Contract ID");
                                    AlreadySelected.SetRange("Split Payment Series", Rec."Split Payment Series");
                                    AlreadySelected.SetRange("Secondary Item Type", SelectedSchedule."Secondary Item Type");
                                    AlreadyUsed := AlreadySelected.Count();

                                    if AlreadyUsed >= TotalExisting then
                                        Error('All "%1" items have already been selected. You cannot select more.', SelectedSchedule."Secondary Item Type");

                                    // -----------------------------------------
                                    // 3. Update totals & concatenated string
                                    // -----------------------------------------
                                    if SelectedPaymentSeries <> '' then SelectedPaymentSeries += ', ';
                                    SelectedPaymentSeries += SelectedSchedule."Secondary Item Type";

                                    TotalAmount += SelectedSchedule.Amount;
                                    TotalVATAmount += SelectedSchedule."VAT Amount";
                                    TotalAmountInclVAT += SelectedSchedule."Amount Including VAT";
                                until SelectedSchedule.Next() = 0;

                            // -----------------------------------------
                            // 4. Assign values to current record
                            // -----------------------------------------
                            Rec."Secondary Item Type" := SelectedPaymentSeries;
                            Rec."Split Amount" := TotalAmount;
                            Rec."Split VAT Amount" := TotalVATAmount;
                            Rec."Split Amount Including VAT" := TotalAmountInclVAT;
                            // persist the change now so the handler can read it
                            Rec.Modify(true);
                            CurrPage.Update();
                            // call the same handler used by OnModifyRecord so the
                            // second (remaining) line is created immediately

                        end;
                    end;

                }
                field("Split Due Date"; Rec."Split Due Date")
                {
                    ApplicationArea = All;
                    Caption = 'Split Due Date';
                    ToolTip = 'The due date for the split payment change.';
                }
                field("Split Payment Mode"; Rec."Split Payment Mode")
                {
                    ApplicationArea = All;
                    Caption = 'Split Payment Mode';
                    ToolTip = 'The payment mode for the split payment change.';
                }
                field("Deposit Bank Name"; Rec."Deposit Bank Name")
                {
                    ApplicationArea = All;
                    Editable = (Rec."Split Payment Mode" <> 'Cash');
                }

                field("Split Amount"; Rec."Split Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Split Amount';
                    ToolTip = 'The amount of the split payment change.';
                }

                field("Split VAT Amount"; Rec."Split VAT Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Split VAT Amount';
                    ToolTip = 'The VAT amount of the split payment change.';
                }

                field("Split Amount Including VAT"; Rec."Split Amount Including VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Split Amount Including VAT';
                    ToolTip = 'The total amount including VAT for the split payment change.';
                }

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'The unique entry number for the split payment change.';
                }

                field("Tenant ID"; Rec."Tenant ID")
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

        Rec."Tenant ID" := tenantID;
        Rec."Contract ID" := ContractID;
    end;

    var
        tenantID: Code[20];
        ContractID: Integer;

}