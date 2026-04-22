page 73209808 "Security Deposit Ledger List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Security Deposite Ledger";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Ledger ID"; Rec."Ledger ID") { ApplicationArea = All; ToolTip = 'Specifies the unique identifier for the security deposit ledger entry.'; }
                field("Contract ID"; Rec."Contract ID") { ApplicationArea = All; ToolTip = 'Specifies the unique identifier for the contract associated with this security deposit ledger entry.'; }
                field("Tenant ID"; Rec."Tenant ID") { ApplicationArea = All; ToolTip = 'Specifies the unique identifier for the tenant associated with this security deposit ledger entry.'; }
                field("Property ID"; Rec."Property ID") { ApplicationArea = All; ToolTip = 'Specifies the unique identifier for the property associated with this security deposit ledger entry.'; }
                field("Transaction Date"; Rec."Transaction Date") { ApplicationArea = All; ToolTip = 'Specifies the date of the transaction for this security deposit ledger entry.'; }
                field("Transaction Type"; Rec."Transaction Type") { ApplicationArea = All; ToolTip = 'Specifies the type of transaction for this security deposit ledger entry, such as deposit, refund, or adjustment.'; }
                field("Initial Deposit Amount"; Rec."Initial Deposit Amount") { ApplicationArea = All; ToolTip = 'Specifies the initial deposit amount for this security deposit ledger entry.'; }
                field("Unpaid Rent Deduction"; Rec."Unpaid Rent Deduction") { ApplicationArea = All; ToolTip = 'Specifies the amount deducted for unpaid rent from the security deposit.'; }
                field("Damage Charges Deduction"; Rec."Damage Charges Deduction") { ApplicationArea = All; ToolTip = 'Specifies the amount deducted for damage charges from the security deposit.'; }
                field("Penalty Deduction"; Rec."Penalty Deduction") { ApplicationArea = All; ToolTip = 'Specifies the amount deducted for penalties from the security deposit.'; }
                field("Service Charges Deduction"; Rec."Service Charges Deduction") { ApplicationArea = All; ToolTip = 'Specifies the amount deducted for service charges from the security deposit.'; }
                field("Other Deductions"; Rec."Other Deductions") { ApplicationArea = All; ToolTip = 'Specifies any other deductions applied to the security deposit ledger entry.'; }
                field("Total Deductions"; Rec."Total Deductions") { ApplicationArea = All; Editable = false; ToolTip = 'Specifies the total deductions applied to the security deposit ledger entry.'; }
                field("Refundable Amount"; Rec."Refundable Amount") { ApplicationArea = All; Editable = false; ToolTip = 'Specifies the amount that is refundable to the tenant after deductions.'; }
                field("Approval Status"; Rec."Approval Status") { ApplicationArea = All; ToolTip = 'Specifies the current approval status of the security deposit ledger entry.'; }
                field("Processed By"; Rec."Processed By") { ApplicationArea = All; ToolTip = 'Specifies the user who processed this security deposit ledger entry.'; }
                field("Final Settlement Date"; Rec."Final Settlement Date") { ApplicationArea = All; ToolTip = 'Specifies the date when the final settlement of the security deposit was processed.'; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
#pragma warning disable AW0005
            action(ApproveRefund)
#pragma warning restore AW0005
            {
                Caption = 'Approve Refund';
                ApplicationArea = All;
                ToolTip = 'Approve the refund for the selected security deposit ledger entry.';
                trigger OnAction()
                var
                    LedgerEntry: Record "Security Deposite Ledger";
                begin
                    LedgerEntry.Get(Rec."Ledger ID");
                    if LedgerEntry."Approval Status" <> LedgerEntry."Approval Status"::Pending then
                        Error('Only pending refunds can be approved.');

                    LedgerEntry."Approval Status" := LedgerEntry."Approval Status"::Approved;
                    LedgerEntry."Final Settlement Date" := CurrentDateTime;
                    LedgerEntry."Processed By" := CopyStr(UserId.ToUpper(), 1, StrLen(UserId.ToUpper()));
                    LedgerEntry.Modify();
                end;
            }
        }
    }


}