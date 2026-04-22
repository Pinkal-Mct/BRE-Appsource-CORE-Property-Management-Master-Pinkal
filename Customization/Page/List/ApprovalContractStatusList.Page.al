page 73209760 "Approval Contract Status List"
{
    PageType = List;
    SourceTable = "Approval Contract Status";
    ApplicationArea = All;
    Caption = 'Approval Request Contract Status List';
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
                    ToolTip = 'Unique identifier for the approval request.';
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Current status of the approval request.';
                }
                field("Contract ID"; Rec."Contract ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Identifier for the associated tenancy contract.';

                    // DrillDown trigger to navigate to the Tenancy Contract Card
                    trigger OnDrillDown()
                    var
                        TenancyContractRec: Record "Tenancy Contract"; // Replace with the correct table name for Tenancy Contract
                    begin
                        // Debugging: Log the Contract ID value
                        Message('Checking Contract ID: %1', Rec."Contract ID");

                        // Use SetRange and FindFirst to locate the record
                        TenancyContractRec.SetRange("Contract ID", Rec."Contract ID");

                        if TenancyContractRec.FindFirst() then
                            // Record found, open the Tenancy Contract Card page
                            PAGE.Run(PAGE::"Tenancy Contract Card", TenancyContractRec) // Replace with the correct card page ID or name
                        else
                            // Record not found
                            Message('The selected Contract ID (%1) does not exist in the Tenancy Contract table.', Rec."Contract ID");

                    end;
                }

                field("Renewal Contract ID"; Rec."Renewal Contract ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Identifier for the associated renewal contract.';

                    trigger OnDrillDown()
                    var
                        RenewalContractRec: Record "Contract Renewal"; // Replace with the correct table name for Contract Renewal
                    begin
                        // Debugging: Log the Renewal Contract ID value
                        Message('Checking Renewal Contract ID: %1', Rec."Renewal Contract ID");

                        // Use SetRange and FindFirst to locate the record
                        RenewalContractRec.SetRange("ID", Rec."Renewal Contract ID");

                        if RenewalContractRec.FindFirst() then
                            // Record found, open the Contract Renewal Card page
                            PAGE.Run(PAGE::"Contract Renewal Card", RenewalContractRec) // Replace with the correct card page ID or name
                        else
                            // Record not found
                            Message('The selected Contract Renewal ID (%1) does not exist in the Contract Renewal table.', Rec."Renewal Contract ID");

                    end;
                }

                field("Lease ID"; Rec."Lease ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Identifier for the associated lease.';
                }
                field("Tenancy Contract Status"; Rec."Tenancy Contract Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Status of the associated tenancy contract.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Approve)
            {
                Caption = 'Approve';
                ApplicationArea = All;
                Image = Approve;
                Visible = IsPropertyManager; // Button visible only for Property Manager
                ToolTip = 'Approve the selected contract status request.';

                trigger OnAction()
                var
                    SelectedRec: Record "Approval Contract Status";
                    StatusUpdateCU: Codeunit "Contract Status Synchronizer";
                    ContractRenewal: Codeunit "Contract Renewal Response";
                begin
                    if Rec.Status = 'Pending' then begin
                        SelectedRec := Rec;
                        SelectedRec.Status := 'Approved';
                        SelectedRec.Modify();
                        StatusUpdateCU.SyncToTenancyContract(SelectedRec); // ✅
                        ContractRenewal.SyncToTenancyContractRenewal(SelectedRec);


                        Message('Request Approved Successfully');
                        Commit();
                        CurrPage.Update();

                    end else
                        Message('Selected record is not in "Pending" status.');
                end;
            }

            action(Reject)
            {
                Caption = 'Reject';
                ApplicationArea = All;
                Image = Reject;
                Visible = IsPropertyManager; // Button visible only for Property Manager
                ToolTip = 'Reject the selected contract status request.';

                trigger OnAction()
                var
                    SelectedRec: Record "Approval Contract Status";
                    StatusUpdateCU: Codeunit "Contract Status Synchronizer";
                    ContractRenewal: Codeunit "Contract Renewal Response";
                begin
                    if Rec.Status = 'Pending' then begin
                        SelectedRec := Rec;
                        SelectedRec.Status := 'Declined';
                        SelectedRec.Modify();

                        Commit();
                        CurrPage.Update();
                        StatusUpdateCU.SyncToTenancyContract(SelectedRec); // ✅
                        ContractRenewal.SyncToTenancyContractRenewal(SelectedRec);

                    end else
                        Message('Selected record is not in "Pending" status.');
                end;
            }
        }

        area(navigation)
        {
            action("Open Tenancy Contract")
            {
                Caption = 'Open Tenancy Contract';
                ApplicationArea = All;
                Image = Open;
                ToolTip = 'Open the associated tenancy contract card.';

                trigger OnAction()
                var
                    TenancyContractRec: Record "Tenancy Contract"; // Replace with the correct table name for Tenancy Contract
                begin
                    // Debugging: Log the Contract ID value
                    Message('Checking Contract ID: %1', Rec."Contract ID");

                    // Use SetRange and FindFirst to locate the record
                    TenancyContractRec.SetRange("Contract ID", Rec."Contract ID");

                    if TenancyContractRec.FindFirst() then
                        // Record found, open the Tenancy Contract Card page
                        PAGE.Run(PAGE::"Tenancy Contract Card", TenancyContractRec) // Replace with the correct card page ID or name
                    else
                        // Record not found
                        Message('The selected Contract ID (%1) does not exist in the Tenancy Contract table.', Rec."Contract ID");

                end;
            }

            action("Open Renewal Contract")
            {
                Caption = 'Open Renewal Contract';
                ApplicationArea = All;
                Image = Open;
                ToolTip = 'Open the associated renewal contract card.';


                trigger OnAction()
                var
                    RenewalContractRec: Record "Contract Renewal"; // Replace with the correct table name for the Renewal Contract
                begin
                    // Debugging: Log the Renewal Contract ID value
                    Message('Checking Renewal Contract ID: %1', Rec."Renewal Contract ID");

                    // Use SetRange and FindFirst to locate the record
                    RenewalContractRec.SetRange("ID", Rec."Renewal Contract ID");

                    if RenewalContractRec.FindFirst() then
                        // Record found, open the Renewal Contract Card page
                        PAGE.Run(PAGE::"Contract Renewal Card", RenewalContractRec) // Replace with the correct card page ID or name
                    else
                        // Record not found
                        Message('The selected Renewal Contract ID (%1) does not exist in the Contract Renewal table.', Rec."Renewal Contract ID");

                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        IsPropertyManager := CheckUserRole();
    end;

    procedure CheckUserRole(): Boolean
    var
        UserPersonalization: Record "User Personalization";
    begin
        if UserPersonalization.Get(UserSecurityId()) then
            case UserPersonalization."Profile ID" of
                'PROPERTY MANAGER':
                    exit(true);  // Only property managers can approve/reject
                else
                    exit(false);
            end;

        exit(false);
    end;

    var
        IsPropertyManager: Boolean;
}

