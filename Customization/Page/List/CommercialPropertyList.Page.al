page 73209768 "BLRCommercial Property List"
{
    PageType = List;
    SourceTable = "BLRPropertyRegistration";
    ApplicationArea = All;
    Caption = 'Commercial Property List';
    UsageCategory = Administration;
    SourceTableView = where("BLRProperty Classification" = const('Commercial'));
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Property ID"; Rec."BLRProperty ID")
                {
                    ApplicationArea = All;
                    Caption = 'Property ID';
                    ToolTip = 'Specifies the unique identifier for the property.';
                }
                field("Property Name"; Rec."BLRProperty Name")
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    ToolTip = 'Specifies the name of the property.';
                }
                field("BLRPropertyType"; Rec."BLRProperty Classification")
                {
                    ApplicationArea = All;
                    Caption = 'Property Type';
                    ToolTip = 'Specifies the classification of the property (e.g., Commercial).';
                }
            }
        }
    }
    trigger OnOpenPage();
    begin
        Rec.SetRange("BLRProperty Classification", 'Commercial');
    end;
}
