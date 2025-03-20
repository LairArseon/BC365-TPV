codeunit 90501 "TPV Cash Register - Post"
{

    TableNo = "TPV Cash Register";

    var
        ConfirmManagement: Codeunit "Confirm Management";
        PostingDate: Date;
        PostingTime: Time;
        NoTenderLinesToPost_Qst: Label 'Cash Register %1 does not have any Tender Lines associated with it, do you want to post it anyway?',
            Comment = 'ESP="La caja %1 no tiene líneas de efectivo asociadas, ¿desea registrarlo de todos modos?"';

    trigger OnRun()
    var
        TPVTenderLine: Record "TPV Tender Line";
        PostingCashRegisterNo: Code[20];
    begin
        PostingCashRegisterNo := Rec."No.";
        PostingDate := WorkDate();
        PostingTime := Time();

        OnCashRegisterPostingOnBeforePost(Rec, PostingDate, PostingTime);

        if not FindTenderLinesToPost(PostingCashRegisterNo, TPVTenderLine) then
            if not ConfirmManagement.GetResponseOrDefault(StrSubstNo(NoTenderLinesToPost_Qst, PostingCashRegisterNo), true) then
                Error('');

        PostCashRegister(Rec);
        PostTenderLines(TPVTenderLine);

        OnAfterPostingCashRegister(PostingCashRegisterNo);
    end;

    local procedure FindTenderLinesToPost(PostingCashRegisterNo: Code[20]; var TPVTenderLine: Record "TPV Tender Line") HasLines: Boolean
    var
        IsHandled: Boolean;
    begin
        OnBeforeFindTenderLinesToPost(PostingCashRegisterNo, TPVTenderLine, IsHandled);
        if IsHandled then
            exit;

        TPVTenderLine.SetRange("Cash Register No.", PostingCashRegisterNo);
        HasLines := not TPVTenderLine.IsEmpty();

        OnAfterFindTenderLinesToPost(PostingCashRegisterNo, TPVTenderLine);
    end;

    local procedure PostCashRegister(TPVCashRegister: Record "TPV Cash Register")
    var
        TPVPostedCashRegister: Record "TPV Posted Cash Register";
        EmptiedOnPost, PartiallyEmptiedOnPost, IsHandled : Boolean;
    begin
        OnBeforePostCashRegister(TPVCashRegister, IsHandled);
        if IsHandled then
            exit;

        TPVPostedCashRegister.CalcFields("Total Tender Amount", "Remaining Tender Amount");

        if TPVPostedCashRegister."Remaining Tender Amount" < TPVPostedCashRegister."Total Tender Amount" then begin
            PartiallyEmptiedOnPost := true;
            if TPVPostedCashRegister."Remaining Tender Amount" = 0 then
                EmptiedOnPost := true;
        end;

        TPVPostedCashRegister.TransferFields(TPVCashRegister);
        TPVPostedCashRegister.Validate("Posting Date", PostingDate);
        TPVPostedCashRegister.Validate("To Time", PostingTime);
        TPVPostedCashRegister.Validate("Emptied on Post", EmptiedOnPost);
        TPVPostedCashRegister.Validate("Partially Emptied on Post", PartiallyEmptiedOnPost);
        TPVPostedCashRegister.Insert(true);

        DeleteCashRegisterAfterPosting(TPVCashRegister);

        OnAfterPostCashRegister(TPVPostedCashRegister);
    end;

    local procedure PostTenderLines(TPVTenderLine: Record "TPV Tender Line")
    var
        TPVPostedTenderLine: Record "TPV Posted Tender Line";
        IsHandled: Boolean;
    begin
        OnBeforePostTenderLines(TPVTenderLine, IsHandled);
        if IsHandled then
            exit;

        repeat
            TPVPostedTenderLine.TransferFields(TPVTenderLine);
            TPVPostedTenderLine.Validate("Posting Date", PostingDate);
            TPVPostedTenderLine.Validate("To Time", PostingTime);
            TPVPostedTenderLine.Insert(true);
            OnPostingTenderLineAfterInsertLine(TPVTenderLine, TPVPostedTenderLine);
        until TPVTenderLine.Next() = 0;

        DeleteTenderLinesAfterPosting(TPVTenderLine);

        OnAfterPostTenderLines(TPVPostedTenderLine);
    end;

    local procedure DeleteCashRegisterAfterPosting(TPVCashRegister: Record "TPV Cash Register")
    var
        IsHandled: Boolean;
    begin
        OnBeforeDeleteCashRegister(TPVCashRegister, IsHandled);
        if IsHandled then
            exit;

        TPVCashRegister.Delete(true);
    end;

    local procedure DeleteTenderLinesAfterPosting(TPVTenderLine: Record "TPV Tender Line")
    var
        IsHandled: Boolean;
    begin
        OnBeforeDeleteTenderLines(TPVTenderLine, IsHandled);
        if IsHandled then
            exit;

        TPVTenderLine.DeleteAll(true);
    end;

    #region Integration Events

    [IntegrationEvent(false, false)]
    local procedure OnCashRegisterPostingOnBeforePost(var TPVCashRegister: Record "TPV Cash Register"; var PostingDate: Date; var PostingTime: Time)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostCashRegister(var TPVCashRegister: Record "TPV Cash Register"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostCashRegister(var TPVPostedCashRegister: Record "TPV Posted Cash Register")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostTenderLines(var TPVTenderLine: Record "TPV Tender Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostTenderLines(var TPVPostedTenderLine: Record "TPV Posted Tender Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDeleteCashRegister(TPVCashRegister: Record "TPV Cash Register"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDeleteTenderLines(TPVTenderLine: Record "TPV Tender Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostingCashRegister(PostedCashRegisterNo: Code[20])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindTenderLinesToPost(PostingCashRegisterNo: Code[20]; TPVTenderLine: Record "TPV Tender Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFindTenderLinesToPost(PostingCashRegisterNo: Code[20]; TPVTenderLine: Record "TPV Tender Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnPostingTenderLineAfterInsertLine(TPVTenderLine: Record "TPV Tender Line"; TPVPostedTenderLine: Record "TPV Posted Tender Line")
    begin
    end;

    #endregion Inregration Events

}