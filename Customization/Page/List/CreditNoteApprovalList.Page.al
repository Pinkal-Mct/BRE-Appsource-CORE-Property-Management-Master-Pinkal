// page 50969 "Credit Note Approval List"
// {
//     PageType = List;
//     SourceTable = "Credit Note Approval";
//     ApplicationArea = All;
//     Caption = 'Credit Note Approval List';
//     UsageCategory = Lists;
//     InsertAllowed = false;
//     ModifyAllowed = false;


//     layout
//     {
//         area(content)
//         {
//             repeater(Group)
//             {
//                 field("Status"; Rec."Status")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Status';
//                     Editable = false;
//                     ToolTip = 'Specifies the current status of the credit note approval.';
//                 }
//                 field("ID"; Rec."ID")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'ID';
//                     Editable = false;
//                     DrillDown = true;
//                     ToolTip = 'Specifies the unique identifier for the credit note approval record.';

//                     trigger OnDrillDown()
//                     var
//                         CreditNote: Record "Credit Note";
//                     begin
//                         CreditNote.SetRange("ID", Rec."ID");
//                         if CreditNote.FindSet() then
//                             PAGE.RunModal(PAGE::"Credit Note Card", CreditNote)
//                         else
//                             Message('No Credit Note found using FindFirst either.');
//                     end;
//                 }
//                 field("FC ID"; Rec."FC ID")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'FC ID';
//                     Editable = false;
//                     DrillDown = true;
//                     ToolTip = 'Specifies the unique identifier for the final calculation associated with the credit note approval.';

//                     trigger OnDrillDown()
//                     var
//                         finalcalculation: Record "Final Calculation";
//                     begin
//                         finalcalculation.SetRange("FC ID", Rec."FC ID");
//                         if finalcalculation.FindSet() then
//                             PAGE.RunModal(PAGE::"Final Calculation Card", finalcalculation)
//                         else
//                             Message('No Final Calculation found using FindFirst either.');
//                     end;
//                 }
//                 field("Contract ID"; Rec."Contract ID")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Contract ID';
//                     Editable = false;
//                     DrillDown = true;
//                     ToolTip = 'Specifies the unique identifier for the contract associated with the credit note approval.';

//                     trigger OnDrillDown()
//                     var
//                         tenancycontract: Record "Tenancy Contract";
//                     begin
//                         tenancycontract.SetRange("Contract ID", Rec."Contract ID");
//                         if tenancycontract.FindSet() then
//                             PAGE.RunModal(PAGE::"Tenancy Contract Card", tenancycontract)
//                         else
//                             Message('No Tenancy Contract found using FindFirst either.');
//                     end;
//                 }
//                 field("Credit Note Amount"; Rec."Credit Note Amount")
//                 {
//                     ApplicationArea = All;
//                     Editable = false;
//                     ToolTip = 'Specifies the total amount of the credit note approval.';
//                 }

//                 field("Contract Start Date"; Rec."Contract Start Date")
//                 {
//                     ApplicationArea = All;
//                     Editable = false;
//                     ToolTip = 'Specifies the start date of the contract associated with the credit note approval.';
//                 }
//                 field("Contract End Date"; Rec."Contract End Date")
//                 {
//                     ApplicationArea = All;
//                     Editable = false;
//                     ToolTip = 'Specifies the end date of the contract associated with the credit note approval.';
//                 }

//                 field("Tenant ID"; Rec."Tenant ID")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Tenant ID';
//                     Editable = false;
//                     ToolTip = 'Specifies the unique identifier for the tenant associated with the credit note approval.';
//                 }
//                 field("Tenant Name"; Rec."Tenant Name")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Tenant Name';
//                     Editable = false;
//                     ToolTip = 'Specifies the name of the tenant associated with the credit note approval.';
//                 }
//                 field("Credit Note Type"; Rec."Credit Note Type")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Credit Note Type';
//                     Editable = false;
//                     ToolTip = 'Specifies the type of credit note associated with the approval.';
//                 }

