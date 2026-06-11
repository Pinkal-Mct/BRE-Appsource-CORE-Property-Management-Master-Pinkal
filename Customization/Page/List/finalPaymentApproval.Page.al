page 73209778 "BLRfinal payment approval"
{
    PageType = List;
    SourceTable = BLRfinalPaymentApproval;
    ApplicationArea = All;
    Caption = 'Final Payment Approval';
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
                field("ID"; Rec."BLRID")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the unique identifier for the final payment approval record.';
                }
                field(Status; Rec.BLRStatus)
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the current status of the final payment approval.';
                }

                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the unique identifier for the tenant associated with this payment approval.';
                }
                field("Tenant Name"; Rec."BLRTenant Name")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the name of the tenant associated with this payment approval.';
                }
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the unique identifier for the contract associated with this payment approval.';
                }
                field("Payment transaction ID"; Rec."BLRPayment transaction ID")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the unique identifier for the payment transaction associated with this payment approval.';
                }

                field("Payment Date"; Rec."BLRPayment Date")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the date of the payment associated with this approval.';
                }
                field("Total Amount"; Rec."BLRTotal Amount")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the total amount of the payment associated with this approval.';
                }
                field("Due Date"; Rec."BLRDue Date")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the due date for the payment approval.';
                }
                field("Payment mode"; Rec."BLRPayment mode")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the mode of payment for this approval.';
                }
                field(Description; Rec.BLRDescription)
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the description or notes related to the payment approval.';
                }

            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Received)
            {
                Caption = 'Received';
                ApplicationArea = All;
                Image = Approve;
                ToolTip = 'Approve selected records as received';

                trigger OnAction()
                var
                    Finalsettlement: Record "BLRFinalSettlement";
                    SelectedRecs: Record "BLRfinalPaymentApproval";
                    ApproveCount: Integer;
                    ErrorCount: Integer;
                    PaymentStatus: Enum "BLRPayment Status";
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
                            if SelectedRecs."BLRStatus" = 'Pending' then begin
                                SelectedRecs."BLRStatus" := 'Received';
                                SelectedRecs.Modify();

                                Finalsettlement.SetRange("BLRContract ID", SelectedRecs."BLRContract ID");
                                if Finalsettlement.FindSet() then begin
                                    Finalsettlement."BLRReceivable Payment Status" := PaymentStatus::Received;
                                    Finalsettlement."BLRreceivablePaymentStatuss" := 'Received';
                                    Finalsettlement.Modify(true);
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
            action(NotReceived)
            {
                Caption = 'Not Received';
                ApplicationArea = All;
                Image = Reject;
                ToolTip = 'Reject selected records as not received';

                trigger OnAction()
                var
                    SelectedRecs: Record "BLRfinalPaymentApproval";
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
                            if SelectedRecs."BLRStatus" = 'Pending' then begin
                                SelectedRecs."BLRStatus" := 'Not Received'; // Set status to "Declined"
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