table 90509 "TPV Payment Line Buffer"
{
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; "Source Document"; RecordId)
        {
            Caption = 'Source Document', Comment = 'ESP="Documento Origen"';
            Editable = false;
        }
        field(3; "Payment Direction"; Enum "TPV Payment Direction")
        {
            Caption = 'Payment direction', Comment = 'ESP="Dirección pago"';
            Editable = false;
        }
        field(4; "Sales Point"; Code[20])
        {
            Caption = 'Sales Point', Comment = 'ESP="Punto venta"';
            Editable = false;
        }
        field(5; "Payment Method"; Code[10])
        {
            TableRelation = "TPV Sales Point Payment Method"."Payment Method Code" where("Sales Point Code" = field("Sales Point"));
            Caption = 'Payment Method', Comment = 'ESP="Método pago"';
        }
        field(6; "Posting Date"; Date)
        {
            Caption = 'Posting Date', Comment = 'ESP="Fecha Registro"';
            Editable = false;
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
            Editable = false;
        }
        field(11; "Amount Total (Inc. VAT)"; Decimal)
        {
            Caption = 'Total Amount Inc. VAT', Comment = 'ESP="Cantidad Total Con IVA"';
            Editable = false;
        }
        field(12; "Amount Already Paid"; Decimal)
        {
            Caption = 'Paid Amount', Comment = 'ESP="Cantidad Pagada"';
            Editable = false;
        }
        field(13; "Amount Due"; Decimal)
        {
            Caption = 'Amount Due', Comment = 'ESP="Cantidad Pendiente"';
            Editable = false;
        }
        field(14; "Amount Due (Inc. VAT)"; Decimal)
        {
            Caption = 'Amount Due Inc. VAT', Comment = 'ESP="Cantidad Pendiente Con IVA"';
            Editable = false;
        }
        field(15; "Amount"; Decimal)
        {
            Caption = 'Amount', Comment = 'ESP="Cantidad"';

            trigger OnValidate()
            begin
                CheckAmountLimit(Rec);
            end;
        }
        field(16; "Description"; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(17; "Simplified transaction"; Boolean)
        {
            Caption = 'Simplified transaction', Comment = 'ESP="Transacción simplificada"';
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

    procedure CreateLineFromSalesHeader(SalesHeader: Record "Sales Header")
    var
        TVPSetup: Record "TPV Setup";
        PaidAmount: Decimal;
        LineNo: Integer;
    begin
        TVPSetup.Get();
        Rec.Validate("Simplified transaction", TVPSetup.TestSimplTransaction);

        Rec.Validate("Source Document", SalesHeader.RecordId);
        Rec.Validate("Payment Reference", SalesHeader."No.");
        Rec.Validate("Account No.", SalesHeader."Bill-to Customer No.");
        Rec.Validate(Description, SalesHeader."Bill-to Name");

        case SalesHeader."Document Type" of
            Enum::"Sales Document Type"::"Blanket Order", Enum::"Sales Document Type"::Invoice, Enum::"Sales Document Type"::Order, Enum::"Sales Document Type"::Quote:
                Rec.Validate("Payment Direction", Enum::"TPV Payment Direction"::Inbound);
            Enum::"Sales Document Type"::"Credit Memo", Enum::"Sales Document Type"::"Return Order":
                Rec.Validate("Payment Direction", Enum::"TPV Payment Direction"::Outbound);
        end;

        PaidAmount := SalesHeader.CalculatePaidAmount();

        SalesHeader.CalcFields(Amount, "Amount Including VAT");
        Rec.Validate("Amount Total", SalesHeader.Amount);
        Rec.Validate("Amount Total (Inc. VAT)", SalesHeader."Amount Including VAT");
        Rec.Validate("Amount Already Paid", PaidAmount);
        Rec.Validate("Amount Due", "Amount Total" - PaidAmount);
        Rec.Validate("Amount Due (Inc. VAT)", "Amount Total (Inc. VAT)" - PaidAmount);

        Rec.Insert(true);
    end;

    local procedure CheckAmountLimit(var TPVPaymentLineBuffer: Record "TPV Payment Line Buffer" temporary)
    var
        TPVSetup: Record "TPV Setup";
        TPVSalesPointPaymentMethod: Record "TPV Sales Point Payment Method";
        IsHandled: Boolean;
    begin
        OnBeforeCheckAmountLimit(TPVPaymentLineBuffer, IsHandled);
        if IsHandled then
            exit;

        TPVSetup.Get();
        TPVPaymentLineBuffer.TestField("Payment Method");
        TPVSalesPointPaymentMethod.Get(Rec."Sales Point", Rec."Payment Method");

        if TPVSalesPointPaymentMethod."Applies Cash Payment Limit" then
            if TPVPaymentLineBuffer.Amount > TPVSetup."Cash Transaction Limit" then
                Error('Cash transaction limit is %1', TPVSetup."Cash Transaction Limit");

        if TPVPaymentLineBuffer."Simplified transaction" then
            if TPVPaymentLineBuffer.Amount > TPVSetup."Simplified Invoice Limit" then
                Error('Simplified transaction limit is %1', TPVSetup."Simplified Invoice Limit");


        OnAfterCheckAmountLimit(TPVPaymentLineBuffer);
    end;

    procedure Serialize(var PaymentBufferJson: JsonObject)
    var
        TPVDataManagement: Codeunit "TPV Data Management";
        RecRef: RecordRef;
    begin
        RecRef.Open(Rec.RecordId.TableNo);
        RecRef.Copy(Rec, true);
        TPVDataManagement.Serialize(RecRef, PaymentBufferJson);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckAmountLimit(var Rec: Record "TPV Payment Line Buffer" temporary; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckAmountLimit(var Rec: Record "TPV Payment Line Buffer" temporary)
    begin
    end;
}