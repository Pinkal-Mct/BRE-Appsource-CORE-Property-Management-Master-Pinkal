page 73209773 "Contract Renewal List"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "Contract Renewal";
    Caption = 'Contract Renewal List';
    CardPageId = 73209680;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Id"; rec.Id)
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the contract renewal.';
                }
                field("Contract ID"; rec."Contract ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Identifier for the contract associated with the renewal.';
                }
                field("Contract Start Date"; rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Start date of the contract associated with the renewal.';
                }
                field("Contract End Date"; rec."Contract End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'End date of the contract associated with the renewal.';
                }
                field("Contract Amount"; rec."Contract Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Amount of the contract associated with the renewal.';
                }
                field("Unit ID"; rec."Unit ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Identifier for the unit associated with the contract renewal.';
                }

                field("Merge Unit ID"; rec."Merge Unit ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Identifier for the unit to be merged with the contract renewal.';
                }
                field("Unit Name"; rec."Unit Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the unit associated with the contract renewal.';
                }
                field("Property ID"; rec."Property ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Identifier for the property associated with the contract renewal.';
                }
                field("Property Name"; rec."Property Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the property associated with the contract renewal.';
                }
                field("Contract Status"; rec."Renewal Contract Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Status of the contract renewal.';

                }
            }
        }
    }
}