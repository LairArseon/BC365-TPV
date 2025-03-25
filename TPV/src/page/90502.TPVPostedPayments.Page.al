page 90502 "TPV Posted Payments"
{
    Caption = 'Posted TPV Payments', Comment = 'ESP="Pagos TPV registrados"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = History;
    SourceTable = "TPV Posted Payment Line";
    // Editable = false; // TODO

    layout
    {
        area(Content)
        {
            repeater(PostedPaymentLines)
            {
                field("Source Document"; Format(Rec."Source Document")) { StyleExpr = LineStyle; }
                field("Posting Date"; Rec."Posting Date") { StyleExpr = LineStyle; }
                field("Posting Time"; Rec."Posting Time") { StyleExpr = LineStyle; }
                field("Sales Point"; Rec."Sales Point") { StyleExpr = LineStyle; }
                field("Account No."; Rec."Account No.") { StyleExpr = LineStyle; }
                field(Description; Rec.Description) { StyleExpr = LineStyle; }
                field("Amount Total (Inc. VAT)"; Rec."Amount Total (Inc. VAT)") { StyleExpr = LineStyle; }
                field(Amount; Rec.Amount) { StyleExpr = LineStyle; }
                field(Refund; Rec.Refund) { StyleExpr = LineStyle; }
                field("Payment Method"; Rec."Payment Method") { StyleExpr = LineStyle; }
                field("Payment Reference"; Rec."Payment Reference") { StyleExpr = LineStyle; }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetLineStyle();
    end;

    protected var
        LineStyle: Text;

    procedure SetLineStyle()
    begin
        if Rec.Refund then
            LineStyle := 'Ambiguous'
        else
            LineStyle := 'StandardAccent';

        OnAfterSetLineStyle(Rec, LineStyle);
    end;

    #region Event Subscriptions

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetLineStyle(Rec: Record "TPV Posted Payment Line"; var LineStyle: Text)
    begin
    end;

    #endregion Event Subscription
}