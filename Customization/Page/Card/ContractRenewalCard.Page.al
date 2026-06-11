#pragma warning disable AW0006
page 73209680 "BLRContract Renewal Card"
#pragma warning restore AW0006
{
    PageType = Card;
    SourceTable = "BLRContractRenewal";
    ApplicationArea = All;
    Caption = 'Contract Renewal Card';

    layout
    {
        area(content)
        {
            group("General Info")
            {
                Caption = 'General Information';

                field("Id"; rec."BLRId")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Specifies the unique identifier for the contract renewal.';
                }

                field("Contract ID"; rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Editable = true; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Specifies the unique identifier for the contract renewal.';
                }

                field("Proposal ID"; Rec."BLRProposal ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the proposal ID associated with the contract renewal.';
                }
                field("Contract Date"; Rec."BLRContract Date")
                {
                    ApplicationArea = All;
                    Caption = 'Proposal Date';
                    Editable = true;
                    ToolTip = 'Specifies the date of the contract renewal proposal.';
                }
            }

            group("Owner / Lessor Information")
            {
                field("Owner's Name"; rec."BLROwner's Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the owner of the property.';
                }

                field("Lessor's Name"; rec."BLRLessor's Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the lessor of the property.';
                }

                field("Lessor's Emirates ID"; rec."BLRLessor's Emirates ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Emirates ID of the lessor of the property.';
                }

                field("License No."; rec."BLRLicense No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the license number of the lessor of the property.';
                }

                field("Licensing Authority"; rec."BLRLicensing Authority")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the licensing authority of the lessor of the property.';
                }

                field("Lessor's Email"; rec."BLRLessor's Email")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the email address of the lessor of the property.';
                }

                field("Lessor's Phone"; rec."BLRLessor's Phone")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the phone number of the lessor of the property.';
                }
            }

            group("Tenant & Customer Info")
            {
                Caption = 'Tenant & Customer Information';
                field("Tenant ID"; rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the tenant.';
                }
                field("Tenant Full Name"; rec."BLRTenant Full Name")
                {
                    ApplicationArea = All;
                    Caption = 'Tenant Name';
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Specifies the name of the tenant.';
                }
                field("Emirates ID"; rec."BLREmirates ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the Emirates ID of the tenant.';
                }

                field("Contact Number"; rec."BLRContact Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the contact number of the tenant.';
                }

                field("Email Address"; rec."BLREmail Address")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the email address of the tenant.';
                }

                field("Tenant_License No."; Rec."BLRTenant_License No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the license number of the tenant.';
                }

                field("Tenant_Licensing Authority"; Rec."BLRTenant_Licensing Authority")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the licensing authority of the tenant.';
                }
            }


            // Group for Property Information
            group("Property Info")
            {
                Caption = 'Property Information';
                field("Unit ID"; rec."BLRUnit ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Specifies the unique identifier for the unit.';
                }

                field("Praposal Type Selected"; rec."BLRPraposal Type Selected")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Category';
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the unit.';
                }
                field("Unit Name"; rec."BLRUnit Name")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Specifies the name of the unit.';
                }
                field("Property ID"; rec."BLRProperty ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Specifies the unique identifier for the property.';
                }
                field("Property Name"; rec."BLRProperty Name")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Specifies the name of the property.';
                }

                field("Property Classification"; rec."BLRProperty Classification")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'Specifies the classification of the property.';
                }
                field("BLRPropertyType"; rec."BLRProperty Type")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'Specifies the type of the property.';
                }

                field("Merge Unit ID"; Rec."BLRMerge Unit ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Lookup = true; // Enable lookup for Unit ID
                    ToolTip = 'Specifies the unique identifier for the unit.';
                }

                field("Unit Number"; Rec."BLRUnit Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the number of the unit.';
                }

                field("UnitID"; Rec."BLRUnitID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the unique identifier for the unit.';
                }
                field("Usage Type"; Rec."BLRUsage Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the usage type of the unit.';
                }
                field("Unit Type"; Rec."BLRUnit Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the type of the unit.';
                }

                field("Single Unit Name"; Rec."BLRSingle Unit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the unit.';
                }

                field("Ejari Name"; Rec."BLREjari Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the name of the ejari.';
                }
                field("Unit Sq. Feet"; Rec."BLRUnit Sq. Feet")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the square feet of the unit.';
                }
                field("Property Size"; Rec."BLRProperty Size")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the size of the property.';
                }

                field("Base Unit of Measure"; rec."BLRBase Unit of Measure")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'Specifies the base unit of measure for the property.';
                }

                field("Makani Number"; Rec."BLRMakani Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the makani number of the property.';
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
                    ToolTip = 'Specifies the emirate of the property.';
                }

                field(Community; Rec."BLRCommunity")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the community of the property.';
                }
                field("DEWA Number"; Rec."BLRDEWA Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the DEWA number of the property.';
                }
            }

            group("Lease Terms")
            {
                Caption = 'Lease Terms';
                field("Contract Start Date"; rec."BLRContract Start Date")
                {
                    ApplicationArea = All;
                    Editable = true; // The ID is not editable since it's auto-incrementing
                    Caption = 'Lease Start Date';
                    ToolTip = 'Lease Start Date';
                }
                field("Contract End Date"; rec."BLRContract End Date")
                {
                    ApplicationArea = All;
                    Editable = true; // The ID is not editable since it's auto-incrementing
                    Caption = 'Lease End Date';
                    ToolTip = 'Lease End Date';
                }
                field("Contract Tenor"; rec."BLRContract Tenor")
                {
                    ToolTip = 'Lease Tenor';
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    Caption = 'Lease Duration';
                }
                field("Rent Amount"; Rec."BLRRent Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Lease Rent Amount';
                }

                field("Contract Amount"; rec."BLRContract Amount")
                {
                    ApplicationArea = All;
                    Editable = true; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Lease Contract Amount';
                }

                field("Rent VAT Amount"; rec."BLRRent VAT Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Lease Rent VAT Amount';
                }

                field("Rent Amount VAT %"; rec."BLRRent Amount VAT %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Lease Rent Amount VAT %';
                }

                field("Rent Amount Including VAT"; rec."BLRRent Amount Including VAT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Lease Rent Amount Including VAT';
                }

                field("Payment Frequency"; rec."BLRPayment Frequency")
                {
                    ApplicationArea = All;
                    Caption = 'Frequency of payment';
                    ToolTip = 'Frequency of payment';
                }
                field("Payment Method"; rec."BLRPayment Method")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Mode';
                    ToolTip = 'Payment Mode';
                }

                field("No of Installments"; rec."BLRNo of Installments")
                {
                    ApplicationArea = All;
                    Caption = 'No of Installments';
                    Editable = false;
                    ToolTip = 'No of Installments';
                }

                field("Rera"; Rec."BLRRera")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Rera';
                }

                field("Ejari Processing Charges"; Rec."BLREjari Processing Charges")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Ejari Processing Charges';
                }

                field("Renewal Charges"; Rec."BLRRenewal Charges")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Renewal Charges';
                }
            }
            part("Additional Terms"; "BLRRenewalAdditionalTerms")
            {
                ApplicationArea = All;
                SubPageLink = "BLRDocument No." = FIELD(BLRId);
                Caption = 'Additional Terms';
                //SubPageLink = "BLRTenant ID" = FIELD("BLRTenant ID");
            }
            group("Deposit and Fees")
            {
                field("Security Deposit Amount"; Rec."BLRSecurity Deposit Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Security Deposit Amount';
                }
                field("Other Fees"; rec."BLROther Fees")
                {
                    ApplicationArea = All;
                    ToolTip = 'Other Fees';
                }
                field("Refund Conditions"; rec."BLRRefund Conditions")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Refund Conditions';
                }
            }

            group("Responsibilities")
            {
                field("Maintenance Responsibilities"; rec."BLRMaintResp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Maintenance Responsibilities';
                }
                field("Utility Bills Responsibility"; rec."BLRUtilityBillsResp")
                {
                    ApplicationArea = All;
                    ToolTip = 'Utility Bills Responsibility';
                }
                field("Insurance Requirements"; rec."BLRInsurance Requirements")
                {
                    ApplicationArea = All;
                    ToolTip = 'Insurance Requirements';
                }
            }

            group("Conditions for Renewal")
            {
                field("Rent Escalation Clause"; rec."BLRRent Escalation Clause")
                {
                    ApplicationArea = All;
                    ToolTip = 'Rent Escalation Clause';
                }
            }

            group("Special Conditions")
            {
                Caption = 'Special Conditions';

                field("Early Termination Conditions"; rec."BLREarlyTermCond")
                {
                    ApplicationArea = All;
                    ToolTip = 'Early Termination Conditions';
                }
                field("Restrictions"; rec."BLRRestrictions")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'Restrictions';
                }
                field("Legal Jurisdiction"; rec."BLRLegal Jurisdiction")
                {
                    ApplicationArea = All;
                    ToolTip = 'Legal Jurisdiction';
                }

                field("Created By"; rec."BLRCreated By")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Created By';
                }

                field("Approval For Renewal"; rec."BLRApproval For Renewal")
                {
                    ApplicationArea = All;
                    Editable = true; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Approval For Renewal';
                }
                field("Renewal Contract Status"; rec."BLRRenewal Contract Status")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Renewal Contract Status';
                }

                field("Original Contract ID"; rec."BLROriginal Contract ID")
                {
                    ApplicationArea = All;
                    Editable = false; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Original Contract ID';
                }
                field("Single Rent Calculation"; Rec."BLRSingle Rent Calculation")
                {
                    ApplicationArea = All;
                    Editable = Rec."BLRPraposal Type Selected" = Rec."BLRPraposal Type Selected"::"Single Unit";
                    ToolTip = 'Single Rent Calculation';
                    trigger OnValidate()
                    begin
                        UpdateVisibility();
                    end;
                }
                field("Merge Rent Calculation"; Rec."BLRMerge Rent Calculation")
                {
                    ApplicationArea = All;
                    Editable = Rec."BLRPraposal Type Selected" = Rec."BLRPraposal Type Selected"::"Merge Unit";
                    ToolTip = 'Merge Rent Calculation';
                    trigger OnValidate()
                    begin
                        UpdateVisibility();
                    end;
                }

                field("Final Status"; rec."BLRFinal Status")
                {
                    ApplicationArea = All;
                    Editable = true; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Final Status';
                    Caption = 'Contract Renewal Proposal Status';
                }

                field("Contract Status"; rec."BLRContract Status")
                {
                    ApplicationArea = All;
                    Editable = true; // The ID is not editable since it's auto-incrementing
                    ToolTip = 'Contract Status';
                }
            }

            group("Lease Unit Details")
            {
                Caption = 'Unit Details';
                part("Unit all Details"; "BLRCR Sub LeaseMergedUnitsCard")
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

                part("Single Unit lumpsum Rent"; "BLRCRSingleLumAnnualAmntSP")
                {
                    SubPageLink = "BLRID" = FIELD("BLRID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                }
            }

            group("Single Unit with square feet rate")
            {
                Caption = 'Single Unit With Square Feet Rate';
                Visible = ShowLegalReasonFields;

                part("Single Unit Rent"; "BLRCRSingleUnitRentSubPage")
                {
                    SubPageLink = "BLRID" = FIELD("BLRID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                }

            }
            group("Merged Unit with same square feet")
            {
                Caption = 'Merged Unit With Same Square Feet';
                Visible = ShowBusinessReasonFields;
                part("Merge SameSqure Rent"; "BLRCRMergeSameSqureSubPage")
                {
                    SubPageLink = "BLRID" = FIELD("BLRID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                }
            }
            group("Merged Unit with differential square feet rate")
            {
                Caption = 'Merged Unit With Differential Square Feet Rate';
                Visible = ShowLegalReasonFields1;
                part("Merge DifferentSqure Rent"; "BLRCRMergeDifferentSqSubPage")
                {
                    SubPageLink = "BLRID" = FIELD("BLRID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                }
            }
            group("Merged Unit with lumpsum annual amount")
            {
                Caption = 'Merged Unit With Lumpsum Annual Amount';
                Visible = ShowBusinessReasonFields2;
                part("Merge Lum_AnnualAmount Rent"; "BLRCR MergeLum_AnnualAmountSP")
                {
                    SubPageLink = "BLRID" = FIELD("BLRID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                }
            }

            group("Per Day Rent for Revenue Allocation")
            {
                Caption = 'Per Day Rent for Revenue Allocation';
                part("BLRPerDayRentforRevenue"; "BLRCR PerDayRentforRevenueCard")
                {
                    SubPageLink = "BLRContract Renewal ID" = FIELD(BLRId); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = Rec."BLRPraposal Type Selected" = Rec."BLRPraposal Type Selected"::"Merge Unit"; // Visible when "Praposal Type Selected" is "Merge Unit"
                }
            }


            group("Other Payments")
            {
                part("ContractRenewal"; "BLRContract RenewalSubPageCard")
                {
                    SubPageLink = BLRId = FIELD(BLRId),
                    "BLRTenantID" = FIELD("BLRTenant ID");
                    ApplicationArea = All;
                }
            }

            field("Is any Broker Involved?"; Rec."BLRIs any Broker Involved?")
            {
                ApplicationArea = All;
                ToolTip = 'Is any Broker Involved?';
            }

            group("Brokers and Commission Agent Details")
            {
                Visible = Rec."BLRIs any Broker Involved?";

                field("Vendor ID"; Rec."BLRVendor ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Vendor ID';

                    // Trasfer from Table Start 
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        VendorProfileRec: Record "BLRVendorProfile";
                        AnnualAmount: Decimal;
                    begin
                        VendorProfileRec.SetRange("BLRVendor Category", 'Brokers and Commission Agent');
                        VendorProfileRec.SetRange("BLRContract Status", Rec."BLRContract Status"::"Active"); // 👈 Add this line
                        if Page.RunModal(Page::"BLRVendor Profile List", VendorProfileRec) = Action::LookupOK then begin
                            Rec."BLRVendor ID" := VendorProfileRec."BLRVendor ID";
                            Rec."BLRVendor Name" := VendorProfileRec."BLRVendor Name";
                            Rec."BLRStart Date" := VendorProfileRec."BLRStart Date";
                            Rec."BLREnd Date" := VendorProfileRec."BLREnd Date";
                            Rec."BLRContract Status" := VendorProfileRec."BLRContract Status";
                            Rec."BLRCalculation Method" := VendorProfileRec."BLRCalculation Method";
                            Rec."BLRPercentage Type" := VendorProfileRec."BLRPercentage Type";
                            Rec."BLRPercentage" := VendorProfileRec."BLRPercentage";
                            Rec."BLRBase Amount Type" := VendorProfileRec."BLRBase Amount Type";

                            case Rec."BLRBase Amount Type" of
                                Rec."BLRBase Amount Type"::"Annual Rent":
                                    AnnualAmount := Rec."BLRRent Amount";
                                Rec."BLRBase Amount Type"::"Monthly Rent":
                                    AnnualAmount := Rec."BLRRent Amount" / 12;
                            end;

                            Rec."BLRAmount" := AnnualAmount;
                            Rec."BLRFrequency Of Payment" := VendorProfileRec."BLRFrequency Of Payment";
                        end else begin
                            Rec."BLRVendor ID" := '';
                            Rec."BLRVendor Name" := '';
                            Rec."BLRStart Date" := 0D;
                            Rec."BLREnd Date" := 0D;
                            Rec."BLRContract Status" := Rec."BLRContract Status"::" ";
                            Rec."BLRCalculation Method" := ' ';
                            Rec."BLRPercentage Type" := Rec."BLRPercentage Type"::" ";
                            Rec."BLRPercentage" := 0;
                            Rec."BLRAmount" := 0;
                            Rec."BLRBase Amount Type" := Rec."BLRBase Amount Type"::" ";
                            Rec."BLRFrequency Of Payment" := Rec."BLRFrequency Of Payment"::" ";
                        end;
                    end;
                    // Trasfer from Table End
                }

                field("Vendor Name"; Rec."BLRVendor Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Vendor Name';
                }

                field("Start Date"; Rec."BLRStart Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Start Date';
                }

                field("End Date"; Rec."BLREnd Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'End Date';
                }

                field("Calculation Method"; Rec."BLRCalculation Method")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Calculation Method';
                }

                field("Percentage Type"; Rec."BLRPercentage Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Percentage Type';
                }

                field("Percentage"; Rec."BLRPercentage")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Percentage';
                }

                field("Amount"; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Amount';
                }

                field("Base Amount Type"; Rec."BLRBase Amount Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Base Amount Type';
                }
                field("Frequency Of Payment"; Rec."BLRFrequency Of Payment")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Frequency Of Payment';
                }

                field("ContractStatus"; Rec."BLRContractStatus")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Contract Status';
                }
            }
        }
    }

    // Update the enable logic based on "Proposal Type Selected"
    trigger OnAfterGetRecord()
    begin

        CurrPage."Single Unit Rent".Page.Update();
        CurrPage."Merge SameSqure Rent".Page.Update();

        CurrPage."Merge Lum_AnnualAmount Rent".Page.Update();
        CurrPage."Single Unit lumpsum Rent".Page.Update();

        CurrPage."ContractRenewal".Page.SetId(Rec."BLRID");
        CurrPage."ContractRenewal".Page.SetStartEndDate(Rec."BLRContract Start Date", Rec."BLRContract End Date");
        CurrPage."ContractRenewal".Page.SetTenantID(Rec."BLRTenant ID");

    end;

    trigger OnModifyRecord(): Boolean
    begin
        CurrPage."ContractRenewal".Page.SetId(Rec."BLRID");
        CurrPage."ContractRenewal".Page.SetStartEndDate(Rec."BLRContract Start Date", Rec."BLRContract End Date");
        CurrPage."ContractRenewal".Page.SetTenantID(Rec."BLRTenant ID");

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage."ContractRenewal".Page.SetId(Rec."BLRID");
        CurrPage."ContractRenewal".Page.SetStartEndDate(Rec."BLRContract Start Date", Rec."BLRContract End Date");
        CurrPage."ContractRenewal".Page.SetTenantID(Rec."BLRTenant ID");

    end;

    var
        ShowLegalReasonFields: Boolean;
        ShowBusinessReasonFields: Boolean;
        ShowLegalReasonFields1: Boolean;
        ShowBusinessReasonFields2: Boolean;
        ShowLegalReasonFields3: Boolean;
        ShowLegalReasonFields4: Boolean;

    trigger OnOpenPage()
    begin
        UpdateVisibility();
    end;

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

}