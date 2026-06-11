page 73209698 "BLRManagement Fee Calc."
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "BLRManagementFeeCalcHeader";
    Caption = 'Management Fee Calculation';

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Entry No."; Rec."BLREntry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                    Visible = false;
                    ToolTip = 'Specifies the unique entry number for the management fee calculation. This field is auto-generated and cannot be edited.';
                }

                field("Report Date"; Rec."BLRReport Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date of the management fee report.';
                }
                field("Owner ID"; Rec."BLROwner ID")
                {
                    ApplicationArea = All;
                    Editable = not Rec."BLRAll Owners";
                    ToolTip = 'Specifies the unique identifier for the owner. If "All Owners" is selected, this field will be ignored.';

                    trigger OnValidate()
                    begin
                        if Rec."BLROwner ID" <> 0 then
                            ownereditable := false
                        else
                            ownereditable := true;
                    end;
                }
                field("Owner Name"; Rec."BLROwner Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the owner.';
                }
                field("All Owners"; Rec."BLRAll Owners")
                {
                    ApplicationArea = All;
                    Editable = ownereditable;
                    ToolTip = 'Select this option to include all owners in the management fee calculation. If selected, the Owner ID field will be ignored.';

                    trigger OnValidate()
                    begin
                        if Rec."BLRAll Owners" = true then
                            Rec.Validate("BLRAll Properties", true)

                        else
                            Rec.Validate("BLRAll Properties", false);

                    end;
                }
                field("All Properties"; Rec."BLRAll Properties")
                {
                    ApplicationArea = All;
                    Editable = propertyeditable;
                    ToolTip = 'Select this option to include all properties in the management fee calculation. If selected, the Property field will be ignored.';
                    // trigger OnValidate()
                    // begin
                    //     if Rec."BLRAll Properties" = true then
                    //         allpropertyeditable := false
                    //     else
                    //         allpropertyeditable := true;
                    // end;
                }
                field(Property; Rec."BLRProperty")
                {
                    ApplicationArea = All;
                    Editable = not Rec."BLRAll Properties";
                    ToolTip = 'Specifies the properties to be included in the management fee calculation. If "All Properties" is selected, this field will be ignored.';


                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PropertyRegistrationRec: Record "BLRPropertyRegistration";
                        PropertyRegistrationListPage: Page "BLRProperty Registration List";
                        SelectedPropertyNames: Text[250];
                    // PropertyName: Text[100];
                    begin
                        PropertyRegistrationRec.Reset();
                        if Rec."BLROwner ID" = 0 then
                            PropertyRegistrationRec.FindSet()
                        else
                            PropertyRegistrationRec.SetRange("BLROwner ID", Rec."BLROwner ID");

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
                                    SelectedPropertyNames := SelectedPropertyNames + PropertyRegistrationRec."BLRProperty Name";
                                until PropertyRegistrationRec.Next() = 0;
                                Rec."BLRProperty" := SelectedPropertyNames;
                                if Rec."BLRProperty" <> ''
                                then
                                    propertyeditable := false
                                else
                                    propertyeditable := true;
                            end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if Rec."BLRProperty" <> '' then
                            propertyeditable := false
                        else
                            propertyeditable := true;
                    end;
                }
                field("Financial Year"; Rec."BLRFinancial Year")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the financial year for which the management fee is being calculated.';
                }
                field("Period From"; Rec."BLRPeriod From")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the starting date of the period for which the management fee is being calculated.';
                }
                field("Period To"; Rec."BLRPeriod To")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ending date of the period for which the management fee is being calculated.';
                }
            }
            part(ManagementFeeGrid; "BLRManagement Fee Calc Grid")
            {
                SubPageLink = "BLRHeader No." = field("BLREntry No.");
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
                    ManagementFeeCalcCodeunit: Codeunit "BLRSetMgtFeeCalculation";
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
        allownereditable := not Rec."BLRAll Owners";
        allpropertyeditable := not Rec."BLRAll Properties";
    end;

    var
        allownereditable: Boolean;
        allpropertyeditable: Boolean;
        propertyeditable: Boolean;
        ownereditable: Boolean;


}