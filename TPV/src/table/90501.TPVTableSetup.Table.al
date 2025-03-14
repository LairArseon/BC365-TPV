table 90501 "TPV Table Setup"
{
    Caption = 'TPV Record Setup', Comment = 'ESP="Configuración Registros TPV"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Table No."; Integer)
        {
            Caption = 'Table No.', Comment = 'ESP="Nº Tabla"';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = filter(Table));
        }
        field(2; "Table Name"; Text[30])
        {
            Caption = 'Table Name', Comment = 'ESP="Nombre Tabla"';
            FieldClass = FlowField;
            CalcFormula = lookup(AllObjWithCaption."Object Name" where("Object Type" = filter(Table), "Object ID" = field("Table No.")));
            Editable = false;
        }
        field(3; "Table Caption"; Text[249])
        {
            Caption = 'Table Caption', Comment = 'ESP="Caption Tabla"';
            FieldClass = FlowField;
            CalcFormula = lookup(AllObjWithCaption."Object Caption" where("Object Type" = filter(Table), "Object ID" = field("Table No.")));
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Table No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }
}