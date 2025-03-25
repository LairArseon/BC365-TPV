codeunit 90504 "TPV Payment-Post Event Binding"
{
    EventSubscriberInstance = Manual;
    SingleInstance = true;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", OnBeforeCode, '', false, false)]
    local procedure "Gen. Jnl.-Post_OnBeforeCode"(var HideDialog: Boolean)
    begin
        HideDialog := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post", OnBeforeShowPostResultMessage, '', false, false)]
    local procedure "Gen. Jnl.-Post_OnBeforeShowPostResultMessage"(var GenJnlLine: Record "Gen. Journal Line"; var IsHandled: Boolean)
    begin
        if GenJnlLine."Line No." = 0 then
            exit;

        IsHandled := true;
    end;

}