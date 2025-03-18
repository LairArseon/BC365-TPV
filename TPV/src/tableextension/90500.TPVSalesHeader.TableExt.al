tableextension 90500 "TPV Sales Header" extends "Sales Header"
{

    procedure Serialize(var SalesHeaderJson: JsonObject)
    var
        TPVDataManagement: Codeunit "TPV Data Management";
        RecRef: RecordRef;
    begin
        RecRef.Get(Rec.RecordId);
        TPVDataManagement.Serialize(RecRef, SalesHeaderJson);
    end;

    procedure CalculatePaidAmount() PaidAmount: Decimal
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        IsHandled: Boolean;
    begin
        OnBeforeCalculatePaidAmount(PaidAmount, IsHandled);
        if IsHandled then
            exit;

        CustLedgerEntry.SetRange("Customer No.", Rec."Bill-to Customer No.");
        CustLedgerEntry.SetRange("Payment Reference", Rec."No.");
        if CustLedgerEntry.FindSet() then
            repeat
                CustLedgerEntry.CalcFields("Credit Amount (LCY)");
                PaidAmount += CustLedgerEntry."Credit Amount (LCY)";
            until CustLedgerEntry.Next() = 0;

        OnAfterCalculatePaidAmount(PaidAmount);
    end;

    #region Integration Events

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculatePaidAmount(var PaidAmount: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalculatePaidAmount(var PaidAmount: Decimal)
    begin
    end;

    #endregion
}