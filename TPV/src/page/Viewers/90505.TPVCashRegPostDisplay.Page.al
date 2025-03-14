page 90505 "TPV Cash Reg. Post. Display"
{
    Caption = 'TPV Cash Register Posting', Comment = 'ESP="Registro de Caja TPV"';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "TPV Cash Register";

    layout
    {
        area(Content)
        {
            usercontrol(TPVCashRegisterPost; "TPV Cash Register Post")
            {
                trigger ViewerReady()
                begin
                    LoadCashRegister(Rec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not RecSet then
            SetCashRegisterRecord(WorkDate(), SelectCashRegister());
    end;

    var
        RecSet: Boolean;

    procedure SelectCashRegister() CashRegisterCode: Code[20]
    var
        TPVSalesPoint: Record "TPV Sales Point";
        TPVCashRegisterList: Page "TPV Sales Point List";
    begin
        TPVCashRegisterList.LookupMode(true);
        if TPVCashRegisterList.RunModal() <> Action::LookupOK then
            Error('');

        TPVCashRegisterList.GetRecord(TPVSalesPoint);
        CashRegisterCode := TPVSalesPoint."Sales Point Code";
    end;

    procedure SetCashRegisterRecord(CurrentDate: Date; CashRegisterNo: Code[20])
    begin
        RecSet := true;

        if not Rec.Get(CashRegisterNo) then
            InitDayRecord(CurrentDate, CashRegisterNo);

        ValidateTenderLines(Rec);
    end;

    local procedure LoadCashRegister(TPVCashRegister: Record "TPV Cash Register")
    var
        TPVTenderLine: Record "TPV Tender Line";
        TPVDataManagement: Codeunit "TPV Data Management";
        CashRegisterWithTenderLines, CashRegister, TenderLine : JsonObject;
        TenderLines: JsonArray;
        IsHandled: Boolean;
    begin
        OnBeforeLoadCashRegister(IsHandled);
        if IsHandled then
            exit;

        TPVCashRegister.Serialize(CashRegister);

        TPVTenderLine.SetRange("Cash Register No.", TPVCashRegister."No.");
        if TPVTenderLine.FindSet() then
            repeat
                Clear(TenderLine);
                TPVTenderLine.Serialize(TenderLine);
                TenderLines.Add(TenderLine);
            until TPVTenderLine.Next() = 0;

        CashRegisterWithTenderLines := CashRegister;
        TPVDataManagement.AddLines(CashRegisterWithTenderLines, TenderLines);

        CurrPage.TPVCashRegisterPost.LoadElement(TPVCashRegister."No.", CashRegisterWithTenderLines);


        OnAfterLoadCashRegister();
    end;

    local procedure PostCashRegister()
    var
        PostedCashRegister: Code[20];
        PostingCodeunit: Integer;
    begin
        PostedCashRegister := Rec."No.";
        PostingCodeunit := Codeunit::"TPV Cash Register - Post";

        OnBeforePostCashRegister(PostingCodeunit, Rec);
        Codeunit.Run(Codeunit::"TPV Cash Register - Post", Rec);

        OnAfterPostCashRegister(PostedCashRegister);
    end;

    local procedure InitDayRecord(CurrentDate: Date; CashRegisterNo: Code[20])
    var
        TPVPostedCashRegister: Record "TPV Posted Cash Register";
        InitTime: Time;
        IsHandled: Boolean;
    begin
        OnBeforeInitDayRecord(IsHandled);
        if IsHandled then
            exit;

        InitTime := Time();

        Rec.Init();
        Rec.Validate("No.", CashRegisterNo);
        Rec.Insert(true);

        Rec.Validate("Posting Date", CurrentDate);
        Rec.Validate("From Time", InitTime);
        Rec.Modify(true);

        TPVPostedCashRegister.SetAscending("To Time", true);
        TPVPostedCashRegister.SetRange("No.", CashRegisterNo);
        TPVPostedCashRegister.SetRange("Posting Date", CurrentDate);
        if TPVPostedCashRegister.FindLast() then
            if not TPVPostedCashRegister."Emptied on Post" then
                TPVPostedCashRegister.ReactivatePostedTenderLines(Rec)
            else
                CreateBaseTenderLines(Rec)
        else
            CreateBaseTenderLines(Rec);

        OnAfterInitDayRecord();
    end;

    local procedure CreateBaseTenderLines(TPVCashRegister: Record "TPV Cash Register")
    var
        TPVSalesPointTender: Record "TPV Sales Point - Tender";
        TPVTenderLine: Record "TPV Tender Line";
        LineNo: Integer;
        IsHandled: Boolean;
    begin
        OnBeforeCreateBaseTenderLines(IsHandled);
        if IsHandled then
            exit;

        LineNo := 10000;

        TPVSalesPointTender.SetRange("Sales Point Code", TPVCashRegister."No.");
        if TPVSalesPointTender.FindSet() then
            repeat
                TPVTenderLine.Init();
                TPVTenderLine.Validate("Cash Register No.", TPVSalesPointTender."Sales Point Code");
                TPVTenderLine.Validate("Currency Code", TPVSalesPointTender."Currency Code");
                TPVTenderLine.Validate("Tender Type", TPVSalesPointTender."Tender Type");
                TPVTenderLine.Validate("Tender Code", TPVSalesPointTender."Tender Code");
                TPVTenderLine.Insert(true);
                LineNo += 10000;

            until TPVSalesPointTender.Next() = 0;


        OnAfterCreateBaseTenderLines();
    end;

    local procedure ValidateTenderLines(TPVCashRegister: Record "TPV Cash Register")
    var
        TPVSalesPointTender: Record "TPV Sales Point - Tender";
        TPVTenderLine: Record "TPV Tender Line";
        IsHandled: Boolean;
    begin
        OnBeforeValidateTenderLines(IsHandled);
        if IsHandled then
            exit;

        TPVSalesPointTender.SetRange("Sales Point Code", TPVCashRegister."No.");
        if TPVSalesPointTender.FindSet() then
            repeat
                if not TPVTenderLine.Get(TPVSalesPointTender."Sales Point Code", TPVSalesPointTender."Currency Code", TPVSalesPointTender."Tender Type", TPVSalesPointTender."Tender Code") then begin
                    TPVTenderLine.Init();
                    TPVTenderLine.Validate("Cash Register No.", TPVSalesPointTender."Sales Point Code");
                    TPVTenderLine.Validate("Currency Code", TPVSalesPointTender."Currency Code");
                    TPVTenderLine.Validate("Tender Type", TPVSalesPointTender."Tender Type");
                    TPVTenderLine.Validate("Tender Code", TPVSalesPointTender."Tender Code");
                    TPVTenderLine.Insert(true);
                end;
            until TPVSalesPointTender.Next() = 0;

        OnAfterValidateTenderLines();
    end;

    #region Integration Events

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInitDayRecord(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitDayRecord()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostCashRegister(var PostingCodeunit: Integer; var Rec: Record "TPV Cash Register")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostCashRegister(var PostedCashRegister: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLoadCashRegister(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterLoadCashRegister()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateBaseTenderLines(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateBaseTenderLines()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeValidateTenderLines(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateTenderLines()
    begin
    end;

    #endregion Integration Events
}