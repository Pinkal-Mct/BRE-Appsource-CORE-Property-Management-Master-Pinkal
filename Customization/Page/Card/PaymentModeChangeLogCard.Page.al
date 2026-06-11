page 73209707 "BLRPaymentModeChangeLogCard"
{
    PageType = ListPart;
    SourceTable = "BLRPaymentModeChangeLog";
    ApplicationArea = All;
    Caption = 'Payment Mode Change Log Details';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("ID"; Rec."BLRID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The unique identifier for the payment mode change log entry.';
                }
                field("Approval Status"; Rec."BLRApproval Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The approval status of the payment mode change log entry.';
                }
                field("Request Type"; Rec."BLRRequest Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The type of request associated with the payment mode change log entry.';
                }

                field("Payment Series"; Rec."BLRPayment Series")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The payment series for the payment mode change log entry.';
                }
                field("Payment mode"; Rec."BLRPayment mode")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The payment mode for the payment mode change log entry.';
                    Lookup = true;
                }
                field("Cheque Number"; Rec."BLRCheque Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Deposit Bank Name"; Rec."BLRDeposit Bank Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'Contract ID';
                    ToolTip = 'The unique identifier for the contract associated with this payment mode change log entry.';
                }

                field("Entry No."; Rec."BLREntry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'The unique entry number for the payment mode change log entry.';
                }
                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Visible = false;
                    ToolTip = 'The unique identifier for the tenant associated with this payment mode change log entry.';
                }
            }
        }
    }
}