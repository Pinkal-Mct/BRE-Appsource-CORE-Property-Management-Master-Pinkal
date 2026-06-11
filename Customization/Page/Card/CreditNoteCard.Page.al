// page 50966 "Credit Note Card"
// {
//     PageType = Card;
//     SourceTable = "BLRCreditNote";
//     ApplicationArea = All;
//     Caption = 'Credit Note Card';
//     // UsageCategory = Administration;

//     layout
//     {
//         area(content)
//         {
//             group("Contract Details")
//             {
//                 field("Credit Note Type"; Rec."BLRCredit Note Type")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Credit Note Type';
//                     ToolTip = 'Enter the Credit Note Type.';
//                     Editable = false;
//                 }
//                 // field("TerminationCreditNoteType"; Rec."TerminationCreditNoteType")
//                 // {
//                 //     ApplicationArea = All;
//                 //     Caption = 'Credit Note Type';
//                 //     ToolTip = 'Enter the Credit Note Type.';
//                 //     Editable = false;
//                 //     Visible = ShowTermination;
//                 // }

//                 field("ID"; Rec."BLRID")
//                 {
//                     ApplicationArea = All;
//                     Visible = false;
//                 }
//                 field("Credit Note No."; Rec."BLRCredit Note No.")
//                 {
//                     ApplicationArea = All;
//                 }
//                 field("FC ID"; Rec."BLRFC ID")
//                 {
//                     ApplicationArea = All;
//                     Editable = false;
//                 }
//                 field("Contract ID"; Rec."BLRContract ID")
//                 {
//                     ApplicationArea = All;
//                     Lookup = true;
//                     TableRelation = "BLRFinalCalculation"."Contract ID";


//                     trigger OnValidate()
//                     var
//                         finalcalculation: Record "BLRFinalCalculation";
//                         creditnote: Record "BLRCreditNote";

//                     begin
//                         creditnote.Reset();
//                         creditnote.SetRange("BLRContract ID", Rec."BLRContract ID");
//                         if creditnote.FindFirst() then
//                             Error('This Contract ID %1 is already used in another record.', Rec."BLRContract ID");

//                         finalcalculation.SetRange("BLRContract ID", Rec."BLRContract ID");
//                         if finalcalculation.FindSet() then begin
//                             Rec."BLRCredit Note Type" := Rec."BLRCredit Note Type"::"Termination Credit Note";
//                             Rec."BLRContract Start Date" := finalcalculation."BLRContract Start Date";
//                             Rec."BLRContract End Date" := finalcalculation."BLRContract End Date"; // Convert Integer to Text
//                             Rec."BLRUnit Type" := finalcalculation."BLRUnit Type";
//                             Rec."BLRContract Amount" := finalcalculation."BLRContract Amount";
//                             Rec."BLRTenant ID" := finalcalculation."BLRTenant ID";
//                             Rec."BLRTenant Name" := finalcalculation."BLRTenant Name";
//                             Rec."BLRTenant Email" := finalcalculation."BLRTenant Email"; // Convert Integer to Text
//                             Rec."BLRFC ID" := finalcalculation."BLRFC ID";
//                             BillingCalculationSub();

//                         end else begin // Clear the fields if no record is found
//                             Rec."BLRCredit Note Type" := Rec."BLRCredit Note Type"::"Termination Credit Note";
//                             Rec."BLRContract Start Date" := 0D;
//                             Rec."BLRContract End Date" := 0D; // Convert Integer to Text
//                             Rec."BLRUnit Type" := '';
//                             Rec."BLRContract Amount" := 0;
//                             Rec."BLRTenant ID" := '';
//                             Rec."BLRTenant Name" := '';
//                             Rec."BLRTenant Email" := ''; // Convert Integer to Text
//                             Rec."BLRFC ID" := 0;
//                         end;

//                     end;
//                 }

//                 field("Credit Note Document"; Rec."BLRCredit Note Document")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Credit Note Document';
//                     DrillDown = true;
//                     Editable = false;

//                     trigger OnDrillDown()
//                     var
//                         FileURL: Text;
//                     begin
//                         // Get the URL of the uploaded document
//                         FileURL := Rec."BLRCredit Note URL";

//                         // Check if the file URL is not empty
//                         if FileURL = '' then
//                             Error('No document is available to view.');

//                         // Open the file URL in the browser (new tab)
//                         OpenFileInBrowser(FileURL);

//                     end;
//                 }

