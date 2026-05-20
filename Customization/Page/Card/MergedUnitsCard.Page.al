page 73209700 "Merged Units Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Merged Units";
    Caption = 'Merged Unit Card';

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'Merged Unit Information';

                field(FixedNumber; Rec.FixedNumber)
                {
                    ApplicationArea = All;
                    Caption = 'FixedNumber';
                    Editable = false;
                    ToolTip = 'The Fixed Number is a unique identifier for the merged unit.';
                }

                field("Merged Unit ID"; Rec."Merged Unit ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The Merged Unit ID is a unique identifier for the merged unit.';
                }

                field("Property ID"; Rec."Property ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'The Property ID is the identifier for the property associated with the merged unit.';
                }

                field("Property Name"; Rec."Property Name") // Custom Field
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    Editable = false;
                    ToolTip = 'The Property Name is the name of the property associated with the merged unit.';
                }

                field("Unit ID"; Rec."Unit ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Visible = true;
                    AssistEdit = true;
                    ToolTip = 'The Unit ID is the identifier for the unit associated with the merged unit.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        UnitRec: Record "Item"; // Reference to the Unit table
                        UnitList: Page "Item List"; // Reference to the Unit List Page

                    begin
                        if Rec."Property ID" = '' then begin
                            Message('Please select a Property ID first.');
                            exit(false);
                        end;

                        // Apply filters to show only units that are free and have the merging/splitting status as "Single"
                        UnitRec.Reset();
                        UnitRec.SetRange("Property ID", Rec."Property ID");
                        // UnitRec.SetRange("Unit Status", 'Free'); // Filter for free units
                        UnitRec.SetRange("Unit Status", UnitRec."Unit Status"::Free);

                        UnitRec.SetRange("MergeSplitOption", UnitRec."MergeSplitOption"::Single); // Filter for merging/splitting status

                        if UnitRec.IsEmpty then begin
                            Message('No available units that are free and have "Single" option for the selected Property ID.');
                            exit(false);
                        end;

                        UnitList.SetTableView(UnitRec);

                        if UnitList.LookupMode then
                            if UnitList.RunModal() = Action::LookupOk then begin
                                Rec."Unit ID" := UnitRec."No."; // Set selected unit ID
                                exit(true);
                            end;
                        exit(false);
                    end;

                    trigger OnAssistEdit()
                    var
                        UnitRec: Record "Item"; // Reference to the Unit table
                        SubMergedUnitRec: Record "Sub Merged Units"; // Reference to the Sub Merged Units table
                        UnitList: Page "Item List"; // Reference to the Unit List Page
                        SelectedUnits: Text; // To store selected Unit IDs
                        TotalUnitSize: Decimal;
                        TotalMarketRate: Decimal;
                        TotalAmount: Decimal;
                        UnitNames: Text; // To store concatenated Unit Names
                        confirmDialog: Boolean;
                        UnitNumber: Code[1024]; // To store concatenated Unit Numbers
                        MakaniNumber: Text[100]; // To store concatenated Makani Numbers
                        MunicipalityNumber: Text[100]; // To store concatenated Municipality Numbers
                        DewaNumber: Text[100];
                    begin
                        if Rec."Property ID" = '' then begin
                            Message('Please select a Property ID first.');
                            exit;
                        end;

                        // Apply filters to show only units that are free and have the merging/splitting status as "Single"
                        UnitRec.Reset();
                        UnitRec.SetRange("Property ID", Rec."Property ID");
                        UnitRec.SetRange("Unit Status", UnitRec."Unit Status"::Free);
                        UnitRec.SetRange("MergeSplitOption", UnitRec."MergeSplitOption"::Single); // Filter for merging/splitting status

                        if UnitRec.IsEmpty then begin
                            Message('No available units that are free and have "Single" option for the selected Property ID.');
                            exit;
                        end;

                        UnitList.SetTableView(UnitRec);
                        UnitList.LookupMode := true;

                        // Run the page and capture selected units
                        if UnitList.RunModal() = Action::LookUpOk then begin
                            SelectedUnits := UnitList.GetSelectionFilter();
                            confirmDialog := Dialog.Confirm('Please confirm if you would like to proceed with the merge of items/units %1.', true, SelectedUnits);

                            if confirmDialog then begin
                                // Reset totals for calculation
                                TotalUnitSize := 0;
                                TotalMarketRate := 0;
                                TotalAmount := 0;

                                // Delete existing Sub Merged Units for the current Merged Unit
                                SubMergedUnitRec.SetRange("Merged Unit ID", Rec."Merged Unit ID");
                                if SubMergedUnitRec.FindSet() then
                                    repeat
                                        SubMergedUnitRec.Delete();
                                    until SubMergedUnitRec.Next() = 0;

                                // Loop through selected units to calculate total unit size, market rate, and amount
                                UnitRec.Reset();
                                UnitRec.SetFilter("No.", SelectedUnits); // Apply filter on selected Unit IDs
                                if UnitRec.FindSet() then
                                    repeat
                                        TotalUnitSize += UnitRec."Unit Size"; // Sum the unit sizes
                                        TotalMarketRate += UnitRec."Market Rate per Sq. Ft."; // Sum the market rate per square values
                                        TotalAmount += UnitRec."Unit Size" * UnitRec."Market Rate per Sq. Ft."; // Calculate total amount based on market rate per square
                                        if StrLen(UnitNames) > 0 then
                                            UnitNames += ', ';
                                        UnitNames += UnitRec."Unit Name";

                                        if StrLen(UnitNumber) > 0 then
                                            UnitNumber += ', ';
                                        UnitNumber += UnitRec."Unit Number";

                                        if StrLen(MakaniNumber) > 0 then
                                            MakaniNumber += ', ';
                                        MakaniNumber += UnitRec."Makani Number";

                                        if StrLen(MunicipalityNumber) > 0 then
                                            MunicipalityNumber += ', ';
                                        MunicipalityNumber += UnitRec."Municipality Number";

                                        if StrLen(DewaNumber) > 0 then
                                            DewaNumber += ', ';
                                        DewaNumber += UnitRec."DEWA Number";
                                        // Insert into Sub Merged Units table
                                        SubMergedUnitRec.Init();
                                        SubMergedUnitRec."Merged Unit ID" := Rec."Merged Unit ID";
                                        SubMergedUnitRec."Unit ID" := UnitRec."No.";
                                        SubMergedUnitRec."Base Unit of Measure" := UnitRec."Base Unit of Measure";
                                        SubMergedUnitRec."Unit Size" := UnitRec."Unit Size";
                                        SubMergedUnitRec."Market Rate per Square" := UnitRec."Market Rate per Sq. Ft.";
                                        SubMergedUnitRec."Amount" := UnitRec."Unit Size" * UnitRec."Market Rate per Sq. Ft.";
                                        SubMergedUnitRec."Single Unit Name" := UnitRec."Unit Name";

                                        SubMergedUnitRec.Insert();

                                        // Update unit's status
                                        UnitRec."MergeSplitOption" := UnitRec."MergeSplitOption"::Merge; // Change the status to "Merge"
                                        UnitRec."Merged Unit ID" := Rec."Merged Unit ID";
                                        UnitRec.Modify(); // Save the changes
                                    until UnitRec.Next() = 0;


                                // Remove trailing comma and space from UnitNames
                                if StrLen(UnitNames) > 2 then
                                    UnitNames := CopyStr(UnitNames, 1, StrLen(UnitNames) - 2);

                                // Set the total unit size, total market rate, and total amount in the respective fields
                                Rec."Unit Size" := TotalUnitSize;
                                Rec."Market Rate per Square" := TotalMarketRate;
                                Rec."Amount" := TotalAmount;

                                // Set the selected Unit IDs to the Unit ID field
                                Rec."Unit ID" := CopyStr(SelectedUnits, 1, StrLen(SelectedUnits)); // Remove the last comma
                                Rec."Single Unit Name" := CopyStr(UnitNames, 1, StrLen(UnitNames));
                                Rec."Unit Number" := CopyStr(UnitNumber, 1, StrLen(UnitNumber));
                                Rec."Makani Number" := MakaniNumber;
                                Rec."Municipality Number" := MunicipalityNumber;
                                Rec."DEWA Number" := DewaNumber;
                                Rec."Spliting Status" := Rec."Spliting Status"::"Merge";
                                Rec.Modify(); // Explicitly save changes to the current record
                            end;
                        end;
                    end;
                }

                field("Merged Unit Name"; Rec."Merged Unit Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the Merged Unit Name.';
                }

                field("Base Unit of Measure"; rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'The Base Unit of Measure is the unit of measure used for the merged unit.';
                }

                field("Unit Size"; Rec."Unit Size")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the Unit Size.';
                }

                field("Market Rate per Square"; Rec."Market Rate per Square")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Enter the Market Rate per Square.';
                }

                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the Amount.';
                }

                field("Property Type"; Rec."Property Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'The Property Type is the type of property associated with the merged unit.';
                }

                field("Single Unit Name"; Rec."Single Unit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    MultiLine = true;
                    ToolTip = 'The Single Unit Name is the name of the single unit associated with the merged unit.';
                }

                field("Unit Number"; Rec."Unit Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The Unit Number is the number of the unit associated with the merged unit.';
                }
                field("Makani Number"; Rec."Makani Number")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Municipality Number"; Rec."Municipality Number")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("DEWA Number"; Rec."DEWA Number")
                {
                    ApplicationArea = All;
                    Editable = false;

                }

                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The Status indicates the current state of the merged unit.';
                }


                field("Splitting Status"; Rec."Spliting Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'The Splitting Status indicates whether the merged unit is currently being merged or unmerged.';

                    trigger OnValidate()
                    var
                        ItemRec: Record Item;
                        SelectedUnits: Text[1024];
                    begin // Check if the Splitting Status is set to Unmerge
                        if Rec."Spliting Status" = Rec."Spliting Status"::Unmerge then begin
                            // Set Merge Unit Status to N/A
                            Rec."Status" := Rec."Status"::"N/A";

                            // Retrieve the list of units associated with this merged unit
                            SelectedUnits := Rec."Unit ID"; // Contains the Unit IDs associated with the merged unit

                            // Update each item in the Item table with the Unit IDs in SelectedUnits
                            ItemRec.SetFilter("No.", SelectedUnits); // Apply filter to the selected units
                            if ItemRec.FindSet() then
                                repeat
                                    // ItemRec."Unit Status" := 'Free'; // Set Unit Status to Free
                                    ItemRec."Unit Status" := ItemRec."Unit Status"::Free;

                                    ItemRec."MergeSplitOption" := ItemRec."MergeSplitOption"::Single;
                                    ItemRec."Merged Unit ID" := 0; // Set Merging/Splitting to Single
                                    ItemRec.Modify(); // Save changes to the Item record
                                until ItemRec.Next() = 0;

                            // Update the Merged Unit record with the new Status
                            Rec.Modify();
                        end;
                    end;
                }

            }
            group("Unit Details")
            {
                Caption = 'Unit all Details';

                part("Unit all Details"; "Sub Merged Units Card")
                {
                    SubPageLink = "Merged Unit ID" = FIELD("Merged Unit ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                }
            }
        }

    }

    trigger OnAfterGetRecord()
    begin
        // Ensure data is loaded into the subpage grid
        CurrPage."Unit all Details".Page.Update(); // Reload the grid data
    end;
}