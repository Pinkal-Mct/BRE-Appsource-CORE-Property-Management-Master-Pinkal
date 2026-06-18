pageextension 73209584 BLRPropertyRegistrationCardExt extends "BLRProperty Registration Card"
{
    layout
    {
        modify("Documents") // Ensure this matches the group/control name
        {
            Visible = ShowDocAttachment;
        }
    }

    trigger OnOpenPage()
    begin
        ShowDocAttachment := not (BLRIsUserInProfile('LEASE MANAGER') or BLRIsUserInProfile('FINANCE MANAGER'));
    end;

    var
        ShowDocAttachment: Boolean;

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
