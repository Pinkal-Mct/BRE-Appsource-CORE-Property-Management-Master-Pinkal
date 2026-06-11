page 73209700 "BLRMerged Units Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "BLRMergedUnits";
    Caption = 'Merged Unit Card';

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'Merged Unit Information';

                field(FixedNumber; Rec."BLRFixedNumber")
                {
                    ApplicationArea = All;
                    Caption = 'FixedNumber';
                    Editable = false;
                    ToolTip = 'The Fixed Number is a unique identifier for the merged unit.';
                }

                field("Merged Unit ID"; Rec."BLRMerged Unit ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The Merged Unit ID is a unique identifier for the merged unit.';
                }

                field("Property ID"; Rec."BLRProperty ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'The Property ID is the identifier for the property associated with the merged unit.';
                }

                field("Property Name"; Rec."BLRProperty Name") // Custom Field
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    Editable = false;
                    ToolTip = 'The Property Name is the name of the property associated with the merged unit.';
                }

                field("Unit ID"; Rec."BLRUnit ID")
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
                        if Rec."BLRProperty ID" = '' then begin
                            Message('Please select a Property ID first.');
                            exit(false);
                        end;

                        // Apply filters to show only units that are free and have the merging/splitting status as "Single"
                        UnitRec.Reset();
                        UnitRec.SetRange("BLRProperty ID", Rec."BLRProperty ID");
                        // UnitRec.SetRange("BLRUnit Status", 'Free'); // Filter for free units
                        UnitRec.SetRange("BLRUnit Status", UnitRec."BLRUnit Status"::Free);

                        UnitRec.SetRange("BLRMergeSplitOption", UnitRec."BLRMergeSplitOption"::Single); // Filter for merging/splitting status

                        if UnitRec.IsEmpty then begin
                            Message('No available units that are free and have "Single" option for the selected Property ID.');
                            exit(false);
                        end;

                        UnitList.SetTableView(UnitRec);

                        if UnitList.LookupMode then
                            if UnitList.RunModal() = Action::LookupOk then begin
                                Rec."BLRUnit ID" := UnitRec."No."; // Set selected unit ID
                                exit(true);
                            end;
                        exit(false);
                    end;

                    trigger OnAssistEdit()
                    var
                        UnitRec: Record "Item"; // Reference to the Unit table
                        SubMergedUnitRec: Record "BLRSubMergedUnits"; // Reference to the Sub Merged Units table
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
                        if Rec."BLRProperty ID" = '' then begin
                            Message('Please select a Property ID first.');
                            exit;
                        end;

                        // Apply filters to show only units that are free and have the merging/splitting status as "Single"
                        UnitRec.Reset();
                        UnitRec.SetRange("BLRProperty ID", Rec."BLRProperty ID");
                        UnitRec.SetRange("BLRUnit Status", UnitRec."BLRUnit Status"::Free);
                        UnitRec.SetRange("BLRMergeSplitOption", UnitRec."BLRMergeSplitOption"::Single); // Filter for merging/splitting status

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
                                SubMergedUnitRec.SetRange("BLRMerged Unit ID", Rec."BLRMerged Unit ID");
                                if SubMergedUnitRec.FindSet() then
                                    repeat
                                        SubMergedUnitRec.Delete();
                                    until SubMergedUnitRec.Next() = 0;

                                // Loop through selected units to calculate total unit size, market rate, and amount
                                UnitRec.Reset();
                                UnitRec.SetFilter("No.", SelectedUnits); // Apply filter on selected Unit IDs
                                if UnitRec.FindSet() then
                                    repeat
                                        TotalUnitSize += UnitRec."BLRUnit Size"; // Sum the unit sizes
                                        TotalMarketRate += UnitRec."BLRMarket Rate per Sq. Ft."; // Sum the market rate per square values
                                        TotalAmount += UnitRec."BLRUnit Size" * UnitRec."BLRMarket Rate per Sq. Ft."; // Calculate total amount based on market rate per square
                                        if StrLen(UnitNames) > 0 then
                                            UnitNames += ', ';
                                        UnitNames += UnitRec."BLRUnit Name";

                                        if StrLen(UnitNumber) > 0 then
                                            UnitNumber += ', ';
                                        UnitNumber += UnitRec."BLRUnit Number";

                                        if StrLen(MakaniNumber) > 0 then
                                            MakaniNumber += ', ';
                                        MakaniNumber += UnitRec."BLRMakani Number";

                                        if StrLen(MunicipalityNumber) > 0 then
                                            MunicipalityNumber += ', ';
                                        MunicipalityNumber += UnitRec."BLRMunicipality Number";

                                        if StrLen(DewaNumber) > 0 then
                                            DewaNumber += ', ';
                                        DewaNumber += UnitRec."BLRDEWA Number";
                                        // Insert into Sub Merged Units table
                                        SubMergedUnitRec.Init();
                                        SubMergedUnitRec."BLRMerged Unit ID" := Rec."BLRMerged Unit ID";
                                        SubMergedUnitRec."BLRUnit ID" := UnitRec."No.";
                                        SubMergedUnitRec."BLRBase Unit of Measure" := UnitRec."Base Unit of Measure";
                                        SubMergedUnitRec."BLRUnit Size" := UnitRec."BLRUnit Size";
                                        SubMergedUnitRec."BLRMarket Rate per Square" := UnitRec."BLRMarket Rate per Sq. Ft.";
                                        SubMergedUnitRec."BLRAmount" := UnitRec."BLRUnit Size" * UnitRec."BLRMarket Rate per Sq. Ft.";
                                        SubMergedUnitRec."BLRSingle Unit Name" := UnitRec."BLRUnit Name";

                                        SubMergedUnitRec.Insert();

                                        // Update unit's status
                                        UnitRec."BLRMergeSplitOption" := UnitRec."BLRMergeSplitOption"::Merge; // Change the status to "Merge"
                                        UnitRec."BLRMerged Unit ID" := Rec."BLRMerged Unit ID";
                                        UnitRec.Modify(); // Save the changes
                                    until UnitRec.Next() = 0;


                                // Remove trailing comma and space from UnitNames
                                if StrLen(UnitNames) > 2 then
                                    UnitNames := CopyStr(UnitNames, 1, StrLen(UnitNames) - 2);

                                // Set the total unit size, total market rate, and total amount in the respective fields
                                Rec."BLRUnit Size" := TotalUnitSize;
                                Rec."BLRMarket Rate per Square" := TotalMarketRate;
                                Rec."BLRAmount" := TotalAmount;

                                // Set the selected Unit IDs to the Unit ID field
                                Rec."BLRUnit ID" := CopyStr(SelectedUnits, 1, StrLen(SelectedUnits)); // Remove the last comma
                                Rec."BLRSingle Unit Name" := CopyStr(UnitNames, 1, StrLen(UnitNames));
                                Rec."BLRUnit Number" := CopyStr(UnitNumber, 1, StrLen(UnitNumber));
                                Rec."BLRMakani Number" := MakaniNumber;
                                Rec."BLRMunicipality Number" := MunicipalityNumber;
                                Rec."BLRDEWA Number" := DewaNumber;
                                Rec."BLRSpliting Status" := Rec."BLRSpliting Status"::"Merge";
                                Rec.Modify(); // Explicitly save changes to the current record
                            end;
                        end;
                    end;
                }

                field("Merged Unit Name"; Rec."BLRMerged Unit Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the Merged Unit Name.';
                }

                field("Base Unit of Measure"; rec."BLRBase Unit of Measure")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'The Base Unit of Measure is the unit of measure used for the merged unit.';
                }

                field("Unit Size"; Rec."BLRUnit Size")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the Unit Size.';
                }

                field("Market Rate per Square"; Rec."BLRMarket Rate per Square")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Enter the Market Rate per Square.';
                }

                field("Amount"; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the Amount.';
                }

                field("BLRPropertyType"; Rec."BLRProperty Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'The Property Type is the type of property associated with the merged unit.';
                }

                field("Single Unit Name"; Rec."BLRSingle Unit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    MultiLine = true;
                    ToolTip = 'The Single Unit Name is the name of the single unit associated with the merged unit.';
                }

                field("Unit Number"; Rec."BLRUnit Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The Unit Number is the number of the unit associated with the merged unit.';
                }
                field("Makani Number"; Rec."BLRMakani Number")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Municipality Number"; Rec."BLRMunicipality Number")
                {
                    ApplicationArea = All;
                    Editable = false;

                }
                field("DEWA Number"; Rec."BLRDEWA Number")
                {
                    ApplicationArea = All;
                    Editable = false;

                }

                field("Status"; Rec."BLRStatus")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The Status indicates the current state of the merged unit.';
                }


                field("Splitting Status"; Rec."BLRSpliting Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'The Splitting Status indicates whether the merged unit is currently being merged or unmerged.';

                    trigger OnValidate()
                    var
                        ItemRec: Record Item;
                        SelectedUnits: Text[1024];
                    begin // Check if the Splitting Status is set to Unmerge
                        if Rec."BLRSpliting Status" = Rec."BLRSpliting Status"::Unmerge then begin
                            // Set Merge Unit Status to N/A
                            Rec."BLRStatus" := Rec."BLRStatus"::"N/A";

                            // Retrieve the list of units associated with this merged unit
                            SelectedUnits := Rec."BLRUnit ID"; // Contains the Unit IDs associated with the merged unit

                            // Update each item in the Item table with the Unit IDs in SelectedUnits
                            ItemRec.SetFilter("No.", SelectedUnits); // Apply filter to the selected units
                            if ItemRec.FindSet() then
                                repeat
                                    // ItemRec."Unit Status" := 'Free'; // Set Unit Status to Free
                                    ItemRec."BLRUnit Status" := ItemRec."BLRUnit Status"::Free;

                                    ItemRec."BLRMergeSplitOption" := ItemRec."BLRMergeSplitOption"::Single;
                                    ItemRec."BLRMerged Unit ID" := 0; // Set Merging/Splitting to Single
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

                part("Unit all Details"; "BLRSub Merged Units Card")
                {
                    SubPageLink = "BLRMerged Unit ID" = FIELD("BLRMerged Unit ID"); // Link to filter attachments for this owner only
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