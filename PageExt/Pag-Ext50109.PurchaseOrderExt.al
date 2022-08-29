pageextension 50109 "Purchase Order Ext" extends "Purchase Order"
{
    layout
    {
        addafter("Vendor Shipment No.")
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
