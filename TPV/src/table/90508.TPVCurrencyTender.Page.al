page 90508 "TPV Currency - Tender"
{
    Caption = 'Tender types', Comment = 'ESP="Tipos efectivo"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "TPV Currency-Tender";

    layout
    {
        area(Content)
        {
            repeater(CurrencyTender)
            {
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field.', Comment = '%';
                    Visible = false;
                }
                field("Tender Type"; Rec."Tender Type")
                {
                    ToolTip = 'Specifies the value of the Tender Type field.', Comment = '%ESP="Tipo Moneda"';
                }
                field("Tender Code"; Rec."Tender Code")
                {
                    ToolTip = 'Specifies the value of the Tender Code field.', Comment = '%ESP="Código Moneda"';
                }
                field("Tender Name"; Rec."Tender Name")
                {
                    ToolTip = 'Specifies the value of the Tender Name field.', Comment = '%ESP="Nombre Moneda"';
                }
                field("Tender Value"; Rec."Tender Value")
                {
                    ToolTip = 'Specifies the value of the Tender Value field.', Comment = '%ESP="Valor Moneda"';
                }
            }
        }
    }
}