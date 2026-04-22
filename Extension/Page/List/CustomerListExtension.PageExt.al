pageextension 73209599 CustomerListExtension extends "Customer List"
{
    layout
    {
        addlast(Control1)
        {
            field("Customer Type"; Rec."Customer Type")
            {
                ApplicationArea = All;
                Caption = 'Customer Type';
                ToolTip = 'Specifies the type of customer.';
            }
            field("Business Unit"; Rec."Business Unit")
            {
                ApplicationArea = All;
                Caption = 'Business unit';
                Editable = false;
                ToolTip = 'Specifies the business unit associated with the customer.';
            }
        }
        // Add changes to page layout here
    }

    trigger OnOpenPage()
    var
        ModuleSetup: Record "Module Setup";
        ActiveModuleName: Text[50];
    begin
        // Find the active module
        if ModuleSetup.FindSet() then begin
            repeat
                if ModuleSetup."Is Active" then
                    ActiveModuleName := ModuleSetup."Extension Name";
            until ModuleSetup.Next() = 0;

            // Apply filter based on active module
            case ActiveModuleName of
                'PROPERTY MANAGEMENT':
                    Rec.SetRange("Customer Type", "Customer Type Enum"::Tenant);
                'PROPERTY SALES':
                    Rec.SetRange("Customer Type", "Customer Type Enum"::Buyer);
                else
                    Rec.Reset(); // No active module found, clear filters
            end;
        end
        else
            Rec.Reset(); // No records in Module Setup, clear filters

    end;

}