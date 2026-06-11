page 73209815 "BLRVendor Profile List"
{
    PageType = List;
    SourceTable = "BLRVendorProfile";
    ApplicationArea = All;
    Caption = 'Vendor Profiles';
    UsageCategory = Lists;
    CardPageId = 73209749;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Vendor ID"; Rec."BLRVendor ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier for the vendor profile.';

                }
                field("Vendor Name"; Rec."BLRVendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the vendor associated with this profile.';
                }
                field("Vendor Contact No."; Rec."BLRVendor Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contact number for the vendor associated with this profile.';
                }
                field("Start Date"; Rec."BLRStart Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the start date of the vendor profile, indicating when the vendor was added to the system.';
                }
                field("End Date"; Rec."BLREnd Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the end date of the vendor profile, indicating when the vendor was removed or is no longer active.';
                }
                field("Contract Status"; Rec."BLRContract Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status of the vendor profile, such as Active, Inactive, or Pending.';
                }
            }
        }
    }

}
