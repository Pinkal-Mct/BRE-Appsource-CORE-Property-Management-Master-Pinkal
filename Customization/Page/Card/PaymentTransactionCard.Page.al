page 73209712 "Payment Transaction Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Payment Transaction";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("PT Id"; Rec."PT Id")
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
                field("Tenant Id"; Rec."Tenant Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier for the tenant associated with this payment transaction.';
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the tenant associated with this payment transaction.';
                }
                field("Contract Id"; Rec."Contract Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier for the contract associated with this payment transaction.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    Editable = IsFinanceManager;
                    ToolTip = 'Specifies the approval status of the payment transaction. Only Finance Managers can edit this field.';
                }
            }
            group("Payment Series Grid")
            {
                part("Payment series"; "Payment Series Grid")
                {
                    SubPageLink = "Contract Id" = FIELD("Contract Id"),
                    "Payment Transaction Id" = FIELD("PT Id");
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