page 73209731 "Security Deposit Card"
{
    PageType = Card;
    SourceTable = "Security Deposit";
    ApplicationArea = All;
    Caption = 'Security Deposit Transfer';

    layout
    {
        area(content)
        {
            field("Posting Date"; Rec."Posting Date")
            {
                ApplicationArea = All;
                Caption = 'Posting Date';

                trigger OnValidate()
                begin
                    if Rec."Posting Date" > Today() then
                        Error('Posting Date cannot be in the future.');
                end;
            }
            group("Carry Forward From")
            {
                Editable = not (Rec.Status = Rec.Status::Posted);

                field("Security Deposit ID"; rec."Security Deposit ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Security Deposit ID';
                }

                field("Tenant Full Name"; rec."Tenant Full Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Tenant Full Name';
                }


                field("Contract ID"; rec."Contract ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Contract ID';

                    // Trasfer from Table Start  
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        TenancyContractRec: Record "Tenancy Contract";
                    begin
                        if Rec."Tenant Full Name" = '' then
                            Error('Please select a tenant before choosing a contract.');

                        // Filter the contracts by the selected tenant
                        TenancyContractRec.SetRange("Customer Name", Rec."Tenant Full Name");
                        if PAGE.RunModal(PAGE::"Tenancy Contract List", TenancyContractRec) = ACTION::LookupOK then
                            Rec.Validate("Contract ID", TenancyContractRec."Contract ID");

                        FetchContractDetails(Rec."Contract ID", false);
                    end;
                    // Trasfer from Table End
                }

                field("Property Classification"; Rec."Property Classification")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Property Classification';
                }


                field("Contract Start Date"; rec."Contract Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Contract Start Date';
                }

                field("Contract End Date"; rec."Contract End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Contract End Date';
                }

                field("Security Deposit Amount"; rec."Security Deposit Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Security Deposit Amount';
                }

                field("Balance Amount"; rec."Balance Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Balance Amount';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                    StyleExpr = styleExpr;
                    ToolTip = 'Status of the security deposit transfer. Open indicates that the transfer is in progress, while Posted indicates that the transfer has been completed.';
                }
            }

            group("Carry Forward To")
            {
                Editable = not (Rec.Status = Rec.Status::Posted);

                field("New_Contract ID"; rec."New_Contract ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'New Contract ID';

                    // Trasfer from Table Start  
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        TenancyContractRec: Record "Tenancy Contract";
                    begin
                        if Rec."Tenant Full Name" = '' then
                            Error('Please select a tenant before choosing a new contract.');

                        // Filter the contracts by the selected tenant
                        TenancyContractRec.SetRange("Customer Name", Rec."Tenant Full Name");
                        TenancyContractRec.SetRange("Tenant Contract Status", TenancyContractRec."Tenant Contract Status"::Active);


                        if PAGE.RunModal(PAGE::"Tenancy Contract List", TenancyContractRec) = ACTION::LookupOK then
                            Rec."New_Contract ID" := TenancyContractRec."Contract ID";

                        FetchContractDetails(Rec."New_Contract ID", true);
                    end;
                    // Trasfer from Table End
                }

                field("New_Tenant Full Name"; rec."New_Tenant Full Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'New Tenant Full Name';
                }

                field("New_Contract Start Date"; rec."New_Contract Start Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Contract Start Date';
                    ToolTip = 'New Contract Start Date';
                }

                field("New_Contract End Date"; rec."New_Contract End Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Caption = 'Contract End Date';
                    ToolTip = 'New Contract End Date';
                }

                field("New_Security Deposit Amount"; rec."Carry Forward Amount")
                {
                    ApplicationArea = All;
                    ToolTip = 'New Security Deposit Amount';
                }
                field("New Security Amount"; rec."New Security Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'New Security Amount';
                }

                field("New_Balance Amount"; rec."Security Deposit Amt. Received")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'New Balance Amount';
                }

                field("Adjusted amount"; rec."Security Deposit Amt. Pending")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Adjusted Amount';
                }

                field("Narration"; rec."Narration")
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
                Enabled = not (Rec.Status = Rec.Status::Posted);

                trigger OnAction()
                var
                    finalcalculationRec: Record "Final Calculation";
                    SecurityDepositPostMgt: Codeunit "Security Deposit Posting Mgt.";
                begin
                    if Rec."Posting Date" <> 0D then begin

                        if Confirm('Do you want to post journal lines?', true) then begin

                            SecurityDepositPostMgt.PostSecurityDepositAmount(Rec);

                            Rec.UpdateAdjustedAmount();
                            finalcalculationRec.SetRange("Contract ID", Rec."Contract ID");
                            if finalcalculationRec.FindFirst() then begin
                                finalcalculationRec."Total Refundable Deposit" := finalcalculationRec."Security Deposit" + finalcalculationRec."Chiller Deposit" + finalcalculationRec."Other Deposit";
                                finalcalculationRec.Modify(true);
                                finalcalculationRec.CalculateFinalSummary(finalcalculationRec);
                            end;
                            Rec.Status := Rec.Status::Posted;
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
        if Rec.Status = Rec.Status::Open then
            exit('Strong');
        if Rec.Status = Rec.Status::Posted then
            exit('Favorable');
    end;
    // Trasfer from Table Start  
    local procedure FetchContractDetails(ContractID: Integer; IsNewContract: Boolean)
    var
        TenancyContractRec: Record "Tenancy Contract";
        NarrationLbl: Label 'Carry forward of security deposit from %1 to %2.', Comment = '%1 is the old contract ID, %2 is the new contract ID';
    begin
        TenancyContractRec.SetRange("Contract ID", ContractID);
        if TenancyContractRec.FindFirst() then begin
            if IsNewContract then begin
                Rec."New_Contract Start Date" := TenancyContractRec."Contract Start Date";
                Rec."New_Contract End Date" := TenancyContractRec."Contract End Date";
                Rec."New_Tenant Full Name" := TenancyContractRec."Customer Name";
                Rec."New Security Amount" := TenancyContractRec."Security Deposit Amount";
                Rec."Security Deposit Amt. Received" := TenancyContractRec."Security Deposit Amt. Received";
                Rec."Security Deposit Amt. Pending" := TenancyContractRec."Security Amount Pending"; // Update the remaining balance

                // Update the Narration field dynamically
                Rec."Narration" := StrSubstNo(NarrationLbl, Rec."Contract ID", Rec."New_Contract ID");
            end else begin
                Rec."Contract Start Date" := TenancyContractRec."Contract Start Date";
                Rec."Contract End Date" := TenancyContractRec."Contract End Date";
                Rec."Security Deposit Amount" := TenancyContractRec."Security Deposit Amount";
                Rec."Balance Amount" := TenancyContractRec."Security Balanced Amount";
            end;

        end else
            // Clear fields if no record is found
            if IsNewContract then begin
                Clear(Rec."New_Contract Start Date");
                Clear(Rec."New_Contract End Date");
                Clear(Rec."New_Tenant Full Name");
                Clear(Rec."New Security Amount");
                Clear(Rec."Security Deposit Amt. Received");

            end else begin
                Clear(Rec."Contract Start Date");
                Clear(Rec."Contract End Date");
                Clear(Rec."Tenant Full Name");
                Clear(Rec."Security Deposit Amount");
                Clear(Rec."Balance Amount");

            end;

    end;
    // Trasfer from Table End
}