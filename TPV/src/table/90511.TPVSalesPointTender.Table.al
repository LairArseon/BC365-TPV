table 90511 "TPV Sales Point - Tender"
{
    Caption = 'Sales point tender', Comment = 'ESP="Moneda de punto de venta"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Sales Point Code"; Code[20])
        {
            Caption = 'Sales Point Code', Comment = 'ESP="Cód. Punto venta"';
        }
        field(2; "Currency Code"; Code[10])
        {
            TableRelation = Currency;
        }
        field(3; "Tender Type"; Enum "TPV Tender Type")
        {
            Caption = 'Tender Type', Comment = 'ESP="Tipo Moneda"';
        }
        field(4; "Tender Code"; Code[10])
        {
            Caption = 'Tender Code', Comment = 'ESP="Código Moneda"';
            TableRelation = "TPV Currency-Tender"."Tender Code" where("Currency Code" = field("Currency Code"));
        }
    }

    keys
    {
        key(Key1; "Sales Point Code", "Currency Code", "Tender Type", "Tender Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }
}