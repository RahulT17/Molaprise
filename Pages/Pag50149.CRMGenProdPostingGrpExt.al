page 50149 "CRM Gen. Prod Posting Grp Ext"
{
    Caption = 'CRM Gen. Prod Posting Grp Ext';
    PageType = List;
    SourceTable = "CRM Gen. Product Posting Group";
    UsageCategory = Administration;

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
}
