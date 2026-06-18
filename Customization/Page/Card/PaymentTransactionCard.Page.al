page 73209712 "BLRPayment Transaction Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;
    Caption = 'Payment Transaction Card';
    SourceTable = "BLRPaymentTransaction";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("PT Id"; Rec."BLRPT Id")
                {
                    ApplicationArea = all;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the payment transaction.';
                }
                field(SystemId; Rec.SystemId)
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the system identifier for the payment transaction.';
                }
                field("Tenant Id"; Rec."BLRTenant Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier for the tenant associated with this payment transaction.';
                }
                field("Tenant Name"; Rec."BLRTenant Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the tenant associated with this payment transaction.';
                }
                field("Contract Id"; Rec."BLRContract Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier for the contract associated with this payment transaction.';
                }
                field("Approval Status"; Rec."BLRApproval Status")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                    ToolTip = 'Specifies the approval status of the payment transaction. Only Finance Managers can edit this field.';
                }
            }
            group("Payment Series Grid")
            {
                part("Payment series"; "BLRPayment Series Grid")
                {
                    SubPageLink = "BLRContract ID" = FIELD("BLRContract Id"),
                    "BLRPayment Transaction Id" = FIELD("BLRPT Id");
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        IsFinanceManager: Boolean;

    trigger OnOpenPage()
    var
        PermissionSet: Record "User Personalization";
    begin
        // Check if the current user has the 'LEASE MANAGER' permission set
        IsFinanceManager := false;
        PermissionSet.SetRange("User ID", UserId());
        // PermissionSet.SetRange("Profile ID", 'LEASE MANAGER');
        if PermissionSet.FindFirst() then
            if PermissionSet."Profile ID" = 'FINANCE MANAGER' then
                IsFinanceManager := true;

    end;
}