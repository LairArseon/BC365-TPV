pageextension 90504 "TPV Customer Ledger Entries" extends "Customer Ledger Entries"
{
    layout
    {
        addafter(Description)
        {
            field("Payment Reference"; Rec."Payment Reference")
            {
                ApplicationArea = All;
            }
        }
    }
}