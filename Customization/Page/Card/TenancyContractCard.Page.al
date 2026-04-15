page 50313 "Tenancy Contract Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "Tenancy Contract";
    Caption = 'Tenancy Contract';

    layout
    {
        area(content)
        {
            // Group for General Information
            group("General Info")
            {
                Caption = 'General Information';

                field("Contract ID"; rec."Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the tenancy contract.';
                }

                field("Contract Type"; rec."Contract Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the type of tenancy contract.';
                    trigger OnValidate()
                    begin

                        UpdateFieldsEnable();
                    end;
                }
                field("Proposal ID"; Rec."Proposal ID")
                {
                    ApplicationArea = All;
                    Enabled = ProposalIDEnabled;
                    ToolTip = 'Specifies the unique identifier for the proposal associated with this tenancy contract.';
                    trigger OnValidate()
                    begin
                        // CurrPage.SaveRecord();
                    end;

                }

                field("Renewal Proposal ID"; rec."Renewal Proposal ID")
                {
                    ApplicationArea = All;
                    Enabled = RenewalProposalIDEnabled;
                    ToolTip = 'Specifies the unique identifier for the renewal proposal associated with this tenancy contract.';
                }
                field("Contract Date"; Rec."Contract Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the date when the tenancy contract was created.';
                }
            }

            group("Owner / Lessor Information")
            {
                field("Owner's Name"; rec."Owner's Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the name of the owner or lessor associated with this tenancy contract.';
                    Editable = false;

                }
                field("Owner ID"; rec."Owner ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the unique identifier for the owner associated with this tenancy contract.';
                }

                field("Lessor's Name"; rec."Lessor's Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the name of the lessor associated with this tenancy contract.';
                }

                field("Lessor's Emirates ID"; rec."Lessor's Emirates ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the Emirates ID of the lessor associated with this tenancy contract.';
                }

                field("License No."; rec."License No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the license number of the owner or lessor associated with this tenancy contract.';
                }

                field("Licensing Authority"; rec."Licensing Authority")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the licensing authority for the owner or lessor associated with this tenancy contract.';
                }

                field("Lessor's Email"; rec."Lessor's Email")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the email address of the lessor associated with this tenancy contract.';
                }

                field("Lessor's Phone"; rec."Lessor's Phone")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the phone number of the lessor associated with this tenancy contract.';
                }
                field("Lessor's Address"; Rec."Lessor's Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the address of the lessor associated with this tenancy contract.';
                }
                field("Lessor's Nationality"; Rec."Lessor's Nationality")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the nationality of the lessor associated with this tenancy contract.';
                }
            }

            // Group for Tenant and Customer Information
            group("Tenant & Customer Info")
            {
                Caption = 'Tenant & Customer Information';
                field("Tenant ID"; rec."Tenant ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the tenant associated with this tenancy contract.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'Enter the name of the tenant associated with this tenancy contract.';
                }
                field("Emirates ID"; rec."Emirates ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the Emirates ID of the tenant associated with this tenancy contract.';
                }

                field("Contact Number"; rec."Contact Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the contact number of the tenant associated with this tenancy contract.';
                }

                field("Email Address"; rec."Email Address")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the email address of the tenant associated with this tenancy contract.';
                }

                field("Tenant_License No."; Rec."Tenant_License No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the license number of the tenant associated with this tenancy contract.';
                }

                field("Tenant_Licensing Authority"; Rec."Tenant_Licensing Authority")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Select the licensing authority for the tenant associated with this tenancy contract.';
                }
            }

            // Group for Property Information
            group("Property Info")
            {
                Caption = 'Property Information';
                field("Property ID"; rec."Property ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the property associated with this tenancy contract.';
                }
                field("Property Name"; Rec."Property Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the name of the property associated with this tenancy contract.';
                }
                field("Property Classification"; rec."Property Classification")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'Select the classification of the property associated with this tenancy contract.';
                }
                field("Property Type"; rec."Property Type")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'Select the type of property associated with this tenancy contract.';
                }

                field("Praposal Type Selected"; rec."Praposal Type Selected")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Category';
                    Editable = false;
                    ToolTip = 'Select the type of proposal for the tenancy contract, either Single Unit or Merge Unit.';
                }
                field("Unit ID"; rec."Unit ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the unit associated with this tenancy contract.';
                }

                field("Merge Unit ID"; Rec."Merge Unit ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Lookup = true; // Enable lookup for Unit ID
                    ToolTip = 'Specifies the unique identifier for the merge unit associated with this tenancy contract.';
                }
                field("Unit Name"; Rec."Unit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the name of the unit associated with this tenancy contract.';
                }

                field("Unit Number"; Rec."Unit Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the unit number associated with this tenancy contract.';
                }

                field("Unit Address"; rec."Unit Address")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the address of the unit associated with this tenancy contract.';

                }
                field("Unit Classification"; rec."Usage Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the classification of the unit associated with this tenancy contract.';
                    Editable = false;
                }
                field("Unit Type"; rec."Unit Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Select the type of unit associated with this tenancy contract.';
                }

                field("Uniq Unit ID"; Rec.UnitID) // Auto-generated Unit ID
                {
                    ApplicationArea = All;
                    Caption = 'Uniq Unit ID';
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the unit associated with this tenancy contract.';
                }

                field("Single Unit Name"; Rec."Single Unit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    MultiLine = true;
                    ToolTip = 'Enter the name of the single unit associated with this tenancy contract.';
                }

                field("Market Rate per Sq. Ft."; rec."Market Rate per Sq. Ft.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the market rate per square foot for the unit associated with this tenancy contract.';
                }

                field("Ejari Name"; Rec."Ejari Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the Ejari name associated with this tenancy contract.';
                }
                field("Unit Sq. Feet"; Rec."Unit Sq. Feet")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the square footage of the unit associated with this tenancy contract.';
                }
                field("Property Size"; Rec."Property Size")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the size of the property associated with this tenancy contract.';
                }

                field("Base Unit of Measure"; rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Select the base unit of measure for the property associated with this tenancy contract.';
                }

                field("Makani Number"; Rec."Makani Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the Makani number associated with this tenancy contract.';
                }

                field(Emirate; Rec.Emirate)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Select the emirate where the property is located.';
                }

                field(Community; Rec.Community)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Select the community where the property is located.';
                }
                field("DEWA Number"; Rec."DEWA Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the DEWA number associated with this tenancy contract.';
                }

                field("Facilities/Amenities"; rec."Facilities/Amenities")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the facilities or amenities associated with this tenancy contract.';
                }
            }

            // Group for Contract Information
            group("Contract Details")
            {
                Caption = 'Contract Details';
                field("Contract Start Date"; Rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the start date of the tenancy contract.';
                }
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the end date of the tenancy contract.';
                }
                field("Contract Tenor"; Rec."Contract Tenor")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the tenor of the tenancy contract.';
                }

                field("Rent Amount"; Rec."Rent Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the rent amount for the tenancy contract.';
                }

                field("Contract VAT %"; Rec."Contract VAT %")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the VAT percentage applicable to the tenancy contract.';
                }

                field("Contract VAT Amount"; Rec."Contract VAT Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the VAT amount for the tenancy contract.';
                }

                field("Contract Amount Including VAT"; Rec."Contract Amount Including VAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the contract amount including VAT for the tenancy contract.';
                }

                field("Annual Rent Amount"; Rec."Annual Rent Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the annual rent amount for the tenancy contract.';
                }

                field("Payment Frequency"; rec."Payment Frequency")
                {
                    ApplicationArea = All;
                    Caption = 'Frequency of payment';
                    Editable = false;
                    ToolTip = 'Enter the payment frequency for the tenancy contract.';
                }
                field("Payment Method"; rec."Payment Method")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Mode';
                    Editable = false;
                    ToolTip = 'Enter the payment method for the tenancy contract.';
                }
                field("No of Installments"; rec."No of Installments")
                {
                    ApplicationArea = All;
                    Caption = 'No of Installments';
                    ToolTip = 'Enter the number of installments for the tenancy contract.';
                }
            }
            group("Security Deposit")
            {
                field("Security Deposit Amount"; Rec."Security Deposit Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the security deposit amount for the tenancy contract.';
                }

                field("Security Deposit Amt. Received"; Rec."Security Deposit Amt. Received")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Security Deposit Amount Received';
                    ToolTip = 'Enter the amount of security deposit received for the tenancy contract.';

                    trigger OnValidate()
                    begin
                        UpdateSecurityAmountReceived();
                    end;
                }
                field("Security Amount Pending"; Rec."Security Amount Pending")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Security Deposit Amount Pending';
                    ToolTip = 'Enter the amount of security deposit pending for the tenancy contract.';

                    trigger OnValidate()
                    begin
                        UpdateSecurityAmountReceived();
                    end;
                }

                field("Security Balanced Amount"; Rec."Security Balanced Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Security Deposit Amount Balance';
                    ToolTip = 'Enter the balanced amount of the security deposit for the tenancy contract.';
                }
                field("Carry Forward In"; Rec."Carry Forward In")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the amount carried forward from the previous tenancy contract.';
                }
                field("Carry Forward Out"; Rec."Carry Forward Out")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the amount carried forward to the next tenancy contract.';
                }
                field(Adjustments; Rec.Adjustments)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter any adjustments made to the security deposit for the tenancy contract.';
                }
                field(Refund; Rec.Refund)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the amount refunded from the security deposit for the tenancy contract.';
                }
            }

            // Group for Grace Period Information
            group("Grace Period Info")
            {
                Caption = 'Grace Period Information';

                field("Grace Start Date"; Rec."Grace Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the start date of the grace period for the tenancy contract.';
                }
                field("Grace End Date"; Rec."Grace End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the end date of the grace period for the tenancy contract.';
                }
                field("Grace Period"; Rec."Grace Period")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the duration of the grace period for the tenancy contract.';
                }

                field("Handover is Completed"; rec."Handover is Completed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether the handover of the property has been completed.';
                }

                field("Handover of PDC"; rec."Handover of PDC")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether the post-dated cheques (PDC) have been handed over.';
                }
                field("Signed TC Document"; rec."Signed TC Document")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether the signed tenancy contract document has been uploaded.';
                }
                field("Handover Unit"; rec."Handover Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether the unit has been handed over to the tenant.';
                }

                field("Single Rent Calculation"; Rec."Single Rent Calculation")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Select the type of rent calculation for single units, either with lumpsum square feet rate or with square feet rate.';
                    trigger OnValidate()
                    begin
                        UpdateVisibility();
                    end;
                }

                field("Merge Rent Calculation"; Rec."Merge Rent Calculation")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Select the type of rent calculation for merged units, either with differential square feet rate, lumpsum annual amount, or same square feet.';
                    trigger OnValidate()
                    begin
                        UpdateVisibility();
                    end;
                }


                field("Upload Document"; Rec."Upload Document")
                {
                    ToolTip = 'Upload a document related to the tenancy contract.';
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        azureBlobUploader: Codeunit "Azure AD Blob Storage";
                        fileName: Text;
                        uploadResult: Text;
                        folderName: Text;
                    begin
                        folderName := 'TenancyContractDocuments';
                        fileName := azureBlobUploader.ValidateDocument(uploadResult, folderName);
                        if fileName <> '' then begin
                            Rec."Upload Document" := CopyStr(fileName, 1, StrLen(fileName));
                            Rec."view Document" := copyStr(uploadResult, 1, StrLen(uploadResult));
                            Rec.Modify();
                            Message('File uploaded successfully: %1', fileName);
                        end;
                    end;
                }

                field("view Document"; Rec."view Document")
                {
                    ApplicationArea = All;
                    Editable = true;
                    DrillDown = true;
                    Visible = false;
                    ToolTip = 'View the uploaded document related to the tenancy contract.';
                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin
                        // Get the URL of the uploaded document
                        FileURL := Rec."view Document";

                        // Check if the file URL is not empty
                        if FileURL = '' then
                            Error('No document is available to view.');

                        // Open the file URL in the browser (new tab)
                        OpenFileInBrowser(FileURL);
                    end;
                }

                field("Renewal Contract Status"; rec."Renewal Contract Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Indicates the status of the renewal contract associated with this tenancy contract.';
                }

                field("Created By"; rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who created this tenancy contract.';
                }

                field("Renewal Notification to Tenant"; rec."Renewal Notification to Tenant")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether a renewal notification has been sent to the tenant for this tenancy contract.';
                }

                field("Tenant Loyalty Check Reminder"; rec."Tenant Loyalty Check Reminder")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether a reminder for tenant loyalty check has been set for this tenancy contract.';
                }

                field("Payment Reminder"; rec."Payment Reminder")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether a payment reminder has been set for this tenancy contract.';
                }

            }
            group("Lease Unit Details")
            {
                Caption = 'Unit Details';
                part("Unit all Details"; "Sub Lease Merged Units Card")
                {
                    SubPageLink = "Merge Unit ID" = FIELD("Merge Unit ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = Rec."Praposal Type Selected" = Rec."Praposal Type Selected"::"Merge Unit"; // Visible when "Praposal Type Selected" is "Merge Unit"
                }
            }

            group("Single Unit with lumpsum square feet rate")
            {
                Caption = 'Single Unit with lumpsum square feet rate';
                Visible = ShowLegalReasonFields3;

                part("Single Unit lumpsum Rent (Renewal)"; "TC Single LumAnnualAmnt SP")
                {
                    SubPageLink = "ID" = FIELD("Renewal Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" <> 0); // Show only if Renewal Proposal ID is set

                }
                part("Single Unit lumpsum Rent (Proposal)"; "TC Single LumAnnualAmnt SP")
                {
                    SubPageLink = "ID" = FIELD("Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" = 0); // Show only if Renewal Proposal ID is empty

                }
            }


            group("Single Unit with square feet rate")
            {
                Caption = 'Single Unit With Square Feet Rate';
                Visible = ShowLegalReasonFields;

                // Part for Renewal Proposal ID
                part("Single Unit Rent (Renewal)"; "TC Single Unit Rent SubPage")
                {
                    SubPageLink = "ID" = FIELD("Renewal Proposal ID"); // Uses Renewal Proposal ID
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" <> 0); // Show only if Renewal Proposal ID is set
                }

                // Part for Proposal ID (Fallback)
                part("Single Unit Rent (Proposal)"; "TC Single Unit Rent SubPage")
                {
                    SubPageLink = "ID" = FIELD("Proposal ID"); // Uses Proposal ID if Renewal is empty
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" = 0); // Show only if Renewal Proposal ID is empty
                }
            }
            group("Merged Unit with same square feet")
            {
                Caption = 'Merged Unit With Same Square Feet';
                Visible = ShowBusinessReasonFields;
                part("Merge SameSqure Rent (Renewal)"; "TC Merge SameSqure SubPage")
                {
                    SubPageLink = "ID" = FIELD("Renewal Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" <> 0); // Show only if Renewal Proposal ID is set

                }

                part("Merge SameSqure Rent (Proposal)"; "TC Merge SameSqure SubPage")
                {
                    SubPageLink = "ID" = FIELD("Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" = 0); // Show only if Renewal Proposal ID is empty

                }
            }
            group("Merged Unit with differential square feet rate")
            {
                Caption = 'Merged Unit With Differential Square Feet Rate';
                Visible = ShowLegalReasonFields1;
                part("Merge DifferentSqure Rent (Renewal)"; "TC Merge DifferentSq SubPage")
                {
                    SubPageLink = "ID" = FIELD("Renewal Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" <> 0);

                }

                part("Merge DifferentSqure Rent (Proposal)"; "TC Merge DifferentSq SubPage")
                {
                    SubPageLink = "ID" = FIELD("Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" = 0);
                }
            }
            group("Merged Unit with lumpsum annual amount")
            {
                Caption = 'Merged Unit With Lumpsum Annual Amount';
                Visible = ShowBusinessReasonFields2;
                part("Merge Lum_AnnualAmount Rent (Renewal)"; "TC Merge Lum_AnnualAmount SP")
                {
                    SubPageLink = "ID" = FIELD("Renewal Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" <> 0);
                }

                part("Merge Lum_AnnualAmount Rent (Proposal)"; "TC Merge Lum_AnnualAmount SP")
                {
                    SubPageLink = "ID" = FIELD("Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" = 0);
                }
            }

            group("Per Day Rent for Revenue Allocation")
            {
                Caption = 'Per Day Rent for Revenue Allocation';

                //  Show for Renewal Proposal if "Praposal Type Selected" = "Merge Unit"
                part("Per Day Rent (Renewal)"; "TC PerDayRent for Revenue Card")
                {
                    SubPageLink = "Contract Renewal Id" = FIELD("Renewal Proposal ID"); // Link to Renewal Proposal ID
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" <> 0) and
                  (Rec."Praposal Type Selected" = Rec."Praposal Type Selected"::"Merge Unit");
                }

                //  Show for Normal Proposal if "Praposal Type Selected" = "Merge Unit"
                part("Per Day Rent (Proposal)"; "TC PerDayRent for Revenue Card")
                {
                    SubPageLink = "Proposal Id" = FIELD("Proposal ID"); // Link to Proposal ID
                    ApplicationArea = All;
                    Visible = (Rec."Renewal Proposal ID" = 0) and
                  (Rec."Praposal Type Selected" = Rec."Praposal Type Selected"::"Merge Unit");
                }
            }
            group("Rent Calculation")
            {
                field("Update Data"; Rec."Update Data")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    ToolTip = 'Drill down to the Rent Calculation record for this tenancy contract.';

                    trigger OnDrillDown()
                    var
                        RentRecord: Record "Rent Calculation";
                        Tenancycontract: Record "Tenancy Contract";
                        SU_samesquare: Record "TC Single Unit Rent SubPage";
                        SU_lumpsum: Record "TC Single LumAnnualAmnt SP";
                        MU_samesquare: Record "TC Merge SameSqure SubPage";
                        MU_differentsquare: Record "TC Merge DifferentSq SubPage";
                        MU_lumpsum: Record "TC Merge LumAnnualAmount SP";
                        RentSubpage: Record "Rent Calculation Subpage";
                        fetchMonth: Codeunit "Fetch Month";
                        yearlyInstallment: Integer;
                        Lastyear: Integer;
                        RentRecordid: Integer;
                        SingleUnitName: Text;
                        CommaPos: Integer;
                    begin
                        // Find the Tenancy Contract record
                        Tenancycontract.SetRange("Contract ID", Rec."Contract ID");
                        Tenancycontract.SetRange("Tenant ID", Rec."Tenant ID");
                        if Tenancycontract.FindFirst() then begin
                            // Set fields for RentCalculation record
                            RentRecord."Contract ID" := Tenancycontract."Contract ID";
                            RentRecord."Property Classification" := Tenancycontract."Property Classification";
                            RentRecord."Contract Start Date" := Tenancycontract."Contract Start Date";
                            RentRecord."Contract End Date" := Tenancycontract."Contract End Date";
                            RentRecord."Amount" := Round(Tenancycontract."Annual Rent Amount");
                            RentRecord."Tenant ID" := Tenancycontract."Tenant ID";
                            RentRecord."Secondary Item Type" := 'Rent';
                            RentRecord."VAT Amount" := Round(Tenancycontract."Contract VAT Amount");
                            RentRecord."Amount Including VAT" := Round(Tenancycontract."Contract Amount Including VAT");
                            RentRecord."Number of Installments" := Tenancycontract."No of Installments";
                            RentRecord."VAT %" := Tenancycontract."Contract VAT %";

                            // Check if Rent Calculation exists, then modify or insert
                            RentRecord.SetRange("Contract ID", Rec."Contract ID"); // Ensure you're looking for the correct Contract ID

                            if RentRecord.FindFirst() then begin
                                RentRecord."Contract ID" := Tenancycontract."Contract ID";
                                RentRecord."Property Classification" := Tenancycontract."Property Classification";
                                RentRecord."Contract Start Date" := Tenancycontract."Contract Start Date";
                                RentRecord."Contract End Date" := Tenancycontract."Contract End Date";
                                RentRecord."Amount" := Round(Tenancycontract."Annual Rent Amount");
                                RentRecord."Tenant ID" := Tenancycontract."Tenant ID";
                                RentRecord."Secondary Item Type" := 'Rent';
                                RentRecord."VAT Amount" := Round(Tenancycontract."Contract VAT Amount");
                                RentRecord."Amount Including VAT" := Round(Tenancycontract."Contract Amount Including VAT");
                                RentRecord."Number of Installments" := Tenancycontract."No of Installments";
                                RentRecord."VAT %" := Tenancycontract."Contract VAT %";
                                RentRecord.Modify();
                                Message('Record Modified Successfully');
                                exit;
                            end else begin
                                // If Rent Calculation doesn't exist, insert a new one
                                RentRecord.Init();
                                RentRecord."Contract ID" := Tenancycontract."Contract ID";
                                RentRecord."Property Classification" := Tenancycontract."Property Classification";
                                RentRecord."Contract Start Date" := Tenancycontract."Contract Start Date";
                                RentRecord."Contract End Date" := Tenancycontract."Contract End Date";
                                RentRecord."Amount" := Round(Tenancycontract."Annual Rent Amount");
                                RentRecord."Tenant ID" := Tenancycontract."Tenant ID";
                                RentRecord."Secondary Item Type" := 'Rent';
                                RentRecord."VAT Amount" := Round(Tenancycontract."Contract VAT Amount");
                                RentRecord."Amount Including VAT" := Round(Tenancycontract."Contract Amount Including VAT");
                                RentRecord."Number of Installments" := Tenancycontract."No of Installments";
                                RentRecord."VAT %" := Tenancycontract."Contract VAT %";

                                // Handle Rent Calculation Type assignment
                                if Tenancycontract."Single Rent Calculation" = Tenancycontract."Single Rent Calculation"::"Single Unit with lumpsum square feet rate" then
                                    RentRecord."Rent Calculation Type" := Format(Tenancycontract."Single Rent Calculation")
                                else
                                    if Tenancycontract."Single Rent Calculation" = Tenancycontract."Single Rent Calculation"::"Single Unit with square feet rate" then
                                        RentRecord."Rent Calculation Type" := Format(Tenancycontract."Single Rent Calculation")
                                    else
                                        if Tenancycontract."Merge Rent Calculation" = Tenancycontract."Merge Rent Calculation"::"Merged Unit with differential square feet rate" then
                                            RentRecord."Rent Calculation Type" := Format(Tenancycontract."Merge Rent Calculation")
                                        else
                                            if Tenancycontract."Merge Rent Calculation" = Tenancycontract."Merge Rent Calculation"::"Merged Unit with lumpsum annual amount" then
                                                RentRecord."Rent Calculation Type" := Format(Tenancycontract."Merge Rent Calculation")
                                            else
                                                if Tenancycontract."Merge Rent Calculation" = Tenancycontract."Merge Rent Calculation"::"Merged Unit with same square feet" then
                                                    RentRecord."Rent Calculation Type" := Format(Tenancycontract."Merge Rent Calculation")
                                                else
                                                    Error('No valid Rent Calculation Type found in Tenancy Contract.');
                                // Insert the new Rent Calculation record
                                RentRecord.Insert();
                            end;
                            // Update data in Revenue Structure Subpage for Single Rent Calculation
                            if Tenancycontract."Single Rent Calculation" = Tenancycontract."Single Rent Calculation"::"Single Unit with lumpsum square feet rate" then begin
                                SU_lumpsum.SetRange("Contract Id", Tenancycontract."Contract Id");
                                if SU_lumpsum.FindSet() then
                                    repeat
                                        if not RentSubpage.Get(RentRecord."RC ID", SU_lumpsum.SL_Year) then begin
                                            RentSubpage.Init();
                                            RentSubpage."RC ID" := RentRecord."RC ID";
                                            RentSubpage."Contract ID" := RentRecord."Contract ID";
                                            RentSubpage."Tenant Id" := RentRecord."Tenant ID";
                                            RentSubpage."Secondary Item Type" := RentRecord."Secondary Item Type";
                                            RentSubpage."VAT %" := RentRecord."VAT %";
                                            RentSubpage."Propety Classification" := RentRecord."Property Classification";
                                            RentSubpage."VAT Amount" := RentRecord."VAT Amount";
                                            RentSubpage."Amount Including VAT" := RentRecord."Amount Including VAT";
                                            RentSubpage.Year := SU_lumpsum.SL_Year;
                                            RentSubpage."Period Start Date" := SU_lumpsum."SL_Start Date";
                                            RentSubpage."Period End Date" := SU_lumpsum."SL_End Date";
                                            RentSubpage."Number of Days" := SU_lumpsum."SL_Number of Days";
                                            RentSubpage."Per Day Rent" := SU_lumpsum."SL_Per Day Rent";
                                            RentSubpage."Final Annual Amount" := SU_lumpsum."SL_Final Annual Amount";
                                            RentSubpage."Unit ID" := SU_lumpsum."SL_Unit ID";
                                            RentSubpage.Insert();
                                            Clear(RentSubpage);
                                        end
                                    until SU_lumpsum.Next() = 0
                                else
                                    Error('No data found in Single Unit with lumpsum square feet rate subpage for Contract ID %1.', Tenancycontract."Contract ID");
                            end
                            else
                                if Tenancycontract."Single Rent Calculation" = Tenancycontract."Single Rent Calculation"::"Single Unit with square feet rate" then begin
                                    SU_samesquare.SetRange("Contract Id", Tenancycontract."Contract ID");
                                    if SU_samesquare.FindSet() then
                                        repeat
                                            if not RentSubpage.Get(RentRecord."RC ID", SU_samesquare.Year) then begin
                                                RentSubpage.Init();
                                                RentSubpage."RC ID" := RentRecord."RC ID";
                                                RentSubpage."Contract ID" := RentRecord."Contract ID";
                                                RentSubpage."Tenant Id" := RentRecord."Tenant ID";
                                                RentSubpage."Secondary Item Type" := RentRecord."Secondary Item Type";
                                                RentSubpage."VAT %" := RentRecord."VAT %";
                                                RentSubpage."VAT Amount" := RentRecord."VAT Amount";
                                                RentSubpage."Propety Classification" := RentRecord."Property Classification";
                                                RentSubpage."Amount Including VAT" := RentRecord."Amount Including VAT";
                                                RentSubpage.Year := SU_samesquare.Year;
                                                RentSubpage."Period Start Date" := SU_samesquare."Start Date";
                                                RentSubpage."Period End Date" := SU_samesquare."End Date";
                                                RentSubpage."Number of Days" := SU_samesquare."Number of Days";
                                                RentSubpage."Per Day Rent" := SU_samesquare."Per Day Rent";
                                                RentSubpage."Final Annual Amount" := SU_samesquare."Final Annual Amount";
                                                RentSubpage."Unit ID" := SU_samesquare."Unit ID";

                                                RentSubpage.Insert();
                                                Clear(RentSubpage);
                                            end
                                        until SU_samesquare.Next() = 0
                                    else
                                        Error('No data found in Single Unit with square feet rate subpage for Contract ID %1.', Tenancycontract."Contract ID");
                                end

                                else
                                    if Tenancycontract."Merge Rent Calculation" = Tenancycontract."Merge Rent Calculation"::"Merged Unit with differential square feet rate" then begin
                                        // Find the Tenancy Contract record
                                        Tenancycontract.SetRange("Contract Id", Rec."Contract Id");
                                        if Tenancycontract.FindFirst() then begin
                                            SingleUnitName := Tenancycontract."Single Unit Name";
                                            CommaPos := StrPos(SingleUnitName, ','); // Find the position of the first comma
                                            if CommaPos > 0 then
                                                SingleUnitName := CopyStr(SingleUnitName, 1, CommaPos - 1) // Trim to the first name
                                            else
                                                SingleUnitName := SingleUnitName; // No comma, use the whole name

                                            // Find the first unit's details in Merge DifferentSquare table
                                            MU_differentsquare.SetRange("Contract ID", Tenancycontract."Contract ID");
                                            if MU_differentsquare.FindSet() then
                                                repeat
                                                    // Update Revenue Structure Subpage
                                                    if not RentSubpage.Get(RentRecord."RC ID", MU_differentsquare.MD_Year) then begin
                                                        RentSubpage.Init();
                                                        RentSubpage."RC ID" := RentRecord."RC ID";
                                                        RentSubpage."Contract ID" := RentRecord."Contract ID";
                                                        RentSubpage."Tenant Id" := RentRecord."Tenant ID";
                                                        RentSubpage."Secondary Item Type" := RentRecord."Secondary Item Type";
                                                        RentSubpage."VAT %" := RentRecord."VAT %";
                                                        RentSubpage."Propety Classification" := RentRecord."Property Classification";
                                                        RentSubpage."VAT Amount" := RentRecord."VAT Amount";
                                                        RentSubpage."Amount Including VAT" := RentRecord."Amount Including VAT";
                                                        RentSubpage.Year := MU_differentsquare.MD_Year;
                                                        RentSubpage."Period Start Date" := MU_differentsquare."MD_Start Date";
                                                        RentSubpage."Period End Date" := MU_differentsquare."MD_End Date";
                                                        RentSubpage."Number of Days" := MU_differentsquare."MD_Number of Days";
                                                        RentSubpage."Per Day Rent" := MU_differentsquare."MD_Per Day Rent";
                                                        RentSubpage."Final Annual Amount" := MU_differentsquare."MD_Final Annual Amount";
                                                        RentSubpage."Unit ID" := MU_differentsquare."MD_Unit ID";

                                                        RentSubpage.Insert();
                                                        Clear(RentSubpage);
                                                    end
                                                until MU_differentsquare.Next() = 0
                                            else
                                                Error('No data found for Unit Name: %1 in Contract ID: %2.', SingleUnitName, Tenancycontract."Contract ID");
                                        end
                                        else
                                            Error('Tenancy Contract not found for Contract ID: %1.', Rec."Contract ID");
                                    end
                                    else
                                        if Tenancycontract."Merge Rent Calculation" = Tenancycontract."Merge Rent Calculation"::"Merged Unit with lumpsum annual amount" then begin
                                            MU_lumpsum.SetRange("Contract ID", Tenancycontract."Contract ID");
                                            if MU_lumpsum.FindSet() then
                                                repeat
                                                    if not RentSubpage.Get(RentRecord."RC ID", MU_lumpsum.ML_Year) then begin
                                                        RentSubpage.Init();
                                                        RentSubpage."RC ID" := RentRecord."RC ID";
                                                        RentSubpage."Contract ID" := RentRecord."Contract ID";
                                                        RentSubpage."Tenant Id" := RentRecord."Tenant ID";
                                                        RentSubpage."Secondary Item Type" := RentRecord."Secondary Item Type";
                                                        RentSubpage."VAT %" := RentRecord."VAT %";
                                                        RentSubpage."Propety Classification" := RentRecord."Property Classification";
                                                        RentSubpage."VAT Amount" := RentRecord."VAT Amount";
                                                        RentSubpage."Amount Including VAT" := RentRecord."Amount Including VAT";
                                                        RentSubpage.Year := MU_lumpsum.ML_Year;
                                                        RentSubpage."Period Start Date" := MU_lumpsum."ML_Start Date";
                                                        RentSubpage."Period End Date" := MU_lumpsum."ML_End Date";
                                                        RentSubpage."Number of Days" := MU_lumpsum."ML_Number of Days";
                                                        RentSubpage."Per Day Rent" := MU_lumpsum."ML_Per Day Rent";
                                                        RentSubpage."Final Annual Amount" := MU_lumpsum."ML_Final Annual Amount";
                                                        RentSubpage."Unit ID" := MU_lumpsum."ML_Unit ID";

                                                        RentSubpage.Insert();
                                                        Clear(RentSubpage);
                                                    end
                                                until MU_lumpsum.Next() = 0
                                            else
                                                Error('No data found in Merged Unit with lumpsum annual amount subpage for Contract ID %1.', Tenancycontract."Contract ID");
                                        end
                                        else
                                            if Tenancycontract."Merge Rent Calculation" = Tenancycontract."Merge Rent Calculation"::"Merged Unit with same square feet" then begin
                                                MU_samesquare.SetRange("Contract ID", Tenancycontract."Contract ID");
                                                if MU_samesquare.FindSet() then
                                                    repeat
                                                        if not RentSubpage.Get(RentRecord."RC ID", MU_samesquare.MS_Year) then begin
                                                            RentSubpage.Init();
                                                            RentSubpage."RC ID" := RentRecord."RC ID";
                                                            RentSubpage."Contract ID" := RentRecord."Contract ID";
                                                            RentSubpage."Tenant Id" := RentRecord."Tenant ID";
                                                            RentSubpage."Secondary Item Type" := RentRecord."Secondary Item Type";
                                                            RentSubpage."VAT %" := RentRecord."VAT %";
                                                            RentSubpage."VAT Amount" := RentRecord."VAT Amount";
                                                            RentSubpage."Propety Classification" := RentRecord."Property Classification";
                                                            RentSubpage."Amount Including VAT" := RentRecord."Amount Including VAT";
                                                            RentSubpage.Year := MU_samesquare.MS_Year;
                                                            RentSubpage."Period Start Date" := MU_samesquare."MS_Start Date";
                                                            RentSubpage."Period End Date" := MU_samesquare."MS_End Date";
                                                            RentSubpage."Number of Days" := MU_samesquare."MS_Number of Days";
                                                            RentSubpage."Per Day Rent" := MU_samesquare."MS_Per Day Rent";
                                                            RentSubpage."Unit ID" := MU_samesquare."MS_Unit ID";

                                                            RentSubpage."Final Annual Amount" := MU_samesquare."MS_Final Annual Amount";
                                                            RentSubpage.Insert();
                                                            Clear(RentSubpage);
                                                        end
                                                    until MU_samesquare.Next() = 0
                                                else
                                                    Error('No data found in Merged Unit with same square feet subpage for Contract ID %1.', Tenancycontract."Contract ID");
                                            end;

                            RentSubpage.SetRange("RC ID", RentRecord."RC ID");
                            RentSubpage.SetRange("Contract ID", RentRecord."Contract ID");
                            RentSubpage.SetCurrentKey(Year);
                            if RentSubpage.FindLast() then begin
                                Lastyear := RentSubpage.Year;
                                Clear(RentSubpage);
                                RentSubpage.SetRange("RC ID", RentRecord."RC ID");
                                RentSubpage.SetRange("Contract ID", RentRecord."Contract ID");
                                if RentSubpage.FindSet() then
                                    repeat
                                        yearlyInstallment := 12 / fetchMonth.GetNoofMonthsFromFrequency(Format(Rec."Payment Frequency"));

                                        if Rec."No of Installments" > yearlyInstallment then begin
                                            if RentSubpage.Year = Lastyear then
                                                RentSubpage."Yearly No. of Installment" := Rec."No of Installments" - (yearlyInstallment * (Lastyear - 1))
                                            else
                                                RentSubpage."Yearly No. of Installment" := yearlyInstallment;
                                        end
                                        else
                                            if Rec."No of Installments" < yearlyInstallment then
                                                RentSubpage."Yearly No. of Installment" := Rec."No of Installments"
                                            else
                                                RentSubpage."Yearly No. of Installment" := yearlyInstallment;

                                        RentSubpage.Modify(true);
                                    until RentSubpage.Next() = 0;
                            end;
                            Message('New record has been created in Rent Calculation and subpage updated successfully.');
                        end;

                        RentRecord.SetRange("Contract ID", Rec."Contract ID");
                        RentRecord.SetRange("Tenant ID", Rec."Tenant ID");

                        if RentRecord.FindSet() then
                            RentRecordid := RentRecord."RC ID"
                        else begin
                            // If no record is found, create a new Revenue Structure record
                            RentRecord.Init();
                            RentRecord.Insert(true);
                            RentRecord.Modify(true);  // Insert the new record and generate the RS ID

                            // Get the newly created RS ID
                            RentRecordid := RentRecord."RC ID";
                        end;
                        Rec."Rent Calculation Link" := RentRecordid;
                    end;

                }

                field("Rent Calculation Link"; Rec."Rent Calculation Link")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    ToolTip = 'Drill down to the Rent Calculation record for this tenancy contract.';

                    trigger OnDrillDown()
                    var
                        RentCalculation: Record "Rent Calculation";

                    begin
                        // Navigate to the Revenue Structure Card page
                        if RentCalculation.Get(Rec."Rent Calculation Link") then
                            PAGE.RUN(PAGE::"Rent Calculation Card", RentCalculation)
                        else
                            Message('The related Revenue Structure does not exist.')
                    end;

                }

            }
            group("Other Payments")
            {
                part("Revenues"; "Tenancy Contract SubPage Card")
                {
                    SubPageLink = ContractID = FIELD("Contract ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                }
            }

            group("Contract Status")  // Add a separate group for clarity
            {
                field("Update Contract Status"; Rec."Update Contract Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the status to update the contract.';
                    trigger OnValidate()
                    begin
                        // Check if "Update Contract Status" has a value other than its default (e.g., <Blank>)
                        if Rec."Update Contract Status" <> Rec."Update Contract Status"::" " then
                            Rec."Yes/No" := true
                        else
                            Rec."Yes/No" := false;
                    end;
                }

                field("Tenant Contract Status"; rec."Tenant Contract Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The current status of the tenancy contract.';

                    trigger OnValidate()
                    var

                    begin
                        // Check if the contract status is either "Terminated" or "Renewed"
                        if (Rec."Tenant Contract Status" = Rec."Tenant Contract Status"::"Terminated") or
                           (Rec."Tenant Contract Status" = Rec."Tenant Contract Status"::"Contract Renewed") then
                            IsVisible := true  // Link should be visible
                        else
                            IsVisible := false; // Link should be hidden

                    end;
                }

                field("Previous Status"; Rec."Previous Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'The previous status of the tenancy contract.';
                }

                group(FinalCalculation)
                {
                    Visible = IsVisible;
                    ShowCaption = false;
                    field("Final Calculation"; rec."Final Calculation")
                    {
                        ToolTip = 'Drill down to the Final Calculation record for this tenancy contract.';
                        ApplicationArea = All;
                        DrillDown = true;
                        // Show or hide based on status

                        trigger OnDrillDown()
                        var

                            FinalCalculation: Record "Final Calculation";
                            TenancyContractSubpage: Record "Tenancy Contract SubPage";
                            FinalSettlementRefund: Record FinalSettlementRefund;
                            FinalSettlement: Record FinalSettlement;
                            StartDate: Date;
                            EndDate: Date;
                            DaysDiff: Integer;

                            FinalCalculationid: Integer;
                        begin
                            FinalCalculation.SetRange("Contract ID", Rec."Contract ID");
                            FinalCalculation.SetRange("Tenant ID", Rec."Tenant ID");

                            if FinalCalculation.FindSet() then begin
                                PopulateFinalCalculationFromTenancyContract(FinalCalculation);

                                FinalCalculation.Modify();
                                Message('Record Modifyed Successfully');
                            end else begin
                                FinalCalculation.Init();
                                PopulateFinalCalculationFromTenancyContract(FinalCalculation);

                                FinalCalculation.Insert();
                                Message('Record Created Successfully');
                            end;
                            StartDate := Rec."Contract Start Date";
                            EndDate := Rec."Contract End Date";
                            DaysDiff := EndDate - StartDate + 1;
                            FinalCalculation."Original Contract Tenure" := DaysDiff;
                            FinalCalculation.Modify(true);

                            FinalCalculation.SetRange("Contract ID", Rec."Contract ID");
                            FinalCalculation.SetRange("Tenant ID", Rec."Tenant ID");

                            if FinalCalculation.FindSet() then
                                FinalCalculationid := FinalCalculation."FC ID"
                            else begin
                                // If no record is found, create a new Revenue Structure record
                                FinalCalculation.Init();
                                FinalCalculation.Insert(true);
                                FinalCalculation.Modify(true);  // Insert the new record and generate the RS ID

                                // Get the newly created RS ID
                                FinalCalculationid := FinalCalculation."FC ID";
                            end;
                            Rec."Link" := FinalCalculationid;

                            // Add this new section to populate the Final Settlement Refund grid
                            FinalSettlementRefund.SetRange("FC ID", FinalCalculationid);
                            if FinalSettlementRefund.FindSet() then
                                repeat
                                    FinalSettlementRefund."Contract ID" := Rec."Contract ID";
                                    FinalSettlementRefund.Modify(true);
                                until FinalSettlementRefund.Next() = 0
                            else begin
                                // If you want to create a new record when none exists
                                FinalSettlementRefund.Init();
                                FinalSettlementRefund."FC ID" := FinalCalculationid;
                                FinalSettlementRefund."Contract ID" := Rec."Contract ID";
                                FinalSettlementRefund.Insert(true);
                                Clear(FinalSettlementRefund);
                            end;

                            // Add this new section to populate the Final Settlement Refund grid
                            FinalSettlement.SetRange("FC ID", FinalCalculationid);
                            if FinalSettlement.FindSet() then
                                repeat
                                    FinalSettlement."Contract ID" := Rec."Contract ID";
                                    FinalSettlement."Tenant Email" := CopyStr(Rec."Email Address", 1, strlen(Rec."Email Address"));
                                    FinalSettlement."Tenant Name" := Rec."Customer Name";
                                    FinalSettlement.Modify(true);
                                until FinalSettlement.Next() = 0
                            else begin
                                // If you want to create a new record when none exists
                                FinalSettlement.Init();
                                FinalSettlement."FC ID" := FinalCalculationid;
                                FinalSettlement."Contract ID" := Rec."Contract ID";
                                FinalSettlement."Tenant Email" := CopyStr(Rec."Email Address", 1, strlen(Rec."Email Address"));
                                FinalSettlement."Tenant Name" := Rec."Customer Name";
                                FinalSettlement.Insert(true);
                                Clear(FinalSettlement);
                            end;
                        end;
                    }



                    field("Link"; Rec."Link")
                    {
                        ApplicationArea = All;
                        DrillDown = true;
                        ToolTip = 'Click to open the Final Calculation Card';

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
                }
                field("Suspended Reason list"; Rec."Suspended Reason list")
                {
                    ApplicationArea = All;
                    ToolTip = 'Click to open the Suspended Reason List.';
                    Style = Strong; // Makes the field look like a hyperlink
                    StyleExpr = true;

                    trigger OnAssistEdit()
                    var
                        SuspendedReasonRec: Record "SuspendReasonTable";
                    begin
                        // Filter the Suspended Reason List page by the current Contract ID
                        SuspendedReasonRec.SetRange("Contract ID", Rec."Contract ID");
                        Page.Run(Page::"SuspendReasonList", SuspendedReasonRec);
                    end;
                }

            }

            group("WorkflowFrequencys")
            {
                Visible = false;
                part("Workflow Frequency"; "Workflow Frequency PR Card")
                {
                    SubPageLink = "Property ID" = FIELD("Property ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                }
            }

            group("Brokers and Commission Agent Details")
            {
                field("Vendor ID"; Rec."Vendor ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Click to open the Vendor Card';
                }

                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Click to open the Vendor Card';
                }

                field("Start Date"; Rec."Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The start date of the tenancy contract.';
                }

                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The end date of the tenancy contract.';
                }

                field("Calculation Method"; Rec."Calculation Method")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The calculation method of the tenancy contract.';
                }

                field("Percentage Type"; Rec."Percentage Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The percentage type of the tenancy contract.';
                }

                field("Percentage"; Rec."Percentage")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The percentage of the tenancy contract.';
                }

                field("Amount"; Rec."Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The amount of the tenancy contract.';
                }

                field("Base Amount Type"; Rec."Base Amount Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The base amount type of the tenancy contract.';
                }
                field("Frequency Of Payment"; Rec."Frequency Of Payment")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The frequency of payment of the tenancy contract.';
                }

                field("ContractStatus"; Rec."Contract Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The status of the tenancy contract.';
                }
            }
            field(IsCarryForwarded; Rec.IsCarryForwarded)
            {
                ApplicationArea = All;
                ToolTip = 'Carry Forward';
            }
        }
    }
    actions
    {
        area(Reporting)
        {

            action("Run Report")
            {
                ToolTip = 'Run the tenancy contract report for the selected emirate.';
                ApplicationArea = All;
                trigger OnAction()
                var
                    TenancyContract: Record "Tenancy Contract";
                    ReportDubai: Report "Tenancy Contract";
                    ReportAbuDhabi: Report UmmAlQuwainContract;
                    Emirate: Enum Emirates;
                    CurrentEmirateValue: Enum Emirates;
                begin
                    TenancyContract.SetRange("Contract ID", Rec."Contract ID");

                    if Evaluate(CurrentEmirateValue, Rec.Emirate) then
                        case CurrentEmirateValue of
                            Emirate::"Umm Al Quwain":
                                begin
                                    ReportAbuDhabi.SetTableView(TenancyContract);
                                    ReportAbuDhabi.UseRequestPage(false);
                                    ReportAbuDhabi.RunModal();
                                end;
                            Emirate::Dubai, Emirate::"Abu Dhabi", Emirate::Sharjah, Emirate::Ajman, Emirate::Fujairah, Emirate::"Ras Al Khaimah":
                                begin
                                    ReportDubai.SetTableView(TenancyContract);
                                    ReportDubai.UseRequestPage(false);
                                    ReportDubai.RunModal();
                                end;
                        end;
                end;
            }
        }
    }



    procedure OpenFileInBrowser(URL: Text)
    begin
        // Use the Hyperlink method to open the file in the browser
        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;


    var
        ProposalIDEnabled: Boolean;
        RenewalProposalIDEnabled: Boolean;

    trigger OnAfterGetRecord()

    var
        workflowfrequency: Record "Workflow Frequency PR";

    begin

        CurrPage."Revenues".Page.SetContractID(Rec."Contract ID");

        CurrPage."Revenues".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."Revenues".Page.SetProposalId(Rec."Proposal ID");
        CurrPage."Single Unit Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit lumpsum Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit lumpsum Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge SameSqure Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge SameSqure Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge DifferentSqure Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge DifferentSqure Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge Lum_AnnualAmount Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge Lum_AnnualAmount Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        UpdateFieldsEnable();
        UpdateVisibility();
        UpdateSecurityAmountReceived();

        if Rec."Termination Of Contract" = Rec."Termination Of Contract"::" " then
            IsVisible := false  // Link should be visible
        else
            IsVisible := true; // Link should be hidde


        // Check if the contract status is either "Terminated" or "Renewed"
        if (Rec."Tenant Contract Status" = Rec."Tenant Contract Status"::"Terminated") or
           (Rec."Tenant Contract Status" = Rec."Tenant Contract Status"::"Contract Renewed") then
            IsVisible := true  // Link should be visible
        else
            IsVisible := false; // Link should be hidden        

        workflowfrequency.SetRange("Property ID", Rec."Property ID");
        workflowfrequency.SetFilter(Workflow, '%1|%2|%3',
            workflowfrequency.Workflow::"Payment Reminder",
            workflowfrequency.Workflow::"Renewal Notification to Tenant",
            workflowfrequency.Workflow::"Tenant Loyalty Check Reminder");

        if workflowfrequency.FindSet() then begin
            repeat
                case workflowfrequency.Workflow of
                    workflowfrequency.Workflow::"Payment Reminder":
                        Rec."Payment Reminder" := workflowfrequency."No. of Days";

                    workflowfrequency.Workflow::"Renewal Notification to Tenant":
                        Rec."Renewal Notification to Tenant" := workflowfrequency."No. of Days";

                    workflowfrequency.Workflow::"Tenant Loyalty Check Reminder":
                        Rec."Tenant Loyalty Check Reminder" := workflowfrequency."No. of Days";
                end;
            until workflowfrequency.Next() = 0;

            Rec.Modify();
        end;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        CurrPage."Revenues".Page.SetContractID(Rec."Contract ID");

        CurrPage."Revenues".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."Revenues".Page.SetProposalId(Rec."Proposal ID");
        CurrPage."Single Unit Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit lumpsum Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit lumpsum Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge SameSqure Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge SameSqure Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge DifferentSqure Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge DifferentSqure Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge Lum_AnnualAmount Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge Lum_AnnualAmount Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        UpdateVisibility();
        UpdateSecurityAmountReceived();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage."Revenues".Page.SetContractID(Rec."Contract ID");

        CurrPage."Revenues".Page.SetTenantID(Rec."Tenant ID");
        CurrPage."Revenues".Page.SetProposalId(Rec."Proposal ID");
        CurrPage."Single Unit Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit lumpsum Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Single Unit lumpsum Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge SameSqure Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge SameSqure Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge DifferentSqure Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge DifferentSqure Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge Lum_AnnualAmount Rent (Proposal)".Page.SetContractIDs(Rec."Contract ID");
        CurrPage."Merge Lum_AnnualAmount Rent (Renewal)".Page.SetContractIDs(Rec."Contract ID");
        UpdateVisibility();

    end;


    local procedure UpdateFieldsEnable()
    begin
        ProposalIDEnabled := Rec."Contract Type" = Rec."Contract Type"::"New Contract";
        RenewalProposalIDEnabled := Rec."Contract Type" = Rec."Contract Type"::"Renewal Contract";

        CurrPage.Update(false);
    end;

    var
        ShowLegalReasonFields: Boolean;
        ShowBusinessReasonFields: Boolean;
        ShowLegalReasonFields1: Boolean;
        ShowBusinessReasonFields2: Boolean;
        ShowLegalReasonFields3: Boolean;
        ShowLegalReasonFields4: Boolean;
        IsVisible: Boolean;


    // Procedure to update visibility dynamically
    procedure UpdateVisibility()
    begin
        ShowLegalReasonFields := (Rec."Single Rent Calculation" = Rec."Single Rent Calculation"::"Single Unit with square feet rate");
        ShowBusinessReasonFields := (Rec."Merge Rent Calculation" = Rec."Merge Rent Calculation"::"Merged Unit with same square feet");
        ShowLegalReasonFields1 := (Rec."Merge Rent Calculation" = Rec."Merge Rent Calculation"::"Merged Unit with differential square feet rate");
        ShowBusinessReasonFields2 := (Rec."Merge Rent Calculation" = Rec."Merge Rent Calculation"::"Merged Unit with lumpsum annual amount");
        ShowLegalReasonFields3 := (Rec."Single Rent Calculation" = Rec."Single Rent Calculation"::"Single Unit with lumpsum square feet rate");
        ShowLegalReasonFields4 := (Rec."Praposal Type Selected" = Rec."Praposal Type Selected"::"Merge Unit");
    end;

    local procedure UpdateSecurityAmountReceived()
    begin
        // Update Security Amount Received
        if Rec."Security Deposit Amount" = Rec."Security Deposit Amt. Received" then
            Rec."Security Amount Pending" := 0
        else
            Rec."Security Amount Pending" := Rec."Security Deposit Amount" - Rec."Security Deposit Amt. Received";

    end;



    trigger OnOpenPage()
    var
        TenancyContractSubpage: Record "Tenancy Contract Subpage";
    begin
        TenancyContractSubpage.SetRange(ContractID, 0);
        if TenancyContractSubpage.FindSet() then
            TenancyContractSubpage.DeleteAll();
    end;

    procedure PopulateFinalCalculationFromTenancyContract(var aFinalCalculation: Record "Final Calculation")
    var
        TenancyContractSubpage: Record "Tenancy Contract SubPage";
    begin
        aFinalCalculation."Contract ID" := Rec."Contract ID";
        aFinalCalculation."Tenant ID" := Rec."Tenant ID";
        aFinalCalculation."Contract Start Date" := Rec."Contract Start Date";
        aFinalCalculation."Contract End Date" := Rec."Contract End Date";
        aFinalCalculation."Unit Type" := Rec."Usage Type";
        aFinalCalculation."Contract Amount" := Rec."Annual Rent Amount";
        aFinalCalculation."Tenant Email" := Rec."Email Address";
        aFinalCalculation."Tenant Name" := Rec."Customer Name";
        aFinalCalculation."Security Deposit" := Rec."Security Balanced Amount";
        aFinalCalculation."Remaining Security Deposit" := Rec."Security Balanced Amount";


        // Add Chiller Deposit
        TenancyContractSubpage.Reset();
        TenancyContractSubpage.SetRange(ContractID, Rec."Contract ID");
        TenancyContractSubpage.SetRange("Secondary Item Type", 'Chiller Deposit');
        if TenancyContractSubpage.FindFirst() then begin

            aFinalCalculation."Chiller Deposit" := TenancyContractSubpage.Amount;
            aFinalCalculation."Remaining Chiller Deposit" := TenancyContractSubpage.Amount;
        end;


        // Add Other Deposit
        TenancyContractSubpage.Reset();
        TenancyContractSubpage.SetRange(ContractID, Rec."Contract ID");
        TenancyContractSubpage.SetRange("Secondary Item Type", 'Other Deposit');
        if TenancyContractSubpage.FindFirst() then begin
            aFinalCalculation."Other Deposit" := TenancyContractSubpage.Amount;
            aFinalCalculation."Remaining Other Deposit" := TenancyContractSubpage.Amount;
        end;


        aFinalCalculation."Total Refundable Deposit" := aFinalCalculation."Security Deposit" + aFinalCalculation."Chiller Deposit" + aFinalCalculation."Other Deposit";
    end;
}
