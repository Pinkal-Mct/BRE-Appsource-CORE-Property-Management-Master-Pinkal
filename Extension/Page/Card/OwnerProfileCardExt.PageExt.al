pageextension 73209580 BLROwnerProfileCardExt extends "BLROwner Profile Card"
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
        ShowBankingInfo := not (BLRIsUserInProfile('LEASE MANAGER') or BLRIsUserInProfile('PROPERTY MANAGER'));
        ShowOwnerDocs := not BLRIsUserInProfile('LEASE MANAGER');
    end;

    var
        ShowBankingInfo: Boolean;
        ShowOwnerDocs: Boolean;

    local procedure BLRIsUserInProfile(ProfileID: Code[20]): Boolean
    var
        AccessControl: Record "User Personalization";
    begin
        AccessControl.SetRange("User ID", UserId());
        AccessControl.SetRange("Profile ID", ProfileID);
        // exit(AccessControl.FindFirst());
        exit(not AccessControl.IsEmpty());
    end;
}
