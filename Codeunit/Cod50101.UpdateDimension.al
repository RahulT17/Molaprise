codeunit 50101 "Update Dimension"
{
    trigger OnRun()
    begin
        UpdateDimensionValues;
        //UpdateGenProdGrps;
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

    // procedure UpdateGenProdGrps()
    // var
    //     CDSGenProd: Record 50101;
    //     //CRMIntegrationManagement: Codeunit "CRM Integration Management";
    //     recGenProdPostGrp: Record "Gen. Product Posting Group";
    // begin
    //     Codeunit.Run(Codeunit::"CRM Integration Management");
    //     CDSGenProd.RESET;
    //     if CDSGenProd.FindSet() then
    //         repeat
    //             recGenProdPostGrp.Reset();
    //             recGenProdPostGrp.SetRange(Code, CDSGenProd.Code);
    //             If recGenProdPostGrp.FindFirst() then begin
    //                 //Error('Already exists!');
    //             end
    //             else begin
    //                 recGenProdPostGrp.Init();
    //                 recGenProdPostGrp.Code := CDSGenProd.Code;
    //                 recGenProdPostGrp."Parent Item" := CDSGenProd.sgit_productcategoryid;
    //                 recGenProdPostGrp.Insert(true);
    //             end;

    //         until CDSGenProd.Next() = 0;
    // end;

    // procedure onAfterDimsInsert(var ItemNo: Code[20])
    // begin
    //     Codeunit.Run(Codeunit::"CRM Integration Management");
    //     recItem.SetRange("No.", ItemNo);
    //     If recItem.FindFirst() then begin
    //         If recItem."Dimension Value" <> '00000000-0000-0000-0000-000000000000' then begin
    //             recDefaultDim.Reset();
    //             recDefaultDim.SetRange("Table ID", 27);
    //             recDefaultDim.SetRange("No.", recItem."No.");
    //             recDefaultDim.SetRange("Dimension Code", 'MANUFACTURER');

    //             DimensionValue := '';


    //             recCrmdimensionValues.Reset();
    //             recCrmdimensionValues.SetRange(AccountId, recItem."Dimension Value");
    //             IF recCrmdimensionValues.FindFirst() then
    //                 If Strlen(recCrmdimensionValues.Name) > 20 then
    //                     DimensionValue := PADSTR(recCrmdimensionValues.Name, 20)
    //                 else
    //                     DimensionValue := recCrmdimensionValues.Name;

    //             HasDimension := false;

    //             If recDefaultDim.FindSet() then
    //                 repeat
    //                     If (recDefaultDim."Dimension Value Code" = DimensionValue) and (DimensionValue <> '') then
    //                         HasDimension := true;
    //                 until recDefaultDim.Next() = 0;

    //             If HasDimension = false then begin
    //                 recDefaultDim.Reset();
    //                 recDefaultDim.Init();
    //                 recDefaultDim."Table ID" := 27;
    //                 recDefaultDim."No." := recItem."No.";
    //                 recDefaultDim."Dimension Code" := 'MANUFACTURER';
    //                 recDefaultDim."Dimension Value Code" := DimensionValue;
    //                 recDefaultDim.Insert()
    //             end;
    //         end;
    //     end;

    //     //     If recItem.Posting_Group <> '00000000-0000-0000-0000-000000000000' then begin
    //     //         recCRMGenProdPostGrp.Reset();
    //     //         recCRMGenProdPostGrp.SetRange(sgit_productcategoryid, recItem.Posting_Group);

    //     //         If recCRMGenProdPostGrp.FindFirst() then
    //     //             recItem."Gen. Prod. Posting Group" := recCRMGenProdPostGrp.Code;
    //     //     end;
    //     // end;
    // end;

    var
        recDefaultDim: Record "Default Dimension";
        //recCrmdimensionValues: Record "CRM Dimension Values";

        DimensionValue: Code[20];
        HasDimension: Boolean;
        recItem: Record Item;

    //recCRMGenProdPostGrp: Record "CRM Gen Prod Posting Grp Ext";
}
