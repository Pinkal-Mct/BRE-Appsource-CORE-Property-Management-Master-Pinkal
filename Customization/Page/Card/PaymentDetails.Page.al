page 73209704 "BLRPaymentDetails"
{
    PageType = ListPart;
    SourceTable = "BLRPaymentDetails";
    ApplicationArea = All;
    Caption = 'Payment Details';
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Item Description"; Rec."BLRItem Description")
                {
                    ToolTip = 'Description of the item for which the payment is made.';
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Amount"; Rec."BLRAmount")
                {
                    ToolTip = 'The amount of the payment made for the item.';
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Amount';
                }
                field("VAT Amount"; Rec."BLRVAT Amount")
                {
                    ToolTip = 'The VAT amount applicable to the payment made for the item.';
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'VAT Amount';
                }
                field("Amount Including VAT"; Rec."BLRAmount Including VAT")
                {
                    ToolTip = 'The total amount of the payment including VAT.';
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Amount Including VAT';
                }
                field("Payment Status"; Rec."BLRPayment Status")
                {
                    ToolTip = 'The status of the payment made for the item.';
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = StyleExprTxt;
                }
                field("Payment Date"; Rec."BLRPayment Date")
                {
                    ToolTip = 'The date on which the payment was made for the item.';
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = StyleExprTxt;
                }
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ToolTip = 'The ID of the contract associated with the payment.';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Entry No."; Rec."BLREntry No.")
                {
                    ToolTip = 'The entry number of the payment record.';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Termination Date"; Rec."BLRTermination Date")
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
        if (Rec."BLRPayment Date" > Rec."BLRTermination Date") AND (Rec."BLRPayment Status" <> 'Received') then begin
            Rec."BLRPayment Status" := 'Due';
            StyleExprTxt := 'Unfavorable';
            Rec.Modify();
        end else
            StyleExprTxt := '   ';
        if Rec."BLRPayment Status" = 'Received' then begin
            Rec."BLRPayment Status" := 'Paid';
            Rec.Modify();
        end;
    end;

    var
        StyleExprTxt: Text;
}