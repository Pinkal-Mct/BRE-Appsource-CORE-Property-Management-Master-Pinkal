pageextension 73209578 CustomerPaymentReceipt extends "Cash Receipt Journal"
{
    actions
    {
        modify(Post)
        {
            ApplicationArea = All;
            Caption = 'Post Entry';
            Promoted = true;
            PromotedCategory = Process;
            PromotedIsBig = true;

            trigger OnBeforeAction()
            var
                PaymentReceiptEntry: Record "Customer Payment Receipt";
                GenJournalLine: Record "Gen. Journal Line";
            begin
                CurrPage.SetSelectionFilter(GenJournalLine);
                if GenJournalLine.FindSet() then
                    repeat
                        // Check if an entry with the same document number already exists
                        PaymentReceiptEntry.SetRange("Document No.", GenJournalLine."Document No.");
                        if PaymentReceiptEntry.FindFirst() then begin
                            // Modify existing entry
                            PaymentReceiptEntry."Posing Date" := GenJournalLine."Posting Date";
                            PaymentReceiptEntry."Account Type" := GenJournalLine."Account Type";
                            PaymentReceiptEntry."Account No." := GenJournalLine."Account No.";
                            PaymentReceiptEntry.Description := GenJournalLine.Description;
                            PaymentReceiptEntry.Amount := Abs(GenJournalLine.Amount);
                            PaymentReceiptEntry.Modify(true);
                        end else begin
                            // Create new entry
                            PaymentReceiptEntry.Init();
                            PaymentReceiptEntry."Document No." := GenJournalLine."Document No.";
                            PaymentReceiptEntry."Posing Date" := GenJournalLine."Posting Date";
                            PaymentReceiptEntry."Account Type" := GenJournalLine."Account Type";
                            PaymentReceiptEntry."Account No." := GenJournalLine."Account No.";
                            PaymentReceiptEntry.Description := GenJournalLine.Description;
                            PaymentReceiptEntry.Amount := Abs(GenJournalLine.Amount);
                            PaymentReceiptEntry.Insert(true);
                        end;
                    until GenJournalLine.Next() = 0;

                Message('All selected entries processed successfully!');
            end;
        }
    }
}