page 90504 "TPV BC Tender Line Part"
{
    Caption = 'Tender Lines', Comment = 'ESP="Lineas Moneda"';
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "TPV Tender Line";

    layout
    {
        area(Content)
        {
            repeater(TenderLines)
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