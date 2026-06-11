pageextension 73209578 BLRCustomerPaymentReceipt extends "Cash Receipt Journal"
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
                PaymentReceiptEntry: Record "BLRCustomerPaymentReceipt";
                GenJournalLine: Record "Gen. Journal Line";
            begin
                CurrPage.SetSelectionFilter(GenJournalLine);
                if GenJournalLine.FindSet() then
                    repeat
                        // Check if an entry with the same document number already exists
                        PaymentReceiptEntry.SetRange("BLRDocument No.", GenJournalLine."Document No.");
                        if PaymentReceiptEntry.FindFirst() then begin
                            // Modify existing entry
                            PaymentReceiptEntry."BLRPosing Date" := GenJournalLine."Posting Date";
                            PaymentReceiptEntry."BLRAccount Type" := GenJournalLine."Account Type";
                            PaymentReceiptEntry."BLRAccount No." := GenJournalLine."Account No.";
                            PaymentReceiptEntry."BLRDescription" := GenJournalLine.Description;
                            PaymentReceiptEntry."BLRAmount" := Abs(GenJournalLine.Amount);
                            PaymentReceiptEntry.Modify(true);
                        end else begin
                            // Create new entry
                            PaymentReceiptEntry.Init();
                            PaymentReceiptEntry."BLRDocument No." := GenJournalLine."Document No.";
                            PaymentReceiptEntry."BLRPosing Date" := GenJournalLine."Posting Date";
                            PaymentReceiptEntry."BLRAccount Type" := GenJournalLine."Account Type";
                            PaymentReceiptEntry."BLRAccount No." := GenJournalLine."Account No.";
                            PaymentReceiptEntry."BLRDescription" := GenJournalLine.Description;
                            PaymentReceiptEntry."BLRAmount" := Abs(GenJournalLine.Amount);
                            PaymentReceiptEntry.Insert(true);
                        end;
                    until GenJournalLine.Next() = 0;

                Message('All selected entries processed successfully!');
            end;
        }
    }
}