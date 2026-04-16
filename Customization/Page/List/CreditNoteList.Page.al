// page 50964 "Credit Note List"
// {
//     PageType = List;
//     SourceTable = "Credit Note";
//     ApplicationArea = All;
//     Caption = 'Credit Note List';
//     UsageCategory = Lists;
//     CardPageId = 50966;


//     layout
//     {
//         area(content)
//         {
//             repeater(Group)
//             {
//                 field("ID"; Rec."ID")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'ID';
//                     Editable = false;
//                     ToolTip = 'Specifies the unique identifier for the credit note.';
//                 }
//                 field("Contract ID"; Rec."Contract ID")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Contract ID';
//                     Editable = false;
//                     ToolTip = 'Specifies the unique identifier for the contract associated with the credit note.';
//                 }
//                 field("Unit Type"; Rec."Unit Type")
//                 {
//                     ApplicationArea = All;
//                     Editable = false;
//                     ToolTip = 'Specifies the type of unit associated with the credit note, such as Residential or Commercial.';
//                 }
//                 field("Contract Amount"; Rec."Contract Amount")
//                 {
//                     ApplicationArea = All;
//                     Editable = false;
//                     ToolTip = 'Specifies the total amount of the contract associated with the credit note.';
//                 }

//                 field("Contract Start Date"; Rec."Contract Start Date")
//                 {
//                     ApplicationArea = All;
//                     Editable = false;
//                     ToolTip = 'Specifies the start date of the contract associated with the credit note.';
//                 }
//                 field("Contract End Date"; Rec."Contract End Date")
//                 {
//                     ApplicationArea = All;
//                     Editable = false;
//                     ToolTip = 'Specifies the end date of the contract associated with the credit note.';
//                 }

//                 field("Tenant ID"; Rec."Tenant ID")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Tenant ID';
//                     Editable = false;
//                     ToolTip = 'Specifies the unique identifier for the tenant associated with the credit note.';
//                 }
//                 field("Tenant Name"; Rec."Tenant Name")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Tenant Name';
//                     Editable = false;
//                     ToolTip = 'Specifies the name of the tenant associated with the credit note.';
//                 }
//                 field("Tenant Email"; Rec."Tenant Email")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Tenant Email';
//                     Editable = false;
//                     ToolTip = 'Specifies the email address of the tenant associated with the credit note.';
//                 }
//                 field("Status"; Rec."Status")
//                 {
//                     ApplicationArea = All;
//                     Caption = 'Status';
//                     Editable = false;
//                     ToolTip = 'Specifies the current status of the credit note, such as Pending, Approved, or Rejected.';
//                 }
//             }
//         }
//     }

// }
