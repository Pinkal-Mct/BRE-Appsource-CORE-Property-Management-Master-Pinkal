pageextension 73209580 OwnerProfileCardExt extends "Owner Profile Card"
{

    layout
    {
        modify("Banking Information")
        {
            Visible = ShowBankingInfo;
        }
        modify("TRN")
        {
            Visible = ShowBankingInfo;
        }
        modify("Document Attachments")
        {
            Visible = ShowOwnerDocs;
        }
    }

    trigger OnOpenPage()
    begin
        ShowBankingInfo := not (IsUserInProfile('LEASE MANAGER') or IsUserInProfile('PROPERTY MANAGER'));
        ShowOwnerDocs := not IsUserInProfile('LEASE MANAGER');
    end;

    var
        ShowBankingInfo: Boolean;
        ShowOwnerDocs: Boolean;

    local procedure IsUserInProfile(ProfileID: Code[20]): Boolean
    var
        AccessControl: Record "User Personalization";
    begin
        AccessControl.SetRange("User ID", UserId());
        AccessControl.SetRange("Profile ID", ProfileID);
        // exit(AccessControl.FindFirst());
        exit(not AccessControl.IsEmpty());
    end;
}
