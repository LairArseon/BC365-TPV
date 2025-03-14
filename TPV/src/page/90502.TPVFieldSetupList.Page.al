page 90502 "TPV Field Setup List"
{
    Caption = 'TPV Field Setup', Comment = 'ESP="Configuración Campos TPV"';
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "TPV Field Setup";
    PopulateAllFields = true;

    layout
    {
        area(Content)
        {
            repeater(FieldsRepeater)
            {
                field("Table No."; Rec."Table No.")
                {
                    Visible = false;
                }
                field("Table Name"; Rec."Table Name")
                {
                    Visible = false;
                }
                field("Table Caption"; Rec."Table Caption")
                {
                    Visible = false;
                }
                field("Field Name"; Rec."Field Name")
                {
                    Visible = false;
                }
                field("Field Caption"; Rec."Field Caption")
                {
                    trigger OnAssistEdit()
                    var
                        Field: Record Field;
                        TPVFieldSelection: Page "TPV Field Selection";
                    begin
                        Field.SetRange(TableNo, Rec."Table No.");
                        TPVFieldSelection.SetTableView(Field);
                        TPVFieldSelection.LookupMode(true);
                        if TPVFieldSelection.RunModal() = Action::LookupOK then begin
                            TPVFieldSelection.GetRecord(Field);
                            Rec.Validate("Field No.", Field."No.");
                            Rec.CalcFields("Field Caption", "Field Name");
                        end;
                    end;
                }
                field("Field No."; Rec."Field No.")
                {
                    Editable = false;

                    trigger OnAssistEdit()
                    var
                        Field: Record Field;
                        TPVFieldSelection: Page "TPV Field Selection";
                    begin
                        Field.SetRange(TableNo, Rec."Table No.");
                        TPVFieldSelection.SetTableView(Field);
                        TPVFieldSelection.LookupMode(true);
                        if TPVFieldSelection.RunModal() = Action::LookupOK then begin
                            TPVFieldSelection.GetRecord(Field);
                            Rec.Validate("Field No.", Field."No.");
                            Rec.CalcFields("Field Caption", "Field Name");
                        end;
                    end;
                }
                field("Field Position"; Rec."Field Position")
                {

                }
            }
        }
    }
}