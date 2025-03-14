enum 90501 "TPV Tender Type"
{
    Extensible = true;

    value(1; Coin)
    {
        Caption = 'Coin', Comment = 'ESP="Moneda"';
    }
    value(2; Bill)
    {
        Caption = 'Bill', Comment = 'ESP="Billete"';
    }
}