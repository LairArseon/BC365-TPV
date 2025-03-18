page 90513 "TPV Posted Tender Lines Part"
{
    Caption = 'Posted Lines', Comment = 'ESP="Líneas registradas"';
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "TPV Posted Tender Line";

    layout
    {
        area(Content)
        {
            repeater(PostedLines)
            {

                field("Currency Code"; Rec."Currency Code") { }
                field("Tender Type"; Rec."Tender Type") { }
                field("Tender Code"; Rec."Tender Code") { }
                field(Quantity; Rec.Quantity) { }
                field("Amount (LCY)"; Rec."Amount (LCY)") { }
            }
        }
    }
}