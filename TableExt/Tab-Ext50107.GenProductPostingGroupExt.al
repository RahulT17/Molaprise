tableextension 50107 "Gen. Product Posting Group Ext" extends "Gen. Product Posting Group"
{

    fields
    {
        field(50100; "Parent Item"; Guid)
        {
            DataClassification = ToBeClassified;
        }
        modify(Code)
        {
            Width = 50;
        }
    }
}
