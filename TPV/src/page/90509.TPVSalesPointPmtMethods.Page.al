page 90509 "TPV Sales Point Pmt. Methods"
{
    Caption = 'Sales point payment method', Comment = 'ESP="Métodos pago punto venta"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "TPV Sales Point Payment Method";

    layout
    {
        area(Content)
        {
            repeater(PaymentMethodList)
            {
                field("Sales Point Code"; Rec."Sales Point Code") { }
                field("Payment Method Code"; Rec."Payment Method Code") { }
                field(Description; Rec.Description) { }
                field("Applies Cash Payment Limit"; Rec."Applies Cash Payment Limit") { }
                field("Bal. Account Type"; Rec."Bal. Account Type") { }
                field("Bal. Account No."; Rec."Bal. Account No.") { }
                field("Direct Debit"; Rec."Direct Debit") { }
                field("Direct Debit Pmt. Terms Code"; Rec."Direct Debit Pmt. Terms Code") { }
            }
        }
    }
}