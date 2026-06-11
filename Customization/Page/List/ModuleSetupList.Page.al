page 73209785 "BLRModule Setup List"
{
    PageType = List;
    ApplicationArea = All;
    SourceTable = "BLRModuleSetup";
    Caption = 'Module Setup List';

    UsageCategory = Lists;

    layout
    {
        area(Content)
        {


            repeater(General)
            {



                field("Extension Name"; Rec."BLRExtension Name")
                {
                    Caption = 'Module Name';
                    ApplicationArea = All;
                    ToolTip = 'Name of the module or extension.';
                }
                field("Is Active"; Rec."BLRIs Active")
                {
                    Caption = 'Is Active';
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether the module or extension is currently active.';
                }

            }
        }
    }




    trigger OnOpenPage()
    var
        ModuleSetupRec: Record "BLRModuleSetup";
    begin
        // Check if the record exists using the primary key
        if not ModuleSetupRec.Get('SETUP') then begin
            ModuleSetupRec.Init();
            ModuleSetupRec."BLRModule Name" := 'SETUP'; // Assign the primary key
            ModuleSetupRec.Insert();
        end;
    end;

}