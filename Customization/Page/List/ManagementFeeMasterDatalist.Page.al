page 73209783 "Management Fee MasterData List"
{
    PageType = List;
    SourceTable = "Management Fee MasterData";
    ApplicationArea = All;
    Caption = 'Management Fee Master Data';
    UsageCategory = Lists;
    CardPageId = 73209671;
    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Management Fee Number"; Rec."Management Fee Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the management fee. This field is auto-generated and cannot be edited.';
                }
                field("Vendor ID"; Rec."Vendor ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    ToolTip = 'Specifies the unique identifier for the vendor. Click to view the vendor profile.';

                    trigger OnDrillDown()
                    var
                        VendorProfile: Record "Vendor";
                    begin
                        VendorProfile.SetRange("No.", Rec."Vendor ID");
                        if VendorProfile.FindSet() then
                            PAGE.RunModal(PAGE::"Vendor Profile Card", VendorProfile)
                        else
                            Message('No Vendor Profile found using FindFirst either.');
                    end;

                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the full name of the vendor.';
                }

            }
        }
    }

}
