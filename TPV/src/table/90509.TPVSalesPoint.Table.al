table 90509 "TPV Sales Point"
{
    Caption = 'TPV Sales point', Comment = 'ESP="Punto venta TPV"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Sales Point Code"; Code[20])
        {
            Caption = 'Sales Point Code', Comment = 'ESP="Cód. Punto venta"';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(3; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center', Comment = 'ESP="Centro de Responsabilidad"';
            TableRelation = "Responsibility Center";
        }
    }

    keys
    {
        key(Key1; "Sales Point Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}