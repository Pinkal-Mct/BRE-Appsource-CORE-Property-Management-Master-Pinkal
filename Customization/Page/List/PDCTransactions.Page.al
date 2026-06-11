page 73209796 "BLRPDC Transactions"
{
    PageType = List;
    SourceTable = "BLRPDCTransaction";
    ApplicationArea = All;
    Caption = 'PDC Transactions List';
    UsageCategory = Lists;
    CardPageId = 73209713;
    layout
    {
        area(content)
        {

            // Filter group for user inputs
            group("Filters")
            {
                field("Tenant Filter"; TenantFilter)
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Filter PDCs by Tenant Name.';
                    Caption = 'Tenant Name Filter';
                    trigger OnValidate()
                    begin
                        if TenantFilter <> '' then
                            Rec.SETFILTER("BLRTenant Name Display", '&&' + TenantFilter + '*')
                        else
                            Rec.RESET();

                        CurrPage.UPDATE(false);
                    end;
                }
                field("Status Filter"; StatusFilter)
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Filter PDCs by Status.';
                    Caption = 'Status Filter';
                    trigger OnValidate()
                    begin
                        if StatusFilter <> StatusFilter::" " then
                            Rec.SETRANGE(Rec."BLRCheque Status", StatusFilter)
                        else
                            Rec.RESET();

                        CurrPage.UPDATE(false);
                    end;
                }
                field("Cheque No"; ChequeNo)
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specify the start date for the filter.';
                    Caption = 'Cheque Number Filter';
                    trigger OnValidate()
                    begin
                        if ChequeNo <> '' then
                            Rec.SETFILTER("BLRCheque Number", '&&' + ChequeNo + '*')
                        else
                            Rec.RESET();

                        CurrPage.UPDATE(false);
                    end;
                }
                field("Due Date"; DateToFilter)
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specify the end date for the filter.';

                    trigger OnValidate()
                    begin
                        if DateToFilter <> 0D then
                            Rec.SETFILTER("BLRCheque Date", '=%1', DateToFilter)
                        else
                            Rec.RESET();

                        CurrPage.UPDATE(false);
                    end;
                }
            }
            repeater(Group)
            {
                field("PDC ID"; Rec."BLRPDC ID") { ToolTip = 'Unique identifier for the PDC transaction.'; }
                field("payment Series"; Rec."BLRpayment Series") { ToolTip = 'Payment series associated with the PDC transaction.'; }
                field("Tenant Name"; Rec."BLRTenant Name Display") { ToolTip = 'Name of the tenant associated with the PDC transaction.'; }
                field("Tenant Id"; Rec."BLRTenant Id") { ToolTip = 'Identifier for the tenant associated with the PDC transaction.'; }
                field("Contract ID"; Rec."BLRContract ID") { ToolTip = 'Identifier for the contract associated with the PDC transaction.'; }
                field("Bank Name"; Rec."BLRBank Name") { ToolTip = 'Name of the bank associated with the PDC transaction.'; }
                field("Cheque Number"; Rec."BLRCheque Number") { ToolTip = 'Cheque number associated with the PDC transaction.'; }
                field("Cheque Date"; Rec."BLRCheque Date") { ToolTip = 'Date when the cheque was issued.'; }
                field("Amount"; Rec."BLRAmount") { ToolTip = 'Amount of the PDC transaction.'; }
                field("Status"; Rec."BLRCheque Status") { ToolTip = 'Current status of the PDC transaction, such as Pending, Cleared, or Rejected.'; }
                field("Approval Status"; Rec."BLRApproval Status") { ToolTip = 'Approval status of the PDC transaction.'; }


            }
        }
    }

    actions
    {
        area(processing)
        {
#pragma warning disable AW0005
            action("Apply Filters")
#pragma warning restore AW0005
            {
                ApplicationArea = All;
                Caption = 'Apply Filters';
                ToolTip = 'Apply the selected filter criteria.';
                trigger OnAction()
                begin
                    if TenantFilter <> '' then
                        Rec.SETFILTER("BLRTenant Name Display", '&&' + TenantFilter + '*');

                    if StatusFilter <> StatusFilter::" " then
                        Rec.SETRANGE(Rec."BLRCheque Status", StatusFilter);

                    if ChequeNo <> '' then
                        Rec.SETFILTER("BLRCheque Number", '&&' + ChequeNo + '*');

                    if DateToFilter <> 0D then
                        Rec.SETFILTER("BLRCheque Date", '<=%1', DateToFilter);

                    CurrPage.UPDATE(false);
                end;
            }

#pragma warning disable AW0005
            action("Clear Filters")
#pragma warning restore AW0005
            {
                ApplicationArea = All;
                Caption = 'Clear Filters';
                ToolTip = 'Clear all applied filters.';
                trigger OnAction()
                begin
                    Rec.RESET();
                    TenantFilter := '';
                    StatusFilter := StatusFilter::" ";
                    ChequeNo := '';
                    DateToFilter := 0D;

                    CurrPage.UPDATE(false);
                end;
            }


        }
    }
    trigger OnOpenPage()
    var
        PDCTransaction: Record "BLRPDCTransaction";
    begin
        PDCTransaction.SetRange("BLRCheque Status", PDCTransaction."BLRCheque Status"::Cancelled);

        if PDCTransaction.FindSet() then
            repeat
                PDCTransaction.Delete(true);
            until PDCTransaction.Next() = 0;
    end;

    var

        TenantFilter: Text[100]; // Filter for Tenant Name

        StatusFilter: Enum "BLRPDC Status Type Enum"; // Filter for Cheque Status
        ChequeNo: Text[20]; // Filter start date
        DateToFilter: Date; // Filter end date



}


