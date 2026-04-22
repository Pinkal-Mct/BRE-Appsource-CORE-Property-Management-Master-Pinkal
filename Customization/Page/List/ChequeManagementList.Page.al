page 73209767 "Cheque Management List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Cheque Table";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cheque ID"; Rec."ChequeID") { ToolTip = 'Unique identifier for the cheque.'; }
                field("Lease ID"; Rec."LeaseID") { ToolTip = 'Identifier for the lease associated with the cheque.'; }
                field("Cheque Date"; Rec."ChequeDate") { ToolTip = 'Date when the cheque was issued.'; }
                field("Cheque Amount"; Rec."ChequeAmount") { ToolTip = 'Amount of the cheque.'; }
                field("Cheque Status"; Rec."ChequeStatus")
                {
                    ToolTip = 'Current status of the cheque, such as Pending, Cleared, or Rejected.';

                }
            }
        }
    }


}