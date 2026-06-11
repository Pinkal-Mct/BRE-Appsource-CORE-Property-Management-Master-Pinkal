codeunit 73209622 "BLRUpdateManagement Fee Status"
{


    trigger OnRun()
    begin
        UpdateContractStatus();
    end;

    local procedure UpdateContractStatus()
    var
        MgmtFeeLine: Record "BLRManagementFeeGrid";
        TodayDate: Date;
    begin
        TodayDate := Today;

        MgmtFeeLine.Reset();

        if MgmtFeeLine.FindSet() then
            repeat
                if (MgmtFeeLine."BLRValid From" <= TodayDate) and
                   (MgmtFeeLine."BLRValid To" >= TodayDate) then begin

                    if MgmtFeeLine."BLRContract Status" <>
                       MgmtFeeLine."BLRContract Status"::Active then begin
                        MgmtFeeLine."BLRContract Status" :=
                            MgmtFeeLine."BLRContract Status"::Active;
                        MgmtFeeLine.Modify();
                    end;

                end else

                    if MgmtFeeLine."BLRContract Status" <>
                       MgmtFeeLine."BLRContract Status"::Expired then begin
                        MgmtFeeLine."BLRContract Status" :=
                            MgmtFeeLine."BLRContract Status"::Expired;
                        MgmtFeeLine.Modify();
                    end;


            until MgmtFeeLine.Next() = 0;
    end;
}
