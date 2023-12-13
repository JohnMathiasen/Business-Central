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

                field(FilterInLicense_EVAS; FilterNotInLicense)
                {
                    Caption = 'Show';
                    trigger OnValidate()
                    begin
                        if FilterNotInLicense then
                            Rec.SetFilter("Object Subtype", '=%1', '')
                        else
                            Rec.SetRange("Object Subtype");
                    end;
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
            field(InLicense_EVAS; InLicense)
            {
                Caption = 'In License', Comment = 'DAN="I licens"';
                ApplicationArea = all;
                Editable = false;
                Visible = PerformLicenseCheck;
            }
        }
        modify("Object Subtype")
        {
            Visible = not PerformLicenseCheck;
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
    trigger OnOpenPage()
    begin
        if rec. FindFirst() then begin
            PerformLicenseCheck := Rec."Object Subtype" = 'Lic';
            LicenseText := GetLicenseinfo();
        end;
    

    end;
    trigger OnAfterGetRecord()
    begin
        PerformLicenseCheck := Rec."Object Subtype" = 'Lic';
        if PerformLicenseCheck then begin
            ObjectUsed := Rec."Object Name" <> '';
            InLicense := Permitted();
        end;

    end;

    var
        ObjectUsed, InLicense, PerformLicenseCheck, FilterNotInLicense : Boolean;
        LicenseText: Text;


    internal procedure SetLicenseCheckFields(EnableFields: Boolean)
    begin
        PerformLicenseCheck := EnableFields;
    end;

    local procedure Permitted(): Boolean
    var
        LicensePermission: Record "License Permission";
    begin
        LicensePermission.Get(Rec."Object Type",Rec."Object ID");
        exit((LicensePermission."Read Permission" in [LicensePermission."Read Permission"::Yes, LicensePermission."Insert Permission"::Yes, LicensePermission."Modify Permission"::Yes, LicensePermission."Delete Permission"::Yes, LicensePermission."Execute Permission"::Yes]));
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

}
