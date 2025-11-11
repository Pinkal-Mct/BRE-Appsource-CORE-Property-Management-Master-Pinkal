page 50509 "PDC Transaction"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "PDC Transaction";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                Caption = 'General Information';
                field("PDC ID"; Rec."PDC ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the record.';
                }

                field("payment Series"; Rec."payment Series")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The series of the payment associated with this PDC transaction.';
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The unique identifier for the contract associated with this PDC transaction.';
                }
                field("Tenant Name"; Rec."Tenant Id")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The name of the tenant associated with this PDC transaction.';
                }
                field("Tenant"; Rec."Tenant Name Display")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The display name of the tenant associated with this PDC transaction.';
                }
                field("Cheque Number"; Rec."Cheque Number")
                {
                    ApplicationArea = All;
                    Editable = IsFieldEditable;
                    ToolTip = 'The cheque number associated with this PDC transaction.';
                    trigger OnValidate()
                    var
                        PaymentSeriesRec: Record "Payment Mode2";
                    begin
                        PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                        PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                        if PaymentSeriesRec.FindSet() then begin
                            PaymentSeriesRec."Cheque Number" := Rec."Cheque Number";
                            PaymentSeriesRec.Modify();
                        end;
                    end;
                }
                field("Bank Name"; Rec."Bank Name")
                {
                    ApplicationArea = All;
                    Editable = IsFieldEditable;
                    ToolTip = 'The name of the bank associated with this PDC transaction.';
                    trigger OnValidate()
                    var
                        PaymentSeriesRec: Record "Payment Mode2";
                    begin
                        PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                        PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                        if PaymentSeriesRec.FindSet() then begin
                            PaymentSeriesRec."Deposit Bank" := Rec."Bank Name";
                            PaymentSeriesRec.Modify();
                        end;
                    end;
                }

                field("Cheque Date"; Rec."Cheque Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The date of the cheque associated with this PDC transaction.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Editable = IsFieldEditable;
                    ToolTip = 'The amount of the cheque associated with this PDC transaction.';
                }
                field("Old Cheque#"; Rec."Old Cheque#")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The old cheque number if this cheque has been replaced.';
                }
                field(Status; Rec."Cheque Status")
                {
                    ApplicationArea = All;
                    Editable = IsLeaseManager;
                    ToolTip = 'The status of the cheque associated with this PDC transaction.';
                    trigger OnValidate()
                    var
                        PaymentSeriesRec: Record "Payment Mode2";
                        CashReceiptJournalCodeunit: Codeunit "Cash Receipt Journal Entry";
                        oldStatus: Enum "PDC Status Type Enum";

                    begin

                        oldStatus := xRec."Cheque Status";

                        case oldStatus of

                            oldStatus::Cleared:
                                Error('Cheque status cannot be changed once it is Cleared.');
                            oldStatus::Deposited:
                                if (Rec."Cheque Status" = Rec."Cheque Status"::"Cheque Received") OR (Rec."Cheque Status" = Rec."Cheque Status"::Retrieved) OR
                                    (Rec."Cheque Status" = Rec."Cheque Status"::"Replaced & Received") then begin
                                    Rec."Cheque Status" := oldStatus;
                                    Error('Cannot change Deposited status to %1.', Rec."Cheque Status");
                                end;

                            oldStatus::"Due cheque not deposited":
                                if (Rec."Cheque Status" = Rec."Cheque Status"::Cleared) OR (Rec."Cheque Status" = Rec."Cheque Status"::Returned) OR
                                (Rec."Cheque Status" = Rec."Cheque Status"::"Replaced & Received") then begin
                                    Rec."Cheque Status" := oldStatus;
                                    Error('Cannot change Due, Cheque Not Deposited status to %1.', Rec."Cheque Status");
                                end;
                            oldStatus::Retrieved:
                                if (Rec."Cheque Status" = Rec."Cheque Status"::Cleared) OR
                                   (Rec."Cheque Status" = Rec."Cheque Status"::Deposited) OR
                                   (Rec."Cheque Status" = Rec."Cheque Status"::Returned) OR
                                   (Rec."Cheque Status" = Rec."Cheque Status"::Deferred) then begin
                                    Rec."Cheque Status" := oldStatus;
                                    Error('Cannot change Retrieved status to %1.', Rec."Cheque Status");
                                end;

                            oldStatus::Returned:
                                if (Rec."Cheque Status" = Rec."Cheque Status"::Cleared) OR
                                   (Rec."Cheque Status" = Rec."Cheque Status"::Deposited) OR
                                   (Rec."Cheque Status" = Rec."Cheque Status"::Retrieved) then begin
                                    Rec."Cheque Status" := oldStatus;
                                    Error('Cannot change Returned status to %1.', Rec."Cheque Status");
                                end;

                            oldStatus::"Replaced & Received":
                                if Rec."Cheque Status" = Rec."Cheque Status"::Cleared then begin
                                    Rec."Cheque Status" := oldStatus;
                                    Error('Cannot change Replaced & Received status to Cleared.');
                                end;

                            oldStatus::Deferred:
                                if (Rec."Cheque Status" = Rec."Cheque Status"::Cleared) OR
                                   (Rec."Cheque Status" = Rec."Cheque Status"::Retrieved) OR
                                   (Rec."Cheque Status" = Rec."Cheque Status"::Returned) OR
                                   (Rec."Cheque Status" = Rec."Cheque Status"::"Replaced & Received") then begin
                                    Rec."Cheque Status" := oldStatus;
                                    Error('Cannot change Deferred status to %1.', Rec."Cheque Status");
                                end;
                        end;

                        case
                        Rec."Cheque Status" of

                            // Check if the Cheque Status is set to 'Cleared'
                            Rec."Cheque Status"::Cleared:
                                begin
                                    // Ensure the related Payment Series record exists

                                    PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                                    PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                                    if PaymentSeriesRec.FindSet() then begin
                                        // Update the Payment Status field in the Payment Series record
                                        PaymentSeriesRec.Validate("Payment Status", PaymentSeriesRec."Payment Status"::Received);
                                        PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::Cleared;
                                        PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::Y;
                                        PaymentSeriesRec.Modify(); // Save the changes

                                        CashReceiptJournalCodeunit.CreateCashReceiptJournal(PaymentSeriesRec);
                                    end else
                                        Error('The related Payment Series record was not found.');
                                end;
                            Rec."Cheque Status"::Deposited:
                                begin
                                    PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                                    PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                                    if PaymentSeriesRec.FindSet() then begin
                                        // Update the Payment Status field in the Payment Series record

                                        PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::Deposited;
                                        PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Due;
                                        PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::Y;
                                        PaymentSeriesRec.Modify(); // Save the changes
                                    end else
                                        Error('The related Payment Series record was not found.');
                                end;
                            Rec."Cheque Status"::"Cheque Received":
                                begin
                                    PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                                    PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");

                                    if PaymentSeriesRec.FindSet() then begin
                                        // Update the Payment Status field in the Payment Series record

                                        PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::"Cheque Received";
                                        PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Scheduled;
                                        PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::"-";
                                        PaymentSeriesRec.Modify(); // Save the changes
                                    end else
                                        Error('The related Payment Series record was not found.');
                                end;
                            Rec."Cheque Status"::"Due cheque not deposited":
                                begin
                                    PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                                    PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                                    if PaymentSeriesRec.FindSet() then begin
                                        PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::"Due cheque not deposited";
                                        PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Scheduled;
                                        PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::"-";
                                        PaymentSeriesRec.Modify();
                                    end else
                                        Error('The related Payment Series record was not found.');
                                end;
                            Rec."Cheque Status"::"Replaced & Received":
                                begin
                                    PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                                    PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                                    if PaymentSeriesRec.FindSet() then begin
                                        PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::"Replaced & Received";
                                        PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Scheduled;
                                        PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::"-";
                                        // PaymentSeriesRec.Modify();
                                        PaymentSeriesRec."Old Cheque #" := PaymentSeriesRec."Cheque Number";
                                        PaymentSeriesRec."Cheque Number" := '';
                                        PaymentSeriesRec.Modify();
                                        Rec."Old Cheque#" := CopyStr(Rec."Cheque Number", 1, StrLen(Rec."Cheque Number"));
                                        Rec."Cheque Number" := '';
                                        Rec.Modify();
                                    end else
                                        Error('The related Payment Series record was not found.');
                                end;
                            Rec."Cheque Status"::Retrieved:
                                begin
                                    PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                                    PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                                    if PaymentSeriesRec.FindSet() then begin
                                        PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::Retrieved;
                                        PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Scheduled;
                                        PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::"-";
                                        // PaymentSeriesRec.Modify();
                                        PaymentSeriesRec."Old Cheque #" := PaymentSeriesRec."Cheque Number";
                                        PaymentSeriesRec."Cheque Number" := '';
                                        PaymentSeriesRec.Modify();
                                        Rec."Old Cheque#" := CopyStr(Rec."Cheque Number", 1, StrLen(Rec."Cheque Number"));
                                        Rec."Cheque Number" := '';
                                        Rec.Modify();
                                    end else
                                        Error('The related Payment Series record was not found.');
                                end;
                            Rec."Cheque Status"::Returned:
                                begin
                                    PaymentSeriesRec.SetRange("Payment Series", Rec."payment Series");
                                    PaymentSeriesRec.SetRange("Contract ID", Rec."Contract ID");
                                    if PaymentSeriesRec.FindSet() then begin
                                        PaymentSeriesRec."Cheque Status" := PaymentSeriesRec."Cheque Status"::Returned;
                                        PaymentSeriesRec."Payment Status" := PaymentSeriesRec."Payment Status"::Scheduled;
                                        PaymentSeriesRec."Deposit Status" := PaymentSeriesRec."Deposit Status"::"-";
                                        PaymentSeriesRec.Modify();


                                    end else
                                        Error('The related Payment Series record was not found.');
                                end;
                        end;
                    end;
                }

                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = true;
                    ToolTip = 'The approval status of the PDC transaction.';
                }

                field(View; Rec.View)
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    ToolTip = 'Click to view the details of the PDC transaction.';

                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin

                        FileURL := Rec."View Document URL";
                        // Check if the file URL is not empty
                        if FileURL = '' then
                            Error('No document is available to view.');

                        // Open the file URL in the browser (new tab)
                        OpenFileInBrowser(FileURL);

                    end;
                }

                group(HideFields)
                {
                    ShowCaption = false;
                    Visible = Isvisible;

                    field("Reason"; Rec."Reason")
                    {
                        ApplicationArea = All;
                        Visible = false;
                        ToolTip = 'The reason for the rejection of the cheque.';
                    }
                }
            }
        }
    }

    var
        IsLeaseManager: Boolean;
        Isvisible: Boolean;
        IsFieldEditable: Boolean;

    trigger OnAfterGetRecord()
    begin
        IsFieldEditable := (Rec."Approval Status" <> Rec."Approval Status"::Approved)
    end;

    trigger OnOpenPage()
    var
        PermissionSet: Record "User Personalization";
    begin
        // Check if the current user has the 'LEASE_MANAGER' permission set
        IsLeaseManager := false;
        PermissionSet.SetRange("User ID", UserId());
        // PermissionSet.SetRange("Profile ID", 'LEASE_MANAGER');
        if PermissionSet.FindFirst() then
            if PermissionSet."Profile ID" = 'LEASE_MANAGER' then
                IsLeaseManager := true
    end;

    procedure OpenFileInBrowser(URL: Text)
    begin
        // Use the Hyperlink method to open the file in the browser
        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;


}