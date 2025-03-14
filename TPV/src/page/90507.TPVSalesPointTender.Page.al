page 90507 "TPV Sales Point - Tender"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "TPV Sales Point - Tender";

    layout
    {
        area(Content)
        {
            repeater(SalesPointTender)
            {
                field("Sales Point Code"; Rec."Sales Point Code")
                {
                    Visible = false;
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ToolTip = 'Specifies the value of the Currency Code field.', Comment = '%';
                }
                field("Tender Code"; Rec."Tender Code")
                {
                    ToolTip = 'Specifies the value of the Tender Code field.', Comment = '%ESP="Código Moneda"';
                }
                field("Tender Type"; Rec."Tender Type")
                {
                    ToolTip = 'Specifies the value of the Tender Type field.', Comment = '%ESP="Tipo Moneda"';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(LCYTenderCodes)
            {
                Caption = 'Use local currency', Comment = 'ESP="Usar divisa local"';
                ApplicationArea = All;

                trigger OnAction()
                var
                    GeneralLedgerSetup: Record "General Ledger Setup";
                    TPVCurrencyTender: Record "TPV Currency-Tender";
                    TPVSalesPointTender: Record "TPV Sales Point - Tender";
                    PageSalesPointFilter: Text;
                begin
                    PageSalesPointFilter := Rec.GetFilter("Sales Point Code");
                    if PageSalesPointFilter = '' then
                        exit;
                    GeneralLedgerSetup.Get();
                    TPVCurrencyTender.SetRange("Currency Code", GeneralLedgerSetup.GetCurrencyCode(''));
                    if TPVCurrencyTender.FindSet() then
                        repeat
                            TPVSalesPointTender.Init();
                            TPVSalesPointTender.Validate("Sales Point Code", PageSalesPointFilter);
                            TPVSalesPointTender.Validate("Currency Code", TPVCurrencyTender."Currency Code");
                            TPVSalesPointTender.Validate("Tender Type", TPVCurrencyTender."Tender Type");
                            TPVSalesPointTender.Validate("Tender Code", TPVCurrencyTender."Tender Code");
                            TPVSalesPointTender.Insert(true);
                        until TPVCurrencyTender.Next() = 0;
                end;
            }
        }
    }
}