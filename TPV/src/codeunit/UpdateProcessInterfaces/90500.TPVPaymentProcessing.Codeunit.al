codeunit 90500 "TPV Payment Processing" implements "TPV Payment Process"
{

    var
        TPVSetup: Record "TPV Setup";
        GenJnlTemplateName, GenJnlBatchName : Code[10];
        SetupGet: Boolean;


    procedure PostPaymentLine(var TPVPaymentLineBuffer: Record "TPV Payment Line Buffer" temporary)
    var
        TPVSalesPoint: Record "TPV Sales Point";
        IsHandled: Boolean;
    begin
        OnBeforePostPaymentLine(TPVPaymentLineBuffer, IsHandled);
        if IsHandled then
            exit;

        TPVPaymentLineBuffer.TestField("Payment Method");
        TPVPaymentLineBuffer.TestField(Amount);

        TPVSalesPoint.Get(TPVPaymentLineBuffer."Sales Point");
        GetSetup(TPVSalesPoint);
        CreateCreditPaymentLine(TPVPaymentLineBuffer);
        CreateDebitPaymentLine(TPVPaymentLineBuffer);

        PostCurrentLine(TPVPaymentLineBuffer);
    end;

    /// <summary>
    /// Gets the TPV Setup and Sets the Template and Batch that will be used for posting if specific Batch is selected on Sales Point
    /// </summary>
    procedure GetSetup(TPVSalesPoint: Record "TPV Sales Point"): Record "TPV Setup"
    begin
        if not SetupGet then
            TPVSetup.Get();

        TPVSetup.TestField("Journal Template Name");
        GenJnlTemplateName := TPVSetup."Journal Template Name";
        if TPVSalesPoint."Journal Batch Name" <> '' then
            GenJnlBatchName := TPVSalesPoint."Journal Batch Name"
        else begin
            TPVSetup.TestField("Journal Batch Name");
            GenJnlBatchName := TPVSetup."Journal Batch Name";
        end;

        OnAfterGetTPVSetup(GenJnlTemplateName, GenJnlBatchName);

        exit(TPVSetup);
    end;

    /// <summary>
    /// Creates the Credit payment line for the payment
    /// </summary>
    procedure CreateCreditPaymentLine(var TPVPaymentLineBuffer: Record "TPV Payment Line Buffer" temporary)
    var
        TPVSalesPointPaymentMethod: Record "TPV Sales Point Payment Method";
        GenJournalLine: Record "Gen. Journal Line";
        IsHandled: Boolean;
    begin
        OnBeforeCreateCreditPaymentLine(TPVPaymentLineBuffer, IsHandled);
        if IsHandled then
            exit;

        CorrectSign(TPVPaymentLineBuffer);
        InitGenJnlLine(GenJournalLine, TPVPaymentLineBuffer);

        case TPVPaymentLineBuffer."Payment Direction" of
            Enum::"TPV Payment Direction"::Inbound:
                begin
                    GenJournalLine.Validate("Account Type", Enum::"Gen. Journal Account Type"::Customer);
                    GenJournalLine.Validate("Account No.", TPVPaymentLineBuffer."Account No.");
                    GenJournalLine.Validate("Payment Method Code", TPVPaymentLineBuffer."Payment Method");
                    GenJournalLine.Validate("Credit Amount", TPVPaymentLineBuffer.Amount);
                end;
            Enum::"TPV Payment Direction"::Outbound:
                begin
                    GenJournalLine.Validate("Account Type", Enum::"Gen. Journal Account Type"::"G/L Account");
                    TPVSalesPointPaymentMethod.Get(TPVPaymentLineBuffer."Sales Point", TPVPaymentLineBuffer."Payment Method");
                    TPVSalesPointPaymentMethod.TestField("Bal. Account No.");
                    GenJournalLine.Validate("Account No.", TPVSalesPointPaymentMethod."Bal. Account No.");
                    GenJournalLine.Validate("Payment Method Code", TPVPaymentLineBuffer."Payment Method");
                    GenJournalLine.Validate("Credit Amount", TPVPaymentLineBuffer.Amount);
                end;
        end;

        GenJournalLine.Insert(true);

        OnAfterCreateCreditPaymentLine(TPVPaymentLineBuffer);
    end;

    /// <summary>
    /// Creates the Debit payment line for the payment
    /// </summary>
    procedure CreateDebitPaymentLine(var TPVPaymentLineBuffer: Record "TPV Payment Line Buffer" temporary)
    var
        TPVSalesPointPaymentMethod: Record "TPV Sales Point Payment Method";
        GenJournalLine: Record "Gen. Journal Line";
        IsHandled: Boolean;
    begin
        OnBeforeCreateDebitPaymentLine(TPVPaymentLineBuffer, IsHandled);
        if IsHandled then
            exit;

        CorrectSign(TPVPaymentLineBuffer);
        InitGenJnlLine(GenJournalLine, TPVPaymentLineBuffer);

        case TPVPaymentLineBuffer."Payment Direction" of
            Enum::"TPV Payment Direction"::Inbound:
                begin
                    GenJournalLine.Validate("Account Type", Enum::"Gen. Journal Account Type"::"G/L Account");
                    TPVSalesPointPaymentMethod.Get(TPVPaymentLineBuffer."Sales Point", TPVPaymentLineBuffer."Payment Method");
                    TPVSalesPointPaymentMethod.TestField("Bal. Account No.");
                    GenJournalLine.Validate("Account No.", TPVSalesPointPaymentMethod."Bal. Account No.");
                    GenJournalLine.Validate("Payment Method Code", TPVPaymentLineBuffer."Payment Method");
                    GenJournalLine.Validate("Debit Amount", TPVPaymentLineBuffer.Amount);
                end;
            Enum::"TPV Payment Direction"::Outbound:
                begin
                    GenJournalLine.Validate("Account Type", Enum::"Gen. Journal Account Type"::Customer);
                    GenJournalLine.Validate("Account No.", TPVPaymentLineBuffer."Account No.");
                    GenJournalLine.Validate("Payment Method Code", TPVPaymentLineBuffer."Payment Method");
                    GenJournalLine.Validate("Debit Amount", TPVPaymentLineBuffer.Amount);
                end;
        end;

        GenJournalLine.Insert(true);

        OnAfterCreateDebitPaymentLine(TPVPaymentLineBuffer);
    end;

    /// <summary>
    /// Create the general journal line that will be filled with the specific quantities for a payment journal
    /// </summary>
    local procedure InitGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; TPVPaymentLineBuffer: Record "TPV Payment Line Buffer" temporary)
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        GenJournalTemplate: Record "Gen. Journal Template";
        GenJournalBatch: Record "Gen. Journal Batch";
        NoSeries: Codeunit "No. Series";
        GenJnlLineNo: Integer;
        IsHandled: Boolean;
    begin
        OnBeforeInitGenJnlLine(GenJournalLine, TPVPaymentLineBuffer, IsHandled);
        if IsHandled then
            exit;

        GenJournalLine.SetRange("Journal Template Name", GenJnlTemplateName);
        GenJournalLine.SetRange("Journal Batch Name", GenJnlBatchName);
        if GenJournalLine.FindLast() then
            GenJnlLineNo := GenJournalLine."Line No." + 10000
        else
            GenJnlLineNo := 10000;

        GenJournalTemplate.Get(GenJnlTemplateName);
        GenJournalBatch.Get(GenJnlTemplateName, GenJnlBatchName);

        GenJournalLine.Init();
        GenJournalLine.Validate("Journal Template Name", GenJnlTemplateName);
        GenJournalLine.Validate("Journal Batch Name", GenJnlBatchName);
        GenJournalLine.Validate("Line No.", GenJnlLineNo);
        if TPVPaymentLineBuffer.Refund then
            GenJournalLine.Validate("Document Type", Enum::"Gen. Journal Document Type"::Refund)
        else
            GenJournalLine.Validate("Document Type", Enum::"Gen. Journal Document Type"::Payment);
        GenJournalLine."Posting Date" := WorkDate();
        GenJournalLine."Document Date" := WorkDate();
        GenJournalLine."VAT Reporting Date" := GeneralLedgerSetup.GetVATDate(GenJournalLine."Posting Date", GenJournalLine."Document Date");
        if GenJournalBatch."No. Series" <> '' then
            GenJournalLine."Document No." := NoSeries.PeekNextNo(GenJournalBatch."No. Series", GenJournalLine."Posting Date");

        GenJournalLine."Source Code" := GenJournalTemplate."Source Code";
        GenJournalLine."Reason Code" := GenJournalBatch."Reason Code";
        GenJournalLine."Posting No. Series" := GenJournalBatch."Posting No. Series";

        GenJournalLine."Bal. Account Type" := GenJournalBatch."Bal. Account Type";
        if (GenJournalLine."Account Type" in [GenJournalLine."Account Type"::Customer, GenJournalLine."Account Type"::Vendor, GenJournalLine."Account Type"::"Fixed Asset"]) and
           (GenJournalLine."Bal. Account Type" in [GenJournalLine."Bal. Account Type"::Customer, GenJournalLine."Bal. Account Type"::Vendor, GenJournalLine."Bal. Account Type"::"Fixed Asset"])
        then
            GenJournalLine."Account Type" := GenJournalLine."Account Type"::"G/L Account";
        GenJournalLine.Validate("Bal. Account No.", GenJournalBatch."Bal. Account No.");
        GenJournalLine.Description := '';

        GenJournalLine.UpdateJournalBatchID();

        GenJournalLine.Validate("Payment Reference", TPVPaymentLineBuffer."Payment Reference");

        OnAfterInitGenJnlLine(GenJournalLine, TPVPaymentLineBuffer);
    end;

    /// <summary>
    /// When quantities are made negative we assume the operation shloud be reversed
    /// </summary>
    local procedure CorrectSign(var TPVPaymentLineBuffer: Record "TPV Payment Line Buffer" temporary)
    var
        IsHandled: Boolean;
    begin
        OnBeforeCorrectSign(TPVPaymentLineBuffer, IsHandled);
        if IsHandled then
            exit;

        if (TPVPaymentLineBuffer."Payment Direction" = Enum::"TPV Payment Direction"::Inbound) and (TPVPaymentLineBuffer.Amount < 0) then begin
            TPVPaymentLineBuffer."Payment Direction" := Enum::"TPV Payment Direction"::Outbound;
            TPVPaymentLineBuffer.Amount := Abs(TPVPaymentLineBuffer.Amount);
            TPVPaymentLineBuffer.Refund := true;
        end;

        if (TPVPaymentLineBuffer."Payment Direction" = Enum::"TPV Payment Direction"::Outbound) and (TPVPaymentLineBuffer.Amount < 0) then begin
            TPVPaymentLineBuffer."Payment Direction" := Enum::"TPV Payment Direction"::Inbound;
            TPVPaymentLineBuffer.Amount := Abs(TPVPaymentLineBuffer.Amount);
            TPVPaymentLineBuffer.Refund := true;
        end;

        OnAfterCorrectSign(TPVPaymentLineBuffer);
    end;

    /// <summary>
    /// Posts the journals if indicated to in the Sales point setup and creates a posting history of the operation
    /// </summary>
    local procedure PostCurrentLine(var TPVPaymentLineBuffer: Record "TPV Payment Line Buffer")
    var
        TPVPostedPaymentLine: Record "TPV Posted Payment Line";
        NewLineNo: Integer;
        IsHandled: Boolean;
    begin
        OnBeforePostCurrentLine(TPVPaymentLineBuffer, IsHandled);
        if IsHandled then
            exit;

        PostJournalLinesIfRequired(TPVPaymentLineBuffer);

        TPVPostedPaymentLine.SetRange("Source Document", TPVPaymentLineBuffer."Source Document");
        if TPVPostedPaymentLine.FindLast() then
            NewLineNo := TPVPostedPaymentLine."Line No." + 10000
        else
            NewLineNo := 10000;

        TPVPaymentLineBuffer.Validate("Posting Date", WorkDate());
        TPVPaymentLineBuffer.Validate("Posting Time", Time());
        TPVPostedPaymentLine.TransferFields(TPVPaymentLineBuffer);
        TPVPostedPaymentLine.Validate("Line No.", NewLineNo);
        TPVPostedPaymentLine.Insert(true);

        TPVPaymentLineBuffer.Delete(true);

        OnAfterPostCurrentLine(TPVPostedPaymentLine);
    end;

    /// <summary>
    /// Posts the created journal lines for the payment
    /// </summary>
    local procedure PostJournalLinesIfRequired(var TPVPaymentLineBuffer: Record "TPV Payment Line Buffer" temporary)
    var
        TPVPaymentPostEventBinding: Codeunit "TPV Payment-Post Event Binding";
        GenJournalLine: Record "Gen. Journal Line";
        TPVSalesPoint: Record "TPV Sales Point";
        IsHandled: Boolean;
    begin
        OnBeforePostJournalLinesIfRequired(TPVPaymentLineBuffer, IsHandled);
        if IsHandled then
            exit;

        BindSubscription(TPVPaymentPostEventBinding);

        TPVSalesPoint.Get(TPVPaymentLineBuffer."Sales Point");
        if not TPVSalesPoint."Auto Post Payments" then
            exit;

        GenJournalLine.SetRange("Payment Reference", TPVPaymentLineBuffer."Payment Reference");
        if GenJournalLine.FindSet() then
            GenJournalLine.SendToPosting(Codeunit::"Gen. Jnl.-Post");

        UnbindSubscription(TPVPaymentPostEventBinding);

        OnAfterPostJournalLinesIfRequired(TPVPaymentLineBuffer);
    end;

    #region Integration Events

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateCreditPaymentLine(TPVPaymentLineBuffer: Record "TPV Payment Line Buffer"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateCreditPaymentLine(TPVPaymentLineBuffer: Record "TPV Payment Line Buffer")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateDebitPaymentLine(TPVPaymentLineBuffer: Record "TPV Payment Line Buffer"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateDebitPaymentLine(TPVPaymentLineBuffer: Record "TPV Payment Line Buffer")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostCurrentLine(TPVPaymentLineBuffer: Record "TPV Payment Line Buffer"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostCurrentLine(TPVPostedPaymentLine: Record "TPV Posted Payment Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetTPVSetup(var GenJnlTemplateName: Code[10]; var GenJnlBatchName: Code[10])
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInitGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; TPVPaymentLineBuffer: Record "TPV Payment Line Buffer"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; TPVPaymentLineBuffer: Record "TPV Payment Line Buffer")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostJournalLinesIfRequired(var TPVPaymentLineBuffer: Record "TPV Payment Line Buffer" temporary; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostJournalLinesIfRequired(var TPVPaymentLineBuffer: Record "TPV Payment Line Buffer" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCorrectSign(var TPVPaymentLineBuffer: Record "TPV Payment Line Buffer" temporary; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCorrectSign(var TPVPaymentLineBuffer: Record "TPV Payment Line Buffer" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostPaymentLine(var TPVPaymentLineBuffer: Record "TPV Payment Line Buffer" temporary; var IsHandled: Boolean)
    begin
    end;

    #endregion Integration Events
}