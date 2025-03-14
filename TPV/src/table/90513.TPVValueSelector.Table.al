table 90513 "TPV Value Selector"
{
    Caption = 'Available Values', Comment = 'ESP="Valores Disponibles"';
    DataClassification = ToBeClassified;
    TableType = Temporary;

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.', Comment = 'ESP="Nº"';
        }
        field(2; "Source Record"; RecordId)
        {
            Caption = 'EnglishText', Comment = 'ESP="TranslatedText"';
        }
        field(3; "Formatted Value"; Text[2048])
        {
            Caption = 'Calue', Comment = 'ESP="Valor"';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    procedure AddValue(RecordID: RecordId; FormattedValue: Text)
    begin
        if Rec.FindLast() then begin
            Rec."No." += 1;
            Rec."Source Record" := RecordID;
            Rec."Formatted Value" := FormattedValue;
            Rec.Insert();
        end;
    end;
}