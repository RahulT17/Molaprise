pageextension 50100 "Sales Order Ext" extends "Sales Order"
{
    layout
    {
        addafter("Your Reference")
        {
            field("Deal Name"; "Deal Name")
            {
                ApplicationArea = All;
            }
            field("Service Period"; "Service Period")
            {
                ApplicationArea = All;
            }
            field("Remark 1"; "Remark 1")
            {
                ApplicationArea = All;
            }
            field("Remark 2"; "Remark 2")
            {
                ApplicationArea = All;
            }
            field("Purchase Order No."; "Purchase Order No.")
            {
                ApplicationArea = All;
            }
            field("Vendor No."; "Vendor No.")
            {
                ApplicationArea = All;

                trigger OnValidate()
                begin
                    if Vendor_Rec.get(Rec."Vendor No.") then
                        "Vendor Name" := Vendor_Rec.Name;
                end;

            }
            field("Vendor Name"; "Vendor Name")
            {
                ApplicationArea = All;
                Editable = false;

            }
            field("Drop Shipment"; "Drop Shipment")
            {
                ApplicationArea = All;
            }

        }


    }
    actions
    {
        addafter("&Print")
        {
            action("Copy S.O to P.O")
            {
                Caption = 'Copy S.O to P.O';
                ApplicationArea = all;
                Image = Copy;
                Promoted = true;

                trigger OnAction()
                begin
                    CopySOtoPO;
                end;
            }

        }
    }


    var

        Vendor_Rec: Record Vendor;

    procedure CopySOtoPO()
    var
        recPurchaseHeader: Record "Purchase Header";
        PurchaseOrderPage: Page 50;
        PurcahseOrderNo: Code[20];
        NoSeriesMgt: Codeunit NoSeriesManagement;
        RecSalesLine: Record "Sales Line";
        RecPurchaseLines: Record "Purchase Line";
        ShipToOption_New: Option "Default (Company Address)",Location,"Customer Address","Custom Address";
        RecItem: Record Item;
        PayToOptions: Option "Default (Vendor)","Another Vendor","Custom Address";
        DimMgt: Codeunit DimensionManagement;
        Dimension: Record 480;
    begin
        if Rec.Status = Status::Released then begin
            recPurchaseHeader.Reset();
            if Rec."Drop Shipment" = true then begin
                Rec.TestField("Vendor No.");
                recPurchaseHeader.Init();
                recPurchaseHeader."Document Type" := recPurchaseHeader."Document Type"::Order;
                NoSeriesMgt.InitSeries(recPurchaseHeader.GetNoSeriesCode, recPurchaseHeader."No. Series", 0D, recPurchaseHeader."No.", recPurchaseHeader."No. Series");
                recPurchaseHeader."Buy-from Vendor No." := Rec."Vendor No.";
                recPurchaseHeader."Buy-from Vendor Name" := Rec."Vendor Name";
                recPurchaseHeader."Deal Name" := Rec."Deal Name";
                recPurchaseHeader."Remark 1" := Rec."Remark 1";
                recPurchaseHeader."Remark 2" := Rec."Remark 2";
                ShipToOptions := ShipToOption_New::"Customer Address";
                recPurchaseHeader."Sell-to Customer No." := Rec."Sell-to Customer No.";
                recPurchaseHeader."Ship-to Name" := Rec."Ship-to Name";
                recPurchaseHeader."Ship-to Address" := Rec."Ship-to Address";
                recPurchaseHeader."Ship-to Address 2" := Rec."Ship-to Address 2";
                recPurchaseHeader."Ship-to City" := Rec."Ship-to City";
                recPurchaseHeader."Ship-to County" := Rec."Ship-to County";
                recPurchaseHeader."Ship-to Post Code" := Rec."Ship-to Post Code";
                recPurchaseHeader."Ship-to Country/Region Code" := Rec."Ship-to Country/Region Code";
                recPurchaseHeader."Ship-to Contact" := Rec."Ship-to Contact";
                recPurchaseHeader.Insert();
                RecSalesLine.SetRange("Document No.", Rec."No.");
                if RecSalesLine.FindSet() then begin
                    repeat
                        RecPurchaseLines.Init();
                        RecPurchaseLines."Document No." := recPurchaseHeader."No.";
                        RecPurchaseLines."Line No." := RecSalesLine."Line No.";
                        RecPurchaseLines."Document Type" := RecPurchaseLines."Document Type"::Order;
                        RecPurchaseLines.Type := RecSalesLine.Type;
                        RecPurchaseLines."No." := RecSalesLine."No.";
                        RecPurchaseLines.Description := RecSalesLine.Description;
                        if RecItem.get(Rec."No.") then
                            RecPurchaseLines."Unit Cost" := RecItem."Last Direct Cost";
                        RecPurchaseLines.Quantity := RecSalesLine.Quantity;
                        RecPurchaseLines."Location Code" := RecSalesLine."Location Code";
                        RecPurchaseLines."Bin Code" := RecSalesLine."Bin Code";
                        RecPurchaseLines."Tax Area Code" := RecSalesLine."Tax Area Code";
                        RecPurchaseLines."Tax Group Code" := RecSalesLine."Tax Group Code";
                        RecPurchaseLines."Shortcut Dimension 1 Code" := RecSalesLine."Shortcut Dimension 1 Code";
                        RecPurchaseLines."Shortcut Dimension 2 Code" := RecSalesLine."Shortcut Dimension 2 Code";
                        RecPurchaseLines.Insert();


                    until RecSalesLine.Next() = 0;
                end;
            end else begin
                if Rec.Status = Status::Released then begin
                    Rec.TestField("Vendor No.");
                    recPurchaseHeader.Init();
                    recPurchaseHeader."Document Type" := recPurchaseHeader."Document Type"::Order;
                    NoSeriesMgt.InitSeries(recPurchaseHeader.GetNoSeriesCode, recPurchaseHeader."No. Series", 0D, recPurchaseHeader."No.", recPurchaseHeader."No. Series");
                    recPurchaseHeader."Buy-from Vendor No." := Rec."Vendor No.";
                    recPurchaseHeader."Buy-from Vendor Name" := Rec."Vendor Name";
                    recPurchaseHeader."Deal Name" := Rec."Deal Name";
                    recPurchaseHeader."Remark 1" := Rec."Remark 1";
                    recPurchaseHeader."Remark 2" := Rec."Remark 2";
                    ShipToOptions := ShipToOptions;
                    recPurchaseHeader.Insert();
                    RecSalesLine.SetRange("Document No.", Rec."No.");
                    if RecSalesLine.FindSet() then begin
                        repeat
                            RecPurchaseLines.Init();
                            RecPurchaseLines."Document No." := recPurchaseHeader."No.";
                            RecPurchaseLines."Line No." := RecSalesLine."Line No.";
                            RecPurchaseLines."Document Type" := RecPurchaseLines."Document Type"::Order;
                            RecPurchaseLines.Type := RecSalesLine.Type;
                            RecPurchaseLines."No." := RecSalesLine."No.";
                            RecPurchaseLines.Description := RecSalesLine.Description;
                            if RecItem.get(Rec."No.") then
                                RecPurchaseLines."Unit Cost" := RecItem."Last Direct Cost";
                            RecPurchaseLines.Quantity := RecSalesLine.Quantity;
                            RecPurchaseLines."Location Code" := RecSalesLine."Location Code";
                            RecPurchaseLines."Bin Code" := RecSalesLine."Bin Code";
                            RecPurchaseLines."Tax Area Code" := RecSalesLine."Tax Area Code";
                            RecPurchaseLines."Tax Group Code" := RecSalesLine."Tax Group Code";
                            RecPurchaseLines."Shortcut Dimension 1 Code" := RecSalesLine."Shortcut Dimension 1 Code";
                            RecPurchaseLines."Shortcut Dimension 2 Code" := RecSalesLine."Shortcut Dimension 2 Code";
                            RecPurchaseLines.Insert();
                        until RecSalesLine.Next() = 0;
                    end;
                end;

                PurchaseOrderPage.SetTableView(recPurchaseHeader);
                PurchaseOrderPage.SetRecord(recPurchaseHeader);
                PurchaseOrderPage.Run();

            end;
        end else begin
            Error('Status must be released');
        end;
    end;


}
