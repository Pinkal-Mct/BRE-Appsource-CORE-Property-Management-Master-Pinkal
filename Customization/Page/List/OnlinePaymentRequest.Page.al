page 73209787 "BLROnline Payment Request"
{
    PageType = List;
    SourceTable = BLROnlinePaymentApproval;
    ApplicationArea = All;
    Caption = 'Payment receive Approval';
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Permissions =
        tabledata BLROnlinePaymentApproval = RM,
        tabledata "BLRPaymentMode2" = RM,
        tabledata "BLRPaymentSchedule2" = RM;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID"; Rec."BLRID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the online payment request.';
                }
                field(Status; Rec."BLRStatus")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Status of the online payment request, such as Pending, Received, or Not Received.';
                }
                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the tenant associated with the online payment request.';
                }
                field("Tenant Name"; Rec."BLRTenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Name of the tenant associated with the online payment request.';
                }
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the contract associated with the online payment request.';
                }
                field("Payment transaction ID"; Rec."BLRPayment transaction ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the payment transaction associated with the online payment request.';
                }
                field("Payment Series"; Rec."BLRPayment Series")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Payment series associated with the online payment request.';
                }
                field("Payment Date"; Rec."BLRPayment Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Date of the payment associated with the online payment request.';
                }
                field("Total Amount"; Rec."BLRTotal Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Total amount of the payment associated with the online payment request.';
                }
                field("Due Date"; Rec."BLRDue Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Due date for the payment associated with the online payment request.';
                }
                field("Payment mode"; Rec."BLRPayment mode")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Payment mode used for the online payment request, such as Credit Card, Bank Transfer, etc.';
                }
                field(Description; Rec.BLRDescription)
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Description of the online payment request.';
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
                ToolTip = 'Approve the selected online payment requests.';
                Image = Approve;

                trigger OnAction()
                var
                    SelectedRecs: Record "BLROnlinePaymentApproval";
                    PaymentRec: Record "BLRPaymentMode2";
                    PaymentScheduleRec: Record "BLRPaymentSchedule2";
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

                                PaymentRec.SetRange(PaymentRec."BLRContract ID", SelectedRecs."BLRContract ID");
                                PaymentRec.SetRange(PaymentRec."BLRTenant ID", SelectedRecs."BLRTenant ID");
                                PaymentRec.SetRange(PaymentRec."BLRPayment Series", SelectedRecs."BLRPayment Series");

                                if PaymentRec.FindSet() then begin
                                    // Update the status of OnlinePaymentApproval record
                                    PaymentRec."BLRApprove/Decline Status" := 'Received';
                                    // PaymentRec."BLRPayment Status" := PaymentStatus::Received;
                                    PaymentRec.Validate("BLRPayment Status", PaymentStatus::Received);
                                    PaymentRec."BLRPayment Received Date" := Today;
                                    PaymentRec.Modify(true);
                                end;

                                PaymentScheduleRec.SetRange(PaymentScheduleRec."BLRContract ID", PaymentRec."BLRContract ID");
                                PaymentScheduleRec.SetRange(PaymentScheduleRec."BLRTenant ID", PaymentRec."BLRTenant ID");
                                PaymentScheduleRec.SetRange(PaymentScheduleRec."BLRPayment Series", PaymentRec."BLRPayment Series");

                                // Loop through the Payment Schedule records to find matching Payment Series
                                if PaymentScheduleRec.FindSet() then
                                    repeat
                                        // Update Payment Schedule status to "Received" for the matching Payment Series
                                        PaymentScheduleRec."BLRPayment Status" := 'Received';
                                        PaymentScheduleRec."BLRPayment Recieved Date" := PaymentRec."BLRPayment Received Date";
                                        PaymentScheduleRec.Modify(); // Save the updated record
                                    until PaymentScheduleRec.Next() = 0; // Continue until all matching records are processed

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
                ToolTip = 'Reject the selected online payment requests.';

                trigger OnAction()
                var
                    SelectedRecs: Record "BLROnlinePaymentApproval";
                    PaymentRec: Record "BLRPaymentMode2";
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

                                PaymentRec.SetRange(PaymentRec."BLRContract ID", SelectedRecs."BLRContract ID");
                                PaymentRec.SetRange(PaymentRec."BLRTenant ID", SelectedRecs."BLRTenant ID");
                                PaymentRec.SetRange(PaymentRec."BLRPayment Series", SelectedRecs."BLRPayment Series");

                                if PaymentRec.FindSet() then begin
                                    // Update the status of OnlinePaymentApproval record
                                    PaymentRec."BLRApprove/Decline Status" := 'Not Received';
                                    PaymentRec.Modify(true);
                                end;

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