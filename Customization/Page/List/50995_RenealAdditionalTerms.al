page 73209818 "BLRRenewalAdditionalTerms"
{
    PageType = ListPart;
    SourceTable = "BLRRenewalAdditionalTerms";
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