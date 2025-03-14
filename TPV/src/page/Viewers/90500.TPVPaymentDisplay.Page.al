page 90500 "TPV Payment Display"
{
    Caption = 'TPV Payment interface', Comment = 'ESP="Interfaz pagos TPV"';
    DataCaptionFields = "Source Record";
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "TPV Line Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            usercontrol(TPVLineDisplay; "TPV Payment Display")
            {
                trigger ViewerReady()
                begin
                    LoadFirstElement();
                end;

                trigger UpdateFieldValue(ElementID: Text; FieldNo: Integer; NewValue: Text)
                begin
                    UpdateFieldDisplayValue(ElementID, FieldNo, NewValue);
                end;

                trigger TriggerSelector(ElementID: Text; FromFieldNo: Integer; RelatedTableNo: Integer; RelatedFieldNo: Integer)
                var
                    NewValue: Text;
                begin
                    if GetNewValueFromRelatedRecord(ElementID, FromFieldNo, RelatedTableNo, RelatedFieldNo, NewValue) then
                        UpdateFieldDisplayValue(ElementID, FromFieldNo, NewValue)
                    else
                        ThrowError(ElementID, FromFieldNo, '');
                end;
            }
        }
    }

    local procedure LoadFirstElement()
    var
        IsHandled: Boolean;
    begin
        OnBeforeLoadFirstElement(IsHandled);
        if IsHandled then
            exit;

        if Rec.FindFirst() then
            LoadLine(Rec, Rec."Source Record");

        OnAfterLoadFirstElement();
    end;

    local procedure LoadLine(var TPVBuffer: Record "TPV Line Buffer" temporary; RecordId: RecordId)
    var
        IsHandled: Boolean;
    begin
        OnBeforeLoadElement(TPVBuffer, IsHandled);
        if IsHandled then
            exit;

        CurrPage.TPVLineDisplay.LoadElement(
            Format(TPVBuffer."Source Record"),
            TPVBuffer.SerializeLine(RecordId));

        CurrPage.TPVLineDisplay.DisplayElement(Format(RecordId));

        OnAfterLoadElement(TPVBuffer);
    end;

    local procedure UpdateFieldDisplayValue(ElementID: Text; FieldNo: Integer; NewValue: Text)
    var
        IsHandled: Boolean;
    begin
        OnBeforeUpdateFieldDisplayValue(ElementID, FieldNo, NewValue, IsHandled);
        if IsHandled then
            exit;

        CurrPage.TPVLineDisplay.UpdateFieldDisplayValue(ElementID, FieldNo, NewValue);

        OnAfterUpdateFieldDisplayValue(ElementID, FieldNo, NewValue);
    end;

    local procedure GetNewValueFromRelatedRecord(ElementID: Text; FromFieldNo: Integer; RelatedTableNo: Integer; RelatedFieldNo: Integer; var NewValue: Text) ValueChosen: Boolean
    var
        TPVDataManagement: Codeunit "TPV Data Management";
        IsHandled: Boolean;
    begin
        OnBeforeGetNewValueFromRelatedRecord(ElementID, FromFieldNo, RelatedTableNo, RelatedFieldNo, NewValue, ValueChosen, IsHandled);
        if IsHandled then
            exit;

        case FromFieldNo of


        end;

        ThrowError(ElementID, FromFieldNo, '');

        OnAfterGetNewValueFromRelatedRecord(ElementID, FromFieldNo, RelatedTableNo, RelatedFieldNo, NewValue, ValueChosen);
    end;

    local procedure ThrowError(ElementID: Text; FromFieldNo: Integer; ErrorText: Text)
    var
        IsHandled: Boolean;
    begin
        OnBeforeThrowError(ElementID, FromFieldNo, ErrorText, IsHandled);
        if IsHandled then
            exit;

        CurrPage.TPVLineDisplay.ThrowError(ElementID, FromFieldNo, ErrorText);

        OnAfterThrowError(ElementID, FromFieldNo, ErrorText);
    end;

    #region Integration Events

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLoadFirstElement(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterLoadFirstElement()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeLoadElement(var TPVBuffer: Record "TPV Line Buffer" temporary; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterLoadElement(var TPVBuffer: Record "TPV Line Buffer" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateFieldDisplayValue(ElementID: Text; FieldNo: Integer; NewValue: Text; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateFieldDisplayValue(ElementID: Text; FieldNo: Integer; NewValue: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeThrowError(ElementID: Text; FromFieldNo: Integer; ErrorText: Text; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterThrowError(ElementID: Text; FromFieldNo: Integer; ErrorText: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetNewValueFromRelatedRecord(ElementID: Text; FromFieldNo: Integer; RelatedTableNo: Integer; RelatedFieldNo: Integer; NewValue: Text; var returnVar: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetNewValueFromRelatedRecord(ElementID: Text; FromFieldNo: Integer; RelatedTableNo: Integer; RelatedFieldNo: Integer; NewValue: Text; var returnVar: Boolean)
    begin
    end;

    #endregion Integration Events

}