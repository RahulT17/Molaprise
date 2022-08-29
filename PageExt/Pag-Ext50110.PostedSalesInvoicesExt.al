pageextension 50110 "Posted Sales Invoices Ext" extends "Posted Sales Invoices"
{
    layout
    {
        addafter("Sell-to Customer Name")
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
