page 73209678 "BLRCheque Mangement Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "BLRChequeTable";
    Editable = true;

    layout
    {
        area(content)
        {
            group("General")
            {
                field("Cheque ID"; Rec."BLRChequeID") { ToolTip = 'Unique identifier for the cheque.'; }
                field("Lease ID"; Rec."BLRLeaseID") { ToolTip = 'Identifier for the lease associated with the cheque.'; }
                field("Cheque Date"; Rec."BLRChequeDate") { ToolTip = 'Date of the cheque.'; }
                field("Cheque Amount"; Rec."BLRChequeAmount") { ToolTip = 'Amount of the cheque.'; }
                field("Cheque Status"; Rec."BLRChequeStatus")
                {
                    ToolTip = 'Status of the cheque, indicating whether it is pending, cleared, or cancelled.';

                }
            }
        }
    }
}