page 73209738 "BLRSuspend Reason Card"
{
    PageType = Card;
    SourceTable = BLRSuspendReasonTable;
    ApplicationArea = All;
    Caption = 'Suspend Reason Card';
    UsageCategory = Administration;

    layout
    {
        area(content)
        {


            group("Tenancy Details")
            {
                Caption = 'Tenancy Details';

                field("Contract Type"; rec."BLRContract Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Type of contract for the tenancy.';
                    trigger OnValidate()
                    begin
                        UpdateFieldsEnable();
                    end;
                }

                field("Proposal ID"; Rec."BLRProposal ID")
                {
                    ApplicationArea = All;
                    Caption = 'Proposal ID';
                    Enabled = ProposalIDEnabled;
                    ToolTip = 'Identifier for the proposal associated with this tenancy.';
                }

                field("Renewal Proposal ID"; Rec."BLRRenewal Proposal ID")
                {
                    ApplicationArea = All;
                    Caption = 'Renewal Proposal ID';
                    Enabled = RenewalProposalIDEnabled;
                    ToolTip = 'Identifier for the renewal proposal associated with this tenancy.';
                }

                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'Identifier for the contract associated with this tenancy.';
                }

                field(TenantID; Rec.BLRTenantID)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Unique identifier for the tenant associated with this tenancy.';
                }

                field(TenantName; Rec.BLRTenantName)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Name of the tenant associated with this tenancy.';
                }

                field(EmiratesID; Rec.BLREmiratesID)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Emirates ID of the tenant associated with this tenancy.';
                }

                field(ContactNumber; Rec.BLRContactNumber)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Contact number of the tenant associated with this tenancy.';
                }

                field(EmailAddress; Rec.BLREmailAddress)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Email address of the tenant associated with this tenancy.';
                }

                field(TenantTradeLicenseNo; Rec.BLRTradeLicenseNo)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Trade license number of the tenant associated with this tenancy.';
                }

                field(TenantLicensingAuthority; Rec.BLRLicensingAuthority)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Licensing authority of the tenant associated with this tenancy.';
                }
            }
            group("General Information")
            {
                Caption = 'General Details';

                field(ID; Rec.BLRID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the suspend reason.';
                }

                field(DateEffective; Rec.BLRDateEffective)
                {
                    ApplicationArea = All;
                    ToolTip = 'Effective date of the suspension reason.';
                }

                field(SuspensionEndDate; Rec.BLRSuspensionEndDate)
                {
                    ApplicationArea = All;
                    ToolTip = 'End date of the suspension reason.';
                }

                field(Reason; Rec.BLRReason)
                {
                    ApplicationArea = All;
                    ToolTip = 'Reason for the suspension.';

                    trigger OnValidate()
                    begin
                        UpdateVisibility(); // Update visibility when Reason is changed
                    end;
                }

                field(Description; Rec.BLRDescription)
                {
                    ApplicationArea = All;
                    ToolTip = 'Description of the suspension reason.';
                }

                field("Tenant Contract Status"; Rec."BLRTenant Contract Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Status of the tenant contract associated with this suspension reason.';
                }

                field("ReleaseUnits"; Rec."BLRReleaseUnits")
                {
                    ApplicationArea = All;
                    ToolTip = 'Units to be released as part of the suspension reason.';
                }
            }



            group("Legal Reason Details")
            {
                Caption = 'Legal Reason Details';
                Visible = ShowLegalReasonFields;

                field(ReleaseUnit; Rec.BLRReleaseUnit)
                {
                    ApplicationArea = All;
                    Caption = 'Release Unit';
                    ToolTip = 'Unit to be released as part of the legal suspension reason.';
                }

                field(ReleaseDate; Rec.BLRReleaseDate)
                {
                    ApplicationArea = All;
                    Caption = 'Release Date';
                    ToolTip = 'Date when the unit is to be released as part of the legal suspension reason.';
                }
            }

            group("Business Reason Details")
            {
                Caption = 'Business Reason Details';
                Visible = ShowBusinessReasonFields;

                field(SuspensionEffectiveDate; Rec.BLRSuspensionEffectiveDate)
                {
                    ApplicationArea = All;
                    Caption = 'Effective Date of Suspension to Active';
                    ToolTip = 'Date when the suspension becomes effective for business reasons.';
                }

                field(IssueResolutionDescription; Rec.BLRIssueResolutionDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Issue Resolution Description';
                    ToolTip = 'Description of the issue resolution for the business suspension reason.';
                }
            }
        }

        area(factboxes)
        {
            systempart(ControlLinks; Links)
            {
                ApplicationArea = RecordLinks;
            }

            systempart(ControlNotes; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    var
        ShowLegalReasonFields: Boolean;
        ShowBusinessReasonFields: Boolean;

    // Initialize visibility when the page opens
    trigger OnOpenPage()
    begin
        UpdateVisibility();
    end;

    // Procedure to update visibility dynamically
    procedure UpdateVisibility()
    begin
        ShowLegalReasonFields := (Rec.BLRReason = Rec.BLRReason::"Legal Reason");
        ShowBusinessReasonFields := (Rec.BLRReason = Rec.BLRReason::"Business Reason");
    end;

    trigger OnAfterGetRecord()
    begin
        UpdateFieldsEnable();
    end;

    var
        ProposalIDEnabled: Boolean;
        RenewalProposalIDEnabled: Boolean;


    local procedure UpdateFieldsEnable()
    begin
        ProposalIDEnabled := Rec."BLRContract Type" = Rec."BLRContract Type"::"New Contract";
        RenewalProposalIDEnabled := Rec."BLRContract Type" = Rec."BLRContract Type"::"Renewal Contract";

        CurrPage.Update(false);
    end;
}
