page 73209765 "Brokerage Master Data List"
{
    PageType = List;
    SourceTable = "Brokerage Master Data";
    ApplicationArea = All;
    Caption = 'Brokerage Master Data';
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Vendor ID"; Rec."Vendor ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    ToolTip = 'Specifies the unique identifier for the vendor associated with the brokerage master data.';

                    trigger OnDrillDown()
                    var
                        VendorProfile: Record "Vendor Profile";
                    begin
                        VendorProfile.SetRange("Vendor ID", Rec."Vendor ID");
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
                    ToolTip = 'Specifies the name of the vendor associated with the brokerage master data.';
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    ToolTip = 'Specifies the unique identifier for the contract associated with the brokerage master data.';

                    trigger OnDrillDown()
                    var
                        tenancycontract: Record "Tenancy Contract";
                    begin
                        tenancycontract.SetRange("Contract ID", Rec."Contract ID");
                        if tenancycontract.FindSet() then
                            PAGE.RunModal(PAGE::"Tenancy Contract Card", tenancycontract)
                        else
                            Message('No Property Registration found using FindFirst either.');
                    end;
                }
                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    ToolTip = 'Specifies the unique identifier for the property associated with the brokerage master data.';

                    trigger OnDrillDown()
                    var
                        PropertyProfile: Record "Property Registration";
                    begin
                        PropertyProfile.SetRange("Property ID", Rec."Property ID");
                        if PropertyProfile.FindSet() then
                            PAGE.RunModal(PAGE::"Property Registration Card", PropertyProfile)
                        else
                            Message('No Property Registration found using FindFirst either.');
                    end;
                }
                field("Property Name"; Rec."Property Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the property associated with the brokerage master data.';
                }
                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the start date for the brokerage calculation period.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the end date for the brokerage calculation period.';
                }
                field("Property Type"; Rec."Property Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the type of property associated with the brokerage master data, such as Residential or Commercial.';
                }
                field("Calculation Method"; Rec."Calculation Method")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the method used for calculating the brokerage, such as Percentage or Fixed Amount.';
                }
                field("Base Amount"; Rec."Base Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the base amount used for calculating the brokerage, which can be a percentage of the contract amount or a fixed amount.';
                }
                field("Base Amount Type"; Rec."Base Amount Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the type of base amount used for calculating the brokerage, such as Contract Amount or Property Value.';
                }
                field("Percentage Type"; Rec."Percentage Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the type of percentage used for calculating the brokerage, such as Monthly or Annual.';
                }

                field("Percentage"; Rec."Percentage")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the percentage used for calculating the brokerage, applicable if the calculation method is Percentage.';
                }
                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the calculated brokerage amount based on the base amount and percentage, applicable if the calculation method is Percentage.';
                }
                field("Frequency Of Payment"; Rec."Frequency Of Payment")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the frequency of payment for the brokerage, such as Monthly, Quarterly, or Annually.';
                }
                field("Contract Status"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the current status of the contract associated with the brokerage master data, such as Active or Inactive.';
                }
                field("Owner Name"; Rec."Owner Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the owner associated with the brokerage master data.';
                }
                // field("Unit ID"; Rec."Unit ID")
                // {
                //     ApplicationArea = All;
                //     Editable = false;
                //     ToolTip = 'Specifies the unique identifier for the unit associated with the brokerage master data.';
                // }
                field("Unit Number"; Rec."Unit Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the number assigned to the unit associated with the brokerage master data.';
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the unit associated with the brokerage master data.';
                }
                field("Tenant Name"; Rec."Tenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the tenant associated with the brokerage master data.';
                }
                field("Owner ID"; Rec."Owner ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the owner associated with the brokerage master data.';
                }
            }
        }
    }

}
