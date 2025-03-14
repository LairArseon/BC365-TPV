pageextension 90501 "TPV Currencies" extends Currencies
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