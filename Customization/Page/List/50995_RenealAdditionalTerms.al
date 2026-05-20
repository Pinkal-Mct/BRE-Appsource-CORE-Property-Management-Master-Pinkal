page 50995 "Renewal AdditionalTermsSubpage"
{
    PageType = ListPart;
    SourceTable = "Renewal Additional Terms";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}