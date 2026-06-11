page 73209774 "BLRCustomerPaymentReceipt"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "BLRCustomerPaymentReceipt";
    Caption = 'Customer Payment Receipt';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."BLREntry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                    ToolTip = 'The unique identifier for the customer payment receipt entry.';
                }
                field("Posing Date"; Rec."BLRPosing Date")
                {
                    ApplicationArea = All;
                    Caption = 'Posing Date';
                    ToolTip = 'The date when the customer payment receipt was posted.';
                }
                field("Document No."; Rec."BLRDocument No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                    ToolTip = 'The document number associated with the customer payment receipt.';
                }
                field("Account Type"; Rec."BLRAccount Type")
                {
                    ApplicationArea = All;
                    Caption = 'Account Type';
                    ToolTip = 'The type of account associated with the customer payment receipt.';
                }
                field("Account No."; Rec."BLRAccount No.")
                {
                    ApplicationArea = All;
                    Caption = 'Account No.';
                    ToolTip = 'The account number associated with the customer payment receipt.';
                }
                field(Description; Rec."BLRDescription")
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'A description of the customer payment receipt.';
                }
                field(Amount; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'The amount of the customer payment receipt.';
                }
            }
        }
    }
}