page 50149 "Base Amount Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Base Amount Data Header";
    Caption = 'Base Amount Report';
    Editable = false;
    layout
    {

        area(Content)
        {
            field("Base Amount Type"; Rec."Base Amount Type")
            {
                ApplicationArea = All;
                Caption = 'Base Amount Type';
                ToolTip = 'Specifies the type of base amount, such as Revenue, Collections, Annual Rent, Per Unit Fee, or Hybrid.';
            }
            part(BaseAmountGrid; "Base Amount Report Grid")
            {
                SubPageLink = "Header No." = FIELD("Header No."), "Line No." = FIELD("Line No."); // Link to filter attachments for this owner only
                ApplicationArea = All;
                Visible = isBaseAmountVisible;
            }
            part(BaseAmountUnitGrid; "Base Amount Unit Wise Grid")
            {
                SubPageLink = "Header No." = FIELD("Header No."), "Line No." = FIELD("Line No."); // Link to filter attachments for this owner only
                ApplicationArea = All;
                Visible = idUnitListVisible;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        case
            Rec."Base Amount Type" of
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