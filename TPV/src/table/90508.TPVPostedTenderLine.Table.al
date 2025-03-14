table 90508 "TPV Posted Tender Line"
{
    Caption = 'TPV Posted Tender Line', Comment = 'ESP="Línea Moneda registrada TPV"';
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
        }
        field(10; Amount; Decimal)
        {
            Caption = 'Total monetary value', Comment = 'ESP="Valor monetario total"';
        }
        field(11; "Amount (LCY)"; Decimal)
        {
            Caption = 'Total monetary value (LCY)', Comment = 'ESP="Valor monetario total (DL)"';
        }
        field(12; "Remaining Quantity"; Decimal)
        {
            Caption = 'Remaining amount', Comment = 'ESP="Cantidad Restante"';
        }
    }

    keys
    {
        key(Key1; "Cash Register No.", "Currency Code", "Tender Type", "Tender Code", "Posting Date", "From Time", "To Time")
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

}