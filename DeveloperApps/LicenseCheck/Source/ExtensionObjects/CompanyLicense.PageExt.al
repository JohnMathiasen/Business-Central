/// <summary>
/// PageExtension Company License_EVAS (ID 50149) extends Record Company Information.
/// </summary>
pageextension 50149 "Company License_EVAS" extends "Company Information"
{
    layout
    {
        addafter("User Experience")
        {
            group(LicenseCheck_EVAS)
            {
                Caption = 'License', Comment = 'DAN="Licens"';

                field(LicenseCtrl_EVAS; LicenseText)
                {
                    Caption = 'License', Comment = 'DAN="Licens"';
                    ToolTip = 'License', Comment = 'DAN="Licens"';
                    MultiLine = true;
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    actions
    {

        addlast(Processing)
        {
            group(CheckLicense_EVAS)
            {
                Caption = 'Check License', Comment = 'DAN="Tjek Licens"';

                action(License_EVAS)
                {
                    ApplicationArea = all;
                    Caption = 'Show License', Comment = 'DAN="Vis licens"';
                    ToolTip = 'Show License', Comment = 'DAN="Vis licens"';
                    Image = Process;
                    trigger OnAction()
                    begin
                        if LicenseText = '' then
                            LicenseText := GetLicenseinfo();
                        CurrPage.Activate(true);
                    end;
                }
                action(FindUsed_EVAS)
                {
                    ApplicationArea = all;
                    Caption = 'Find Used', Comment = 'DAN="Find anvendte"';
                    ToolTip = 'Find Used', Comment = 'DAN="Find anvendte"';
                    Image = Process;
                    trigger OnAction()
                    begin
                        ProcessFind(ObjSearchType::Used);
                    end;
                }
                action(FindUnused_EVAS)
                {
                    ApplicationArea = all;
                    Caption = 'Find Unused', Comment = 'DAN="Find ledige"';
                    ToolTip = 'Find Unused', Comment = 'DAN="Find ledige"';
                    Image = Process;
                    trigger OnAction()
                    begin
                        ProcessFind(ObjSearchType::Free);
                    end;
                }
                action(FindAll_EVAS)
                {
                    ApplicationArea = all;
                    Caption = 'Find All', Comment = 'DAN="Find alle"';
                    ToolTip = 'Find All', Comment = 'DAN="Find alle"';
                    Image = Process;
                    trigger OnAction()
                    begin
                        ProcessFind(ObjSearchType::All);
                    end;
                }
                action(FindApp_EVAS)
                {
                    ApplicationArea = all;
                    Caption = 'Show App Objects', Comment = 'DAN="Vis App objekter"';
                    ToolTip = 'Show App Objects', Comment = 'DAN="Vis App objekter"';
                    Image = Process;
                    trigger OnAction()
                    begin
                        ProcessAppFind();
                    end;
                }
            }
        }
    }


    var
        Window: Dialog;
        ObjecttypeFilterTxt: Label 'Table|Report|Codeunit|XMLport|Page|Query|PageExtension|TableExtension|ReportExtension';
        PctTxt: Label '%1 Pct.', Comment = '%1= Percentage';
        ObjSearchType: Option All,Used,Free;
        LicenseText: Text;

    local procedure ProcessFind(ObjSearch: Option All,Used,Free)
    var
        TempAllObjWithCaption: Record AllObjWithCaption temporary;
        LicensePermissionView: Text;
    begin
        if not RunFilterPage(LicensePermissionView) then
            exit;

        TempAllObjWithCaption.DeleteAll();

        FindObjects(ObjSearch, TempAllObjWithCaption, LicensePermissionView);

        ShowObjects(TempAllObjWithCaption);
    end;

    local procedure ProcessAppFind()
    var
        AllObjWithCaption: Record AllObjWithCaption;
        TempAllObjWithCaption: Record AllObjWithCaption temporary;
        AppNotFoundErr: Label 'An app with %1 %2 is not installed', Comment = 'DAN="En app med %1 %2 er ikke installeret"';
        BlankAppErr: Label 'You must Select an App', Comment = 'DAN="Du skal vælge en App"';
        SelectOneAppErr: Label 'You can only select one app', Comment = 'DAN="Du kan kun vælge en app"';
        LicensePermissionView: Text;
        FilterObjErr: Label 'There´s no object within the filter', Comment = 'DAN="Der er ingen objekter indfor filteret"';
    begin
        if not RunAppFilterPage(LicensePermissionView) then
            exit;

        AllObjWithCaption.SetView(LicensePermissionView);
        if AllObjWithCaption.GetFilter("App Package ID") = '' then
            Error(BlankAppErr);
        if AllObjWithCaption.GetRangeMin("App Package ID") <> AllObjWithCaption.GetRangeMin("App Package ID") then
            Error(SelectOneAppErr);
        if not AppExist(AllObjWithCaption) then
            Error(AppNotFoundErr, AllObjWithCaption.FieldCaption("App Package ID"), AllObjWithCaption.GetFilter("App Package ID"));

        if not AllObjWithCaption.FindFirst() then
            Error(FilterObjErr);

        TempAllObjWithCaption.DeleteAll();

        FindAppObjects(AllObjWithCaption."App Package ID", TempAllObjWithCaption, LicensePermissionView);

        ShowObjects(TempAllObjWithCaption);
    end;

    local procedure RunFilterPage(var ObjectInLicenseView: Text): Boolean
    var
        LicensePermission: Record "License Permission";
        FilterPage: FilterPageBuilder;
    begin
        ObjectInLicenseView := LicensePermission.GetView();
        SetObjectInLicenseFilterPage(FilterPage);

        if FilterPage.RunModal() then begin
            ObjectInLicenseView := FilterPage.GetView(LicensePermission.TableCaption);
            exit(true);
        end;
    end;

    local procedure SetObjectInLicenseFilterPage(var FilterPage2: FilterPageBuilder)
    var
        LicensePermission: Record "License Permission";
    begin
        FilterPage2.AddTable(LicensePermission.TableCaption, Database::"License Permission");
        FilterPage2.AddField(LicensePermission.TableCaption, LicensePermission."Object Type");
        FilterPage2.AddField(LicensePermission.TableCaption, LicensePermission."Object Number");
    end;

    local procedure RunAppFilterPage(var ObjectInLicenseView: Text): Boolean
    var
        AllObjWithCaption: Record AllObjWithCaption;
        FilterPage: FilterPageBuilder;
    begin
        ObjectInLicenseView := AllObjWithCaption.GetView();
        SetAppObjectInLicenseFilterPage(FilterPage);

        if FilterPage.RunModal() then begin
            ObjectInLicenseView := FilterPage.GetView(AllObjWithCaption.TableCaption);
            exit(true);
        end;
    end;

    local procedure SetAppObjectInLicenseFilterPage(var FilterPage2: FilterPageBuilder)
    var
        AllObjWithCaption: Record AllObjWithCaption;
    begin
        FilterPage2.AddTable(AllObjWithCaption.TableCaption, Database::AllObjWithCaption);
        FilterPage2.AddField(AllObjWithCaption.TableCaption, AllObjWithCaption."App Package ID");
        FilterPage2.AddField(AllObjWithCaption.TableCaption, AllObjWithCaption."Object Type");
        FilterPage2.AddField(AllObjWithCaption.TableCaption, AllObjWithCaption."Object ID");
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

    local procedure FindObjects(ObjSearch: Option All,Used,Free; var TempAllObjWithCaption: Record AllObjWithCaption temporary; LicensePermissionView: Text)
    var
        AllObjWithCaption: Record AllObjWithCaption;
        LicensePermission: Record "License Permission";
        NoofRecords, Counter, Step : Integer;
    begin
        if LicensePermissionView <> '' then begin
            LicensePermission.SetView(LicensePermissionView);
            if LicensePermission.GetFilter("Object Type") = '' then
                LicensePermission.SetFilter("Object Type", ObjecttypeFilterTxt);
        end else
            LicensePermission.SetFilter("Object Type", ObjecttypeFilterTxt);

        NoofRecords := LicensePermission.Count;
        Step := StartProgressIndicator(NoofRecords);
        if LicensePermission.FindSet() then
            repeat
                Counter += 1;
                ShowProgressIndicator(NoofRecords, Counter, Step);
                TempAllObjWithCaption.Init();
                TempAllObjWithCaption."Object ID" := LicensePermission."Object Number";
                TempAllObjWithCaption."Object Type" := LicensePermission."Object Type";

                if GetAllObjectWithPermission(LicensePermission, AllObjWithCaption) then begin
                    TempAllObjWithCaption."Object Name" := AllObjWithCaption."Object Name";
                    TempAllObjWithCaption."App Package ID" := AllObjWithCaption."App Package ID";
                    TempAllObjWithCaption."App Runtime Package ID" := AllObjWithCaption."App Runtime Package ID";
                end;

                case ObjSearch of
                    ObjSearch::Free:
                        if Permitted(LicensePermission) and (TempAllObjWithCaption."Object Name" = '') then
                            TempAllObjWithCaption."Object Subtype" := GetLicensedTxt()
                        else
                            TempAllObjWithCaption."Object Subtype" := GetNotLicensedTxt();
                    ObjSearch::Used:
                        if Permitted(LicensePermission) and (TempAllObjWithCaption."Object Name" <> '') then
                            TempAllObjWithCaption."Object Subtype" := GetLicensedTxt()
                        else
                            TempAllObjWithCaption."Object Subtype" := GetNotLicensedTxt();
                    ObjSearch::All:
                        if Permitted(LicensePermission) then
                            TempAllObjWithCaption."Object Subtype" := GetLicensedTxt()
                        else
                            TempAllObjWithCaption."Object Subtype" := GetNotLicensedTxt();
                end;
                TempAllObjWithCaption.Insert();

            until LicensePermission.Next() = 0;
        CloseProgressIndicator(NoofRecords, Counter);
    end;

    local procedure FindAppObjects(PackageID: Guid; var TempAllObjWithCaption: Record AllObjWithCaption temporary; LicensePermissionView: Text)
    var
        AllObjWithCaption: Record AllObjWithCaption;
        LicensePermission: Record "License Permission";
        NoofRecords, Counter, Step : Integer;
    begin
        if LicensePermissionView <> '' then begin
            AllObjWithCaption.SetView(LicensePermissionView);
            if AllObjWithCaption.GetFilter("Object Type") = '' then
                AllObjWithCaption.SetFilter("Object Type", ObjecttypeFilterTxt);
        end else
            AllObjWithCaption.SetFilter("Object Type", ObjecttypeFilterTxt);

        NoofRecords := AllObjWithCaption.Count;
        Step := StartProgressIndicator(NoofRecords);

        AllObjWithCaption.SetRange("App Package ID", PackageID);
        if AllObjWithCaption.FindSet() then
            repeat
                Counter += 1;
                ShowProgressIndicator(NoofRecords, Counter, Step);

                if GetLicensePermission(AllObjWithCaption, LicensePermission) then begin
                    TempAllObjWithCaption.Init();
                    TempAllObjWithCaption."Object ID" := LicensePermission."Object Number";
                    TempAllObjWithCaption."Object Type" := LicensePermission."Object Type";
                    TempAllObjWithCaption."Object Name" := AllObjWithCaption."Object Name";
                    TempAllObjWithCaption."App Package ID" := AllObjWithCaption."App Package ID";
                    TempAllObjWithCaption."App Runtime Package ID" := AllObjWithCaption."App Runtime Package ID";
                    if Permitted(LicensePermission) then
                        TempAllObjWithCaption."Object Subtype" := GetLicensedTxt()
                    else
                        TempAllObjWithCaption."Object Subtype" := GetNotLicensedTxt();
                    TempAllObjWithCaption.Insert();
                end;
            until AllObjWithCaption.Next() = 0;

        CloseProgressIndicator(NoofRecords, Counter);
    end;

    local procedure GetAllObjectWithPermission(LicensePermission: Record "License Permission"; var AllObjWithCaption1: Record AllObjWithCaption): Boolean
    begin
        exit(AllObjWithCaption1.Get(GetObjTypeAllObjWithCaption(LicensePermission), LicensePermission."Object Number"));
    end;

    local procedure GetLicensePermission(AllObjWithCaption1: Record AllObjWithCaption; var LicensePermission: Record "License Permission"): Boolean
    begin
        exit(LicensePermission.Get(GetObjTypeLicensePermission(AllObjWithCaption1), AllObjWithCaption1."Object ID"));
    end;

    local procedure GetObjTypeAllObjWithCaption(LicensePermission: Record "License Permission"): option TableData,Table,,Report,,Codeunit,XMLport,MenuSuite,Page,Query,System,FieldNumber,,,"PageExtension","TableExtension",Enum,EnumExtension,Profile,"ProfileExtension",PermissionSet,PermissionSetExtension,ReportExtension
    var
        AllObjWithCaption1: Record AllObjWithCaption;
    begin
        case LicensePermission."Object Type" of
            LicensePermission."Object Type"::Table:
                exit(AllObjWithCaption1."Object Type"::Table);
            LicensePermission."Object Type"::Report:
                exit(AllObjWithCaption1."Object Type"::Report);
            LicensePermission."Object Type"::Codeunit:
                exit(AllObjWithCaption1."Object Type"::Codeunit);
            LicensePermission."Object Type"::XMLport:
                exit(AllObjWithCaption1."Object Type"::XMLport);
            LicensePermission."Object Type"::Page:
                exit(AllObjWithCaption1."Object Type"::Page);
            LicensePermission."Object Type"::Query:
                exit(AllObjWithCaption1."Object Type"::Query);
            LicensePermission."Object Type"::"PageExtension":
                exit(AllObjWithCaption1."Object Type"::"PageExtension");
            LicensePermission."Object Type"::"TableExtension":
                exit(AllObjWithCaption1."Object Type"::"TableExtension");
            LicensePermission."Object Type"::ReportExtension:
                exit(AllObjWithCaption1."Object Type"::ReportExtension);
        end;
    end;

    local procedure GetObjTypeLicensePermission(AllObjWithCaption: Record AllObjWithCaption): option TableData,Table,,Report,,Codeunit,XMLport,MenuSuite,Page,Query,System,FieldNumber,,,"PageExtension","TableExtension",Enum,EnumExtension,Profile,"ProfileExtension",PermissionSet,PermissionSetExtension,ReportExtension
    var
        LicensePermission: Record "License Permission";
    begin
        case AllObjWithCaption."Object Type" of
            AllObjWithCaption."Object Type"::Table:
                exit(LicensePermission."Object Type"::Table);
            AllObjWithCaption."Object Type"::Report:
                exit(LicensePermission."Object Type"::Report);
            AllObjWithCaption."Object Type"::Codeunit:
                exit(LicensePermission."Object Type"::Codeunit);
            AllObjWithCaption."Object Type"::XMLport:
                exit(LicensePermission."Object Type"::XMLport);
            AllObjWithCaption."Object Type"::Page:
                exit(LicensePermission."Object Type"::Page);
            AllObjWithCaption."Object Type"::Query:
                exit(LicensePermission."Object Type"::Query);
            AllObjWithCaption."Object Type"::"PageExtension":
                exit(LicensePermission."Object Type"::"PageExtension");
            AllObjWithCaption."Object Type"::"TableExtension":
                exit(LicensePermission."Object Type"::"TableExtension");
            AllObjWithCaption."Object Type"::ReportExtension:
                exit(LicensePermission."Object Type"::ReportExtension);
        end;
    end;

    internal procedure Permitted(LicensePermission: Record "License Permission"): Boolean
    begin
        if (LicensePermission."Read Permission" = LicensePermission."Read Permission"::" ") and
            (LicensePermission."Execute Permission" = LicensePermission."Execute Permission"::" ") and
            (LicensePermission."Insert Permission" = LicensePermission."Insert Permission"::" ") then
            exit(false)
        else
            exit(true);
    end;

    local procedure StartProgressIndicator(NoofRecords: Integer): Integer
    var
        WindowTxt: Label 'Progress #1############', Comment = 'DAN="Gennemløber #1############"';
    begin
        Window.Open(WindowTxt);
        Window.Update(1, StrSubstNo(PctTxt, 0));
        if NoOfRecords < 100 then
            exit(1);

        exit(NoOfRecords div 100);
    end;

    local procedure ShowProgressIndicator(NoofRecords: Integer; Counter: Integer; Step: Integer)
    var
        Pct, Remainder : Decimal;
    begin
        Pct := round(100 * Counter / NoofRecords, 1);
        Remainder := Counter mod Step;
        if Remainder = 0 then
            Window.Update(1, StrSubstNo(PctTxt, Pct));
    end;

    local procedure CloseProgressIndicator(NoofRecords: Integer; Counter: Integer)
    begin
        if Counter = NoofRecords then
            Window.Close();
    end;

    local procedure ShowObjects(var TempAllObjWithCaption: Record AllObjWithCaption temporary)
    var
        NoObjectsErr: Label 'Did not find any objects within the filter', Comment = 'DAN="Der blev ikke fundet objekter indenfor filteret."';
    begin
        TempAllObjWithCaption.Reset();
        if TempAllObjWithCaption.IsEmpty then begin
            Message(NoObjectsErr);
            exit;
        end;

        TempAllObjWithCaption.FindFirst();
        Page.RunModal(Page::"All Objects with Caption", TempAllObjWithCaption);
    end;

    local procedure AppExist(var AllObjWithCaption: Record AllObjWithCaption): Boolean
    var
        AllObjWithCaption2: Record AllObjWithCaption;
    begin
        AllObjWithCaption2.SetFilter("App Package ID", AllObjWithCaption.GetFilter("App Package ID"));
        exit(not AllObjWithCaption2.IsEmpty);
    end;

    internal procedure GetLicensedTxt(): Text[30]
    var
        LicensedTxt: Label 'Yes';
    begin
        exit(LicensedTxt);
    end;

    internal procedure GetNotLicensedTxt(): Text[30]
    var
        NotLicensedTxt: Label 'No';
    begin
        exit(NotLicensedTxt);
    end;

}
