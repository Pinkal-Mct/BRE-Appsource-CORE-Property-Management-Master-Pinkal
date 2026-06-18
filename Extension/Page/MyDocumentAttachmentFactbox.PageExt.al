namespace PropertyManagement.PropertyManagement;

using Microsoft.Foundation.Attachment;

pageextension 73209603 BLRMyDocumentAttachmentFactbox extends "Doc. Attachment List Factbox"
{
    layout
    {
        addafter("File Extension")
        {
            field("BLRNo."; Rec."No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the unique identifier for the document attachment.';
            }

            field("BLRTable Name"; Rec."BLRTable Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the name of the table to which the document attachment is linked.';
            }

            field(BLRDocumentMedia; Rec."BLRDocumentMedia")
            {
                ApplicationArea = All;
                Caption = 'Document Preview';
                Editable = false;
                ToolTip = 'Displays the uploded document.';
            }
        }
    }
}