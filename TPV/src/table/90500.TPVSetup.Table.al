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
        field(6; "Journal Template Name"; Code[10])
        {
            Caption = 'TPV Payment Template', Comment = 'ESP="Libro registro pagos TPV"';
            TableRelation = "Gen. Journal Template".Name where(Type = filter(Payments));
        }
        field(7; "Journal Batch Name"; Code[10])
        {
            Caption = 'General TPV Payment Batch', Comment = 'ESP="Sección general registro pagos TPV"';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));
        }
        field(100; "TestSimplTransaction"; Boolean)
        {
            Caption = 'Test Simpl transaction', Comment = 'ESP="Prueba transaccion simpl"';
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