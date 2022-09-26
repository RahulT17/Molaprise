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

        field(50109; VendorId; Guid)
        {
            Caption = 'Vendor Id';
            DataClassification = ToBeClassified;
            ExternalAccess = Full;
            ExternalName = 'sgit_vendor';
            ExternalType = 'Lookup';
            TableRelation = "CRM Account".AccountId;
        }
        // field(50104; "Vendor No."; Code[250])
        // {
        //     ExternalName = 'cr9b4_vendornameorder';
        //     ExternalType = 'Lookup';
        //     ExternalAccess = Full;
        //     DataClassification = ToBeClassified;
        //     TableRelation = "CRM Account".AccountNumber;
        // }
        field(50105; "Vendor Total Cost Order"; Decimal)
        {
            ExternalName = 'cr964_vendortotalcostorder';
            ExternalType = 'Decimal';
            ExternalAccess = Full;
            DataClassification = ToBeClassified;
        }
        field(50106; "Vendor Reference Id"; Text[250])
        {
            ExternalName = 'sgit_vendorreferenceid';
            ExternalType = 'String';
            ExternalAccess = Full;
            DataClassification = ToBeClassified;
        }
        field(50107; "Drop Shipment"; Boolean)
        {
            ExternalName = 'sgit_isdropshipment';
            ExternalType = 'Boolean';
            ExternalAccess = Full;
            DataClassification = ToBeClassified;
        }
        field(50108; "Order Submitted By"; Text[250])
        {
            ExternalName = 'sgit_ordersubmittedby';
            ExternalType = 'String';
            ExternalAccess = Full;
            DataClassification = ToBeClassified;
        }
    }
    var
        test: page 26;
        crmItem: Record "CRM Product";
        Dim: Record Dimension;
        crm: Codeunit "CRM Sales Order to Sales Order";
}
