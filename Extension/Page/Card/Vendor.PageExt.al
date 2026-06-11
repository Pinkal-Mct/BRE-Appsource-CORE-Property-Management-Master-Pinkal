pageextension 73209589 BLRVendor extends "Vendor Card"
{
    layout
    {

        modify("Country/Region Code")
        {
            Visible = false;
        }
        modify(City)
        {
            Visible = false;
        }
        modify("Post Code")
        {
            Visible = false;
        }
        modify(ShowMap)
        {
            Visible = false;
        }
        modify("Customized Calendar")
        {
            Visible = false;
        }

        addafter("Blocked")
        {
            field("BLRVendorCategory"; Rec."BLRVendor Category")
            {
                ApplicationArea = All;
                Caption = 'Vendor Category';
                TableRelation = "BLRVendorCategory"."BLRVendor Category Type";
                ToolTip = 'Specifies the vendor category for this vendor.';
            }
        }

        addafter("Address 2")
        {
            field("BLRCountry"; Rec."BLRCountry")
            {
                ApplicationArea = All;
                Caption = 'Country';
                TableRelation = "BLRCountry"."BLRCountry Code";
                ToolTip = 'Specifies the country in which the vendor is located.';
            }
        }
        addafter("BLRCountry")
        {
            field("BLREmirate"; Rec."BLREmirate Name")
            {
                ApplicationArea = All;
                Caption = 'Emirate';
                TableRelation = BLREmirate."BLREmirate Name" where("BLRCountry Code" = field("BLRCountry"));
                ToolTip = 'Specifies the emirate in which the vendor is located.';
            }
        }

        addafter("BLREmirate")
        {
            field("BLRCommunity"; Rec."BLRCommunity")
            {
                ApplicationArea = All;
                Caption = 'Community';
                TableRelation = BLRCommunity."BLRCommunity Name" where("BLREmirate Name" = field("BLREmirate Name"));
                ToolTip = 'Specifies the community in which the vendor is located.';
            }
        }
    }
}