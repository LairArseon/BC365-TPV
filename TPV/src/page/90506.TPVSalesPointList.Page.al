page 90506 "TPV Sales Point List"
{
    Caption = 'Sales point list', Comment = 'ESP="Lista puntos venta"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "TPV Sales Point";

    layout
    {
        area(Content)
        {
            repeater(RegisterList)
            {
                field("Sales Point Code"; Rec."Sales Point Code") { }

                field(Description; Rec.Description) { }

                field("Responsibility Center"; Rec."Responsibility Center") { }

                field("Journal Batch Name"; Rec."Journal Batch Name") { }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(TenderTypes)
            {
                Caption = 'Tender Types', Comment = 'ESP="Tipos Moneda"';
                ApplicationArea = All;
                Image = Currencies;

                RunObject = page "TPV Sales Point - Tender";
                RunPageLink = "Sales Point Code" = field("Sales Point Code");
            }
            action(PaymentMethods)
            {
                Caption = 'Payment Methods', Comment = 'ESP="Métodos Pago"';
                ApplicationArea = All;
                Image = Payment;

                RunObject = page "TPV Sales Point Pmt. Methods";
                RunPageLink = "Sales Point Code" = field("Sales Point Code");
            }
        }

    }
}