page 73209714 "BLRPDRRevenueAllocationGrid"
{
    PageType = List;
    SourceTable = "BLRPDRRevenueAllocationDetails";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Praposal ID"; Rec."BLRPraposal ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'The unique identifier for the proposal.';
                }
                field(Year; Rec."BLRYear")
                {
                    ApplicationArea = All;
                    ToolTip = 'The year for which the revenue allocation is being made.';
                }
                field("Unit ID"; Rec."BLRUnit ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'The identifier for the unit associated with the proposal.';
                    trigger OnDrillDown()
                    var
                        LeaseProposal: Record "BLRLeaseProposalDetails"; // Assuming Lease Proposal record
                        NewAllocationDetails: Record "BLRPDRRevenueAllocationDetails";
                        SingleUnitNames: Text;
                    begin
                        // Fetch the related Lease Proposal record dynamically (assuming there is a relationship between them)
                        if LeaseProposal.Get(Rec."BLRPraposal ID") then begin
                            // Fetch the unit names dynamically from Lease Proposal
                            SingleUnitNames := GetLeaseUnitNames(LeaseProposal);

                            // Set the SingleUnitNames field in the new revenue allocation grid
                            NewAllocationDetails."BLRUnit ID" := CopyStr(SingleUnitNames, 1, 2048);

                            // Open the new grid page and pass the NewAllocationDetails record
                            PAGE.Run(PAGE::"BLRPDRRevenueAllocationGrid", NewAllocationDetails);
                        end;
                    end;
                }
                field("Sq. Ft."; Rec."BLRSq. Ft.")
                {
                    ApplicationArea = All;
                    ToolTip = 'The square footage of the unit associated with the proposal.';
                }
                field("Per Day Rent Per Unit"; Rec."BLRPer Day Rent Per Unit")
                {
                    ApplicationArea = All;
                    ToolTip = 'The rent amount per day for the unit associated with the proposal.';
                }
                field("Total Revenue"; Rec."BLRTotal Revenue")
                {
                    ApplicationArea = All;
                    ToolTip = 'The total revenue generated from the proposal.';
                }
            }
        }
    }

    //-----------------Get Lease Unit Name -----------------//
    local procedure GetLeaseUnitNames(var LeaseProposal: Record "BLRLeaseProposalDetails"): Text
    var
        Result: Text;
    begin
        // Initialize Result as an empty string
        Result := '';

        // Dynamically fetch unit names related to Lease Proposal
        // This is an example and should be adapted based on how unit names are linked to the Lease Proposal.

        // Assuming the Lease Proposal has a relation to units (could be a list or multiple fields like "UnitName1", "UnitName2", etc.)
        if LeaseProposal."BLRSingle Unit Name" <> '' then begin
            if Result <> '' then
                Result := Result + ', '; // Add a comma separator if it's not the first entry
            Result := Result + LeaseProposal."BLRSingle Unit Name";
        end;

        if LeaseProposal."BLRSingle Unit Name" <> '' then begin
            if Result <> '' then
                Result := Result + ', ';
            Result := Result + LeaseProposal."BLRSingle Unit Name";
        end;

        if LeaseProposal."BLRSingle Unit Name" <> '' then begin
            if Result <> '' then
                Result := Result + ', ';
            Result := Result + LeaseProposal."BLRSingle Unit Name";
        end;

        // If there are many units or a dynamic list, you can loop through the related records

        // Return the concatenated result
        exit(Result);
    end;

    //-----------------Get Lease Unit Name -----------------//
}
