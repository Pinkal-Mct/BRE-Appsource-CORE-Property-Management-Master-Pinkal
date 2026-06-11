page 73209747 "BLRTenant Document SubPage"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "BLRTenantDocumentDetails";
    Caption = 'Tenant Document SubPage';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Document Type"; Rec."BLRDocument Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Document Type';
                }
                field("Document Name"; Rec."BLRDocument Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Document Name';
                }
                field("Upload Document"; Rec."BLRUpload Document")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    ToolTip = 'Click to upload a document related to the tenant.';
                    trigger OnDrillDown()
                    var
                        azureBlobUploader: Codeunit "BLRAzure AD Blob Storage";
                        fileName: Text;
                        uploadResult: Text;
                        folderName: Text;
                    begin
                        folderName := 'TenantDocuments';
                        fileName := azureBlobUploader.ValidateDocument(uploadResult, folderName);
                        if fileName <> '' then begin
                            Rec."BLRUpload Document" := CopyStr(fileName, 1, StrLen(fileName));
                            Rec."BLRView Document URL" := CopyStr(uploadResult, 1, StrLen(uploadResult));
                            Rec.Modify();
                            Message('File uploaded successfully: %1', fileName);
                        end;
                    end;
                }

                field("View & Download"; Rec."BLRView & Download")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    ToolTip = 'Click to view the uploaded document.';
                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin
                        // Get the URL of the uploaded document
                        FileURL := Rec."BLRView Document URL";

                        // Check if the file URL is not empty
                        if FileURL = '' then
                            Error('No document is available to view.');

                        // Open the file URL in the browser (new tab)
                        OpenFileInBrowser(FileURL);
                    end;

                }

                field("Tenant Screening"; Rec."BLRTenant Screening")
                {
                    ApplicationArea = All;
                    ToolTip = 'Tenant Screening';
                }
            }
        }
    }


    procedure SetPropertyId(pOwnerId: code[20])
    begin
        TenantId := pOwnerId;
    end;

    procedure OpenFileInBrowser(URL: Text)
    begin
        // Use the Hyperlink method to open the file in the browser
        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."BLRNo" := TenantId;
    end;

    var
        TenantId: code[20];

}