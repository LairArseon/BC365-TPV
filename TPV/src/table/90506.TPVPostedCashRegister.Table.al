table 90506 "TPV Posted Cash Register"
{
    Caption = 'TPV Posted Cash Register', Comment = 'ESP="Histórico cierre Caja TPV"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'Cash Reg. No.', Comment = 'ESP="Nº Caja"';
        }
        field(2; "Posting Date"; Date)
        {
            Caption = 'Posting Date', Comment = 'ESP="Fecha Registro"';
        }
        field(3; "From Time"; Time)
        {
            Caption = 'From Time', Comment = 'ESP="Desde Hora"';
        }
        field(4; "To Time"; Time)
        {
            Caption = 'To Time', Comment = 'ESP="Hasta Hora"';
        }
        field(5; "Emptied on Post"; Boolean)
        {
            Caption = 'Emptied when posting', Comment = 'ESP="Vaciada al registrar"';
        }
        field(6; Description; Text[100])
        {
            Caption = 'Description', Comment = 'ESP="Descripción"';
        }
        field(7; "Partially Emptied on Post"; Boolean)
        {
            Caption = 'Partially emptied on post', Comment = 'ESP="Parcialmente vaciada al registrar"';
        }
        field(10; "Total Tender Amount"; Decimal)
        {
            Caption = 'Tender Amount Total', Comment = 'ESP="Cantidad total efectivo"';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("TPV Posted Tender Line".Amount where(
                "Cash Register No." = field("No."),
                "Posting Date" = field("Posting Date"),
                "From Time" = field("From Time"),
                "To Time" = field("To Time")));
        }
        field(11; "Total Tender Amount (LCY)"; Decimal)
        {
            Caption = 'Tender Amount Total (LCY)', Comment = 'ESP="Cantidad total efectivo (DL)"';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("TPV Posted Tender Line"."Amount (LCY)" where(
                "Cash Register No." = field("No."),
                "Posting Date" = field("Posting Date"),
                "From Time" = field("From Time"),
                "To Time" = field("To Time")));
        }
        field(12; "Payment Terminal Amount"; Decimal)
        {
            Caption = 'Payment Terminal Total', Comment = 'ESP="Total Datáfono"';
        }
        field(13; "Remaining Tender Amount"; Decimal)
        {
            Caption = 'Remaining Amount', Comment = 'ESP="Cantidad restante"';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("TPV Posted Tender Line"."Remaining Amount" where("Cash Register No." = field("No.")));
        }
        field(14; "Remaining Tender Amount (LCY)"; Decimal)
        {
            Caption = 'Remaining Amount (LCY)', Comment = 'ESP="Cantidad restante (DL)"';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = sum("TPV Posted Tender Line"."Remaining Amount (LCY)" where("Cash Register No." = field("No.")));
        }
    }

    keys
    {
        key(Key1; "No.", "Posting Date", "From Time", "To Time")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        // Add changes to field groups here
    }

    procedure ReactivatePostedTenderLines(ActiveTPVCashRegister: Record "TPV Cash Register")
    var
        TPVPostedTenderLine: Record "TPV Posted Tender Line";
        TPVTenderLine: Record "TPV Tender Line";
        ConfirmManagement: Codeunit "Confirm Management";
        OverWriteLinesQst: Label 'TPV %1 has active tender lines, are you sure you want to update the quantities with the contents of the register on %2?\%3',
            Comment = 'ESP="El TPV %1 tiene lineas de efectivo activas, está seguro que desea sustituirlas por los contenidos de la caja el día %2?\3"';
        UpdateInfoMsg: Text;
    begin
        Rec.TestField("Emptied on Post", false);

        if TPVTenderLine.CheckActiveLines(ActiveTPVCashRegister."No.") then begin
            UpdateInfoMsg := TPVTenderLine.CreateUpdateInfoMessage(Rec);
            if not ConfirmManagement.GetResponseOrDefault(StrSubstNo(OverWriteLinesQst, Rec."No.", Rec."Posting Date", UpdateInfoMsg), false) then
                Error('')
            else
                TPVTenderLine.ClearLines(ActiveTPVCashRegister."No.");
        end;

        TPVPostedTenderLine.SetRange("Cash Register No.", Rec."No.");
        TPVPostedTenderLine.SetRange("Posting Date", Rec."Posting Date");
        TPVPostedTenderLine.SetRange("From Time", Rec."From Time");
        TPVPostedTenderLine.SetRange("To Time", Rec."To Time");
        if TPVPostedTenderLine.FindSet() then
            repeat
                TPVTenderLine.TransferFields(TPVPostedTenderLine);
                TPVTenderLine.Validate(Quantity, TPVPostedTenderLine."Remaining Quantity");
                TPVTenderLine.Validate("Posting Date", ActiveTPVCashRegister."Posting Date");
                TPVTenderLine.Validate("From Time", ActiveTPVCashRegister."From Time");
                TPVTenderLine.Insert(true);
            until TPVPostedTenderLine.Next() = 0;


    end;

    procedure ReactivatePostedTenderLinesWithRemainder()
    begin

    end;

}