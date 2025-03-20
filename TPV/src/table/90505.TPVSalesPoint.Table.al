table 90505 "TPV Sales Point"
{
    Caption = 'TPV Sales point', Comment = 'ESP="Punto venta TPV"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Sales Point Code"; Code[20])
        {
            Caption = 'Sales Point Code', Comment = 'ESP="Cód. Punto venta"';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(3; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center', Comment = 'ESP="Centro de Responsabilidad"';
            TableRelation = "Responsibility Center";
        }

        field(4; "Journal Template Name"; Code[10])
        {
            Caption = 'TPV Payment Template', Comment = 'ESP="Libro registro pagos TPV"';
            FieldClass = FlowField;
            CalcFormula = lookup("TPV Setup"."Journal Template Name");
        }
        field(5; "Journal Batch Name"; Code[10])
        {
            Caption = 'General TPV Payment Batch', Comment = 'ESP="Sección general registro pagos TPV"';
            TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));
        }
        field(6; "Auto Post Payments"; Boolean)
        {
            Caption = 'Auto-Post Payments', Comment = 'ESP="Auto-Registro Pagos"';
        }
    }

    keys
    {
        key(Key1; "Sales Point Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    procedure SelectSalesPoint(UserID: Text; var SelectedSalesPoint: Code[20]): Boolean
    var
        UserSetup: Record "User Setup";
        TPVSalesPointList: Page "TPV Sales Point List";
    begin
        UserSetup.Get(UserID);
        Rec.SetFilter("Responsibility Center", '%1', UserSetup."TPV Resp. Center Filter");

        if Rec.IsEmpty() then
            exit(false);

        if Rec.Count() = 1 then begin
            Rec.FindFirst();
            SelectedSalesPoint := Rec."Sales Point Code";
            exit(true);
        end;

        TPVSalesPointList.SetTableView(Rec);
        TPVSalesPointList.LookupMode(true);
        if not (TPVSalesPointList.RunModal() = Action::LookupOK) then
            exit(false);

        TPVSalesPointList.GetRecord(Rec);
        SelectedSalesPoint := Rec."Sales Point Code";
        exit(true);
    end;

}