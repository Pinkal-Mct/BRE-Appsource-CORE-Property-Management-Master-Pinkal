page 50927 "Payment Mode Card"
{
    PageType = Card;
    SourceTable = "Payment Mode";
    ApplicationArea = All;
    Caption = 'Payment mode Details';

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    NotBlank = true;
                    Editable = IsFieldEditable;
                    ToolTip = 'Enter the Contract ID.';
                }
                field("Contract Start date"; Rec."Contract Start date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the Contract Start date.';
                }
                field("Contract End date"; Rec."Contract End date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the Contract End date.';
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                    ToolTip = 'Enter the Tenant ID.';
                }

                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the Tenant Name.';
                }

                field("Tenant Email"; Rec."Tenant Email")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the Tenant Email.';
                }

                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the Approval Status.';
                    Editable = IsFinanceManager AND IsFieldEditable;

                    trigger OnValidate()
                    var
                        PaymentModeRec: Record "Payment Mode2";
                        MissingFields: Text;
                        AnyMissing: Boolean;
                        ChqNumLbl: Label 'Series %1: Cheque Number is missing', Comment = '%1 is the Payment Series';
                        DpstBnkLbl: Label 'Series %1: Deposit Bank is missing', Comment = '%1 is the Payment Series';
                        UpldChqLbl: Label 'Series %1: Upload Cheque is missing', Comment = '%1 is the Payment Series';
                    begin
                        if Rec."Approval Status" <> Rec."Approval Status"::Approved then
                            exit;

                        PaymentModeRec.Reset();
                        PaymentModeRec.SetRange("Contract ID", Rec."Contract ID");

                        if not PaymentModeRec.FindSet() then
                            Error('Cannot change Approval Status to Approved. No payment mode details found for Contract %1.', Rec."Contract ID");

                        AnyMissing := false;
                        MissingFields := '';

                        repeat
                            if PaymentModeRec."Payment Mode" = 'Pending' then
                                Error('Cannot change Approval Status to Approved. Payment Mode is still Pending for Series %1.', PaymentModeRec."Payment Series");

                            case PaymentModeRec."Payment Mode" of
                                'Cheque':
                                    begin
                                        if PaymentModeRec."Cheque Number" = '-' then begin
                                            AnyMissing := true;
                                            MissingFields += StrSubstNo(ChqNumLbl, PaymentModeRec."Payment Series");
                                        end;
                                        if PaymentModeRec."Deposit Bank" = '' then begin
                                            AnyMissing := true;
                                            MissingFields += StrSubstNo(DpstBnkLbl, PaymentModeRec."Payment Series");
                                        end;
                                        if PaymentModeRec."Upload Cheque" = 'Upload Cheque' then begin
                                            AnyMissing := true;
                                            MissingFields += StrSubstNo(UpldChqLbl, PaymentModeRec."Payment Series");
                                        end;
                                    end;

                                'Bank Transfer', 'Credit Card', 'Mobile Wallet':
                                    if PaymentModeRec."Deposit Bank" = '' then begin
                                        AnyMissing := true;
                                        MissingFields += StrSubstNo(DpstBnkLbl, PaymentModeRec."Payment Series");
                                    end;
                            end;
                        until PaymentModeRec.Next() = 0;

                        if AnyMissing then
                            Error('Cannot change Approval Status to Approved. The following required details are missing for Contract %1: %2', Rec."Contract ID", MissingFields);
                    end;
                }

                field("Payment Reminder"; rec."Payment Reminder")
                {
                    ApplicationArea = All;
                    Editable = true;
                    Visible = false;
                    ToolTip = 'Enter the Payment Reminder.';
                }
                field("On-hold"; Rec."On-hold")
                {
                    ApplicationArea = All;
                    Editable = IsFieldEditable;
                    Visible = false;
                    ToolTip = 'Enter the On-hold status.';
                }
                field(Isupdated; Rec.Isupdated)
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Indicates if the record has been updated.';
                }
            }

            group("Payment Mode")
            {
                part("PaymentMode"; "Payment Mode Card2")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"),
                      "Tenant ID" = FIELD("Tenant ID"); // Link to filter attachments for this owner only
                                                        // "Contract ID" = FIELD("Contract ID")
                    ApplicationArea = All;
                }
            }


            group("CombinePaymentLog")
            {
                Visible = IsCombineVisible;
                Caption = 'Combine Payment Log';
                part("CombinePaymentsLog"; "CombinePaymentLogCard")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"),
                      "Tenant ID" = FIELD("Tenant ID"); // Link to filter attachments for this owner only
                                                        // "Contract ID" = FIELD("Contract ID")
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

                    field("Combine Payment Series"; Rec."Combine Payment Series")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Enter the Payment Series for combining payments.';

                        // Trasfer from Table Start
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            PaymentMode2Rec: Record "Payment Mode2";
                            Selection: Page "Payment Mode2 List";
                            SelectedPaymentSeries: Text;
                            TotalAmount: Decimal;
                            TotalVATAmount: Decimal;
                            TotalAmountInclVAT: Decimal;
                        begin
                            // First check if Contract ID is selected
                            if Rec."Contract ID" = 0 then
                                Error('Please select a Contract ID first');

                            // Filter Payment Mode2 records based on Contract ID
                            PaymentMode2Rec.Reset();
                            PaymentMode2Rec.SetRange("Contract ID", Rec."Contract ID");
                            PaymentMode2Rec.SetFilter("Payment Status", '<> %1 & <> %2', PaymentMode2Rec."Payment Status"::Cancelled, PaymentMode2Rec."Payment Status"::Received);

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
                                        SelectedPaymentSeries := SelectedPaymentSeries + PaymentMode2Rec."Payment Series";

                                        // Sum up amounts
                                        TotalAmount += PaymentMode2Rec.Amount;
                                        TotalVATAmount += PaymentMode2Rec."VAT Amount";
                                        TotalAmountInclVAT += PaymentMode2Rec."Amount Including VAT";
                                    until PaymentMode2Rec.Next() = 0;

                                    // Set all values to the record
                                    Rec."Combine Payment Series" := CopyStr(SelectedPaymentSeries, 1, StrLen(SelectedPaymentSeries));
                                    Rec."Combine Amount" := TotalAmount;
                                    Rec."Combine VAT Amount" := TotalVATAmount;
                                    Rec."Combine Amount Including VAT" := TotalAmountInclVAT;
                                end;
                            end;
                        end;
                        // Trasfer from Table End
                    }

                    field("Combine Due Date"; Rec."Combine Due Date")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Enter the Due Date for combining payments.';
                    }

                    field("Combine Payment Mode"; Rec."Combine Payment Mode")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Enter the Payment Mode for combining payments.';
                    }

                    field("Combine Amount"; Rec."Combine Amount")
                    {
                        ApplicationArea = All;
                        ToolTip = 'The total amount for the combined payments.';
                        Editable = false;
                    }

                    field("Combine VAT Amount"; Rec."Combine VAT Amount")
                    {
                        ApplicationArea = All;
                        ToolTip = 'The total VAT amount for the combined payments.';
                        Editable = false;
                    }

                    field("Combine Amount Including VAT"; Rec."Combine Amount Including VAT")
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
                    field("Deposit Bank"; Rec."C_Deposit_Bank")
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

                    field("cheque No"; Rec."C_Cheque_Number")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Enter the Cheque Number if Payment Mode is Cheque.';
                    }
                }
            }
            group("SplitPaymentLog")
            {
                Visible = IsSplitVisible;
                Caption = 'Split Payment Log';
                part("SplitPaymentsLog"; "SplitPaymentLogCard")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"),
                      "Tenant ID" = FIELD("Tenant ID"); // Link to filter attachments for this owner only
                                                        // "Contract ID" = FIELD("Contract ID")
                    ApplicationArea = All;
                }
            }
            group("SplitPayment")
            {
                Visible = IsSplitVisible;
                Caption = 'Split Payment';
                part("SplitPayments"; "Split Payment Change Card")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"),
                      "Tenant ID" = FIELD("Tenant ID"); // Link to filter attachments for this owner only
                                                        // "Contract ID" = FIELD("Contract ID")
                    ApplicationArea = All;
                }
            }

            group("PaymentModeChangeLog")
            {
                Visible = IsChangePaymodeVisible;
                Caption = 'Change Payment Mode Log';
                part("PaymentsModeChangeLog"; "PaymentModeChangeLogCard")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"),
                      "Tenant ID" = FIELD("Tenant ID"); // Link to filter attachments for this owner only
                                                        // "Contract ID" = FIELD("Contract ID")
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
                    field("Change Payment Series"; Rec."Change Payment Series")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Enter the Payment Series for changing payment mode.';

                        // Trasfer from Table Start
                        trigger OnLookup(var Text: Text): Boolean
                        var
                            PaymentMode2Rec: Record "Payment Mode2";
                            Selection: Page "Payment Mode2 List";
                        begin
                            // Ensure Contract ID is selected first
                            if Rec."Contract ID" = 0 then
                                Error('Please select a Contract ID first');

                            // Filter Payment Mode2 records based on Contract ID
                            PaymentMode2Rec.Reset();
                            PaymentMode2Rec.SetRange("Contract ID", Rec."Contract ID");
                            PaymentMode2Rec.SetFilter("Payment Status", '<> %1 & <> %2', PaymentMode2Rec."Payment Status"::Cancelled, PaymentMode2Rec."Payment Status"::Received);

                            Selection.LookupMode(true);
                            Selection.SetTableView(PaymentMode2Rec);

                            if Selection.RunModal() = ACTION::LookupOK then begin
                                Selection.SetSelectionFilter(PaymentMode2Rec);

                                if PaymentMode2Rec.FindFirst() then
                                    Rec."Change Payment Series" := PaymentMode2Rec."Payment Series"; // Select only one value

                            end;
                        end;
                        // Trasfer from Table End
                    }

                    field("Change Payment Mode"; Rec."Change Payment Mode")
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
                    field(CP_Deposit_Bank; Rec.CP_Deposit_Bank)
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
                    field(CP_Cheque_Number; Rec.CP_Cheque_Number)
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
                    RequestType := RequestType::"Payment Mode";
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
                    Paymentmode2: Record "Payment Mode2";
                    Approvalpayment: Record "Approval Payment Request";
                    SplitPayChange: Record "Split Payment Change";
                    MaxID: Integer;

                begin
                    // Validate required fields
                    if Rec."Contract ID" = 0 then
                        Error('Contract ID must be specified');

                    // Find the highest ID and increment it
                    if Approvalpayment.FindLast() then
                        MaxID := Approvalpayment.ID + 1
                    else
                        MaxID := 1; // If no records exist, start from 1

                    if IsCombineVisible then begin
                        Approvalpayment.Init();
                        Approvalpayment.ID := MaxID; // Assign the new auto-incremented ID
                        Approvalpayment."Contract ID" := Rec."Contract ID";
                        Approvalpayment."Tenant ID" := Rec."Tenant ID";
                        Approvalpayment."Status" := 'Pending';
                        Approvalpayment."Request Type" := Format(RequestType);
                        Approvalpayment."Manual/Auto Status" := Format(Status);
                        Approvalpayment."Payment Series" := Rec."Combine Payment Series";
                        Approvalpayment."Due Date" := Rec."Combine Due Date";
                        Approvalpayment."Payment Mode" := Rec."Combine Payment Mode";
                        Approvalpayment."Amount" := Rec."Combine Amount";
                        Approvalpayment."VAT Amount" := Rec."Combine VAT Amount";
                        Approvalpayment."Change Amount" := Rec."Combine Amount Including VAT";
                        Approvalpayment."Payment mode ID" := Rec."Contract ID";
                        Approvalpayment.C_Cheque_Number := Rec.C_Cheque_Number;
                        Approvalpayment.C_Deposit_Bank := Rec.C_Deposit_Bank;
                        Approvalpayment.Insert();
                    end
                    else
                        if IsSplitVisible then begin
                            if SplitPayChange.FindSet() then begin
                                repeat

                                    if (SplitPayChange."Split Payment Series" <> '') and
                                    (SplitPayChange."Secondary Item Type" <> '') and
                                    (SplitPayChange."Split Due Date" <> 0D) and
                                    //(SplitPayChange."Payment Mode" <> '') and
                                    (SplitPayChange."Split Amount" <> 0) then begin


                                        Approvalpayment.Init(); // Initialize a new record
                                        Approvalpayment.ID := MaxID; // Assign unique ID
                                        MaxID += 1; // Increment for the next record

                                        Approvalpayment."Contract ID" := Rec."Contract ID";
                                        Approvalpayment."Tenant ID" := Rec."Tenant ID";
                                        Approvalpayment."Status" := 'Pending';
                                        Approvalpayment."Request Type" := Format(RequestType);
                                        Approvalpayment."Manual/Auto Status" := Format(Status);
                                        Approvalpayment.Items := SplitPayChange."Secondary Item Type";
                                        Approvalpayment."Payment Series" := SplitPayChange."Split Payment Series";
                                        Approvalpayment."Due Date" := SplitPayChange."Split Due Date";
                                        Approvalpayment."Payment Mode" := SplitPayChange."Split Payment Mode";
                                        Approvalpayment.C_Cheque_Number := SplitPayChange."Cheque Number";

                                        Approvalpayment.C_Deposit_Bank := SplitPayChange."Deposit Bank Name";

                                        Approvalpayment."Amount" := SplitPayChange."Split Amount";
                                        Approvalpayment."VAT Amount" := SplitPayChange."Split VAT Amount";
                                        Approvalpayment."Change Amount" := SplitPayChange."Split Amount Including VAT";
                                        Approvalpayment."Payment mode ID" := Rec."Contract ID";
                                        Paymentmode2.SetRange("Contract ID", SplitPayChange."Contract ID");
                                        Paymentmode2.SetRange("Payment Series", SplitPayChange."Split Payment Series");
                                        if Paymentmode2.FindFirst() then
                                            Approvalpayment."Old Cheque" := Paymentmode2."Cheque Number";
                                        Approvalpayment.Insert(); // Insert inside the loop
                                    end;
                                until SplitPayChange.Next() = 0;
                                SplitPayChange.Reset();
                                SplitPayChange.DeleteAll(); // Delete all records from the grid
                            end;
                        end
                        else
                            if IsChangePaymodeVisible then begin
                                Approvalpayment.Init();
                                Approvalpayment.ID := MaxID;
                                Approvalpayment."Contract ID" := Rec."Contract ID";
                                Approvalpayment."Tenant ID" := Rec."Tenant ID";
                                Approvalpayment."Status" := 'Pending';
                                Approvalpayment."Request Type" := Format(RequestType);
                                Approvalpayment."Manual/Auto Status" := Format(Status);
                                Approvalpayment."Payment Series" := Rec."Change Payment Series";
                                Approvalpayment."Payment Mode" := Rec."Change Payment Mode";
                                Approvalpayment.C_Cheque_Number := Rec.CP_Cheque_Number;
                                Approvalpayment.C_Deposit_Bank := Rec.CP_Deposit_Bank;

                                Approvalpayment."Payment mode ID" := Rec."Contract ID";
                                Approvalpayment.Insert();
                            end;

                    Message('Approval Request Sent successfully!');

                    // Clear relevant fields after sending request
                    Clear(SplitPayChange."Split Payment Series");
                    Clear(SplitPayChange."Split Due Date");
                    Clear(SplitPayChange."Split Payment Mode");
                    Clear(SplitPayChange."Split Amount");
                    Clear(SplitPayChange."Secondary Item Type");
                    Clear(SplitPayChange."Split VAT Amount");
                    Clear(SplitPayChange."Split Amount Including VAT");
                    Clear(SplitPayChange."Cheque Number");
                    Clear(SplitPayChange."Deposit Bank Name");
                    Clear(Rec."Combine Payment Series");
                    Clear(Rec."Combine Due Date");
                    Clear(Rec."Combine Payment Mode");
                    Clear(Rec."Combine Amount");
                    Clear(Rec."Combine VAT Amount");
                    Clear(Rec."Combine Amount Including VAT");
                    Clear(Rec.C_Cheque_Number);
                    Clear(Rec.C_Deposit_Bank);

                    Clear(Rec."Change Payment Series");
                    Clear(Rec."Change Payment Mode");
                    Clear(Rec.CP_Cheque_Number);
                    Clear(Rec.CP_Deposit_Bank);
                    // Modify and update the record
                    Rec.Modify();
                end;

            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        // Fields are editable only if Approval Status is not "Approved"
        IsFieldEditable := (Rec."Approval Status" <> Rec."Approval Status"::Approved);
        CurrPage."PaymentMode".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."PaymentMode".Page.SetContractID(Rec."Contract ID");
        CurrPage.PaymentMode.Page.SetDetails(Rec."Tenant Name", Rec."Tenant Email");
        CurrPage."SplitPayments".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."SplitPayments".Page.SetContractID(Rec."Contract ID");
    end;


    trigger OnModifyRecord(): Boolean
    begin
        IsFieldEditable := (Rec."Approval Status" <> Rec."Approval Status"::Approved);
        CurrPage."PaymentMode".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."PaymentMode".Page.SetContractID(Rec."Contract ID");
        CurrPage.PaymentMode.Page.SetDetails(Rec."Tenant Name", Rec."Tenant Email");
        CurrPage."SplitPayments".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."SplitPayments".Page.SetContractID(Rec."Contract ID");
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        CurrPage."PaymentMode".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."PaymentMode".Page.SetContractID(Rec."Contract ID");
        CurrPage.PaymentMode.Page.SetDetails(Rec."Tenant Name", Rec."Tenant Email");
        CurrPage."SplitPayments".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."SplitPayments".Page.SetContractID(Rec."Contract ID");

    end;

    procedure CombinePaymentLogStore()
    var
        ApprovalPaymentRequest: Record "Approval Payment Request";
        CombinePaymentLogsub: Record "CombinePaymentLog";
    begin

        CombinePaymentLogsub.SetRange("Contract ID", Rec."Contract ID");
        if CombinePaymentLogsub.FindSet() then
            CombinePaymentLogsub.DeleteAll();


        // TenancyContractLine.Reset();
        ApprovalPaymentRequest.SetRange("Contract ID", Rec."Contract ID");
        ApprovalPaymentRequest.SetRange("Tenant ID", Rec."Tenant ID");
        ApprovalPaymentRequest.SetRange("Request Type", 'Combine');
        if ApprovalPaymentRequest.FindSet() then
            repeat
                CombinePaymentLogsub.Init();
                CombinePaymentLogsub."Contract ID" := Rec."Contract ID";
                CombinePaymentLogsub."Tenant ID" := Rec."Tenant ID";
                // Calculate VAT amount based on percentage
                CombinePaymentLogsub."ID" := ApprovalPaymentRequest.ID;
                CombinePaymentLogsub."Approval Status" := ApprovalPaymentRequest."Status";
                CombinePaymentLogsub."Request Type" := ApprovalPaymentRequest."Request Type";
                CombinePaymentLogsub."New Amount" := ApprovalPaymentRequest."Amount";
                CombinePaymentLogsub."New VAT Amount" := ApprovalPaymentRequest."Vat Amount";
                CombinePaymentLogsub."Change Amount Including VAT" := ApprovalPaymentRequest."Change Amount";
                CombinePaymentLogsub."Payment mode" := ApprovalPaymentRequest."Payment mode";
                CombinePaymentLogsub."Payment Series" := ApprovalPaymentRequest."Payment Series";
                CombinePaymentLogsub."Due Date" := ApprovalPaymentRequest."Due Date";
                CombinePaymentLogsub."C_Deposit_Bank" := ApprovalPaymentRequest."C_Deposit_Bank";
                CombinePaymentLogsub."C_Cheque_Number" := ApprovalPaymentRequest."C_Cheque_Number";
                CombinePaymentLogsub.Insert();
                Clear(CombinePaymentLogsub);
            until ApprovalPaymentRequest.Next() = 0;

    end;

    procedure SplitPaymentLogStore()
    var
        ApprovalPaymentRequest: Record "Approval Payment Request";
        SplitPaymentLogsub: Record "SplitPaymentLog";
    begin

        SplitPaymentLogsub.SetRange("Contract ID", Rec."Contract ID");
        if SplitPaymentLogsub.FindSet() then
            SplitPaymentLogsub.DeleteAll();


        // TenancyContractLine.Reset();
        ApprovalPaymentRequest.SetRange("Contract ID", Rec."Contract ID");
        ApprovalPaymentRequest.SetRange("Tenant ID", Rec."Tenant ID");

        ApprovalPaymentRequest.SetRange("Request Type", 'Split');
        if ApprovalPaymentRequest.FindSet() then
            repeat
                SplitPaymentLogsub.Init();
                SplitPaymentLogsub."Contract ID" := Rec."Contract ID";
                SplitPaymentLogsub."Tenant ID" := Rec."Tenant ID";
                // Calculate VAT amount based on percentage
                SplitPaymentLogsub."ID" := ApprovalPaymentRequest.ID;
                SplitPaymentLogsub."Approval Status" := ApprovalPaymentRequest."Status";
                SplitPaymentLogsub."Request Type" := ApprovalPaymentRequest."Request Type";
                SplitPaymentLogsub."Payment Series" := ApprovalPaymentRequest."Payment Series";
                SplitPaymentLogsub."New Amount" := ApprovalPaymentRequest."Amount";
                SplitPaymentLogsub."New VAT Amount" := ApprovalPaymentRequest."Vat Amount";
                SplitPaymentLogsub."Change Amount Including VAT" := ApprovalPaymentRequest."Change Amount";
                SplitPaymentLogsub."Payment mode" := ApprovalPaymentRequest."Payment mode";
                SplitPaymentLogsub."Cheque Number" := ApprovalPaymentRequest.C_Cheque_Number;
                SplitPaymentLogsub."Deposit Bank Name" := ApprovalPaymentRequest.C_Deposit_Bank;

                SplitPaymentLogsub."Due Date" := ApprovalPaymentRequest."Due Date";
                SplitPaymentLogsub.Items := ApprovalPaymentRequest.Items;
                SplitPaymentLogsub.Insert();
                Clear(SplitPaymentLogsub);
            until ApprovalPaymentRequest.Next() = 0;
    end;


    procedure PaymentModeLogStore()
    var
        ApprovalPaymentRequest: Record "Approval Payment Request";
        PaymentModeLogSub: Record "PaymentModeChangeLog";
    begin

        PaymentModeLogSub.SetRange("Contract ID", Rec."Contract ID");
        if PaymentModeLogSub.FindSet() then
            PaymentModeLogSub.DeleteAll();


        // TenancyContractLine.Reset();
        ApprovalPaymentRequest.SetRange("Contract ID", Rec."Contract ID");
        ApprovalPaymentRequest.SetRange("Tenant ID", Rec."Tenant ID");
        ApprovalPaymentRequest.SetRange("Request Type", 'Payment Mode');
        if ApprovalPaymentRequest.FindSet() then
            repeat
                PaymentModeLogSub.Init();
                PaymentModeLogSub."Contract ID" := Rec."Contract ID";
                PaymentModeLogSub."Tenant ID" := Rec."Tenant ID";
                // Calculate VAT amount based on percentage
                PaymentModeLogSub."ID" := ApprovalPaymentRequest.ID;
                PaymentModeLogSub."Approval Status" := ApprovalPaymentRequest."Status";
                PaymentModeLogSub."Request Type" := ApprovalPaymentRequest."Request Type";
                PaymentModeLogSub."Payment Series" := ApprovalPaymentRequest."Payment Series";
                PaymentModeLogSub."Payment mode" := ApprovalPaymentRequest."Payment mode";
                PaymentModeLogSub."Cheque Number" := ApprovalPaymentRequest.C_Cheque_Number;
                PaymentModeLogSub."Deposit Bank Name" := ApprovalPaymentRequest.C_Deposit_Bank;

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
        RequestType: Option Combine,Split,"Payment Mode";
        Status: Option Manual,Frontend;

    trigger OnOpenPage()
    var
        PermissionSet: Record "User Personalization";
    begin
        IsFieldEditable := (Rec."Approval Status" <> Rec."Approval Status"::Approved);
        // Check if the current user has the 'LEASE_MANAGER' permission set
        IsFinanceManager := false;
        PermissionSet.SetRange("User ID", UserId());
        // PermissionSet.SetRange("Profile ID", 'LEASE_MANAGER');
        if PermissionSet.FindFirst() then
            if PermissionSet."Profile ID" = 'FINANCE MANAGER' then
                IsFinanceManager := true;


    end;

}