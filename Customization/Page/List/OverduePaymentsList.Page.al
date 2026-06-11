page 73209789 "BLROverdue Payments List" // Use an appropriate page number
{
    PageType = List;
    SourceTable = "BLRPaymentMode2"; // Replace with your actual payment table
    ApplicationArea = All;
    Caption = 'Overdue Payments';
    UsageCategory = None;

    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the contract associated with the payment.';
                }
                field("Tenant Id"; Rec."BLRTenant Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the tenant associated with the payment.';
                }
                field("Tenant Name"; Rec."BLRTenant Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the tenant associated with the payment.';
                }
                field("Payment Series"; Rec."BLRPayment Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Series of the payment document.';
                }
                field("Due Date"; Rec."BLRDue Date")
                {
                    ApplicationArea = All;
                    Style = Unfavorable;  // Shows in red
                    ToolTip = 'Due date for the payment.';
                }
                field("Amount"; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Amount due for the payment.';
                }
                field("VAT Amount"; Rec."BLRVAT Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'VAT amount applicable to the payment.';
                }
                field("Amount Including VAT"; Rec."BLRAmount Including VAT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Total amount including VAT for the payment.';
                }
                field("Days Overdue"; CalcDaysOverdue())
                {
                    ApplicationArea = All;
                    Caption = 'Days Overdue';
                    Style = Unfavorable;  // Shows in red
                    ToolTip = 'Number of days the payment is overdue.';
                }
                // Include payment status if available
                field("Payment Status"; Rec."BLRPayment Status")
                {
                    ApplicationArea = All;
                    StyleExpr = 'Unfavorable';
                    ToolTip = 'Current status of the payment, indicating it is overdue.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        // Filter only by payment status being Overdue
        Rec.SetRange("BLRPayment Status", Rec."BLRPayment Status"::Overdue);
    end;

    local procedure CalcDaysOverdue(): Integer
    begin
        if Rec."BLRDue Date" = 0D then
            exit(0);

        exit(TODAY - Rec."BLRDue Date");
    end;
}