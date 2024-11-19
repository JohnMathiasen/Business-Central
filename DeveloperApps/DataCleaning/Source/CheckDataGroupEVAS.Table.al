table 50105 "Check Data Group_EVAS"
{
    Caption = 'Check Data Group', Comment = 'DAN="Datakontrolgruppe"';
    DataClassification = CustomerContent;
    LookupPageId = "Check Data Groups_EVAS";
    DrillDownPageId = "Check Data Groups_EVAS";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code', Comment = 'DAN="Kode"';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description', Comment = 'DAN="Beskrivelse"';
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
