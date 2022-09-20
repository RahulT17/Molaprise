report 50101 "MANUFACTURERIntegration"
{
    ApplicationArea = All;
    Caption = 'Manufacturer Integration';
    UsageCategory = ReportsAndAnalysis;
    Permissions = tabledata 349 = rm;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; "Integer")
        {
            DataItemTableView = where(Number = const(1));
            trigger OnAfterGetRecord()
            begin
                UpdateDimensionValues
            end;
        }


    }

    procedure UpdateDimensionValues()
    var
        DimVals: Record "CRM Dimension Values";
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        DimensionValue: Record 349;
        recDimensionValue: Record 349;
        DimName: Code[50];
    begin
        DimVals.Reset();
        DimVals.SetRange(CustomerTypeCode, DimVals.CustomerTypeCode::Press);
        IF DimVals.FindSet() then
            repeat
            begin
                Clear(DimName);
                recDimensionValue.Reset();
                recDimensionValue.SetRange("Dimension Code", 'MANUFACTURER');
                DimName := dimvals.Name;
                recDimensionValue.SetRange("Code", DimName);
                if recDimensionValue.FindFirst() then begin
                    //Error('Already exists');
                end
                else begin
                    DimensionValue.Init();
                    DimensionValue."Dimension Code" := 'MANUFACTURER';
                    DimensionValue.Code := DimVals.Name;
                    DimensionValue.Name := DimVals.Name;
                    DimensionValue.Insert(true);
                end;
            end;
            until DimVals.Next() = 0;
        CRMIntegrationManagement.CreateNewRecordsFromCRM(DimVals);
    end;
}

