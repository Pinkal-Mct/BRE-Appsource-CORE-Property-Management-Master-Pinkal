page 50994 "TC Additional Terms Subpage"
{
    PageType = ListPart;
    SourceTable = "TC Additional Terms";
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