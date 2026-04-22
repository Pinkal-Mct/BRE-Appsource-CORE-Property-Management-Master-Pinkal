page 73209797 "Property Registration List"
{
    PageType = List;
    SourceTable = "Property Registration";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = 73209717;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Property ID"; rec."Property ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the property registration.';
                }
                field("Property Name"; rec."Property Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the property associated with the registration.';
                }

                field("Description"; rec."Description")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Description of the property registration.';
                }

                field("Type"; rec."Type")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Type of the property registration.';
                }

                field("Base Unit of Measure"; rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Base unit of measure for the property registration.';
                }

                field("Market Rate per Sq. Ft."; rec."Market Rate per Sq. Ft.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Market rate per square foot for the property registration.';
                }

                field("Community"; rec.Community)
                {
                    ApplicationArea = All;
                    ToolTip = 'Community associated with the property registration.';
                }

                field("Owner ID"; rec."Owner ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the owner of the property registration.';
                }
                field("Registration Date"; rec."Registration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date when the property registration was created.';
                }
            }
        }
    }


}
