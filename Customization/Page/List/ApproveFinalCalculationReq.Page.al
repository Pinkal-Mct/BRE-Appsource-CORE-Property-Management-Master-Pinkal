page 73209762 "BLRApprove FinalCalculationReq"
{
    PageType = List;
    SourceTable = "BLRApprovalFinalCalculation";
    ApplicationArea = All;
    Caption = 'Approval Final Calculation List';
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("ID"; Rec."BLRID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the approval final calculation.';
                }
                field("Status"; Rec."BLRStatus")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Current status of the approval final calculation.';
                }

                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the tenant associated with the approval final calculation.';
                }

                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the contract associated with the approval final calculation.';
                }

                field("FC ID"; Rec."BLRFC ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the final calculation associated with the approval.';
                }

                field("Link"; Rec."BLRLink")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    ToolTip = 'Link to the final calculation record.';


                    trigger OnDrillDown()
                    var
                        FinalCalculation: Record "BLRFinalCalculation";
                    begin

                        // Navigate to the Revenue Structure Card page
                        if FinalCalculation.Get(Rec."BLRLink") then
                            PAGE.RUN(PAGE::"BLRFinalCalculationCard", FinalCalculation)
                        else
                            Message('The related Revenue Structure does not exist.')
                    end;

                }

                field("Contract Start Date"; Rec."BLRContract Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Start date of the contract associated with the approval final calculation.';
                }

                field("Contract End Date"; Rec."BLRContract End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'End date of the contract associated with the approval final calculation.';
                }

                field("Termination Date"; Rec."BLRTermination Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Date when the contract associated with the approval final calculation was terminated.';
                }

                field("Contract Amount"; Rec."BLRContract Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Total amount of the contract associated with the approval final calculation.';
                }





            }
        }
    }


    actions
    {
        area(Processing)
        {
#pragma warning disable AW0011
            action(Approve)
#pragma warning restore AW0011
            {
                ApplicationArea = All;
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsFinanceManager;
                ToolTip = 'Approve the selected final calculation entry.';


                trigger OnAction()
                var
                    FinalCalculation: Record "BLRFinalCalculation";
                begin
                    if Rec.BLRStatus = Rec.BLRStatus::Approved then
                        Error('This entry is already approved');

                    if Confirm('Do you want to approve this entry?') then begin
                        // Update entry status
                        Rec.BLRStatus := Rec.BLRStatus::Approved;
                        Rec.Modify();

                        FinalCalculation.SetRange("BLRContract ID", Rec."BLRContract ID");
                        if FinalCalculation.FindFirst() then begin

                            FinalCalculation.BLRStatus := FinalCalculation.BLRStatus::Approved;
                            FinalCalculation.Modify();
                        end;

                        Message('Entry has been approved successfully!');
                    end;
                end;
            }
            action(Reject)
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Image = Cancel;
                Visible = IsFinanceManager;
                ToolTip = 'Click to reject the selected record. This action is available only to Finance Managers.';

                trigger OnAction()
                var
                    FinalCalculation: Record "BLRFinalCalculation";
                begin
                    if Rec.BLRStatus = Rec.BLRStatus::Rejected then
                        Error('This entry is already rejected');

                    if Confirm('Do you want to reject this entry?') then begin
                        // Update entry status
                        Rec.BLRStatus := Rec.BLRStatus::Rejected;
                        Rec.Modify();

                        FinalCalculation.SetRange("BLRContract ID", Rec."BLRContract ID");
                        if FinalCalculation.FindFirst() then begin
                            FinalCalculation.BLRStatus := FinalCalculation.BLRStatus::Rejected;
                            FinalCalculation.Modify();
                        end;

                        Message('Entry has been rejected.');
                    end;
                end;
            }
        }
    }


    trigger OnOpenPage()
    var

    begin
        // Check if the current user has the 'LEASE MANAGER' permission set

        IsFinanceManager := VisibleApproveAction();
    end;

    procedure VisibleApproveAction(): Boolean
    var
        UserPersonalization: Record "User Personalization";
    begin

        if UserPersonalization.Get(UserSecurityId()) then
            case UserPersonalization."Profile ID" of
                'PROPERTY MANAGER':
                    exit(false);
                'LEASE MANAGER':
                    exit(false);
                'FINANCE MANAGER':
                    exit(true);
            end;


        exit(false);
    end;

    var
        IsFinanceManager: Boolean;

}