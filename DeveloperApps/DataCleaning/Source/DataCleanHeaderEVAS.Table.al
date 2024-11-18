table 50100 "Data Clean Header_EVAS"
{
    Caption = 'Data Clean Header', Comment = 'DAN="Datavaskhoved"';
    DataClassification = CustomerContent;
    LookupPageId = "Data Clean Documents_EVAS";
    DrillDownPageId = "Data Clean Documents_EVAS";

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
