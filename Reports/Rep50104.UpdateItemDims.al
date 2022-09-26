report 50104 "Update Item Dimensions"
{
    ApplicationArea = All;
    Caption = 'Update Item Dimensions';
    UsageCategory = ReportsAndAnalysis;
    Permissions = tabledata 27 = rm;
    ProcessingOnly = true;
    dataset
    {
        dataitem(Integer; "Integer")
        {
            DataItemTableView = where(Number = const(1));

            trigger OnAfterGetRecord()
            var
                ItemUnitofMeasure: Record "Item Unit of Measure";
                recItem: Record Item;
            begin
                recItem.RESET;
                if recItem.FindSet() then begin
                    repeat
                        Codeunit.Run(Codeunit::"CRM Integration Management");
                        recCRMProduct.Reset();
                        recCRMProduct.SetRange(Name, recItem.Description);
                        IF recItem."Dimension Value" <> '00000000-0000-0000-0000-000000000000' then begin
                            IF recCRMProduct.FindFirst() AND (recItem."Dimension Value" <> recCRMProduct.Manufacturer) AND (recItem."Dimension Value" <> '00000000-0000-0000-0000-000000000000') AND (recCRMProduct.Manufacturer <> '00000000-0000-0000-0000-000000000000') then begin
                                recItem."Dimension Value" := recCRMProduct.Manufacturer;
                                recItem.Modify()
                            end;
                        end;

                        ManufactGUID := '00000000-0000-0000-0000-000000000000';
                        IF recCRMProduct.FindFirst() then
                            ManufactGUID := recCRMProduct.Manufacturer;

                        If (recItem."Dimension Value" <> '00000000-0000-0000-0000-000000000000') OR (ManufactGUID <> '00000000-0000-0000-0000-000000000000') then begin
                            recDefaultDim.Reset();
                            recDefaultDim.SetRange("Table ID", 27);
                            recDefaultDim.SetRange("No.", recItem."No.");
                            recDefaultDim.SetRange("Dimension Code", 'MANUFACTURER');

                            DimensionValue := '';


                            recCrmdimensionValues.Reset();
                            IF ManufactGUID <> '00000000-0000-0000-0000-000000000000' then
                                recCrmdimensionValues.SetRange(AccountId, ManufactGUID)
                            else
                                recCrmdimensionValues.SetRange(AccountId, recItem."Dimension Value");
                            IF recCrmdimensionValues.FindFirst() then
                                If Strlen(recCrmdimensionValues.Name) > 20 then
                                    DimensionValue := PADSTR(recCrmdimensionValues.Name, 20)
                                else
                                    DimensionValue := recCrmdimensionValues.Name;

                            HasDimension := false;

                            If recDefaultDim.FindSet() then
                                repeat
                                    If (recDefaultDim."Dimension Value Code" = DimensionValue) and (DimensionValue <> '') then
                                        HasDimension := true;
                                until recDefaultDim.Next() = 0;

                            recDefaultDim.Reset();
                            recDefaultDim.SetRange("Table ID", 27);
                            recDefaultDim.SetRange("No.", recItem."No.");
                            recDefaultDim.SetRange("Dimension Code", 'MANUFACTURER');


                            IF (HasDimension = false) AND (DimensionValue <> recDefaultDim."Dimension Value Code") AND (DimensionValue <> '') AND (recCrmdimensionValues.name <> '') AND (recItem."Dimension Value" <> '00000000-0000-0000-0000-000000000000') then begin
                                recDefaultDim."Dimension Value Code" := DimensionValue;
                                recDefaultDim.Modify()
                            end
                            else
                                If HasDimension = false then begin
                                    If (recDefaultDim."Dimension Code" <> '') AND (recDefaultDim."Dimension Value Code" <> '') then begin
                                        recDefaultDim."Dimension Value Code" := DimensionValue;
                                        recDefaultDim.Modify();
                                    end
                                    else
                                        if (recDefaultDim."Dimension Code" <> '') AND (recDefaultDim."Dimension Value Code" = '') then begin
                                            recDefaultDim."Dimension Value Code" := DimensionValue;
                                            recDefaultDim.Modify();
                                        end
                                        else begin

                                            recDefaultDim.Reset();
                                            recDefaultDim.Init();
                                            recDefaultDim."Table ID" := 27;
                                            recDefaultDim."No." := recItem."No.";
                                            recDefaultDim."Dimension Code" := 'MANUFACTURER';
                                            recDefaultDim."Dimension Value Code" := DimensionValue;
                                            recDefaultDim.Insert()
                                        end;
                                end;
                        end;

                    until recItem.Next = 0;
                end;
                //UpdateDimensionValues();


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
    // procedure UpdateDimensionValues()
    // var
    //     DimVals: Record "CRM Account";
    //     CRMIntegrationManagement: Codeunit "CRM Integration Management";
    //     DimensionValue: Record 349;
    //     recDimensionValue: Record 349;
    //     DimName: Code[50];
    // begin
    //     DimVals.Reset();
    //     DimVals.SetRange(CustomerTypeCode, DimVals.CustomerTypeCode::Press);
    //     IF DimVals.FindSet() then
    //         repeat
    //         begin
    //             Clear(DimName);
    //             recDimensionValue.Reset();
    //             recDimensionValue.SetRange("Dimension Code", 'MANUFACTURER');
    //             DimName := dimvals.Name;
    //             recDimensionValue.SetRange("Code", DimName);
    //             if recDimensionValue.FindFirst() then begin
    //                 //Error('Already exists');
    //             end
    //             else begin
    //                 DimensionValue.Init();
    //                 DimensionValue."Dimension Code" := 'MANUFACTURER';
    //                 DimensionValue.Code := DimVals.Name;
    //                 DimensionValue.Name := DimVals.Name;
    //                 DimensionValue.Insert(true);
    //             end;
    //         end;
    //         until DimVals.Next() = 0;
    //     CRMIntegrationManagement.CreateNewRecordsFromCRM(DimVals);
    // end;
    var
        recDefaultDim: Record "Default Dimension";
        recCrmdimensionValues: Record "CRM Dimension Values";

        DimensionValue: Code[20];
        HasDimension: Boolean;
        recCRMGenProdPostGrp: Record "CRM Gen Prod Posting Grp Ext";

        recCRMProduct: Record "CRM Product";
        PostingGrp: Guid;
        recGenProdPostGrp: Record "Gen. Product Posting Group";

        GenProdPostGrp: Guid;
        ManufactGUID: Guid;
}
