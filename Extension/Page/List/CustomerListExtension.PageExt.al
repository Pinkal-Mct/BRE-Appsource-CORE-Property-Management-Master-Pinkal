pageextension 73209599 BLRCustomerListExtension extends "Customer List"
{
    layout
    {
        addlast(Control1)
        {
            field("BLRCustomer Type"; Rec."BLRCustomer Type")
            {
                ApplicationArea = All;
                Caption = 'Customer Type';
                ToolTip = 'Specifies the type of customer.';
            }
            field("BLRBusiness Unit"; Rec."BLRBusiness Unit")
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
        ModuleSetup: Record "BLRModuleSetup";
        ActiveModuleName: Text[50];
    begin
        // Find the active module
        if ModuleSetup.FindSet() then begin
            repeat
                if ModuleSetup."BLRIs Active" then
                    ActiveModuleName := ModuleSetup."BLRExtension Name";
            until ModuleSetup.Next() = 0;

            // Apply filter based on active module
            case ActiveModuleName of
                'PROPERTY MANAGEMENT':
                    Rec.SetRange("BLRCustomer Type", "BLRCustomer Type Enum"::Tenant);
                'PROPERTY SALES':
                    Rec.SetRange("BLRCustomer Type", "BLRCustomer Type Enum"::Buyer);
                else
                    Rec.Reset(); // No active module found, clear filters
            end;
        end
        else
            Rec.Reset(); // No records in Module Setup, clear filters

    end;

}