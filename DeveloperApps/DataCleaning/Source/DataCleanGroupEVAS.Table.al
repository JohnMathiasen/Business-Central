table 50105 "Data Clean Group_EVAS"
{
    Caption = 'Data Clean Group', Comment = 'DAN="Datavask Gruppe"';
    DataClassification = CustomerContent;
    LookupPageId = "Data Clean Groups_EVAS";
    DrillDownPageId = "Data Clean Groups_EVAS";

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
