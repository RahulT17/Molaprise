codeunit 50100 "Insert Integration Mapping"
{
    trigger OnRun()
    begin
        //DeleteMappings();
        //SalesSetup()
    end;

    procedure DeleteMappings()
    begin


        // IntegrationFieldMapping.RESET;
        // IntegrationFieldMapping.SetRange("No.", 2055);
        // if IntegrationFieldMapping.FindSet() then
        //     IntegrationFieldMapping.DeleteAll();

        // IntegrationFieldMapping.RESET;
        // IntegrationFieldMapping.SetRange("No.", 1712);
        // if IntegrationFieldMapping.FindSet() then
        //     IntegrationFieldMapping.DeleteAll();
        // IntegrationFieldMapping.RESET;
        // IntegrationFieldMapping.SetRange("No.", 1660);
        // if IntegrationFieldMapping.FindSet() then
        //     IntegrationFieldMapping.DeleteAll();

        //Message('Deleted unwanted couplings!');
    end;

    procedure SalesSetup()
    begin
        // InsertIntegrationFieldMapping('ITEM-PRODUCT',
        //   recItem.FieldNo(Type), CDSProduct.FieldNo(Type),
        //   IntegrationFieldMapping.Direction::Bidirectional, '', true, false);
        // InsertIntegrationFieldMapping('ITEM-PRODUCT',
        //     recItem.FieldNo("Last Direct Cost"), CDSProduct.FieldNo(StandardCost),
        //     IntegrationFieldMapping.Direction::Bidirectional, '', true, false);

        // InsertIntegrationFieldMapping('SALESORDER-ORDER',
        // SalesOrder.FieldNo("External Document No."), CDSSalesOrder.FieldNo("External Document No."),
        // IntegrationFieldMapping.Direction::Bidirectional, '', true, false);

        // InsertIntegrationFieldMapping('SALESORDER-ORDER',
        // SalesOrder.FieldNo("Deal Name"), CDSSalesOrder.FieldNo("Deal Name"),
        // IntegrationFieldMapping.Direction::Bidirectional, '', true, false);

        // InsertIntegrationFieldMapping('SALESORDER-ORDER',
        // SalesOrder.FieldNo("Service Period"), CDSSalesOrder.FieldNo("Service Period"),
        // IntegrationFieldMapping.Direction::Bidirectional, '', true, false);
    end;

    procedure InsertIntegrationFieldMapping(IntegrationTableMappingName: Code[20]; TableFieldNo: Integer; IntegrationTableFieldNo: Integer; SynchDirection: Option; ConstValue: Text; ValidateField: Boolean; ValidateIntegrationTableField: Boolean)
    var
        IntegrationFieldMapping: Record "Integration Field Mapping";
    begin
        IntegrationFieldMapping.CreateRecord(IntegrationTableMappingName, TableFieldNo, IntegrationTableFieldNo, SynchDirection,
            ConstValue, ValidateField, ValidateIntegrationTableField);
        Message('Congrats!Mapping added...');
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CRM Sales Order to Sales Order", 'OnCreateSalesOrderHeaderOnBeforeSalesHeaderInsert', '', true, true)]
    local procedure OnSOHeaderOnBeforeSHeaderIns2(var SalesHeader: Record "Sales Header";
    CRMSalesorder: Record "CRM Salesorder");
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.get();
        SalesHeader."Service Period" := CRMSalesorder."Service Period";
        SalesHeader."Deal Name" := CRMSalesorder."Deal Name";
        SalesHeader."External Document No." := CRMSalesorder."External Document No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Integration Rec. Synch. Invoke", 'OnAfterInsertRecord', '', false, false)]
    procedure OnAfterInsertRecord(var SourceRecordRef: RecordRef; var DestinationRecordRef: RecordRef)
    var
        CRMConnectionSetup: Record "CRM Connection Setup";
        CRMSalesorder: Record "CRM Salesorder";
        SalesHeader: Record "Sales Header";
        SourceDestCode: Text;
    begin
        SourceDestCode := GetSourceDestCode(SourceRecordRef, DestinationRecordRef);
        case SourceDestCode of
            'CRM Product-Item':
                begin
                    CreteItemUnitOfMeasureAndAssignSalesUnitOfMeasure(DestinationRecordRef);
                end;
        end;
    end;

    local procedure CreteItemUnitOfMeasureAndAssignSalesUnitOfMeasure(var DestinationRecordRef: RecordRef)
    var
        Item: Record Item;
        ItemUnitOfMeasure: Record "Item Unit of Measure";
    begin
        DestinationRecordRef.SetTable(Item);
        ItemUnitOfMeasure.Init();
        ItemUnitOfMeasure.Validate(Code, Item."Base Unit of Measure");
        ItemUnitOfMeasure.Validate("Item No.", Item."No.");
        ItemUnitOfMeasure.Validate("Qty. per Unit of Measure", 1);
        ItemUnitOfMeasure.Insert(true);
        Item.Get(Item.RecordId);
        Item.Validate("Sales Unit of Measure", ItemUnitOfMeasure.Code);
        Item.Modify(true);
        DestinationRecordRef.GetTable(Item);
    end;

    local procedure GetSourceDestCode(SourceRecordRef: RecordRef; DestinationRecordRef: RecordRef): Text
    var
        SourceDestCodePatternTxt: Label '%1-%2', Locked = true;
    begin
        if (SourceRecordRef.Number() <> 0) and (DestinationRecordRef.Number() <> 0) then
            exit(StrSubstNo(SourceDestCodePatternTxt, SourceRecordRef.Name(), DestinationRecordRef.Name()));
        exit('');
    end;

    [EventSubscriber(ObjectType::Table, DATABASE::"Purchase Header", 'OnAfterAddShipToAddress', '', true, true)]
    local procedure CopyFieldFromSalesOrdToPurchOrd(var PurchaseHeader: Record "Purchase Header"; SalesHeader: Record "Sales Header"; ShowError: Boolean)
    Var
        PurchLine2: Record "Purchase Line";
    begin
        if ShowError then begin
            PurchLine2.Reset();
            PurchLine2.SetRange("Document Type", PurchaseHeader."Document Type"::Order);
            PurchLine2.SetRange("Document No.", PurchaseHeader."No.");
            if not PurchLine2.IsEmpty() then begin
                if PurchaseHeader."Deal Name" <> SalesHeader."Deal Name" then
                    Error(Text052, PurchaseHeader.FieldCaption("Deal Name"), PurchaseHeader."No.", SalesHeader."No.");
                if PurchaseHeader."Remark 1" <> SalesHeader."Remark 1" then
                    Error(Text052, PurchaseHeader.FieldCaption("Remark 1"), PurchaseHeader."No.", SalesHeader."No.");
                if PurchaseHeader."Remark 2" <> SalesHeader."Remark 2" then
                    Error(Text052, PurchaseHeader.FieldCaption("Remark 2"), PurchaseHeader."No.", SalesHeader."No.");
                if PurchaseHeader."Service Period" <> SalesHeader."Service Period" then
                    Error(Text052, PurchaseHeader.FieldCaption("Service Period"), PurchaseHeader."No.", SalesHeader."No.");

            end else begin
                PurchaseHeader."Deal Name" := SalesHeader."Deal Name";
                PurchaseHeader."Remark 1" := SalesHeader."Remark 1";
                PurchaseHeader."Remark 2" := SalesHeader."Remark 2";
                PurchaseHeader."Service Period" := SalesHeader."Service Period";
                PurchaseHeader.Modify();

            end;

        end;
    end;



    Var
        CDSSalesOrder: Record "CRM Salesorder";
        IntegrationTableMappingName: Code[20];
        SalesOrder: Record "Sales Header";
        IntegrationFieldMapping: Record "Integration Field Mapping";
        recItem: Record item;
        CDSProduct: Record "CRM Product";
        Text052: Label 'The %1 field on the purchase order %2 must be the same as on sales order %3.';
}
