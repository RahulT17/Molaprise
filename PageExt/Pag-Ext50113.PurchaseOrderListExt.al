pageextension 50113 "Purchase Order List Ext" extends "Purchase Order List"
{
    layout
    {
        addafter("Vendor Authorization No.")
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
