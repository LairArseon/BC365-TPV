codeunit 90502 "TPV Data Management"
{

    /// <summary>
    /// Serialize any line given a RecordRef
    /// </summary>
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
                if Field.ObsoleteState <> Field.ObsoleteState::Removed then begin
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
                end;
            until Field.Next() = 0;
    end;

    /// <summary>
    /// Add an array of lines to a existing json object under the key selected key
    /// </summary>
    procedure AddLines(var ParentObject: JsonObject; var LinesToAdd: JsonArray)
    begin
        ParentObject.Add('lines', LinesToAdd)
    end;
}