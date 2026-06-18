pageextension 73209579 BLRCustomers extends "Customer Card"
{
    layout
    {
        modify("Balance (LCY)")
        {
            Visible = false;
        }
        modify(BalanceAsVendor)
        {
            Visible = false;
        }
        modify("salesperson code")
        {
            Visible = false;
        }
        modify("Service Zone Code")
        {
            Visible = false;
        }
        modify("Document Sending Profile")
        {
            Visible = false;
        }
        modify("Disable Search by Name")
        {
            Visible = false;
        }
        modify("Balance Due (LCY)")
        {
            Visible = false;
        }
        modify("Credit Limit (LCY)")
        {
            Visible = false;
        }
        modify(Blocked)
        {
            Visible = false;
        }
        modify(TotalSales2)
        {
            Visible = false;
        }
        modify(Payments)
        {
            Visible = false;
        }
        modify(Shipping)
        {
            Visible = false;
        }
        modify("Intrastat Partner Type")
        {
            Visible = false;
        }
        modify(Statistics)
        {
            Visible = false;
        }
        modify("IC Partner Code")
        {
            Visible = false;
        }
        modify("Privacy Blocked")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Country/Region Code")
        {
            Visible = false;
        }
        modify(City)
        {
            Visible = false;
        }
        modify("Post Code")
        {
            Visible = false;
        }
        modify("Fax No.")
        {
            Visible = false;
        }
        modify("Home Page")
        {
            Visible = false;
        }
        modify("Language Code")
        {
            Visible = false;
        }
        modify("Format Region")
        {
            Visible = false;
        }
        modify(ContactDetails)
        {
            Visible = false;
        }
        modify("No.")
        {
            Caption = 'Tenant ID';
            Editable = false;
        }
        modify(Name)
        {
            Caption = 'Full Name';
        }
        modify("Phone No.")
        {
            Caption = 'Contact Number';
        }
        modify(MobilePhoneNo)
        {
            Caption = 'Emergency Contact';
        }
        modify("E-Mail")
        {
            Caption = 'Email Address';
        }
        modify(Address)
        {
            Caption = 'Local Address';
        }
        modify("Address 2")
        {
            Caption = 'Mailing Address';
        }
        modify(ShowMap)
        {
            Visible = false;
        }
        modify(AddressDetails)
        {
            Caption = 'Customer Address';
        }
        addafter(AddressDetails)
        {
            group(BLRCustContactDetails)
            {
                Caption = 'Contact Details';
            }
        }
        movefirst(BLRCustContactDetails; "Phone No.", "MobilePhoneNo", "E-Mail")
        addafter(Name)
        {
            field(BLRUsername; Rec.BLRUsername)
            {
                ApplicationArea = All;
                ToolTip = 'The username for the tenant. This is used for login purposes.';
            }
            field("BLRPassword"; rec."BLRPassword")
            {
                ApplicationArea = All;
                ToolTip = 'The password for the tenant. This is used for login purposes.';
            }
            field("BLRDate Of Birth"; rec."BLRDate Of Birth")
            {
                ApplicationArea = All;
                ToolTip = 'The date of birth of the tenant. This is used for identification purposes.';
            }
            field("BLRNationality"; rec."BLRNationality")
            {
                ApplicationArea = All;
                ToolTip = 'The nationality of the tenant. This is used for identification purposes.';
            }
            field("BLREmirates ID"; rec."BLREmirates ID")
            {
                ApplicationArea = All;
                ToolTip = 'The Emirates ID of the tenant. This is used for identification purposes.';
            }
            field("BLREmirates ID Expiry Date"; rec."BLREmirates ID Expiry Date")
            {
                ApplicationArea = All;
                ToolTip = 'The expiry date of the Emirates ID of the tenant. This is used for identification purposes.';
            }
            field("BLRLicense No."; Rec."BLRLicense No.")
            {
                ApplicationArea = All;
                ToolTip = 'The license number of the tenant. This is used for identification purposes.';
            }
            field("BLRLicensing Authority"; Rec."BLRLicensing Authority")
            {
                ApplicationArea = All;
                ToolTip = 'The authority that issued the license for the tenant. This is used for identification purposes.';
            }
            field("BLRCode Area"; Rec."BLRCode Area")
            {
                ApplicationArea = All;
                Caption = 'Code Area';
                Visible = false;
                ToolTip = 'The code area for the tenant. This is used for identification purposes.';
            }
            field(BLROccupation; Rec."BLROccupation")
            {
                ApplicationArea = All;
                Caption = 'Occupation';
                ToolTip = 'The occupation of the tenant. This is used for identification purposes.';
            }
        }
        addlast(General)
        {
            field("BLRCustomer Type"; Rec."BLRCustomer Type")
            {
                ApplicationArea = All;
                Caption = 'Customer Type';
                ToolTip = 'The type of customer, such as individual or company. This is used for classification purposes.';
            }

            field("BLRBusiness Unit"; Rec."BLRBusiness Unit")
            {
                ApplicationArea = All;
                Caption = 'Business unit';
                Visible = false;
                ToolTip = 'The business unit associated with the tenant. This is used for organizational purposes.';
            }
        }
        addafter("Address & Contact")
        {
            group("BLRPassport Details")
            {
                field("BLRPassport Number"; rec."BLRPassport Number")
                {
                    ApplicationArea = All;
                    ToolTip = 'The passport number of the tenant. This is used for identification purposes.';
                }
                field("BLRPassport Issue Date"; rec."BLRPassport Issue Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'The issue date of the passport of the tenant. This is used for identification purposes.';
                }
                field("BLRPassport Expiry Date"; rec."BLRPassport Expiry Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'The expiry date of the passport of the tenant. This is used for identification purposes.';
                }
                field("BLRCountry of Passport"; rec."BLRCountry of Passport")
                {
                    ApplicationArea = All;
                    ToolTip = 'The country that issued the passport of the tenant. This is used for identification purposes.';
                }
            }

            part("BLRDocument Attachments"; "BLRTenant Document SubPage")
            {
                SubPageLink = BLRNo = field("No."); // Link to filter attachments for this owner only
                ApplicationArea = All;
                Visible = isVisible;
            }

            group("BLRTenant Screening")
            {
                field("BLRApprove"; Rec."BLRApprove")
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    ToolTip = 'Indicates whether the tenant has been approved.';
                }
                field("BLRDecline"; Rec."BLRDecline")
                {
                    ApplicationArea = All;
                    Caption = 'Decline';
                    ToolTip = 'Indicates whether the tenant has been declined.';
                }
            }

        }
        addafter("Address 2")
        {
            field("BLRP.O.Box"; Rec."BLRP.O.Box")
            {
                ApplicationArea = All;
                Caption = 'P.O.Box';
                ToolTip = 'The P.O. Box number for the tenant. This is used for mailing purposes.';
            }
        }
    }

    var
        isVisible: Boolean;

    trigger OnModifyRecord(): Boolean
    begin
        CurrPage."BLRDocument Attachments".Page.SetPropertyId(Rec."No.");
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage."BLRDocument Attachments".Page.SetPropertyId(Rec."No.");
        isVisible := true;
    end;

    trigger OnAfterGetRecord()
    begin
        CurrPage."BLRDocument Attachments".Page.SetPropertyId(Rec."No.");
        if Rec."No." <> '' then
            isVisible := true
        else
            isVisible := false;

    end;
}