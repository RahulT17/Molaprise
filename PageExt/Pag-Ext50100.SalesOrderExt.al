pageextension 50100 "Sales Order Ext" extends "Sales Order"
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
            field("Purchase Order No."; "Purchase Order No.")
            {
                ApplicationArea = All;
            }
            field("Vendor No."; "Vendor No.")
            {
                ApplicationArea = All;

                trigger OnValidate()
                begin
                    if Vendor_Rec.get(Rec."Vendor No.") then
                        "Vendor Name" := Vendor_Rec.Name;
                end;

            }
            field("Vendor Name"; "Vendor Name")
            {
                ApplicationArea = All;
                Editable = false;

            }

        }
    }

    var

        Vendor_Rec: Record Vendor;
}
