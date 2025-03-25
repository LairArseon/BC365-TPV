table 90512 "TPV Sales Point Payment Method"
{
    Caption = 'Sales point payment methods', Comment = 'ESP="Métodos pago punto venta"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Sales Point Code"; Code[20])
        {
            Caption = 'Sales point code', Comment = 'ESP="Código punto venta"';
            TableRelation = "TPV Sales Point";
        }
        field(2; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment method code', Comment = 'ESP="Código método pago"';
            TableRelation = "Payment Method";
            NotBlank = true;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(4; "Bal. Account Type"; enum "Payment Balance Account Type")
        {
            Caption = 'Bal. Account Type', Comment = 'ESP="Tipo Cuenta"';

            trigger OnValidate()
            begin
                "Bal. Account No." := '';
            end;
        }
        field(5; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.', Comment = 'ESP="Número de cuenta"';
            TableRelation = if ("Bal. Account Type" = const("G/L Account")) "G/L Account"
            else
            if ("Bal. Account Type" = const("Bank Account")) "Bank Account";

            trigger OnValidate()
            begin
                if "Bal. Account No." <> '' then
                    TestField("Direct Debit", false);
                if "Bal. Account Type" = "Bal. Account Type"::"G/L Account" then
                    CheckGLAcc("Bal. Account No.");
            end;
        }
        field(6; "Direct Debit"; Boolean)
        {
            Caption = 'Direct Debit', Comment = 'ESP="Débito directo"';

            trigger OnValidate()
            begin
                if not "Direct Debit" then
                    "Direct Debit Pmt. Terms Code" := '';
                if "Direct Debit" then
                    TestField("Bal. Account No.", '');
            end;
        }
        field(7; "Direct Debit Pmt. Terms Code"; Code[10])
        {
            Caption = 'Direct Debit Pmt. Terms Code', Comment = 'ESP="Términos pago débito directo"';
            TableRelation = "Payment Terms";

            trigger OnValidate()
            begin
                if "Direct Debit Pmt. Terms Code" <> '' then
                    TestField("Direct Debit", true);
            end;
        }
        field(8; "Applies Cash Payment Limit"; Boolean)
        {
            Caption = 'Cash Limit', Comment = 'ESP="Límite efectivo"';
        }
        field(9; "Uses Payment Terminal"; Boolean)
        {
            Caption = 'Uses Payment Terminal', Comment = 'ESP="Usa Datáfono"';
        }
    }

    keys
    {
        key(Key1; "Sales Point Code", "Payment Method Code")
        {
            Clustered = true;
        }
    }

    local procedure CheckGLAcc(AccNo: Code[20])
    var
        GLAcc: Record "G/L Account";
    begin
        if AccNo <> '' then begin
            GLAcc.Get(AccNo);
            GLAcc.CheckGLAcc();
            GLAcc.TestField("Direct Posting", true);
        end;
    end;
}