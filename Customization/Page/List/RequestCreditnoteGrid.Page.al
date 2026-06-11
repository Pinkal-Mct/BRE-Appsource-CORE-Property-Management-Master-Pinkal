page 73209800 "BLRRequest CreditNote Grid"
{
    PageType = ListPart;
    SourceTable = "BLRRequestCreditNoteGrid";
    ApplicationArea = All;
    Caption = 'Request Credit Note Grid';
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Request No."; Rec."BLRRequest No.")
                {
                    ApplicationArea = All;
                    Caption = 'Request No.';
                    ToolTip = 'Specifies the unique number of the credit note request.';
                }
                field("Payment Series"; Rec."BLRPayment Series")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Series';
                    ToolTip = 'Specifies the payment series associated with this request.';
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        paymentmode2Rec: Record "BLRPaymentMode2";
                    begin
                        Rec."BLRCurrent Charges Amount" := 0;
                        paymentmode2Rec.SetRange("BLRContract ID", ContractID);
                        if Page.RunModal(Page::"BLRPayment Mode2 List", paymentmode2Rec) = Action::LookupOK then begin
                            Rec."BLRPayment Series" := paymentmode2Rec."BLRPayment Series";
                            Rec."BLRContract ID" := ContractID;
                            if Rec."BLRLine No." = 0 then
                                Rec.Insert(true);
                            paymentmode2Rec.SetRange("BLRPayment Series", Rec."BLRPayment Series");
                            paymentmode2Rec.SetRange("BLRContract ID", Rec."BLRContract ID");
                            if paymentmode2Rec.FindFirst() then begin
                                Rec."BLRCurrent Charges Amount" := paymentmode2Rec."BLRAmount";
                                Rec."BLRTotal Reduction" := Rec."BLRCurrent Charges Amount";
                            end;
                        end;
                    end;
                }
                field("Charges"; Rec."BLRCharges")
                {
                    ApplicationArea = All;
                    Caption = 'View Charges Details';
                    ToolTip = 'Click to view detailed charges for this request.';
                    TableRelation = "BLRPaymentSchedule2"."BLRSecondary Item Type" where("BLRContract ID" = field("BLRContract ID"), "BLRPayment Series" = field("BLRPayment Series"));
                    trigger OnValidate()
                    var
                        PaymentSchedule2: Record "BLRPaymentSchedule2";
                    begin
                        PaymentSchedule2.SetRange("BLRContract ID", Rec."BLRContract ID");
                        PaymentSchedule2.SetRange("BLRPayment Series", Rec."BLRPayment Series");
                        PaymentSchedule2.SetRange("BLRSecondary Item Type", Rec.BLRCharges);
                        if PaymentSchedule2.FindFirst()
                        then begin
                            Rec."BLRCurrent Charges Amount" := PaymentSchedule2."BLRAmount";
                            Rec."BLRTotal Reduction" := Rec."BLRCurrent Charges Amount";
                            Rec.BLRInvoiced := PaymentSchedule2."BLRInvoiced";
                            Rec."BLRInvoice ID" := PaymentSchedule2."BLRInvoice ID";
                        end;
                    end;
                }
                field("Current Charges Amount"; Rec."BLRCurrent Charges Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Current Charges Amount';
                    Editable = false;
                    ToolTip = 'Shows the current charges amount for this request.';
                }
                field("Total Reduction"; Rec."BLRTotal Reduction")
                {
                    ApplicationArea = All;
                    Caption = 'Total Reduction';
                    ToolTip = 'Specifies the total reduction amount to be applied to the charges.';
                    trigger OnValidate()
                    var
                    begin
                        if Rec."BLRTotal Reduction" > Rec."BLRCurrent Charges Amount" then
                            Error('Total Rent Reduction cannot exceed Current Charges Amount.');
                        Rec."BLRTotal Pay Rent Amount" := Rec."BLRCurrent Charges Amount" - Rec."BLRTotal Reduction";
                    end;
                }
                field("Total Pay Amount"; Rec."BLRTotal Pay Rent Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Total Pay Amount';
                    ToolTip = 'Shows the total amount to be paid after reduction.';
                    Editable = false;
                }
                field("Invoice ID"; Rec."BLRInvoice ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Displays the invoice ID associated with this request.';
                    Editable = false;
                }
                field(Invoiced; Rec.BLRInvoiced)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Indicates whether this request has been invoiced.';
                }
                field("Credit Note No."; Rec."BLRCredit Note No.")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Note No.';
                    Editable = false;
                    ToolTip = 'Displays the generated credit note number.';
                }
                field("Credit Memo Generated"; Rec."BLRCredit Memo Generated")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Memo Generated';
                    Editable = IsFinanceManager;
                    ToolTip = 'Indicates whether a credit memo has been generated for this request.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(CeateandApplyCreditMemo)
            {
                Caption = 'Create & Apply Credit Memo';
                ToolTip = 'Create and post Sales credit memo';
                Image = CreditMemo;
                ApplicationArea = All;
                trigger OnAction()
                var
                    RequestCreditNoteRec: Record "BLRRequestCreditNote";
                    GenerateCreditMemo: Codeunit "BLRCredit Memo Generate";
                    UserConfirmed: Boolean;
                begin
                    RequestCreditNoteRec.SetRange("BLRRequest No.", Rec."BLRRequest No.");
                    RequestCreditNoteRec.SetRange(BLRStatus, RequestCreditNoteRec."BLRStatus"::Approved);
                    RequestCreditNoteRec.SetRange("BLRAdjust with Invoice", RequestCreditNoteRec."BLRAdjust with Invoice"::Pending);
                    if RequestCreditNoteRec.FindFirst() then begin
                        UserConfirmed := Confirm('Do you want to create and post the Sales Credit Memo now?', false);
                        if UserConfirmed then
                            GenerateCreditMemo.GenerateCreditMemo(Rec)
                        else
                            Message('Operation canceled by user.')
                    end
                    else
                        if RequestCreditNoteRec."BLRStatus" <> RequestCreditNoteRec."BLRStatus"::Approved then
                            Error('Credit Note must be approved before creating and applying a credit memo.');
                    if RequestCreditNoteRec."BLRAdjust with Invoice" = RequestCreditNoteRec."BLRAdjust with Invoice"::Adjusted then
                        Error('The Credit Note is already adjusted');
                end;
            }
        }
    }
    var
        ContractID: Integer;
        IsFinanceManager: Boolean;

    procedure SetContractID(pContractID: Integer)
    begin
        ContractID := pContractID;
    end;

    trigger OnOpenPage()
    var
    begin
        IsFinanceManager := CheckUserRole();
    end;

    procedure CheckUserRole(): Boolean
    var
        UserPersonalization: Record "User Personalization";
    begin
        if UserPersonalization.Get(UserSecurityId()) then
            case UserPersonalization."Profile ID" of
                'FINANCE MANAGER':
                    exit(true);
                else
                    exit(false);
            end;
        exit(false);
    end;
}