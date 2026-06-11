page 73209677 "BLRCarryForwardGrid"
{
    PageType = ListPart;
    ApplicationArea = All;
    // UsageCategory = Administration;
    SourceTable = "BLRSecurityDeposit";
    Caption = 'Carry Forward To';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Contract ID"; Rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                    ToolTip = 'Contract ID';
                }
                field("New Contract ID"; Rec."BLRNew_Contract ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'New Contract ID';
                }
                field("Total Amount"; Rec."BLRCarry Forward Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'Total Amount to be carried forward to new contract.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(CarryForward)
            {
                ApplicationArea = All;
                Caption = 'Carry Forward';
                Image = TransferFunds;
                ToolTip = 'Carry forward the security deposit amount to new contract.';
                trigger OnAction()
                var
                    securityDepositRec: Record "BLRSecurityDeposit";

                    securityDepositCard: Page "BLRSecurity Deposit Card";
                    userConfirmed: Boolean;
                begin
                    userConfirmed := Confirm('Do you want Carry forwad secuirty deposit amount?', false);
                    if not userConfirmed then
                        exit;
                    securityDepositRec.Reset();
                    securityDepositRec.Init();

                    if PopulateContractDetails(securityDepositRec, contractId) then begin
                        securityDepositCard.SetRecord(securityDepositRec);
                        securityDepositCard.Run();
                    end;
                end;
            }
        }
    }


    var
        contractId: Integer;

    procedure SetContractId(pContractId: Integer)
    begin
        contractId := pContractId;
    end;

    procedure PopulateContractDetails(var pSecurityDepositRec: Record "BLRSecurityDeposit"; pContractId: Integer): Boolean
    var
        tenancyContractRec: Record "BLRTenancyContract";
    begin

        if tenancyContractRec.Get(pContractId) then begin
            pSecurityDepositRec."BLRContract ID" := pContractId;
            pSecurityDepositRec."BLRTenant Full Name" := tenancyContractRec."BLRCustomer Name";
            pSecurityDepositRec."BLRTenant ID" := tenancyContractRec."BLRTenant ID";
            pSecurityDepositRec."BLRProperty Classification" := tenancyContractRec."BLRProperty Classification";
            pSecurityDepositRec."BLRContract Start Date" := tenancyContractRec."BLRContract Start Date";
            pSecurityDepositRec."BLRContract End Date" := tenancyContractRec."BLRContract End Date";
            pSecurityDepositRec."BLRSecurity Deposit Amount" := tenancyContractRec."BLRSecurity Deposit Amount";
            pSecurityDepositRec."BLRBalance Amount" := tenancyContractRec."BLRSecurity Balanced Amount";
            pSecurityDepositRec.Insert(true);
            exit(true);
        end;
    end;

}