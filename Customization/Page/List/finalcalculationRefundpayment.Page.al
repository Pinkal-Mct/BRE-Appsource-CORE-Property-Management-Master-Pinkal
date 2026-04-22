page 73209777 "finalcalculation_Refundpayment"
{
    PageType = List;
    SourceTable = finalcalculation_refunApproval;
    ApplicationArea = All;
    Caption = 'Final Calculation Refund Approval';
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the final calculation refund approval record.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the current status of the final calculation refund approval.';
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the tenant associated with this refund approval.';
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the tenant associated with this refund approval.';
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the contract associated with this refund approval.';
                }
                field(fcID; Rec.fcID)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the final calculation associated with this refund approval.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the due date for the final calculation refund approval.';
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the total amount of the final calculation refund approval.';
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the bank associated with this refund approval.';
                }
                field("Branch Address"; Rec."Branch Address")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the address of the bank branch associated with this refund approval.';
                }
                field("Account Holder Name"; Rec."Account Holder Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the account holder for the bank account associated with this refund approval.';
                }
                field("Account Number"; Rec."Account Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the bank account number associated with this refund approval.';
                }
                field("Swift Code"; Rec."Swift Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the SWIFT code for the bank associated with this refund approval.';
                }
                field("IBAN number"; Rec."IBAN number")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the IBAN number for the bank account associated with this refund approval.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies any additional description or notes related to the final calculation refund approval.';
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the date when the refund approval request was made.';
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action(paid)
            {
                Caption = 'paid';
                ApplicationArea = All;
                Image = Approve;
                ToolTip = 'Approve selected records as paid';

                trigger OnAction()
                var
                    FinalsettlementRefund: Record "FinalSettlementRefund";
                    SelectedRecs: Record "finalcalculation_refunApproval";
                    ApproveCount: Integer;
                    ErrorCount: Integer;
                begin
                    CurrPage.SetSelectionFilter(SelectedRecs);

                    if SelectedRecs.IsEmpty() then begin
                        Message('No records selected for approval.');
                        exit;
                    end;

                    ApproveCount := 0;
                    ErrorCount := 0;

                    if SelectedRecs.FindSet() then
                        repeat
                            if SelectedRecs.Status = 'Pending' then begin
                                SelectedRecs.Status := 'paid';
                                SelectedRecs.Modify();

                                FinalsettlementRefund.SetRange("Contract ID", SelectedRecs."Contract ID");

                                if FinalsettlementRefund.FindSet() then begin
                                    FinalsettlementRefund."Refund Payment Status" := FinalsettlementRefund."Refund Payment Status"::Paid;
                                    FinalsettlementRefund.Modify(true);
                                end;

                                ApproveCount += 1;
                            end else
                                ErrorCount += 1;
                        until SelectedRecs.Next() = 0;

                    Commit();
                    CurrPage.Update(false);
                    Message('%1 record(s) approved. %2 record(s) were not in "Pending" status.', ApproveCount, ErrorCount);
                end;
            }
            action(NotPaid)
            {
                Caption = 'Not Paid';
                ApplicationArea = All;
                Image = Cancel;
                ToolTip = 'Reject selected records as not paid';

                trigger OnAction()
                var
                    SelectedRecs: Record "finalcalculation_refunApproval";
                    RejectCount: Integer;
                    ErrorCount: Integer;
                begin
                    // Store selected records
                    CurrPage.SetSelectionFilter(SelectedRecs);

                    if SelectedRecs.IsEmpty() then begin
                        Message('No records selected for rejection.');
                        exit;
                    end;

                    RejectCount := 0;
                    ErrorCount := 0;

                    if SelectedRecs.FindSet() then
                        repeat
                            if SelectedRecs.Status = 'Pending' then begin
                                SelectedRecs.Status := 'Not Paid'; // Set status to "Declined"
                                SelectedRecs.Modify();
                                RejectCount += 1;
                            end else
                                ErrorCount += 1; // Count records that are not in "Pending" status
                        until SelectedRecs.Next() = 0;
                    Commit(); // Commit changes
                    CurrPage.Update(false); // Refresh page
                    // Display result messages
                    Message('%1 record(s) rejected. %2 record(s) were not in "Pending" status.', RejectCount, ErrorCount);
                end;
            }
        }
    }
}