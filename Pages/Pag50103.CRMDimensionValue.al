page 50103 "CRM Dimension Values"
{
    ApplicationArea = All;
    Caption = 'CRM Dimension Value';
    PageType = List;
    SourceTable = "CRM Dimension Values";
    UsageCategory = Lists;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                // field("Dimension Code"; Rec."Dimension Code")
                // {
                //     ApplicationArea = All;
                // }
                // field("Code"; Rec.Code)
                // {
                //     ApplicationArea = All;
                // }
                field(CustomerTypeCode; CustomerTypeCode)
                {
                    ApplicationArea = All;
                    OptionCaption = ' ,Competitor,Consultant,Customer,Investor,Partner,Influencer,Press,Prospect,Reseller,Supplier,Vendor,Other,Manufacturer';
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field(AccountId; Rec.AccountId)
                {
                    ApplicationArea = All;
                }
                // field(CustomerTypeCodeCustom; CustomerTypeCodeCustom)
                // {
                //     ApplicationArea = All;
                // }
                // field(CustomerTypeCodeCustom)
                // {
                //     ApplicationArea = All;
                // }
            }
        }

    }
    actions
    {
        area(processing)
        {
            // action(CreateFromCDS)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Create in Business Central';
            //     Promoted = true;
            //     PromotedCategory = Process;
            //     ToolTip = 'Generate the table from the coupled Microsoft Dataverse lab book.';

            //     trigger OnAction()
            //     var
            //         CDSDimension: Record "CRM Dimension Values";
            //         CRMIntegrationManagement: Codeunit "CRM Integration Management";
            //     begin
            //         // CurrPage.SetSelectionFilter(Rec);
            //         // CRMIntegrationManagement.CreateNewRecordsFromCRM(Rec);
            //         pageCRMSalesOrder.UpdateDimensionValues

            //     end;
            // }
        }
    }
    var
        CurrentlyCoupledCDSDimension: Record "CRM Dimension Values";

    trigger OnInit()
    begin
        Codeunit.Run(Codeunit::"CRM Integration Management");
    end;

    procedure SetCurrentlyCoupledCDSGenPostProd(CDSLabBook: Record "CRM Dimension Values")
    begin
        CurrentlyCoupledCDSDimension := CDSLabBook;
    end;

    var
        pageCRMSalesOrder: Page "CRM Sales Order";
}
