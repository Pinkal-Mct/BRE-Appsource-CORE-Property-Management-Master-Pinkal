page 73209767 "BLRCheque Management List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Cheque Management List';
    SourceTable = "BLRChequeTable";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cheque ID"; Rec."BLRChequeID") { ToolTip = 'Unique identifier for the cheque.'; }
                field("Lease ID"; Rec."BLRLeaseID") { ToolTip = 'Identifier for the lease associated with the cheque.'; }
                field("Cheque Date"; Rec."BLRChequeDate") { ToolTip = 'Date when the cheque was issued.'; }
                field("Cheque Amount"; Rec."BLRChequeAmount") { ToolTip = 'Amount of the cheque.'; }
                field("Cheque Status"; Rec."BLRChequeStatus")
                {
                    ToolTip = 'Current status of the cheque, such as Pending, Cleared, or Rejected.';

                }
            }
        }
    }


}