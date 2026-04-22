page 73209689 DialogBoxForInvoiceRejection
{
    PageType = StandardDialog;
    Caption = 'Enter Reason Rejection';
    layout
    {
        area(content)
        {
            field(ReasonForRejection; reasonvalue)
            {
                Caption = 'Reason for Rejection';
                ApplicationArea = All;
                ToolTip = 'Enter the reason for rejection.';
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    begin
        // Allow the dialog to close if the user clicks Cancel
        if CloseAction = Action::Cancel then
            exit(true);

        // Remove leading and trailing spaces


        // Validate only when OK is clicked
        if CloseAction = Action::OK then
            if reasonvalue = '' then begin
                Message('Please enter a reason for rejection before proceeding.');
                exit(false); // Prevents closing the dialog
            end;

        exit(true); // Allows closing if validation passes or Cancel is clicked
    end;

    procedure GetReason(): Text[1000];
    begin
        exit(reasonvalue);
    end;

    var
        reasonvalue: Text[1000];
}