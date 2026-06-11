page 73209797 "BLRProperty Registration List"
{
    PageType = List;
    SourceTable = "BLRPropertyRegistration";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = 73209717;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Property ID"; rec."BLRProperty ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the property registration.';
                }
                field("Property Name"; rec."BLRProperty Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the property associated with the registration.';
                }

                field("Description"; rec."BLRDescription")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Description of the property registration.';
                }

                field("Type"; rec."BLRType")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Type of the property registration.';
                }

                field("Base Unit of Measure"; rec."BLRBase Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Base unit of measure for the property registration.';
                }

                field("Market Rate per Sq. Ft."; rec."BLRMarket Rate per Sq. Ft.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Market rate per square foot for the property registration.';
                }

                field("BLRCommunity"; rec."BLRCommunity")
                {
                    ApplicationArea = All;
                    ToolTip = 'Community associated with the property registration.';
                }

                field("Owner ID"; rec."BLROwner ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the owner of the property registration.';
                }
                field("Registration Date"; rec."BLRRegistration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date when the property registration was created.';
                }
            }
        }
    }


}
