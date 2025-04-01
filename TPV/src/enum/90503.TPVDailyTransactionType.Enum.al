enum 90503 "TPV Daily Transaction Type"
{
    Extensible = true;

    value(1; "Order Charge")
    {
        Caption = 'Order Charge', Comment = 'ESP="Cobro de Pedido"';
    }
    value(2; "Chargeback")
    {
        Caption = 'Chargeback', Comment = 'ESP="Devolución"';
    }
    value(3; "Invoice Charge")
    {
        Caption = 'Invoice Charge', Comment = 'ESP="Cobro de Factura"';
    }
    value(4; "Older Invoice Charge")
    {
        Caption = 'Previous Invoice Charge', Comment = 'ESP="Cobro factura anterior"';
    }
}