page 73209765 "BLRBrokerage Master Data List"
{
    PageType = List;
    SourceTable = "BLRBrokerageMasterData";
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
                field("Vendor ID"; Rec."BLRVendor ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    ToolTip = 'Specifies the unique identifier for the vendor associated with the brokerage master data.';

                    trigger OnDrillDown()
                    var
                        VendorProfile: Record "BLRVendorProfile";
                    begin
                        VendorProfile.SetRange("BLRVendor ID", Rec."BLRVendor ID");
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
                    ToolTip = 'Specifies the name of the vendor associated with the brokerage master data.';
                }
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    ToolTip = 'Specifies the unique identifier for the contract associated with the brokerage master data.';

                    trigger OnDrillDown()
                    var
                        tenancycontract: Record "BLRTenancyContract";
                    begin
                        tenancycontract.SetRange("BLRContract ID", Rec."BLRContract ID");
                        if tenancycontract.FindSet() then
                            PAGE.RunModal(PAGE::"BLRTenancy Contract Card", tenancycontract)
                        else
                            Message('No Property Registration found using FindFirst either.');
                    end;
                }
                field("Property ID"; Rec."BLRProperty ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    ToolTip = 'Specifies the unique identifier for the property associated with the brokerage master data.';

                    trigger OnDrillDown()
                    var
                        PropertyProfile: Record "BLRPropertyRegistration";
                    begin
                        PropertyProfile.SetRange("BLRProperty ID", Rec."BLRProperty ID");
                        if PropertyProfile.FindSet() then
                            PAGE.RunModal(PAGE::"BLRProperty Registration Card", PropertyProfile)
                        else
                            Message('No Property Registration found using FindFirst either.');
                    end;
                }
                field("Property Name"; Rec."BLRProperty Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the property associated with the brokerage master data.';
                }
                field("Start Date"; Rec."BLRStart Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the start date for the brokerage calculation period.';
                }
                field("End Date"; Rec."BLREnd Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the end date for the brokerage calculation period.';
                }
                field("BLRPropertyType"; Rec."BLRProperty Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the type of property associated with the brokerage master data, such as Residential or Commercial.';
                }
                field("Calculation Method"; Rec."BLRCalculation Method")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the method used for calculating the brokerage, such as Percentage or Fixed Amount.';
                }
                field("Base Amount"; Rec."BLRBase Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the base amount used for calculating the brokerage, which can be a percentage of the contract amount or a fixed amount.';
                }
                field("Base Amount Type"; Rec."BLRBase Amount Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the type of base amount used for calculating the brokerage, such as Contract Amount or Property Value.';
                }
                field("Percentage Type"; Rec."BLRPercentage Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the type of percentage used for calculating the brokerage, such as Monthly or Annual.';
                }

                field("Percentage"; Rec."BLRPercentage")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the percentage used for calculating the brokerage, applicable if the calculation method is Percentage.';
                }
                field("Amount"; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the calculated brokerage amount based on the base amount and percentage, applicable if the calculation method is Percentage.';
                }
                field("Frequency Of Payment"; Rec."BLRFrequency Of Payment")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the frequency of payment for the brokerage, such as Monthly, Quarterly, or Annually.';
                }
                field("Contract Status"; Rec."BLRContract Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the current status of the contract associated with the brokerage master data, such as Active or Inactive.';
                }
                field("Owner Name"; Rec."BLROwner Name")
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
                field("Unit Number"; Rec."BLRUnit Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the number assigned to the unit associated with the brokerage master data.';
                }
                field("Unit Name"; Rec."BLRUnit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the unit associated with the brokerage master data.';
                }
                field("Tenant Name"; Rec."BLRTenant Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the tenant associated with the brokerage master data.';
                }
                field("Owner ID"; Rec."BLROwner ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the owner associated with the brokerage master data.';
                }
            }
        }
    }

}
