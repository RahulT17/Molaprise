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
    }
    var
        codee: codeunit 50100;
        Purch: Page 50;
        purchTab: Record 38;
        SalesPage: Page 45;
}
