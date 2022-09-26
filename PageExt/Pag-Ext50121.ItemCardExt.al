pageextension 50121 "Item Card Ext" extends "Item Card"
{
    trigger OnOpenPage()
    var
        CodeUnitUpdateDimsGrps: Codeunit "Dimensions & Pst Grps Update";
    begin
        CodeUnitUpdateDimsGrps.UpdateDimesions(Rec."No.");
        CodeUnitUpdateDimsGrps.UpdatePostingGrps(Rec."No.");
    end;
}
