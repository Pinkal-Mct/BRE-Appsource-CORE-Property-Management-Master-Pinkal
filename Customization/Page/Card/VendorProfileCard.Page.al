page 73209749 "BLRVendor Profile Card"
{
    PageType = Card;
    SourceTable = "BLRVendorProfile";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Identification")
            {
                Caption = 'Vendor Identification Details';

                field("Vendor ID"; Rec."BLRVendor ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    ToolTip = 'Specifies the unique identifier for the vendor.';
                    trigger OnValidate()
                    begin
                        brokeragesectionpopulated()
                    end;
                }

                field("Vendor Name"; Rec."BLRVendor Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the vendor.';
                }

                field("Vendor Contact No."; Rec."BLRVendor Contact No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the contact number of the vendor.';
                }

                field("Start Date"; Rec."BLRStart Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the start date of the contract with the vendor.';
                }

                field("End Date"; Rec."BLREnd Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the end date of the contract with the vendor.';
                }
                field("BLRVendorCategory"; Rec."BLRVendor Category")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the category of the vendor.';
                    trigger OnValidate()
                    begin
                        if UpperCase(Rec."BLRVendor Category") = 'BROKERS AND COMMISSION AGENT' then
                            ShowBrokerageGroup := true
                        else
                            ShowBrokerageGroup := false;

                    end;
                }

                field("Privacy Blocked"; Rec."BLRPrivacy Blocked")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the vendor is privacy blocked.';
                }
                field("Last Date Modified"; Rec."BLRLast Date Modified")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the last date when the vendor details were modified.';
                }
                field("Document Sending Profile"; Rec."BLRDocument Sending Profile")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the document sending profile for the vendor.';
                }
                field("Search Name"; Rec."BLRSearch Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the search name for the vendor, used for quick identification.';
                }
                field("IC Partner Code"; Rec."BLRIC Partner Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the intercompany partner code for the vendor, used for transactions between companies.';
                }
                field("Purchaser Code"; Rec."BLRPurchaser Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the purchaser code for the vendor, used for identifying the purchaser in transactions.';
                }
                field("Responsibility Center"; Rec."BLRResponsibility Center")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the responsibility center for the vendor, used for managing vendor-related responsibilities.';
                }
                field("Disable Search by Name"; Rec."BLRDisable Search by Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the search by name is disabled for the vendor.';
                }
                field("Company Size Code"; Rec."BLRCompany Size Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the company size code for the vendor, used for categorizing vendors based on their size.';
                }

                field("Contract Status"; Rec."BLRContract Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the vendor contract, indicating whether it is active, expired, or terminated.';
                }

                field(Blocked; Rec."BLRBlocked")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether the vendor is blocked for transactions.';
                }
                field("Balance (LCY)"; Rec."BLRBalance (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total balance of the vendor in local currency (LCY). This includes all amounts due to the vendor, such as unpaid invoices and credit memos.';
                }

                field("Balance Due (LCY)"; Rec."BLRBalance Due (LCY)")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total balance due to the vendor in local currency (LCY). This is the amount that is currently outstanding and needs to be paid to the vendor.';
                }
            }

            group("Brokers and Commission Agent Details")
            {
                Visible = ShowBrokerageGroup;
                field("Calculation Method"; Rec."BLRCalculation Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the method of calculation for the vendor, such as fixed amount or percentage based.';
                    trigger OnValidate()
                    begin
                        UpdateFieldEditability();
                    end;
                }

                field("Percentage Type"; Rec."BLRPercentage Type")
                {
                    ApplicationArea = All;
                    Editable = IsPercentageTypeEditable;
                    ToolTip = 'Specifies the type of percentage used for the vendor calculation, such as revenue or collection.';
                }
                field("Base Amount Type"; Rec."BLRBase Amount Type")
                {
                    ApplicationArea = All;
                    Editable = IsBaseamount;
                    ToolTip = 'Specifies the type of base amount used for the vendor calculation, such as monthly rent or other types.';

                    trigger OnValidate()
                    begin
                        UpdateFieldEditability();
                    end;
                }

                field("Percentage"; Rec."BLRPercentage")
                {
                    ApplicationArea = All;
                    Editable = IsPercentageEditable;
                    ToolTip = 'Specifies the percentage used for the vendor calculation. This field is editable only if the calculation method is set to percentage based.';
                }

                field("Amount"; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    Editable = IsAmountEditable;
                    ToolTip = 'Specifies the amount used for the vendor calculation. This field is editable only if the calculation method is set to fixed amount.';
                }

                field("Frequency Of Payment"; Rec."BLRFrequency Of Payment")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the frequency of payment for the vendor, such as monthly or quarterly.';
                }
            }

            group("Address & Contact")
            {
                Caption = 'Address & Contact';
                group(AddressDetails)
                {
                    Caption = 'Address';
                    field(Address; Rec.BLRAddress)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the primary address of the vendor.';
                    }
                    field("Address 2"; Rec."BLRAddress 2")
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the secondary address of the vendor, if applicable.';
                    }

                    field(Country; Rec.BLRCountry)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the country of the vendor.';
                    }
                }
                field("Phone No."; Rec."BLRPhone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the primary phone number of the vendor.';
                }
                field(MobilePhoneNo; Rec."BLRMobile Phone No.")
                {
                    ApplicationArea = All;
                    Caption = 'Mobile Phone No.';
                    ToolTip = 'Specifies the mobile phone number of the vendor.';
                }
                field("E-Mail"; Rec."BLRE-Mail")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the email address of the vendor.';
                }
                field("Home Page"; Rec."BLRHome Page")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the home page or website of the vendor.';
                }
                field("Our Account No."; Rec."BLROur Account No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the account number assigned to the vendor by your organization.';
                }
                group(Contact)
                {
                    Caption = 'Contact';
                    field("Primary Contact Code"; Rec."BLRPrimary Contact Code")
                    {
                        ApplicationArea = All;
                        Caption = 'Primary Contact Code';
                        ToolTip = 'Specifies the primary contact code for the vendor, used to identify the main point of contact.';
                    }
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';

                field("VAT Registration No."; Rec."BLRVAT Registration No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the VAT registration number of the vendor, if applicable.';
                }
                field("Price Calculation Method"; Rec."BLRPrice Calculation Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the method used for calculating prices with the vendor, such as standard or negotiated rates.';
                }
                field("Price Including VAT"; Rec."BLRPrice Including VAT")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether prices are calculated including VAT or not.';
                }

            }
            group(Payments)
            {
                Caption = 'Payments';

                field("Application Method"; Rec."BLRApplication Method")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the method used for applying payments to the vendor, such as automatic or manual.';
                }
                field("Payment Terms Code"; Rec."BLRPayment Terms Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payment terms code for the vendor, used for payment processing.';
                }
                field("Payment Method Code"; Rec."BLRPayment Method Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payment method code for the vendor, used to determine how payments are made.';
                }
                field(Priority; Rec.BLRPriority)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the priority of the vendor for payment processing. Higher priority vendors may be paid first.';
                }
                field("Block Payment Tolerance"; Rec."BLRBlock Payment Tolerance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies whether payment tolerance is blocked for the vendor. If blocked, any discrepancies in payment amounts will prevent processing.';
                }
                field("Preferred Bank Account Code"; Rec."BLRPreferred Bank Account Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the preferred bank account code for the vendor, used for processing payments.';
                }
                field("Partner Type"; Rec."BLRPartner Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of partner for the vendor, such as customer or vendor.';
                }
                field("Cash Flow Payment Terms Code"; Rec."BLRCashFlowPmtTermsCode")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the cash flow payment terms code for the vendor, used for managing cash flow related to vendor payments.';
                }
                field("Creditor No."; Rec."BLRCreditor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the creditor number assigned to the vendor, used for accounting and financial reporting purposes.';
                }
            }
            group(Receiving)
            {
                Caption = 'Receiving';
                field("Location Code"; Rec."BLRLocation Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the location code for the vendor, used to identify where goods or services are received.';
                }
                field("Shipment Method Code"; Rec."BLRShipment Method Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shipment method code for the vendor, used to determine how goods are shipped from the vendor.';
                }
                field("Lead Time Calculation"; Rec."BLRLead Time Calculation")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the lead time calculation method for the vendor, used to determine how long it takes to receive goods or services.';
                }
                field("Base Calendar Code"; Rec."BLRBase Calendar Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the base calendar code for the vendor, used to determine working days and lead times.';
                }
            }
            field("Over-Receipt Code"; Rec."BLROver-Receipt Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the over-receipt code for the vendor, used to manage situations where more goods are received than ordered.';
            }
            field("Receive E-Document To"; Rec."BLRReceive E-Document To")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies where electronic documents related to the vendor are received, such as a specific email address or system.';
            }

            group("Calculation Details")
            {
                Caption = 'Calculation Details';
                Visible = IsVisibleCommission;
                part("Calculation Detail"; "BLRVendorCalculationDetailsSub")
                {
                    SubPageLink = "BLRVendor ID" = FIELD("BLRVendor ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                }
            }

            group("BLRVendorDocument")
            {
                Caption = 'Vendor Document';
                part("Vendor Documents"; "BLRVendor Document Sub")
                {
                    SubPageLink = "BLRVendor ID" = FIELD("BLRVendor ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                }
            }

            group("Contract Document")
            {
                Caption = 'Invoice/Receipt Documents';
                part("Contract Documents"; "BLRVendor I/R DocumentSub")
                {
                    SubPageLink = "BLRVendor ID" = FIELD("BLRVendor ID"); // Link to filter attachments for this owner only
                    ApplicationArea = All;
                }
            }
        }
    }

    procedure brokeragesectionpopulated()
    begin
        if UpperCase(Rec."BLRVendor Category") = 'BROKERS AND COMMISSION AGENT' then
            ShowBrokerageGroup := true
        else
            ShowBrokerageGroup := false;

    end;

    trigger OnAfterGetRecord()
    begin
        CurrPage."Contract Documents".Page.SetVendorID(Rec."BLRVendor ID");
        CurrPage."Calculation Detail".Page.SetVendorID(Rec."BLRVendor ID");
        CurrPage."Calculation Detail".Page.SetStartEndDate(Rec."BLRStart Date", Rec."BLREnd Date", Rec."BLRVendor Name");
        CurrPage."Vendor Documents".Page.SetVendorID(Rec."BLRVendor ID");

        if UpperCase(Rec."BLRVendor Category") = 'BROKERS AND COMMISSION AGENT' then
            ShowBrokerageGroup := true
        else
            ShowBrokerageGroup := false;

        UpdateFieldEditability();
        UpdateVisibility();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        CurrPage."Contract Documents".Page.SetVendorID(Rec."BLRVendor ID");
        CurrPage."Calculation Detail".Page.SetVendorID(Rec."BLRVendor ID");
        CurrPage."Calculation Detail".Page.SetStartEndDate(Rec."BLRStart Date", Rec."BLREnd Date", Rec."BLRVendor Name");
        CurrPage."Vendor Documents".Page.SetVendorID(Rec."BLRVendor ID");
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        CurrPage."Contract Documents".Page.SetVendorID(Rec."BLRVendor ID");
        CurrPage."Calculation Detail".Page.SetVendorID(Rec."BLRVendor ID");
        CurrPage."Calculation Detail".Page.SetStartEndDate(Rec."BLRStart Date", Rec."BLREnd Date", Rec."BLRVendor Name");
        CurrPage."Vendor Documents".Page.SetVendorID(Rec."BLRVendor ID");
    end;

    var
        ShowBrokerageGroup: Boolean;
        IsAmountEditable: Boolean;
        IsPercentageEditable: Boolean;
        IsPercentageTypeEditable: Boolean;
        IsBaseamount: Boolean;
        IsVisibleCommission: Boolean;

    local procedure UpdateVisibility()
    begin
        IsVisibleCommission := (UpperCase(Rec."BLRVendor Category") <> 'BROKERS AND COMMISSION AGENT');
    end;

    procedure UpdateFieldEditability()
    begin
        case UpperCase(Rec."BLRCalculation Method") of
            '':
                begin
                    IsAmountEditable := false;
                    IsPercentageEditable := false;
                    IsPercentageTypeEditable := false;
                    IsBaseamount := false;
                end;

            'FIXED AMOUNT':
                begin
                    IsAmountEditable := true;
                    IsPercentageEditable := false;
                    IsPercentageTypeEditable := false;
                    IsBaseamount := false;
                end;

            'PERCENTAGE BASED':
                begin
                    IsAmountEditable := false;
                    IsPercentageEditable := true;
                    IsPercentageTypeEditable := true;
                    IsBaseamount := true;
                end;

            'STANDARD RATE':
                begin

                    if Rec."BLRBase Amount Type" <> Rec."BLRBase Amount Type"::"Monthly Rent" then
                        Rec."BLRBase Amount Type" := Rec."BLRBase Amount Type"::"Monthly Rent";

                    if Rec."BLRBase Amount Type" = Rec."BLRBase Amount Type"::"Monthly Rent" then begin
                        IsAmountEditable := false;
                        IsPercentageEditable := false;
                        IsPercentageTypeEditable := false;
                        IsBaseamount := false;
                    end;
                end;

            else begin
                IsAmountEditable := false;
                IsPercentageEditable := false;
                IsPercentageTypeEditable := false;
                IsBaseamount := false;
            end;
        end;
    end;
}