//                 field("Credit Note URL"; Rec."BLRCredit Note URL")
//                 {
//                     ApplicationArea = All;
//                     Editable = false;
//                     Visible = false;
//                 }
//                 field("Contract Start Date"; Rec."BLRContract Start Date")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Contract Start Date';
//                     ToolTip = 'Enter the Contract Start Date.';
//                     Editable = false;
//                 }
//                 field("Contract End Date"; Rec."BLRContract End Date")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Contract End Date';
//                     ToolTip = 'Enter the Contract End Date.';
//                     Editable = false;
//                 }
//                 field("Unit Type"; Rec."BLRUnit Type")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Unit Type';
//                     ToolTip = 'Enter the Unit Type.';
//                     Editable = false;
//                 }
//                 field("Contract Amount"; Rec."BLRContract Amount")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Contract Amount';
//                     ToolTip = 'Enter the Contract Amount.';
//                     Editable = false;
//                 }
//                 field("Status"; Rec."BLRStatus")
//                 {
//                     ApplicationArea = All;
//                     Editable = false;
//                 }

//             }
//             group("Customer Details")
//             {
//                 field("Tenant ID"; Rec."BLRTenant ID")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Tenant ID';
//                     Editable = false;
//                 }
//                 field("Tenant Email"; Rec."BLRTenant Email")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Tenant Email';
//                     Editable = false;
//                 }
//                 field("Tenant Name"; Rec."BLRTenant Name")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Tenant Name';
//                     Editable = false;
//                 }
//             }
//             field("Reason for Rejection"; Rec."BLRReason for Rejection")
//             {
//                 Caption = 'Reason for Rejection';
//                 Editable = false;
//             }
//             group("Billing-Calculation")
//             {
//                 part("Billing-Calculations"; "Billing Calculation CN Card")
//                 {
//                     SubPageLink = "BLRContract ID" = FIELD("BLRContract ID"); // Link to filter attachments for this owner only
//                     ApplicationArea = All;
//                     // Visible = isVisible;
//                 }

//             }
//             // group("Invoice Details")
//             // {
//             //     // Visible = IsStandardCreditNoteType;
//             //     field("Invoice ID"; Rec."Invoice ID")
//             //     {
//             //         ApplicationArea = All;
//             //         Caption = 'Invoice ID';
//             //     }
//             //     field("Amount"; Rec."Amount")
//             //     {
//             //         ApplicationArea = All;
//             //         Caption = 'Credit Note Amount';
//             //     }
//             // }
//             // group("Credit-Note Details")
//             // {
//             //     // Visible = IsStandardCreditNoteType;
//             //     part("Invoice-CreditNote"; "Invoice-Credit Note Card")
//             //     {
//             //         SubPageLink = "BLRID" = FIELD("BLRID"); // Link to filter attachments for this owner only
//             //         ApplicationArea = All;
//             //         // Visible = isVisible;
//             //     }
//             // }
//             // group("Generate Credit-Note Details")
//             // {
//             //     // Visible = IsStandardCreditNoteType;
//             //     part("Final Invoice-CreditNote"; "Filtered Invoice Detail Card")
//             //     {
//             //         SubPageLink = "BLRID" = FIELD("BLRID"); // Link to filter attachments for this owner only
//             //         ApplicationArea = All;
//             //         // Visible = isVisible;
//             //     }
//             // }
//         }
//     }


//     actions
//     {
//         area(Processing)
//         {
//             action(CreditNote)
//             {
//                 ApplicationArea = All;
//                 Caption = 'Credit Note Approval';
//                 Image = PostDocument;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 Enabled = Rec."BLRStatus" = Rec."BLRStatus"::Pending;


//                 trigger OnAction()
//                 var
//                     ApprovalCreditNote: Record "BLRCreditNoteApproval";
//                     CreditNote: Record "BLRCreditNote";
//                     billingcalculation: Record "BLRBillingCalculationCN";
//                     creditnoteamount: Decimal;
//                 begin
//                     // Validate required fields
//                     if Rec."BLRContract ID" = 0 then
//                         Error('Contract ID must be specified');

//                     // Get the actual Credit Note record
//                     if not CreditNote.Get(Rec."BLRID") then
//                         Error('Credit Note record not found.');

//                     ApprovalCreditNote.SetRange("BLRContract ID", Rec."BLRContract ID");

//                     if ApprovalCreditNote.FindSet() then begin
//                         // Modify existing approval record
//                         ApprovalCreditNote."BLRID" := CreditNote."BLRID";
//                         ApprovalCreditNote."BLRFC ID" := CreditNote."BLRFC ID";
//                         ApprovalCreditNote."BLRContract ID" := CreditNote."BLRContract ID";
//                         ApprovalCreditNote."BLRTenant ID" := CreditNote."BLRTenant ID";
//                         ApprovalCreditNote."BLRStatus" := CreditNote."BLRStatus";
//                         ApprovalCreditNote."BLRContract Start Date" := CreditNote."BLRContract Start Date";
//                         ApprovalCreditNote."BLRContract End Date" := CreditNote."BLRContract End Date";
//                         ApprovalCreditNote."BLRTenant Name" := CreditNote."BLRTenant Name";
//                         ApprovalCreditNote."BLRCredit Note Type" := CreditNote."BLRCredit Note Type"::"Termination Credit Note";
//                         ApprovalCreditNote.Modify();

