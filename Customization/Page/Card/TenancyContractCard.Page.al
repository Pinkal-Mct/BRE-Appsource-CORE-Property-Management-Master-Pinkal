page 73209745 "BLRTenancy Contract Card"
{
    PageType = Card;
    ApplicationArea = All;
    SourceTable = "BLRTenancyContract";
    Caption = 'Tenancy Contract';

    layout
    {
        area(content)
        {
            // Group for General Information
            group("General Info")
            {
                Caption = 'General Information';

                field("Contract ID"; rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the tenancy contract.';
                }

                field("Contract Type"; rec."BLRContract Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the type of tenancy contract.';
                    trigger OnValidate()
                    begin

                        UpdateFieldsEnable();
                    end;
                }
                field("Proposal ID"; Rec."BLRProposal ID")
                {
                    ApplicationArea = All;
                    Enabled = ProposalIDEnabled;
                    ToolTip = 'Specifies the unique identifier for the proposal associated with this tenancy contract.';
                    trigger OnValidate()
                    begin
                        // CurrPage.SaveRecord();
                    end;

                }

                field("Renewal Proposal ID"; rec."BLRRenewal Proposal ID")
                {
                    ApplicationArea = All;
                    Enabled = RenewalProposalIDEnabled;
                    ToolTip = 'Specifies the unique identifier for the renewal proposal associated with this tenancy contract.';
                }
                field("Contract Date"; Rec."BLRContract Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the date when the tenancy contract was created.';
                }
            }

            group("Owner / Lessor Information")
            {
                field("Owner's Name"; rec."BLROwner's Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the name of the owner or lessor associated with this tenancy contract.';
                    Editable = false;

                }
                field("Owner ID"; rec."BLROwner ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Specifies the unique identifier for the owner associated with this tenancy contract.';
                }

                field("Lessor's Name"; rec."BLRLessor's Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the name of the lessor associated with this tenancy contract.';
                }

                field("Lessor's Emirates ID"; rec."BLRLessor's Emirates ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the Emirates ID of the lessor associated with this tenancy contract.';
                }

                field("License No."; rec."BLRLicense No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the license number of the owner or lessor associated with this tenancy contract.';
                }

                field("Licensing Authority"; rec."BLRLicensing Authority")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the licensing authority for the owner or lessor associated with this tenancy contract.';
                }

                field("Lessor's Email"; rec."BLRLessor's Email")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the email address of the lessor associated with this tenancy contract.';
                }

                field("Lessor's Phone"; rec."BLRLessor's Phone")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the phone number of the lessor associated with this tenancy contract.';
                }
                field("Lessor's Address"; Rec."BLRLessor's Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the address of the lessor associated with this tenancy contract.';
                }
                field("Lessor's Nationality"; Rec."BLRLessor's Nationality")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the nationality of the lessor associated with this tenancy contract.';
                }
            }

            // Group for Tenant and Customer Information
            group("Tenant & Customer Info")
            {
                Caption = 'Tenant & Customer Information';
                field("Tenant ID"; rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the tenant associated with this tenancy contract.';
                }
                field("Customer Name"; Rec."BLRCustomer Name")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'Enter the name of the tenant associated with this tenancy contract.';
                }
                field("Emirates ID"; rec."BLREmirates ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the Emirates ID of the tenant associated with this tenancy contract.';
                }

                field("Contact Number"; rec."BLRContact Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the contact number of the tenant associated with this tenancy contract.';
                }

                field("Email Address"; rec."BLREmail Address")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the email address of the tenant associated with this tenancy contract.';
                }

                field("Tenant_License No."; Rec."BLRTenant_License No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the license number of the tenant associated with this tenancy contract.';
                }

                field("Tenant_Licensing Authority"; Rec."BLRTenant_Licensing Authority")
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
                field("Property ID"; rec."BLRProperty ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the property associated with this tenancy contract.';
                }
                field("Property Name"; Rec."BLRProperty Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the name of the property associated with this tenancy contract.';
                }
                field("Property Classification"; rec."BLRProperty Classification")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'Select the classification of the property associated with this tenancy contract.';
                }
                field("BLRPropertyType"; rec."BLRProperty Type")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'Select the type of property associated with this tenancy contract.';
                }

                field("Praposal Type Selected"; rec."BLRPraposal Type Selected")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Category';
                    Editable = false;
                    ToolTip = 'Select the type of proposal for the tenancy contract, either Single Unit or Merge Unit.';
                }
                field("Unit ID"; rec."BLRUnit ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the unit associated with this tenancy contract.';
                }

                field("Merge Unit ID"; Rec."BLRMerge Unit ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Lookup = true; // Enable lookup for Unit ID
                    ToolTip = 'Specifies the unique identifier for the merge unit associated with this tenancy contract.';
                }
                field("Unit Name"; Rec."BLRUnit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the name of the unit associated with this tenancy contract.';
                }

                field("Unit Number"; Rec."BLRUnit Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the unit number associated with this tenancy contract.';
                }

                field("Unit Address"; rec."BLRUnit Address")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the address of the unit associated with this tenancy contract.';

                }
                field("Unit Classification"; rec."BLRUsage Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the classification of the unit associated with this tenancy contract.';
                    Editable = false;
                }
                field("Unit Type"; rec."BLRUnit Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Select the type of unit associated with this tenancy contract.';
                }

                field("Uniq Unit ID"; Rec."BLRUnitID") // Auto-generated Unit ID
                {
                    ApplicationArea = All;
                    Caption = 'Uniq Unit ID';
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the unit associated with this tenancy contract.';
                }

                field("Single Unit Name"; Rec."BLRSingle Unit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    MultiLine = true;
                    ToolTip = 'Enter the name of the single unit associated with this tenancy contract.';
                }

                field("Market Rate per Sq. Ft."; rec."BLRMarket Rate per Sq. Ft.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the market rate per square foot for the unit associated with this tenancy contract.';
                }

                field("Ejari Name"; Rec."BLREjari Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the Ejari name associated with this tenancy contract.';
                }
                field("Unit Sq. Feet"; Rec."BLRUnit Sq. Feet")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the square footage of the unit associated with this tenancy contract.';
                }
                field("Property Size"; Rec."BLRProperty Size")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the size of the property associated with this tenancy contract.';
                }

                field("Base Unit of Measure"; rec."BLRBase Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Select the base unit of measure for the property associated with this tenancy contract.';
                }

                field("Makani Number"; Rec."BLRMakani Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the Makani number associated with this tenancy contract.';
                }
                field("Municipality Number"; Rec."BLRMunicipality Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field(Emirate; Rec."BLREmirate")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Select the emirate where the property is located.';
                }

                field(Community; Rec."BLRCommunity")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Select the community where the property is located.';
                }
                field("DEWA Number"; Rec."BLRDEWA Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the DEWA number associated with this tenancy contract.';
                }

                field("Facilities/Amenities"; rec."BLRFacilities/Amenities")
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
                field("Contract Start Date"; Rec."BLRContract Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the start date of the tenancy contract.';
                }
                field("Contract End Date"; Rec."BLRContract End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the end date of the tenancy contract.';
                }
                field("Contract Tenor"; Rec."BLRContract Tenor")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the tenor of the tenancy contract.';
                }

                field("Rent Amount"; Rec."BLRRent Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the rent amount for the tenancy contract.';
                }

                field("Contract VAT %"; Rec."BLRContract VAT %")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the VAT percentage applicable to the tenancy contract.';
                }

                field("Contract VAT Amount"; Rec."BLRContract VAT Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the VAT amount for the tenancy contract.';
                }

                field("Contract Amount Including VAT"; Rec."BLRContAmtInclVAT")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the contract amount including VAT for the tenancy contract.';
                }

                field("Annual Rent Amount"; Rec."BLRAnnual Rent Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the annual rent amount for the tenancy contract.';
                }

                field("Payment Frequency"; rec."BLRPayment Frequency")
                {
                    ApplicationArea = All;
                    Caption = 'Frequency of payment';
                    Editable = false;
                    ToolTip = 'Enter the payment frequency for the tenancy contract.';
                }
                field("Payment Method"; rec."BLRPayment Method")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Mode';
                    Editable = false;
                    ToolTip = 'Enter the payment method for the tenancy contract.';
                }
                field("No of Installments"; rec."BLRNo of Installments")
                {
                    ApplicationArea = All;
                    Caption = 'No of Installments';
                    ToolTip = 'Enter the number of installments for the tenancy contract.';
                }
            }
            part("Additional Terms"; "BLRTC Additional Terms Subpage")
            {
                ApplicationArea = All;
                SubPageLink = "BLRDocument No." = FIELD("BLRContract ID");
                Caption = 'Additional Terms';

            }
            group("BLRSecurityDeposit")
            {
                field("Security Deposit Amount"; Rec."BLRSecurity Deposit Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the security deposit amount for the tenancy contract.';
                }

                field("Security Deposit Amt. Received"; Rec."BLRSecDepAmtReceived")
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
                field("Security Amount Pending"; Rec."BLRSecurity Amount Pending")
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

                field("Security Balanced Amount"; Rec."BLRSecurity Balanced Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Security Deposit Amount Balance';
                    ToolTip = 'Enter the balanced amount of the security deposit for the tenancy contract.';
                }
                field("Carry Forward In"; Rec."BLRCarry Forward In")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the amount carried forward from the previous tenancy contract.';
                }
                field("Carry Forward Out"; Rec."BLRCarry Forward Out")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the amount carried forward to the next tenancy contract.';
                }
                field(Adjustments; Rec.BLRAdjustments)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter any adjustments made to the security deposit for the tenancy contract.';
                }
                field(Refund; Rec.BLRRefund)
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

                field("Grace Start Date"; Rec."BLRGrace Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the start date of the grace period for the tenancy contract.';
                }
                field("Grace End Date"; Rec."BLRGrace End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the end date of the grace period for the tenancy contract.';
                }
                field("Grace Period"; Rec."BLRGrace Period")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the duration of the grace period for the tenancy contract.';
                }

                field("Handover is Completed"; rec."BLRHandover is Completed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether the handover of the property has been completed.';
                }

                field("Handover of PDC"; rec."BLRHandover of PDC")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether the post-dated cheques (PDC) have been handed over.';
                }
                field("Signed TC Document"; rec."BLRSigned TC Document")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether the signed tenancy contract document has been uploaded.';
                }
                field("Handover Unit"; rec."BLRHandover Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether the unit has been handed over to the tenant.';
                }

                field("Single Rent Calculation"; Rec."BLRSingle Rent Calculation")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Select the type of rent calculation for single units, either with lumpsum square feet rate or with square feet rate.';
                    trigger OnValidate()
                    begin
                        UpdateVisibility();
                    end;
                }

                field("Merge Rent Calculation"; Rec."BLRMerge Rent Calculation")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Select the type of rent calculation for merged units, either with differential square feet rate, lumpsum annual amount, or same square feet.';
                    trigger OnValidate()
                    begin
                        UpdateVisibility();
                    end;
                }


                field("Upload Document"; Rec."BLRUpload Document")
                {
                    ToolTip = 'Upload a document related to the tenancy contract.';
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        azureBlobUploader: Codeunit "BLRAzure AD Blob Storage";
                        fileName: Text;
                        uploadResult: Text;
                        folderName: Text;
                    begin
                        folderName := 'TenancyContractDocuments';
                        fileName := azureBlobUploader.ValidateDocument(uploadResult, folderName);
                        if fileName <> '' then begin
                            Rec."BLRUpload Document" := CopyStr(fileName, 1, StrLen(fileName));
                            Rec."BLRview Document" := copyStr(uploadResult, 1, StrLen(uploadResult));
                            Rec.Modify();
                            Message('File uploaded successfully: %1', fileName);
                        end;
                    end;
                }

                field("view Document"; Rec."BLRview Document")
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
                        FileURL := Rec."BLRview Document";

                        // Check if the file URL is not empty
                        if FileURL = '' then
                            Error('No document is available to view.');

                        // Open the file URL in the browser (new tab)
                        OpenFileInBrowser(FileURL);
                    end;
                }

                field("Renewal Contract Status"; rec."BLRRenewal Contract Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Indicates the status of the renewal contract associated with this tenancy contract.';
                }

                field("Created By"; rec."BLRCreated By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who created this tenancy contract.';
                }

                field("Renewal Notification to Tenant"; rec."BLRRenewalNotiftoTenant")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether a renewal notification has been sent to the tenant for this tenancy contract.';
                }

                field("Tenant Loyalty Check Reminder"; rec."BLRTenantLoyaltyCheckReminder")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether a reminder for tenant loyalty check has been set for this tenancy contract.';
                }

                field("Payment Reminder"; rec."BLRPayment Reminder")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates whether a payment reminder has been set for this tenancy contract.';
                }

            }
            group("Lease Unit Details")
            {
                Caption = 'Unit Details';
                part("Unit all Details"; "BLRSub Lease Merged Units Card")
                {
                    SubPageLink = "BLRMerge Unit ID" = FIELD("BLRMerge Unit ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = Rec."BLRPraposal Type Selected" = Rec."BLRPraposal Type Selected"::"Merge Unit"; // Visible when "Praposal Type Selected" is "Merge Unit"
                }
            }

            group("Single Unit with lumpsum square feet rate")
            {
                Caption = 'Single Unit with lumpsum square feet rate';
                Visible = ShowLegalReasonFields3;

                part("Single Unit lumpsum Rent (Renewal)"; "BLRTCSingleLumAnnualAmntSP")
                {
                    SubPageLink = "BLRID" = FIELD("BLRRenewal Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."BLRRenewal Proposal ID" <> 0); // Show only if Renewal Proposal ID is set

                }
                part("Single Unit lumpsum Rent (Proposal)"; "BLRTCSingleLumAnnualAmntSP")
                {
                    SubPageLink = "BLRID" = FIELD("BLRProposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."BLRRenewal Proposal ID" = 0); // Show only if Renewal Proposal ID is empty

                }
            }


            group("Single Unit with square feet rate")
            {
                Caption = 'Single Unit With Square Feet Rate';
                Visible = ShowLegalReasonFields;

                // Part for Renewal Proposal ID
                part("Single Unit Rent (Renewal)"; "BLRTCSingleUnitRentSubPage")
                {
                    SubPageLink = "BLRID" = FIELD("BLRRenewal Proposal ID"); // Uses Renewal Proposal ID
                    ApplicationArea = All;
                    Visible = (Rec."BLRRenewal Proposal ID" <> 0); // Show only if Renewal Proposal ID is set
                }

                // Part for Proposal ID (Fallback)
                part("Single Unit Rent (Proposal)"; "BLRTCSingleUnitRentSubPage")
                {
                    SubPageLink = "BLRID" = FIELD("BLRProposal ID"); // Uses Proposal ID if Renewal is empty
                    ApplicationArea = All;
                    Visible = (Rec."BLRRenewal Proposal ID" = 0); // Show only if Renewal Proposal ID is empty
                }
            }
            group("Merged Unit with same square feet")
            {
                Caption = 'Merged Unit With Same Square Feet';
                Visible = ShowBusinessReasonFields;
                part("Merge SameSqure Rent (Renewal)"; "BLRTCMergeSameSqureSubPage")
                {
                    SubPageLink = "BLRID" = FIELD("BLRRenewal Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."BLRRenewal Proposal ID" <> 0); // Show only if Renewal Proposal ID is set

                }

                part("Merge SameSqure Rent (Proposal)"; "BLRTCMergeSameSqureSubPage")
                {
                    SubPageLink = "BLRID" = FIELD("BLRProposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."BLRRenewal Proposal ID" = 0); // Show only if Renewal Proposal ID is empty

                }
            }
            group("Merged Unit with differential square feet rate")
            {
                Caption = 'Merged Unit With Differential Square Feet Rate';
                Visible = ShowLegalReasonFields1;
                part("Merge DifferentSqure Rent (Renewal)"; "BLRTCMergeDifferentSqSubPage")
                {
                    SubPageLink = "BLRID" = FIELD("BLRRenewal Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."BLRRenewal Proposal ID" <> 0);

                }

                part("Merge DifferentSqure Rent (Proposal)"; "BLRTCMergeDifferentSqSubPage")
                {
                    SubPageLink = "BLRID" = FIELD("BLRProposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."BLRRenewal Proposal ID" = 0);
                }
            }
            group("Merged Unit with lumpsum annual amount")
            {
                Caption = 'Merged Unit With Lumpsum Annual Amount';
                Visible = ShowBusinessReasonFields2;
                part("Merge Lum_AnnualAmount Rent (Renewal)"; "BLRTC MergeLum_AnnualAmountSP")
                {
                    SubPageLink = "BLRID" = FIELD("BLRRenewal Proposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."BLRRenewal Proposal ID" <> 0);
                }

                part("Merge Lum_AnnualAmount Rent (Proposal)"; "BLRTC MergeLum_AnnualAmountSP")
                {
                    SubPageLink = "BLRID" = FIELD("BLRProposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = (Rec."BLRRenewal Proposal ID" = 0);
                }
            }

            group("Per Day Rent for Revenue Allocation")
            {
                Caption = 'Per Day Rent for Revenue Allocation';

                //  Show for Renewal Proposal if "Praposal Type Selected" = "Merge Unit"
                part("Per Day Rent (Renewal)"; "BLRTC PerDayRentforRevenueCard")
                {
                    SubPageLink = "BLRContract Renewal ID" = FIELD("BLRRenewal Proposal ID"); // Link to Renewal Proposal ID
                    ApplicationArea = All;
                    Visible = (Rec."BLRRenewal Proposal ID" <> 0) and
                  (Rec."BLRPraposal Type Selected" = Rec."BLRPraposal Type Selected"::"Merge Unit");
                }

                //  Show for Normal Proposal if "Praposal Type Selected" = "Merge Unit"
                part("Per Day Rent (Proposal)"; "BLRTC PerDayRentforRevenueCard")
                {
                    SubPageLink = "BLRProposal ID" = FIELD("BLRProposal ID"); // Link to Proposal ID
                    ApplicationArea = All;
                    Visible = (Rec."BLRRenewal Proposal ID" = 0) and
                  (Rec."BLRPraposal Type Selected" = Rec."BLRPraposal Type Selected"::"Merge Unit");
                }
            }
            group("BLRRentCalculation")
            {
                field("Update Data"; Rec."BLRUpdate Data")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    ToolTip = 'Drill down to the Rent Calculation record for this tenancy contract.';

                    trigger OnDrillDown()
                    var
                        RentRecord: Record "BLRRentCalculation";
                        Tenancycontract: Record "BLRTenancyContract";
                        SU_samesquare: Record "BLRTCSingleUnitRentSubPage";
                        SU_lumpsum: Record "BLRTCSingleLumAnnualAmntSP";
                        MU_samesquare: Record "BLRTCMergeSameSqureSubPage";
                        MU_differentsquare: Record "BLRTCMergeDifferentSqSubPage";
                        MU_lumpsum: Record "BLRTCMergeLumAnnualAmountSP";
                        RentSubpage: Record "BLRRentCalculationSubpage";
                        fetchMonth: Codeunit "BLRFetch Month";
                        yearlyInstallment: Integer;
                        Lastyear: Integer;
                        RentRecordid: Integer;
                        SingleUnitName: Text;
                        CommaPos: Integer;
                    begin
                        // Find the Tenancy Contract record
                        Tenancycontract.SetRange("BLRContract ID", Rec."BLRContract ID");
                        Tenancycontract.SetRange("BLRTenant ID", Rec."BLRTenant ID");
                        if Tenancycontract.FindFirst() then begin
                            // Set fields for RentCalculation record
                            RentRecord."BLRContract ID" := Tenancycontract."BLRContract ID";
                            RentRecord."BLRProperty Classification" := Tenancycontract."BLRProperty Classification";
                            RentRecord."BLRContract Start Date" := Tenancycontract."BLRContract Start Date";
                            RentRecord."BLRContract End Date" := Tenancycontract."BLRContract End Date";
                            RentRecord."BLRAmount" := Round(Tenancycontract."BLRAnnual Rent Amount");
                            RentRecord."BLRTenant ID" := Tenancycontract."BLRTenant ID";
                            RentRecord."BLRSecondary Item Type" := 'Rent';
                            RentRecord."BLRVAT Amount" := Round(Tenancycontract."BLRContract VAT Amount");
                            RentRecord."BLRAmount Including VAT" := Round(Tenancycontract."BLRContAmtInclVAT");
                            RentRecord."BLRNumber of Installments" := Tenancycontract."BLRNo of Installments";
                            RentRecord."BLRVAT %" := Tenancycontract."BLRContract VAT %";

                            // Check if Rent Calculation exists, then modify or insert
                            RentRecord.SetRange("BLRContract ID", Rec."BLRContract ID"); // Ensure you're looking for the correct Contract ID

                            if RentRecord.FindFirst() then begin
                                RentRecord."BLRContract ID" := Tenancycontract."BLRContract ID";
                                RentRecord."BLRProperty Classification" := Tenancycontract."BLRProperty Classification";
                                RentRecord."BLRContract Start Date" := Tenancycontract."BLRContract Start Date";
                                RentRecord."BLRContract End Date" := Tenancycontract."BLRContract End Date";
                                RentRecord."BLRAmount" := Round(Tenancycontract."BLRAnnual Rent Amount");
                                RentRecord."BLRTenant ID" := Tenancycontract."BLRTenant ID";
                                RentRecord."BLRSecondary Item Type" := 'Rent';
                                RentRecord."BLRVAT Amount" := Round(Tenancycontract."BLRContract VAT Amount");
                                RentRecord."BLRAmount Including VAT" := Round(Tenancycontract."BLRContAmtInclVAT");
                                RentRecord."BLRNumber of Installments" := Tenancycontract."BLRNo of Installments";
                                RentRecord."BLRVAT %" := Tenancycontract."BLRContract VAT %";
                                RentRecord.Modify();
                                Message('Record Modified Successfully');
                                exit;
                            end else begin
                                // If Rent Calculation doesn't exist, insert a new one
                                RentRecord.Init();
                                RentRecord."BLRContract ID" := Tenancycontract."BLRContract ID";
                                RentRecord."BLRProperty Classification" := Tenancycontract."BLRProperty Classification";
                                RentRecord."BLRContract Start Date" := Tenancycontract."BLRContract Start Date";
                                RentRecord."BLRContract End Date" := Tenancycontract."BLRContract End Date";
                                RentRecord."BLRAmount" := Round(Tenancycontract."BLRAnnual Rent Amount");
                                RentRecord."BLRTenant ID" := Tenancycontract."BLRTenant ID";
                                RentRecord."BLRSecondary Item Type" := 'Rent';
                                RentRecord."BLRVAT Amount" := Round(Tenancycontract."BLRContract VAT Amount");
                                RentRecord."BLRAmount Including VAT" := Round(Tenancycontract."BLRContAmtInclVAT");
                                RentRecord."BLRNumber of Installments" := Tenancycontract."BLRNo of Installments";
                                RentRecord."BLRVAT %" := Tenancycontract."BLRContract VAT %";

                                // Handle Rent Calculation Type assignment
                                if Tenancycontract."BLRSingle Rent Calculation" = Tenancycontract."BLRSingle Rent Calculation"::"Single Unit with lumpsum square feet rate" then
                                    RentRecord."BLRRent Calculation Type" := Format(Tenancycontract."BLRSingle Rent Calculation")
                                else
                                    if Tenancycontract."BLRSingle Rent Calculation" = Tenancycontract."BLRSingle Rent Calculation"::"Single Unit with square feet rate" then
                                        RentRecord."BLRRent Calculation Type" := Format(Tenancycontract."BLRSingle Rent Calculation")
                                    else
                                        if Tenancycontract."BLRMerge Rent Calculation" = Tenancycontract."BLRMerge Rent Calculation"::"Merged Unit with differential square feet rate" then
                                            RentRecord."BLRRent Calculation Type" := Format(Tenancycontract."BLRMerge Rent Calculation")
                                        else
                                            if Tenancycontract."BLRMerge Rent Calculation" = Tenancycontract."BLRMerge Rent Calculation"::"Merged Unit with lumpsum annual amount" then
                                                RentRecord."BLRRent Calculation Type" := Format(Tenancycontract."BLRMerge Rent Calculation")
                                            else
                                                if Tenancycontract."BLRMerge Rent Calculation" = Tenancycontract."BLRMerge Rent Calculation"::"Merged Unit with same square feet" then
                                                    RentRecord."BLRRent Calculation Type" := Format(Tenancycontract."BLRMerge Rent Calculation")
                                                else
                                                    Error('No valid Rent Calculation Type found in Tenancy Contract.');
                                // Insert the new Rent Calculation record
                                RentRecord.Insert();
                            end;
                            // Update data in Revenue Structure Subpage for Single Rent Calculation
                            if Tenancycontract."BLRSingle Rent Calculation" = Tenancycontract."BLRSingle Rent Calculation"::"Single Unit with lumpsum square feet rate" then begin
                                SU_lumpsum.SetRange("BLRContract Id", Tenancycontract."BLRContract Id");
                                if SU_lumpsum.FindSet() then
                                    repeat
                                        if not RentSubpage.Get(RentRecord."BLRRC ID", SU_lumpsum."BLRSL_Year") then begin
                                            RentSubpage.Init();
                                            RentSubpage."BLRRC ID" := RentRecord."BLRRC ID";
                                            RentSubpage."BLRContract ID" := RentRecord."BLRContract ID";
                                            RentSubpage."BLRTenant Id" := RentRecord."BLRTenant ID";
                                            RentSubpage."BLRSecondary Item Type" := RentRecord."BLRSecondary Item Type";
                                            RentSubpage."BLRVAT %" := RentRecord."BLRVAT %";
                                            RentSubpage."BLRPropety Classification" := RentRecord."BLRProperty Classification";
                                            RentSubpage."BLRVAT Amount" := RentRecord."BLRVAT Amount";
                                            RentSubpage."BLRAmount Including VAT" := RentRecord."BLRAmount Including VAT";
                                            RentSubpage."BLRYear" := SU_lumpsum."BLRSL_Year";
                                            RentSubpage."BLRPeriod Start Date" := SU_lumpsum."BLRSL_Start Date";
                                            RentSubpage."BLRPeriod End Date" := SU_lumpsum."BLRSL_End Date";
                                            RentSubpage."BLRNumber of Days" := SU_lumpsum."BLRSL_Number of Days";
                                            RentSubpage."BLRPer Day Rent" := SU_lumpsum."BLRSL_Per Day Rent";
                                            RentSubpage."BLRFinal Annual Amount" := SU_lumpsum."BLRSL_Final Annual Amount";
                                            RentSubpage."BLRUnit ID" := SU_lumpsum."BLRSL_Unit ID";
                                            RentSubpage.Insert();
                                            Clear(RentSubpage);
                                        end
                                    until SU_lumpsum.Next() = 0
                                else
                                    Error('No data found in Single Unit with lumpsum square feet rate subpage for Contract ID %1.', Tenancycontract."BLRContract ID");
                            end
                            else
                                if Tenancycontract."BLRSingle Rent Calculation" = Tenancycontract."BLRSingle Rent Calculation"::"Single Unit with square feet rate" then begin
                                    SU_samesquare.SetRange("BLRContract Id", Tenancycontract."BLRContract ID");
                                    if SU_samesquare.FindSet() then
                                        repeat
                                            if not RentSubpage.Get(RentRecord."BLRRC ID", SU_samesquare."BLRYear") then begin
                                                RentSubpage.Init();
                                                RentSubpage."BLRRC ID" := RentRecord."BLRRC ID";
                                                RentSubpage."BLRContract ID" := RentRecord."BLRContract ID";
                                                RentSubpage."BLRTenant Id" := RentRecord."BLRTenant ID";
                                                RentSubpage."BLRSecondary Item Type" := RentRecord."BLRSecondary Item Type";
                                                RentSubpage."BLRVAT %" := RentRecord."BLRVAT %";
                                                RentSubpage."BLRVAT Amount" := RentRecord."BLRVAT Amount";
                                                RentSubpage."BLRPropety Classification" := RentRecord."BLRProperty Classification";
                                                RentSubpage."BLRAmount Including VAT" := RentRecord."BLRAmount Including VAT";
                                                RentSubpage."BLRYear" := SU_samesquare."BLRYear";
                                                RentSubpage."BLRPeriod Start Date" := SU_samesquare."BLRStart Date";
                                                RentSubpage."BLRPeriod End Date" := SU_samesquare."BLREnd Date";
                                                RentSubpage."BLRNumber of Days" := SU_samesquare."BLRNumber of Days";
                                                RentSubpage."BLRPer Day Rent" := SU_samesquare."BLRPer Day Rent";
                                                RentSubpage."BLRFinal Annual Amount" := SU_samesquare."BLRFinal Annual Amount";
                                                RentSubpage."BLRUnit ID" := SU_samesquare."BLRUnit ID";

                                                RentSubpage.Insert();
                                                Clear(RentSubpage);
                                            end
                                        until SU_samesquare.Next() = 0
                                    else
                                        Error('No data found in Single Unit with square feet rate subpage for Contract ID %1.', Tenancycontract."BLRContract ID");
                                end

                                else
                                    if Tenancycontract."BLRMerge Rent Calculation" = Tenancycontract."BLRMerge Rent Calculation"::"Merged Unit with differential square feet rate" then begin
                                        // Find the Tenancy Contract record
                                        Tenancycontract.SetRange("BLRContract Id", Rec."BLRContract Id");
                                        if Tenancycontract.FindFirst() then begin
                                            SingleUnitName := Tenancycontract."BLRSingle Unit Name";
                                            CommaPos := StrPos(SingleUnitName, ','); // Find the position of the first comma
                                            if CommaPos > 0 then
                                                SingleUnitName := CopyStr(SingleUnitName, 1, CommaPos - 1) // Trim to the first name
                                            else
                                                SingleUnitName := SingleUnitName; // No comma, use the whole name

                                            // Find the first unit's details in Merge DifferentSquare table
                                            MU_differentsquare.SetRange("BLRContract ID", Tenancycontract."BLRContract ID");
                                            if MU_differentsquare.FindSet() then
                                                repeat
                                                    // Update Revenue Structure Subpage
                                                    if not RentSubpage.Get(RentRecord."BLRRC ID", MU_differentsquare."BLRMD_Year") then begin
                                                        RentSubpage.Init();
                                                        RentSubpage."BLRRC ID" := RentRecord."BLRRC ID";
                                                        RentSubpage."BLRContract ID" := RentRecord."BLRContract ID";
                                                        RentSubpage."BLRTenant Id" := RentRecord."BLRTenant ID";
                                                        RentSubpage."BLRSecondary Item Type" := RentRecord."BLRSecondary Item Type";
                                                        RentSubpage."BLRVAT %" := RentRecord."BLRVAT %";
                                                        RentSubpage."BLRPropety Classification" := RentRecord."BLRProperty Classification";
                                                        RentSubpage."BLRVAT Amount" := RentRecord."BLRVAT Amount";
                                                        RentSubpage."BLRAmount Including VAT" := RentRecord."BLRAmount Including VAT";
                                                        RentSubpage."BLRYear" := MU_differentsquare."BLRMD_Year";
                                                        RentSubpage."BLRPeriod Start Date" := MU_differentsquare."BLRMD_Start Date";
                                                        RentSubpage."BLRPeriod End Date" := MU_differentsquare."BLRMD_End Date";
                                                        RentSubpage."BLRNumber of Days" := MU_differentsquare."BLRMD_Number of Days";
                                                        RentSubpage."BLRPer Day Rent" := MU_differentsquare."BLRMD_Per Day Rent";
                                                        RentSubpage."BLRFinal Annual Amount" := MU_differentsquare."BLRMD_Final Annual Amount";
                                                        RentSubpage."BLRUnit ID" := MU_differentsquare."BLRMD_Unit ID";

                                                        RentSubpage.Insert();
                                                        Clear(RentSubpage);
                                                    end
                                                until MU_differentsquare.Next() = 0
                                            else
                                                Error('No data found for Unit Name: %1 in Contract ID: %2.', SingleUnitName, Tenancycontract."BLRContract ID");
                                        end
                                        else
                                            Error('Tenancy Contract not found for Contract ID: %1.', Rec."BLRContract ID");
                                    end
                                    else
                                        if Tenancycontract."BLRMerge Rent Calculation" = Tenancycontract."BLRMerge Rent Calculation"::"Merged Unit with lumpsum annual amount" then begin
                                            MU_lumpsum.SetRange("BLRContract ID", Tenancycontract."BLRContract ID");
                                            if MU_lumpsum.FindSet() then
                                                repeat
                                                    if not RentSubpage.Get(RentRecord."BLRRC ID", MU_lumpsum."BLRML_Year") then begin
                                                        RentSubpage.Init();
                                                        RentSubpage."BLRRC ID" := RentRecord."BLRRC ID";
                                                        RentSubpage."BLRContract ID" := RentRecord."BLRContract ID";
                                                        RentSubpage."BLRTenant Id" := RentRecord."BLRTenant ID";
                                                        RentSubpage."BLRSecondary Item Type" := RentRecord."BLRSecondary Item Type";
                                                        RentSubpage."BLRVAT %" := RentRecord."BLRVAT %";
                                                        RentSubpage."BLRPropety Classification" := RentRecord."BLRProperty Classification";
                                                        RentSubpage."BLRVAT Amount" := RentRecord."BLRVAT Amount";
                                                        RentSubpage."BLRAmount Including VAT" := RentRecord."BLRAmount Including VAT";
                                                        RentSubpage."BLRYear" := MU_lumpsum."BLRML_Year";
                                                        RentSubpage."BLRPeriod Start Date" := MU_lumpsum."BLRML_Start Date";
                                                        RentSubpage."BLRPeriod End Date" := MU_lumpsum."BLRML_End Date";
                                                        RentSubpage."BLRNumber of Days" := MU_lumpsum."BLRML_Number of Days";
                                                        RentSubpage."BLRPer Day Rent" := MU_lumpsum."BLRML_Per Day Rent";
                                                        RentSubpage."BLRFinal Annual Amount" := MU_lumpsum."BLRML_Final Annual Amount";
                                                        RentSubpage."BLRUnit ID" := MU_lumpsum."BLRML_Unit ID";

                                                        RentSubpage.Insert();
                                                        Clear(RentSubpage);
                                                    end
                                                until MU_lumpsum.Next() = 0
                                            else
                                                Error('No data found in Merged Unit with lumpsum annual amount subpage for Contract ID %1.', Tenancycontract."BLRContract ID");
                                        end
                                        else
                                            if Tenancycontract."BLRMerge Rent Calculation" = Tenancycontract."BLRMerge Rent Calculation"::"Merged Unit with same square feet" then begin
                                                MU_samesquare.SetRange("BLRContract ID", Tenancycontract."BLRContract ID");
                                                if MU_samesquare.FindSet() then
                                                    repeat
                                                        if not RentSubpage.Get(RentRecord."BLRRC ID", MU_samesquare."BLRMS_Year") then begin
                                                            RentSubpage.Init();
                                                            RentSubpage."BLRRC ID" := RentRecord."BLRRC ID";
                                                            RentSubpage."BLRContract ID" := RentRecord."BLRContract ID";
                                                            RentSubpage."BLRTenant Id" := RentRecord."BLRTenant ID";
                                                            RentSubpage."BLRSecondary Item Type" := RentRecord."BLRSecondary Item Type";
                                                            RentSubpage."BLRVAT %" := RentRecord."BLRVAT %";
                                                            RentSubpage."BLRVAT Amount" := RentRecord."BLRVAT Amount";
                                                            RentSubpage."BLRPropety Classification" := RentRecord."BLRProperty Classification";
                                                            RentSubpage."BLRAmount Including VAT" := RentRecord."BLRAmount Including VAT";
                                                            RentSubpage."BLRYear" := MU_samesquare."BLRMS_Year";
                                                            RentSubpage."BLRPeriod Start Date" := MU_samesquare."BLRMS_Start Date";
                                                            RentSubpage."BLRPeriod End Date" := MU_samesquare."BLRMS_End Date";
                                                            RentSubpage."BLRNumber of Days" := MU_samesquare."BLRMS_Number of Days";
                                                            RentSubpage."BLRPer Day Rent" := MU_samesquare."BLRMS_Per Day Rent";
                                                            RentSubpage."BLRUnit ID" := MU_samesquare."BLRMS_Unit ID";

                                                            RentSubpage."BLRFinal Annual Amount" := MU_samesquare."BLRMS_Final Annual Amount";
                                                            RentSubpage.Insert();
                                                            Clear(RentSubpage);
                                                        end
                                                    until MU_samesquare.Next() = 0
                                                else
                                                    Error('No data found in Merged Unit with same square feet subpage for Contract ID %1.', Tenancycontract."BLRContract ID");
                                            end;

                            RentSubpage.SetRange("BLRRC ID", RentRecord."BLRRC ID");
                            RentSubpage.SetRange("BLRContract ID", RentRecord."BLRContract ID");
                            RentSubpage.SetCurrentKey(BLRYear);
                            if RentSubpage.FindLast() then begin
                                Lastyear := RentSubpage."BLRYear";
                                Clear(RentSubpage);
                                RentSubpage.SetRange("BLRRC ID", RentRecord."BLRRC ID");
                                RentSubpage.SetRange("BLRContract ID", RentRecord."BLRContract ID");
                                if RentSubpage.FindSet() then
                                    repeat
                                        yearlyInstallment := 12 / fetchMonth.GetNoofMonthsFromFrequency(Format(Rec."BLRPayment Frequency"));

                                        if Rec."BLRNo of Installments" > yearlyInstallment then begin
                                            if RentSubpage."BLRYear" = Lastyear then
                                                RentSubpage."BLRYearly No. of Installment" := Rec."BLRNo of Installments" - (yearlyInstallment * (Lastyear - 1))
                                            else
                                                RentSubpage."BLRYearly No. of Installment" := yearlyInstallment;
                                        end
                                        else
                                            if Rec."BLRNo of Installments" < yearlyInstallment then
                                                RentSubpage."BLRYearly No. of Installment" := Rec."BLRNo of Installments"
                                            else
                                                RentSubpage."BLRYearly No. of Installment" := yearlyInstallment;

                                        RentSubpage.Modify(true);
                                    until RentSubpage.Next() = 0;
                            end;
                            Message('New record has been created in Rent Calculation and subpage updated successfully.');
                        end;

                        RentRecord.SetRange("BLRContract ID", Rec."BLRContract ID");
                        RentRecord.SetRange("BLRTenant ID", Rec."BLRTenant ID");

                        if RentRecord.FindSet() then
                            RentRecordid := RentRecord."BLRRC ID"
                        else begin
                            // If no record is found, create a new Revenue Structure record
                            RentRecord.Init();
                            RentRecord.Insert(true);
                            RentRecord.Modify(true);  // Insert the new record and generate the RS ID

                            // Get the newly created RS ID
                            RentRecordid := RentRecord."BLRRC ID";
                        end;
                        Rec."BLRRent Calculation Link" := RentRecordid;
                    end;

                }

                field("Rent Calculation Link"; Rec."BLRRent Calculation Link")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    ToolTip = 'Drill down to the Rent Calculation record for this tenancy contract.';

                    trigger OnDrillDown()
                    var
                        RentCalculation: Record "BLRRentCalculation";

                    begin
                        // Navigate to the Revenue Structure Card page
                        if RentCalculation.Get(Rec."BLRRent Calculation Link") then
                            PAGE.RUN(PAGE::"BLRRent Calculation Card", RentCalculation)
                        else
                            Message('The related Revenue Structure does not exist.')
                    end;

                }

            }
            group("Other Payments")
            {
                part("Revenues"; "BLRTenancy ContractSubPageCard")
                {
                    SubPageLink = BLRContractID = FIELD("BLRContract ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                }
            }

            group("Contract Status")  // Add a separate group for clarity
            {
                field("Update Contract Status"; Rec."BLRUpdate Contract Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the status to update the contract.';
                    trigger OnValidate()
                    begin
                        // Check if "Update Contract Status" has a value other than its default (e.g., <Blank>)
                        if Rec."BLRUpdate Contract Status" <> Rec."BLRUpdate Contract Status"::" " then
                            Rec."BLRYes/No" := true
                        else
                            Rec."BLRYes/No" := false;
                    end;
                }

                field("Tenant Contract Status"; rec."BLRTenant Contract Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The current status of the tenancy contract.';

                    trigger OnValidate()
                    var

                    begin
                        // Check if the contract status is either "Terminated" or "Renewed"
                        if (Rec."BLRTenant Contract Status" = Rec."BLRTenant Contract Status"::"Terminated") or
                           (Rec."BLRTenant Contract Status" = Rec."BLRTenant Contract Status"::"Contract Renewed") then
                            IsVisible := true  // Link should be visible
                        else
                            IsVisible := false; // Link should be hidden

                    end;
                }

                field("Previous Status"; Rec."BLRPrevious Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'The previous status of the tenancy contract.';
                }

                group(FinalCalculation)
                {
                    Visible = IsVisible;
                    ShowCaption = false;
                    field("BLRFinalCalculation"; rec."BLRFinal Calculation")
                    {
                        ToolTip = 'Drill down to the Final Calculation record for this tenancy contract.';
                        ApplicationArea = All;
                        DrillDown = true;
                        // Show or hide based on status

                        trigger OnDrillDown()
                        var

                            FinalCalculation: Record "BLRFinalCalculation";
                            TenancyContractSubpage: Record "BLRTenancyContractSubpage";
                            FinalSettlementRefund: Record BLRFinalSettlementRefund;
                            FinalSettlement: Record BLRFinalSettlement;
                            StartDate: Date;
                            EndDate: Date;
                            DaysDiff: Integer;

                            FinalCalculationid: Integer;
                        begin
                            FinalCalculation.SetRange("BLRContract ID", Rec."BLRContract ID");
                            FinalCalculation.SetRange("BLRTenant ID", Rec."BLRTenant ID");

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
                            StartDate := Rec."BLRContract Start Date";
                            EndDate := Rec."BLRContract End Date";
                            DaysDiff := EndDate - StartDate + 1;
                            FinalCalculation."BLROriginal Contract Tenure" := DaysDiff;
                            FinalCalculation.Modify(true);

                            FinalCalculation.SetRange("BLRContract ID", Rec."BLRContract ID");
                            FinalCalculation.SetRange("BLRTenant ID", Rec."BLRTenant ID");

                            if FinalCalculation.FindSet() then
                                FinalCalculationid := FinalCalculation."BLRFC ID"
                            else begin
                                // If no record is found, create a new Revenue Structure record
                                FinalCalculation.Init();
                                FinalCalculation.Insert(true);
                                FinalCalculation.Modify(true);  // Insert the new record and generate the RS ID

                                // Get the newly created RS ID
                                FinalCalculationid := FinalCalculation."BLRFC ID";
                            end;
                            Rec."BLRLink" := FinalCalculationid;

                            // Add this new section to populate the Final Settlement Refund grid
                            FinalSettlementRefund.SetRange("BLRFC ID", FinalCalculationid);
                            if FinalSettlementRefund.FindSet() then
                                repeat
                                    FinalSettlementRefund."BLRContract ID" := Rec."BLRContract ID";
                                    FinalSettlementRefund.Modify(true);
                                until FinalSettlementRefund.Next() = 0
                            else begin
                                // If you want to create a new record when none exists
                                FinalSettlementRefund.Init();
                                FinalSettlementRefund."BLRFC ID" := FinalCalculationid;
                                FinalSettlementRefund."BLRContract ID" := Rec."BLRContract ID";
                                FinalSettlementRefund.Insert(true);
                                Clear(FinalSettlementRefund);
                            end;

                            // Add this new section to populate the Final Settlement Refund grid
                            FinalSettlement.SetRange("BLRFC ID", FinalCalculationid);
                            if FinalSettlement.FindSet() then
                                repeat
                                    FinalSettlement."BLRContract ID" := Rec."BLRContract ID";
                                    FinalSettlement."BLRTenant Email" := CopyStr(Rec."BLREmail Address", 1, strlen(Rec."BLREmail Address"));
                                    FinalSettlement."BLRTenant Name" := Rec."BLRCustomer Name";
                                    FinalSettlement.Modify(true);
                                until FinalSettlement.Next() = 0
                            else begin
                                // If you want to create a new record when none exists
                                FinalSettlement.Init();
                                FinalSettlement."BLRFC ID" := FinalCalculationid;
                                FinalSettlement."BLRContract ID" := Rec."BLRContract ID";
                                FinalSettlement."BLRTenant Email" := CopyStr(Rec."BLREmail Address", 1, strlen(Rec."BLREmail Address"));
                                FinalSettlement."BLRTenant Name" := Rec."BLRCustomer Name";
                                FinalSettlement.Insert(true);
                                Clear(FinalSettlement);
                            end;
                        end;
                    }



                    field("Link"; Rec."BLRLink")
                    {
                        ApplicationArea = All;
                        DrillDown = true;
                        ToolTip = 'Click to open the Final Calculation Card';

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
                }
                field("Suspended Reason list"; Rec."BLRSuspended Reason list")
                {
                    ApplicationArea = All;
                    ToolTip = 'Click to open the Suspended Reason List.';
                    Style = Strong; // Makes the field look like a hyperlink
                    StyleExpr = true;

                    trigger OnAssistEdit()
                    var
                        SuspendedReasonRec: Record "BLRSuspendReasonTable";
                    begin
                        // Filter the Suspended Reason List page by the current Contract ID
                        SuspendedReasonRec.SetRange("BLRContract ID", Rec."BLRContract ID");
                        Page.Run(Page::"BLRSuspendReasonList", SuspendedReasonRec);
                    end;
                }

            }

            group("WorkflowFrequencys")
            {
                Visible = false;
                part("BLRWorkflowFrequency"; "BLRWorkflow Frequency PR Card")
                {
                    SubPageLink = "BLRProperty ID" = FIELD("BLRProperty ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                }
            }

            group("Brokers and Commission Agent Details")
            {
                field("Vendor ID"; Rec."BLRVendor ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Click to open the Vendor Card';
                }

                field("Vendor Name"; Rec."BLRVendor Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Click to open the Vendor Card';
                }

                field("Start Date"; Rec."BLRStart Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The start date of the tenancy contract.';
                }

                field("End Date"; Rec."BLREnd Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The end date of the tenancy contract.';
                }

                field("Calculation Method"; Rec."BLRCalculation Method")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The calculation method of the tenancy contract.';
                }

                field("Percentage Type"; Rec."BLRPercentage Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The percentage type of the tenancy contract.';
                }

                field("Percentage"; Rec."BLRPercentage")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The percentage of the tenancy contract.';
                }

                field("Amount"; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The amount of the tenancy contract.';
                }

                field("Base Amount Type"; Rec."BLRBase Amount Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The base amount type of the tenancy contract.';
                }
                field("Frequency Of Payment"; Rec."BLRFrequency Of Payment")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The frequency of payment of the tenancy contract.';
                }

                field("ContractStatus"; Rec."BLRContract Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'The status of the tenancy contract.';
                }
            }
            field(IsCarryForwarded; Rec.BLRIsCarryForwarded)
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
                    TenancyContract: Record "BLRTenancyContract";
                    ReportDubai: Report "BLRTenancyContract";
                    ReportAbuDhabi: Report BLRUmmAlQuwainContract;
                    Emirate: Enum BLREmirates;
                    CurrentEmirateValue: Enum BLREmirates;
                begin
                    TenancyContract.SetRange("BLRContract ID", Rec."BLRContract ID");

                    if Evaluate(CurrentEmirateValue, Rec."BLREmirate") then
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
        workflowfrequency: Record "BLRWorkflowFrequencyPR";

    begin

        CurrPage."Revenues".Page.SetContractID(Rec."BLRContract ID");

        CurrPage."Revenues".Page.SetTenantID(Rec."BLRTenant ID");
        CurrPage."Revenues".Page.SetProposalId(Rec."BLRProposal ID");
        CurrPage."Single Unit Rent (Renewal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Single Unit lumpsum Rent (Renewal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Single Unit Rent (Proposal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Single Unit lumpsum Rent (Proposal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Merge SameSqure Rent (Renewal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Merge SameSqure Rent (Proposal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Merge DifferentSqure Rent (Proposal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Merge DifferentSqure Rent (Renewal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Merge Lum_AnnualAmount Rent (Proposal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Merge Lum_AnnualAmount Rent (Renewal)".Page.SetContractIDs(Rec."BLRContract ID");
        UpdateFieldsEnable();
        UpdateVisibility();
        UpdateSecurityAmountReceived();

        if Rec."BLRTermination Of Contract" = Rec."BLRTermination Of Contract"::" " then
            IsVisible := false  // Link should be visible
        else
            IsVisible := true; // Link should be hidde


        // Check if the contract status is either "Terminated" or "Renewed"
        if (Rec."BLRTenant Contract Status" = Rec."BLRTenant Contract Status"::"Terminated") or
           (Rec."BLRTenant Contract Status" = Rec."BLRTenant Contract Status"::"Contract Renewed") then
            IsVisible := true  // Link should be visible
        else
            IsVisible := false; // Link should be hidden        

        workflowfrequency.SetRange("BLRProperty ID", Rec."BLRProperty ID");
        workflowfrequency.SetFilter(BLRWorkflow, '%1|%2|%3',
            workflowfrequency."BLRWorkflow"::"Payment Reminder",
            workflowfrequency."BLRWorkflow"::"Renewal Notification to Tenant",
            workflowfrequency."BLRWorkflow"::"Tenant Loyalty Check Reminder");

        if workflowfrequency.FindSet() then begin
            repeat
                case workflowfrequency."BLRWorkflow" of
                    workflowfrequency."BLRWorkflow"::"Payment Reminder":
                        Rec."BLRPayment Reminder" := workflowfrequency."BLRNo. of Days";

                    workflowfrequency."BLRWorkflow"::"Renewal Notification to Tenant":
                        Rec."BLRRenewalNotiftoTenant" := workflowfrequency."BLRNo. of Days";

                    workflowfrequency."BLRWorkflow"::"Tenant Loyalty Check Reminder":
                        Rec."BLRTenantLoyaltyCheckReminder" := workflowfrequency."BLRNo. of Days";
                end;
            until workflowfrequency.Next() = 0;

            Rec.Modify();
        end;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        CurrPage."Revenues".Page.SetContractID(Rec."BLRContract ID");

        CurrPage."Revenues".Page.SetTenantID(Rec."BLRTenant ID");
        CurrPage."Revenues".Page.SetProposalId(Rec."BLRProposal ID");
        CurrPage."Single Unit Rent (Renewal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Single Unit lumpsum Rent (Renewal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Single Unit Rent (Proposal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Single Unit lumpsum Rent (Proposal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Merge SameSqure Rent (Renewal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Merge SameSqure Rent (Proposal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Merge DifferentSqure Rent (Proposal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Merge DifferentSqure Rent (Renewal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Merge Lum_AnnualAmount Rent (Proposal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Merge Lum_AnnualAmount Rent (Renewal)".Page.SetContractIDs(Rec."BLRContract ID");
        UpdateVisibility();
        UpdateSecurityAmountReceived();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage."Revenues".Page.SetContractID(Rec."BLRContract ID");

        CurrPage."Revenues".Page.SetTenantID(Rec."BLRTenant ID");
        CurrPage."Revenues".Page.SetProposalId(Rec."BLRProposal ID");
        CurrPage."Single Unit Rent (Renewal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Single Unit lumpsum Rent (Renewal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Single Unit Rent (Proposal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Single Unit lumpsum Rent (Proposal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Merge SameSqure Rent (Renewal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Merge SameSqure Rent (Proposal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Merge DifferentSqure Rent (Proposal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Merge DifferentSqure Rent (Renewal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Merge Lum_AnnualAmount Rent (Proposal)".Page.SetContractIDs(Rec."BLRContract ID");
        CurrPage."Merge Lum_AnnualAmount Rent (Renewal)".Page.SetContractIDs(Rec."BLRContract ID");
        UpdateVisibility();

    end;


    local procedure UpdateFieldsEnable()
    begin
        ProposalIDEnabled := Rec."BLRContract Type" = Rec."BLRContract Type"::"New Contract";
        RenewalProposalIDEnabled := Rec."BLRContract Type" = Rec."BLRContract Type"::"Renewal Contract";

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
        ShowLegalReasonFields := (Rec."BLRSingle Rent Calculation" = Rec."BLRSingle Rent Calculation"::"Single Unit with square feet rate");
        ShowBusinessReasonFields := (Rec."BLRMerge Rent Calculation" = Rec."BLRMerge Rent Calculation"::"Merged Unit with same square feet");
        ShowLegalReasonFields1 := (Rec."BLRMerge Rent Calculation" = Rec."BLRMerge Rent Calculation"::"Merged Unit with differential square feet rate");
        ShowBusinessReasonFields2 := (Rec."BLRMerge Rent Calculation" = Rec."BLRMerge Rent Calculation"::"Merged Unit with lumpsum annual amount");
        ShowLegalReasonFields3 := (Rec."BLRSingle Rent Calculation" = Rec."BLRSingle Rent Calculation"::"Single Unit with lumpsum square feet rate");
        ShowLegalReasonFields4 := (Rec."BLRPraposal Type Selected" = Rec."BLRPraposal Type Selected"::"Merge Unit");
    end;

    local procedure UpdateSecurityAmountReceived()
    begin
        // Update Security Amount Received
        if Rec."BLRSecurity Deposit Amount" = Rec."BLRSecDepAmtReceived" then
            Rec."BLRSecurity Amount Pending" := 0
        else
            Rec."BLRSecurity Amount Pending" := Rec."BLRSecurity Deposit Amount" - Rec."BLRSecDepAmtReceived";

    end;



    trigger OnOpenPage()
    var
        TenancyContractSubpage: Record "BLRTenancyContractSubpage";
    begin
        TenancyContractSubpage.SetRange(BLRContractID, 0);
        if TenancyContractSubpage.FindSet() then
            TenancyContractSubpage.DeleteAll();
    end;

    procedure PopulateFinalCalculationFromTenancyContract(var aFinalCalculation: Record "BLRFinalCalculation")
    var
        TenancyContractSubpage: Record "BLRTenancyContractSubpage";
    begin
        aFinalCalculation."BLRContract ID" := Rec."BLRContract ID";
        aFinalCalculation."BLRTenant ID" := Rec."BLRTenant ID";
        aFinalCalculation."BLRContract Start Date" := Rec."BLRContract Start Date";
        aFinalCalculation."BLRContract End Date" := Rec."BLRContract End Date";
        aFinalCalculation."BLRUnit Type" := Rec."BLRUsage Type";
        aFinalCalculation."BLRContract Amount" := Rec."BLRAnnual Rent Amount";
        aFinalCalculation."BLRTenant Email" := Rec."BLREmail Address";
        aFinalCalculation."BLRTenant Name" := Rec."BLRCustomer Name";
        aFinalCalculation."BLRSecurity Deposit" := Rec."BLRSecurity Balanced Amount";
        aFinalCalculation."BLRRemaining Security Deposit" := Rec."BLRSecurity Balanced Amount";


        // Add Chiller Deposit
        TenancyContractSubpage.Reset();
        TenancyContractSubpage.SetRange(BLRContractID, Rec."BLRContract ID");
        TenancyContractSubpage.SetRange("BLRSecondary Item Type", 'Chiller Deposit');
        if TenancyContractSubpage.FindFirst() then begin

            aFinalCalculation."BLRChiller Deposit" := TenancyContractSubpage."BLRInvoiced and Paid";
            aFinalCalculation."BLRRemaining Chiller Deposit" := TenancyContractSubpage."BLRInvoiced and Paid";
        end;


        // Add Other Deposit
        TenancyContractSubpage.Reset();
        TenancyContractSubpage.SetRange(BLRContractID, Rec."BLRContract ID");
        TenancyContractSubpage.SetRange("BLRSecondary Item Type", 'Other Deposit');
        if TenancyContractSubpage.FindFirst() then begin
            aFinalCalculation."BLROther Deposit" := TenancyContractSubpage."BLRInvoiced and Paid";
            aFinalCalculation."BLRRemaining Other Deposit" := TenancyContractSubpage."BLRInvoiced and Paid";
        end;


        aFinalCalculation."BLRTotal Refundable Deposit" := aFinalCalculation."BLRSecurity Deposit" + aFinalCalculation."BLRChiller Deposit" + aFinalCalculation."BLROther Deposit";
    end;
}
