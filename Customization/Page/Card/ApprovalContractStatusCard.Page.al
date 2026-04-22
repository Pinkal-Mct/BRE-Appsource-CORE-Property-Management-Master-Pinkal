page 73209673 "Approval Contract Status Card"
{
    PageType = Card;
    SourceTable = "Approval Contract Status";
    ApplicationArea = All;
    Caption = 'Approval Contract Status Card';

    layout
    {
        area(content)
        {
            group(General)
            {
                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the approval contract status.';
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Current status of the approval contract.';
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Identifier for the contract associated with this approval status.';
                }
                field("Lease ID"; Rec."Lease ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Identifier for the lease associated with this approval status.';
                }

                field("Tenancy Contract Status"; Rec."Tenancy Contract Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Status of the tenancy contract related to this approval.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            // You can add actions here if needed
        }
    }
}
