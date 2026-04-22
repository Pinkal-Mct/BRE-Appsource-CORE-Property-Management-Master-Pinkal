page 73209704 "Payment Details"
{
    PageType = ListPart;
    SourceTable = "Payment Details";
    ApplicationArea = All;
    Caption = 'Payment Details';
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Item Description"; Rec."Item Description")
                {
                    ToolTip = 'Description of the item for which the payment is made.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Amount"; Rec."Amount")
                {
                    ToolTip = 'The amount of the payment made for the item.';
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Amount';
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ToolTip = 'The VAT amount applicable to the payment made for the item.';
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'VAT Amount';
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ToolTip = 'The total amount of the payment including VAT.';
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Amount Including VAT';
                }
                field("Payment Status"; Rec."Payment Status")
                {
                    ToolTip = 'The status of the payment made for the item.';
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = StyleExprTxt;
                }
                field("Payment Date"; Rec."Payment Date")
                {
                    ToolTip = 'The date on which the payment was made for the item.';
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = StyleExprTxt;
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ToolTip = 'The ID of the contract associated with the payment.';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'The entry number of the payment record.';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Termination Date"; Rec."Termination Date")
                {
                    ToolTip = 'The date on which the contract associated with the payment was terminated.';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        if (Rec."Payment Date" > Rec."Termination Date") AND (Rec."Payment Status" <> 'Received') then begin
            Rec."Payment Status" := 'Due';
            StyleExprTxt := 'Unfavorable';
            Rec.Modify();
        end else
            StyleExprTxt := '   ';
        if Rec."Payment Status" = 'Received' then begin
            Rec."Payment Status" := 'Paid';
            Rec.Modify();
        end;
    end;

    var
        StyleExprTxt: Text;
}