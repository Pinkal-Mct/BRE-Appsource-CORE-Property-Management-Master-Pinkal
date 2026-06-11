page 73209806 "BLRSecondary Items"
{
    PageType = List;
    SourceTable = Item;
    SourceTableView = where("BLRItem type template" = const("BLRItem Type Template Enum"::"Secondary Item"));
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
                field("Item type template"; Rec."BLRItem type template")
                {
                    ApplicationArea = All;
                }
                field("Primary Item Type"; Rec."BLRPrimary Item Type")
                {
                    ApplicationArea = All;
                }
                field("Charges Status"; Rec."BLRCharges Status")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
