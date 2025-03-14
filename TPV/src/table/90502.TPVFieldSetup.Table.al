table 90502 "TPV Field Setup"
{
    Caption = 'TPV Field Setup', Comment = 'ESP="Configuración Campos TPV"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Table No."; Integer)
        {
            Caption = 'Table No.', Comment = 'ESP="Nº Tabla"';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = filter(Table));
        }
        field(2; "Field No."; Integer)
        {
            Caption = 'Field No.', Comment = 'ESP="Nº Campo"';
            TableRelation = Field."No." where(TableNo = field("Table No."), ObsoleteState = filter(<> Removed));
        }
        field(3; "Field Position"; Integer)
        {
            Caption = 'Field Position', Comment = 'ESP="Posición Campo"';
        }
        field(10; "Table Name"; Text[30])
        {
            Caption = 'Table Name', Comment = 'ESP="Nombre Tabla"';
            FieldClass = FlowField;
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object Type" = filter(Table), "Object ID" = field("Table No.")));
            Editable = false;
        }
        field(11; "Table Caption"; Text[249])
        {
            Caption = 'Table Caption', Comment = 'ESP="Caption Tabla"';
            FieldClass = FlowField;
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = filter(Table), "Object ID" = field("Table No.")));
            Editable = false;
        }
        field(20; "Field Name"; Text[30])
        {
            Caption = 'Field Name', Comment = 'ESP="Nombre Campo"';
            FieldClass = FlowField;
            CalcFormula = lookup(Field.FieldName where(TableNo = field("Table No."), "No." = field("Field No.")));
            Editable = false;
        }
        field(21; "Field Caption"; Text[80])
        {
            Caption = 'Field Caption', Comment = 'ESP="Caption Campo"';
            FieldClass = FlowField;
            CalcFormula = lookup(Field."Field Caption" where(TableNo = field("Table No."), "No." = field("Field No.")));
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Table No.", "Field No.")
        {
            Clustered = true;
        }
        key(Key2; "Field Position") { }
    }
}