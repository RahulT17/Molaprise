tableextension 50100 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        field(50100; "Deal Name"; Text[250])
        {
            Caption = 'Deal Name';
            DataClassification = ToBeClassified;
        }
        field(50101; "Service Period"; Text[250])
        {
            Caption = 'Service Period';
            DataClassification = ToBeClassified;
        }
        field(50102; "Remark 1"; Text[250])
        {
            Caption = 'Remark 1';
            DataClassification = ToBeClassified;
            // trigger OnValidate()
            // begin
            //     codee.Run()
            // end;
        }
        field(50103; "Remark 2"; Text[250])
        {
            Caption = 'Remark 2';
            DataClassification = ToBeClassified;
        }
        field(50104; "Purchase Order No."; Code[20])
        {
            Caption = 'Purchase Order No.';
            DataClassification = ToBeClassified;
        }
        field(50105; "Vendor Name"; Text[100])
        {
            Caption = 'Vendor Name';
            DataClassification = ToBeClassified;
            //TableRelation = Vendor;
        }
        field(50106; "Vendor No."; Code[250])
        {
            Caption = 'Vendor No.';
            DataClassification = ToBeClassified;
            TableRelation = Vendor;
        }
        field(50108; "Drop Shipment"; Boolean)
        {
            Caption = 'Drop Shipment';
            DataClassification = ToBeClassified;
        }
        field(50109; "Vendor Total Cost Order"; Decimal)
        {
            Caption = 'Vendor Total Cost Order';
            DataClassification = ToBeClassified;
        }
        field(50110; "Vendor Reference Id"; Text[250])
        {
            Caption = 'Vendor Reference Id';
            DataClassification = ToBeClassified;
        }
        field(50111; "Order Submitted By"; Text[250])
        {
            Caption = 'Order Submitted By';
            DataClassification = ToBeClassified;
        }
    }
    var
        codee: codeunit 50100;
        Purch: Page 50;
        purchTab: Record 38;
        SalesPage: Page 45;
        Vendor: Record Vendor;
}
