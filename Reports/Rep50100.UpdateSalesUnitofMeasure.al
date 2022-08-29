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

                        If recItem.Type = recItem.Type::"Non-Inventory" then begin
                            recItem."Gen. Prod. Posting Group" := 'NO TAX';
                            recItem."Tax Group Code" := 'NONTAXABLE';
                            recItem.Modify()
                        end;

                        If recItem.Type = recItem.Type::Inventory then begin
                            recItem."Gen. Prod. Posting Group" := 'RETAIL';
                            recItem."Tax Group Code" := 'TAXABLE';
                            recItem."Inventory Posting Group" := 'RESALE';
                            recItem.Modify()
                        end;

                        If recItem.Type = recItem.Type::Service then begin
                            recItem."Gen. Prod. Posting Group" := 'SERVICES';
                            recItem."Tax Group Code" := 'NONTAXABLE';
                            recItem.Modify()
                        end;

                    // if recItem."Unit Price" = 0.00 then begin
                    //     recItem."Unit Price" := recItem."Unit Cost";
                    //     recItem.Modify()
                    // end;

                    until recItem.Next = 0;
                end;
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
