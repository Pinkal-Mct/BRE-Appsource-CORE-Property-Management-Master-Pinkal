page 73209675 "BLRBrokerage Calculation Card"
{
    PageType = Card;
    SourceTable = "BLRBrokerageCalculation";
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
                field("ID"; Rec."BLRID")
                {
                    ToolTip = 'The unique identifier for the brokerage calculation.';
                    ApplicationArea = All;
                }
                field("Owner ID"; Rec."BLROwner ID")
                {
                    ToolTip = 'The unique identifier for the owner associated with the brokerage calculation.';
                    ApplicationArea = All;
                }
                field("Property ID"; Rec."BLRProperty ID")
                {
                    ToolTip = 'The unique identifier for the property associated with the brokerage calculation.';
                    ApplicationArea = All;
                }
                field("Start Date"; Rec."BLRStart Date")
                {
                    ToolTip = 'The start date of the brokerage calculation period.';
                    ApplicationArea = All;
                }
                field("End Date"; Rec."BLREnd Date")
                {
                    ToolTip = 'The end date of the brokerage calculation period.';
                    ApplicationArea = All;
                }
            }
            group("BLRBrokerageCalculation")
            {
                Caption = 'Brokerage Calculation';
                part("Brokerage Calculations"; "BLRBrokerageCalculationSubCard")
                {
                    SubPageLink = "BLRID" = FIELD("BLRID");
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
                    MasterDataRec: Record "BLRBrokerageMasterData";
                    SubDetailRec: Record "BLRBrokerageCalculationSub";
                    CalcHeaderRec: Record "BLRBrokerageCalculation";
                    CardStartDate: Date;
                    CardEndDate: Date;
                begin
                    if Rec."BLROwner ID" = 0 then
                        Error('Owner Name is required.');
                    if Rec."BLRProperty ID" = '' then
                        Error('Property ID is required.');
                    SubDetailRec.Reset();
                    SubDetailRec.SetRange("BLRProperty ID", Rec."BLRProperty ID");
                    if SubDetailRec.FindFirst() then
                        SubDetailRec.DeleteAll();
                    CalcHeaderRec.Get(Rec."BLRID");
                    begin
                        CardStartDate := CalcHeaderRec."BLRStart Date";
                        CardEndDate := CalcHeaderRec."BLREnd Date";
                    end;
                    MasterDataRec.Reset();
                    MasterDataRec.SetRange("BLRProperty ID", Rec."BLRProperty ID");
                    MasterDataRec.SetRange("BLROwner ID", Rec."BLROwner ID");
                    if MasterDataRec.FindSet() then begin
                        repeat
                            if not (
                   (MasterDataRec."BLREnd Date" < CardStartDate) or
                   (MasterDataRec."BLRStart Date" > CardEndDate)
               ) then begin
                                SubDetailRec.Init();
                                SubDetailRec.Reset();
                                if SubDetailRec.FindLast() then
                                    SubDetailRec."BLREntry No." := SubDetailRec."BLREntry No." + 1
                                else
                                    SubDetailRec."BLREntry No." := 1;
                                SubDetailRec."BLRID" := Rec."BLRID";
                                SubDetailRec."BLROwner ID" := MasterDataRec."BLROwner ID";
                                SubDetailRec."BLRVendor ID" := MasterDataRec."BLRVendor ID";
                                SubDetailRec."BLRStart Date" := MasterDataRec."BLRStart Date";
                                SubDetailRec."BLREnd Date" := MasterDataRec."BLREnd Date";
                                SubDetailRec."BLRProperty ID" := MasterDataRec."BLRProperty ID";
                                SubDetailRec."BLRContract ID" := MasterDataRec."BLRContract ID";
                                SubDetailRec."BLRTenant Name" := COPYSTR(MasterDataRec."BLRTenant Name", 1, StrLen(MasterDataRec."BLRTenant Name"));
                                SubDetailRec."BLRProperty Name" := CopyStr(MasterDataRec."BLRProperty Name", 1, StrLen(MasterDataRec."BLRProperty Name"));
                                SubDetailRec."BLRUnit Number" := CopyStr(MasterDataRec."BLRUnit Number", 1, StrLen(MasterDataRec."BLRUnit Number"));
                                SubDetailRec."BLRUnit Name" := CopyStr(MasterDataRec."BLRUnit Number", 1, StrLen(MasterDataRec."BLRUnit Name"));
                                SubDetailRec."BLRVendor Name" := COPYSTR(MasterDataRec."BLRVendor Name", 1, StrLen(MasterDataRec."BLRVendor Name"));
                                SubDetailRec."BLRBrokerage Percentage" := MasterDataRec."BLRPercentage";
                                SubDetailRec."BLRBrokerage Amount" := MasterDataRec."BLRAmount";
                                SubDetailRec."BLROwner Name" := CopyStr(MasterDataRec."BLROwner Name", 1, StrLen(MasterDataRec."BLROwner Name"));
                                SubDetailRec."BLRCalculation Method" := MasterDataRec."BLRCalculation Method";
                                SubDetailRec."BLRBase Amount Type" := MasterDataRec."BLRBase Amount Type";
                                SubDetailRec."BLRBase Amount" := MasterDataRec."BLRBase Amount";
                                SubDetailRec."BLRAmount" := MasterDataRec."BLRAmount";
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
