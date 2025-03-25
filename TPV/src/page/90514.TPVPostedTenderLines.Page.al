page 90514 "TPV Posted Tender Lines"
{
    Caption = 'Posted Tender Lines', Comment = 'ESP="Lineas Efectivo registradas"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "TPV Posted Tender Line";

    layout
    {
        area(Content)
        {
            repeater(PostedLines)
            {
                field("Cash Register No."; Rec."Cash Register No.") { }
                field("Currency Code"; Rec."Currency Code") { }
                field("Tender Type"; Rec."Tender Type") { }
                field("Tender Code"; Rec."Tender Code") { }
                field("Posting Date"; Rec."Posting Date") { }
                field(Quantity; Rec.Quantity) { }
                field("Amount (LCY)"; Rec."Amount (LCY)") { }
            }
        }
    }
}