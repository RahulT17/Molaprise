codeunit 50101 "Update Dimension"
{
    trigger OnRun()
    begin
        UpdateDimensionValues;
    end;

    procedure UpdateDimensionValues()
    var
        DimVals: Record "CRM Dimension Values";
        // CRMIntegrationManagement: Codeunit "CRM Integration Management";
        DimensionValue: Record 349;
        recDimensionValue: Record 349;
        DimName: Code[20];
    begin
        Codeunit.Run(Codeunit::"CRM Integration Management");
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
