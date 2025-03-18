page 90501 "TPV Setup"
{
    Caption = 'TPV Setup', Comment = 'ESP="Configuración TPV"';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "TPV Setup";

    layout
    {
        area(Content)
        {
            group(Setup)
            {
                Caption = 'Settings', Comment = 'ESP="Ajustes"';
                field(Active; Rec.Active) { }
                field("Exchange rates for FCY"; Rec."Exchange rates for FCY") { }
            }
            group(Limits)
            {
                Caption = 'Limits', Comment = 'ESP="Límites"';
                field("Cash Transaction Limit"; Rec."Cash Transaction Limit") { }
                field("Simplified Invoice Limit"; Rec."Simplified Invoice Limit") { }
            }
            group(Posting)
            {
                Caption = 'Posting', Comment = 'ESP="Registro"';
                field("Journal Template Name"; Rec."Journal Template Name") { }
                field("Journal Batch Name"; Rec."Journal Batch Name") { }
            }
            group(Test)
            {
                field(TestSimplTransaction; Rec.TestSimplTransaction) { }
            }
        }
    }
}