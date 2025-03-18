tableextension 90501 "TPV Sales Line" extends "Sales Line"
{
    procedure Serialize(var SalesLineJson: JsonObject)
    var
        TPVDataManagement: Codeunit "TPV Data Management";
        RecRef: RecordRef;
    begin
        RecRef.Get(Rec.RecordId);
        TPVDataManagement.Serialize(RecRef, SalesLineJson);
    end;
}