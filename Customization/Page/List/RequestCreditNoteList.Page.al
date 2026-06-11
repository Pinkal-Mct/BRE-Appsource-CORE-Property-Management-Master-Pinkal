page 73209801 "BLRRequest Credit Note List"
{
    PageType = List;
    SourceTable = "BLRRequestCreditNote";
    ApplicationArea = All;
    Caption = 'Request Credit Note List';
    UsageCategory = Lists;
    CardPageId = "BLRRequest Credit Note Card";
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Request No."; Rec."BLRRequest No.")
                {
                    ApplicationArea = All;
                    Caption = 'Request No.';
                    ToolTip = 'Specifies the unique number of the credit note request.';
                }
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Caption = 'Contract ID';
                    ToolTip = 'Specifies the contract associated with this credit note request.';
                }
                field("Tenant No."; Rec."BLRTenant No.")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant No.';
                    ToolTip = 'Specifies the tenant related to this credit note request.';
                }
                field("Request Date"; Rec."BLRRequest Date")
                {
                    ApplicationArea = All;
                    Caption = 'Request Date';
                    ToolTip = 'Specifies the date when the credit note was requested.';
                }
                field(Status; Rec."BLRStatus")
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    ToolTip = 'Shows the current status of the credit note request.';
                }
                field("Adjust with Invoice"; Rec."BLRAdjust with Invoice")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether the credit note should be adjusted with an invoice.';
                    Caption = 'Adjust with Invoice';
                }

            }
        }
    }

}