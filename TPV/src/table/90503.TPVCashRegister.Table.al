table 90503 "TPV Cash Register"
{
    Caption = 'TPV Cash Register', Comment = 'ESP="Caja Registradora TPV"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'Cash Reg. No.', Comment = 'ESP="Nº Caja"';
        }
        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date', Comment = 'ESP="Fecha Registro"';
        }
        field(3; "From Time"; Time)
        {
            Caption = 'From Time', Comment = 'ESP="Desde Hora"';
        }
        field(4; "To Time"; Time)
        {
            Caption = 'To Time', Comment = 'ESP="Hasta Hora"';
        }
        field(5; "Empty on Post"; Boolean)
        {
            Caption = 'Empty when posting', Comment = 'ESP="Vaciar al registrar"';
        }
        field(6; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(7; "Partially Emptied on Post"; Boolean)
        {
            Caption = 'Partially emptied on post', Comment = 'ESP="Parcialmente vaciada al registrar"';
        }
        field(10; "Total Tender Amount"; Decimal)
        {
            Caption = 'Tender Amount Total', Comment = 'ESP="Cantidad total efectivo"';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("TPV Tender Line".Amount where("Cash Register No." = field("No.")));
        }
        field(11; "Total Tender Amount (LCY)"; Decimal)
        {
            Caption = 'Tender Amount Total (LCY)', Comment = 'ESP="Cantidad total efectivo (DL)"';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("TPV Tender Line"."Amount (LCY)" where("Cash Register No." = field("No.")));
        }
        field(12; "Payment Terminal Amount"; Decimal)
        {
            Caption = 'Payment Terminal Total', Comment = 'ESP="Total Datáfono"';
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

    procedure Serialize(var CashRegisterJson: JsonObject)
    var
        TPVDataManagement: Codeunit "TPV Data Management";
        RecRef: RecordRef;
    begin
        RecRef.Get(Rec.RecordId);
        TPVDataManagement.Serialize(RecRef, CashRegisterJson);
    end;
}