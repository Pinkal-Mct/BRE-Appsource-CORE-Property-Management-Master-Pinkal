page 73209698 "Management Fee Calc."
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "Management Fee Calc. Header";
    Caption = 'Management Fee Calculation';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                    Visible = false;
                    ToolTip = 'Specifies the unique entry number for the management fee calculation. This field is auto-generated and cannot be edited.';
                }

                field("Report Date"; Rec."Report Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the management fee report.';
                }
                field("Owner ID"; Rec."Owner ID")
                {
                    ApplicationArea = All;
                    Editable = not Rec."All Owners";
                    ToolTip = 'Specifies the unique identifier for the owner. If "All Owners" is selected, this field will be ignored.';

                    trigger OnValidate()
                    begin
                        if Rec."Owner ID" <> 0 then
                            ownereditable := false
                        else
                            ownereditable := true;
                    end;
                }
                field("Owner Name"; Rec."Owner Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the owner.';
                }
                field("All Owners"; Rec."All Owners")
                {
                    ApplicationArea = All;
                    Editable = ownereditable;
                    ToolTip = 'Select this option to include all owners in the management fee calculation. If selected, the Owner ID field will be ignored.';

                    trigger OnValidate()
                    begin
                        if Rec."All Owners" = true then
                            Rec.Validate("All Properties", true)

                        else
                            Rec.Validate("All Properties", false);

                    end;
                }
                field("All Properties"; Rec."All Properties")
                {
                    ApplicationArea = All;
                    Editable = propertyeditable;
                    ToolTip = 'Select this option to include all properties in the management fee calculation. If selected, the Property field will be ignored.';
                    // trigger OnValidate()
                    // begin
                    //     if Rec."All Properties" = true then
                    //         allpropertyeditable := false
                    //     else
                    //         allpropertyeditable := true;
                    // end;
                }
                field(Property; Rec.Property)
                {
                    ApplicationArea = All;
                    Editable = not Rec."All Properties";
                    ToolTip = 'Specifies the properties to be included in the management fee calculation. If "All Properties" is selected, this field will be ignored.';


                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PropertyRegistrationRec: Record "Property Registration";
                        PropertyRegistrationListPage: Page "Property Registration List";
                        SelectedPropertyNames: Text[250];
                    // PropertyName: Text[100];
                    begin
                        PropertyRegistrationRec.Reset();
                        if Rec."Owner ID" = 0 then
                            PropertyRegistrationRec.FindSet()
                        else
                            PropertyRegistrationRec.SetRange("Owner ID", Rec."Owner ID");

                        PropertyRegistrationListPage.LookupMode(true);
                        PropertyRegistrationListPage.SetTableView(PropertyRegistrationRec);

                        if PropertyRegistrationListPage.RunModal() = ACTION::LookupOK then begin

                            //  Clear(PropertyName);
                            Clear(SelectedPropertyNames);

                            PropertyRegistrationListPage.SetSelectionFilter(PropertyRegistrationRec);
                            if PropertyRegistrationRec.FindSet() then begin
                                repeat
                                    if SelectedPropertyNames <> '' then
                                        SelectedPropertyNames := SelectedPropertyNames + ', ';
                                    SelectedPropertyNames := SelectedPropertyNames + PropertyRegistrationRec."Property Name";
                                until PropertyRegistrationRec.Next() = 0;
                                Rec.Property := SelectedPropertyNames;
                                if Rec.Property <> ''
                                then
                                    propertyeditable := false
                                else
                                    propertyeditable := true;
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if Rec.Property <> '' then
                            propertyeditable := false
                        else
                            propertyeditable := true;
                    end;
                }
                field("Financial Year"; Rec."Financial Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the financial year for which the management fee is being calculated.';
                }
                field("Period From"; Rec."Period From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the starting date of the period for which the management fee is being calculated.';
                }
                field("Period To"; Rec."Period To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ending date of the period for which the management fee is being calculated.';
                }
            }
            part(ManagementFeeGrid; "Management Fee Calc Grid")
            {
                SubPageLink = "Header No." = field("Entry No.");
                ApplicationArea = All;
                Caption = 'Management Fee Details';
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ShowCalculation)
            {
                Caption = 'Calculate Management Fee';
                Image = CalculateVAT;
                trigger OnAction()
                var
                    ManagementFeeCalcCodeunit: Codeunit "SetManagementFeeCalculation";
                begin
                    ManagementFeeCalcCodeunit.PopulateManagementFeeLines(Rec);
                end;

            }
        }

        area(Promoted)
        {
            actionref(ShowCalculation_; ShowCalculation)
            { }
        }
    }
    trigger OnOpenPage()
    begin
        allownereditable := true;
        allpropertyeditable := true;
        propertyeditable := true;
        ownereditable := true;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        allownereditable := not Rec."All Owners";
        allpropertyeditable := not Rec."All Properties";
    end;

    var
        allownereditable: Boolean;
        allpropertyeditable: Boolean;
        propertyeditable: Boolean;
        ownereditable: Boolean;


}