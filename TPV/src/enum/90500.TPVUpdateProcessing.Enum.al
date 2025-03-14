enum 90500 "TPV Update Processing" implements "TPV Update Process"
{
    Caption = 'TPV Processing', Comment = 'ESP="Proceso TPV"';
    Extensible = true;

    value(1; "Payment Process")
    {
        Caption = 'Payment Processing', Comment = 'ESP="Proceso Pago"';
        Implementation = "TPV Update Process" = "TPV Payment Processing";
    }
}