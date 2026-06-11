page 73209710 "BLRPayment Schedule Card2"
{
    PageType = ListPart;
    SourceTable = "BLRPaymentSchedule2";
    ApplicationArea = All;
    Caption = 'Payment Schedule Details';
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Secondary Item Type"; Rec."BLRSecondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Item Types';
                    Editable = false;
                    ToolTip = 'The type of secondary item associated with this payment schedule.';
                }
                field("Amount"; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Amount';
                    ToolTip = 'The amount for the payment schedule.';
                }
                field("VAT Amount"; Rec."BLRVAT Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'VAT Amount';
                    ToolTip = 'The VAT amount for the payment schedule.';
                }
                field("Amount Including VAT"; Rec."BLRAmount Including VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Amount Including VAT';
                    ToolTip = 'The amount including VAT for the payment schedule.';
                }

                field("Installment Start Date"; Rec."BLRInstallment Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Installment Start Date';
                    ToolTip = 'The start date of the installment for this payment schedule.';
                }

                field("Installment End Date"; Rec."BLRInstallment End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Installment End Date';
                    ToolTip = 'The end date of the installment for this payment schedule.';
                }

                field("Due Date"; Rec."BLRDue Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Due Date';
                    ToolTip = 'The due date for the payment schedule.';
                }

                field("Installment No."; Rec."BLRInstallment No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Installment No.';
                    ToolTip = 'The installment number for this payment schedule.';
                }

                field("Payment Series"; Rec."BLRPayment Series")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'Payment Series';
                    ToolTip = 'The series of the payment associated with this payment schedule.';
                }
                field("Tenant Name"; Rec."BLRTenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'Tenant Name';
                    ToolTip = 'The name of the tenant associated with this payment schedule.';
                }

                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Lookup = true;
                    Visible = false;
                    Caption = 'Tenant ID';
                    ToolTip = 'The ID of the tenant associated with this payment schedule.';
                }
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'Contract ID';
                    ToolTip = 'The ID of the contract associated with this payment schedule.';
                }
                field(Invoiced; Rec."BLRInvoiced")
                {
                    ApplicationArea = All;
                    Caption = 'Invoiced';
                    Editable = InvoicedField;
                    ToolTip = 'Indicates whether the payment schedule has been invoiced.';
                }
                field("Invoice ID"; Rec."BLRInvoice ID")
                {
                    ApplicationArea = All;
                    Caption = 'Invoice ID';
                    ToolTip = 'The ID of the invoice associated with this payment schedule.';
                    Editable = InvoicedField;

                    trigger OnDrillDown()
                    var
                        SalesHeader: Record "Sales Header";
                        postedsalesinvoice: Record "Sales Invoice Header";
                    begin
                        if SalesHeader.Get(Enum::"Sales Document Type"::Invoice, Rec."BLRInvoice ID") then
                            PAGE.Run(PAGE::"Sales Invoice", SalesHeader)
                        else
                            if postedsalesinvoice.Get(Rec."BLRInvoice ID") then
                                PAGE.Run(PAGE::"Posted Sales Invoice", postedsalesinvoice);

                    end;
                }
                field("Invoice Approval Status"; Rec."BLRInvoice Approval Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'The approval status of the invoice associated with this payment schedule.';
                    Caption = 'Invoice Approval Status';
                    Editable = false;
                }
                field("Contract Status"; Rec."BLRContract Status")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Status';
                    ToolTip = 'The status of the contract associated with this payment schedule.';
                    Editable = false;
                    Visible = false;

                }
                field("Overdue Invoice"; Rec."BLROverdue Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'Overdue Invoice';
                    ToolTip = 'Indicates whether the invoice is overdue.';
                    Editable = false;
                    Visible = false;
                }
                field("Property ID"; Rec."BLRProperty ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The ID of the property associated with this payment schedule.';
                    Visible = false;
                }
                field("No of Days"; Rec."BLRNo of Days")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The number of days for the payment schedule.';
                    Visible = false;
                }
                field("Workflow frequency date"; Rec."BLRWorkflow frequency date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The date for the workflow frequency associated with this payment schedule.';
                    Visible = false;
                }
                field("Contract start date"; Rec."BLRContract start date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The start date of the contract associated with this payment schedule.';
                    Visible = false;
                }
                field("VAT%"; Rec."BLRVAT%")
                {
                    ApplicationArea = All;
                    Caption = 'VAT%';
                    Editable = false;
                    ToolTip = 'The VAT percentage for the payment schedule.';
                    Visible = false;
                }
                field("Payment Status"; Rec."BLRPayment Status")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'The status of the payment associated with this payment schedule.';
                }
                field("Payment Received Date"; Rec."BLRPayment Recieved Date")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Received Date';
                    Editable = false;
                    ToolTip = 'The date when the payment was received for this payment schedule.';
                    Visible = false;
                }
                field("Property Classification"; Rec."BLRProperty Classification")
                {
                    ApplicationArea = All;
                    Caption = 'Property Classification';
                    Editable = false;
                    Visible = false;
                    ToolTip = 'The classification of the property associated with this payment schedule.';
                }

                field("BLRPaymentMode"; Rec."BLRPayment Mode")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Mode';
                    Editable = false;
                    ToolTip = 'The mode of payment for this payment schedule.';
                    Visible = false;
                }
                field("Cheque Number"; Rec."BLRCheque Number")
                {
                    ApplicationArea = All;
                    Caption = 'Cheque Number';
                    Editable = false;
                    ToolTip = 'The cheque number for this payment schedule.';
                    Visible = false;
                }
                field("Credit Note No."; Rec."BLRCredit Note No.")
                {
                    ApplicationArea = All;
                    Caption = '"Credit Note No."';
                    Editable = false;
                    ToolTip = 'The credit note number associated with this payment schedule.';
                    Visible = false;
                }

                field("Credit Note Amount"; Rec."BLRCredit Note Amount")
                {
                    ApplicationArea = All;
                    Caption = '"Credit Note Amount"';
                    Editable = false;
                    ToolTip = 'The amount of the credit note associated with this payment schedule.';
                    Visible = false;
                }

                field("Final Rent Amount"; Rec."BLRFinal Rent Amount")
                {
                    ApplicationArea = All;
                    Caption = '"Final Rent Amount"';
                    Editable = false;
                    ToolTip = 'The final rent amount after adjustments for this payment schedule.';
                    Visible = false;
                }
                field("Final RentAmountIncludingVAT"; Rec."BLRFinalRentAmtInclVAT")
                {
                    ApplicationArea = All;
                    Caption = '"Final Rent Amount Including VAT"';
                    Editable = false;
                    ToolTip = 'The final rent amount including VAT for this payment schedule.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {

        area(Processing)
        {
            action(FirstInvoice)
            {
                ApplicationArea = All;
                Caption = 'Initiate Contract Invoice';
                Image = Calculate;
                ToolTip = 'Create the first invoice of the contract based on the payment schedule.';
                trigger OnAction()
                var
                    newsalesheader: Record "Sales Header";
                    PaymentScheduleGrid: Record "BLRPaymentSchedule2";
                    PaymentscheduleGridRec: Record "BLRPaymentSchedule2";
                    customercard: Record Customer;
                    userConfirmed: Boolean;
                begin
                    PaymentScheduleGrid.SetRange("BLRContract ID", Rec."BLRContract ID");
                    PaymentScheduleGrid.SetRange("BLRTenant ID", Rec."BLRTenant ID");
                    PaymentScheduleGrid.SetFilter(BLRInvoiced, '=false');
                    PaymentScheduleGrid.SetRange(BLRYear, 1);
                    PaymentScheduleGrid.SetRange("BLRInstallment No.", 1);
                    if not PaymentScheduleGrid.FindFirst() then begin
                        Message('No uninvoiced first installment records found.');
                        exit;
                    end else begin
                        userConfirmed := Confirm('Do you want to create the invoice?', false);
                        if not userConfirmed then
                            exit;
                        newsalesheader := CreateSalesHeader(PaymentScheduleGrid."BLRContract ID", PaymentScheduleGrid."BLRTenant ID", PaymentScheduleGrid."BLRProperty Classification", PaymentScheduleGrid."BLRDue Date");
                        customercard.SetRange("No.", newsalesheader."Sell-to Customer No.");
                        if customercard.FindSet() then
                            if newsalesheader."BLRProperty Classification" <> '' then begin
                                customercard.Validate("Gen. Bus. Posting Group", newsalesheader."BLRProperty Classification");
                                customercard.Validate("Customer Posting Group", newsalesheader."BLRProperty Classification");
                                customercard.Modify();
                            end;
                        if newsalesheader."BLRProperty Classification" <> '' then begin
                            newsalesheader.Validate("Gen. Bus. Posting Group", newsalesheader."BLRProperty Classification");
                            newsalesheader.Validate("Customer Posting Group", newsalesheader."BLRProperty Classification");
                            newsalesheader.Modify();
                        end;

                        PaymentscheduleGridRec.SetRange("BLRContract ID", Rec."BLRContract ID");
                        PaymentscheduleGridRec.SetRange("BLRTenant ID", Rec."BLRTenant ID");
                        PaymentscheduleGridRec.SetFilter(BLRInvoiced, '=false');
                        PaymentscheduleGridRec.SetRange(BLRYear, 1);
                        PaymentscheduleGridRec.SetRange("BLRInstallment No.", 1);
                        if PaymentscheduleGridRec.FindSet() then
                            repeat
                                Saleslinecreate(newsalesheader, PaymentscheduleGridRec);
                                PaymentscheduleGridRec."BLRInvoiced" := true;
                                PaymentscheduleGridRec."BLRInvoice ID" := newsalesheader."No.";
                                PaymentscheduleGridRec.Modify();
                            until PaymentscheduleGridRec.Next() = 0;
                        Message('Invoice %1 created successfully for first installment.', newsalesheader."No.");
                    end;
                end;
            }
        }
    }

    procedure CreateSalesHeader(pcontractid: Integer; pTenantID: Code[20]; pUnitType: Text[50]; pDueDate: Date): Record "Sales Header"
    var
        salesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Header";
        salesReciveable: Record "Sales & Receivables Setup";
        noseries: Codeunit "No. Series";
    begin
        salesHeader.Init();
        if salesReciveable.FindFirst() then
            salesHeader."No." := noseries.GetNextNo(salesReciveable."Invoice Nos.", Today, true);
        salesHeader."Document Type" := SalesInvoiceHeader."Document Type"::Invoice;
        salesHeader.Validate("Sell-to Customer No.", pTenantID);
        salesHeader."Document Date" := Today;
        salesHeader.Validate("BLRContract ID", pcontractid);
        salesHeader."Posting Date" := Today;
        salesHeader."Due Date" := pDueDate;
        salesHeader."BLRProperty Classification" := pUnitType;
        salesHeader."Posting No. Series" := salesReciveable."Posted Invoice Nos.";
        salesHeader.Insert();
        exit(salesHeader);
    end;

    procedure Saleslinecreate(var salesheader1: Record "Sales Header"; var PaymentscheduleGridLine: Record "BLRPaymentSchedule2")
    var
        saleline: Record "Sales Line";
        newSaleslines: Record "Sales Line";
        item: Record Item;
    begin
        saleline.Init();
        saleline."Document Type" := saleline."Document Type"::Invoice;

        newSaleslines.SetRange("Document No.", salesheader1."No.");
        newSaleslines.SetRange("Document Type", Enum::"Sales Document Type"::Invoice);
        newSaleslines.SetCurrentKey("Line No.");
        if newSaleslines.FindLast() then
            saleline."Line No." := newSaleslines."Line No." + 1000
        else
            saleline."Line No." := 1000;
        saleline."Document No." := salesheader1."No.";
        saleline."BLRContract ID" := salesheader1."BLRContract ID";
        saleline.Type := saleline.Type::Item;
        saleline."Sell-to Customer No." := salesheader1."Sell-to Customer No.";
        item.SetRange(Description, PaymentscheduleGridLine."BLRSecondary Item Type");
        item.SetFilter("BLRCharges Status", '<>%1', item."BLRCharges Status"::" ");
        if item.FindFirst() then
            saleline.Validate("No.", item."No.");

        saleline.Validate("Quantity (Base)", 1);
        saleline.Validate(Quantity, 1);
        saleline.Validate("Unit Price", Abs(PaymentscheduleGridLine."BLRAmount"));
        saleline."BLRContract ID" := PaymentscheduleGridLine."BLRContract ID";
        saleline."BLRFC ID" := salesheader1."BLRFC ID";
        saleline.Insert();
        Clear(saleline);
    end;

    procedure NotAccessInvoicedFieldFinanceManager(): Boolean
    var
        UserPersonalization1: Record "User Personalization";
    begin
        if UserPersonalization1.Get(UserSecurityId()) then
            case UserPersonalization1."Profile ID" of
                'PROPERTY MANAGER':
                    exit(false);
                'LEASE MANAGER':
                    exit(false);
                'FINANCE MANAGER':
                    exit(true);
            end;
        exit(false);
    end;

    trigger OnAfterGetRecord()
    var
        PaymentSchedule: Record "BLRPaymentSchedule";
        workflowfrequency: Record "BLRWorkflowFrequencyPR";
        TempDueDate: Date;
    begin
        InvoicedField := NotAccessInvoicedFieldFinanceManager();

        if PaymentSchedule.Get(Rec."BLRContract ID") then
            Rec."BLRContract start date" := PaymentSchedule."BLRContract Start date";

        workflowfrequency.SetRange("BLRProperty ID", Rec."BLRProperty ID");
        workflowfrequency.SetRange(BLRWorkflow, workflowfrequency."BLRWorkflow"::Invoice);
        if workflowfrequency.FindFirst() then
            Rec."BLRNo of Days" := workflowfrequency."BLRNo. of Days";

        TempDueDate := Rec."BLRDue Date";

        if TempDueDate <> 0D then begin
            if Rec."BLRNo of Days" = 0 then
                Rec."BLRWorkflow frequency date" := TempDueDate
            else
                Rec."BLRWorkflow frequency date" := CalcDate('-' + Format(Rec."BLRNo of Days") + 'D', TempDueDate);
        end else
            Rec."BLRWorkflow frequency date" := 0D;

        Rec."BLRFinal Rent Amount" := Rec."BLRAmount" - Rec."BLRCredit Note Amount";
        Rec."BLRFinalRentAmtInclVAT" := Rec."BLRFinal Rent Amount" + (Rec."BLRFinal Rent Amount" * Rec."BLRVAT%") / 100;
        Rec.Modify();
    end;

    var
        InvoicedField: Boolean;

}