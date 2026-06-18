pageextension 73209588 BLRSalesInvoiceSubformExt extends "Sales Invoice Subform"
{
    layout
    {
        addafter("Document No.")
        {
            field("BLRContract ID"; Rec."BLRContract ID")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the contract associated with this sales invoice line.';
            }
            field("BLRFC ID"; Rec."BLRFC ID")
            {
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the financial charge associated with this sales invoice line.';
            }

        }

    }

    trigger OnAfterGetRecord()
    var
        vatpostingsetup: Record "VAT Posting Setup";
    begin

        if VATPostingSetup.Get(Rec."VAT Bus. Posting Group", Rec."VAT Prod. Posting Group") then begin
            Rec.Validate("VAT Identifier", vatpostingsetup."VAT Identifier");
            Rec.Validate("VAT %", VATPostingSetup."VAT %");
            Rec."VAT Base Amount" := Rec.Amount * (Rec."VAT %" / 100);

            Rec."Amount Including VAT" := Rec."Line Amount" + Rec."VAT Base Amount";
            Rec.Modify();
        end;

    end;

}
