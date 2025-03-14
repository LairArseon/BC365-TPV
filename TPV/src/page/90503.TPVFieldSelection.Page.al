page 90503 "TPV Field Selection"
{
    Caption = 'TPV Field Selection', Comment = 'ESP="Selección Campos TPV"';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = Field;

    layout
    {
        area(Content)
        {
            repeater(FieldRepeater)
            {
                field("No."; Rec."No.")
                {

                }
                field("Field Caption"; Rec."Field Caption")
                {

                }
            }
        }
    }
}