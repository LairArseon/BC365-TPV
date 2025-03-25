table 90510 "TPV Posted Payment Line"
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
        field(5; "Payment Method"; Code[10])
        {
            TableRelation = "TPV Sales Point Payment Method"."Payment Method Code" where("Sales Point Code" = field("Sales Point"));
            Caption = 'Payment Method', Comment = 'ESP="Método pago"';
        }
        field(6; "Posting Date"; Date)
        {
            Caption = 'Posting Date', Comment = 'ESP="Fecha Registro"';
        }
        field(7; "Posting Time"; Time)
        {
            Caption = 'Posting Time', Comment = 'ESP="Hora Registro"';
            Editable = false;
        }
        field(8; "Payment Reference"; Code[50])
        {
            Caption = 'Payment reference', Comment = 'ESP="Referencia pago"';
            Editable = false;
        }
        field(9; "Account No."; Code[20])
        {
            Caption = 'Account No.', Comment = 'ESP="Nº Cuenta"';
            Editable = false;
        }
        field(10; "Amount Total"; Decimal)
        {
            Caption = 'Total Amount', Comment = 'ESP="Cantidad Total"';
        }
        field(11; "Amount Total (Inc. VAT)"; Decimal)
        {
            Caption = 'Total Amount Inc. VAT', Comment = 'ESP="Cantidad Total Con IVA"';
        }
        field(12; "Amount Paid"; Decimal)
        {
            Caption = 'Paid Amount', Comment = 'ESP="Cantidad Pagada"';
        }
        field(13; "Amount Due"; Decimal)
        {
            Caption = 'Amount Due', Comment = 'ESP="Cantidad Pendiente"';
        }
        field(14; "Amount Due (Inc. VAT)"; Decimal)
        {
            Caption = 'Amount Due Inc. VAT', Comment = 'ESP="Cantidad Pendiente Con IVA"';
        }
        field(15; "Amount"; Decimal)
        {
            Caption = 'Amount', Comment = 'ESP="Cantidad"';
        }
        field(16; "Description"; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(17; "Simplified transaction"; Boolean)
        {
            Caption = 'Simplified transaction', Comment = 'ESP="Transacción simplificada"';
        }
        field(18; Refund; Boolean)
        {
            Caption = 'Reimbursement', Comment = 'ESP="Reembolso"';
        }
    }

    keys
    {
        key(Key1; "Source Document", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    procedure Serialize(var PostedPaymentJson: JsonObject)
    var
        TPVDataManagement: Codeunit "TPV Data Management";
        RecRef: RecordRef;
    begin
        RecRef.Get(Rec.RecordId);
        TPVDataManagement.Serialize(RecRef, PostedPaymentJson);
    end;
}