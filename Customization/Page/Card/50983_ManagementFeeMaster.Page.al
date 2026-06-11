page 73209671 "BLRMangement Fee Master Card"
{
    SourceTable = "BLRManagementFeeMasterData";
    ApplicationArea = All;
    Caption = 'Management Fee Master Card';
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(Group)
            {
                field("Vendor ID"; Rec."BLRVendor ID")
                {
                    ApplicationArea = All;
                    TableRelation = Vendor;
                }
                field("Vendor Name"; Rec."BLRVendor Name")
                {
                    ApplicationArea = All;
                    Editable = false;


                }
            }
            part(ManagementFeeGrid; "BLRManagement Fee GridListPart")
            {
                SubPageLink = "BLRManagement Fee Number" = FIELD("BLRManagement Fee Number"); // Link to filter attachments for this owner only
                ApplicationArea = All;
                Caption = 'Management Fee Details';
                UpdatePropagation = Both;
            }
        }
    }


}