page 50508 "PDC Transactions"
{
    PageType = List;
    SourceTable = "PDC Transaction";
    ApplicationArea = All;
    Caption = 'PDC Transactions List';
    UsageCategory = Lists;
    CardPageId = 50509;
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
                            Rec.SETFILTER("Tenant Name Display", '&&' + TenantFilter + '*')
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
                            Rec.SETRANGE(Rec."Cheque Status", StatusFilter)
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
                            Rec.SETFILTER("Cheque Number", '&&' + ChequeNo + '*')
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
                            Rec.SETFILTER("Cheque Date", '=%1', DateToFilter)
                        else
                            Rec.RESET();

                        CurrPage.UPDATE(false);
                    end;
                }
            }
            repeater(Group)
            {
                field("PDC ID"; Rec."PDC ID") { ToolTip = 'Unique identifier for the PDC transaction.'; }
                field("payment Series"; Rec."payment Series") { ToolTip = 'Payment series associated with the PDC transaction.'; }
                field("Tenant Name"; Rec."Tenant Name Display") { ToolTip = 'Name of the tenant associated with the PDC transaction.'; }
                field("Tenant Id"; Rec."Tenant Id") { ToolTip = 'Identifier for the tenant associated with the PDC transaction.'; }
                field("Contract ID"; Rec."Contract ID") { ToolTip = 'Identifier for the contract associated with the PDC transaction.'; }
                field("Bank Name"; Rec."Bank Name") { ToolTip = 'Name of the bank associated with the PDC transaction.'; }
                field("Cheque Number"; Rec."Cheque Number") { ToolTip = 'Cheque number associated with the PDC transaction.'; }
                field("Cheque Date"; Rec."Cheque Date") { ToolTip = 'Date when the cheque was issued.'; }
                field("Amount"; Rec.Amount) { ToolTip = 'Amount of the PDC transaction.'; }
                field("Status"; Rec."Cheque Status") { ToolTip = 'Current status of the PDC transaction, such as Pending, Cleared, or Rejected.'; }
                field("Approval Status"; Rec."Approval Status") { ToolTip = 'Approval status of the PDC transaction.'; }


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
                        Rec.SETFILTER("Tenant Name Display", '&&' + TenantFilter + '*');

                    if StatusFilter <> StatusFilter::" " then
                        Rec.SETRANGE(Rec."Cheque Status", StatusFilter);

                    if ChequeNo <> '' then
                        Rec.SETFILTER("Cheque Number", '&&' + ChequeNo + '*');

                    if DateToFilter <> 0D then
                        Rec.SETFILTER("Cheque Date", '<=%1', DateToFilter);

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
        PDCTransaction: Record "PDC Transaction";
    begin
        PDCTransaction.SetRange("Cheque Status", PDCTransaction."Cheque Status"::Cancelled);

        if PDCTransaction.FindSet() then
            repeat
                PDCTransaction.Delete(true);
            until PDCTransaction.Next() = 0;
    end;

    var

        TenantFilter: Text[100]; // Filter for Tenant Name

        StatusFilter: Enum "PDC Status Type Enum"; // Filter for Cheque Status
        ChequeNo: Text[20]; // Filter start date
        DateToFilter: Date; // Filter end date



}


