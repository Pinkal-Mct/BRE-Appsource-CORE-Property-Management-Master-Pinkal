page 50993 "Additional Terms Subpage"
{
    PageType = ListPart;
    SourceTable = "Additional Terms";
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