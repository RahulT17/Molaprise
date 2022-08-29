tableextension 50101 "CRM Salesorder Ext" extends "CRM Salesorder"
{
    fields
    {
        field(50100; "Deal Name"; Text[250])
        {
            ExternalName = 'name';
            ExternalType = 'String';
            ExternalAccess = Full;
            DataClassification = ToBeClassified;
        }
        field(50101; "Service Period"; Text[250])
        {
            ExternalName = 'sgit_serviceperiod';
            ExternalType = 'String';
            ExternalAccess = Full;
            DataClassification = ToBeClassified;
        }
        field(50102; "External Document No."; Text[250])
        {
            ExternalName = 'mp_customerponumber';
            ExternalType = 'String';
            ExternalAccess = Full;
            DataClassification = ToBeClassified;
        }
    }
}
