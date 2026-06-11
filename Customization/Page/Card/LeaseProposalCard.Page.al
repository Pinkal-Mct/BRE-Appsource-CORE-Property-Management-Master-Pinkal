page 73209697 "BLRLease Proposal Card"
{
    PageType = Card;
    SourceTable = "BLRLeaseProposalDetails";
    ApplicationArea = All;
    Caption = 'Lease Proposal';
    UsageCategory = None;
    Editable = true;

    layout
    {
        area(content)
        {
            group("General Information")
            {
                field("Proposal ID"; rec."BLRProposal ID")
                {
                    ApplicationArea = All;
                    Editable = false; // Typically auto-generated or set once
                    ToolTip = 'This is a generated field';
                }
                field("Property ID"; rec."BLRProperty ID")
                {
                    ApplicationArea = All;
                    Lookup = true; // Enable lookup for Property ID
                    ShowMandatory = true;
                    NotBlank = true;
                    ToolTip = 'Select the property for which the lease proposal is being created.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }


                field("Property Name"; rec."BLRProperty Name")
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'This field displays the name of the property associated with the lease proposal.';
                }

                field("Praposal Type Selected"; rec."BLRPraposal Type Selected")
                {
                    ApplicationArea = All;
                    Caption = 'Unit Category';
                    ToolTip = 'Select the type of proposal: Single Unit or Merge Unit.';
                    trigger OnValidate()
                    begin
                        UpdateUnitEnableState();
                    end;
                }

                field("Unit ID"; rec."BLRUnit ID")
                {
                    ApplicationArea = All;
                    Lookup = true; // Enable lookup for Unit ID
                    Enabled = EnableSingleUnit;
                    ToolTip = 'Select the Unit ID for the lease proposal. This field is mandatory for Single Unit proposals.';

                }

                field("Merge Unit ID"; Rec."BLRMerge Unit ID")
                {
                    ApplicationArea = All;
                    Editable = true;
                    Lookup = true; // Enable lookup for Unit ID
                    Enabled = EnableMergeUnit;
                    ToolTip = 'Select the Merge Unit ID for the lease proposal. This field is mandatory for Merge Unit proposals.';

                    trigger OnValidate()

                    begin
                        UpdateVisibility();
                    end;

                }

                field("Property Address"; rec."BLRUnit Address")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'This field displays the address of the property associated with the lease proposal.';
                }


                field("Unit Number"; Rec."BLRUnit Number") // Custom Field
                {
                    ApplicationArea = All;
                    Caption = 'Unit Number';
                    Editable = false;
                    ToolTip = 'This field displays the unit number associated with the lease proposal.';
                }

                field("Unit Classification"; rec."BLRUsage Type")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'This field displays the classification of the unit, such as Residential, Commercial, etc.';
                }

                field("Unit Type"; rec."BLRUnit Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'This field displays the type of unit, such as Apartment, Office, etc.';

                }
                field("Unit Name"; Rec."BLRUnit Name") // Custom Field
                {
                    ApplicationArea = All;
                    Caption = 'Unit Name';
                    Editable = false;
                    ToolTip = 'This field displays the name of the unit associated with the lease proposal.';
                }

                field("Single Unit Name"; Rec."BLRSingle Unit Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    MultiLine = true;
                    ToolTip = 'This field displays the name of the single unit associated with the lease proposal. It can contain multiple lines for detailed information.';
                }
                field("Uniq Unit ID"; Rec."BLRUnitID") // Auto-generated Unit ID
                {
                    ApplicationArea = All;
                    Caption = 'Uniq Unit ID';
                    Editable = false;
                    ToolTip = 'This field displays the unique identifier for the unit associated with the lease proposal.';
                }

                field("Base Unit of Measure"; rec."BLRBase Unit of Measure")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    ToolTip = 'This field displays the base unit of measure for the unit associated with the lease proposal. It indicates the standard measurement unit used for the unit, such as square feet or square meters.';
                }

                field("Market Rate per Sq. Ft."; rec."BLRMarket Rate per Sq. Ft.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'This field displays the market rate per square foot for the unit associated with the lease proposal.';
                }

                field("Unit Size"; rec."BLRUnit Size")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'This field displays the size of the unit in square feet.';
                }
                field("Facilities/Amenities"; rec."BLRFacilities/Amenities")
                {
                    ApplicationArea = All;
                    ToolTip = 'This field displays the facilities or amenities available in the unit associated with the lease proposal.';
                }
                field("Property Size"; Rec."BLRProperty Size")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'This field displays the size of the property associated with the lease proposal.';
                }
                field("Makani Number"; Rec."BLRMakani Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'This field displays the Makani number, a unique identifier for the property in Dubai.';
                }
                field("Municipality Number"; Rec."BLRMunicipality Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Municipality Number';
                    ToolTip = 'This field displays the municipality number associated with the property.';
                }
                field(Emirate; Rec."BLREmirate")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'This field displays the emirate where the property is located.';
                }
                field(Community; Rec."BLRCommunity")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'This field displays the community or locality where the property is situated.';
                }
                field("DEWA Number"; Rec."BLRDEWA Number")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'This field displays the Dubai Electricity and Water Authority (DEWA) number associated with the property.';
                }
            }
            part(AdditionalTerms; "BLRAdditional Terms Subpage")
            {
                ApplicationArea = All;
                SubPageLink = "BLRDocument No." = FIELD("BLRProposal ID");
                Caption = 'Additional Terms';
            }


            group("Tenant Details")
            {

                field("Tenant ID"; rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the Tenant ID for the lease proposal. This field is mandatory.';
                }
                field("Tenant Full Name"; rec."BLRTenant Full Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'This field displays the full name of the tenant associated with the lease proposal.';
                }
                field("Tenant Contact Phone"; rec."BLRTenant Contact Phone")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'This field displays the contact phone number of the tenant associated with the lease proposal.';
                }
                field("Tenant Contact Email"; rec."BLRTenant Contact Email")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'This field displays the contact email address of the tenant associated with the lease proposal.';
                }

                field("Emirates ID"; rec."BLREmirates ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'This field displays the Emirates ID of the tenant, which is a unique identification number issued by the UAE government.';
                }
                field("License No."; Rec."BLRLicense No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'This field displays the license number of the tenant, which is required for business entities operating in the UAE.';
                }

                field("Licensing Authority"; Rec."BLRLicensing Authority")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'This field displays the authority that issued the tenant`s license, such as the Department of Economic Development (DED) or relevant free zone authority.';
                }

                field("Legal Representative"; rec."BLRLegal Representative")
                {
                    ApplicationArea = All;
                    ToolTip = 'This field displays the name of the legal representative of the tenant, who is authorized to sign contracts and agreements on behalf of the tenant.';
                }
            }

            group("Lease Terms")
            {
                field("Lease Start Date"; rec."BLRLease Start Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the start date of the lease. This field is mandatory.';

                    trigger OnValidate()
                    var
                        revenueItemSub: Record "BLRRevenueItemSubpage";
                    begin
                        revenueItemSub.SetRange(BLRProposalID, Rec."BLRProposal ID");
                        if revenueItemSub.FindSet() then
                            revenueItemSub.ModifyAll("BLRStart Date", Rec."BLRLease Start Date");
                    end;
                }
                field("Lease End Date"; rec."BLRLease End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Select the end date of the lease. This field is mandatory.';

                    trigger OnValidate()
                    var
                        revenueItemSub: Record "BLRRevenueItemSubpage";
                        fetchMonth: Codeunit "BLRFetch Month";
                        docAttach: Page "BLRRevenue Item Subpage Card";
                    begin
                        Rec."BLRLease Duration" := fetchMonth.CalculateLeaseDuration(Rec."BLRLease Start Date", Rec."BLRLease End Date");
                        docAttach.SetStartEndDate(Rec."BLRLease Start Date", Rec."BLRLease End Date", Rec."BLRUnit Name", Rec."BLRProperty Name", Rec."BLRUnit Size", Rec."BLRTenant Full Name");
                        Rec."BLRPayment Frequency" := Rec."BLRPayment Frequency"::" ";
                        Rec."BLRNo of Installments" := 0;

                        revenueItemSub.SetRange(BLRProposalID, Rec."BLRProposal ID");
                        if revenueItemSub.FindSet() then
                            revenueItemSub.ModifyAll("BLREnd Date", Rec."BLRLease End Date");
                    end;
                }
                field("Lease Duration"; rec."BLRLease Duration")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'This field displays the duration of the lease in months, calculated based on the lease start and end dates.';
                }
                field("Rent Amount"; rec."BLRRent Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'This field displays the total annual rent amount for the lease proposal. It is calculated based on the payment frequency and other factors.';
                }
                field("Annual Rent Amount"; rec."BLRAnnual Rent Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'This field displays the annual rent amount for the lease proposal. It is calculated based on the payment frequency and other factors.';
                }
                field("Rent VAT Amount"; rec."BLRRent VAT Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'This field displays the VAT amount applicable on the rent. It is calculated based on the annual rent amount and the VAT percentage.';
                }


                field("Rent Amount VAT %"; rec."BLRRent Amount VAT %")
                {
                    ApplicationArea = All;
                    ToolTip = 'This field displays the VAT percentage applicable on the rent amount. It is used to calculate the VAT amount on the rent.';
                }

                field("Rent Amount Including VAT"; rec."BLRRent Amount Including VAT")
                {
                    ApplicationArea = All;
                    ToolTip = 'This field displays the total rent amount including VAT. It is calculated by adding the rent amount and the rent VAT amount.';
                }

                field("Payment Frequency"; rec."BLRPayment Frequency")
                {
                    ApplicationArea = All;
                    Caption = 'Frequency of payment';

                    trigger OnValidate()
                    var
                        installmentCalcEng: Codeunit "BLRInstallmentCalculationEng";
                    begin
                        Rec."BLRNo of Installments" := installmentCalcEng.CalculateInstallments(Rec."BLRLease Duration", Format(Rec."BLRPayment Frequency"));
                    end;
                }
                field("No of Installments"; rec."BLRNo of Installments")
                {
                    ApplicationArea = All;
                    Caption = 'No of Installments';
                    ToolTip = 'This field displays the number of installments for the lease proposal based on the payment frequency and lease duration. It is calculated automatically when the payment frequency is selected.';
                }
                field("Payment Method"; rec."BLRPayment Method")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Mode';
                    ToolTip = 'Select the payment method for the lease proposal. This field determines how the rent is paid, such as bank transfer, cheque, or cash.';
                }

            }

            group("BLRSecurityDeposit")
            {
                field("Security Deposit Amount"; rec."BLRSecurity Deposit Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'This field displays the security deposit amount required for the lease proposal. It is typically a percentage of the annual rent amount.';
                }

                field("Refund Conditions"; rec."BLRRefund Conditions")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'This field displays the conditions under which the security deposit will be refunded to the tenant at the end of the lease.';
                }

            }

            group("Responsibilities")
            {
                field("Maintenance Responsibilities"; rec."BLRMaintResp")
                {
                    ApplicationArea = All;
                    ToolTip = 'This field displays the maintenance responsibilities of the tenant and landlord as per the lease proposal.';
                }
                field("Utility Bills Responsibility"; rec."BLRUtilityBillsResp")
                {
                    ApplicationArea = All;
                    ToolTip = 'This field displays the responsibility of the tenant and landlord for utility bills as per the lease proposal.';
                }
                field("Insurance Requirements"; rec."BLRInsurance Requirements")
                {
                    ApplicationArea = All;
                    ToolTip = 'This field displays the insurance requirements of the tenant and landlord as per the lease proposal.';
                }
            }

            group("Conditions for Renewal")
            {
                field("Rent Escalation Clause"; rec."BLRRent Escalation Clause")
                {
                    ApplicationArea = All;
                    ToolTip = 'This field displays the rent escalation clause applicable for the lease proposal. It specifies how the rent will increase upon renewal of the lease.';
                }
            }

            group("Special Conditions")
            {
                field("Early Termination Conditions"; rec."BLREarlyTermCond")
                {
                    ApplicationArea = All;
                    ToolTip = 'This field displays the conditions under which either party can terminate the lease early.';
                }
                field("Restrictions"; rec."BLRRestrictions")
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    ToolTip = 'This field displays any restrictions applicable to the lease proposal, such as subletting, alterations, or use of the property.';
                }
                field("Legal Jurisdiction"; rec."BLRLegal Jurisdiction")
                {
                    ApplicationArea = All;
                    ToolTip = 'This field displays the legal jurisdiction applicable to the lease proposal. It specifies the governing law and dispute resolution mechanism for the lease.';
                }

                field("Single Rent Calculation"; Rec."BLRSingle Rent Calculation")
                {
                    ApplicationArea = All;
                    Editable = Rec."BLRPraposal Type Selected" = Rec."BLRPraposal Type Selected"::"Single Unit";
                    ToolTip = 'Select the rent calculation method for single unit proposals. This field determines how the rent is calculated based on the unit size and other factors.';
                    trigger OnValidate()
                    begin
                        UpdateVisibility();
                    end;
                }
                field("Merge Rent Calculation"; Rec."BLRMerge Rent Calculation")
                {
                    ApplicationArea = All;
                    Editable = Rec."BLRPraposal Type Selected" = Rec."BLRPraposal Type Selected"::"Merge Unit";
                    ToolTip = 'Select the rent calculation method for merge unit proposals. This field determines how the rent is calculated based on the merged units and other factors.';
                    trigger OnValidate()
                    begin
                        UpdateVisibility();
                    end;
                }

                field("Update Data"; Rec."BLRUpdate Data")
                {
                    ApplicationArea = All;
                    Editable = false;
                    DrillDown = true;
                    Visible = false;
                    ToolTip = 'Click to update data in the Revenue Structure and subpages based on the lease proposal details.';
                    trigger OnDrillDown()
                    var
                        TargetRecord: Record "BLRRevenueStructure";
                        LeaseProposal: Record "BLRLeaseProposalDetails";
                        SU_samesquare: Record "BLRSingleUnitRentSubPage";
                        SU_lumpsum: Record "BLRSingleLumAnnualAmntSubPage";
                        MU_samesquare: Record "BLRMergeSameSqureSubPage";
                        MU_differentsquare: Record "BLRMergeDifferentSqureSubPage";
                        MU_lumpsum: Record "BLRMergeLumAnnualAmountSubPage";
                        RevenueSubpage: Record "BLRRevenueStructureSubpage";
                        SingleUnitName: Text;
                        CommaPos: Integer;
                    begin
                        // Find the lease proposal record
                        LeaseProposal.SetRange("BLRProposal ID", Rec."BLRProposal ID");
                        if LeaseProposal.FindFirst() then begin
                            // Initialize and insert new record with data from lease proposal
                            TargetRecord.Init();
                            // TargetRecord."Proposal ID" := LeaseProposal."BLRProposal ID";
                            TargetRecord."BLRContract Start Date" := LeaseProposal."BLRLease Start Date";
                            TargetRecord."BLRContract End Date" := LeaseProposal."BLRLease End Date";
                            TargetRecord."BLRAmount" := LeaseProposal."BLRAnnual Rent Amount";
                            TargetRecord."BLRTenant ID" := LeaseProposal."BLRTenant ID";
                            TargetRecord."BLRSecondary Item Type" := 'Rent';
                            TargetRecord."BLRVAT Amount" := LeaseProposal."BLRRent VAT Amount";
                            TargetRecord."BLRAmount Including VAT" := LeaseProposal."BLRRent Amount Including VAT";
                            TargetRecord.Insert();

                            if LeaseProposal."BLRSingle Rent Calculation" = LeaseProposal."BLRSingle Rent Calculation"::"Single Unit with lumpsum square feet rate" then begin
                                SU_lumpsum.SetRange("BLRProposal ID", LeaseProposal."BLRProposal ID");
                                if SU_lumpsum.FindSet() then
                                    repeat
                                        if not RevenueSubpage.Get(TargetRecord."BLRRS ID", SU_lumpsum."BLRSL_Year") then begin
                                            RevenueSubpage.Init();
                                            RevenueSubpage."BLRRS ID" := TargetRecord."BLRRS ID";
                                            RevenueSubpage."BLRYear" := SU_lumpsum."BLRSL_Year";
                                            RevenueSubpage."BLRPeriod Start Date" := SU_lumpsum."BLRSL_Start Date";
                                            RevenueSubpage."BLRPeriod End Date" := SU_lumpsum."BLRSL_End Date";
                                            RevenueSubpage."BLRNumber of Days" := SU_lumpsum."BLRSL_Number of Days";
                                            RevenueSubpage.Insert();
                                            Clear(RevenueSubpage);
                                        end else
                                            Message('Skipping duplicate record for RS ID=%1, Year=%2.',
                                                    TargetRecord."BLRRS ID", SU_lumpsum."BLRSL_Year");
                                    until SU_lumpsum.Next() = 0
                                else
                                    Error('No data found in Single Unit with lumpsum square feet rate subpage for Proposal ID %1.', LeaseProposal."BLRProposal ID");
                            end
                            else
                                if LeaseProposal."BLRSingle Rent Calculation" = LeaseProposal."BLRSingle Rent Calculation"::"Single Unit with square feet rate" then begin
                                    SU_samesquare.SetRange("BLRProposal ID", LeaseProposal."BLRProposal ID");
                                    if SU_samesquare.FindSet() then
                                        repeat
                                            if not RevenueSubpage.Get(TargetRecord."BLRRS ID", SU_samesquare."BLRYear") then begin
                                                RevenueSubpage.Init();
                                                RevenueSubpage."BLRRS ID" := TargetRecord."BLRRS ID";
                                                RevenueSubpage."BLRYear" := SU_samesquare."BLRYear";
                                                RevenueSubpage."BLRPeriod Start Date" := SU_samesquare."BLRStart Date";
                                                RevenueSubpage."BLRPeriod End Date" := SU_samesquare."BLREnd Date";
                                                RevenueSubpage."BLRNumber of Days" := SU_samesquare."BLRNumber of Days";

                                                RevenueSubpage.Insert();
                                                Clear(RevenueSubpage);
                                            end else
                                                Message('Skipping duplicate record for RS ID=%1, Year=%2.',
                                                        TargetRecord."BLRRS ID", SU_samesquare."BLRYear");
                                        until SU_samesquare.Next() = 0
                                    else
                                        Error('No data found in Single Unit with square feet rate subpage for Proposal ID %1.', LeaseProposal."BLRProposal ID");
                                end
                                else
                                    if LeaseProposal."BLRMerge Rent Calculation" = LeaseProposal."BLRMerge Rent Calculation"::"Merged Unit with differential square feet rate" then begin
                                        // Find the lease proposal record
                                        LeaseProposal.SetRange("BLRProposal ID", Rec."BLRProposal ID");
                                        if LeaseProposal.FindFirst() then begin
                                            SingleUnitName := LeaseProposal."BLRSingle Unit Name";
                                            CommaPos := StrPos(SingleUnitName, ','); // Find the position of the first comma
                                            if CommaPos > 0 then
                                                SingleUnitName := CopyStr(SingleUnitName, 1, CommaPos - 1) // Trim to the first name
                                            else
                                                SingleUnitName := SingleUnitName; // No comma, use the whole name

                                            // Find the first unit's details in Merge DifferentSquare table
                                            MU_differentsquare.SetRange("BLRProposal ID", LeaseProposal."BLRProposal ID");
                                            MU_differentsquare.SetRange("BLRMD_Unit ID", SingleUnitName); // Filter by the first unit name
                                            if MU_differentsquare.FindSet() then
                                                repeat
                                                    // Update Revenue Structure Subpage
                                                    if not RevenueSubpage.Get(TargetRecord."BLRRS ID", MU_differentsquare."BLRMD_Year") then begin
                                                        RevenueSubpage.Init();
                                                        RevenueSubpage."BLRRS ID" := TargetRecord."BLRRS ID";
                                                        RevenueSubpage."BLRYear" := MU_differentsquare."BLRMD_Year";
                                                        RevenueSubpage."BLRPeriod Start Date" := MU_differentsquare."BLRMD_Start Date";
                                                        RevenueSubpage."BLRPeriod End Date" := MU_differentsquare."BLRMD_End Date";
                                                        RevenueSubpage."BLRNumber of Days" := MU_differentsquare."BLRMD_Number of Days";
                                                        RevenueSubpage.Insert();
                                                        Clear(RevenueSubpage);
                                                    end else
                                                        Message('Skipping duplicate record for RS ID=%1, Year=%2.',
                                                                TargetRecord."BLRRS ID", MU_differentsquare."BLRMD_Year");
                                                until MU_differentsquare.Next() = 0

                                            // Message('Revenue data successfully updated for Unit Name: %1.', SingleUnitName);
                                            else
                                                Error('No data found for Unit Name: %1 in Proposal ID: %2.', SingleUnitName, LeaseProposal."BLRProposal ID");
                                        end
                                        else
                                            Error('Lease Proposal not found for Proposal ID: %1.', Rec."BLRProposal ID");
                                    end

                                    else
                                        if LeaseProposal."BLRMerge Rent Calculation" = LeaseProposal."BLRMerge Rent Calculation"::"Merged Unit with lumpsum annual amount" then begin
                                            MU_lumpsum.SetRange("BLRProposal ID", LeaseProposal."BLRProposal ID");
                                            if MU_lumpsum.FindSet() then
                                                repeat
                                                    if not RevenueSubpage.Get(TargetRecord."BLRRS ID", MU_lumpsum."BLRML_Year") then begin
                                                        RevenueSubpage.Init();
                                                        RevenueSubpage."BLRRS ID" := TargetRecord."BLRRS ID";
                                                        RevenueSubpage."BLRYear" := MU_lumpsum."BLRML_Year";
                                                        RevenueSubpage."BLRPeriod Start Date" := MU_lumpsum."BLRML_Start Date";
                                                        RevenueSubpage."BLRPeriod End Date" := MU_lumpsum."BLRML_End Date";
                                                        RevenueSubpage."BLRNumber of Days" := MU_lumpsum."BLRML_Number of Days";
                                                        RevenueSubpage.Insert();
                                                        Clear(RevenueSubpage);
                                                    end else
                                                        Message('Skipping duplicate record for RS ID=%1, Year=%2.',
                                                                TargetRecord."BLRRS ID", MU_lumpsum."BLRML_Year");
                                                until MU_lumpsum.Next() = 0
                                            else
                                                Error('No data found in Merged Unit with lumpsum annual amount subpage for Proposal ID %1.', LeaseProposal."BLRProposal ID");
                                        end
                                        else
                                            if LeaseProposal."BLRMerge Rent Calculation" = LeaseProposal."BLRMerge Rent Calculation"::"Merged Unit with same square feet" then begin
                                                MU_samesquare.SetRange("BLRProposal ID", LeaseProposal."BLRProposal ID");
                                                if MU_samesquare.FindSet() then
                                                    repeat
                                                        if not RevenueSubpage.Get(TargetRecord."BLRRS ID", MU_samesquare."BLRMS_Year") then begin
                                                            RevenueSubpage.Init();
                                                            RevenueSubpage."BLRRS ID" := TargetRecord."BLRRS ID";
                                                            RevenueSubpage."BLRYear" := MU_samesquare."BLRMS_Year";
                                                            RevenueSubpage."BLRPeriod Start Date" := MU_samesquare."BLRMS_Start Date";
                                                            RevenueSubpage."BLRPeriod End Date" := MU_samesquare."BLRMS_End Date";

                                                            RevenueSubpage."BLRNumber of Days" := MU_samesquare."BLRMS_Number of Days";
                                                            RevenueSubpage.Insert();
                                                            Clear(RevenueSubpage);
                                                        end else
                                                            Message('Skipping duplicate record for RS ID=%1, Year=%2.',
                                                                    TargetRecord."BLRRS ID", MU_samesquare."BLRMS_Year");
                                                    until MU_samesquare.Next() = 0
                                                else
                                                    Error('No data found in Merged Unit with same square feet subpage for Proposal ID %1.', LeaseProposal."BLRProposal ID");
                                            end;

                            Message('New record has been created in Revenue Structure and subpage updated successfully.');
                        end else
                            Error('Lease Proposal not found for Proposal ID %1.', Rec."BLRProposal ID");
                    end;
                }

            }

            group("Single Unit with lumpsum square feet rate")
            {
                Caption = 'Single Unit with lumpsum square feet rate';
                Visible = ShowLegalReasonFields3;

                part("Single Unit lumpsum Rent"; "BLRSingleLumAnnualAmntSubPage")
                {
                    SubPageLink = "BLRProposal ID" = FIELD("BLRProposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                }
            }

            group("Single Unit with square feet rate")
            {
                Caption = 'Single Unit With Square Feet Rate';
                Visible = ShowLegalReasonFields;

                part("Single Unit Rent"; "BLRSingleUnitRentSubPage")
                {
                    SubPageLink = "BLRProposal ID" = FIELD("BLRProposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                }

            }
            group("Merged Unit with same square feet")
            {
                Caption = 'Merged Unit With Same Square Feet';
                Visible = ShowBusinessReasonFields;
                part("Merge SameSqure Rent"; "BLRMergeSameSqureSubPage")
                {
                    SubPageLink = "BLRProposal ID" = FIELD("BLRProposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                }
            }
            group("Merged Unit with differential square feet rate")
            {
                Caption = 'Merged Unit With Differential Square Feet Rate';
                Visible = ShowLegalReasonFields1;
                part("Merge DifferentSqure Rent"; "BLRMergeDifferentSqureSubPage")
                {
                    SubPageLink = "BLRProposal ID" = FIELD("BLRProposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                }
            }
            group("Merged Unit with lumpsum annual amount")
            {
                Caption = 'Merged Unit With Lumpsum Annual Amount';
                Visible = ShowBusinessReasonFields2;
                part("Merge Lum_AnnualAmount Rent"; "BLRMergeLumAnnualAmountSubPage")
                {
                    SubPageLink = "BLRProposal ID" = FIELD("BLRProposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                }
            }

            group("Per Day Rent for Revenue Allocation")
            {
                Caption = 'Per Day Rent for Revenue Allocation';
                part("BLRPerDayRentforRevenue"; "BLRPerDayRentforRevenueCard")
                {
                    SubPageLink = "BLRProposal ID" = FIELD("BLRProposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                    Visible = Rec."BLRPraposal Type Selected" = Rec."BLRPraposal Type Selected"::"Merge Unit"; // Visible when "Praposal Type Selected" is "Merge Unit"
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

            group("Other Payments")
            {
                Editable = Rec."BLRProposal Status" <> Rec."BLRProposal Status"::Approved;
                part("Revenue"; "BLRRevenue Item SubPage Card")
                {
                    SubPageLink = BLRProposalID = FIELD("BLRProposal ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                }
            }

            group("Proposal Status")  // Add a separate group for clarity
            {
                field("ProposalStatus"; Rec."BLRProposal Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Proposal Status';
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

            field("Is any Broker Involved?"; Rec."BLRIs any Broker Involved?")
            {
                ApplicationArea = All;
                ToolTip = 'Indicates whether any broker is involved in the lease proposal. If true, broker details will be displayed.';
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
                        MonthlyRent: Decimal;
                        Percentageamt: Integer;

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
                            Rec."BLRBase Amount Type" := VendorProfileRec."BLRBase Amount Type";
                            Rec."BLRFrequency Of Payment" := VendorProfileRec."BLRFrequency Of Payment";
                            Rec."BLRPercentage" := VendorProfileRec."BLRPercentage";

                            Percentageamt := Rec."BLRPercentage"; // used for calculations

                            case UpperCase(Rec."BLRCalculation Method") of
                                'FIXED AMOUNT':
                                    Rec."BLRAmount" := VendorProfileRec."BLRAmount";
                                'STANDARD RATE':
                                    if Rec."BLRBase Amount Type" = Rec."BLRBase Amount Type"::"Monthly Rent" then begin
                                        MonthlyRent := Rec."BLRRent Amount";
                                        Rec."BLRAmount" := Round(MonthlyRent / 12, 0.01); // 2 decimal rounding
                                    end;
                                'PERCENTAGE BASED':
                                    if Rec."BLRBase Amount Type" = Rec."BLRBase Amount Type"::"Annual Rent" then begin
                                        MonthlyRent := Rec."BLRRent Amount";
                                        Rec."BLRAmount" := Round((MonthlyRent * Percentageamt) / 100, 0.01);
                                    end;
                            end;
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

                field("Contract Status"; Rec."BLRContract Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Contract Status';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Save")
            {
                Caption = 'Save';
                ApplicationArea = All;
                Image = Save;
                ToolTip = 'Save';
                trigger OnAction()
                begin
                    Rec.Modify(true);
                end;
            }
        }

        area(Reporting)
        {
            action("Lease Proposal Document")
            {
                ApplicationArea = All;
                ToolTip = 'Generate Lease Proposal Document';
                Image = Document;

                trigger OnAction()
                var
                    LeasePrposal: Record "BLRLeaseProposalDetails";
                    ReportRequest: Report "BLRProposal Report";
                begin
                    Commit();
                    LeasePrposal.SetRange("BLRProposal ID", Rec."BLRProposal ID");
                    ReportRequest.SetTableView(LeasePrposal);
                    ReportRequest.Run();
                end;
            }
            action("Other Payment Document")
            {
                ApplicationArea = All;
                ToolTip = 'Generate Other Payment Document';
                Image = Document;
                trigger OnAction()
                var
                    RevenueItemSubpage: Record "BLRRevenueItemSubpage";
                    ReportRequest: Report "BLROther Payment Details";
                begin
                    Commit();
                    RevenueItemSubpage.Reset();
                    RevenueItemSubpage.SetRange(BLRProposalID, Rec."BLRProposal ID");
                    ReportRequest.SetTableView(RevenueItemSubpage);
                    ReportRequest.Run();
                end;
            }
        }
        area(Promoted)
        {
            actionref(Save_; Save) { }
        }
    }


    var
        EnableSingleUnit: Boolean;
        EnableMergeUnit: Boolean;

    trigger OnAfterGetRecord()
    begin
        CurrPage."Revenue".Page.SetProposalId(Rec."BLRProposal ID");
        CurrPage."Revenue".Page.SetStartEndDate(Rec."BLRLease Start Date", Rec."BLRLease End Date", Rec."BLRUnit Name", Rec."BLRProperty Name", Rec."BLRUnit Size", Rec."BLRTenant Full Name");
        CurrPage."Revenue".Page.SetTenantID(Rec."BLRTenant ID");

        CurrPage."Single Unit Rent".Page.Update();
        CurrPage."Merge SameSqure Rent".Page.Update();

        CurrPage."Merge Lum_AnnualAmount Rent".Page.Update();
        CurrPage."Single Unit lumpsum Rent".Page.Update();
        UpdateUnitEnableState();
    end;


    trigger OnModifyRecord(): Boolean
    begin
        CurrPage."Revenue".Page.SetProposalId(Rec."BLRProposal ID");
        CurrPage."Revenue".Page.SetStartEndDate(Rec."BLRLease Start Date", Rec."BLRLease End Date", Rec."BLRUnit Name", Rec."BLRProperty Name", Rec."BLRUnit Size", Rec."BLRTenant Full Name");
        CurrPage."Revenue".Page.SetTenantID(Rec."BLRTenant ID");

    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        docAttach: Page "BLRRevenue Item Subpage Card";
    begin
        CurrPage."Revenue".Page.SetProposalId(Rec."BLRProposal ID");
        CurrPage."Revenue".Page.SetStartEndDate(Rec."BLRLease Start Date", Rec."BLRLease End Date", Rec."BLRUnit Name", Rec."BLRProperty Name", Rec."BLRUnit Size", Rec."BLRTenant Full Name");
        CurrPage."Revenue".Page.SetTenantID(Rec."BLRTenant ID");

        docAttach.SetProposalID(Rec."BLRProposal ID");
    end;

    trigger OnOpenPage()
    begin
        UpdateVisibility();
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        RecRef: RecordRef;
        xRecRef: RecordRef;
        IsNewUnmodified: Boolean;
    begin
        RecRef.GetTable(Rec);
        xRecRef.GetTable(xRec);

        IsNewUnmodified := (RecRef.Count = 0) or (Format(Rec) = Format(xRec));

        if IsNewUnmodified and (CloseAction = ACTION::Cancel) then
            exit(true);

        if CloseAction = ACTION::OK then
            if not IsNewUnmodified then
                Rec.TestField("BLRProperty ID");

        exit(true);
    end;

    var
        ShowLegalReasonFields: Boolean;
        ShowBusinessReasonFields: Boolean;
        ShowLegalReasonFields1: Boolean;
        ShowBusinessReasonFields2: Boolean;
        ShowLegalReasonFields3: Boolean;
        ShowLegalReasonFields4: Boolean;

    local procedure UpdateUnitEnableState()
    begin
        case Rec."BLRPraposal Type Selected" of
            Rec."BLRPraposal Type Selected"::"Single Unit":
                begin
                    EnableSingleUnit := true;
                    EnableMergeUnit := false;
                end;
            Rec."BLRPraposal Type Selected"::"Merge Unit":
                begin
                    EnableSingleUnit := false;
                    EnableMergeUnit := true;
                end;
            else
                EnableSingleUnit := false;
                EnableMergeUnit := false;
        end;
    end;

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
