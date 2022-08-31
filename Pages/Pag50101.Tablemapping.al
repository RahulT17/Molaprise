page 50101 "Table mapping"
{
    Caption = 'Table mapping';
    PageType = Card;
    layout
    {
        area(content)
        {
            field("Integration table mapping name"; "Integration table mapping name")
            {
                ApplicationArea = All;
            }
            group("Business central")
            {
                field("BC Table No"; "BC Table No")
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Tableobjects: page "Table Objects";
                    begin
                        AllObjWithCaption.Reset();
                        AllObjWithCaption.SetFilter("Object Type", '%1', AllObjWithCaption."Object Type"::Table);
                        if AllObjWithCaption.FindSet() then begin
                            if page.RunModal(Page::"Table Objects", AllObjWithCaption) = Action::LookupOK then begin
                                "BC Table No" := AllObjWithCaption."Object ID";
                                "BC Table Name" := AllObjWithCaption."Object Name";
                            end;
                        end;
                    end;
                }
                field("BC Table Name"; "BC Table Name")
                {
                    ApplicationArea = All;
                }
            }
            group(CRM)
            {
                field("Integration Table No"; "Integration Table No")
                {
                    ApplicationArea = all;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Tableobjects: page "Table Objects";
                    begin
                        AllObjWithCaption.Reset();
                        AllObjWithCaption.SetFilter("Object Type", '%1', AllObjWithCaption."Object Type"::Table);
                        if AllObjWithCaption.FindSet() then begin
                            if page.RunModal(page::"Table Objects", AllObjWithCaption) = Action::LookupOK then begin
                                "Integration Table No" := AllObjWithCaption."Object ID";
                                "integration Table Name" := AllObjWithCaption."Object Name";
                            end;
                        end;
                    end;
                }
                field("Integration Table Name"; "Integration Table Name")
                {
                    ApplicationArea = All;
                }
                field("CRM UID field No"; "CRM UID field No")
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        field: record field;
                    begin
                        if "Integration Table No" <> 0 then begin
                            field.Reset();
                            field.SetRange(TableNo, "Integration Table No");
                            if field.FindSet() then;
                            if Page.RunModal(Page::"Fields Lookup", field) = Action::LookupOK then begin
                                "CRM UID field No" := field."No.";
                            end;
                        end else
                            Error('Please select integration Table No');
                    end;
                }
                field("CRM Modified field No"; "CRM Modified field No")
                {
                    ApplicationArea = All;
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        field: record field;
                    begin
                        if "Integration Table No" <> 0 then begin
                            field.Reset();
                            field.SetRange(TableNo, "Integration Table No");
                            if field.FindSet() then;
                            if Page.RunModal(Page::"Fields Lookup", field) = Action::LookupOK then begin
                                "CRM Modified field No" := field."No.";
                            end;
                        end else
                            Error('Please select integration Table No');
                    END;
                }
            }
            group(Mapping)
            {
                field(TableConfigTemplateCode; TableConfigTemplateCode)
                {
                    ApplicationArea = All;
                }
                field(IntegrationTableConfigTemplateCode; IntegrationTableConfigTemplateCode)
                {
                    ApplicationArea = All;
                }
                field(SyncDirection; SyncDirection)
                {
                    ApplicationArea = All;
                }
                field("Sync only coupled records"; "Sync only coupled records")
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
            action("Insert table mapping")
            {
                ApplicationArea = All;
                trigger OnAction()
                begin
                    integrationTableMapping.Reset();
                    integrationTableMapping.SetRange("Table ID", "BC Table No");
                    integrationTableMapping.SetRange("Integration Table ID", "Integration Table No");
                    if not integrationTableMapping.FindFirst() then
                        InsertIntegrationTableMapping(integrationTableMapping, "Integration table mapping name", "BC Table No", "Integration Table No", "CRM UID field No", "CRM Modified field No", TableConfigTemplateCode, IntegrationTableConfigTemplateCode, SyncDirection, "Sync only coupled records")
                    else
                        Error('Integration Table Mapping already exists.');
                end;
            }
        }
    }
    var
        [InDataSet]
        "Integration table mapping name": Code[20];
        [InDataSet]
        "BC Table No": Integer;
        [InDataSet]
        "Integration Table No": Integer;
        [InDataSet]
        "BC Table Name": Text;
        [InDataSet]
        "Integration Table Name": Text;
        [InDataSet]
        "CRM UID field No": Integer;
        [InDataSet]
        "CRM Modified field No": Integer;
        [InDataSet]
        TableConfigTemplateCode: Code[10];
        [InDataSet]
        IntegrationTableConfigTemplateCode: Code[10];
        [InDataSet]
        "Sync only coupled records": Boolean;
        [InDataSet]
        SyncDirection: Option Bidirectional,ToIntegrationTable,FromIntegrationTable;
        AllObjWithCaption: Record AllObjWithCaption;

        integrationTableMapping: Record "Integration Table Mapping";

    local procedure InsertIntegrationTableMapping(var IntegrationTableMapping: Record "Integration Table Mapping"; MappingName: Code[20]; TableNo: Integer; IntegrationTableNo: Integer; IntegrationTableUIDFieldNo: Integer; IntegrationTableModifiedFieldNo: Integer; TableConfigTemplateCode: Code[10]; IntegrationTableConfigTemplateCode: Code[10]; SyncDirection: Option; SynchOnlyCoupledRecords: Boolean)
    begin
        IntegrationTableMapping.CreateRecord(MappingName, TableNo, IntegrationTableNo, IntegrationTableUIDFieldNo, IntegrationTableModifiedFieldNo, TableConfigTemplateCode, IntegrationTableConfigTemplateCode, SynchOnlyCoupledRecords, SyncDirection, 'CDS');
        "BC Table No" := 0;
        "BC Table Name" := '';
        "Integration Table No" := 0;
        "Integration Table Name" := '';
    end;
}
