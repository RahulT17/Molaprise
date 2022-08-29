pageextension 50115 PostedPurchaseInvoicesList extends "Posted Purchase Invoices"
{
    layout
    {
        addafter("Currency Code")
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
