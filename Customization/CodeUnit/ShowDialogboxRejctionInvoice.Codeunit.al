codeunit 73209630 ShowDialogboxRejctionInvoice
{
    procedure DialogboxForRejection(var Rec: Record "Sales Header")
    var
        salesheader1: Record "Sales Header";
        Rejectionmail: Codeunit RejectSalesInvoice;
        dialogpage: Page DialogBoxForInvoiceRejection;
        ReasonForRejection: Text[1000];
    begin
        salesheader1.SetRange(salesheader1."Document Type", Rec."Document Type"::Invoice);
        salesheader1.SetRange(salesheader1."No.", Rec."No.");
        if not salesheader1.IsEmpty() then
            if dialogpage.RunModal() = Action::OK then begin
                ReasonForRejection := dialogpage.GetReason();
                Rec."Reason for Rejection" := ReasonForRejection;
                Rec.Modify();
                Rejectionmail.SendInvoiceToLeaseManager(Rec);
            end else
                Message('Please Enter Reason');
    end;
}