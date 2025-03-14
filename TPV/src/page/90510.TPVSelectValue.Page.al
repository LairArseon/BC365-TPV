page 90510 "TPV Select Value"
{
    Caption = 'Select Value', Comment = 'ESP="Selector Valor"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "TPV Value Selector";

    layout
    {
        area(Content)
        {
            repeater(ValueRepeater)
            {
                field("Source Record"; Rec."Source Record")
                {
                    ToolTip = 'Specifies the value of the EnglishText field.', Comment = '%ESP="TranslatedText"';
                }
                field("Formatted Value"; Rec."Formatted Value")
                {
                    ToolTip = 'Specifies the value of the Calue field.', Comment = '%ESP="Valor"';
                }
            }
        }
    }
}