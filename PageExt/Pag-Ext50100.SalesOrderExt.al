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
                Editable = false;
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
                Editable = false;
            }
            field("Vendor Total Cost Order"; Rec."Vendor Total Cost Order")
            {
                ApplicationArea = All;
            }
            field("Vendor Reference Id"; Rec."Vendor Reference Id")
            {
                ApplicationArea = All;
            }
            field("Order Submitted By"; Rec."Order Submitted By")
            {
                ApplicationArea = All;
                Editable = false;
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
        modify(Release)
        {
            trigger OnBeforeAction()
            var
                SalesLine: Record "Sales Line";
            begin
                SalesLine.SetRange("Document No.", Rec."No.");
                if SalesLine.FindSet() then begin
                    repeat
                        SalesLine.TestField("Shortcut Dimension 2 Code");
                    until SalesLine.Next() = 0;
                end;
            end;
        }
    }


    var

        Vendor_Rec: Record Vendor;
        PurCodeunit: Codeunit "Purch.-Get Drop Shpt.";

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
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        Vendor: Record Vendor;
        RequisitionLine: Record "Requisition Line";
        PurchDocFromSalesDoc1: Codeunit "Purch. Doc. From Sales Doc.";
        Email: Codeunit Email;
        MAIL: Codeunit Mail;
        EmailMeassge: Codeunit "Email Message";
        RegardsDetails: Text;
        Recepients1: text;
        Subject: Text;
        Body: Text;
        Recepients: List of [Text];
        UserSetup: Record "User Setup";
    begin
        if Rec.Status = Status::Released then begin
            if Rec."Drop Shipment" = true then begin
                recPurchaseHeader.Reset();
                Rec.TestField("Vendor No.");
                if Rec."Purchase Order No." = '' then begin
                    recPurchaseHeader.Init();
                    recPurchaseHeader."Document Type" := recPurchaseHeader."Document Type"::Order;
                    NoSeriesMgt.InitSeries(recPurchaseHeader.GetNoSeriesCode, recPurchaseHeader."No. Series", 0D, recPurchaseHeader."No.", recPurchaseHeader."No. Series");
                    recPurchaseHeader."Buy-from Vendor No." := Rec."Vendor No.";
                    recPurchaseHeader."Buy-from Vendor Name" := Rec."Vendor Name";
                    Vendor.get(recPurchaseHeader."Buy-from Vendor No.");
                    recPurchaseHeader."Buy-from Address" := Vendor.Address;
                    recPurchaseHeader."Buy-from Address 2" := Vendor."Address 2";
                    recPurchaseHeader."Buy-from City" := Vendor.City;
                    recPurchaseHeader."Buy-from County" := Vendor.County;
                    recPurchaseHeader."Buy-from Country/Region Code" := Vendor."Country/Region Code";
                    recPurchaseHeader."Buy-from Contact No." := Vendor.Contact;
                    recPurchaseHeader."Buy-from Contact" := Vendor.Contact;
                    recPurchaseHeader."Prepayment %" := Vendor."Prepayment %";
                    recPurchaseHeader."Payment Terms Code" := Vendor."Payment Terms Code";
                    recPurchaseHeader."Prepmt. Payment Terms Code" := Vendor."Payment Terms Code";
                    recPurchaseHeader."Gen. Bus. Posting Group" := Vendor."Gen. Bus. Posting Group";
                    recPurchaseHeader."Payment Method Code" := Vendor."Payment Method Code";
                    recPurchaseHeader."Tax Area Code" := Vendor."Tax Area Code";
                    recPurchaseHeader."Tax Liable" := Vendor."Tax Liable";
                    recPurchaseHeader."Vendor Posting Group" := Vendor."Vendor Posting Group";
                    recPurchaseHeader."Invoice Disc. Code" := Vendor."Invoice Disc. Code";
                    recPurchaseHeader."IRS 1099 Code" := Vendor."IRS 1099 Code";

                    recPurchaseHeader."Pay-to Address" := Vendor.Address;
                    recPurchaseHeader."Pay-to Address 2" := Vendor."Address 2";
                    recPurchaseHeader."Pay-to City" := Vendor.City;
                    recPurchaseHeader."Pay-to County" := Vendor.County;
                    recPurchaseHeader."Pay-to Country/Region Code" := Vendor."Country/Region Code";
                    recPurchaseHeader."Pay-to Contact No." := Vendor.Contact;
                    recPurchaseHeader."Pay-to Contact" := Vendor.Contact;
                    recPurchaseHeader."Document Date" := Today;
                    recPurchaseHeader."Posting Date" := Today;
                    recPurchaseHeader."Due Date" := Today;
                    recPurchaseHeader."Deal Name" := Rec."Deal Name";
                    recPurchaseHeader."Remark 1" := Rec."Remark 1";
                    recPurchaseHeader."Remark 2" := Rec."Remark 2";
                    recPurchaseHeader."Pay-to Vendor No." := Rec."Vendor No.";

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
                    recPurchaseHeader."Sales Order No." := Rec."No.";
                    recPurchaseHeader."Service Period" := Rec."Service Period";
                    recPurchaseHeader."Doc. No. Occurrence" := 1;
                    recPurchaseHeader."Sales Order No." := Rec."No.";
                    recPurchaseHeader.Insert();
                    Rec."Purchase Order No." := recPurchaseHeader."No.";
                    Rec.Modify();
                    RecSalesLine.SetRange("Document No.", Rec."No.");

                    if RecSalesLine.FindSet() then begin
                        repeat

                            RecPurchaseLines.Init();
                            RecPurchaseLines."Document No." := recPurchaseHeader."No.";
                            RecPurchaseLines."Line No." := RecSalesLine."Line No.";
                            RecPurchaseLines."Document Type" := RecPurchaseLines."Document Type"::Order;
                            RecPurchaseLines."Gen. Bus. Posting Group" := RecSalesLine."Gen. Bus. Posting Group";

                            CopyDocMgt.TransfldsFromSalesToPurchLine(RecSalesLine, RecPurchaseLines);
                            RecPurchaseLines."Sales Order No." := RecSalesLine."Document No.";
                            RecPurchaseLines."Sales Order Line No." := RecSalesLine."Line No.";
                            RecPurchaseLines."Drop Shipment" := true;
                            RecPurchaseLines.Insert();
                            RecSalesLine."Purchase Order No." := RecPurchaseLines."Document No.";
                            RecSalesLine."Purch. Order Line No." := RecPurchaseLines."Line No.";
                            RecSalesLine.Modify()


                        until RecSalesLine.Next() = 0;

                    end;

                    Recepients.Add('himani.p@shaligraminfotech.com');
                    Subject := 'Hello,<br>This is system generated meassege please do not reply to this email.';
                    EmailMeassge.Create(Recepients, 'Test Email', Subject, true);
                    Email.Send(EmailMeassge, Enum::"Email Scenario"::Default);
                    Message('Email Sent');
                    Clear(PurchaseOrderPage);
                    PurchaseOrderPage.SetTableView(recPurchaseHeader);
                    PurchaseOrderPage.SetRecord(recPurchaseHeader);
                    PurchaseOrderPage.Run();


                end else
                    Error('P.O is already created for this sales order and the number is', '%1', Rec."No.");

            end;

        end else begin
            Error('Status must be release');
        end;



    end;

    var


}
