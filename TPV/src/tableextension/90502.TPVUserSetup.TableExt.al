tableextension 90502 "TPV User Setup" extends "User Setup"
{
    fields
    {
        field(90500; "TPV Resp. Center Filter"; Code[10])
        {
            Caption = 'TPV Reps. Center Filter', Comment = 'ESP="Filtro Centros Resp. TPV"';
            DataClassification = CustomerContent;
            TableRelation = "Responsibility Center".Code;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }
}