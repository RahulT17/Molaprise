table 50100 "CRM Gen. Product Posting Group"
{
    TableType = CRM;
    ExternalName = 'sgit_productcategory';

    fields
    {
        field(2; sgit_productcategoryid; Guid)
        {
            Caption = 'sgit_productcategoryid';
            ExternalName = 'sgit_productcategoryid';
            ExternalType = 'Uniqueidentifier';
            DataClassification = ToBeClassified;
        }
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
            ExternalName = 'sgit_name';
            ExternalType = 'String';
            ExternalAccess = Full;
        }
    }
    keys
    {
        key(PK; sgit_productcategoryid)
        {
            Clustered = true;
        }
    }
}
