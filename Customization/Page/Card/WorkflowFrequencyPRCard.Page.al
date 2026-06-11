page 73209750 "BLRWorkflow Frequency PR Card"
{
    PageType = ListPart;
    SourceTable = "BLRWorkflowFrequencyPR";
    ApplicationArea = All;
    Caption = 'Workflow Frequency PR Card';

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Company ID"; Rec."BLRCompany ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Visible = false;
                    ToolTip = 'Enter the Company ID.';
                }

                field("Workflow"; Rec."BLRWorkflow")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the Workflow.';
                }
                field("frequncy Status"; Rec."BLRfrequncy Status")
                {
                    ApplicationArea = All;
                    Caption = 'frequncy Status';
                    Editable = false;
                    ToolTip = 'Enter the Frequency Status.';

                    trigger OnValidate()
                    begin
                        // If "Property" is selected, allow editing "No of Days", otherwise disable it
                        if Rec."BLRfrequncy Status" = Rec."BLRfrequncy Status"::Property then
                            IsApproved := true
                        else
                            IsApproved := false;
                    end;
                }

                field("No. of Days"; Rec."BLRNo. of Days")
                {
                    ApplicationArea = All;
                    Editable = IsApproved;
                    ToolTip = 'Enter the Number of Days.';
                }

                field("Property ID"; Rec."BLRProperty ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Visible = false;
                    ToolTip = 'Enter the Property ID.';
                }
            }
        }
    }

    var
        IsApproved: Boolean;

    trigger OnAfterGetRecord()
    begin
        if Rec."BLRfrequncy Status" = Rec."BLRfrequncy Status"::Property then
            IsApproved := true
        else
            IsApproved := false;
    end;
}