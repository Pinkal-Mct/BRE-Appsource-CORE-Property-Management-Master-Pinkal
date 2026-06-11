page 73209727 "BLRRevenue Recognition Card"
{
    PageType = Card;
    SourceTable = "BLRRevenueRecognition";
    ApplicationArea = All;
    Caption = 'Revenue Recognition Rent';

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("RR ID"; Rec."BLRRR ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The unique identifier for the revenue recognition record.';
                }

                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    ShowMandatory = true;
                    NotBlank = true;
                    ToolTip = 'The unique identifier for the contract associated with this revenue recognition.';
                }

                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The unique identifier for the tenant associated with this revenue recognition.';
                }
                field("Start Date"; Rec."BLRStart Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The start date for the revenue recognition period.';
                }

                field("End Date"; Rec."BLREnd Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The end date for the revenue recognition period.';
                }

                field("Contract Amount"; Rec."BLRContract Amount")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'The total amount of the contract associated with this revenue recognition.';
                }
            }

            group("BLRRevenueRecognition")
            {
                part("RevenueRecognition"; "BLRRevenue Recognition Card2")
                {
                    SubPageLink = "BLRContract ID" = FIELD("BLRContract ID"),
                      "BLRTenant ID" = FIELD("BLRTenant ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;

                }
            }

        }
    }

}