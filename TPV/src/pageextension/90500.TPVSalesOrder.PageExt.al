pageextension 90500 "TPV Sales Order" extends "Sales Order"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addlast("O&rder")
        {
            action(OpenTPV)
            {
                Caption = 'Open TPV', Comment = 'ESP="Abrir TPV"';
                ApplicationArea = All;
                Image = AmountByPeriod;
                Visible = ShowTPV;

                trigger OnAction()
                var
                    tempTPVBuffer: Record "TPV Line Buffer" temporary;
                    SalesLine: Record "Sales Line";
                    RecRef: RecordRef;
                begin
                    SalesLine.SetRange("Document Type", Rec."Document Type");
                    SalesLine.SetRange("Document No.", Rec."No.");
                    if SalesLine.FindSet() then
                        repeat
                            RecRef.Get(SalesLine.RecordId);
                            tempTPVBuffer.InsertLine(RecRef);
                            Page.Run(Page::"TPV Payment Display", tempTPVBuffer);

                        until SalesLine.Next() = 0;
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