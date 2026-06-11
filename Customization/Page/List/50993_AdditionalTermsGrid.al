page 73209816 "BLRAdditional Terms Subpage"
{
    PageType = ListPart;
    SourceTable = "BLRAdditionalTerms";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {

                field(Description; Rec.BLRDescription)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}