namespace PropertyManagement.PropertyManagement;

using Microsoft.Foundation.Attachment;

pageextension 73209603 MyDocumentAttachmentFactbox extends "Doc. Attachment List Factbox"
{
    layout
    {
        addafter("File Extension")
        {
            field("No."; Rec."No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the unique identifier for the document attachment.';
            }

            field("Table Name"; Rec."Table Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the name of the table to which the document attachment is linked.';
            }

            field(DocumentMedia; Rec.DocumentMedia)
            {
                ApplicationArea = All;
                Caption = 'Document Preview';
                Editable = false;
                ToolTip = 'Displays the uploded document.';
            }
        }
    }
}