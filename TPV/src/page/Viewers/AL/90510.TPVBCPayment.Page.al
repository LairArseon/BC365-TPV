page 90510 "TPV BC Payment"
{
    Caption = 'TPV BC Payment interface', Comment = 'ESP="Interfaz pagos BC TPV"';
    DataCaptionFields = "Source Document";
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "TPV Payment Line Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(SourceDetails)
            {
                Caption = 'Details', Comment = 'ESP="Detalles"';
                field("Sales Point"; Rec."Sales Point") { }
                field("Account No."; Rec."Account No.") { }
                field(Description; Rec.Description) { }
                field("Payment Method"; Rec."Payment Method") { }
                field("Source Document"; Format(Rec."Source Document")) { }

            }
            group(Amounts)
            {
                Caption = 'Amounts', Comment = 'ESP="Cantidades"';
                field("Amount Total (Inc. VAT)"; Rec."Amount Total (Inc. VAT)") { }
                field("Amount Due (Inc. VAT)"; Rec."Amount Due (Inc. VAT)") { }
                field("Amount Already Paid"; Rec."Amount Already Paid") { }
                field(Amount; Rec.Amount) { }
            }
        }
    }

    actions
    {
        area(Promoted)
        {
            actionref(PostPaymentAct_Ref; PostPaymentAct) { }
        }

        area(Processing)
        {
            action(PostPaymentAct)
            {
                Caption = 'Post', Comment = 'ESP="Registrar"';
                Image = PostedPayment;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    PostPayment();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SelectSalesPoint();
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

    local procedure SelectSalesPoint()
    var
        TPVSalesPoint: Record "TPV Sales Point";
        SalesPoint: Code[20];
    begin
        if not TPVSalesPoint.SelectSalesPoint(UserId, Rec."Sales Point") then
            Error('You must select a Sales Point')
        else
            Rec.Modify();
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

    #endregion Integration Events
}