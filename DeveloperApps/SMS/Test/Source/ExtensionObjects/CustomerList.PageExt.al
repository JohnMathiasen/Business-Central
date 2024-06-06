/// <summary>
/// PageExtension Customer List_EVAS (ID 50301) extends Record Customer List.
/// </summary>
pageextension 50100 "Customer List_EVAS" extends "Customer List"
{
    actions
    {
        addfirst(processing)
        {
            action(TestSMSAuth_EVAS)
            {
                Caption = 'TEST AUTH';
                ApplicationArea = all;
                Image = TestReport;
                trigger OnAction()
                var
                    ISmsProvider: Interface "ISmsProvider_EVAS";
                    TokenText: Text;
                begin
                    ISmsProvider := Enum::"SMS Provider_EVAS"::Blueidea;
                    TokenText := ISmsProvider.GetAccessToken();
                    Message('Retur : %1', TokenText);
                end;
            }
            action(TestSMS_EVAS)
            {
                Caption = 'TEST SMS';
                ApplicationArea = all;
                Image = TestReport;
                trigger OnAction()
                var
                    ISmsProvider: Interface "ISmsProvider_EVAS";
                    SMSText: Text;
                    RecipientTxt: Text;
                    ReferenceID: Integer;
                    ReturnValue: Text;
                begin
                    SMSText := 'Dette er EV test';
                    RecipientTxt := '+4527271632';
                    ReferenceId := 301;
                    ISmsProvider := Enum::"SMS Provider_EVAS"::Blueidea;
                    ISmsProvider.SendTextMessage(SMSText, RecipientTxt, ReferenceID, ReturnValue);
                    Message('Retur : %1', ReturnValue);
                end;
            }
        }
    }

    // local procedure GetAccessTokenBlueIdea2(): Text
    // var
    //     HttpClient2: Codeunit "Http Client_HCEAV";
    //     InitializeHttpClient: Codeunit "Initialize Http Client_HCEAV";
    //     HttpResponse2: HttpResponseMessage;
    //     Token: Text;
    //     ResponseText: Text;
    //     SendFailureErr: Label 'Unable to request access token. Error Code %1\Message: %2', Comment = 'DAN="Access Token kunne ikke hentes. Fejlkode %1\Besked: %2"';
    //     UserName: Text;
    //     UserPassword: Text;
    //     RequestUri: Text;
    //     ContentTxt: Text;
    // begin
    //     UserName := 'krk@elbek-vejrup.dk';
    //     UserPassword := 'ITA4ever?';
    //     RequestUri := 'https://api.sms-service.dk/User/Login';
    //     ContentTxt := StrSubstNo('{"email":"%1","password":"%2"}', UserName, UserPassword);

    //     HttpClient2.Initialize();
    //     HttpClient2.SetRequestUri(RequestUri);
    //     //HttpClient2.SetMethod('POST');
    //     HttpClient2.SetMethod(Enum::"Http Request Type"::POST);
    //     HttpClient2.SetContent(ContentTxt);

    //     HttpClient2.UpdateContentHeader('Content-type', 'application/json');
    //     HttpClient2.UpdateHeader('Accept', 'text/plain');

    //     if HttpClient2.Send(HttpResponse2) then begin
    //         ReadRequestTokenFromResponse(HttpResponse2, Token);
    //         exit(Token);
    //     end else
    //         if HttpResponse2.Content().ReadAs(ResponseText) then
    //             Error(SendFailureErr, HttpResponse2.HttpStatusCode(), ResponseText)
    //         else
    //             Error(SendFailureErr, HttpResponse2.HttpStatusCode(), 'Could not read response');
    //     exit('');
    // end;

    // local procedure ReadRequestTokenFromResponse(Response: HttpResponseMessage; var Token: Text)
    // var
    //     ContentJSON: JsonObject;
    //     JSON: JsonToken;
    //     AccessTokenLbl: Label 'accessToken', Locked = true;
    //     ContentText: Text;
    // begin
    //     Token := '';
    //     Response.Content().ReadAs(ContentText);
    //     ContentJSON.ReadFrom(ContentText);
    //     ContentJSON.Get(AccessTokenLbl, JSON);
    //     Token := JSON.AsValue().AsText();
    // end;

    // local procedure SendTextMessage(MessageText: Text; Recipient: Text): Integer;
    // var
    //     HttpClient: Codeunit "Http Client_HCEAV";
    //     BearerLbl: Label 'Bearer %1', Locked = true;
    //     HttpResponse: HttpResponseMessage;
    //     AccessTokentxt: Text;
    //     RequestUri: Text;
    //     RequestBody: Text;
    //     BlueIdeaProfileID: Code[10];
    //     ReferenceId: Integer;
    //     TestMode: Text;
    //     NameofSender: Text;
    //     ResponseText: Text;
    //     SendFailureErr: Label 'Unable to request access token. Error Code %1\Message: %2', Comment = 'DAN="Access Token kunne ikke hentes. Fejlkode %1\Besked: %2"';
    //     TokenTxt: Text;
    // begin
    //     RequestUri := 'https://api.sms-service.dk/Message/SendSingle';
    //     BlueIdeaProfileID := '5221';
    //     NameofSender := 'Forsyning';
    //     testMode := 'false';
    //     ReferenceId := 301;
    //     AccessTokentxt := StrSubstNo(BearerLbl, GetAccessTokenBlueIdea2());
    //     HttpClient.Initialize();
    //     //HttpClient.Initialize(InitializeHttpClient.InitializeHttpClient(Enum::"Authorization Type_HCEAV"::OAuth, AccessTokentxt));
    //     HttpClient.SetRequestUri(RequestUri);
    //     HttpClient.SetMethod(Format(Enum::"Http Request Type"::POST));

    //     RequestBody := StrSubstNo('{"messageText":"%1","profileId":%2,"externalRefId":%3,"phone":"%4","email":null,"testMode":%5,"isVoice":false,"smsSendAs":"%6"}',
    //                                   MessageText, BlueIdeaProfileID, ReferenceId, Recipient, TestMode, NameofSender);
    //     HttpClient.SetContent(RequestBody);

    //     HttpClient.UpdateContentHeader('Content-Type', 'application/json');
    //     HttpClient.UpdateHeader('Accept', 'text/plain');
    //     HttpClient.UpdateHeader('Authorization', AccessTokentxt);

    //     if HttpClient.Send(HttpResponse) then begin
    //         HttpResponse.Content.ReadAs(ResponseText);
    //         Message(ResponseText);
    //     end else
    //         if HttpResponse.Content().ReadAs(ResponseText) then
    //             Error(SendFailureErr, HttpResponse.HttpStatusCode(), ResponseText)
    //         else
    //             Error(SendFailureErr, HttpResponse.HttpStatusCode(), 'Could not read response');
    //     exit(ReferenceId);
    // end;
}
