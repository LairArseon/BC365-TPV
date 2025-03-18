page 90512 "TPV Posted Cash Registers"
{
    Caption = 'TPV Posted Cash Registers', Comment = 'ESP="Cajas Registradas TPV"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "TPV Posted Cash Register";
    // Editable = false; // TODO

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("No."; Rec."No.") { }
                field(Description; Rec.Description) { }
                field("Total Tender Amount (LCY)"; Rec."Total Tender Amount (LCY)") { }
                field("Posting Date"; Rec."Posting Date") { }
            }
        }
        area(FactBoxes)
        {
            part(TPVPostedTenderLines; "TPV Posted Tender Lines Part")
            {
                Caption = 'Lines', Comment = 'ESP="Líneas"';
                SubPageLink = "Cash Register No." = field("No."),
                                "Posting Date" = field("Posting Date"),
                                "From Time" = field("From Time"),
                                "To Time" = field("To Time");
            }
        }
    }
}