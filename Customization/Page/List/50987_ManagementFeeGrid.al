page 73209752 "BLRManagement Fee GridListPart"
{
    PageType = ListPart;
    SourceTable = "BLRManagementFeeGrid";
    ApplicationArea = All;
    Caption = 'Management Fee Agreements';

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Entry No."; Rec."BLREntry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                    ToolTip = 'System-generated entry number for the management fee record.';
                    Editable = false;
                    Visible = false;

                }

                field("Management Fee Number"; Rec."BLRManagement Fee Number")
                {
                    ApplicationArea = All;
                    Caption = 'Management Fee No.';
                    ToolTip = 'Specifies the management fee master or PMC reference number.';
                    Editable = false;
                    Visible = false;
                }

                field("Vendor ID"; Rec."BLRVendor ID")
                {
                    ApplicationArea = All;
                    Caption = 'PMC Vendor ID';
                    ToolTip = 'Specifies the vendor ID of the property management company.';
                    Editable = false;
                    Visible = false;
                }
                field("Owner ID"; Rec."BLROwner ID")
                {
                    ApplicationArea = All;
                    Caption = 'Owner ID';
                    ToolTip = 'Specifies the unique identifier for the owner of the property.';
                }

                field("Company/Owner Name"; Rec."BLRCompany/Owner Name")
                {
                    ApplicationArea = All;
                    Caption = 'Company / Owner Name';
                    ToolTip = 'Specifies the legal owner of the property.';
                    Editable = false;


                }

                field("Property Name"; Rec."BLRProperty Name")
                {
                    ApplicationArea = All;
                    Caption = 'Property Name';
                    ToolTip = 'Specifies the name of the property for which the management fee is defined.';
                }

                field("BLRPropertyType"; Rec."BLRProperty Type")
                {
                    ApplicationArea = All;
                    Caption = 'Property Type';
                    ToolTip = 'Specifies whether the property is Residential or Commercial.';
                    Editable = false;
                }

                field("Calculation Method"; Rec."BLRCalculation Method")
                {
                    ApplicationArea = All;
                    Caption = 'Calculation Method';
                    ToolTip = 'Specifies how the management fee is calculated, such as percentage of revenue, annual rent, collections, per unit, or hybrid.';
                    trigger OnValidate()
                    begin
                        case
                            Rec."BLRCalculation Method" of
                            Rec."BLRCalculation Method"::"Per Unit Fee":
                                Rec.BLRPercentage := 0;
                            Rec."BLRCalculation Method"::"Percentage of Monthly Revenue", Rec."BLRCalculation Method"::"Percentage of Collections", Rec."BLRCalculation Method"::"Percentage of Annual Rent":
                                Rec."BLRAmount" := 0;
                        end;
                        Percentageeditablevalidation := AccessiblePercentagefields();
                        Amounteditablevalidation := AccessibleAmountfield();
                    end;
                }


                field("Calculation Sub-Type"; Rec."BLRCalculation Sub-Type")
                {
                    ApplicationArea = All;
                    Caption = 'Calculation Sub-Type';
                    ToolTip = 'Specifies whether the calculation is percentage-based or a fixed amount.';
                }

                field("Percentage Type"; Rec."BLRPercentage Type")
                {
                    ApplicationArea = All;
                    Caption = 'Percentage Type';
                    ToolTip = 'Specifies whether the percentage applied is fixed or variable.';
                }
                field(Percentage; Rec.BLRPercentage)
                {
                    ApplicationArea = All;
                    Caption = 'Percentage';
                    ToolTip = 'Specifies the agreed Percentage for management fee calculation.';
                    BlankZero = true;
                    Editable = Percentageeditablevalidation;
                }
                field("Amount"; Rec."BLRAmount")
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the agreed fixed amount for management fee calculation.';
                    Editable = Amounteditablevalidation;
                }

                field("Base Amount Source"; Rec."BLRBase Amount Source")
                {
                    ApplicationArea = All;
                    Caption = 'Base Amount Source';
                    ToolTip = 'Specifies the base amount used for fee calculation, such as revenue, collections, or annual rent.';
                }

                field("Payment Frequency"; Rec."BLRPayment Frequency")
                {
                    ApplicationArea = All;
                    Caption = 'Payment Frequency';
                    ToolTip = 'Specifies how often the management fee is calculated, such as monthly, quarterly, half-yearly, or yearly.';
                }

                field("Valid From"; Rec."BLRValid From")
                {
                    ApplicationArea = All;
                    Caption = 'Valid From';
                    ToolTip = 'Specifies the start date from which this management fee agreement is applicable.';
                }

                field("Valid To"; Rec."BLRValid To")
                {
                    ApplicationArea = All;
                    Caption = 'Valid To';
                    ToolTip = 'Specifies the end date until which this management fee agreement is applicable.';
                    trigger OnValidate()
                    begin
                        Rec."BLRValidity Period" := Format(Rec."BLRValid From", 0, '<Day,2>/<Month,2>/<Year4>') + ' To ' + Format(Rec."BLRValid To", 0, '<Day,2>/<Month,2>/<Year4>');
                    end;
                }

                field("Contract Status"; Rec."BLRContract Status")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Status';
                    ToolTip = 'Indicates whether the management fee contract is active or expired.';
                    Editable = false;
                }
                field("Contract Document"; Rec."BLRContract Document")
                {
                    ApplicationArea = All;
                    Caption = 'Contract Document';
                    Editable = false;
                    ToolTip = 'Upload the management fee contract document. Click to upload or view the document.';
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        azureBlobUploader: Codeunit "BLRAzure AD Blob Storage";
                        fileName: Text;
                        uploadResult: Text;
                        folderName: Text;
                    begin

                        folderName := 'ManagementFeeDocument';
                        fileName := azureBlobUploader.ValidateDocument(uploadResult, folderName);
                        if fileName <> '' then begin
                            Rec."BLRView Document" := CopyStr(fileName, 1, StrLen(fileName));
                            Rec."BLRURL Document" := uploadResult;
                            Rec.Modify();
                            Message('File uploaded successfully: %1', fileName);
                        end;
                    end;
                }
                field("View Document"; Rec."BLRView Document")
                {
                    ApplicationArea = All;
                    Caption = 'View Document';
                    Editable = false;
                    DrillDown = true;
                    ToolTip = 'Click to view the uploaded management fee contract document.';
                    trigger OnDrillDown()
                    var
                        FileURL: Text;
                    begin

                        FileURL := Rec."BLRURL Document";


                        if FileURL = '' then
                            Error('No document is available to view.');


                        OpenFileInBrowser(FileURL);
                    end;

                }
                field("Validity Period"; Rec."BLRValidity Period")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Displays the validity period of the management fee agreement, calculated from the Valid From and Valid To dates.';
                }
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

    trigger OnAfterGetRecord()

    begin
        Percentageeditablevalidation := AccessiblePercentagefields();
        Amounteditablevalidation := AccessibleAmountfield();
    end;

    procedure AccessiblePercentagefields(): Boolean
    var
    begin
        if Rec."BLRCalculation Method" <> Rec."BLRCalculation Method"::"Per Unit Fee" then
            exit(true)
        else
            exit(false);
    end;

    procedure AccessibleAmountfield(): Boolean
    begin
        if (Rec."BLRCalculation Method" = Rec."BLRCalculation Method"::Hybrid) OR (Rec."BLRCalculation Method" = Rec."BLRCalculation Method"::"Per Unit Fee") then
            exit(true)
        else
            exit(false);
    end;


    var
        Percentageeditablevalidation: Boolean;
        Amounteditablevalidation: Boolean;

}