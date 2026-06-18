pageextension 73209600 BLRItemListExtension extends "Item List"
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
            field("BLRUnit Name"; Rec."BLRUnit Name")
            {
                ApplicationArea = All;
                Caption = 'Unit Name';
                ToolTip = 'Name of the unit';
            }
            field("BLRProperty Name"; Rec."BLRProperty Name")
            {
                ApplicationArea = All;
                Caption = 'Property Name';
                ToolTip = 'Name of the property to which the unit belongs';
            }
            field("BLRUsage Type"; Rec."BLRUsage Type")
            {
                ApplicationArea = All;
                Caption = 'Usage Type';
                ToolTip = 'Type of usage for the unit, e.g., Residential, Commercial';
            }
            field("BLRUnit Status"; Rec."BLRUnit Status")
            {
                ApplicationArea = All;
                Caption = 'Unit Status';
                ToolTip = 'Current status of the unit, e.g., Free, Occupied, Under Maintenance';
            }

            field("BLRMerging/Splitting"; rec."BLRMergeSplitOption")
            {
                ApplicationArea = All;
                ToolTip = 'Indicates if the unit is available for merging or splitting';
            }

            field("BLRMarket Rate per Sq. Ft."; rec."BLRMarket Rate per Sq. Ft.")
            {
                ApplicationArea = All;
                ToolTip = 'Market rate per square foot for the unit';
            }

            field("BLRAmount"; Rec."BLRAmount")
            {
                ApplicationArea = All;
                Caption = 'Amount';
                ToolTip = 'Total amount associated with the unit';
            }

            field("BLRUnit Registration Date"; Rec."Last Date Modified")
            {
                ApplicationArea = All;
                Caption = 'Last Date Modified';
                ToolTip = 'Date when the unit was last modified';
            }

            field("BLRMerged Unit ID"; Rec."BLRMerged Unit ID")
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
    procedure BLRGetSelectedUnitIDs(): Text
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
        Rec.SetRange("BLRItem type template", Rec."BLRItem type template"::"Unit Service");
    end;
}