//                         billingcalculation.SetRange("BLRContract ID", Rec."BLRContract ID");
//                         if billingcalculation.FindSet() then begin
//                             // Modify existing approval record
//                             repeat
//                                 creditnoteamount += billingcalculation."BLRAmount Including VAT";
//                             until billingcalculation.Next() = 0;

//                             ApprovalCreditNote."BLRCredit Note Amount" := creditnoteamount;
//                             ApprovalCreditNote.Modify();
//                         end;
//                         Message('Approval Request Modified successfully!');
//                     end else begin
//                         // Insert new approval record
//                         ApprovalCreditNote.Init();
//                         ApprovalCreditNote."BLRID" := CreditNote."BLRID";
//                         ApprovalCreditNote."BLRFC ID" := CreditNote."BLRFC ID";
//                         ApprovalCreditNote."BLRContract ID" := CreditNote."BLRContract ID";
//                         ApprovalCreditNote."BLRTenant ID" := CreditNote."BLRTenant ID";
//                         ApprovalCreditNote."BLRStatus" := CreditNote."BLRStatus";
//                         ApprovalCreditNote."BLRContract Start Date" := CreditNote."BLRContract Start Date";
//                         ApprovalCreditNote."BLRContract End Date" := CreditNote."BLRContract End Date";
//                         ApprovalCreditNote."BLRTenant Name" := CreditNote."BLRTenant Name";
//                         ApprovalCreditNote."BLRCredit Note Type" := CreditNote."BLRCredit Note Type"::"Termination Credit Note";
//                         ApprovalCreditNote.Insert(true);
//                         //  Message('Approval Request Sent successfully!');

//                         billingcalculation.SetRange("BLRContract ID", Rec."BLRContract ID");
//                         if billingcalculation.FindSet() then begin
//                             // Modify existing approval record
//                             repeat
//                                 creditnoteamount += billingcalculation."BLRAmount Including VAT";
//                             until billingcalculation.Next() = 0;

//                             ApprovalCreditNote."BLRCredit Note Amount" := creditnoteamount;
//                             ApprovalCreditNote.Modify();
//                         end;
//                         Message('Approval Request Sent successfully!');
//                     end;
//                 end;

//             }

//             action("Create Credit Note")
//             {
//                 Caption = 'Credit Note Document';
//                 ApplicationArea = All;
//                 Image = NewDocument; // Use an appropriate icon for the action
//                 Promoted = true; // Make the action visible in the header
//                 PromotedCategory = Process; // Place it in the "Process" category
//                 PromotedIsBig = true; // Make it a prominent action

//                 trigger OnAction()
//                 var
//                     CreditNotetable: Record "BLRCreditNote";
//                     CreditNoteReport: Report "Terminated Credit Note";
//                     azureBlobUploader: Codeunit "Azure AD Blob Storage";
//                     fileName: Text;
//                     uploadResult: Text;
//                     folderName: Text;
//                     inStream: InStream;
//                     Billingcalculationgrid: Record "BLRFinalBillingCalculationGrid";
//                     TempBlob: Codeunit "Temp Blob";
//                     OutStream: OutStream;
//                 begin
//                     // Credit Note table માં filter set કરો
//                     CreditNotetable.Reset();
//                     CreditNotetable.SetRange(ID, Rec."BLRID");

//                     if not CreditNotetable.FindFirst() then
//                         Error('Credit Note record not found for ID: %1', Rec."BLRID");

//                     // Report માં table view set કરો
//                     CreditNoteReport.SetTableView(CreditNotetable);
//                     CreditNoteReport.UseRequestPage(false);

//                     // PDF generate કરો
//                     TempBlob.CreateOutStream(OutStream);
//                     CreditNoteReport.SaveAs('', ReportFormat::Pdf, OutStream);
//                     TempBlob.CreateInStream(InStream);

//                     FileName := 'CreditNote_' + Format(Rec."BLRID") + '.pdf';

//                     folderName := 'Payment Receipt';
//                     uploadResult := azureBlobUploader.UploadDocumentToBlob(inStream, fileName, folderName);

//                     if uploadResult <> '' then begin
//                         Rec."BLRCredit Note Document" := fileName;
//                         Rec."BLRCredit Note URL" := uploadResult;
//                         Rec.Modify();
//                         Message('File uploaded successfully: %1', fileName);
//                     end else
//                         Error('File upload failed');

