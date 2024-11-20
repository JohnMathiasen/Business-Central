table 50100 "Check Data Header_EVAS"
{
    Caption = 'Check Data Header', Comment = 'DAN="Datakontrolhoved"';
    DataClassification = CustomerContent;
    LookupPageId = "Check Data Documents_EVAS";
    DrillDownPageId = "Check Data Documents_EVAS";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code', Comment = 'DAN="Kode"';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description', Comment = 'DAN="Beskrivelse"';
        }
        field(3; "Table No."; Integer)
        {
            Caption = 'Table No.', Comment = 'DAN="Tabelnr."';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));
        }
        field(5; "Check Data Group Code"; Code[10])
        {
            Caption = 'Check Data Group Code', Comment = 'DAN="Datakontrolgruppekode"';
            TableRelation = "Check Data Group_EVAS"."Code";
        }
        field(7; Type; Enum "Check Data Type_EVAS")
        {
            Caption = 'Type', Comment = 'DAN="Type"';
            trigger OnValidate()
            var
                CheckDataLine: Record "Check Data Line_EVAS";
                DeleteLinesLbl: Label 'Do you want to delete Lines for %1 %2', Comment = 'DAN="Vil du slette linjer for %1 %2"';
            begin
                if Type <> xRec."Type" then begin
                    CheckDataLine.SetRange("Code", Code);
                    if not CheckDataLine.iseMpty then
                        if confirm(DeleteLinesLbl, false, Rec.TableCaption, Rec.Code) then
                            CheckDataLine.DeleteAll(true);
                end;
            end;
        }
        field(10; Enabled; Boolean)
        {
            Caption = 'Enabled', Comment = 'DAN="Aktiv"';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
