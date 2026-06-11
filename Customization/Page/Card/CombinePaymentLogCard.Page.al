page 73209679 "BLRCombinePaymentLogCard"
{
    PageType = ListPart;
    SourceTable = "BLRCombinePaymentLog";
    ApplicationArea = All;
    Caption = 'Combine Payment Log Details';

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
                    ToolTip = 'The unique identifier for the combine payment log entry.';
                }
                field("Approval Status"; Rec."BLRApproval Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The approval status of the combine payment log entry.';
                }
                field("Request Type"; Rec."BLRRequest Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The type of request associated with the combine payment log entry.';
                }

                field("New Amount"; Rec."BLRNew Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The new amount for the combine payment log entry.';
                }
                field("New VAT Amount"; Rec."BLRNew VAT Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The new VAT amount for the combine payment log entry.';
                }
                field("Change Amount Including VAT"; Rec."BLRChange Amount Including VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The change amount including VAT for the combine payment log entry.';
                }
                field("Payment mode"; Rec."BLRPayment mode")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Lookup = true;
                    ToolTip = 'The payment mode for the combine payment log entry.';
                }

                field("Due Date"; Rec."BLRDue Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The due date for the combine payment log entry.';
                }

                field("Payment Series"; Rec."BLRPayment Series")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The payment series associated with the combine payment log entry.';
                }
                field("cheque No"; Rec."BLRC_Cheque_Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cheque number associated with this combine payment log entry.';
                }
                field("Deposit Bank"; Rec."BLRC_Deposit_Bank")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the deposit bank associated with this combine payment log entry.';
                }
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'Contract ID';
                    ToolTip = 'The unique identifier for the contract associated with this combine payment log entry.';
                }

                field("Entry No."; Rec."BLREntry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'The unique entry number for the combine payment log entry.';
                }
                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Visible = false;
                    ToolTip = 'The unique identifier for the tenant associated with this combine payment log entry.';
                }
            }
        }
    }
}