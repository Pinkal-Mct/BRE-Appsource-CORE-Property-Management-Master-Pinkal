pageextension 73209589 Vendor extends "Vendor Card"
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
            field("Vendor Category"; Rec."Vendor Category")
            {
                ApplicationArea = All;
                Caption = 'Vendor Category';
                TableRelation = "Vendor Category"."Vendor Category Type";
                ToolTip = 'Specifies the vendor category for this vendor.';
            }
        }

        addafter("Address 2")
        {
            field("Country"; Rec."Country")
            {
                ApplicationArea = All;
                Caption = 'Country';
                TableRelation = Country."Country Code";
                ToolTip = 'Specifies the country in which the vendor is located.';
            }
        }
        addafter("Country")
        {
            field("Emirate"; Rec."Emirate Name")
            {
                ApplicationArea = All;
                Caption = 'Emirate';
                TableRelation = Emirate."Emirate Name" where("Country Code" = field(Country));
                ToolTip = 'Specifies the emirate in which the vendor is located.';
            }
        }

        addafter("Emirate")
        {
            field("Community"; Rec."Community")
            {
                ApplicationArea = All;
                Caption = 'Community';
                TableRelation = Community."Community Name" where("Emirate Name" = field("Emirate Name"));
                ToolTip = 'Specifies the community in which the vendor is located.';
            }
        }
    }
}