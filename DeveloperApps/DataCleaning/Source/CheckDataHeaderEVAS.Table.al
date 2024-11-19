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
        field(5; "Data Clean Group Code"; Code[10])
        {
            Caption = 'Data Clean Group Code', Comment = 'DAN="Datavaskgruppekode"';
            TableRelation = "Check Data Group_EVAS"."Code";
        }
        field(7; Type; Enum "Check Data Type_EVAS")
        {
            Caption = 'Type', Comment = 'DAN="Type"';
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
