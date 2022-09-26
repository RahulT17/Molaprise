codeunit 50102 "Dimensions & Pst Grps Update"
{
    procedure UpdateDimesions(var ItemNo: Code[20])
    var
        ItemUnitofMeasure: Record "Item Unit of Measure";
        recItem: Record Item;
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
    begin
        recItem.RESET;
        recItem.SetRange("No.", ItemNo);
        if recItem.FindFirst() then begin

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

        end;
    end;


    procedure UpdatePostingGrps(var ItemNo: Code[20])
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
        ItemUnitofMeasure: Record "Item Unit of Measure";
        recItem: Record Item;
    begin
        recItem.Reset();
        recItem.SetRange("No.", ItemNo);
        if recItem.FindFirst() then begin

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

        end;
    end;
}