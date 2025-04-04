page 90500 "TPV Payment Display"
{
    Caption = 'TPV Payment interface', Comment = 'ESP="Interfaz pagos TPV"';
    DataCaptionFields = "Source Document";
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "TPV Payment Line Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            usercontrol(TPVLineDisplay; "TPV Payment Display")
            {
                trigger ViewerReady()
                begin
                    LoadElement();
                end;

                trigger ValidateField(ElementID: Text; FieldNo: Integer; NewValue: Text)
                begin
                    UpdateFieldDisplayValue(ElementID, FieldNo, NewValue);
                end;

                trigger TriggerSelector(ElementID: Text; FieldNo: Integer)
                var
                    NewValue: Text;
                begin
                    if SelectValueFromRelatedRecord(ElementID, FieldNo, NewValue) then
                        UpdateFieldDisplayValue(ElementID, FieldNo, NewValue)
                    else
                        ThrowError(ElementID, FieldNo, '');
                end;

                trigger Submit()
                begin
                    PostPayment();
                end;
            }
        }
    }

    local procedure LoadElement()
    var
        IsHandled: Boolean;
    begin
        OnBeforeLoadFirstElement(IsHandled);
        if IsHandled then
            exit;

        LoadElement(Rec, Rec."Source Document");

        OnAfterLoadFirstElement();
    end;

    local procedure LoadElement(var TPVPaymentBuffer: Record "TPV Payment Line Buffer" temporary; RecordId: RecordId)
    var
        TPVDataManagement: Codeunit "TPV Data Management";
        PaymentLine: JsonObject;
        IncludedFields: JsonArray;
        IsHandled: Boolean;
    begin
        OnBeforeLoadElement(TPVPaymentBuffer, IsHandled);
        if IsHandled then
            exit;

        TPVPaymentBuffer.Serialize(PaymentLine);
        CurrPage.TPVLineDisplay.LoadElement(
            Format(TPVPaymentBuffer."Source Document"),
            PaymentLine);

        GetDisplayFields(IncludedFields);
        CurrPage.TPVLineDisplay.DisplayElement(Format(RecordId), IncludedFields);

        OnAfterLoadElement(TPVPaymentBuffer);
    end;

    local procedure GetDisplayFields(var IncludedFields: JsonArray)
    var
        FieldMask: JsonObject;
        IsHandled: Boolean;
    begin
        OnBeforeGetDisplayFields(IncludedFields, IsHandled);
        if IsHandled then
            exit;

        AddDisplayField(IncludedFields, Rec.FieldNo("Account No."), false, false, 10);
        AddDisplayField(IncludedFields, Rec.FieldNo(Description), true, false, 20);
        AddDisplayField(IncludedFields, Rec.FieldNo("Sales Point"), false, false, 30);
        AddDisplayField(IncludedFields, Rec.FieldNo("Payment Method"), false, true, 40);
        AddDisplayField(IncludedFields, Rec.FieldNo("Payment Reference"), false, false, 50);
        AddDisplayField(IncludedFields, Rec.FieldNo("Amount Total (Inc. VAT)"), false, false, 60);
        AddDisplayField(IncludedFields, Rec.FieldNo("Amount Due (Inc. VAT)"), false, false, 70);
        AddDisplayField(IncludedFields, Rec.FieldNo("Amount Already Paid"), false, false, 80);
        AddDisplayField(IncludedFields, Rec.FieldNo(Amount), true, false, 90);

        OnAfterGetDisplayFields(IncludedFields);
    end;

    local procedure AddDisplayField(var FieldsArray: JsonArray; FieldNo: Integer; Editable: Boolean; AddSelector: Boolean; Position: Integer)
    var
        TPVDataManagement: Codeunit "TPV Data Management";
        FieldObject: JsonObject;
        IsHandled: Boolean;
    begin
        OnBeforeAddDisplayField(FieldNo, Editable, Position, IsHandled);
        if IsHandled then
            exit;

        FieldsArray.Add(TPVDataManagement.CreateFieldDisplayMask(FieldNo, Editable, AddSelector, Position));
    end;

    [TryFunction]
    local procedure ValidateField(ElementID: Text; FieldNo: Integer; NewValue: Text)
    var
        RecRef: RecordRef;
        FieldRef: FieldRef;
    begin
        RecRef.Open(Rec.RecordId.TableNo);
        RecRef.Copy(Rec, true);

        FieldRef := RecRef.Field(FieldNo);
        FieldRef.Validate(NewValue);
    end;

    local procedure UpdateFieldDisplayValue(ElementID: Text; FieldNo: Integer; NewValue: Text)
    var
        IsHandled: Boolean;
    begin
        OnBeforeUpdateFieldDisplayValue(ElementID, FieldNo, NewValue, IsHandled);
        if IsHandled then
            exit;

        CurrPage.TPVLineDisplay.UpdateFieldValue(ElementID, FieldNo, NewValue);

        OnAfterUpdateFieldDisplayValue(ElementID, FieldNo, NewValue);
    end;

    local procedure SelectValueFromRelatedRecord(ElementID: Text; FieldNo: Integer; var NewValue: Text) ValueChosen: Boolean
    var
        TPVDataManagement: Codeunit "TPV Data Management";
        IsHandled: Boolean;
    begin
        OnBeforeGetNewValueFromRelatedRecord(ElementID, FieldNo, NewValue, ValueChosen, IsHandled);
        if IsHandled then
            exit;

        case FieldNo of
            Rec.FieldNo("Payment Method"):
                begin

                end;

        end;

        ThrowError(ElementID, FieldNo, '');

        OnAfterGetNewValueFromRelatedRecord(ElementID, FieldNo, NewValue, ValueChosen);
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

    local procedure PostPayment()
    var
        TPVPaymentProcess: Interface "TPV Payment Process";
        ProcessImplementation: Enum "TPV Update Processing";
        IsHandled: Boolean;
    begin
        ProcessImplementation := ProcessImplementation::"Payment Process";
        OnBeforePostPayment(ProcessImplementation, IsHandled);
        if IsHandled then
            exit;

        TPVPaymentProcess := ProcessImplementation;
        TPVPaymentProcess.PostPaymentLine(Rec);

        OnAfterPostPayment();
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
    local procedure OnBeforeLoadElement(var TPVPaymentBuffer: Record "TPV Payment Line Buffer" temporary; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterLoadElement(var TPVPaymentBuffer: Record "TPV Payment Line Buffer" temporary)
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
    local procedure OnBeforeGetNewValueFromRelatedRecord(ElementID: Text; FromFieldNo: Integer; NewValue: Text; var returnVar: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetNewValueFromRelatedRecord(ElementID: Text; FromFieldNo: Integer; NewValue: Text; var returnVar: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostPayment(var ProcessImplementation: Enum "TPV Update Processing"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostPayment()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetDisplayFields(IncludedFields: JsonArray; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetDisplayFields(IncludedFields: JsonArray)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeAddDisplayField(FieldNo: Integer; var Editable: Boolean; var Position: Integer; var IsHandled: Boolean)
    begin
    end;

    #endregion Integration Events

}