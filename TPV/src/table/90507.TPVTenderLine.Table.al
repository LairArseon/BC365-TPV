table 90507 "TPV Tender Line"
{
    Caption = 'TPV Tender Line', Comment = 'ESP="Linea Moneda TPV"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Cash Register No."; Code[20])
        {
            Caption = 'Cash register No.', Comment = 'ESP="Nº Caja registradora"';
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
        field(6; "Currency Code"; Code[10])
        {
            TableRelation = Currency;
        }
        field(7; "Tender Type"; Enum "TPV Tender Type")
        {
            Caption = 'Tender Type', Comment = 'ESP="Tipo Moneda"';
        }
        field(8; "Tender Code"; Code[10])
        {
            Caption = 'Tender Code', Comment = 'ESP="Código Moneda"';
            TableRelation = "TPV Currency-Tender"."Tender Code" where("Currency Code" = field("Currency Code"));
        }
        field(9; Quantity; Decimal)
        {
            Caption = 'Quantity', Comment = 'ESP="Cantidad"';

            trigger OnValidate()
            begin
                Rec.TestField("Currency Code");
                Rec.TestField("Tender Type");
                Rec.TestField("Tender Code");

                Rec.CalculateLineAmount();
            end;
        }
        field(10; Amount; Decimal)
        {
            Caption = 'Total monetary value', Comment = 'ESP="Valor monetario total"';

            trigger OnValidate()
            begin
                Rec.CalculateLCYAmount();
            end;
        }
        field(11; "Amount (LCY)"; Decimal)
        {
            Caption = 'Total monetary value (LCY)', Comment = 'ESP="Valor monetario total (DL)"';
        }
        field(12; "Remaining Quantity"; Decimal)
        {
            Caption = 'Leftover Cash', Comment = 'ESP="Fondo Caja"';

            trigger OnValidate()
            begin
                Rec.TestField("Currency Code");
                Rec.TestField("Tender Type");
                Rec.TestField("Tender Code");

                Rec.CalculateLineRemainingAmount();
            end;
        }
        field(13; "Remaining Amount"; Decimal)
        {
            Caption = 'Remaining monetary value', Comment = 'ESP="Valor monetario restante"';
        }
        field(14; "Remaining Amount (LCY)"; Decimal)
        {
            Caption = 'Remaining monetary amount (LCY)', Comment = 'ESP="Valor monetario restante (DL)"';
        }

    }

    keys
    {
        key(Key1; "Cash Register No.", "Currency Code", "Tender Type", "Tender Code")
        {
            Clustered = true;
        }
    }

    procedure GetLineCurrencyTenderInfo() CurrencyTenderInfo: Text
    var
        CurrencyTenderInfoBuilder_Tok: Label '%1 - %2 %3', Locked = true;
    begin
        CurrencyTenderInfo := StrSubstNo(CurrencyTenderInfoBuilder_Tok, Rec."Tender Code", Rec."Tender Type", Rec."Currency Code");
    end;

    procedure ClearLines(CashRegisterNo: Code[20])
    var
        TPVTenderLine: Record "TPV Tender Line";
        IsHandled: Boolean;
    begin
        OnBeforeClearLines(CashRegisterNo, IsHandled);
        if IsHandled then
            exit;

        TPVTenderLine.SetRange("Cash Register No.", CashRegisterNo);
        TPVTenderLine.DeleteAll(true);

        OnAfterClearLines(CashRegisterNo);
    end;

    procedure CalculateLineAmount()
    var
        CurrencyTender: Record "TPV Currency-Tender";
        IsHandled: Boolean;
    begin
        OnBeforeCalculateLineAmount(IsHandled);
        if IsHandled then
            exit;

        CurrencyTender.Get(Rec."Currency Code", Rec."Tender Type", Rec."Tender Code");
        Rec.Validate(Amount, Rec.Quantity * CurrencyTender."Tender Value");

        OnAfterCalculateLineAmount();
    end;

    procedure CalculateLineRemainingAmount()
    var
        CurrencyTender: Record "TPV Currency-Tender";
        IsHandled: Boolean;
    begin
        OnBeforeCalculateLineRemainingAmount(IsHandled);
        if IsHandled then
            exit;

        CurrencyTender.Get(Rec."Currency Code", Rec."Tender Type", Rec."Tender Code");
        Rec.Validate("Remaining Amount", Rec.Quantity * CurrencyTender."Tender Value");

        OnAfterCalculateLineRemainingAmount();
    end;

    procedure CalculateLCYAmount()
    var
        TPVSetup: Record "TPV Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        CurrencyExchangeFactor, AmountLCY : Decimal;
        IsHandled: Boolean;
    begin
        OnBeforeCalculateLCYAmount(IsHandled);
        if IsHandled then
            exit;

        GeneralLedgerSetup.Get();
        if Rec."Currency Code" = GeneralLedgerSetup.GetCurrencyCode('') then begin
            Rec."Amount (LCY)" := Rec.Amount;
            exit;
        end;

        TPVSetup.Get();
        if not TPVSetup."Exchange rates for FCY" then
            exit;

        CurrencyExchangeFactor := CurrencyExchangeRate.GetCurrentCurrencyFactor(Rec."Currency Code");
        AmountLCY := CurrencyExchangeRate.ExchangeAmtFCYToLCY(Rec."Posting Date", Rec."Currency Code", Rec.Amount, CurrencyExchangeFactor);

        Rec.Validate("Amount (LCY)", AmountLCY);

        OnAfterCalculateLCYAmount();
    end;

    procedure CalculateLCYRemainingAmount()
    var
        TPVSetup: Record "TPV Setup";
        GeneralLedgerSetup: Record "General Ledger Setup";
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        CurrencyExchangeFactor, RemainingAmountLCY : Decimal;
        IsHandled: Boolean;
    begin
        OnBeforeCalculateRemainingLCYAmount(IsHandled);
        if IsHandled then
            exit;

        GeneralLedgerSetup.Get();
        if Rec."Currency Code" = GeneralLedgerSetup.GetCurrencyCode('') then begin
            Rec."Remaining Amount (LCY)" := Rec."Remaining Amount";
            exit;
        end;

        TPVSetup.Get();
        if not TPVSetup."Exchange rates for FCY" then
            exit;

        CurrencyExchangeFactor := CurrencyExchangeRate.GetCurrentCurrencyFactor(Rec."Currency Code");
        RemainingAmountLCY := CurrencyExchangeRate.ExchangeAmtFCYToLCY(Rec."Posting Date", Rec."Currency Code", Rec."Remaining Amount", CurrencyExchangeFactor);

        Rec.Validate("Remaining Amount (LCY)", RemainingAmountLCY);

        OnAfterCalculateRemainingLCYAmount();
    end;

    procedure CheckActiveLines(CashRegisterNo: Code[20]) HasActiveLines: Boolean
    var
        TPVTenderLine: Record "TPV Tender Line";
        IsHandled: Boolean;
    begin
        OnBeforeCheckActiveLines(IsHandled, CashRegisterNo, HasActiveLines);
        if IsHandled then
            exit;

        TPVTenderLine.SetRange("Cash Register No.", CashRegisterNo);
        if not TPVTenderLine.IsEmpty() then
            HasActiveLines := true;

        OnAfterCheckActiveLines(CashRegisterNo, HasActiveLines);
    end;

    procedure CreateUpdateInfoMessage(TPVPostedCashRegister: Record "TPV Posted Cash Register") UpdateMessage: Text
    var
        TPVTenderLine: Record "TPV Tender Line";
        TPVPostedTenderLine: Record "TPV Posted Tender Line";
        DictionaryOfActiveTender, DictionaryOfPostedTender : Dictionary of [Text, Decimal];
        ListOfCurrencyTenderKeys: List of [Text];
        UpdateMessageBuilder: TextBuilder;
        CurrencyTenderInfo: Text;
        ActiveAmount, PostedAmount : Decimal;
        UpdateMessageBuilder_Tok: Label '%1   %2 -> %3';
        IsHandled: Boolean;
    begin
        OnBeforeCreateUpdateInfoMessage(TPVPostedCashRegister, UpdateMessage, IsHandled);
        if IsHandled then
            exit;

        // Get a dictionary for the active lines
        TPVTenderLine.SetRange("Cash Register No.", TPVPostedCashRegister."No.");
        if TPVTenderLine.FindSet() then
            repeat
                DictionaryOfActiveTender.Add(TPVTenderLine.GetLineCurrencyTenderInfo(), TPVTenderLine.Quantity)
            until TPVTenderLine.Next() = 0;

        // Get a dictionary for the posted lines
        TPVPostedTenderLine.SetRange("Cash Register No.", TPVPostedCashRegister."No.");
        TPVPostedTenderLine.SetRange("Posting Date", TPVPostedCashRegister."Posting Date");
        TPVPostedTenderLine.SetRange("From Time", TPVPostedCashRegister."From Time");
        TPVPostedTenderLine.SetRange("To Time", TPVPostedCashRegister."To Time");
        if TPVPostedTenderLine.FindSet() then
            repeat
                DictionaryOfActiveTender.Add(TPVPostedTenderLine.GetLineCurrencyTenderInfo(), TPVPostedTenderLine.Quantity)
            until TPVPostedTenderLine.Next() = 0;

        // Get a list of all the tender in either posted or active lines
        foreach CurrencyTenderInfo in DictionaryOfActiveTender.Keys do begin
            ListOfCurrencyTenderKeys.Add(CurrencyTenderInfo);
        end;
        foreach CurrencyTenderInfo in DictionaryOfPostedTender.Keys do begin
            if not ListOfCurrencyTenderKeys.Contains(CurrencyTenderInfo) then
                ListOfCurrencyTenderKeys.Add(CurrencyTenderInfo);
        end;

        // Use the list to iterate the dictionaries to build the update message
        foreach CurrencyTenderInfo in ListOfCurrencyTenderKeys do begin
            if not DictionaryOfActiveTender.Get(CurrencyTenderInfo, ActiveAmount) then
                ActiveAmount := 0;
            if not DictionaryOfPostedTender.Get(CurrencyTenderInfo, PostedAmount) then
                PostedAmount := 0;
            UpdateMessageBuilder.AppendLine(StrSubstNo(UpdateMessageBuilder_Tok, CurrencyTenderInfo, ActiveAmount, PostedAmount));
        end;
        UpdateMessage := UpdateMessageBuilder.ToText();

        OnAfterCreateUpdateInfoMessage(TPVPostedCashRegister, UpdateMessage);
    end;

    procedure Serialize(var TenderLineJsonObject: JsonObject)
    var
        TPVDataManagement: Codeunit "TPV Data Management";
        RecRef: RecordRef;
    begin
        RecRef.Get(Rec.RecordId);
        TPVDataManagement.Serialize(RecRef, TenderLineJsonObject);
    end;

    #region Integration Events

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateLineAmount(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalculateLineAmount()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateLineRemainingAmount(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalculateLineRemainingAmount()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateLCYAmount(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalculateLCYAmount()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateRemainingLCYAmount(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalculateRemainingLCYAmount()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckActiveLines(var IsHandled: Boolean; CashRegisterNo: Code[20]; var HasActiveLines: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckActiveLines(CashRegisterNo: Code[20]; var HasActiveLines: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateUpdateInfoMessage(TPVPostedCashRegister: Record "TPV Posted Cash Register"; var UpdateMessage: Text; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateUpdateInfoMessage(TPVPostedCashRegister: Record "TPV Posted Cash Register"; var UpdateMessage: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeClearLines(No: Code[20]; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterClearLines(No: Code[20])
    begin
    end;

    #endregion Integration Events
}