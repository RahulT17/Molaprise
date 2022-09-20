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
        CRMAccount: Record "CRM Account";
        CRMIntegrationRecord: Record "CRM Integration Record";
        NAVCustomerRecordId: RecordID;
        CRMAccountId: Guid;
        IsHandled: Boolean;
        CRMProductName: Codeunit "CRM Product Name";
        recVendor: Record Vendor;
        VendorGuid: Code[250];
    begin
        SalesSetup.get();
        SalesHeader."Service Period" := CRMSalesorder."Service Period";
        SalesHeader."Deal Name" := CRMSalesorder."Deal Name";
        SalesHeader."External Document No." := CRMSalesorder."External Document No.";
        //SalesHeader."Vendor No." := CRMSalesorder."Vendor No.";
        SalesHeader."Vendor Total Cost Order" := CRMSalesorder."Vendor Total Cost Order";
        SalesHeader."Vendor Reference Id" := CRMSalesorder."Vendor Reference Id";
        SalesHeader."Drop Shipment" := CRMSalesorder."Drop Shipment";
        SalesHeader."Order Submitted By" := CRMSalesorder."Order Submitted By";
        VendorGuid := DELCHR(CRMSalesorder.VendorId, '=', '{}');
        if VendorGuid <> '' then begin
            if not CRMIntegrationRecord.FindRecordIDFromID(VendorGuid, DATABASE::Vendor, NAVCustomerRecordId) then
                Error('Something went wrong!', 'Cannot create order!', CRMAccount.Name, CRMProductName.CDSServiceName());

            recVendor.Get(NAVCustomerRecordId);
            //Message(Format(recVendor."No."));
        end;

        SalesHeader."Vendor No." := recVendor."No.";
        if recVendor.Get(SalesHeader."Vendor No.") then
            SalesHeader."Vendor Name" := recVendor.Name;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CRM Sales Order to Sales Order", 'OnCreateSalesOrderLinesOnBeforeSalesLineInsert', '', false, false)]
    local procedure OnSalesLineOnbeforeSalesLineInsert(var SalesLine: Record "Sales Line")
    var
        recSalesHeader: Record "Sales Header";
    begin
        recSalesHeader.RESET;
        recSalesHeader.SetRange("No.", SalesLine."Document No.");
        if recSalesHeader.FindFirst() then
            if recSalesHeader."Drop Shipment" = true then
                SalesLine."Drop Shipment" := true;
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
    procedure CopyFieldFromSalesOrdToPurchOrd(var PurchaseHeader: Record "Purchase Header"; SalesHeader: Record "Sales Header"; ShowError: Boolean)
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
                PurchaseHeader."Sales Order No." := SalesHeader."No.";
                //SalesHeader."Purchase Order No." := PurchaseHeader."No.";
                PurchaseHeader.Modify();

            end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CRM Setup Defaults", 'OnGetCDSTableNo', '', false, false)]
    local procedure HandleOnGetCDSTableNo(BCTableNo: Integer; var CDSTableNo: Integer; var handled: Boolean)
    begin
        if BCTableNo = Database::"Gen. Product Posting Group" then begin
            CDSTableNo := Database::"CRM Gen Prod Posting Grp Ext";
            handled := true;
        end;
        if BCTableNo = Database::"Dimension Value" then begin
            CDSTableNo := Database::"CRM Dimension Values";
            handled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Lookup CRM Tables", 'OnLookupCRMTables', '', true, true)]
    local procedure HandleOnLookupCRMTables(CRMTableID: Integer; NAVTableId: Integer; SavedCRMId: Guid; var CRMId: Guid; IntTableFilter: Text; var Handled: Boolean)
    begin
        if CRMTableID = Database::"CRM Gen Prod Posting Grp Ext" then
            Handled := LookupCDSGenPostGrp(SavedCRMId, CRMId, IntTableFilter);
        if CRMTableID = Database::"CRM Dimension Values" then
            Handled := LookupCDSDimensions(SavedCRMId, CRMId, IntTableFilter);
    end;

    local procedure LookupCDSGenPostGrp(SavedCRMId: Guid; var CRMId: Guid; IntTableFilter: Text): Boolean
    var
        CDSGenPost: Record "CRM Gen Prod Posting Grp Ext";
        OriginalCDSGenPost: Record "CRM Gen Prod Posting Grp Ext";
        OriginalCDSGenPostList: Page "CRM Gen. Prod Posting Grp Ext";

    begin
        if not IsNullGuid(CRMId) then begin
            if CDSGenPost.Get(CRMId) then
                OriginalCDSGenPostList.SetRecord(CDSGenPost);
            if not IsNullGuid(SavedCRMId) then
                if OriginalCDSGenPost.get(SavedCRMId) then
                    OriginalCDSGenPostList.SetCurrentlyCoupledCDSGenPostProd(OriginalCDSGenPost);
        end;

        CDSGenPost.SetView(IntTableFilter);
        OriginalCDSGenPostList.SetTableView(CDSGenPost);
        OriginalCDSGenPostList.LookupMode(true);
        if OriginalCDSGenPostList.RunModal = Action::LookupOK then begin
            OriginalCDSGenPostList.GetRecord(CDSGenPost);
            CRMId := CDSGenPost.sgit_productcategoryid;
            exit(true);
        end;
        exit(false);
    end;

    local procedure LookupCDSDimensions(SavedCRMId: Guid; var CRMId: Guid; IntTableFilter: Text): Boolean
    var
        CDSGenPost: Record "CRM Dimension Values";
        OriginalCDSGenPost: Record "CRM Dimension Values";
        OriginalCDSGenPostList: Page "CRM Dimension Values";

    begin
        if not IsNullGuid(CRMId) then begin
            if CDSGenPost.Get(CRMId) then
                OriginalCDSGenPostList.SetRecord(CDSGenPost);
            if not IsNullGuid(SavedCRMId) then
                if OriginalCDSGenPost.get(SavedCRMId) then
                    OriginalCDSGenPostList.SetCurrentlyCoupledCDSGenPostProd(OriginalCDSGenPost);
        end;

        CDSGenPost.SetView(IntTableFilter);
        OriginalCDSGenPostList.SetTableView(CDSGenPost);
        OriginalCDSGenPostList.LookupMode(true);
        if OriginalCDSGenPostList.RunModal = Action::LookupOK then begin
            OriginalCDSGenPostList.GetRecord(CDSGenPost);
            CRMId := CDSGenPost.AccountId;
            exit(true);
        end;
        exit(false);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"CRM Setup Defaults", 'OnAddEntityTableMapping', '', true, true)]
    local procedure HandleOnAddEntityTableMapping(var TempNameValueBuffer: Record "Name/Value Buffer" temporary);
    var
        CRMSetupDefaults: Codeunit "CRM Setup Defaults";
    begin
        AddEntityTableMapping('CDSGenProd', DATABASE::"CRM Gen Prod Posting Grp Ext", TempNameValueBuffer);
        CRMSetupDefaults.AddEntityTableMapping('CDSGenProd', DATABASE::"CRM Gen Prod Posting Grp Ext", TempNameValueBuffer);

        AddEntityTableMapping('CDSDimensions', DATABASE::"CRM Dimension Values", TempNameValueBuffer);
        CRMSetupDefaults.AddEntityTableMapping('CDSDimensions', DATABASE::"CRM Dimension Values", TempNameValueBuffer);
    end;

    local procedure AddEntityTableMapping(CRMEntityTypeName: Text; TableID: Integer; var TempNameValueBuffer: Record "Name/Value Buffer" temporary)
    begin
        TempNameValueBuffer.Init();
        TempNameValueBuffer.ID := TempNameValueBuffer.Count + 1;
        TempNameValueBuffer.Name := CopyStr(CRMEntityTypeName, 1, MaxStrLen(TempNameValueBuffer.Name));
        TempNameValueBuffer.Value := Format(TableID);
        TempNameValueBuffer.Insert();
    end;


    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterDeleteEvent', '', false, false)]
    procedure onDeletePucahseLines(var Rec: Record "Purchase Line")
    var
        PurchaseLine: Record "Purchase Line";
        PurchaseHeader: Record "Purchase Header";
        SalesHedaer: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        if Rec."Sales Order No." <> '' then begin
            SalesLine.SetRange("Document No.", Rec."Sales Order No.");
            SalesLine.SetRange("Line No.", Rec."Sales Order Line No.");
            if SalesLine.FindFirst() then begin
                SalesLine."Purchase Order No." := '';
                SalesLine."Purch. Order Line No." := 0;
                SalesLine.Modify();
            end;
            SalesHedaer.SetRange("No.", SalesLine."Document No.");
            if SalesHedaer.FindFirst() then begin
                SalesHedaer."Purchase Order No." := '';
                SalesHedaer.Modify()
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
