/// <summary>
/// Table Calender Email Recipient_EVAS (ID 50301).
/// </summary>
table 50301 "Calender Email Recipient_EVAS"
{
    Caption = 'Calender Email Recipient', Comment = 'DAN="Kalender mail modtagere"';
    LookupPageId = "Calender Email Recipients_EVAS";
    DrillDownPageId = "Calender Email Recipients_EVAS";
    fields
    {
        field(1; "Calender Entry UID"; Guid)
        {
            Caption = 'Calender Entry UID', Comment = 'DAN="Kalenderpost UID"';
            DataClassification = SystemMetadata;
            TableRelation = "Outlook Calender Entry_EVAS".Id;
        }

        field(2; "E-Mail Address"; Text[250])
        {
            Caption = 'E-mail Address', Comment = 'DAN="E-mail adresse"';
            DataClassification = CustomerContent;
        }

        field(3; "Email Recipient Type"; Enum "Email Recipient Type")
        {
            Caption = 'Email Recipient Type', Comment = 'DAN="Mailmodtage type"';
            DataClassification = CustomerContent;
        }
        field(4; Name; Text[250])
        {
            Caption = 'Name', Comment = 'DAN="Navn"';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Calender Entry UID", "E-Mail Address", "Email Recipient Type")
        {
            Clustered = true;
        }
    }
}