codeunit 73209627 "BLRDialogboxRejecCreditMemo"
{
    procedure Dialogboxcreditmemo(var Rec: Record "Sales Header")
    var
        salesheader1: Record "Sales Header";
        Rejectionmail: Codeunit "BLRReject Credit Memo";
        dialogpage: Page BLRDialogBoxInvoiceRejection;
        ReasonForRejection: Text[1000];
    begin
        salesheader1.SetRange(salesheader1."Document Type", Rec."Document Type"::"Credit Memo");
        salesheader1.SetRange(salesheader1."No.", Rec."No.");
        if not salesheader1.IsEmpty() then begin
            if dialogpage.RunModal() = Action::OK then
                ReasonForRejection := dialogpage.GetReason();
            Rec."BLRRejection Reason CreditNote" := ReasonForRejection;
            Rec.Modify();
            Rejectionmail.SendInvoiceToLeaseManager(Rec);
        end else
            Message('Please Enter Reason');
    end;
}