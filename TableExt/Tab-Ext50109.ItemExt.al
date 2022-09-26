tableextension 50109 "Item Ext" extends Item
{
    fields
    {
        field(50100; "Dimension Value"; Guid)
        {
            Caption = 'Dimension Value';
            DataClassification = ToBeClassified;
            //TableRelation = "Dimension Value";
            // TableRelation = "CRM Product".Manufacturer;
            // TestTableRelation = false;
        }
        // field(50101; Posting_Group; Guid)
        // {
        //     Caption = 'Posting Group';
        //     DataClassification = ToBeClassified;
        // }

    }
}
