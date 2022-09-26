reportextension 50100 "Standard Sales - Invoice Ext" extends "Standard Sales - Invoice"
{
    WordLayout = './Layouts/Standard_Sales_Invoice.docx';

    dataset
    {
        add(Header)
        {
            column(External_Document_No_; "External Document No.")
            {

            }
            column(Service_Period; "Service Period")
            {

            }
            column(ExternalLable; ExternalLable)
            {

            }
            column(ServiceLable; ServiceLable)
            {

            }
        }
    }
    var
        ExternalLable: Label 'External Document No.';
        ServiceLable: Label 'Service Period';
}
