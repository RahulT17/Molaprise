table 50101 "CRM Gen Prod Posting Grp Ext"
{
    TableType = CDS;
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
    var
        pagee: page 5353;
        pageee: page 5380;
        test: Record 5341;
        tablee: Record 349;

        accounttable: Record "CRM Account";
}

