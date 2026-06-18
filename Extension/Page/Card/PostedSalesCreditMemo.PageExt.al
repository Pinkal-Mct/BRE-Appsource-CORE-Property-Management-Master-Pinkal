pageextension 73209581 BLRPostedSalesCreditMemo extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter(General)
        {
            group("BLRContract Information")
            {
                field("BLRContract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'ID of the contract related to this credit memo.';
                }
                field("BLRProperty Name"; Rec."BLRProperty Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the property related to this credit memo.';
                }
                field("BLRUnit Name"; Rec."BLRUnit Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the unit related to this credit memo.';
                }
                field("BLRContract Amount"; Rec."BLRContract Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Amount of the contract related to this credit memo.';
                    Editable = false;
                }
                field("BLRContract Tenure"; Rec."BLRContract Tenure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Tenure of the contract related to this credit memo.';
                }
                field("BLRContract Period"; Rec."BLRContract Period")
                {
                    ApplicationArea = All;
                    ToolTip = 'Period of the contract related to this credit memo.';
                }
                field("BLRProperty Classification"; Rec."BLRProperty Classification")
                {
                    ApplicationArea = All;
                    ToolTip = 'Classification of the property related to this credit memo.';
                }
                field("BLRApproval Status for CreditNote"; Rec."BLRApprovalStatusforCreditNote")
                {
                    ApplicationArea = All;
                    ToolTip = 'Approval status for the credit note.';
                }
                field("BLRRejection Reason CreditNote"; Rec."BLRRejection Reason CreditNote")
                {
                    ApplicationArea = All;
                    ToolTip = 'Reason for rejection of the credit note.';
                }
                field("BLRTerminated Credit Note"; Rec."BLRTerminated Credit Note")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates if the credit note is terminated.';
                    Editable = false;
                    Visible = false;
                }


            }
        }
        addlast(General)
        {
            field("BLRCredit Memo URL"; Rec."BLRCredit Memo URL")
            {
                ApplicationArea = All;
                Caption = 'View Document URL';
                ToolTip = 'Specifies the URL to view the document associated with this posted sales credit memo.';
            }
            field("BLRCredit Memo Document"; Rec."BLRCredit Memo Document")
            {
                ToolTip = 'Specifies the document associated with this posted sales credit memo.';
                ApplicationArea = All;
                Caption = 'View Invoice';
                Editable = false;
                DrillDown = true;
                trigger OnDrillDown()
                var
                    FileURL: Text;
                begin

                    FileURL := Rec."BLRCredit Memo URL";


                    if FileURL = '' then
                        Error('No document is available to view.');


                    BLROpenFileInBrowser(FileURL);
                end;

            }
        }

    }
    procedure BLROpenFileInBrowser(URL: Text)
    begin

        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;
}