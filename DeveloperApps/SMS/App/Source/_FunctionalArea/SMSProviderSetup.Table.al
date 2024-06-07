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

    }
    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }
}
