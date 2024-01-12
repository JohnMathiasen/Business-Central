/// <summary>
/// PageExtension All Objects with Caption_EVAS (ID 50101) extends Record All Objects with Caption.
/// </summary>
pageextension 50101 "All Objects with Caption_EVAS" extends "All Objects with Caption"
{        
    layout
    {
        addbefore(Control1102601000)
        {
            group(LicenseCheck_EVAS)
            {                  
                ShowCaption = false;

                field(LicenseCtrl_EVAS; LicenseText)
                {
                    Caption = 'License', Comment = 'DAN="Licens"';
                    ToolTip = 'License', Comment = 'DAN="Licens"';
                    MultiLine = true;
                    ApplicationArea = All;
                    Editable = false;
                    Visible = PerformLicenseCheck;
                }
            }
        }
        addafter("Object Name")
        {

            field(ObjectUsed_EVAS; ObjectUsed)
            {
                Caption = 'Used', Comment = 'DAN="Anvendt"';
                ApplicationArea = all;
                Editable = false;
                Visible = PerformLicenseCheck;
            }
        }
        modify("Object Subtype")
        {
            Visible = true;
            Caption = 'Licensed', Comment = 'DAN="Licensieret"';
        }
        modify("Object Caption")
        {
            Visible = not PerformLicenseCheck;
        }
        modify("App Name")
        {
            Visible = not PerformLicenseCheck;
        }
    }

    actions
    {
        addlast(Processing)
        {
            action(GetSourceApp_EVAS)
            {
                Caption = 'Download App source file', Comment = 'DAN="Gem App filer"';
                ToolTip = 'Download App source file', Comment = 'DAN="Gem App filer"';
                ApplicationArea = all;
                Image = Download;
                trigger OnAction()
                begin
                    GetAppSource(Rec);
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        if rec. FindFirst() then begin
            SetPerformLicenseCheck();
            LicenseText := GetLicenseinfo();
        end;

    end;
    trigger OnAfterGetRecord()
    var
    begin
        SetPerformLicenseCheck();
        if PerformLicenseCheck then
            ObjectUsed := Rec."Object Name" <> '';
    end;

    var
        ObjectUsed, PerformLicenseCheck : Boolean;
        LicenseText: Text;

    local procedure SetPerformLicenseCheck()
    var
        CompanyInformationPage: Page "Company Information";
    begin
        PerformLicenseCheck := (Rec."Object Subtype" = CompanyInformationPage.GetLicensedTxt()) or (Rec."Object Subtype" = CompanyInformationPage.GetNotLicensedTxt())
    end;

    local procedure GetLicenseinfo(): Text
    var
        LicenseInformation: Record "License Information";
        LicText: Text;
        CR, LF : Char;
    begin
        CR := 13;
        LF := 10;
        if LicenseInformation.FindSet(false, false) then
            repeat
                LicText += LicenseInformation.Text + format(CR) + Format(LF);
            until LicenseInformation.Next() = 0;
        exit(LicText);
    end;

    local procedure GetAppSource(AllObjWithCaption: Record AllObjWithCaption)
    var
        ExtensionManagement: Codeunit "Extension Management";
    begin
        ExtensionManagement.DownloadExtensionSource(AllObjWithCaption."App Package ID");
    end;
}
