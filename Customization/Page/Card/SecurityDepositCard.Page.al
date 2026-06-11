page 73209731 "BLRSecurity Deposit Card"
{
    PageType = Card;
    SourceTable = "BLRSecurityDeposit";
    ApplicationArea = All;
    Caption = 'Security Deposit Transfer';

    layout
    {
        area(content)
        {
            field("Posting Date"; Rec."BLRPosting Date")
            {
                ApplicationArea = All;
                Caption = 'Posting Date';

                trigger OnValidate()
                begin
                    if Rec."BLRPosting Date" > Today() then
                        Error('Posting Date cannot be in the future.');
                end;
            }
            group("Carry Forward From")
            {
                Editable = not (Rec.BLRStatus = Rec.BLRStatus::Posted);

                field("Security Deposit ID"; rec."BLRSecurity Deposit ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Security Deposit ID';
                }

                field("Tenant Full Name"; rec."BLRTenant Full Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Tenant Full Name';
                }


                field("Contract ID"; rec."BLRContract ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Contract ID';

                    // Trasfer from Table Start  
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        TenancyContractRec: Record "BLRTenancyContract";
                    begin
                        if Rec."BLRTenant Full Name" = '' then
                            Error('Please select a tenant before choosing a contract.');

                        // Filter the contracts by the selected tenant
                        TenancyContractRec.SetRange("BLRCustomer Name", Rec."BLRTenant Full Name");
                        if PAGE.RunModal(PAGE::"BLRTenancy Contract List", TenancyContractRec) = ACTION::LookupOK then
                            Rec.Validate("BLRContract ID", TenancyContractRec."BLRContract ID");

                        FetchContractDetails(Rec."BLRContract ID", false);
                    end;
                    // Trasfer from Table End
                }

                field("Property Classification"; Rec."BLRProperty Classification")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Property Classification';
                }


                field("Contract Start Date"; rec."BLRContract Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Contract Start Date';
                }

                field("Contract End Date"; rec."BLRContract End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Contract End Date';
                }

                field("Security Deposit Amount"; rec."BLRSecurity Deposit Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Security Deposit Amount';
                }

                field("Balance Amount"; rec."BLRBalance Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Balance Amount';
                }
                field(Status; Rec.BLRStatus)
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = styleExpr;
                    ToolTip = 'Status of the security deposit transfer. Open indicates that the transfer is in progress, while Posted indicates that the transfer has been completed.';
                }
            }

            group("Carry Forward To")
            {
                Editable = not (Rec.BLRStatus = Rec.BLRStatus::Posted);

                field("New_Contract ID"; rec."BLRNew_Contract ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'New Contract ID';

                    // Trasfer from Table Start  
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        TenancyContractRec: Record "BLRTenancyContract";
                    begin
                        if Rec."BLRTenant Full Name" = '' then
                            Error('Please select a tenant before choosing a new contract.');

                        // Filter the contracts by the selected tenant
                        TenancyContractRec.SetRange("BLRCustomer Name", Rec."BLRTenant Full Name");
                        TenancyContractRec.SetRange("BLRTenant Contract Status", TenancyContractRec."BLRTenant Contract Status"::Active);


                        if PAGE.RunModal(PAGE::"BLRTenancy Contract List", TenancyContractRec) = ACTION::LookupOK then
                            Rec."BLRNew_Contract ID" := TenancyContractRec."BLRContract ID";

                        FetchContractDetails(Rec."BLRNew_Contract ID", true);
                    end;
                    // Trasfer from Table End
                }

                field("New_Tenant Full Name"; rec."BLRNew_Tenant Full Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'New Tenant Full Name';
                }

                field("New_Contract Start Date"; rec."BLRNew_Contract Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Contract Start Date';
                    ToolTip = 'New Contract Start Date';
                }

                field("New_Contract End Date"; rec."BLRNew_Contract End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Contract End Date';
                    ToolTip = 'New Contract End Date';
                }

                field("New_Security Deposit Amount"; rec."BLRCarry Forward Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'New Security Deposit Amount';
                }
                field("New Security Amount"; rec."BLRNew Security Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'New Security Amount';
                }

                field("New_Balance Amount"; rec."BLRSecDepAmtReceived")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'New Balance Amount';
                }

                field("Adjusted amount"; rec."BLRSecDepAmtPending")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Adjusted Amount';
                }

                field("Narration"; rec."BLRNarration")
                {
                    ApplicationArea = All;
                    Editable = false;
                    MultiLine = true;
                    ToolTip = 'Narration for the security deposit transfer.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(PostSecurityDeposit)
            {
                ApplicationArea = All;
                Caption = 'Post Security Deposit';
                Image = Post;
                ToolTip = 'Post the security deposit transfer and update the final calculation.';
                Enabled = not (Rec.BLRStatus = Rec.BLRStatus::Posted);

                trigger OnAction()
                var
                    finalcalculationRec: Record "BLRFinalCalculation";
                    SecurityDepositPostMgt: Codeunit "BLRSecurityDepositPostingMgt.";
                begin
                    if Rec."BLRPosting Date" <> 0D then begin

                        if Confirm('Do you want to post journal lines?', true) then begin

                            SecurityDepositPostMgt.PostSecurityDepositAmount(Rec);

                            Rec.UpdateAdjustedAmount();
                            finalcalculationRec.SetRange("BLRContract ID", Rec."BLRContract ID");
                            if finalcalculationRec.FindFirst() then begin
                                finalcalculationRec."BLRTotal Refundable Deposit" := finalcalculationRec."BLRSecurity Deposit" + finalcalculationRec."BLRChiller Deposit" + finalcalculationRec."BLROther Deposit";
                                finalcalculationRec.Modify(true);
                                finalcalculationRec.CalculateFinalSummary(finalcalculationRec);
                            end;
                            Rec.BLRStatus := Rec.BLRStatus::Posted;
                            Rec.Modify(true);
                        end
                        else
                            exit;
                    end else
                        Error('Please enter a valid Posting Date before posting the security deposit.');

                end;
            }
        }
    }
    trigger OnAfterGetCurrRecord()
    begin
        styleExpr := GetStatusStyle();
    end;

    var
        styleExpr: Text;

    procedure GetStatusStyle(): Text
    begin
        if Rec.BLRStatus = Rec.BLRStatus::Open then
            exit('Strong');
        if Rec.BLRStatus = Rec.BLRStatus::Posted then
            exit('Favorable');
    end;
    // Trasfer from Table Start  
    local procedure FetchContractDetails(ContractID: Integer; IsNewContract: Boolean)
    var
        TenancyContractRec: Record "BLRTenancyContract";
        NarrationLbl: Label 'Carry forward of security deposit from %1 to %2.', Comment = '%1 is the old contract ID, %2 is the new contract ID';
    begin
        TenancyContractRec.SetRange("BLRContract ID", ContractID);
        if TenancyContractRec.FindFirst() then begin
            if IsNewContract then begin
                Rec."BLRNew_Contract Start Date" := TenancyContractRec."BLRContract Start Date";
                Rec."BLRNew_Contract End Date" := TenancyContractRec."BLRContract End Date";
                Rec."BLRNew_Tenant Full Name" := TenancyContractRec."BLRCustomer Name";
                Rec."BLRNew Security Amount" := TenancyContractRec."BLRSecurity Deposit Amount";
                Rec."BLRSecDepAmtReceived" := TenancyContractRec."BLRSecDepAmtReceived";
                Rec."BLRSecDepAmtPending" := TenancyContractRec."BLRSecurity Amount Pending"; // Update the remaining balance

                // Update the Narration field dynamically
                Rec."BLRNarration" := StrSubstNo(NarrationLbl, Rec."BLRContract ID", Rec."BLRNew_Contract ID");
            end else begin
                Rec."BLRContract Start Date" := TenancyContractRec."BLRContract Start Date";
                Rec."BLRContract End Date" := TenancyContractRec."BLRContract End Date";
                Rec."BLRSecurity Deposit Amount" := TenancyContractRec."BLRSecurity Deposit Amount";
                Rec."BLRBalance Amount" := TenancyContractRec."BLRSecurity Balanced Amount";
            end;

        end else
            // Clear fields if no record is found
            if IsNewContract then begin
                Clear(Rec."BLRNew_Contract Start Date");
                Clear(Rec."BLRNew_Contract End Date");
                Clear(Rec."BLRNew_Tenant Full Name");
                Clear(Rec."BLRNew Security Amount");
                Clear(Rec."BLRSecDepAmtReceived");

            end else begin
                Clear(Rec."BLRContract Start Date");
                Clear(Rec."BLRContract End Date");
                Clear(Rec."BLRTenant Full Name");
                Clear(Rec."BLRSecurity Deposit Amount");
                Clear(Rec."BLRBalance Amount");

            end;

    end;
    // Trasfer from Table End
}