page 73209678 "Cheque Mangement Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Cheque Table";
    Editable = true;

    layout
    {
        area(content)
        {
            group("General")
            {
                field("Cheque ID"; Rec."ChequeID") { ToolTip = 'Unique identifier for the cheque.'; }
                field("Lease ID"; Rec."LeaseID") { ToolTip = 'Identifier for the lease associated with the cheque.'; }
                field("Cheque Date"; Rec."ChequeDate") { ToolTip = 'Date of the cheque.'; }
                field("Cheque Amount"; Rec."ChequeAmount") { ToolTip = 'Amount of the cheque.'; }
                field("Cheque Status"; Rec."ChequeStatus")
                {
                    ToolTip = 'Status of the cheque, indicating whether it is pending, cleared, or cancelled.';

                }
            }
        }
    }
}