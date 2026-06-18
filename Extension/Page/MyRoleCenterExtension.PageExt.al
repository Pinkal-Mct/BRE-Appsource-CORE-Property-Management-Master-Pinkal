pageextension 73209604 "BLRMyRoleCenterExtension" extends "Business Manager Role Center"
{
    actions
    {
        addfirst(sections)
        {
            group(BLRAction42)
            {
                Caption = 'Property Management';

                action(BLRCountryList)
                {
                    Caption = 'Countries';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "BLRCountry List";
                    ToolTip = 'View list of countries.';
                }
                action(BLREmirateList)
                {
                    Caption = 'Emirates';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "BLREmirate List";
                    ToolTip = 'View list of emirates.';
                }
                action(BLRCommunityList)
                {
                    Caption = 'Communities';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "BLRCommunity List";
                    ToolTip = 'View list of communities.';
                }

                action(BLRPropertyClassification)
                {
                    Caption = 'Property Classifications';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "BLRPrimary Classification List";
                    ToolTip = 'View list of property classifications.';
                }
                action(BLRPropertyType)
                {
                    Caption = 'Property Types';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "BLRProperty Type List";
                    ToolTip = 'View list of property types.';
                }
                action(BLRUnitType)
                {
                    Caption = 'Unit Types';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "BLRSecondaryClassificationList";
                    ToolTip = 'View list of unit types.';
                }

                action(BLROwnerProfile)
                {
                    Caption = 'Owner Profiles';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "BLROwner Profile List";
                    ToolTip = 'View list of owner profiles.';
                }
                action(BLRTenantProfile)
                {
                    Caption = 'Tenant Profiles';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Customer List";
                    ToolTip = 'View list of tenant profiles.';
                }
                action(BLRUOM)
                {
                    Caption = 'Unit of Measure';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Units of Measure";
                    ToolTip = 'View list of units of measure.';
                }
                action(BLRPrimaryItemList)
                {
                    Caption = 'Primary Items';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "BLRPrimary Item List";
                    ToolTip = 'View list of primary items.';
                }
                action(BLRSecondaryItemList)
                {
                    Caption = 'Secondary Items';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "BLRSecondary Items";
                    ToolTip = 'View list of secondary items.';

                }
                action(BLRCategoryList)
                {
                    Caption = 'Categories';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "BLRCategory List";
                    ToolTip = 'View list of categories.';
                }
                action(BLRBankAccountList)
                {
                    Caption = 'Bank Accounts';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Bank Account List";
                    ToolTip = 'View list of bank accounts.';
                }
                action(BLRPaymentTypeList)
                {
                    Caption = 'Payment Types';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "BLRPayment Type List";
                    ToolTip = 'View list of payment types.';
                }
                action(BLRVendorCategoryList)
                {
                    Caption = 'Vendor Categories';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "BLRVendor Category List";
                    ToolTip = 'View list of vendor categories.';
                }
                action(BLRCalculationTypeList)
                {
                    Caption = 'Calculation Types';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "BLRCalculation Type List";
                    ToolTip = 'View list of calculation types.';
                }

                action(BLRPeopertyRegistration)
                {
                    Caption = ' Property Registrations';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "BLRProperty Registration List";
                    ToolTip = 'View list of property registrations.';
                }

                action(BLRUnitList)
                {
                    Caption = 'Unit Registrations';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Item List";
                    RunPageView = where("BLRItem type template" = const("Unit Service"));
                    ToolTip = 'View list of unit registrations.';
                }
                action(BLRLeaseProposal)
                {
                    Caption = 'Lease Proposals';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "BLRLease Proposal List";
                    ToolTip = 'View list of lease proposals.';
                }

                action(BLRTenancyContract)
                {
                    Caption = 'Tenancy Contracts';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "BLRTenancy Contract List";
                    ToolTip = 'View list of tenancy contracts.';
                }

                action(BLRMergeUnits)
                {
                    Caption = 'Merge Units';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "BLRMerged Units List";
                    ToolTip = 'View list of merged units.';
                }
                action(BLRRentCalculation)
                {
                    Caption = 'Rent Calculation';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "BLRRent Calculation List";

                    ToolTip = 'View list of rent calculations.';
                }

                action(BLRPaymentschedule)
                {
                    Caption = 'Payment Schedule';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "BLRPayment Schedule List";
                    ToolTip = 'View list of payment schedules.';
                }
                action(BLRPaymentMode)
                {
                    Caption = 'Payment Mode';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "BLRPayment Mode List";
                    ToolTip = 'View list of payment modes.';
                }

                action(BLRPDCTransactions)
                {
                    Caption = 'PDC Transactions';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "BLRPDC Transactions";
                    ToolTip = 'View list of PDC transactions.';
                }

                action(BLRApprovalContractStatus)
                {
                    Caption = 'Approval Contract Status';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "BLRApproval ContractStatusList";
                    ToolTip = 'View list of approval contract statuses.';
                }
                action(BLRConytractRenewal)
                {
                    Caption = 'Contract Renewal';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "BLRContract Renewal List";
                    ToolTip = 'View list of contract renewals.';
                }

                action(BLRSecurityDeposit)
                {
                    Caption = 'Security Deposit';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "BLRSecurity Deposit List";
                    ToolTip = 'View list of security deposits.';
                }

                action(BLRFinalCalculation)
                {
                    Caption = 'Final Calculation';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "BLRFinal Calculation List";
                    ToolTip = 'View list of final calculations.';
                }

                action(BLRContractEndProcessApproval)
                {
                    Caption = 'Contract End Process Approval';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "BLRContract EndProcessApproval";
                    ToolTip = 'View list of contract end process approvals.';
                }

            }
        }
    }
}