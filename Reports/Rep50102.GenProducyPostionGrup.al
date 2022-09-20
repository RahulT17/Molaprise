report 50102 "Gen Producy Postion Grup"
{
    Caption = 'Gen Product Posting Group';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Integer; "Integer")

        {
            DataItemTableView = where(Number = const(1));
            trigger OnAfterGetRecord()
            var
                CDSGenProd: Record "CRM Gen Prod Posting Grp Ext";
                CRMIntegrationManagement: Codeunit "CRM Integration Management";
            begin
                Codeunit.Run(Codeunit::"CRM Integration Management");
                CDSGenProd.RESET;
                if CDSGenProd.FindSet() then
                    repeat
                    //CRMIntegrationManagement.CreateNewRecordsFromCRM(CDSGenProd);
                    // refer to 50101
                    until CDSGenProd.Next() = 0;
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}
