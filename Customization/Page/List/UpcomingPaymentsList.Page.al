page 73209814 "Upcoming Payments List" // Use an appropriate page number
{
    PageType = List;
    SourceTable = "Payment Mode2"; // Replace with your actual payment table
    ApplicationArea = All;
    Caption = 'Payments Due Within 10 Days';
    UsageCategory = Lists;

    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'The unique identifier for the contract associated with this payment.';
                }
                field("Tenant Id"; Rec."Tenant Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'The unique identifier for the tenant associated with this payment.';
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'The name of the tenant associated with this payment.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'The date when the payment is due.';
                    Style = Attention;
                }
                field("Amount"; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'The amount due for this payment.';
                }
                field("Days Until Due"; CalcDaysUntilDue())
                {
                    ApplicationArea = All;
                    Caption = 'Days Until Due';
                    ToolTip = 'The number of days remaining until the payment is due.';
                }
                field("Payment Status"; Rec."Payment Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'The current status of the payment.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        CurrentDate: Date;
        TenDaysLater: Date;
    begin
        CurrentDate := TODAY;
        TenDaysLater := CALCDATE('<+10D>', CurrentDate);

        // Only filter by due date, don't check payment status
        Rec.SetFilter("Due Date", '%1..%2', CurrentDate, TenDaysLater);
    end;

    local procedure CalcDaysUntilDue(): Integer
    begin
        if Rec."Due Date" = 0D then
            exit(0);

        exit(Rec."Due Date" - TODAY);
    end;
}