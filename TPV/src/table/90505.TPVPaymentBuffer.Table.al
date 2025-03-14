table 90505 "TPV Payment Buffer"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Source Document"; RecordId)
        {
            Caption = 'Source Document', Comment = 'ESP="Documento Origen"';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.', Comment = 'ESP="Nº Línea"';
        }
        field(3; "Payment Direction"; Enum "TPV Payment Direction")
        {
            Caption = 'Payment direction', Comment = 'ESP="Dirección pago"';
        }
        field(4; "Sales Point"; Code[20])
        {
            Caption = 'Sales Point', Comment = 'ESP="Punto venta"';
        }
        field(5; "Payment Method"; Code[20])
        {
            TableRelation = "TPV Sales Point Payment Method"."Payment Method Code" where("Sales Point Code" = field("Sales Point"));
            Caption = 'Payment Method', Comment = 'ESP="Método pago"';

            trigger OnLookup()
            var
            begin

            end;
        }
        field(10; "Amount Total"; Decimal)
        {
            Caption = 'Total Amount', Comment = 'ESP="Cantidad Total"';
        }
        field(11; "Amount Paid"; Decimal)
        {
            Caption = 'Paid Amount', Comment = 'ESP="Cantidad Pagada"';
        }
        field(12; "Amount Due"; Decimal)
        {
            Caption = 'Amount Due', Comment = 'ESP="Cantidad Pendiente"';
        }
        field(13; "Amount"; Decimal)
        {
            Caption = 'Amount', Comment = 'ESP="Cantidad"';
        }

    }

    keys
    {
        key(Key1; "Source Document")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }
}