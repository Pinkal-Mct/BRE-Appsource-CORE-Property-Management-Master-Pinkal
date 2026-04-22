page 73209711 "Payment Series Grid"
{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Payment Series Details";
    Caption = 'Payment Series Grid';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("payment Series"; Rec."payment Series")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the payment series.';
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    ToolTip = 'Total amount for the payment series.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Due date for the payment series.';
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                    ApplicationArea = All;
                    ToolTip = 'Mode of payment for the series, such as Cheque, Cash, or Bank Transfer.';
                }
                field("Cheque Number"; Rec."Cheque Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Cheque number associated with the payment series.';
                }
                field("Deposite Bank"; Rec."Deposite Bank")
                {
                    ApplicationArea = All;
                    ToolTip = 'Bank where the payment series is deposited.';
                }
                field("Deposite Status"; Rec."Deposite Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Status of the deposit for the payment series, indicating whether it is pending, completed, or cancelled.';
                }
                field("Payment Status"; Rec."Payment Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Status of the payment series, indicating whether it is pending, completed, or cancelled.';
                }
                field("Cheque Status"; Rec."Cheque Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Status of the cheque associated with the payment series, indicating whether it is pending, cleared, or cancelled.';
                }
                field("Old Cheque"; Rec."Old Cheque")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates if the cheque is an old cheque, used for tracking purposes.';
                }
                field(View; Rec.View)
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    ToolTip = 'View the details of the payment series.';
                    trigger OnValidate()
                    begin
                        if Rec."Payment Mode" <> 'Cheque' then
                            Error('Cheque number can only be entered when Payment Mode is set to Cheque.');
                    end;

                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin
                        // Get the URL of the uploaded document
                        FileURL := Rec."View Document URL";

                        // Check if the file URL is not empty
                        if FileURL = '' then
                            Error('No document is available to view.');

                        // Open the file URL in the browser (new tab)
                        OpenFileInBrowser(FileURL);
                    end;
                }

                field("View Document URL"; Rec."View Document URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'URL of the document associated with the payment series.';
                }

                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Status of the approval for the payment series, indicating whether it is pending, approved, or rejected.';
                }
            }
        }
    }


    procedure OpenFileInBrowser(URL: Text)
    begin
        // Use the Hyperlink method to open the file in the browser
        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;

}