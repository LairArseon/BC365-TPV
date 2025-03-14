table 90504 "TPV Currency-Tender"
{
    Caption = 'TPV Tender Type', Comment = 'ESP="Tipo Moneda TPV"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Currency Code"; Code[10])
        {
            TableRelation = Currency;
        }
        field(2; "Tender Type"; Enum "TPV Tender Type")
        {
            Caption = 'Tender Type', Comment = 'ESP="Tipo Moneda"';
        }
        field(3; "Tender Code"; Code[10])
        {
            Caption = 'Tender Code', Comment = 'ESP="Código Moneda"';
        }
        field(4; "Tender Name"; Text[30])
        {
            Caption = 'Tender Name', Comment = 'ESP="Nombre Moneda"';
        }
        field(5; "Tender Value"; Decimal)
        {
            Caption = 'Tender Value', Comment = 'ESP="Valor Moneda"';
        }
    }

    keys
    {
        key(Key1; "Currency Code", "Tender Type", "Tender Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Currency Code", "Tender Type", "Tender Code", "Tender Name")
        {

        }
    }
}