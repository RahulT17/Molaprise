pageextension 50101 "CRM Sales Order List Ext" extends "CRM Sales Order List"
{
    actions
    {
        modify(CreateInNAV)
        {
            trigger OnBeforeAction()
            var
                CodeUnitUpdateDimsGrps: Codeunit "Dimensions & Pst Grps Update";
                CRMSalesOrderDetails: Record "CRM Salesorderdetail";
                recCRMProduct: Record "CRM Product";
                ProductNo: Code[100];
            begin
                CRMSalesOrderDetails.SetRange(CRMSalesOrderDetails.SalesOrderId, Rec.SalesOrderId);
                IF CRMSalesOrderDetails.FindSet() then
                    repeat
                    begin
                        recCRMProduct.Reset();
                        recCRMProduct.SetRange(ProductId, CRMSalesOrderDetails.ProductId);
                        Clear(ProductNo);
                        IF recCRMProduct.FindFirst() then begin
                            ProductNo := recCRMProduct.ProductNumber;
                            If StrLen(ProductNo) <= 20 then begin
                                CodeUnitUpdateDimsGrps.UpdateDimesions(ProductNo);
                                CodeUnitUpdateDimsGrps.UpdatePostingGrps(ProductNo);
                                //Message(ProductNo);
                            end;
                        end;
                    end;
                    until CRMSalesOrderDetails.Next() = 0;
            end;
        }
    }
}