//                     // Update Billing Calculation Grid
//                     Billingcalculationgrid.SetRange("BLRContract ID", Rec."BLRContract ID");
//                     if Billingcalculationgrid.FindSet() then begin
//                         Billingcalculationgrid."Credit Note Document" := Rec."BLRCredit Note Document";
//                         Billingcalculationgrid."Credit Note Document URL" := Rec."BLRCredit Note URL";
//                         Billingcalculationgrid.Modify(true);
//                     end;
//                 end;
//             }
//         }
//     }

//     // var
//     //     IsStandardCreditNoteType: Boolean;

//     // trigger OnAfterGetRecord()
//     // begin
//     //     if Rec."BLRCredit Note Type" = Rec."BLRCredit Note Type"::"Standard Credit Note" then begin
//     //         IsStandardCreditNoteType := true;
//     //     end else begin
//     //         IsStandardCreditNoteType := false;
//     //     end;
//     // end;

//     // trigger OnNewRecord(BelowxRec: Boolean)
//     // var
//     //     CreditNoteRec: Record "BLRCreditNote";
//     //     NextID: Integer;
//     // begin
//     //     if Rec."BLRID" = 0 then begin
//     //         if CreditNoteRec.FindLast() then
//     //             NextID := CreditNoteRec."BLRID" + 1
//     //         else
//     //             NextID := 1;

//     //         Rec."BLRID" := NextID;

//     //     end;
//     // end;


//     procedure BillingCalculationSub()
//     var
//         BillingCalculationSubCN: Record "BLRBillingCalculationCN";
//         BillingCalculationSubFC: Record "BLRFinalBillingCalculationGrid";
//     begin


//         BillingCalculationSubCN.SetRange("BLRContract ID", Rec."BLRContract ID");
//         if BillingCalculationSubCN.FindSet() then begin
//             BillingCalculationSubCN.DeleteAll();
//         end;

//         // TenancyContractLine.Reset();
//         BillingCalculationSubFC.SetRange("BLRContract ID", Rec."BLRContract ID");
//         if BillingCalculationSubFC.FindSet() then begin
//             repeat
//                 if BillingCalculationSubFC."DifferenceAmount" > 0 then begin
//                     BillingCalculationSubCN.Init();
//                     BillingCalculationSubCN."BLRCredit Note ID" := Rec."BLRID";
//                     BillingCalculationSubCN."BLRContract ID" := Rec."BLRContract ID";
//                     BillingCalculationSubCN."BLRTenant ID" := Rec."BLRTenant ID";
//                     BillingCalculationSubCN."BLRItem" := BillingCalculationSubFC."RevenueDescription";
//                     BillingCalculationSubCN."BLRAmount" := BillingCalculationSubFC."DifferenceAmount";
//                     BillingCalculationSubCN."BLRVAT Amount" := BillingCalculationSubFC."DifferenceVAT";
//                     BillingCalculationSubCN."BLRAmount Including VAT" := BillingCalculationSubFC."DifferenceAmountInclVAT";
//                     BillingCalculationSubCN.Insert();
//                     Clear(BillingCalculationSubCN);
//                 end;
//             until BillingCalculationSubFC.Next() = 0;
//         end;

//     end;

//     procedure ShowCreditNoteInBillingCalculationGrid()
//     var
//         Billingcalculationgrid: Record "BLRFinalBillingCalculationGrid";
//     begin
//         Billingcalculationgrid.SetRange("BLRContract ID", Rec."BLRContract ID");
//         if Billingcalculationgrid.FindSet() then begin
//             Billingcalculationgrid."BLRCredit Note ID" := Rec."BLRCredit Note No.";
//             // Billingcalculationgrid."Credit Note Document" := Rec."BLRCredit Note Document";
//             // Billingcalculationgrid."Credit Note Document URL" := Rec."BLRCredit Note URL";
//             Billingcalculationgrid.Modify();
//         end;
//     end;

//     procedure ShowCreditNoteInBillingCalculationSubGrid()
//     var
//         Billingcalculationgrid: Record "BLRBillingCalculationCN";
//     begin
//         Billingcalculationgrid.SetRange("BLRContract ID", Rec."BLRContract ID");
//         if Billingcalculationgrid.FindSet() then begin
//             repeat
//                 Billingcalculationgrid."BLRCredit Note ID" := Rec."BLRID";
//                 Billingcalculationgrid.Modify();
//             until Billingcalculationgrid.Next() = 0;

//         end;
//     end;

//     procedure OpenFileInBrowser(URL: Text)
//     begin
//         // Use the Hyperlink method to open the file in the browser
//         if URL <> '' then
//             Hyperlink(URL)
//         else
//             Error('The file URL is invalid.');
//     end;

//     trigger OnAfterGetRecord()
//     var
//     begin
//         ShowCreditNoteInBillingCalculationGrid();
//         ShowCreditNoteInBillingCalculationSubGrid();
//     end;
// }



