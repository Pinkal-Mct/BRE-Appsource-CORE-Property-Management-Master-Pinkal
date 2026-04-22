pageextension 73209586 "Sales Header" extends "Sales Credit Memo"
{
    actions
    {
        addafter(Action7)
        {
            action("Create Credit Note")
            {
                ToolTip = 'Create a credit note for the selected sales header.';
                Caption = 'Create Credit Note';
                ApplicationArea = All;
                Image = NewDocument; // Use an appropriate icon for the action
                Promoted = true; // Make the action visible in the header
                PromotedCategory = Process; // Place it in the "Process" category
                PromotedIsBig = true; // Make it a prominent action

                trigger OnAction()
                var
                    SalesHeader: Record "Sales Header";
                    CreditNote: Report "Credit Note";
                begin
                    // Filter the Sales Header record based on the current record
                    SalesHeader.SetRange("No.", Rec."No.");

                    // Set the filtered Sales Header as the data source for the Credit Note report
                    CreditNote.SetTableView(SalesHeader);

                    // Run the Credit Note report
                    CreditNote.RunModal();
                end;
            }
        }
    }
}