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
                field("Sales Point Code"; Rec."Sales Point Code")
                {
                    ToolTip = 'Specifies the value of the Sales point code field.', Comment = '%ESP="Código punto venta"';
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ToolTip = 'Specifies the value of the Payment method code field.', Comment = '%ESP="Código método pago"';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = '%ESP="Descripción"';
                }
                field("Bal. Account Type"; Rec."Bal. Account Type")
                {
                    ToolTip = 'Specifies the value of the Bal. Account Type field.', Comment = '%ESP="Tipo Cuenta"';
                }
                field("Bal. Account No."; Rec."Bal. Account No.")
                {
                    ToolTip = 'Specifies the value of the Bal. Account No. field.', Comment = '%ESP="Número de cuenta"';
                }
                field("Direct Debit"; Rec."Direct Debit")
                {
                    ToolTip = 'Specifies the value of the Direct Debit field.', Comment = '%ESP="Débito directo"';
                }
                field("Direct Debit Pmt. Terms Code"; Rec."Direct Debit Pmt. Terms Code")
                {
                    ToolTip = 'Specifies the value of the Direct Debit Pmt. Terms Code field.', Comment = '%ESP="Términos pago débito directo"';
                }
            }
        }
    }
}