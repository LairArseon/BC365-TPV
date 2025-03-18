pageextension 90503 "TPV User Setup" extends "User Setup"
{
    layout
    {
        addbefore("Sales Resp. Ctr. Filter")
        {
            field("TPV Resp. Center Filter"; Rec."TPV Resp. Center Filter")
            {
                ApplicationArea = All;
            }
        }
    }
}