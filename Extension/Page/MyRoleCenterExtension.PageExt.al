pageextension 50104 "MyRoleCenterExtension" extends "Business Manager Role Center"
{
    actions
    {
        addfirst(sections)
        {
            group(Action42)
            {
                Caption = 'Property Management';

                action(CountryList)
                {
                    Caption = 'Countries';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Country List";
                    ToolTip = 'View list of countries.';
                }
                action(EmirateList)
                {
                    Caption = 'Emirates';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Emirate List";
                    ToolTip = 'View list of emirates.';
                }
                action(CommunityList)
                {
                    Caption = 'Communities';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Community List";
                    ToolTip = 'View list of communities.';
                }

                action(PropertyClassification)
                {
                    Caption = 'Property Classifications';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Primary Classification List";
                    ToolTip = 'View list of property classifications.';
                }
                action(PropertyType)
                {
                    Caption = 'Property Types';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Property Type List";
                    ToolTip = 'View list of property types.';
                }
                action(UnitType)
                {
                    Caption = 'Unit Types';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Secondary Classification List";
                    ToolTip = 'View list of unit types.';
                }

                action(OwnerProfile)
                {
                    Caption = 'Owner Profiles';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Owner Profile List";
                    ToolTip = 'View list of owner profiles.';
                }
                action(TenantProfile)
                {
                    Caption = 'Tenant Profiles';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Customer List";
                    ToolTip = 'View list of tenant profiles.';
                }
                action(UOM)
                {
                    Caption = 'Unit of Measure';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Units of Measure";
                    ToolTip = 'View list of units of measure.';
                }
                action(PrimaryItemList)
                {
                    Caption = 'Primary Items';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Primary Item List";
                    ToolTip = 'View list of primary items.';
                }
                action(SecondaryItemList)
                {
                    Caption = 'Secondary Items';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Secondary Items";
                    ToolTip = 'View list of secondary items.';

                }
                action(CategoryList)
                {
                    Caption = 'Categories';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Category List";
                    ToolTip = 'View list of categories.';
                }
                action(BankAccountList)
                {
                    Caption = 'Bank Accounts';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Bank Account List";
                    ToolTip = 'View list of bank accounts.';
                }
                action(PaymentTypeList)
                {
                    Caption = 'Payment Types';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Payment Type List";
                    ToolTip = 'View list of payment types.';
                }
                action(VendorCategoryList)
                {
                    Caption = 'Vendor Categories';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Vendor Category List";
                    ToolTip = 'View list of vendor categories.';
                }
                action(CalculationTypeList)
                {
                    Caption = 'Calculation Types';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Calculation Type List";
                    ToolTip = 'View list of calculation types.';
                }

                action(PeopertyRegistration)
                {
                    Caption = ' Property Registrations';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Property Registration List";
                    ToolTip = 'View list of property registrations.';
                }

                action(UnitList)
                {
                    Caption = 'Unit Registrations';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Item List";
                    RunPageView = where("Item type template" = const("Unit Service"));
                    ToolTip = 'View list of unit registrations.';
                }
                action(LeaseProposal)
                {
                    Caption = 'Lease Proposals';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Lease Proposal List";
                    ToolTip = 'View list of lease proposals.';
                }

                action(TenancyContract)
                {
                    Caption = 'Tenancy Contracts';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Tenancy Contract List";
                    ToolTip = 'View list of tenancy contracts.';
                }

                action(MergeUnits)
                {
                    Caption = 'Merge Units';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Merged Units List";
                    ToolTip = 'View list of merged units.';
                }
                action(RentCalculation)
                {
                    Caption = 'Rent Calculation';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Rent Calculation List";

                    ToolTip = 'View list of rent calculations.';
                }

                action(Paymentschedule)
                {
                    Caption = 'Payment Schedule';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Payment Schedule List";
                    ToolTip = 'View list of payment schedules.';
                }
                action(PaymentMode)
                {
                    Caption = 'Payment Mode';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Payment Mode List";
                    ToolTip = 'View list of payment modes.';
                }

                action(PDCTransactions)
                {
                    Caption = 'PDC Transactions';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "PDC Transactions";
                    ToolTip = 'View list of PDC transactions.';
                }

                action(ApprovalContractStatus)
                {
                    Caption = 'Approval Contract Status';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Approval Contract Status List";
                    ToolTip = 'View list of approval contract statuses.';
                }
                action(ConytractRenewal)
                {
                    Caption = 'Contract Renewal';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Contract Renewal List";
                    ToolTip = 'View list of contract renewals.';
                }

                action(SecurityDeposit)
                {
                    Caption = 'Security Deposit';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Security Deposit List";
                    ToolTip = 'View list of security deposits.';
                }

                action(FinalCalculation)
                {
                    Caption = 'Final Calculation';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Final Calculation List";
                    ToolTip = 'View list of final calculations.';
                }

                action(ContractEndProcessApproval)
                {
                    Caption = 'Contract End Process Approval';
                    ApplicationArea = Basic, Suite;
                    RunObject = Page "Contract End Process Approval";
                    ToolTip = 'View list of contract end process approvals.';
                }

            }
        }
    }
}