//             }
//         }
//     }

//     actions
//     {
//         area(Processing)
//         {
//             action(Approve)
//             {
//                 ApplicationArea = All;
//                 Caption = 'Approve';
//                 Image = Approve;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 Visible = IsFinanceManager;
//                 ToolTip = 'Approve the selected credit note approval.';


//                 trigger OnAction()
//                 var
//                     CreditNote: Record "Credit Note";
//                     FinalcalculationBilling: Record "Final Billing Calculation Grid";
//                     createSalescreditmemo: Codeunit "Create Sales Credit Memo";
//                 begin
//                     if Rec.Status = Rec.Status::Approved then
//                         Error('This entry is already approved');

//                     if Confirm('Do you want to approve this entry?') then begin
//                         // Update entry status
//                         Rec.Status := Rec.Status::Approved;
//                         Rec.Modify();
//                         createSalescreditmemo.CreateSalesCreditMemo(Rec);
//                         // Update main record status
//                         if CreditNote.Get(Rec."ID") then begin
//                             CreditNote.Status := CreditNote.Status::Approved;
//                             CreditNote.Modify();
//                         end;

//                         FinalcalculationBilling.SetRange("Contract ID", CreditNote."Contract ID");
//                         if FinalcalculationBilling.FindSet() then begin
//                             FinalcalculationBilling."Creditnote" := true;
//                             FinalcalculationBilling."Credit Note To Be Raised" := 0;
//                             FinalcalculationBilling.Modify(true);
//                         end else
//                             Error('No Final Billing Calculation record found for Contract ID %1', CreditNote."Contract ID");

//                         Message('Entry has been approved successfully!');
//                     end;
//                 end;
//             }
//             action(Reject)
//             {
//                 ApplicationArea = All;
//                 Caption = 'Reject';
//                 Image = Cancel;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;
//                 Visible = IsFinanceManager;
//                 ToolTip = 'Reject the selected credit note approval.';

//                 trigger OnAction()
//                 var
//                     CreditNote: Record "Credit Note";
//                     DialogPage: Page DialogBoxForInvoiceRejection;
//                     ReasonForRejection: Text;
//                 begin
//                     if Rec.Status = Rec.Status::Reject then
//                         Error('This entry is already rejected');

//                     if Confirm('Do you want to reject this entry?') then
//                         if DialogPage.RunModal() = Action::OK then begin
//                             ReasonForRejection := DialogPage.GetReason();

//                             if (ReasonForRejection = '') then
//                                 Error('Please enter a reason for rejection.');

//                             // Update current record
//                             Rec.Status := Rec.Status::Reject;
//                             // Rec."Reason for Rejection" := ReasonForRejection;
//                             Rec.Modify();

//                             // Update Credit Note record
//                             if CreditNote.Get(Rec."ID") then begin
//                                 CreditNote.Status := CreditNote.Status::Reject;
//                                 CreditNote."Reason for Rejection" := CopyStr(ReasonForRejection, 1, StrLen(ReasonForRejection));
//                                 CreditNote.Modify();
//                             end;

//                             Message('Entry has been rejected successfully!');
//                         end else
//                             Error('Rejection cancelled.');

//                 end;

//             }
//         }

//     }

//     trigger OnOpenPage()
//     var

//     begin
//         // Check if the current user has the 'LEASE_MANAGER' permission set

//         IsFinanceManager := VisibleApproveAction();
//     end;

//     procedure VisibleApproveAction(): Boolean
//     var
//         UserPersonalization: Record "User Personalization";
//     begin

//         if UserPersonalization.Get(UserSecurityId()) then
//             case UserPersonalization."Profile ID" of
//                 'PROPERTY MANAGER':
//                     exit(false);
//                 'LEASE_MANAGER':
//                     exit(false);
//                 'finance manager':
//                     exit(true);
//             end;

//         exit(false);
//     end;

//     var
//         IsFinanceManager: Boolean;

// }
