pageextension 50117 "Integration Table Mapping List" extends "Integration Table Mapping List"
{
    actions
    {
        addafter(FieldMapping)
        {
            action("Field Mapping")
            {
                ApplicationArea = All;
                Caption = 'Field Mapping';
                Image = Change;
                trigger OnAction()
                var
                    FieldMapping: Page "fIeld Mapping";
                begin
                    FieldMapping.SetTableID(Rec."Table ID", Rec."Integration Table ID");
                    FieldMapping.RunModal();
                end;
            }

            action("Table Mapping")
            {
                ApplicationArea = All;
                Caption = 'Table Mapping';
                Image = Change;
                trigger OnAction()
                var
                    TableMapping: Page "Table Mapping";
                begin
                    TableMapping.RunModal();
                end;
            }
        }
    }
}
