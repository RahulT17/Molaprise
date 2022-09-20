page 50149 "CRM Gen. Prod Posting Grp Ext"
{
    ApplicationArea = All;
    Caption = 'CRM Gen. Prod Posting Grp Ext';
    PageType = List;
    SourceTable = "CRM Gen Prod Posting Grp Ext";
    UsageCategory = Lists;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(sgit_productcategoryid; Rec.sgit_productcategoryid)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the sgit_productcategoryid field.';
                }
            }
        }

    }
    actions
    {
        area(processing)
        {
            action(CreateFromCDS)
            {
                ApplicationArea = All;
                Caption = 'Create in Business Central';
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Generate the table from the coupled Microsoft Dataverse lab book.';

                trigger OnAction()
                var
                    CDSGenProd: Record "CRM Gen Prod Posting Grp Ext";
                    CRMIntegrationManagement: Codeunit "CRM Integration Management";
                begin
                    CurrPage.SetSelectionFilter(CDSGenProd);
                    CRMIntegrationManagement.CreateNewRecordsFromCRM(CDSGenProd);
                end;
            }
        }
    }
    var
        CurrentlyCoupledCDSGenPostProd: Record "CRM Gen Prod Posting Grp Ext";

    trigger OnInit()
    begin
        Codeunit.Run(Codeunit::"CRM Integration Management");
    end;

    procedure SetCurrentlyCoupledCDSGenPostProd(CDSLabBook: Record "CRM Gen Prod Posting Grp Ext")
    begin
        CurrentlyCoupledCDSGenPostProd := CDSLabBook;
    end;
}
