report 50103 "Update Item Posting Groups"
{
    ApplicationArea = All;
    Caption = 'Update Item Posting Groups';
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
                //recItem.SetRange("No.", '8PW-00017');
                if recItem.FindSet() then begin
                    repeat
                        Codeunit.Run(Codeunit::"CRM Integration Management");
                        recCRMProduct.Reset();
                        recCRMProduct.SetRange(Name, recItem.Description);
                        PostingGrp := '00000000-0000-0000-0000-000000000000';

                        If recCRMProduct.FindFirst() then
                            PostingGrp := recCRMProduct.Posting_Group;

                        recGenProdPostGrp.Reset();
                        recGenProdPostGrp.SetRange(Code, recItem."Gen. Prod. Posting Group");
                        GenProdPostGrp := '00000000-0000-0000-0000-000000000000';
                        if recGenProdPostGrp.FindFirst() then
                            GenProdPostGrp := recGenProdPostGrp."Parent Item";

                        If (GenProdPostGrp <> PostingGrp) AND (not ((GenProdPostGrp <> '00000000-0000-0000-0000-000000000000') and (PostingGrp = '00000000-0000-0000-0000-000000000000'))) then begin
                            // recCRMGenProdPostGrp.Reset();
                            // recCRMGenProdPostGrp.SetRange(sgit_productcategoryid, recItem.Posting_Group);

                            // If recCRMGenProdPostGrp.FindFirst() then
                            //     recItem."Gen. Prod. Posting Group" := recCRMGenProdPostGrp.Code;

                            recGenProdPostGrp.Reset();

                            //recGenProdPostGrp.SetRange("Parent Item", PostingGrp);
                            recGenProdPostGrp.SetFilter("Parent Item", '%1', PostingGrp);
                            If recGenProdPostGrp.FindFirst() then begin
                                recItem."Gen. Prod. Posting Group" := recGenProdPostGrp.Code;
                                recItem.Modify()
                            end;

                            // IF recCRMProduct.Posting_Group <> '00000000-0000-0000-0000-000000000000' then begin
                            //     GenPostingGroup.SetRange("Parent Item", recCRMProduct.Posting_Group);
                            //     IF GenPostingGroup.FindFirst() then
                            //         Item."Gen. Prod. Posting Group" := GenPostingGroup.Code;
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
