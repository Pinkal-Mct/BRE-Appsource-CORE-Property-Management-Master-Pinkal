page 50732 "final payment approval"
{
    PageType = List;
    SourceTable = finalPaymentApproval;
    ApplicationArea = All;
    Caption = 'Final Payment Approval';
    UsageCategory = Lists;
    InsertAllowed = true;
    ModifyAllowed = true;
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
                    Editable = true;
                    ToolTip = 'Specifies the unique identifier for the final payment approval record.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the current status of the final payment approval.';
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the unique identifier for the tenant associated with this payment approval.';
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the name of the tenant associated with this payment approval.';
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the unique identifier for the contract associated with this payment approval.';
                }
                field("Payment transaction ID"; Rec."Payment transaction ID")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the unique identifier for the payment transaction associated with this payment approval.';
                }

                field("Payment Date"; Rec."Payment Date")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the date of the payment associated with this approval.';
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the total amount of the payment associated with this approval.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the due date for the payment approval.';
                }
                field("Payment mode"; Rec."Payment mode")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the mode of payment for this approval.';
                }
                field(Description; Rec.Description)
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
                    Finalsettlement: Record "FinalSettlement";
                    SelectedRecs: Record "finalPaymentApproval";
                    ApproveCount: Integer;
                    ErrorCount: Integer;
                    PaymentStatus: Enum "Payment Status";
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
                                SelectedRecs.Status := 'Received';
                                SelectedRecs.Modify();

                                Finalsettlement.SetRange("Contract ID", SelectedRecs."Contract ID");
                                if Finalsettlement.FindSet() then begin
                                    Finalsettlement."Receivable Payment Status" := PaymentStatus::Received;
                                    Finalsettlement.receivablePaymentStatuss := 'Received';
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
                    SelectedRecs: Record "finalPaymentApproval";
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
                                SelectedRecs.Status := 'Not Received'; // Set status to "Declined"
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