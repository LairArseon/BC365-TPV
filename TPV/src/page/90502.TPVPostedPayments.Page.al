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
                field("Source Document"; Format(Rec."Source Document")) { }
                field("Posting Date"; Rec."Posting Date") { }
                field("Posting Time"; Rec."Posting Time") { }
                field("Sales Point"; Rec."Sales Point") { }
                field("Account No."; Rec."Account No.") { }
                field(Description; Rec.Description) { }
                field("Amount Total (Inc. VAT)"; Rec."Amount Total (Inc. VAT)") { }
                field(Amount; Rec.Amount) { }
                field("Payment Method"; Rec."Payment Method") { }
                field("Payment Reference"; Rec."Payment Reference") { }
            }
        }
    }
}