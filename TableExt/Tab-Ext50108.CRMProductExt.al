tableextension 50108 "CRM Product Ext" extends "CRM Product"
{
    fields
    {
        field(50109; Manufacturer; Guid)
        {
            Caption = 'Manufacturer';
            DataClassification = ToBeClassified;
            ExternalAccess = Full;
            ExternalName = 'mp_manufacturer';
            ExternalType = 'Lookup';
            TableRelation = "CRM Product".Manufacturer;
        }
        field(50100; Posting_Group; Guid)
        {
            Caption = 'Posting group';
            DataClassification = ToBeClassified;
            ExternalAccess = Full;
            ExternalName = 'sgit_productcategory';
            ExternalType = 'Lookup';
            TableRelation = "CRM Gen Prod Posting Grp Ext".sgit_productcategoryid;
        }

    }
}
