pageextension 50102 "Posted Sales Invoice Ext" extends "Posted Sales Invoice"
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
    actions
    {
        modify(Print)
        {

            trigger OnAfterAction()
            begin
                Report.Run(1306);
            end;

        }

        addafter(Print)
        {
            action(SalesInvoice)
            {
                Caption = 'Sales Invoice';
                Image = Print;
                ApplicationArea = all;
                RunObject = report "Standard Sales - Invoice";
            }
        }
    }
}
