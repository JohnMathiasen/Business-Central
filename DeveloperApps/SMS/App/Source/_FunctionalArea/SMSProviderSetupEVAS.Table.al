/// <summary>
/// Table SMS Setup_EVAS (ID 52001).
/// </summary>
table 52000 "SMS Provider Setup_EVAS"
{
    Caption = 'SMS Provider Setup', Comment = 'DAN="Opsætning af SMS udbyder"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Primary Key', Comment = 'DAN="Primærnøgle"';
        }
        field(2; "SMS Provider"; Enum "SMS Provider_EVAS")
        {
            Caption = 'Interface for Text Messages', Comment = 'DAN="SMS Interface"';
        }
        field(4; "Name of Sender"; Text[11])
        {
            Caption = 'Navn ved afsendelse', Comment = 'DAN="Navn ved afsendelse"';
        }

    }
    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }
}
