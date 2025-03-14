table 90510 "TPV Line Buffer"
{
    Caption = 'TPV Viewer Buffer', Comment = 'ESP="Buffer Previsualización TPV"';
    TableType = Temporary;
    DataClassification = CustomerContent;
    Extensible = true;

    fields
    {
        field(1; "Source Record"; RecordId)
        {
            Caption = 'Source Line', Comment = 'ESP="Linea Origen"';
            AllowInCustomizations = Always;
        }
        field(2; "Field No."; Integer)
        {
            Caption = 'No.', Comment = 'ESP="Nº"';
            AllowInCustomizations = Never;
        }
        field(3; "Field Type"; Option)
        {
            Caption = 'Type', Comment = 'ESP="Tipo"';
            AllowInCustomizations = Always;
            OptionMembers = RecordID,Date,Time,DateFormula,Decimal,Media,MediaSet,Text,Code,BLOB,Boolean,Integer,Option,BigInteger,Duration,GUID,DateTime;
        }
        field(4; "Field Class"; Option)
        {
            Caption = 'Class', Comment = 'ESP="Clase"';
            OptionMembers = Normal,FlowField,FlowFilter;
        }
        field(5; "Field Name"; Text[30])
        {
            Caption = 'Quantity', Comment = 'ESP="Cantidad"';
            AllowInCustomizations = Always;
        }
        field(6; "Field Caption"; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
            AllowInCustomizations = Always;
        }
        field(7; OptionString; Text[2047])
        {
            Caption = 'Options', Comment = 'ESP="Opciones"';
        }
        field(8; Enabled; Boolean)
        {
            Caption = 'Enabled', Comment = 'ESP="Activado"';
        }
        field(9; "Formatted Value"; Text[2048])
        {
            Caption = 'Formatted Value', Comment = 'ESP="Valor Formateado"';
        }
        field(10; "New Formatted Value"; Text[2048])
        {
            Caption = 'Formatted Value', Comment = 'ESP="Valor Formateado"';
        }
        field(11; "Field Position"; Integer)
        {
            Caption = 'Field Order', Comment = 'ESP="Orden Campo"';
        }
        field(12; "Relation Table No."; Integer)
        {
            Caption = 'Related table', Comment = 'ESP="Tabla relacionada"';
        }
        field(13; "Relation Field No."; Integer)
        {
            Caption = 'Related Field', Comment = 'ESP="Campo relacionado"';
        }
        field(100; RecordIDValue; RecordID) { }
        field(101; DateValue; Date) { }
        field(102; TimeValue; Time) { }
        field(103; DateFormulaValue; DateFormula) { }
        field(104; DecimalValue; Decimal) { }
        field(105; MediaValue; Media) { }
        field(106; MediaSetValue; MediaSet) { }
        field(107; TextValue; Text[2048]) { }
        field(108; CodeValue; Code[2048]) { }
        field(109; BLOBValue; BLOB) { }
        field(110; BooleanValue; Boolean) { }
        field(111; IntegerValue; Integer) { }
        field(112; OptionValue; Integer) { }
        field(113; BigIntegerValue; BigInteger) { }
        field(114; DurationValue; Duration) { }
        field(115; GUIDValue; GUID) { }
        field(116; DateTimeValue; DateTime) { }

        field(200; NewRecordIDValue; RecordID) { }
        field(201; NewDateValue; Date) { }
        field(202; NewTimeValue; Time) { }
        field(203; NewDateFormulaValue; DateFormula) { }
        field(204; NewDecimalValue; Decimal) { }
        field(205; NewMediaValue; Media) { }
        field(206; NewMediaSetValue; MediaSet) { }
        field(207; NewTextValue; Text[2048]) { }
        field(208; NewCodeValue; Code[2048]) { }
        field(209; NewBLOBValue; BLOB) { }
        field(210; NewBooleanValue; Boolean) { }
        field(211; NewIntegerValue; Integer) { }
        field(212; NewOptionValue; Integer) { }
        field(213; NewBigIntegerValue; BigInteger) { }
        field(214; NewDurationValue; Duration) { }
        field(215; NewGUIDValue; GUID) { }
        field(216; NewDateTimeValue; DateTime) { }
    }

    keys
    {
        key(Key1; "Source Record", "Field No.")
        {
            Clustered = true;
        }
        key(Key2; "Field Position") { }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Field No.", "Field Caption")
        {

        }
        fieldgroup(Brick; "Field No.", "Field Caption")
        {

        }
    }

    procedure SerializeLine(RecID: RecordId) SerializedLine: JsonArray
    var
        FieldObject: JsonObject;
    begin
        Rec.SetCurrentKey("Field Position");
        Rec.SetRange("Source Record", RecID);
        Rec.SetFilter("Field Type", '<>%1&<>%2', Rec."Field Type"::BLOB, Rec."Field Type"::Media);
        if Rec.FindSet() then
            repeat
                Clear(FieldObject);
                FieldObject.Add('SourceRecord', Format(Rec."Source Record"));
                FieldObject.Add('FieldNo', Rec."Field No.");
                FieldObject.Add('FieldName', Rec."Field Name");
                FieldObject.Add('FieldCaption', Rec."Field Caption");
                FieldObject.Add('FieldType', Rec."Field Type");
                FieldObject.Add('FieldOptions', Rec.OptionString);
                FieldObject.Add('FieldValue', Rec."Formatted Value");
                SerializedLine.Add(FieldObject)
            until Rec.Next() = 0;
    end;

    procedure InsertLine(RecordRef: RecordRef)
    var
        TPVFieldSetup: Record "TPV Field Setup";
        Field: Record Field;
        FieldRef: FieldRef;
    begin
        TPVFieldSetup.SetCurrentKey("Field Position");
        TPVFieldSetup.SetRange("Table No.", RecordRef.RecordId.TableNo);
        if TPVFieldSetup.FindSet() then
            repeat
                if Field.Get(TPVFieldSetup."Table No.", TPVFieldSetup."Field No.") then begin
                    Rec.Init();
                    Rec."Source Record" := RecordRef.RecordId;
                    Rec."Field No." := Field."No.";
                    Rec."Field Name" := Field.FieldName;
                    Rec."Field Caption" := Field."Field Caption";
                    Rec.OptionString := Field.OptionString;
                    Rec."Relation Table No." := Field.RelationTableNo;
                    Rec."Relation Field No." := Field.RelationFieldNo;
                    Rec."Field Position" := TPVFieldSetup."Field Position";
                    FieldRef := RecordRef.Field(Field."No.");
                    if FieldRef.Type = FieldType::Blob then
                        FieldRef.CalcField();

                    Rec.ValidateIntoType(FieldRef);
                    Rec.Insert(true);
                end;

            until TPVFieldSetup.Next() = 0;

    end;

    procedure ValidateIntoType(FieldRef: FieldRef)
    begin
        case FieldRef.Type of
            FieldType::RecordId:
                begin
                    Rec."Field Type" := Rec."Field Type"::RecordID;
                    Rec.RecordIDValue := FieldRef.Value;
                end;
            FieldType::Date:
                begin
                    Rec."Field Type" := Rec."Field Type"::Date;
                    Rec.DateValue := FieldRef.Value;
                end;
            FieldType::Time:
                begin
                    Rec."Field Type" := Rec."Field Type"::Time;
                    Rec.TimeValue := FieldRef.Value;
                end;
            FieldType::DateFormula:
                begin
                    Rec."Field Type" := Rec."Field Type"::DateFormula;
                    Rec.DateFormulaValue := FieldRef.Value;
                end;
            FieldType::Decimal:
                begin
                    Rec."Field Type" := Rec."Field Type"::Decimal;
                    Rec.DecimalValue := FieldRef.Value;
                end;
            FieldType::Media:
                begin
                    Rec."Field Type" := Rec."Field Type"::Media;
                    Rec.MediaValue := FieldRef.Value;
                end;
            FieldType::MediaSet:
                begin
                    Rec."Field Type" := Rec."Field Type"::MediaSet;
                    Rec.MediaSetValue := FieldRef.Value;
                end;
            FieldType::Text:
                begin
                    Rec."Field Type" := Rec."Field Type"::Text;
                    Rec.TextValue := FieldRef.Value;
                end;
            FieldType::Code:
                begin
                    Rec."Field Type" := Rec."Field Type"::Code;
                    Rec.CodeValue := FieldRef.Value;
                end;
            FieldType::Blob:
                begin
                    Rec."Field Type" := Rec."Field Type"::BLOB;
                    Rec.BLOBValue := FieldRef.Value;
                end;
            FieldType::Boolean:
                begin
                    Rec."Field Type" := Rec."Field Type"::Boolean;
                    Rec.BooleanValue := FieldRef.Value;
                end;
            FieldType::Integer:
                begin
                    Rec."Field Type" := Rec."Field Type"::Integer;
                    Rec.IntegerValue := FieldRef.Value;
                end;
            FieldType::Option:
                begin
                    Rec."Field Type" := Rec."Field Type"::Option;
                    Rec.OptionValue := FieldRef.Value;
                end;
            FieldType::BigInteger:
                begin
                    Rec."Field Type" := Rec."Field Type"::BigInteger;
                    Rec.BigIntegerValue := FieldRef.Value;
                end;
            FieldType::Duration:
                begin
                    Rec."Field Type" := Rec."Field Type"::Duration;
                    Rec.DurationValue := FieldRef.Value;
                end;
            FieldType::Guid:
                begin
                    Rec."Field Type" := Rec."Field Type"::GUID;
                    Rec.GUIDValue := FieldRef.Value;
                end;
            FieldType::DateTime:
                begin
                    Rec."Field Type" := Rec."Field Type"::DateTime;
                    Rec.DateTimeValue := FieldRef.Value;
                end;
        end;

        if not (FieldRef.Type in [FieldRef.Type::Blob, FieldRef.Type::Media, FieldRef.Type::MediaSet]) then
            Rec."Formatted Value" := Format(FieldRef.Value);
    end;
}