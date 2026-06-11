page 73209705 "BLRPayment Mode Card"
{
    PageType = Card;
    SourceTable = "BLRPaymentMode";
    ApplicationArea = All;
    Caption = 'Payment mode Details';

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    NotBlank = true;
                    Editable = IsFieldEditable;
                    ToolTip = 'Enter the Contract ID.';
                }
                field("Contract Start date"; Rec."BLRContract Start date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the Contract Start date.';
                }
                field("Contract End date"; Rec."BLRContract End date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the Contract End date.';
                }

                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                    ToolTip = 'Enter the Tenant ID.';
                }

                field("Tenant Name"; Rec."BLRTenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the Tenant Name.';
                }

                field("Tenant Email"; Rec."BLRTenant Email")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the Tenant Email.';
                }

                field("Approval Status"; Rec."BLRApproval Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the Approval Status.';
                    Editable = IsFinanceManager AND IsFieldEditable;

                    trigger OnValidate()
                    var
                        PaymentModeRec: Record "BLRPaymentMode2";
                        MissingFields: Text;
                        AnyMissing: Boolean;
                        ChqNumLbl: Label 'Series %1: Cheque Number is missing', Comment = '%1 is the Payment Series';
                        DpstBnkLbl: Label 'Series %1: Deposit Bank is missing', Comment = '%1 is the Payment Series';
                        UpldChqLbl: Label 'Series %1: Upload Cheque is missing', Comment = '%1 is the Payment Series';
                    begin
                        if Rec."BLRApproval Status" <> Rec."BLRApproval Status"::Approved then
                            exit;

                        PaymentModeRec.Reset();
                        PaymentModeRec.SetRange("BLRContract ID", Rec."BLRContract ID");

                        if not PaymentModeRec.FindSet() then
                            Error('Cannot change Approval Status to Approved. No payment mode details found for Contract %1.', Rec."BLRContract ID");

                        AnyMissing := false;
                        MissingFields := '';

                        repeat
                            if PaymentModeRec."BLRPayment Mode" = 'Pending' then
                                Error('Cannot change Approval Status to Approved. Payment Mode is still Pending for Series %1.', PaymentModeRec."BLRPayment Series");

                            case PaymentModeRec."BLRPayment Mode" of
                                'Cheque':
                                    begin
                                        if PaymentModeRec."BLRCheque Number" = '-' then begin
                                            AnyMissing := true;
                                            MissingFields += StrSubstNo(ChqNumLbl, PaymentModeRec."BLRPayment Series");
                                        end;
                                        if PaymentModeRec."BLRDeposit Bank" = '' then begin
                                            AnyMissing := true;
                                            MissingFields += StrSubstNo(DpstBnkLbl, PaymentModeRec."BLRPayment Series");
                                        end;
                                        if PaymentModeRec."BLRUpload Cheque" = 'Upload Cheque' then begin
                                            AnyMissing := true;
                                            MissingFields += StrSubstNo(UpldChqLbl, PaymentModeRec."BLRPayment Series");
                                        end;
                                    end;

                                'Bank Transfer', 'Credit Card', 'Mobile Wallet':
                                    if PaymentModeRec."BLRDeposit Bank" = '' then begin
                                        AnyMissing := true;
                                        MissingFields += StrSubstNo(DpstBnkLbl, PaymentModeRec."BLRPayment Series");
                                    end;
                            end;
                        until PaymentModeRec.Next() = 0;

                        if AnyMissing then
                            Error('Cannot change Approval Status to Approved. The following required details are missing for Contract %1: %2', Rec."BLRContract ID", MissingFields);
                    end;
                }

                field("Payment Reminder"; rec."BLRPayment Reminder")
                {
                    ApplicationArea = All;
                    Editable = true;
                    Visible = false;
                    ToolTip = 'Enter the Payment Reminder.';
                }
                field("On-hold"; Rec."BLROn-hold")
                {
                    ApplicationArea = All;
                    Editable = IsFieldEditable;
                    Visible = false;
                    ToolTip = 'Enter the On-hold status.';
                }
                field(Isupdated; Rec."BLRIsupdated")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Indicates if the record has been updated.';
                }
            }

            group("BLRPaymentMode")
            {
                part("PaymentMode"; "BLRPayment Mode Card2")
                {
                    SubPageLink = "BLRContract ID" = FIELD("BLRContract ID"),
                      "BLRTenant ID" = FIELD("BLRTenant ID"); // Link to filter attachments for this owner only
                                                              // "Contract ID" = FIELD("BLRContract ID")
                    ApplicationArea = All;
                }
            }


            group("BLRCombinePaymentLog")
            {
                Visible = IsCombineVisible;
                Caption = 'Combine Payment Log';
                part("CombinePaymentsLog"; "BLRCombinePaymentLogCard")
                {
                    SubPageLink = "BLRContract ID" = FIELD("BLRContract ID"),
                      "BLRTenant ID" = FIELD("BLRTenant ID"); // Link to filter attachments for this owner only
                                                              // "Contract ID" = FIELD("BLRContract ID")
                    ApplicationArea = All;
                }
            }

            group("CombinePayment")
            {
                Visible = IsCombineVisible;
                Caption = 'Combine Payment';
                group(labels)
                {
                    ShowCaption = false;

                    field("Combine Payment Series"; Rec."BLRCombine Payment Series")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Enter the Payment Series for combining payments.';

                        // Trasfer from Table Start
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            PaymentMode2Rec: Record "BLRPaymentMode2";
                            Selection: Page "BLRPayment Mode2 List";
                            SelectedPaymentSeries: Text;
                            TotalAmount: Decimal;
                            TotalVATAmount: Decimal;
                            TotalAmountInclVAT: Decimal;
                        begin
                            // First check if Contract ID is selected
                            if Rec."BLRContract ID" = 0 then
                                Error('Please select a Contract ID first');

                            // Filter Payment Mode2 records based on Contract ID
                            PaymentMode2Rec.Reset();
                            PaymentMode2Rec.SetRange("BLRContract ID", Rec."BLRContract ID");
                            PaymentMode2Rec.SetFilter("BLRPayment Status", '<> %1 & <> %2', PaymentMode2Rec."BLRPayment Status"::Cancelled, PaymentMode2Rec."BLRPayment Status"::Received);

                            Selection.LookupMode(true);
                            Selection.SetTableView(PaymentMode2Rec);

                            if Selection.RunModal() = ACTION::LookupOK then begin
                                // Clear totals
                                Clear(TotalAmount);
                                Clear(TotalVATAmount);
                                Clear(TotalAmountInclVAT);
                                Clear(SelectedPaymentSeries);

                                Selection.SetSelectionFilter(PaymentMode2Rec);
                                if PaymentMode2Rec.FindSet() then begin
                                    repeat
                                        // Add to payment series string
                                        if SelectedPaymentSeries <> '' then
                                            SelectedPaymentSeries := SelectedPaymentSeries + ',';
                                        SelectedPaymentSeries := SelectedPaymentSeries + PaymentMode2Rec."BLRPayment Series";

                                        // Sum up amounts
                                        TotalAmount += PaymentMode2Rec."BLRAmount";
                                        TotalVATAmount += PaymentMode2Rec."BLRVAT Amount";
                                        TotalAmountInclVAT += PaymentMode2Rec."BLRAmount Including VAT";
                                    until PaymentMode2Rec.Next() = 0;

                                    // Set all values to the record
                                    Rec."BLRCombine Payment Series" := CopyStr(SelectedPaymentSeries, 1, StrLen(SelectedPaymentSeries));
                                    Rec."BLRCombine Amount" := TotalAmount;
                                    Rec."BLRCombine VAT Amount" := TotalVATAmount;
                                    Rec."BLRCombineAmtInclVAT" := TotalAmountInclVAT;
                                end;
                            end;
                        end;
                        // Trasfer from Table End
                    }

                    field("Combine Due Date"; Rec."BLRCombine Due Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Enter the Due Date for combining payments.';
                    }

                    field("Combine Payment Mode"; Rec."BLRCombine Payment Mode")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Enter the Payment Mode for combining payments.';
                    }

                    field("Combine Amount"; Rec."BLRCombine Amount")
                    {
                        ApplicationArea = All;
                        ToolTip = 'The total amount for the combined payments.';
                        Editable = false;
                    }

                    field("Combine VAT Amount"; Rec."BLRCombine VAT Amount")
                    {
                        ApplicationArea = All;
                        ToolTip = 'The total VAT amount for the combined payments.';
                        Editable = false;
                    }

                    field("Combine Amount Including VAT"; Rec."BLRCombineAmtInclVAT")
                    {
                        ApplicationArea = All;
                        ToolTip = 'The total amount including VAT for the combined payments.';
                        Editable = false;
                    }
                }
                group(label)
                {
                    ShowCaption = false;
                    label(note2)
                    {
                        Caption = 'Note: Deposit Bank is required only if Payment Mode is Cheque, Bank Transfer, etc.';
                        ApplicationArea = All;
                        Style = Strong;
                    }
                    field("Deposit Bank"; Rec."BLRC_Deposit_Bank")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Enter the Deposit Bank if Payment Mode is Cheque, Bank Transfer, etc.';
                    }

                    label(note)
                    {
                        Caption = 'Note: Cheque details are required only if Payment Mode is Cheque.';
                        ApplicationArea = All;
                        Style = Strong;
                    }

                    field("cheque No"; Rec."BLRC_Cheque_Number")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Enter the Cheque Number if Payment Mode is Cheque.';
                    }
                }
            }
            group("BLRSplitPaymentLog")
            {
                Visible = IsSplitVisible;
                Caption = 'Split Payment Log';
                part("SplitPaymentsLog"; "BLRSplitPaymentLogCard")
                {
                    SubPageLink = "BLRContract ID" = FIELD("BLRContract ID"),
                      "BLRTenant ID" = FIELD("BLRTenant ID"); // Link to filter attachments for this owner only
                                                              // "Contract ID" = FIELD("BLRContract ID")
                    ApplicationArea = All;
                }
            }
            group("SplitPayment")
            {
                Visible = IsSplitVisible;
                Caption = 'Split Payment';
                part("SplitPayments"; "BLRSplit Payment Change Card")
                {
                    SubPageLink = "BLRContract ID" = FIELD("BLRContract ID"),
                      "BLRTenant ID" = FIELD("BLRTenant ID"); // Link to filter attachments for this owner only
                                                              // "Contract ID" = FIELD("BLRContract ID")
                    ApplicationArea = All;
                }
            }

            group("BLRPaymentModeChangeLog")
            {
                Visible = IsChangePaymodeVisible;
                Caption = 'Change Payment Mode Log';
                part("PaymentsModeChangeLog"; "BLRPaymentModeChangeLogCard")
                {
                    SubPageLink = "BLRContract ID" = FIELD("BLRContract ID"),
                      "BLRTenant ID" = FIELD("BLRTenant ID"); // Link to filter attachments for this owner only
                                                              // "Contract ID" = FIELD("BLRContract ID")
                    ApplicationArea = All;
                }
            }

            group("ChangePaymentMode")
            {
                Visible = IsChangePaymodeVisible;
                Caption = 'Change Payment Mode';

                group(ChangePaymentMode1)
                {
                    ShowCaption = false;
                    field("Change Payment Series"; Rec."BLRChange Payment Series")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Enter the Payment Series for changing payment mode.';

                        // Trasfer from Table Start
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            PaymentMode2Rec: Record "BLRPaymentMode2";
                            Selection: Page "BLRPayment Mode2 List";
                        begin
                            // Ensure Contract ID is selected first
                            if Rec."BLRContract ID" = 0 then
                                Error('Please select a Contract ID first');

                            // Filter Payment Mode2 records based on Contract ID
                            PaymentMode2Rec.Reset();
                            PaymentMode2Rec.SetRange("BLRContract ID", Rec."BLRContract ID");
                            PaymentMode2Rec.SetFilter("BLRPayment Status", '<> %1 & <> %2', PaymentMode2Rec."BLRPayment Status"::Cancelled, PaymentMode2Rec."BLRPayment Status"::Received);

                            Selection.LookupMode(true);
                            Selection.SetTableView(PaymentMode2Rec);

                            if Selection.RunModal() = ACTION::LookupOK then begin
                                Selection.SetSelectionFilter(PaymentMode2Rec);

                                if PaymentMode2Rec.FindFirst() then
                                    Rec."BLRChange Payment Series" := PaymentMode2Rec."BLRPayment Series"; // Select only one value

                            end;
                        end;
                        // Trasfer from Table End
                    }

                    field("Change Payment Mode"; Rec."BLRChange Payment Mode")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Enter the Payment Mode for changing payment mode.';
                    }
                }
                group(ChangePaymentMode2)
                {
                    ShowCaption = false;
                    label(CPnote1)
                    {
                        Caption = 'Note: Deposit Bank is required only if Payment Mode is Cheque, Bank Transfer, etc.';
                        ApplicationArea = All;
                        Style = Strong;
                    }
                    field(CP_Deposit_Bank; Rec."BLRCP_Deposit_Bank")
                    {
                        Caption = 'Deposit Bank Name';
                        ApplicationArea = All;
                        ToolTip = 'Enter the Deposit Bank if Payment Mode is Cheque, Bank Transfer, etc.';
                    }
                    label(CPnote2)
                    {
                        Caption = 'Note: Cheque No. is only required if Payment Mode is Cheque';
                        ApplicationArea = All;
                        Style = Strong;
                    }
                    field(CP_Cheque_Number; Rec."BLRCP_Cheque_Number")
                    {
                        Caption = 'Cheque No.';
                        ApplicationArea = All;
                        ToolTip = 'Enter the Cheque Number if Payment Mode is Cheque.';
                    }
                }
            }
        }
    }


    actions
    {
        area(Processing)
        {
            action(CombineData)
            {
                Caption = 'Combine Data';
                ApplicationArea = All;
                Image = NewDocument;
                ToolTip = 'Combine multiple payments into one request.';

                trigger OnAction()
                var

                begin

                    IsCombineVisible := true;
                    IsSplitVisible := false;
                    IsChangePaymodeVisible := false;
                    RequestType := RequestType::Combine;
                    Status := Status::Manual;
                    Message('Combine Payment section is open.');
                    CombinePaymentLogStore();
                end;
            }

            action(SplitData)
            {
                Caption = 'Split Data';
                ApplicationArea = All;
                Image = NewDocument;
                ToolTip = 'Split a single payment into multiple requests.';

                trigger OnAction()
                begin

                    IsCombineVisible := false;
                    IsChangePaymodeVisible := false;
                    IsSplitVisible := true;
                    RequestType := RequestType::Split;
                    Status := Status::Manual;
                    Message('Split Payment section is open.');
                    SplitPaymentLogStore();
                end;
            }


            action(Paymode)
            {
                Caption = 'Payment Mode Change';
                ApplicationArea = All;
                Image = NewDocument;
                ToolTip = 'Change the payment mode for a request.';

                trigger OnAction()
                begin

                    IsCombineVisible := false;
                    IsSplitVisible := false;
                    IsChangePaymodeVisible := true;
                    RequestType := RequestType::"BLRPaymentMode";
                    Status := Status::Manual;
                    Message('Paymode Payment section is open.');
                    PaymentModeLogStore();
                end;
            }


            action(RequestSend)
            {
                Caption = 'Request Send';
                ApplicationArea = All;
                Image = SendTo;
                ToolTip = 'Send the payment request for approval.';

                trigger OnAction()
                var
                    Paymentmode2: Record "BLRPaymentMode2";
                    Approvalpayment: Record "BLRApprovalPaymentRequest";
                    SplitPayChange: Record "BLRSplitPaymentChange";
                    MaxID: Integer;

                begin
                    // Validate required fields
                    if Rec."BLRContract ID" = 0 then
                        Error('Contract ID must be specified');

                    // Find the highest ID and increment it
                    if Approvalpayment.FindLast() then
                        MaxID := Approvalpayment."BLRID" + 1
                    else
                        MaxID := 1; // If no records exist, start from 1

                    if IsCombineVisible then begin
                        if (Rec."BLRCombine Payment Series" <> '') and (Rec."BLRCombine Due Date" <> 0D) and (Rec."BLRCombine Payment Mode" <> '') then begin
                            //(SplitPayChange."BLRPaymentMode" <> '') and
                            Approvalpayment.Init();
                            Approvalpayment."BLRID" := MaxID; // Assign the new auto-incremented ID
                            Approvalpayment."BLRContract ID" := Rec."BLRContract ID";
                            Approvalpayment."BLRTenant ID" := Rec."BLRTenant ID";
                            Approvalpayment."BLRStatus" := 'Pending';
                            Approvalpayment."BLRRequest Type" := Format(RequestType);
                            Approvalpayment."BLRManual/Auto Status" := Format(Status);
                            Approvalpayment."BLRPayment Series" := Rec."BLRCombine Payment Series";
                            Approvalpayment."BLRDue Date" := Rec."BLRCombine Due Date";
                            Approvalpayment."BLRPayment Mode" := Rec."BLRCombine Payment Mode";
                            Approvalpayment."BLRAmount" := Rec."BLRCombine Amount";
                            Approvalpayment."BLRVAT Amount" := Rec."BLRCombine VAT Amount";
                            Approvalpayment."BLRChange Amount" := Rec."BLRCombineAmtInclVAT";
                            Approvalpayment."BLRPayment mode ID" := Rec."BLRContract ID";
                            Approvalpayment."BLRC_Cheque_Number" := Rec."BLRC_Cheque_Number";
                            Approvalpayment."BLRC_Deposit_Bank" := Rec."BLRC_Deposit_Bank";
                            Approvalpayment.Insert();
                            Message('Approval Request Sent successfully!');
                            Clear(Rec."BLRCombine Payment Series");
                            Clear(Rec."BLRCombine Due Date");
                            Clear(Rec."BLRCombine Payment Mode");
                            Clear(Rec."BLRCombine Amount");
                            Clear(Rec."BLRCombine VAT Amount");
                            Clear(Rec."BLRCombineAmtInclVAT");
                            Clear(Rec."BLRC_Cheque_Number");
                            Clear(Rec."BLRC_Deposit_Bank");
                        end else
                            Message('Please ensure all required fields for Combine Payment are filled before sending the request.');
                    end
                    else
                        if IsSplitVisible then begin
                            if SplitPayChange.FindSet() then
                                repeat

                                    if (SplitPayChange."BLRSplit Payment Series" <> '') and
                                    (SplitPayChange."BLRSecondary Item Type" <> '') and
                                    (SplitPayChange."BLRSplit Due Date" <> 0D) and
                                    //(SplitPayChange."BLRPaymentMode" <> '') and
                                    (SplitPayChange."BLRSplit Amount" <> 0) then begin


                                        Approvalpayment.Init(); // Initialize a new record
                                        Approvalpayment."BLRID" := MaxID; // Assign unique ID
                                        MaxID += 1; // Increment for the next record

                                        Approvalpayment."BLRContract ID" := Rec."BLRContract ID";
                                        Approvalpayment."BLRTenant ID" := Rec."BLRTenant ID";
                                        Approvalpayment."BLRStatus" := 'Pending';
                                        Approvalpayment."BLRRequest Type" := Format(RequestType);
                                        Approvalpayment."BLRManual/Auto Status" := Format(Status);
                                        Approvalpayment."BLRItems" := SplitPayChange."BLRSecondary Item Type";
                                        Approvalpayment."BLRPayment Series" := SplitPayChange."BLRSplit Payment Series";
                                        Approvalpayment."BLRDue Date" := SplitPayChange."BLRSplit Due Date";
                                        Approvalpayment."BLRPayment Mode" := SplitPayChange."BLRSplit Payment Mode";
                                        Approvalpayment."BLRC_Cheque_Number" := SplitPayChange."BLRCheque Number";

                                        Approvalpayment."BLRC_Deposit_Bank" := SplitPayChange."BLRDeposit Bank Name";

                                        Approvalpayment."BLRAmount" := SplitPayChange."BLRSplit Amount";
                                        Approvalpayment."BLRVAT Amount" := SplitPayChange."BLRSplit VAT Amount";
                                        Approvalpayment."BLRChange Amount" := SplitPayChange."BLRSplit Amount Including VAT";
                                        Approvalpayment."BLRPayment mode ID" := Rec."BLRContract ID";
                                        Paymentmode2.SetRange("BLRContract ID", SplitPayChange."BLRContract ID");
                                        Paymentmode2.SetRange("BLRPayment Series", SplitPayChange."BLRSplit Payment Series");
                                        if Paymentmode2.FindFirst() then
                                            Approvalpayment."BLROld Cheque" := Paymentmode2."BLRCheque Number";
                                        Approvalpayment.Insert(); // Insert inside the loop
                                        Message('Approval Request Sent successfully!');
                                        Clear(SplitPayChange."BLRSplit Payment Series");
                                        Clear(SplitPayChange."BLRSplit Due Date");
                                        Clear(SplitPayChange."BLRSplit Payment Mode");
                                        Clear(SplitPayChange."BLRSplit Amount");
                                        Clear(SplitPayChange."BLRSecondary Item Type");
                                        Clear(SplitPayChange."BLRSplit VAT Amount");
                                        Clear(SplitPayChange."BLRSplit Amount Including VAT");
                                        Clear(SplitPayChange."BLRCheque Number");
                                        Clear(SplitPayChange."BLRDeposit Bank Name");
                                    end else
                                        Message('Skipping incomplete split payment entry with Series %1. Please ensure all required fields are filled.',
                                          SplitPayChange."BLRSplit Payment Series");

                                until SplitPayChange.Next() = 0;
                            SplitPayChange.Reset();
                            SplitPayChange.DeleteAll(); // Delete all records from the grid

                        end
                        else
                            if IsChangePaymodeVisible then
                                if (Rec."BLRChange Payment Series" <> '') and (Rec."BLRChange Payment Mode" <> '') then begin
                                    Approvalpayment.Init();
                                    Approvalpayment."BLRID" := MaxID;
                                    Approvalpayment."BLRContract ID" := Rec."BLRContract ID";
                                    Approvalpayment."BLRTenant ID" := Rec."BLRTenant ID";
                                    Approvalpayment."BLRStatus" := 'Pending';
                                    Approvalpayment."BLRRequest Type" := Format(RequestType);
                                    Approvalpayment."BLRManual/Auto Status" := Format(Status);
                                    Approvalpayment."BLRPayment Series" := Rec."BLRChange Payment Series";
                                    Approvalpayment."BLRPayment Mode" := Rec."BLRChange Payment Mode";
                                    Approvalpayment."BLRC_Cheque_Number" := Rec."BLRCP_Cheque_Number";
                                    Approvalpayment."BLRC_Deposit_Bank" := Rec."BLRCP_Deposit_Bank";
                                    Approvalpayment."BLRPayment mode ID" := Rec."BLRContract ID";
                                    Approvalpayment.Insert();
                                    Message('Approval Request Sent successfully!');
                                    Clear(Rec."BLRChange Payment Series");
                                    Clear(Rec."BLRChange Payment Mode");
                                    Clear(Rec."BLRCP_Cheque_Number");
                                    Clear(Rec."BLRCP_Deposit_Bank");
                                end else
                                    Message('Please ensure all required fields for Change Payment Mode are filled before sending the request.');

                    Rec.Modify();
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        // Fields are editable only if Approval Status is not "Approved"
        IsFieldEditable := (Rec."BLRApproval Status" <> Rec."BLRApproval Status"::Approved);
        CurrPage."PaymentMode".Page.SetTenantID(Rec."BLRTenant ID");
        CurrPage."PaymentMode".Page.SetContractID(Rec."BLRContract ID");
        CurrPage.PaymentMode.Page.SetDetails(Rec."BLRTenant Name", Rec."BLRTenant Email");
        CurrPage."SplitPayments".Page.SetTenantID(Rec."BLRTenant ID");
        CurrPage."SplitPayments".Page.SetContractID(Rec."BLRContract ID");
    end;


    trigger OnModifyRecord(): Boolean
    begin
        IsFieldEditable := (Rec."BLRApproval Status" <> Rec."BLRApproval Status"::Approved);
        CurrPage."PaymentMode".Page.SetTenantID(Rec."BLRTenant ID");
        CurrPage."PaymentMode".Page.SetContractID(Rec."BLRContract ID");
        CurrPage.PaymentMode.Page.SetDetails(Rec."BLRTenant Name", Rec."BLRTenant Email");
        CurrPage."SplitPayments".Page.SetTenantID(Rec."BLRTenant ID");
        CurrPage."SplitPayments".Page.SetContractID(Rec."BLRContract ID");
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        CurrPage."PaymentMode".Page.SetTenantID(Rec."BLRTenant ID");
        CurrPage."PaymentMode".Page.SetContractID(Rec."BLRContract ID");
        CurrPage.PaymentMode.Page.SetDetails(Rec."BLRTenant Name", Rec."BLRTenant Email");
        CurrPage."SplitPayments".Page.SetTenantID(Rec."BLRTenant ID");
        CurrPage."SplitPayments".Page.SetContractID(Rec."BLRContract ID");

    end;

    procedure CombinePaymentLogStore()
    var
        ApprovalPaymentRequest: Record "BLRApprovalPaymentRequest";
        CombinePaymentLogsub: Record "BLRCombinePaymentLog";
    begin

        CombinePaymentLogsub.SetRange("BLRContract ID", Rec."BLRContract ID");
        if CombinePaymentLogsub.FindSet() then
            CombinePaymentLogsub.DeleteAll();


        // TenancyContractLine.Reset();
        ApprovalPaymentRequest.SetRange("BLRContract ID", Rec."BLRContract ID");
        ApprovalPaymentRequest.SetRange("BLRTenant ID", Rec."BLRTenant ID");
        ApprovalPaymentRequest.SetRange("BLRRequest Type", 'Combine');
        if ApprovalPaymentRequest.FindSet() then
            repeat
                CombinePaymentLogsub.Init();
                CombinePaymentLogsub."BLRContract ID" := Rec."BLRContract ID";
                CombinePaymentLogsub."BLRTenant ID" := Rec."BLRTenant ID";
                // Calculate VAT amount based on percentage
                CombinePaymentLogsub."BLRID" := ApprovalPaymentRequest."BLRID";
                CombinePaymentLogsub."BLRApproval Status" := ApprovalPaymentRequest."BLRStatus";
                CombinePaymentLogsub."BLRRequest Type" := ApprovalPaymentRequest."BLRRequest Type";
                CombinePaymentLogsub."BLRNew Amount" := ApprovalPaymentRequest."BLRAmount";
                CombinePaymentLogsub."BLRNew VAT Amount" := ApprovalPaymentRequest."BLRVat Amount";
                CombinePaymentLogsub."BLRChange Amount Including VAT" := ApprovalPaymentRequest."BLRChange Amount";
                CombinePaymentLogsub."BLRPayment mode" := ApprovalPaymentRequest."BLRPayment mode";
                CombinePaymentLogsub."BLRPayment Series" := ApprovalPaymentRequest."BLRPayment Series";
                CombinePaymentLogsub."BLRDue Date" := ApprovalPaymentRequest."BLRDue Date";
                CombinePaymentLogsub."BLRC_Deposit_Bank" := ApprovalPaymentRequest."BLRC_Deposit_Bank";
                CombinePaymentLogsub."BLRC_Cheque_Number" := ApprovalPaymentRequest."BLRC_Cheque_Number";
                CombinePaymentLogsub.Insert();
                Clear(CombinePaymentLogsub);
            until ApprovalPaymentRequest.Next() = 0;

    end;

    procedure SplitPaymentLogStore()
    var
        ApprovalPaymentRequest: Record "BLRApprovalPaymentRequest";
        SplitPaymentLogsub: Record "BLRSplitPaymentLog";
    begin

        SplitPaymentLogsub.SetRange("BLRContract ID", Rec."BLRContract ID");
        if SplitPaymentLogsub.FindSet() then
            SplitPaymentLogsub.DeleteAll();


        // TenancyContractLine.Reset();
        ApprovalPaymentRequest.SetRange("BLRContract ID", Rec."BLRContract ID");
        ApprovalPaymentRequest.SetRange("BLRTenant ID", Rec."BLRTenant ID");

        ApprovalPaymentRequest.SetRange("BLRRequest Type", 'Split');
        if ApprovalPaymentRequest.FindSet() then
            repeat
                SplitPaymentLogsub.Init();
                SplitPaymentLogsub."BLRContract ID" := Rec."BLRContract ID";
                SplitPaymentLogsub."BLRTenant ID" := Rec."BLRTenant ID";
                // Calculate VAT amount based on percentage
                SplitPaymentLogsub."BLRID" := ApprovalPaymentRequest."BLRID";
                SplitPaymentLogsub."BLRApproval Status" := ApprovalPaymentRequest."BLRStatus";
                SplitPaymentLogsub."BLRRequest Type" := ApprovalPaymentRequest."BLRRequest Type";
                SplitPaymentLogsub."BLRPayment Series" := ApprovalPaymentRequest."BLRPayment Series";
                SplitPaymentLogsub."BLRNew Amount" := ApprovalPaymentRequest."BLRAmount";
                SplitPaymentLogsub."BLRNew VAT Amount" := ApprovalPaymentRequest."BLRVat Amount";
                SplitPaymentLogsub."BLRChange Amount Including VAT" := ApprovalPaymentRequest."BLRChange Amount";
                SplitPaymentLogsub."BLRPayment mode" := ApprovalPaymentRequest."BLRPayment mode";
                SplitPaymentLogsub."BLRCheque Number" := ApprovalPaymentRequest."BLRC_Cheque_Number";
                SplitPaymentLogsub."BLRDeposit Bank Name" := ApprovalPaymentRequest."BLRC_Deposit_Bank";

                SplitPaymentLogsub."BLRDue Date" := ApprovalPaymentRequest."BLRDue Date";
                SplitPaymentLogsub."BLRItems" := ApprovalPaymentRequest."BLRItems";
                SplitPaymentLogsub.Insert();
                Clear(SplitPaymentLogsub);
            until ApprovalPaymentRequest.Next() = 0;
    end;


    procedure PaymentModeLogStore()
    var
        ApprovalPaymentRequest: Record "BLRApprovalPaymentRequest";
        PaymentModeLogSub: Record "BLRPaymentModeChangeLog";
    begin

        PaymentModeLogSub.SetRange("BLRContract ID", Rec."BLRContract ID");
        if PaymentModeLogSub.FindSet() then
            PaymentModeLogSub.DeleteAll();


        // TenancyContractLine.Reset();
        ApprovalPaymentRequest.SetRange("BLRContract ID", Rec."BLRContract ID");
        ApprovalPaymentRequest.SetRange("BLRTenant ID", Rec."BLRTenant ID");
        ApprovalPaymentRequest.SetRange("BLRRequest Type", 'Payment Mode');
        if ApprovalPaymentRequest.FindSet() then
            repeat
                PaymentModeLogSub.Init();
                PaymentModeLogSub."BLRContract ID" := Rec."BLRContract ID";
                PaymentModeLogSub."BLRTenant ID" := Rec."BLRTenant ID";
                // Calculate VAT amount based on percentage
                PaymentModeLogSub."BLRID" := ApprovalPaymentRequest."BLRID";
                PaymentModeLogSub."BLRApproval Status" := ApprovalPaymentRequest."BLRStatus";
                PaymentModeLogSub."BLRRequest Type" := ApprovalPaymentRequest."BLRRequest Type";
                PaymentModeLogSub."BLRPayment Series" := ApprovalPaymentRequest."BLRPayment Series";
                PaymentModeLogSub."BLRPayment mode" := ApprovalPaymentRequest."BLRPayment mode";
                PaymentModeLogSub."BLRCheque Number" := ApprovalPaymentRequest."BLRC_Cheque_Number";
                PaymentModeLogSub."BLRDeposit Bank Name" := ApprovalPaymentRequest."BLRC_Deposit_Bank";

                PaymentModeLogSub.Insert();
                Clear(PaymentModeLogSub);
            until ApprovalPaymentRequest.Next() = 0;

    end;


    var
        IsFinanceManager: Boolean;
        IsFieldEditable: Boolean;
        IsCombineVisible: Boolean;
        IsSplitVisible: Boolean;
        IsChangePaymodeVisible: Boolean;
        RequestType: Option Combine,Split,"BLRPaymentMode";
        Status: Option Manual,Frontend;

    trigger OnOpenPage()
    var
        PermissionSet: Record "User Personalization";
    begin
        IsFieldEditable := (Rec."BLRApproval Status" <> Rec."BLRApproval Status"::Approved);
        // Check if the current user has the 'LEASE MANAGER' permission set
        IsFinanceManager := false;
        PermissionSet.SetRange("User ID", UserId());
        // PermissionSet.SetRange("Profile ID", 'LEASE MANAGER');
        if PermissionSet.FindFirst() then
            if PermissionSet."Profile ID" = 'FINANCE MANAGER' then
                IsFinanceManager := true;


    end;

}