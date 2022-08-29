pageextension 50103 "Posted Sales Credit Memo Ext" extends "Posted Sales Credit Memo"
{
    layout
    {
        addafter("Your Reference")
        {
            field("Deal Name"; "Deal Name")
            {
                ApplicationArea = All;
            }
            field("Service Period"; "Service Period")
            {
                ApplicationArea = All;
            }
            field("Remark 1"; "Remark 1")
            {
                ApplicationArea = All;
            }
            field("Remark 2"; "Remark 2")
            {
                ApplicationArea = All;
            }
        }
    }
}
