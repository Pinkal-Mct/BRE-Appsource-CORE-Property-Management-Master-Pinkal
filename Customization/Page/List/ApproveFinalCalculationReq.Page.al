page 50916 "Approve FinalCalculation Req"
{
    PageType = List;
    SourceTable = "Approval Final Calculation";
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
                field("ID"; Rec."ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the approval final calculation.';
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Current status of the approval final calculation.';
                }

                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the tenant associated with the approval final calculation.';
                }

                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the contract associated with the approval final calculation.';
                }

                field("FC ID"; Rec."FC ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the final calculation associated with the approval.';
                }

                field("Link"; Rec."Link")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    ToolTip = 'Link to the final calculation record.';


                    trigger OnDrillDown()
                    var
                        FinalCalculation: Record "Final Calculation";
                    begin

                        // Navigate to the Revenue Structure Card page
                        if FinalCalculation.Get(Rec."Link") then
                            PAGE.RUN(PAGE::"Final Calculation Card", FinalCalculation)
                        else
                            Message('The related Revenue Structure does not exist.')
                    end;

                }

                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Start date of the contract associated with the approval final calculation.';
                }

                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'End date of the contract associated with the approval final calculation.';
                }

                field("Termination Date"; Rec."Termination Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Date when the contract associated with the approval final calculation was terminated.';
                }

                field("Contract Amount"; Rec."Contract Amount")
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
                    FinalCalculation: Record "Final Calculation";
                begin
                    if Rec.Status = Rec.Status::Approved then
                        Error('This entry is already approved');

                    if Confirm('Do you want to approve this entry?') then begin
                        // Update entry status
                        Rec.Status := Rec.Status::Approved;
                        Rec.Modify();

                        FinalCalculation.SetRange("Contract ID", Rec."Contract ID");
                        if FinalCalculation.FindFirst() then begin

                            FinalCalculation.Status := FinalCalculation.Status::Approved;
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
                    FinalCalculation: Record "Final Calculation";
                begin
                    if Rec.Status = Rec.Status::Rejected then
                        Error('This entry is already rejected');

                    if Confirm('Do you want to reject this entry?') then begin
                        // Update entry status
                        Rec.Status := Rec.Status::Rejected;
                        Rec.Modify();

                        FinalCalculation.SetRange("Contract ID", Rec."Contract ID");
                        if FinalCalculation.FindFirst() then begin
                            FinalCalculation.Status := FinalCalculation.Status::Rejected;
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
        // Check if the current user has the 'LEASE_MANAGER' permission set

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
                'LEASE_MANAGER':
                    exit(false);
                'finance manager':
                    exit(true);
            end;


        exit(false);
    end;

    var
        IsFinanceManager: Boolean;

}