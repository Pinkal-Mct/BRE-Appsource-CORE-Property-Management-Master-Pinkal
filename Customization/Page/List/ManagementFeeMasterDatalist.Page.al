page 73209783 "BLRManagementFeeMasterDataList"
{
    PageType = List;
    SourceTable = "BLRManagementFeeMasterData";
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
                field("Management Fee Number"; Rec."BLRManagement Fee Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the management fee. This field is auto-generated and cannot be edited.';
                }
                field("Vendor ID"; Rec."BLRVendor ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    ToolTip = 'Specifies the unique identifier for the vendor. Click to view the vendor profile.';

                    trigger OnDrillDown()
                    var
                        VendorProfile: Record "Vendor";
                    begin
                        VendorProfile.SetRange("No.", Rec."BLRVendor ID");
                        if VendorProfile.FindSet() then
                            PAGE.RunModal(PAGE::"BLRVendor Profile Card", VendorProfile)
                        else
                            Message('No Vendor Profile found using FindFirst either.');
                    end;

                }
                field("Vendor Name"; Rec."BLRVendor Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the full name of the vendor.';
                }

            }
        }
    }

}
