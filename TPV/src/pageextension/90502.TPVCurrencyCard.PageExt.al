pageextension 90502 "TPV Currency Card" extends "Currency Card"
{
    actions
    {
        addlast(processing)
        {
            action(TenderTypes)
            {
                ApplicationArea = All;
                Caption = 'Tender Types', Comment = 'ESP="Tipos Efectivo"';
                Image = Currencies;

                RunObject = Page "TPV Currency - Tender";
                RunPageLink = "Currency Code" = field(Code);
            }
        }
    }
}