page 73209817 "BLRTC Additional Terms Subpage"
{
    PageType = ListPart;
    SourceTable = "BLRTCAdditionalTerms";
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