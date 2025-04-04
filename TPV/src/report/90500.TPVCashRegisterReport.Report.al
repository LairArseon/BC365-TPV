report 90500 "TPV Cash Register Report"
{
    Caption = 'TPV Cash Register Report', Comment = 'ESP="Informe Registro Caja TPV"';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = RDLLayout;

    dataset
    {
        dataitem("TPV Posted Cash Register"; "TPV Posted Cash Register")
        {
            column(No_TPVPostedCashRegister; "No.") { }
            column(PostingDate_TPVPostedCashRegister; "Posting Date") { }
            column(PaymentTerminalAmount_TPVPostedCashRegister; "Payment Terminal Amount") { }
            column(Description_TPVPostedCashRegister; Description) { }
            column(TotalTenderAmountLCY_TPVPostedCashRegister; "Total Tender Amount (LCY)") { }
            column(RunDate; WorkDate()) { }
            column(RunTime; Time()) { }
            column(CompanyName; CompanyName()) { }

            dataitem(tempTPVDailyCashReportBuffer; "TPV Daily Cash Report Buffer")
            {
                UseTemporary = true;

                column(No_tempTPVDailyCashReportBuffer; "No.") { IncludeCaption = true; }
                column(CustomerNo_tempTPVDailyCashReportBuffer; "Customer No.") { IncludeCaption = true; }
                column(CustomerName_tempTPVDailyCashReportBuffer; "Customer Name") { IncludeCaption = true; }
                column(DocumentNo_tempTPVDailyCashReportBuffer; "Document No.") { IncludeCaption = true; }
                column(PaymentMethod_tempTPVDailyCashReportBuffer; "Payment Method") { IncludeCaption = true; }
                column(Amount_tempTPVDailyCashReportBuffer; Amount) { IncludeCaption = true; }
                column(PaidAmount_tempTPVDailyCashReportBuffer; "Paid Amount") { IncludeCaption = true; }
                column(DocumentType_tempTPVDailyCashReportBuffer; "Transaction Type".AsInteger()) { }

            }

            dataitem("TPV Posted Tender Line"; "TPV Posted Tender Line")
            {
                DataItemLinkReference = "TPV Posted Cash Register";
                DataItemLink = "Cash Register No." = field("No."), "Posting Date" = field("Posting Date"), "From Time" = field("From Time"), "To Time" = field("To Time");

                column(TenderCode_TPVPostedTenderLine; "Tender Code") { IncludeCaption = true; }
                column(Quantity_TPVPostedTenderLine; Quantity) { IncludeCaption = true; }
                column(AmountLCY_TPVPostedTenderLine; "Amount (LCY)") { IncludeCaption = true; }
            }

            trigger OnPreDataItem()
            begin
                "TPV Posted Cash Register".CalcFields("Total Tender Amount (LCY)");
                "TPV Posted Cash Register".SetFilter("Posting Date", PostingDateFilter);
            end;

            trigger OnAfterGetRecord()
            var
                TPVSalesPointPaymentMethod: Record "TPV Sales Point Payment Method";
                CustLedgerEntryPaymentMethodFilter: Text;
            begin
                CustLedgerEntryPaymentMethodFilter := TPVSalesPointPaymentMethod.GetAsFilter("TPV Posted Cash Register"."No.");
                LoadCustomerLedgerEntries(CustLedgerEntryPaymentMethodFilter);
            end;
        }

    }



    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Filters)
                {
                    Caption = 'Filters', Comment = 'ESP="Filtros"';

                    field(PostingDateFilter; PostingDateFilter)
                    {
                        Caption = 'Posting Date', Comment = 'ESP="Fecha Registro"';
                    }
                }
            }
        }

        trigger OnOpenPage()
        begin
            PostingDateFilter := "TPV Posted Cash Register".GetFilter("Posting Date");
            if PostingDateFilter = '' then
                PostingDateFilter := Format(WorkDate())
        end;
    }

    rendering
    {
        layout(RDLLayout)
        {
            Type = RDLC;
            LayoutFile = './src/report/CashRegisterReport.rdl';
        }
    }
    labels
    {
        Title = 'Daily Cash Register posting report with transaction details', Comment = 'ESP="Informe diario de caja con detalle de transacciones"';
        CashRegPostingDate = 'Cash register posting date', Comment = 'ESP="Fecha Ciere de Caja"';
        Date = 'Date', Comment = 'ESP="Fecha"';
        Time = 'Time', Comment = 'ESP="Hora"';
        CashCounting = 'Cash Totals', Comment = 'ESP="Arqueo Caja"';
        Subtotal = 'Subtotal', Comment = 'ESP="Subtotal"';
        Total = 'Total', Comment = 'ESP="Total"';
        GeneralTotal = 'General Total', Comment = 'ESP="Total General"';
        PaymentToOrder = 'Payment to Orders', Comment = 'ESP="Pagos a Pedidos"';
        Refunds = 'Refunds', Comment = 'ESP="Reembolsos"';
        PaymentsToInvoice = 'Payments to Invoice', Comment = 'ESP="Pagos a Facturas"';
        PaymentsToOlderInvoices = 'Payments to Older Invoices', Comment = 'ESP="Pagos a Facturas Anteriores"';
    }

    var
        PostingDateFilter: Text;
        EntryNo: Integer;

    local procedure LoadCustomerLedgerEntries(CustLedgerEntryPaymentMethodFilter: Text)
    var
        CustLedgerEntry, CustLedgerEntry2 : Record "Cust. Ledger Entry";
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        TransactionType: Enum "TPV Daily Transaction Type";
        DocumentNo: Code[20];
        Amount: Decimal;
    begin
        // Search for all payments and refunds
        CustLedgerEntry.SetFilter("Posting Date", PostingDateFilter);
        CustLedgerEntry.SetFilter("Document Type", '%1|%2', Enum::"Gen. Journal Document Type"::Payment, Enum::"Gen. Journal Document Type"::Refund);
        CustLedgerEntry.SetFilter("Payment Method Code", CustLedgerEntryPaymentMethodFilter);
        if CustLedgerEntry.FindSet() then
            repeat
                CustLedgerEntry.CalcFields("Amount (LCY)");

                case CustLedgerEntry."Document Type" of
                    Enum::"Gen. Journal Document Type"::Payment:
                        begin
                            if CustLedgerEntry."Closed by Entry No." = 0 then begin
                                TransactionType := Enum::"TPV Daily Transaction Type"::"Order Charge";
                                DocumentNo := CustLedgerEntry."Payment Reference";

                                if SalesHeader.Get(Enum::"Sales Document Type"::Order, CustLedgerEntry."Payment Reference") then begin
                                    SalesHeader.CalcFields("Amount Including VAT");
                                    Amount := SalesHeader."Amount Including VAT";
                                end;

                            end else begin
                                CustLedgerEntry2.Get(CustLedgerEntry."Closed by Entry No.");

                                if CustLedgerEntry2."Posting Date" = CustLedgerEntry."Posting Date" then
                                    TransactionType := Enum::"TPV Daily Transaction Type"::"Invoice Charge"
                                else
                                    TransactionType := Enum::"TPV Daily Transaction Type"::"Older Invoice Charge";

                                DocumentNo := CustLedgerEntry2."Document No.";

                                if SalesInvoiceHeader.Get(CustLedgerEntry2."Document No.") then begin
                                    SalesHeader.CalcFields("Amount Including VAT");
                                    Amount := SalesHeader."Amount Including VAT";
                                end;
                            end;
                        end;
                    Enum::"Gen. Journal Document Type"::Refund:
                        begin
                            TransactionType := Enum::"TPV Daily Transaction Type"::Chargeback;
                            DocumentNo := CustLedgerEntry."Payment Reference";
                        end;
                end;

                tempTPVDailyCashReportBuffer.SetRange("Posting Date", CustLedgerEntry."Posting Date");
                tempTPVDailyCashReportBuffer.SetRange("Customer No.", CustLedgerEntry."Customer No.");
                tempTPVDailyCashReportBuffer.SetRange("Transaction Type", TransactionType);
                tempTPVDailyCashReportBuffer.SetRange("Document No.", DocumentNo);
                tempTPVDailyCashReportBuffer.SetRange("Payment Method", CustLedgerEntry."Payment Method Code");
                if not tempTPVDailyCashReportBuffer.FindFirst() then begin

                    // If there's already a line for that document but a different payment method ignore the value of the document
                    tempTPVDailyCashReportBuffer.SetRange("Payment Method");
                    if tempTPVDailyCashReportBuffer.FindFirst() then
                        Amount := 0;

                    EntryNo += 1;
                    tempTPVDailyCashReportBuffer.Init();
                    tempTPVDailyCashReportBuffer."No." := EntryNo;
                    tempTPVDailyCashReportBuffer."Posting Date" := CustLedgerEntry."Posting Date";
                    tempTPVDailyCashReportBuffer."Customer No." := CustLedgerEntry."Customer No.";
                    tempTPVDailyCashReportBuffer."Customer Name" := CustLedgerEntry."Customer Name";
                    tempTPVDailyCashReportBuffer."Payment Method" := CustLedgerEntry."Payment Method Code";
                    tempTPVDailyCashReportBuffer."Document No." := DocumentNo;
                    tempTPVDailyCashReportBuffer."Transaction Type" := TransactionType;
                    tempTPVDailyCashReportBuffer.Amount := Amount;
                    tempTPVDailyCashReportBuffer.Insert();
                end;

                tempTPVDailyCashReportBuffer."Paid Amount" += CustLedgerEntry."Amount (LCY)" * -1; // Payments are negative and refunds positive, we change it like this
                tempTPVDailyCashReportBuffer.Modify();

            until CustLedgerEntry.Next() = 0;
    end;
}