page 73209815 "Vendor Profile List"
{
    PageType = List;
    SourceTable = "Vendor Profile";
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
                field("Vendor ID"; Rec."Vendor ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the unique identifier for the vendor profile.';

                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the vendor associated with this profile.';
                }
                field("Vendor Contact No."; Rec."Vendor Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contact number for the vendor associated with this profile.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the start date of the vendor profile, indicating when the vendor was added to the system.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the end date of the vendor profile, indicating when the vendor was removed or is no longer active.';
                }
                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the current status of the vendor profile, such as Active, Inactive, or Pending.';
                }
            }
        }
    }

}
