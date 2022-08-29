pageextension 50104 "Sales Order List Ext" extends "Sales Order List"
{
    layout
    {
        addafter("External Document No.")
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
