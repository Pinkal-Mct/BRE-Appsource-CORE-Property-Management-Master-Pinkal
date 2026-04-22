page 73209675 "Brokerage Calculation Card"
{
    PageType = Card;
    SourceTable = "Brokerage Calculation";
    ApplicationArea = All;
    Caption = 'Brokerage Calculation Card';
    UsageCategory = Administration;
    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'Brokerage Calculation Details';
                field("ID"; Rec."ID")
                {
                    ToolTip = 'The unique identifier for the brokerage calculation.';
                    ApplicationArea = All;
                }
                field("Owner ID"; Rec."Owner ID")
                {
                    ToolTip = 'The unique identifier for the owner associated with the brokerage calculation.';
                    ApplicationArea = All;
                }
                field("Property ID"; Rec."Property ID")
                {
                    ToolTip = 'The unique identifier for the property associated with the brokerage calculation.';
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."Start Date")
                {
                    ToolTip = 'The start date of the brokerage calculation period.';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."End Date")
                {
                    ToolTip = 'The end date of the brokerage calculation period.';
                    ApplicationArea = All;
                }
            }
            group("Brokerage Calculation")
            {
                Caption = 'Brokerage Calculation';
                part("Brokerage Calculations"; "Brokerage Calculation Sub Card")
                {
                    SubPageLink = "ID" = FIELD("ID");
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action(SelectVendor)
            {
                ToolTip = 'Select Vendor for Brokerage Calculation';
                Caption = 'Brokerage Calculation';
                Image = Find;
                ApplicationArea = All;
                trigger OnAction()
                var
                    MasterDataRec: Record "Brokerage Master Data";
                    SubDetailRec: Record "Brokerage Calculation Sub";
                    CalcHeaderRec: Record "Brokerage Calculation";
                    CardStartDate: Date;
                    CardEndDate: Date;
                begin
                    if Rec."Owner ID" = 0 then
                        Error('Owner Name is required.');
                    if Rec."Property ID" = '' then
                        Error('Property ID is required.');
                    SubDetailRec.Reset();
                    SubDetailRec.SetRange("Property ID", Rec."Property ID");
                    if SubDetailRec.FindFirst() then
                        SubDetailRec.DeleteAll();
                    CalcHeaderRec.Get(Rec.ID);
                    begin
                        CardStartDate := CalcHeaderRec."Start Date";
                        CardEndDate := CalcHeaderRec."End Date";
                    end;
                    MasterDataRec.Reset();
                    MasterDataRec.SetRange("Property ID", Rec."Property ID");
                    MasterDataRec.SetRange("Owner ID", Rec."Owner ID");
                    if MasterDataRec.FindSet() then begin
                        repeat
                            if not (
                   (MasterDataRec."End Date" < CardStartDate) or
                   (MasterDataRec."Start Date" > CardEndDate)
               ) then begin
                                SubDetailRec.Init();
                                SubDetailRec.Reset();
                                if SubDetailRec.FindLast() then
                                    SubDetailRec."Entry No." := SubDetailRec."Entry No." + 1
                                else
                                    SubDetailRec."Entry No." := 1;
                                SubDetailRec.ID := Rec.ID;
                                SubDetailRec."Owner ID" := MasterDataRec."Owner ID";
                                SubDetailRec."Vendor ID" := MasterDataRec."Vendor ID";
                                SubDetailRec."Start Date" := MasterDataRec."Start Date";
                                SubDetailRec."End Date" := MasterDataRec."End Date";
                                SubDetailRec."Property ID" := MasterDataRec."Property ID";
                                SubDetailRec."Contract ID" := MasterDataRec."Contract ID";
                                SubDetailRec."Tenant Name" := COPYSTR(MasterDataRec."Tenant Name", 1, StrLen(MasterDataRec."Tenant Name"));
                                SubDetailRec."Property Name" := CopyStr(MasterDataRec."Property Name", 1, StrLen(MasterDataRec."Property Name"));
                                SubDetailRec."Unit Number" := CopyStr(MasterDataRec."Unit Number", 1, StrLen(MasterDataRec."Unit Number"));
                                SubDetailRec."Unit Name" := CopyStr(MasterDataRec."Unit Number", 1, StrLen(MasterDataRec."Unit Name"));
                                SubDetailRec."Vendor Name" := COPYSTR(MasterDataRec."Vendor Name", 1, StrLen(MasterDataRec."Vendor Name"));
                                SubDetailRec."Brokerage Percentage" := MasterDataRec.Percentage;
                                SubDetailRec."Brokerage Amount" := MasterDataRec."Amount";
                                SubDetailRec."Owner Name" := CopyStr(MasterDataRec."Owner Name", 1, StrLen(MasterDataRec."Owner Name"));
                                SubDetailRec."Calculation Method" := MasterDataRec."Calculation Method";
                                SubDetailRec."Base Amount Type" := MasterDataRec."Base Amount Type";
                                SubDetailRec."Base Amount" := MasterDataRec."Base Amount";
                                SubDetailRec."Amount" := MasterDataRec.Amount;
                                SubDetailRec.Insert(true);
                            end;
                        until MasterDataRec.Next() = 0;
                        CurrPage.Update();
                        Message('Matching brokerage data inserted.');
                    end else
                        Message('No matching data found in master for selected Owner and Property.');
                end;
            }
        }
    }
}
