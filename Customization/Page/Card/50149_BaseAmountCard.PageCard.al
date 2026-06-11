page 73209670 "BLRBase Amount Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "BLRBaseAmountDataHeader";
    Caption = 'Base Amount Report';
    Editable = false;
    layout
    {

        area(Content)
        {
            field("Base Amount Type"; Rec."BLRBase Amount Type")
            {
                ApplicationArea = All;
                Caption = 'Base Amount Type';
                ToolTip = 'Specifies the type of base amount, such as Revenue, Collections, Annual Rent, Per Unit Fee, or Hybrid.';
            }
            part(BaseAmountGrid; "BLRBase Amount Report Grid")
            {
                SubPageLink = "BLRHeader No." = FIELD("BLRHeader No."), "BLRLine No." = FIELD("BLRLine No."); // Link to filter attachments for this owner only
                ApplicationArea = All;
                Visible = isBaseAmountVisible;
            }
            part(BaseAmountUnitGrid; "BLRBase Amount Unit Wise Grid")
            {
                SubPageLink = "BLRHeader No." = FIELD("BLRHeader No."), "BLRLine No." = FIELD("BLRLine No."); // Link to filter attachments for this owner only
                ApplicationArea = All;
                Visible = idUnitListVisible;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        case
            Rec."BLRBase Amount Type" of
            'Revenue', 'Collections', 'Annual Rent':
                begin
                    isBaseAmountVisible := true;
                    idUnitListVisible := false;
                end;
            'Per Unit Fee':
                begin
                    isBaseAmountVisible := false;
                    idUnitListVisible := true;
                end;
            'Hybrid':
                begin
                    isBaseAmountVisible := true;
                    idUnitListVisible := true;
                end;
        end;
    end;

    var
        isBaseAmountVisible: Boolean;
        idUnitListVisible:
                Boolean;
}