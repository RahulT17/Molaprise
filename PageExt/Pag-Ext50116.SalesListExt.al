pageextension 50116 "Sales List Ext" extends "Sales List"
{
    layout
    {
        addafter("External Document No.")
        {
            field("Deal Name"; "Deal Name")
            {
                ApplicationArea = All;
            }
        }
    }
}
