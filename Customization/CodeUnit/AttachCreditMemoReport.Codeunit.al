codeunit 73209625 "BLRAttach Credit Memo Report"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnAfterSalesCrMemoHeaderInsert, '', false, false)]
    local procedure OnAfterSalesCrMemoHeaderInsert(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean; var TempWhseShptHeader: Record "Warehouse Shipment Header"; var TempWhseRcptHeader: Record "Warehouse Receipt Header")
    var
        SalesHeader1: Record "Sales Header";
        ConfigRecord: Record BLRAzureConfiguration;
        tenancyContract: Record "BLRTenancyContract";
        customer: Record Customer;
        emailcreditmemo: Codeunit "BLRSend Credit Memo to Tenant";

        azureBlobUploader: Codeunit "BLRAzure AD Blob Storage";
        TempBlob: Codeunit "Temp Blob";
        RecRef: RecordRef;
        InStream: InStream;
        FileName: Text;
        SASUrlBase: Text;
        UploadResult: Text;
        ValidFormats: List of [Text];
        FileExtension: Text[10];
        ReportID: Integer;
        OutStream: OutStream;
        folderName: Text;
        postingGroup: Code[20];
    begin
        if not ConfigRecord.FindFirst() then
            Error('Azure configuration is missing. Please set up the SAS URL in the Azure Configuration table.');
        ValidFormats.Add('.png');
        ValidFormats.Add('.jpg');
        ValidFormats.Add('.jpeg');

        SASUrlBase := ConfigRecord."BLRSAS URL";
        FileExtension := '.pdf';
        ReportID := 73209580;
        SalesHeader1.Reset();
        SalesHeader1.SetRange("No.", SalesHeader."No.");
        SalesHeader1.SetRange("Document Type", SalesHeader."Document Type"::"Credit Memo");
        if not SalesHeader1.FindFirst() then
            Error('Sales Credit Memo record not found.');

        RecRef.GetTable(SalesHeader1);
        TempBlob.CreateOutStream(OutStream);
        Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStream, RecRef);

        TempBlob.CreateInStream(InStream);
        FileName := 'CreditMemo_' + SalesCrMemoHeader."No." + FileExtension;
        folderName := 'SalesCreditMemoDocuments';
        UploadResult := azureBlobUploader.UploadDocumentToBlob(InStream, FileName, folderName);
        SalesCrMemoHeader."BLRCredit Memo Document" := CopyStr(FileName, 1, StrLen(FileName));
        SalesCrMemoHeader."BLRCredit Memo URL" := CopyStr(UploadResult, 1, StrLen(UploadResult));
        emailcreditmemo.SendMailToTenantForCreditMemo(SalesCrMemoHeader, FileName, InStream);

        if tenancyContract.Get(SalesHeader."BLRContract ID") then begin
            postingGroup := CopyStr(UpperCase(tenancyContract."BLRProperty Classification"), 1, 20);
            if customer.Get(tenancyContract."BLRTenant ID") then begin
                customer."Gen. Bus. Posting Group" := postingGroup;
                customer."VAT Bus. Posting Group" := postingGroup;
                customer."Customer Posting Group" := postingGroup;
                customer.Modify();
            end;

            SalesCrMemoHeader.Validate("Gen. Bus. Posting Group", postingGroup);
            SalesCrMemoHeader.Validate("VAT Bus. Posting Group", postingGroup);
            SalesCrMemoHeader.Validate("Customer Posting Group", postingGroup);
        end;
    end;
}