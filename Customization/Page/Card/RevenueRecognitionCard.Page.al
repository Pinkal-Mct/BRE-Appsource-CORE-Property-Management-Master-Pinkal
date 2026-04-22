page 73209727 "Revenue Recognition Card"
{
    PageType = Card;
    SourceTable = "Revenue Recognition";
    ApplicationArea = All;
    Caption = 'Revenue Recognition Rent';

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("RR ID"; Rec."RR ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The unique identifier for the revenue recognition record.';
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    ShowMandatory = true;
                    NotBlank = true;
                    ToolTip = 'The unique identifier for the contract associated with this revenue recognition.';
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The unique identifier for the tenant associated with this revenue recognition.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The start date for the revenue recognition period.';
                }

                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The end date for the revenue recognition period.';
                }

                field("Contract Amount"; Rec."Contract Amount")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The total amount of the contract associated with this revenue recognition.';
                }
            }

            group("Revenue Recognition")
            {
                part("RevenueRecognition"; "Revenue Recognition Card2")
                {
                    SubPageLink = "Contract ID" = FIELD("Contract ID"),
                      "Tenant ID" = FIELD("Tenant ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;

                }
            }

        }
    }

}