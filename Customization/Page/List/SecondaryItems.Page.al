page 51000 "Secondary Items"
{
    PageType = List;
    SourceTable = Item;
    SourceTableView = where("Item type template" = const("Item Type Template Enum"::"Secondary Item"));
    ApplicationArea = All;
    Caption = 'Secondary Items';
    UsageCategory = Lists;
    CardPageId = "Item Card";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Item type template"; Rec."Item type template")
                {
                    ApplicationArea = All;
                }
                field("Primary Item Type"; Rec."Primary Item Type")
                {
                    ApplicationArea = All;
                }
                field("Charges Status"; Rec."Charges Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
