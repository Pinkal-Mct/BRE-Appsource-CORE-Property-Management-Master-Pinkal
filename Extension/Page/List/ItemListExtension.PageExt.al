pageextension 73209600 ItemListExtension extends "Item List"
{
    Caption = 'Unit list';

    layout
    {
        modify("No.")
        {
            Caption = 'Unit ID';
        }
        modify("Substitutes Exist")
        {
            Visible = false;
        }
        modify("Assembly BOM")
        {
            Visible = false;
        }
        modify("Cost is Adjusted")
        {
            Visible = false;
        }
        modify("Unit Cost")
        {
            Visible = false;
        }
        modify("Unit Price")
        {
            Visible = false;
        }
        modify("Vendor No.")
        {
            Visible = false;
        }
        modify("Default Deferral Template Code")
        {
            Visible = false;
        }
        modify(Type)
        {
            Visible = false;
        }
        modify(Description)
        {
            Visible = false;
        }

        addbefore(Description)
        {
            field("Unit Name"; Rec."Unit Name")
            {
                ApplicationArea = All;
                Caption = 'Unit Name';
                ToolTip = 'Name of the unit';
            }
            field("Property Name"; Rec."Property Name")
            {
                ApplicationArea = All;
                Caption = 'Property Name';
                ToolTip = 'Name of the property to which the unit belongs';
            }
            field("Usage Type"; Rec."Usage Type")
            {
                ApplicationArea = All;
                Caption = 'Usage Type';
                ToolTip = 'Type of usage for the unit, e.g., Residential, Commercial';
            }
            field("Unit Status"; Rec."Unit Status")
            {
                ApplicationArea = All;
                Caption = 'Unit Status';
                ToolTip = 'Current status of the unit, e.g., Free, Occupied, Under Maintenance';
            }

            field("Merging/Splitting"; rec."MergeSplitOption")
            {
                ApplicationArea = All;
                ToolTip = 'Indicates if the unit is available for merging or splitting';
            }

            field("Market Rate per Sq. Ft."; rec."Market Rate per Sq. Ft.")
            {
                ApplicationArea = All;
                ToolTip = 'Market rate per square foot for the unit';
            }

            field("Amount"; Rec."Amount")
            {
                ApplicationArea = All;
                Caption = 'Amount';
                ToolTip = 'Total amount associated with the unit';
            }

            field("Unit Registration Date"; Rec."Last Date Modified")
            {
                ApplicationArea = All;
                Caption = 'Last Date Modified';
                ToolTip = 'Date when the unit was last modified';
            }

            field("Merged Unit ID"; Rec."Merged Unit ID")
            {
                ApplicationArea = All;
                Caption = 'Merged Unit ID';
                ToolTip = 'ID of the unit if this unit is a result of merging other units';
            }

        }
    }

    var
        Selected: Boolean; // Variable to store whether the unit is selected

    // Function to retrieve selected Unit IDs
    procedure GetSelectedUnitIDs(): Text
    var
        SelectedUnits: Text;
    begin
        SelectedUnits := '';
        if Rec.FindSet() then
            repeat
                if Selected then begin
                    if SelectedUnits <> '' then
                        SelectedUnits := SelectedUnits + ',';
                    SelectedUnits := SelectedUnits + Rec."No.";
                end;
            until Rec.Next() = 0;

        exit(SelectedUnits);
    end;

    trigger OnOpenPage()
    var
    begin
        // Set the filter to show only records where "Item type template" is "Unit Service"
        Rec.SetRange("Item type template", Rec."Item type template"::"Unit Service");
    end;
}