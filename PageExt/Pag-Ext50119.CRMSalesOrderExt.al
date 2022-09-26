pageextension 50119 "CRM Sales Order Ext" extends "CRM Sales Order"
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
    procedure UpdateDimensionValues()
    var
        DimVals: Record "CRM Dimension Values";
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        DimensionValue: Record 349;
        recDimensionValue: Record 349;
        DimName: Code[20];
    begin
        DimVals.Reset();
        DimVals.SetRange(CustomerTypeCode, DimVals.CustomerTypeCode::Press);
        IF DimVals.FindSet() then
            repeat
            begin
                Clear(DimName);
                recDimensionValue.Reset();
                recDimensionValue.SetRange("Dimension Code", 'MANUFACTURER');
                If Strlen(dimvals.Name) > 20 then
                    DimName := PADSTR(DimVals.Name, 20)
                else
                    DimName := DimVals.Name;

                recDimensionValue.SetRange("Code", DimName);

                if recDimensionValue.FindFirst() then begin
                    //Error('Already exists');
                end
                else begin
                    DimensionValue.Init();
                    DimensionValue."Dimension Code" := 'MANUFACTURER';
                    If StrLen(DimVals.Name) > 20 then
                        DimensionValue.Code := PADSTR(DimVals.Name, 20)
                    else
                        DimensionValue.Code := DimVals.Name;

                    If StrLen(DimVals.Name) > 50 then
                        DimensionValue.Name := PADSTR(DimVals.Name, 50)
                    else
                        DimensionValue.Name := DimVals.Name;
                    DimensionValue.Insert(true);
                end;
            end;
            until DimVals.Next() = 0;
    end;
}
