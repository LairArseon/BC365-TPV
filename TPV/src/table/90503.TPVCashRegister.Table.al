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
        field(6; Description; Text[250])
        {
            Caption = 'Details', Comment = 'ESP="Observaciones"';
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
        field(13; "Remaining Tender Amount"; Decimal)
        {
            Caption = 'Remaining Amount', Comment = 'ESP="Cantidad restante"';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("TPV Tender Line"."Remaining Amount" where("Cash Register No." = field("No.")));
        }
        field(14; "Remaining Tender Amount (LCY)"; Decimal)
        {
            Caption = 'Remaining Amount (LCY)', Comment = 'ESP="Cantidad restante (DL)"';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("TPV Tender Line"."Remaining Amount (LCY)" where("Cash Register No." = field("No.")));
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

    procedure InitDayRecord(CurrentDate: Date; CashRegisterNo: Code[20])
    var
        TPVPostedCashRegister: Record "TPV Posted Cash Register";
        InitTime: Time;
        IsHandled: Boolean;
    begin
        OnBeforeInitDayRecord(IsHandled);
        if IsHandled then
            exit;

        InitTime := Time();

        Rec.Init();
        Rec.Validate("No.", CashRegisterNo);
        Rec.Insert(true);

        Rec.Validate("Posting Date", CurrentDate);
        Rec.Validate("From Time", InitTime);
        Rec.Modify(true);

        TPVPostedCashRegister.SetRange("No.", CashRegisterNo);
        if TPVPostedCashRegister.FindLast() then
            if not TPVPostedCashRegister."Emptied on Post" then
                TPVPostedCashRegister.ReactivatePostedTenderLines(Rec)
            else
                CreateBaseTenderLines(Rec)
        else
            CreateBaseTenderLines(Rec);

        OnAfterInitDayRecord();
    end;

    local procedure CreateBaseTenderLines(TPVCashRegister: Record "TPV Cash Register")
    var
        TPVSalesPointTender: Record "TPV Sales Point - Tender";
        TPVTenderLine: Record "TPV Tender Line";
        LineNo: Integer;
        IsHandled: Boolean;
    begin
        OnBeforeCreateBaseTenderLines(IsHandled);
        if IsHandled then
            exit;

        LineNo := 10000;

        TPVSalesPointTender.SetRange("Sales Point Code", TPVCashRegister."No.");
        if TPVSalesPointTender.FindSet() then
            repeat
                TPVTenderLine.Init();
                TPVTenderLine.Validate("Cash Register No.", TPVSalesPointTender."Sales Point Code");
                TPVTenderLine.Validate("From Time", TPVCashRegister."From Time");
                TPVTenderLine.Validate("Currency Code", TPVSalesPointTender."Currency Code");
                TPVTenderLine.Validate("Tender Type", TPVSalesPointTender."Tender Type");
                TPVTenderLine.Validate("Tender Code", TPVSalesPointTender."Tender Code");
                TPVTenderLine.Insert(true);
                LineNo += 10000;

            until TPVSalesPointTender.Next() = 0;


        OnAfterCreateBaseTenderLines();
    end;

    procedure CalcTerminalPaymetsTotal() TotalPaid: Decimal
    var
        TPVSalesPointPaymentMethod: Record "TPV Sales Point Payment Method";
        TPVPostedPaymentLine: Record "TPV Posted Payment Line";
        TerminalPaymentFilter: Text;
        IsHandled: Boolean;
    begin
        OnBeforeCalcTerminalPaymetsTotal(TotalPaid, IsHandled);
        if IsHandled then
            exit;

        TPVSalesPointPaymentMethod.SetRange("Sales Point Code", Rec."No.");
        TPVSalesPointPaymentMethod.SetRange("Uses Payment Terminal", true);
        if TPVSalesPointPaymentMethod.IsEmpty then
            exit;
        TPVSalesPointPaymentMethod.FindSet();
        repeat
            TerminalPaymentFilter += TPVSalesPointPaymentMethod."Payment Method Code" + '|';
        until TPVSalesPointPaymentMethod.Next() = 0;
        TerminalPaymentFilter := TerminalPaymentFilter.TrimEnd('|');

        TPVPostedPaymentLine.SetRange("Sales Point", Rec."No.");
        TPVPostedPaymentLine.SetRange("Posting Date", Rec."Posting Date");
        TPVPostedPaymentLine.SetRange("Posting Time", 0T, Time()); // TODO revisar la fecha de creacion de la caja
        TPVPostedPaymentLine.SetFilter("Payment Method", TerminalPaymentFilter);
        TPVPostedPaymentLine.CalcSums("Amount");
        TotalPaid := TPVPostedPaymentLine."Amount";

        OnAfterCalcTerminalPaymetsTotal(TotalPaid);
    end;

    procedure CalcCashPaymetsTotal() TotalPaid: Decimal
    var
        TPVSalesPointPaymentMethod: Record "TPV Sales Point Payment Method";
        TPVPostedPaymentLine: Record "TPV Posted Payment Line";
        TerminalPaymentFilter: Text;
        IsHandled: Boolean;
    begin
        OnBeforeCalcCashPaymetsTotal(TotalPaid, IsHandled);
        if IsHandled then
            exit;

        TPVSalesPointPaymentMethod.SetRange("Sales Point Code", Rec."No.");
        TPVSalesPointPaymentMethod.SetRange("Applies Cash Payment Limit", true);
        if TPVSalesPointPaymentMethod.IsEmpty then
            exit;
        TPVSalesPointPaymentMethod.FindSet();
        repeat
            TerminalPaymentFilter += TPVSalesPointPaymentMethod."Payment Method Code" + '|';
        until TPVSalesPointPaymentMethod.Next() = 0;
        TerminalPaymentFilter := TerminalPaymentFilter.TrimEnd('|');

        TPVPostedPaymentLine.SetRange("Sales Point", Rec."No.");
        TPVPostedPaymentLine.SetRange("Posting Date", Rec."Posting Date");
        TPVPostedPaymentLine.SetRange("Posting Time", 0T, Time()); // TODO revisar la fecha de creacion de la caja
        TPVPostedPaymentLine.SetFilter("Payment Method", TerminalPaymentFilter);
        TPVPostedPaymentLine.CalcSums("Amount");
        TotalPaid := TPVPostedPaymentLine."Amount";

        OnAfterCalcCashPaymetsTotal(TotalPaid);
    end;

    #region Integration Events

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInitDayRecord(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitDayRecord()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateBaseTenderLines(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateBaseTenderLines()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcTerminalPaymetsTotal(var TotalPaid: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalcTerminalPaymetsTotal(var TotalPaid: Decimal)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcCashPaymetsTotal(var TotalPaid: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalcCashPaymetsTotal(var TotalPaid: Decimal)
    begin
    end;

    #endregion Integration Events

}