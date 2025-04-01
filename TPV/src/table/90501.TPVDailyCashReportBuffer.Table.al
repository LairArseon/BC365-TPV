table 90501 "TPV Daily Cash Report Buffer"
{
    Caption = 'Daily cash register buffer', Comment = 'ESP="Buffer registro caja diario"';
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.', Comment = 'ESP="Nº"';
        }
        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date', Comment = 'ESP="Fecha Registro"';
        }
        field(3; "Document No."; Code[20])
        {
            Caption = 'Document No.', Comment = 'ESP="Nº Documento"';
        }
        field(4; "Customer No."; Code[20])
        {
            Caption = 'Customer No.', Comment = 'ESP="Cod. Cliente"';
        }
        field(5; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name', Comment = 'ESP="Nombre Cliente"';
        }
        field(6; "Amount"; Decimal)
        {
            Caption = 'Amount', Comment = 'ESP="Importe"';
        }
        field(7; "Paid Amount"; Decimal)
        {
            Caption = 'Paid Amount', Comment = 'ESP="Cobrado"';
        }
        field(8; "Payment Method"; Code[20])
        {
            Caption = 'Payment method', Comment = 'ESP="Método pago"';
        }
        field(9; "Transaction Type"; Enum "TPV Daily Transaction Type")
        {
            Caption = 'Transaction Type', Comment = 'ESP="Tipo Transacción"';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }
}