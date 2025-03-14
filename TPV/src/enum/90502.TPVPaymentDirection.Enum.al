enum 90502 "TPV Payment Direction"
{
    Caption = 'Payment direction', Comment = 'ESP="Dirección pago"';
    Extensible = true;

    value(1; Inbound)
    {
        Caption = 'Charge', Comment = 'ESP="Cobro"';
    }
    value(2; Outbound)
    {
        Caption = 'Refund', Comment = 'ESP="Reembolso"';
    }
}