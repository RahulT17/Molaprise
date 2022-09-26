report 50100 "Update Sales Unit of Measure"
{
    ApplicationArea = All;
    Caption = 'Update sales unit of measure';
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
                        IF recItem."Sales Unit of Measure" = '' then begin
                            ItemUnitofMeasure.Reset();
                            ItemUnitofMeasure.SetRange("Item No.", recItem."No.");
                            ItemUnitofMeasure.SetRange(Code, recItem."Base Unit of Measure");
                            IF not ItemUnitofMeasure.findset then begin
                                ItemUnitofMeasure.Reset();
                                ItemUnitOfMeasure.Init();
                                ItemUnitOfMeasure.Validate(Code, recItem."Base Unit of Measure");
                                ItemUnitOfMeasure.Validate("Item No.", recItem."No.");
                                ItemUnitOfMeasure.Validate("Qty. per Unit of Measure", 1);

                                ItemUnitOfMeasure.Insert(true);
                            end;

                            ItemUnitofMeasure.RESET;
                            ItemUnitofMeasure.SetRange("Item No.", recItem."No.");
                            ItemUnitofMeasure.SetRange(Code, recItem."Base Unit of Measure");
                            if ItemUnitofMeasure.FindSet() then begin
                                recItem."Sales Unit of Measure" := recItem."Base Unit of Measure";
                                recItem.Modify()
                            end;
                        end;

                        if recItem."Last Direct Cost" <> recItem."Unit Cost" then begin
                            recItem."Last Direct Cost" := recItem."Unit Cost";
                            recItem.Modify()
                        end;

                    // If recItem.Type = recItem.Type::"Non-Inventory" then begin
                    //     recItem."Gen. Prod. Posting Group" := 'NO TAX';
                    //     recItem."Tax Group Code" := 'NONTAXABLE';
                    //     recItem.Modify()
                    // end;

                    // If recItem.Type = recItem.Type::Inventory then begin
                    //     recItem."Gen. Prod. Posting Group" := 'RETAIL';
                    //     recItem."Tax Group Code" := 'TAXABLE';
                    //     recItem."Inventory Posting Group" := 'RESALE';
                    //     recItem.Modify()
                    // end;

                    // If recItem.Type = recItem.Type::Service then begin
                    //     recItem."Gen. Prod. Posting Group" := 'SERVICES';
                    //     recItem."Tax Group Code" := 'NONTAXABLE';
                    //     recItem.Modify()
                    // end;

                    // if recItem."Unit Price" = 0.00 then begin
                    //     recItem."Unit Price" := recItem."Unit Cost";
                    //     recItem.Modify()
                    // end;

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
