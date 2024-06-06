/// <summary>
/// Table BlueIdea SMS Steup_EVAS (ID 52001).
/// </summary>
table 52001 "BlueIdea SMS Setup_EVAS"
{

    Caption = 'BlueIdea SMS Setup', Comment = 'DAN="BlueIdea SMS Opsætning"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[50])
        {
            Caption = 'Code', Comment = 'DAN="Kode"';
        }
        field(2; "Test Mode"; Boolean)
        {
            Caption = 'Test mode', Comment = 'DAN="Testtilstand"';
        }
        field(4; "Name of Sender"; Text[11])
        {
            Caption = 'Navn ved afsendelse', Comment = 'DAN="Navn ved afsendelse"';
        }
        field(5; Username; Text[250])
        {
            Caption = 'User Name', Comment = 'DAN="Brugernavn"';
        }
        field(6; Password; Blob)
        {
            Caption = 'Password', Comment = 'DAN="Kodeord"';
        }
        field(7; "BlueIdea Profile ID"; Code[10])
        {
            Caption = 'BlueIdea Profile ID', Comment = 'DAN="BlueIdea profil ID"';
        }
        field(8; "Access Token Endpoint"; Text[250])
        {
            Caption = 'Accecss Token Endpoint', Comment = 'DAN="Adgangstoken Endpoint"';
        }
        field(9; Endpoint; Text[250])
        {
            Caption = 'Endpoint', Comment = 'DAN="Endpoint"';
        }

    }
    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }

    // internal procedure Iniitialize()
    // begin
    //     if not Get() then begin
    //         Init();
    //         "Access Token Endpoint" := GetRequestAcessTokenUri();
    //         Endpoint := GetRequestSendSMSUri();
    //         Insert();
    //     end;
    // end;

    internal procedure SetPassword(Value: Text)
    var
        OutStream: OutStream;
    begin
        Password.CreateOutStream(OutStream);
        OutStream.WriteText(Value);
    end;

    [NonDebuggable]
    internal procedure GetPassword(): Text
    var
        UserPassword: InStream;
        PassWord2: Text;
    begin
        CalcFields(PassWord);
        if PassWord.HasValue then begin
            PassWord.CreateInStream(UserPassword);
            UserPassword.ReadText(PassWord2);
            exit(PassWord2);
        end else
            exit('')
    end;

    internal procedure GetRequestAcessTokenUri(): Text[250]
    begin
        exit('https://api.sms-service.dk/User/Login');
    end;

    internal procedure GetRequestSendSMSUri(): Text[250]
    begin
        exit('https://api.sms-service.dk/Message/SendSingle');
    end;
}