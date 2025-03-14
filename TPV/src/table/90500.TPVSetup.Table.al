table 90500 "TPV Setup"
{
    Caption = 'TPV Setup', Comment = 'ESP="Configuración TPV"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary Key"; Code[10]) { }

        field(2; Active; Boolean)
        {
            Caption = 'Active', Comment = 'ESP="Activo"';
        }
        field(3; "Exchange rates for FCY"; Boolean)
        {
            Caption = 'Apply Currency Exchange for FCY', Comment = 'ESP="Aplicar cambios para divisa extranjera"';
        }
        field(4; "Cash Transaction Limit"; Decimal)
        {
            Caption = 'Cash transaction limit', Comment = 'ESP="Límite transacción efectivo"';
        }
        field(5; "Simplified Invoice Limit"; Decimal)
        {
            Caption = 'Simplified invoice limit', Comment = 'ESP="Límite factura simplificada"';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }
}