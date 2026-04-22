page 73209774 "Customer Payment Receipt"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Customer Payment Receipt";
    Caption = 'Customer Payment Receipt';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                    ToolTip = 'The unique identifier for the customer payment receipt entry.';
                }
                field("Posing Date"; Rec."Posing Date")
                {
                    ApplicationArea = All;
                    Caption = 'Posing Date';
                    ToolTip = 'The date when the customer payment receipt was posted.';
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                    ToolTip = 'The document number associated with the customer payment receipt.';
                }
                field("Account Type"; Rec."Account Type")
                {
                    ApplicationArea = All;
                    Caption = 'Account Type';
                    ToolTip = 'The type of account associated with the customer payment receipt.';
                }
                field("Account No."; Rec."Account No.")
                {
                    ApplicationArea = All;
                    Caption = 'Account No.';
                    ToolTip = 'The account number associated with the customer payment receipt.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'A description of the customer payment receipt.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'The amount of the customer payment receipt.';
                }
            }
        }
    }
}