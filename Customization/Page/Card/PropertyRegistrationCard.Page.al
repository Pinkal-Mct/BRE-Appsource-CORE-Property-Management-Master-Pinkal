page 73209717 "Property Registration Card"
{
    PageType = Card;
    SourceTable = "Property Registration";
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


                field("Property ID"; rec."Property ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the property.';
                }
                field("Property Name"; rec."Property Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the property.';

                    trigger OnValidate()
                    begin
                        InsertWorkflowFrquencyData();
                    end;
                }
                field("Company ID"; rec."Company ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the company associated with the property.';

                    trigger OnValidate()
                    begin
                        InsertWorkflowFrquencyData();
                    end;
                }



                field("Base Unit of Measure"; rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the base unit of measure for the property.';

                    trigger OnValidate()
                    begin
                        InsertWorkflowFrquencyData();
                    end;
                }
                field("Property Size"; rec."Property Size")
                {
                    ApplicationArea = All;
                    Caption = 'Property Size';
                    Editable = true;
                    ToolTip = 'Specifies the size of the property in square feet or square meters.';
                }

                field("Market Rate per Sq. Ft."; rec."Market Rate per Sq. Ft.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the market rate per square foot for the property.';
                }

                field("Address"; Rec."Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the address of the property.';
                }
                field("Built-up Area"; Rec."Built-up Area")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the built-up area of the property in square feet or square meters.';
                }
                field("Makani Number"; Rec."Makani Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Makani number for the property, which is a unique identifier for properties in Dubai.';
                }
                field("Municipality Number"; Rec."Municipality Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the municipality number for the property, which is used for official identification.';
                }
                field("DEWA Number"; Rec."DEWA Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the DEWA number for the property, which is a unique identifier for properties in Dubai.';
                }
                field("Number of Floors"; Rec."Number of Floors")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total number of floors in the property.';
                }
                field("Number of Lifts"; Rec."Number of Lifts")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total number of lifts in the property.';
                }

            }


            group("Additional Details")
            {
                Caption = 'Additional Information';

                field("Country"; rec."Country")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the country where the property is located.';
                    // Lookup = true;
                }
                field("Emirate"; rec."Emirate Name")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the emirate where the property is located.';
                    // Lookup = true;
                }
                field("Community"; rec."Community")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Lookup = true;
                    ToolTip = 'Specifies the community where the property is located.';
                }

                field("Number of Units"; rec."Number of Units")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total number of units in the property.';
                }

                field("Property Classification"; rec."Property Classification")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the classification of the property based on its characteristics and usage.';
                    Lookup = true;
                }

                field("Property Type"; rec."Property Type")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    Lookup = true;
                    ToolTip = 'Specifies the type of the property, such as residential, commercial, or industrial.';
                }


                field("Registration Date"; rec."Registration Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the property was registered.';
                }

                field("GTIN"; rec."GTIN")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Global Trade Item Number (GTIN) for the property, which is a unique identifier used in international trade.';
                }
                field("Owner ID"; rec."Owner ID")
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
                part("Document Attachments"; "Property Registration SubPage")
                {
                    SubPageLink = PropertyID = FIELD("Property ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = isVisible;
                }
            }

            group("WorkflowFrequencys")
            {
                Caption = 'List of Workflow Frequency';
                part("Workflow Frequency"; "Workflow Frequency PR Card")
                {
                    SubPageLink = "Company ID" = FIELD("Company ID"),
                    "Property ID" = FIELD("Property ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;

                }
            }


        }
    }


    var
        isVisible: Boolean;

    trigger OnModifyRecord(): Boolean
    begin
        CurrPage."Document Attachments".Page.SetPropertyId(Rec."Property ID");
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage."Document Attachments".Page.SetPropertyId(Rec."Property ID");
        isVisible := true;
    end;

    trigger OnAfterGetRecord()
    begin
        CurrPage."Document Attachments".Page.SetPropertyId(Rec."Property ID");

        if Rec."Property ID" <> '' then
            isVisible := true
        else
            isVisible := false;
    end;

    procedure InsertWorkflowFrquencyData()
    var
        workflowfrequency: Record "Workflow Frequency";
        workflowfrequencyPR: Record "Workflow Frequency PR";
    begin
        workflowfrequencyPR.SetRange("Property ID", Rec."Property ID");
        workflowfrequencyPR.SetRange("Company ID", Rec."Company ID");

        if workflowfrequencyPR.FindSet() then
            workflowfrequencyPR.DeleteAll();


        if workflowfrequency.FindSet() then
            repeat
                workflowfrequencyPR.Init();

                workflowfrequencyPR."Property ID" := Rec."Property ID";
                workflowfrequencyPR."Company ID" := workflowfrequency."Company ID";
                workflowfrequencyPR.Workflow := workflowfrequency.Workflow;
                workflowfrequencyPR."frequncy Status" := workflowfrequency."frequncy Status";
                workflowfrequencyPR."No. of Days" := workflowfrequency."No. of Days";
                workflowfrequencyPR.Insert();
                Clear(workflowfrequencyPR);
            until workflowfrequency.Next() = 0;
    end;
}

