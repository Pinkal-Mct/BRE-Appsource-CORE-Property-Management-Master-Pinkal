page 73209773 "BLRContract Renewal List"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "BLRContractRenewal";
    Caption = 'Contract Renewal List';
    CardPageId = 73209680;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Id"; rec."BLRId")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the contract renewal.';
                }
                field("Contract ID"; rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Identifier for the contract associated with the renewal.';
                }
                field("Contract Start Date"; rec."BLRContract Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Start date of the contract associated with the renewal.';
                }
                field("Contract End Date"; rec."BLRContract End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'End date of the contract associated with the renewal.';
                }
                field("Contract Amount"; rec."BLRContract Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Amount of the contract associated with the renewal.';
                }
                field("Unit ID"; rec."BLRUnit ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Identifier for the unit associated with the contract renewal.';
                }

                field("Merge Unit ID"; rec."BLRMerge Unit ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Identifier for the unit to be merged with the contract renewal.';
                }
                field("Unit Name"; rec."BLRUnit Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the unit associated with the contract renewal.';
                }
                field("Property ID"; rec."BLRProperty ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Identifier for the property associated with the contract renewal.';
                }
                field("Property Name"; rec."BLRProperty Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the property associated with the contract renewal.';
                }
                field("Contract Status"; rec."BLRRenewal Contract Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Status of the contract renewal.';

                }
            }
        }
    }
}