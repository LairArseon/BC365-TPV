page 90504 "TPV Table Setup"
{
    Caption = 'TPV Table Setup', Comment = 'ESP="Configuración Tablas TPV"';
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "TPV Table Setup";

    layout
    {
        area(Content)
        {
            repeater(RecordRepeater)
            {
                field("Table No."; Rec."Table No.")
                {

                }
                field("Table Name"; Rec."Table Name")
                {
                    Visible = false;
                }
                field("Table Caption"; Rec."Table Caption")
                {

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(SetupFieldsForRecord)
            {
                ApplicationArea = All;
                Caption = 'Setup Fields', Comment = 'ESP="Establecer Campos"';
                Image = GetLines;
                RunObject = Page "TPV Field Setup List";
                RunPageLink = "Table No." = field("Table No.");
            }
        }
    }
}