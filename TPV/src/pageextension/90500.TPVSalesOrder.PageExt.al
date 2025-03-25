pageextension 90500 "TPV Sales Order" extends "Sales Order"
{
    layout
    {
        addafter("Work Description")
        {
            field("Paid Amount"; Rec.CalculatePaidAmount())
            {
                ApplicationArea = All;
            }
            field("Shipping No."; Rec."Shipping No.")
            {
                ApplicationArea = All;
            }
            field("Posting No."; Rec."Posting No.")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter("Archive Document_Promoted")
        {
            actionref(OpenBCTPV_Ref; OpenBCTPV) { }
        }

        addlast("O&rder")
        {
            action(OpenTPV)
            {
                Caption = 'Open TPV', Comment = 'ESP="Abrir TPV"';
                ApplicationArea = All;
                Image = AmountByPeriod;
                Visible = false;

                trigger OnAction()
                var
                    TPVPaymentLineBuffer: Record "TPV Payment Line Buffer";
                    TPVDataManagement: Codeunit "TPV Data Management";
                    SalesLine: Record "Sales Line";
                    PaymentOrder, OrderLine : JsonObject;
                    OrderLines: JsonArray;
                    RecRef: RecordRef;
                begin
                    TPVPaymentLineBuffer.CreateLineFromSalesHeader(Rec);
                    TPVPaymentLineBuffer.Serialize(PaymentOrder);

                    SalesLine.SetRange("Document Type", Rec."Document Type");
                    SalesLine.SetRange("Document No.", Rec."No.");
                    if SalesLine.FindSet() then
                        repeat
                            Clear(OrderLine);
                            SalesLine.Serialize(OrderLine);
                            OrderLines.Add(OrderLine);
                        until SalesLine.Next() = 0;

                    TPVDataManagement.AddLines(PaymentOrder, OrderLines);

                    Page.Run(Page::"TPV Payment Display", TPVPaymentLineBuffer)
                end;
            }
            action(OpenBCTPV)
            {
                Caption = 'Post Payment', Comment = 'ESP="Registrar Pago"';
                ApplicationArea = All;
                Image = AmountByPeriod;
                Visible = ShowTPV;

                trigger OnAction()
                var
                    TPVPaymentLineBuffer: Record "TPV Payment Line Buffer";
                begin
                    TPVPaymentLineBuffer.CreateLineFromSalesHeader(Rec);

                    Page.Run(Page::"TPV BC Payment", TPVPaymentLineBuffer)
                end;
            }
        }
    }

    trigger OnOpenPage()
    var
        TPVSetup: Record "TPV Setup";
    begin
        TPVSetup.Get();
        ShowTPV := TPVSetup.Active;
    end;

    var
        ShowTPV: Boolean;
}