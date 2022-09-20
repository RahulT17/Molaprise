table 50102 "CRM Dimension Values"
{
    Caption = 'CRM Dimension Values';
    DataClassification = ToBeClassified;
    ExternalName = 'account';
    TableType = CDS;


    fields
    {
        field(1; AccountId; Guid)
        {
            Caption = 'Account';
            Description = 'Unique identifier of the account.';
            ExternalAccess = Full;
            ExternalName = 'accountid';
            ExternalType = 'Uniqueidentifier';
            DataClassification = ToBeClassified;
        }
        field(6; CustomerTypeCode; Option)
        {
            Caption = 'Relationship Type';
            Description = 'Select the category that best describes the relationship between the account and your organization.';
            ExternalName = 'customertypecode';
            ExternalType = 'Picklist';
            InitValue = " ";
            OptionCaption = ' ,Competitor,Consultant,Customer,Investor,Partner,Influencer,Press,Prospect,Reseller,Supplier,Vendor,Other';
            OptionOrdinalValues = -1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12;
            OptionMembers = " ",Competitor,Consultant,Customer,Investor,Partner,Influencer,Press,Prospect,Reseller,Supplier,Vendor,Other;
        }
        field(19; Name; Text[160])
        {
            Caption = 'Account Name';
            Description = 'Type the company or business name.';
            ExternalName = 'name';
            ExternalType = 'String';
        }
        // field(202; CompanyId; Guid)
        // {
        //     Caption = 'Company Id';
        //     Description = 'Unique identifier of the company that owns the account.';
        //     ExternalName = 'bcbi_companyid';
        //     ExternalType = 'Lookup';
        //     TableRelation = "CDS Company".CompanyId;
        // }
        // field(54; StateCode; Option)
        // {
        //     Caption = 'Status';
        //     Description = 'Shows whether the account is active or inactive. Inactive accounts are read-only and can''t be edited unless they are reactivated.';
        //     ExternalAccess = Modify;
        //     ExternalName = 'statecode';
        //     ExternalType = 'State';
        //     InitValue = Active;
        //     OptionCaption = 'Active,Inactive';
        //     OptionOrdinalValues = 0, 1;
        //     OptionMembers = Active,Inactive;
        // }
        field(50100; "Code"; Code[20])
        {
            Caption = 'Account Number';
            ExternalName = 'Account Number';
            ExternalType = 'Autonumber';
            DataClassification = ToBeClassified;
        }
        field(50101; AccountName; Text[50])
        {
            Caption = 'Account Name';
            ExternalName = 'Account Name';
            ExternalType = 'String';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; AccountId)
        {
            Clustered = true;
        }
        key(Key2; Name)
        {
        }
    }

    var
        CRMAccount: Record "CRM Account";
}
