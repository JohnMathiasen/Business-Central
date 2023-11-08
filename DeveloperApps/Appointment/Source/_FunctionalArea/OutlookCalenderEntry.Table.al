/// <summary>
/// Table Outlook Calender Entry_EVAS (ID 50300).
/// </summary>
table 50300 "Outlook Calender Entry_EVAS"
{
    Caption = 'Outlook Calender Entry', Comment = 'DAN="Outlook kalenderpost"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; Id; Integer)
        {
            Caption = 'Id', Comment = 'DAN="Id"';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }

        field(2; UID; Guid)
        {
            Caption = 'UID', Comment = 'DAN="UID"';
            DataClassification = CustomerContent;
        }
        field(3; "Account Id"; Guid)
        {
            Caption = '', Comment = 'DAN=""';
            DataClassification = SystemMetadata;
        }

        field(4; Connector; Enum "Email Connector")
        {
            Caption = 'Connector', Comment = 'DAN="Connector"';
            DataClassification = SystemMetadata;
        }
        field(5; Sequence; Integer)
        {
            Caption = 'Sequence', Comment = 'DAN="Sekvens"';
            DataClassification = CustomerContent;
            InitValue = 1;
        }
        field(6; "Record ID"; RecordId)
        {
            Caption = 'Record Id', Comment = 'DAN="Record Id"';
            DataClassification = CustomerContent;
        }
        field(7; Description; Text[250])
        {
            Caption = 'Description', Comment = 'DAN="Beskrivelse"';
            DataClassification = CustomerContent;
        }
        field(10; Body; Blob)
        {
            Caption = 'Body', Comment = 'DAN="Body"';
            DataClassification = CustomerContent;
        }
        field(11; Summery; Text[250])
        {
            Caption = 'Summery', Comment = 'DAN="Resumé"';
            DataClassification = CustomerContent;
        }
        field(12; "Email Scenario"; Enum "Email Scenario")
        {
            Caption = 'Email Scenario', Comment = 'DAN="Email Scenarie"';
            DataClassification = CustomerContent;
        }

        field(15; "Create Appointment"; Boolean)
        {
            Caption = 'Create Appointment', Comment = 'DAN="Opret aftale"';
            DataClassification = CustomerContent;
        }
        field(16; "Cancel Appointment"; Boolean)
        {
            Caption = 'Cancel Appointment', Comment = 'DAN="Annullér aftale"';
            DataClassification = CustomerContent;
        }
        field(20; "From Address"; Text[250])
        {
            Caption = 'From Address', Comment = 'DAN="Fra adresse"';
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                MailManagement: Codeunit "Mail Management";
            begin
                if "From Address" <> '' then
                    MailManagement.CheckValidEmailAddresses("From Address");
            end;
        }
        field(21; "Send to"; Text[250])
        {
            Caption = 'Send to', Comment = 'DAN="Send til"';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Send to" <> '' then
                    CorrectAndValidateEmailList("Send to");
            end;
        }
        field(22; "Send CC"; Text[250])
        {
            Caption = 'Send CC', Comment = 'DAN="Send Cc"';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Send CC" <> '' then
                    CorrectAndValidateEmailList("Send CC");
            end;
        }
        field(23; "Send BCC"; Text[250])
        {
            Caption = 'Send BCC', Comment = 'DAN="Send Bcc"';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                if "Send BCC" <> '' then
                    CorrectAndValidateEmailList("Send BCC");
            end;
        }
        field(30; "Starting Datetime"; DateTime)
        {
            Caption = 'Starting Datetime', Comment = 'DAN="Start datotid"';
            DataClassification = CustomerContent;
        }
        field(31; "Ending Datetime"; DateTime)
        {
            Caption = 'Ending Datetime', Comment = 'DAN="Slut datotid"';
            DataClassification = CustomerContent;
        }
        field(65; Subject; Text[250])
        {
            Caption = 'Subjekt', Comment = 'DAN="Emne"';
            DataClassification = CustomerContent;
        }
        field(66; Location; Text[250])
        {
            Caption = 'Location', Comment = 'DAN="Sted"';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; Id)
        {
            Clustered = true;
        }
        key(Key2; UID)
        {
        }
    }

    trigger OnDelete()
    var
        CalenderEmailRecipient: Record "Calender Email Recipient_EVAS";
    begin
        CalenderEmailRecipient.SetRange("Calender Entry UID", UID);
        CalenderEmailRecipient.DeleteAll(true);
    end;

    /// <summary>
    /// Get the message id of the outbox email.
    /// </summary>
    /// <returns>Message id.</returns>
    procedure GetUID(): Guid
    begin
        exit(Rec.UID);
    end;

    /// <summary>
    /// Get the account id of the outbox email.
    /// </summary>
    /// <returns>Account id.</returns>
    procedure GetAccountId(): Guid
    begin
        exit(Rec."Account Id");
    end;

    /// <summary>
    /// The email connector of the outbox email.
    /// </summary>
    /// <returns>Email connector</returns>
    procedure GetConnector(): Enum "Email Connector"
    begin
        exit(Rec.Connector);
    end;

    local procedure CorrectAndValidateEmailList(var EmailAddresses: Text[250])
    var
        MailManagement: Codeunit "Mail Management";
    begin
        EmailAddresses := ConvertStr(EmailAddresses, ',', ';');
        EmailAddresses := DelChr(EmailAddresses, '<>');
        MailManagement.CheckValidEmailAddresses(EmailAddresses);
    end;

    /// <summary>
    /// AddBody.
    /// </summary>
    /// <param name="MessageBody">Text.</param>
    internal procedure AddBody(MessageBody: Text)
    var
        Outstream: OutStream;
    begin
        Clear(Body);
        Body.CreateOutStream(OutStream);
        OutStream.Write(MessageBody);
    end;
}