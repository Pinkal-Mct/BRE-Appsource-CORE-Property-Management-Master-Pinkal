page 73209735 "SplitPaymentLogCard"
{
    PageType = ListPart;
    SourceTable = "SplitPaymentLog";
    ApplicationArea = All;
    Caption = 'Split Payment Log Details';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The unique identifier for the split payment log entry.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The approval status of the split payment log entry.';
                }
                field("Request Type"; Rec."Request Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The type of request associated with the split payment log entry.';
                }

                field("New Amount"; Rec."New Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The new amount associated with the split payment log entry.';
                }
                field("New VAT Amount"; Rec."New VAT Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The new VAT amount associated with the split payment log entry.';
                }
                field("Change Amount Including VAT"; Rec."Change Amount Including VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The change amount including VAT associated with the split payment log entry.';
                }
                field("Payment mode"; Rec."Payment mode")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Lookup = true;
                    ToolTip = 'The payment mode for the split payment log entry.';
                }
                field("Cheque Number"; Rec."Cheque Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Deposit Bank Name"; Rec."Deposit Bank Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The due date for the split payment log entry.';
                }

                field("Payment Series"; Rec."Payment Series")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The payment series for the split payment log entry.';
                }

                field("Items"; Rec."Items")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The items associated with the split payment log entry.';
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    Caption = 'Contract ID';
                    ToolTip = 'The unique identifier for the contract associated with this split payment log entry.';
                }

                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                    ToolTip = 'The unique entry number for the split payment log entry.';
                }
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Visible = false;
                    ToolTip = 'The unique identifier for the tenant associated with this split payment log entry.';
                }
            }
        }
    }
}