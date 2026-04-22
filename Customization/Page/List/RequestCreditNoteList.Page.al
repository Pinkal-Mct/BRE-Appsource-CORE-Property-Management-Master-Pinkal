page 73209801 "Request Credit Note List"
{
    PageType = List;
    SourceTable = "Request Credit Note";
    ApplicationArea = All;
    Caption = 'Request Credit Note List';
    UsageCategory = Lists;
    CardPageId = "Request Credit Note Card";
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Request No."; Rec."Request No.")
                {
                    ApplicationArea = All;
                    Caption = 'Request No.';
                    ToolTip = 'Specifies the unique number of the credit note request.';
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Caption = 'Contract ID';
                    ToolTip = 'Specifies the contract associated with this credit note request.';
                }
                field("Tenant No."; Rec."Tenant No.")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant No.';
                    ToolTip = 'Specifies the tenant related to this credit note request.';
                }
                field("Request Date"; Rec."Request Date")
                {
                    ApplicationArea = All;
                    Caption = 'Request Date';
                    ToolTip = 'Specifies the date when the credit note was requested.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                    ToolTip = 'Shows the current status of the credit note request.';
                }
                field("Adjust with Invoice"; Rec."Adjust with Invoice")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether the credit note should be adjusted with an invoice.';
                    Caption = 'Adjust with Invoice';
                }

            }
        }
    }

}