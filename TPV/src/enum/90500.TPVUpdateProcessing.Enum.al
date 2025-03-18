enum 90500 "TPV Update Processing" implements "TPV Payment Process"
{
    Caption = 'TPV Processing', Comment = 'ESP="Proceso TPV"';
    Extensible = true;

    value(1; "Payment Process")
    {
        Caption = 'Payment Processing', Comment = 'ESP="Proceso Pago"';
        Implementation = "TPV Payment Process" = "TPV Payment Processing";
    }
}