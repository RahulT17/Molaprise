page 50100 "fIeld Mapping"
{
    Caption = 'Insert Field Mapping';
    PageType = Card;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field(TableNo; TableNumber)
                {
                    ApplicationArea = All;
                }
                field(TableName; TableName)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Integration Table No"; IntegrationTableNo)
                {
                    ApplicationArea = All;
                }
                field("Integration Table Name"; IntegrationTableName)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            group("Business Central")
            {
                field(FieldNumber; FieldNumber)
                {
                    ApplicationArea = All;
                    Caption = 'Field No.';
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        field: record field;
                    begin
                        field.Reset();
                        field.SetRange(TableNo, TableNumber);
                        if field.FindSet() then;
                        if Page.RunModal(Page::"Fields Lookup", field) = Action::LookupOK then begin
                            FieldNumber := field."No.";
                            FieldName := field.FieldName;
                        end;
                    end;
                }
                field(FieldName; FieldName)
                {
                    ApplicationArea = All;
                }
            }
            group("CRM")
            {
                field(IntegrationFieldNumber; IntegrationFieldNumber)

                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        field: record field;
                    begin
                        field.Reset();
                        field.SetRange(TableNo, IntegrationTableNo);
                        if field.FindSet() then;
                        if Page.RunModal(Page::"Fields Lookup", field) = Action::LookupOK then begin
                            IntegrationFieldNumber := field."No.";
                            IntegrationFieldName := field.FieldName;
                        end;
                    end;
                }
                field(IntegrationFieldName; IntegrationFieldName)
                {
                    ApplicationArea = All;
                }
            }
            group(Mapping)
            {
                field(SyncDirection; SyncDirection)
                {
                    ApplicationArea = All;
                }
                field(ConstantValue; ConstantValue)
                {
                    ApplicationArea = All;
                }
                field(ValidateField; ValidateField)
                {
                    ApplicationArea = All;
                }
                field(IntegrationValidateField; IntegrationValidateField)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Insert)
            {
                ApplicationArea = All;
                Caption = 'Insert Field Mapping';
                Image = Insert;
                trigger OnAction()
                var
                    Integrationtablemapping: Record "Integration table Mapping";
                    Integrationfieldmapping: Record "Integration field Mapping";
                begin
                    if (FieldNumber <> 0) and (IntegrationFieldNumber <> 0) then begin
                        Integrationtablemapping.Reset();
                        Integrationtablemapping.SetRange("Table ID", TableNumber);
                        Integrationtablemapping.SetRange("Integration Table ID", IntegrationTableNo);
                        if Integrationtablemapping.FindFirst() then begin
                            Integrationfieldmapping.Reset();
                            Integrationfieldmapping.SetRange("Field No.", FieldNumber);
                            Integrationfieldmapping.SetRange("Integration Table Field No.", IntegrationFieldNumber);
                            Integrationfieldmapping.SetRange("Integration Table Mapping Name", Integrationtablemapping.Name);
                            if not Integrationfieldmapping.FindFirst() then begin
                                InsertIntegrationFieldMapping(Integrationtablemapping.Name,
                                FieldNumber, IntegrationFieldNumber,
                                SyncDirection, ConstantValue, ValidateField, IntegrationValidateField);
                                FieldNumber := 0;
                                FieldName := '';
                                IntegrationFieldNumber := 0;
                                IntegrationFieldName := '';
                            end else begin
                                FieldNumber := 0;
                                FieldName := '';
                                IntegrationFieldNumber := 0;
                                IntegrationFieldName := '';
                                Error('Field Mapping already exists.');
                            end;
                        end;
                    end;
                end;
            }
            action(Delete)
            {
                ApplicationArea = All;
                Caption = 'Delete Field Mapping';
                Image = Delete;
                trigger OnAction()
                var
                    Integrationtablemapping: Record "Integration table Mapping";
                    Integrationfieldmapping: Record "Integration field Mapping";
                begin
                    if (FieldNumber <> 0) and (IntegrationFieldNumber <> 0) then begin
                        Integrationtablemapping.Reset();
                        Integrationtablemapping.SetRange("Table ID", TableNumber);
                        Integrationtablemapping.SetRange("Integration Table ID", IntegrationTableNo);
                        if Integrationtablemapping.FindFirst() then begin
                            Integrationfieldmapping.Reset();
                            Integrationfieldmapping.SetRange("Integration Table Mapping Name", Integrationtablemapping.Name);
                            Integrationfieldmapping.SetRange("Field No.", FieldNumber);
                            Integrationfieldmapping.SetRange("Integration Table Field No.", IntegrationFieldNumber);
                            if Integrationfieldmapping.FindFirst() then begin
                                Integrationfieldmapping.Delete(false);
                                FieldNumber := 0;
                                FieldName := '';
                                IntegrationFieldNumber := 0;
                                IntegrationFieldName := '';
                            end else begin
                                Error('Field Mapping doesn''t exists.');
                                FieldNumber := 0;
                                FieldName := '';
                                IntegrationFieldNumber := 0;
                                IntegrationFieldName := '';
                            end;
                        end;
                    end;
                end;
            }
        }
    }

    var
        [InDataSet]
        TableName: Text;
        [InDataSet]
        IntegrationTableName: text;
        [InDataSet]
        TableNumber: Integer;
        [InDataSet]
        IntegrationTableNo: Integer;
        [InDataSet]
        IntegrationFieldNumber: Integer;
        [InDataSet]
        IntegrationFieldName: Text;
        [InDataSet]
        FieldNumber: Integer;
        [InDataSet]
        FieldName: Text;
        [InDataSet]
        SyncDirection: Option Bidirectional,ToIntegrationTable,FromIntegrationTable;
        [InDataSet]
        ConstantValue: Text;
        [InDataSet]
        ValidateField: Boolean;
        [InDataSet]
        IntegrationValidateField: Boolean;

        AllObjWithCaption: Record AllObjWithCaption;

    procedure SetTableID(tableID: Integer; integrationTableID: Integer)
    begin
        TableNumber := tableID;
        if AllObjWithCaption.Get(AllObjWithCaption."Object Type"::Table, "TableNumber") then
            TableName := AllObjWithCaption."Object Caption";
        IntegrationTableNo := integrationTableID;
        if AllObjWithCaption.Get(AllObjWithCaption."Object Type"::Table, integrationTableNo) then
            IntegrationTableName := AllObjWithCaption."Object Caption";
    end;

    procedure InsertIntegrationFieldMapping(IntegrationTableMappingName: Code[20]; TableFieldNo: Integer; IntegrationTableFieldNo: Integer; SynchDirection: Option; ConstValue: Text; ValidateField: Boolean; ValidateIntegrationTableField: Boolean)
    var
        IntegrationFieldMapping: Record "Integration Field Mapping";
    begin
        IntegrationFieldMapping.CreateRecord(IntegrationTableMappingName, TableFieldNo, IntegrationTableFieldNo, SynchDirection,
            ConstValue, ValidateField, ValidateIntegrationTableField);
    end;
}
