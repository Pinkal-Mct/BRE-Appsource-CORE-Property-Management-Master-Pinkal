page 73209672 "BLRAdditional Charges Sub Card"
{
    PageType = ListPart;
    ApplicationArea = All;
    // UsageCategory = Administration;
    SourceTable = "BLRAdditionalChargesSub";
    Caption = 'Termination Additional Charges';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                field("Secondary Item Type"; Rec."BLRSecondary Item Type")
                {
                    ApplicationArea = All;
                    Caption = 'Secondary Item Type';
                    ToolTip = 'Enter the Secondary Item Type.';
                    ShowMandatory = true;
                    NotBlank = true;
                }
                field("Amount"; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ShowMandatory = true;
                    NotBlank = true;
                    ToolTip = 'Enter the amount for the additional charge.';
                }

                field("VAT %"; Rec."BLRVAT %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the VAT percentage for the additional charge.';
                    trigger OnValidate()
                    begin
                        CurrPage.Update(); // Refresh the page to apply changes immediately
                    end;
                }

                field("VAT Amount"; Rec."BLRVAT Amount")
                {
                    ApplicationArea = All;
                    Caption = 'VAT Amount';
                    ToolTip = 'Enter the VAT amount for the additional charge.';
                }

                field("Amount Including VAT"; Rec."BLRAmount Including VAT")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Including VAT';
                    ToolTip = 'Enter the total amount including VAT for the additional charge.';
                }

                field("Start Date"; Rec."BLRStart Date")
                {
                    ApplicationArea = All;
                    Caption = 'Start Date';
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'Enter the start date for the additional charge.';
                }

                field("End Date"; Rec."BLREnd Date")
                {
                    ApplicationArea = All;
                    Caption = 'End Date';
                    Lookup = true;
                    Editable = false;
                    ToolTip = 'Enter the end date for the additional charge.';
                }

                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'Enter the Contract ID associated with the additional charge.';
                    Editable = false;
                }

                field("Tenant ID"; Rec."BLRTenant ID")
                {
                    ApplicationArea = All;
                    Lookup = true;
                    Visible = false;
                    ToolTip = 'Enter the Tenant ID associated with the additional charge.';
                    Editable = false;
                }

                field("Invoiced ID"; Rec."BLRInvoiced ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'The ID of the invoice to which this additional charge is linked.';
                    Editable = false;
                }
                field("Unit Type"; Rec."BLRUnit Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Enter the Unit Type associated with the additional charge.';
                    Editable = false;
                    Visible = false;
                }
            }

            group(TotalAmount)
            {
                field("Total Amount"; Rec."BLRTotal Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Enter the total amount for the additional charge.';
                }
                field("Posted Invoice ID"; Rec."BLRPosted Invoice ID")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    Caption = 'Invoice ID';
                    Editable = false;
                    ToolTip = 'Click to view the invoice.';
                    //  DrillDownPageId = "Sales Invoice";
                    trigger OnDrillDown()
                    var
                        SalesHeader: Record "Sales Header";

                        postedsalesinvoice: Record "Sales Invoice Header";
                    begin
                        SalesHeader.SetRange("No.", Rec."BLRPosted Invoice ID");
                        if SalesHeader.FindFirst() then
                            PAGE.Run(PAGE::"Sales Invoice", SalesHeader)
                        else begin
                            postedsalesinvoice.SetRange("No.", Rec."BLRPosted Invoice ID");
                            if postedsalesinvoice.FindFirst() then
                                PAGE.Run(PAGE::"Posted Sales Invoice", postedsalesinvoice);

                        end;
                    end;

                }
                field("Invoice Document"; Rec."BLRInvoice Document")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Invoice Document';
                    ToolTip = 'Click to view the invoice document.';

                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin
                        FileURL := Rec."BLRInvoice Document URL";
                        if FileURL = '' then
                            Error('No document is available to view.');
                        OpenFileInBrowser(FileURL);
                    end;
                }
                field("Invoice Document URL"; Rec."BLRInvoice Document URL")
                {
                    ApplicationArea = All;
                    Caption = 'Invoice Document URL';
                    ToolTip = 'Click to view the invoice document.';
                    Editable = false;
                    Visible = false;
                }

            }
        }
    }

    procedure OpenFileInBrowser(URL: Text)
    begin

        if URL <> '' then
            Hyperlink(URL)
        else
            Error('The file URL is invalid.');
    end;

    procedure SetContractID(pContractID: Integer)
    begin
        contractID := pContractID;
    end;

    procedure SetTenantID(pTenantID: Code[20])
    begin
        tenantID := pTenantID;
    end;


    procedure SetStartEndDate(pStartDate: Date; pEndDate: Date)
    begin
        startDate := pStartDate;
        endDate := pEndDate;

    end;

    procedure SetUnitType(punittype: Text[100])
    begin
        unittype := punittype;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec."BLRContract ID" := ContractID;
        Rec."BLRTenant ID" := tenantID;

        Rec."BLRStart Date" := startDate;
        Rec."BLREnd Date" := endDate;
        Rec."BLRUnit Type" := CopyStr(unittype, 1, StrLen(unittype));
    end;


    var
        contractID: Integer;
        tenantID: Code[20];
        startDate: Date;
        endDate: Date;

        unittype: Text[100];

}