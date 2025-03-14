codeunit 90502 "TPV Data Management"
{

    procedure Serialize(RecRef: RecordRef; var LineAsJsonObject: JsonObject)
    var
        Field: Record Field;
        FieldRef: FieldRef;
        FieldInfo: JsonObject;
    begin
        LineAsJsonObject.Add('SourceRecord', Format(RecRef.RecordId));
        Field.SetRange(TableNo, RecRef.RecordId.TableNo);
        if Field.FindSet() then
            repeat
                FieldRef := RecRef.Field(Field."No.");
                Clear(FieldInfo);
                FieldInfo.Add('FieldNo', Field."No.");
                FieldInfo.Add('FieldName', Field.FieldName);
                FieldInfo.Add('FieldCaption', Field."Field Caption");
                FieldInfo.Add('FieldType', Field.Type);
                FieldInfo.Add('FieldOptions', Field.OptionString);

                if Field.Class = Field.Class::FlowField then
                    FieldRef.CalcField();
                FieldInfo.Add('FieldValue', Format(FieldRef.Value()));

                LineAsJsonObject.Add(Field.FieldName, FieldInfo);
            until Field.Next() = 0;
    end;

    procedure AddLines(var ParentObject: JsonObject; var LinesToAdd: JsonArray)
    begin
        ParentObject.Add('lines', LinesToAdd)
    end;
}