page 73209717 "BLRProperty Registration Card"
{
    PageType = Card;
    SourceTable = "BLRPropertyRegistration";
    ApplicationArea = All;
    Caption = 'Property Registration';
    // UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'Property Details';


                field("Property ID"; rec."BLRProperty ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the property.';
                }
                field("Property Name"; rec."BLRProperty Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the property.';

                    trigger OnValidate()
                    begin
                        InsertWorkflowFrquencyData();
                    end;
                }
                field("Company ID"; rec."BLRCompany ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the company associated with the property.';

                    trigger OnValidate()
                    begin
                        InsertWorkflowFrquencyData();
                    end;
                }



                field("Base Unit of Measure"; rec."BLRBase Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the base unit of measure for the property.';

                    trigger OnValidate()
                    begin
                        InsertWorkflowFrquencyData();
                    end;
                }
                field("Property Size"; rec."BLRProperty Size")
                {
                    ApplicationArea = All;
                    Caption = 'Property Size';
                    Editable = true;
                    ToolTip = 'Specifies the size of the property in square feet or square meters.';
                }

                field("Market Rate per Sq. Ft."; rec."BLRMarket Rate per Sq. Ft.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the market rate per square foot for the property.';
                }

                field("Address"; Rec."BLRAddress")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the address of the property.';
                }
                field("Built-up Area"; Rec."BLRBuilt-up Area")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the built-up area of the property in square feet or square meters.';
                }
                field("Makani Number"; Rec."BLRMakani Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Makani number for the property, which is a unique identifier for properties in Dubai.';
                }
                field("Municipality Number"; Rec."BLRMunicipality Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the municipality number for the property, which is used for official identification.';
                }
                field("DEWA Number"; Rec."BLRDEWA Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the DEWA number for the property, which is a unique identifier for properties in Dubai.';
                }
                field("Number of Floors"; Rec."BLRNumber of Floors")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total number of floors in the property.';
                }
                field("Number of Lifts"; Rec."BLRNumber of Lifts")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total number of lifts in the property.';
                }

            }


            group("Additional Details")
            {
                Caption = 'Additional Information';

                field("BLRCountry"; rec."BLRCountry")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the country where the property is located.';
                    // Lookup = true;
                }
                field("BLREmirate"; rec."BLREmirate Name")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the emirate where the property is located.';
                    // Lookup = true;
                }
                field("BLRCommunity"; rec."BLRCommunity")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Lookup = true;
                    ToolTip = 'Specifies the community where the property is located.';
                }

                field("Number of Units"; rec."BLRNumber of Units")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total number of units in the property.';
                }

                field("Property Classification"; rec."BLRProperty Classification")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the classification of the property based on its characteristics and usage.';
                    Lookup = true;
                }

                field("BLRPropertyType"; rec."BLRProperty Type")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Lookup = true;
                    ToolTip = 'Specifies the type of the property, such as residential, commercial, or industrial.';
                }


                field("Registration Date"; rec."BLRRegistration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the property was registered.';
                }

                field("GTIN"; rec."BLRGTIN")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Global Trade Item Number (GTIN) for the property, which is a unique identifier used in international trade.';
                }
                field("Owner ID"; rec."BLROwner ID")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Lookup = true;
                    ToolTip = 'Specifies the unique identifier for the owner of the property.';
                }
            }
            group(Documents)
            {

                // Add the Document Attachment Subpage here
                part("Document Attachments"; "BLRPropertyRegistrationSubPage")
                {
                    SubPageLink = BLRPropertyID = FIELD("BLRProperty ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = isVisible;
                }
            }

            group("WorkflowFrequencys")
            {
                Caption = 'List of Workflow Frequency';
                part("BLRWorkflowFrequency"; "BLRWorkflow Frequency PR Card")
                {
                    SubPageLink = "BLRCompany ID" = FIELD("BLRCompany ID"),
                    "BLRProperty ID" = FIELD("BLRProperty ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;

                }
            }


        }
    }


    var
        isVisible: Boolean;

    trigger OnModifyRecord(): Boolean
    begin
        CurrPage."Document Attachments".Page.SetPropertyId(Rec."BLRProperty ID");
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage."Document Attachments".Page.SetPropertyId(Rec."BLRProperty ID");
        isVisible := true;
    end;

    trigger OnAfterGetRecord()
    begin
        CurrPage."Document Attachments".Page.SetPropertyId(Rec."BLRProperty ID");

        if Rec."BLRProperty ID" <> '' then
            isVisible := true
        else
            isVisible := false;
    end;

    procedure InsertWorkflowFrquencyData()
    var
        workflowfrequency: Record "BLRWorkflowFrequency";
        workflowfrequencyPR: Record "BLRWorkflowFrequencyPR";
    begin
        workflowfrequencyPR.SetRange("BLRProperty ID", Rec."BLRProperty ID");
        workflowfrequencyPR.SetRange("BLRCompany ID", Rec."BLRCompany ID");

        if workflowfrequencyPR.FindSet() then
            workflowfrequencyPR.DeleteAll();


        if workflowfrequency.FindSet() then
            repeat
                workflowfrequencyPR.Init();

                workflowfrequencyPR."BLRProperty ID" := Rec."BLRProperty ID";
                workflowfrequencyPR."BLRCompany ID" := workflowfrequency."BLRCompany ID";
                workflowfrequencyPR."BLRWorkflow" := workflowfrequency."BLRWorkflow";
                workflowfrequencyPR."BLRfrequncy Status" := workflowfrequency."BLRfrequncy Status";
                workflowfrequencyPR."BLRNo. of Days" := workflowfrequency."BLRNo. of Days";
                workflowfrequencyPR.Insert();
                Clear(workflowfrequencyPR);
            until workflowfrequency.Next() = 0;
    end;
}

