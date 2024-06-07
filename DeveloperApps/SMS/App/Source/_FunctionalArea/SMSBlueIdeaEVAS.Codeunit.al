/// <summary>
/// Codeunit SMS BlueIdea_EVAS_EVAS (ID 52000).
/// </summary>
codeunit 52000 "SMS BlueIdea_EVAS" implements ISmsProvider_EVAS
{
    var
        BlueIdeaSMSSetupEVAS: Record "BlueIdea SMS Setup_EVAS";
        HttpClient: HttpClient;
        NoResponseTxt: Label 'Could not read response', Comment = 'DAN="kunne ikke løse svar"';
        SendFailureErr: Label 'Unable to request access token. Error Code %1\Message: %2', Comment = 'DAN="Access Token kunne ikke hentes. Fejlkode %1\Besked: %2"';
        SetupRead: Boolean;

    /// <summary>
    /// GetAccessToken.        
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetAccessToken(): Text
    var
        HttpRequest: HttpRequestMessage;
        HttpContent: HttpContent;
        ContentTxt: Label '{"email":"%1","password":"%2"}', Comment = '%1= email address, %2 = Password';
        UserName: Text;
        UserPassword: Text;
        ResponseTxt: Text;
    begin
        GetUserNameAndCredentials(UserName, UserPassword);

        Initialize(HttpRequest);

        HttpRequest.SetRequestUri(GetRequestAcessTokenUri());
        HttpRequest.Method := Format(Enum::"Http Request Type"::POST);
        HttpContent.WriteFrom(StrSubstNo(ContentTxt, UserName, UserPassword));
        HttpRequest.Content := HttpContent;
        UpdateContentHeader(HttpRequest, 'Content-type', 'application/json');

        if not SendRequest(HttpRequest, ResponseTxt) then
            Error(ResponseTxt)
        else
            exit(ResponseTxt);
    end;

    /// <summary>
    /// SendTextMessage.
    /// </summary>
    /// <param name="MessageText">Text.</param>
    /// <param name="Recipient">Text.</param>
    /// <param name="ReferenceId">Integer.</param>
    /// <param name="ReturnValue">VAR Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure SendTextMessage(MessageText: Text; Recipient: Text; ReferenceId: Integer; var ReturnValue: Text): Boolean;
    var
        HttpContent: HttpContent;
        HttpRequest: HttpRequestMessage;
        BearerLbl: Label 'Bearer %1', Locked = true;
        BodyTxt: Label '{"messageText":"%1","profileId":%2,"externalRefId":%3,"phone":"%4","email":null,"testMode":%5,"isVoice":false,"smsSendAs":"%6"}', Comment = '%1 = messageText, %2 =profileId, %3= externalRefId, %4 = phone, %5 = testMode, %6 = smsSendAs';
        AccessTokentxt: Text;
        RequestBody: Text;
        ResponseTxt: Text;
    begin
        CheckPhoneNo(Recipient);

        AccessTokentxt := StrSubstNo(BearerLbl, GetAccessToken());
        Initialize(HttpRequest);
        HttpRequest.SetRequestUri(GetRequestSendSMSUri());
        HttpRequest.Method := Format(Enum::"Http Request Type"::POST);

        RequestBody := StrSubstNo(BodyTxt, MessageText, GetProfileID(), ReferenceId, Recipient, GetTestMode(), GetNameOfSender());
        HttpContent.WriteFrom(RequestBody);
        HttpRequest.Content := HttpContent;
        UpdateContentHeader(HttpRequest, 'Content-type', 'application/json');
        UpdateHttpHeader(HttpRequest, 'Accept', 'text/plain');
        UpdateHttpHeader(HttpRequest, 'Authorization', AccessTokentxt);

        if not SendRequest(HttpRequest, ResponseTxt) then
            Error(ResponseTxt);

        ReturnValue := ResponseTxt;

        exit(true);
    end;

    /// <summary>
    /// openSMSProviderSetup.
    /// </summary>
    /// <param name="SMSProviderCode">Code[20].</param>
    procedure openSMSProviderSetup(SMSProviderCode: Code[20])
    begin
        if SMSProviderCode = '' then
            exit;
        if not BlueIdeaSMSSetupEVAS.Get(SMSProviderCode) then begin
            BlueIdeaSMSSetupEVAS.Init();
            BlueIdeaSMSSetupEVAS.Code := SMSProviderCode;
            BlueIdeaSMSSetupEVAS.Insert(true);
            Commit();
        end;
        BlueIdeaSMSSetupEVAS.SetRange(Code, SMSProviderCode);
        Page.RunModal(Page::"BlueIdea SMS Setup_EVAS", BlueIdeaSMSSetupEVAS);
    end;

    local procedure Initialize(var HttpRequest: HttpRequestMessage)
    var
        UserAgentDescriptionTxt: Label 'Elbek & Vejrup A/S SMS Version %1', Locked = true;
        UserAgentTxt: Label 'user-agent', Locked = true;
        Info: ModuleInfo;
    begin
        HttpClient.Clear();
        Clear(HttpRequest);
        NavApp.GetCurrentModuleInfo(Info);
        UpdateHttpHeader(HttpRequest, UserAgentTxt, StrSubstNo(UserAgentDescriptionTxt, Info.AppVersion));
    end;

    [TryFunction]
    local procedure UpdateHttpHeader(var HttpRequest: HttpRequestMessage; Name: Text; Value: Text)
    var
        Headers: HttpHeaders;
    begin
        HttpRequest.GetHeaders(Headers);
        if Headers.Contains(Name) then
            Headers.Remove(Name);
        Headers.Add(Name, Value);
    end;

    local procedure UpdateContentHeader(var HttpRequest: HttpRequestMessage; Name: Text; Value: Text)
    var
        Headers: HttpHeaders;
        Content: HttpContent;
    begin
        Content := HttpRequest.Content;
        if not Content.GetHeaders(Headers) then
            exit;
        if Headers.Contains(Name) then
            Headers.Remove(Name);
        Headers.Add(Name, Value);
        HttpRequest.Content := Content;
    end;

    local procedure Send(HttpRequest: HttpRequestMessage; var HttpResponse: HttpResponseMessage): Boolean
    begin
        ClearLastError();
        if HttpClient.Send(HttpRequest, HttpResponse) then
            if HttpResponse.IsSuccessStatusCode then
                exit(true)
            else
                exit(false);

        exit(false);
    end;

    local procedure SendRequest(var HttpRequest: HttpRequestMessage; var ResponseTxt: Text): Boolean
    var
        HttpResponse: HttpResponseMessage;

    begin
        if Send(HttpRequest, HttpResponse) then begin
            ReadRequestTokenFromResponse(HttpResponse, ResponseTxt);
            exit(true);
        end else begin
            if HttpResponse.Content().ReadAs(ResponseTxt) then
                ResponseTxt := StrSubstNo(SendFailureErr, HttpResponse.HttpStatusCode(), ResponseTxt)
            else
                ResponseTxt := StrSubstNo(SendFailureErr, HttpResponse.HttpStatusCode(), NoResponseTxt);
            exit(false);
        end;
    end;

    local procedure ReadRequestTokenFromResponse(Response: HttpResponseMessage; var Token: Text)
    var
        ContentJSON: JsonObject;
        JSON: JsonToken;
        AccessTokenLbl: Label 'accessToken', Locked = true;
        ContentText: Text;
    begin
        Token := '';
        Response.Content().ReadAs(ContentText);
        if ContentJSON.ReadFrom(ContentText) then begin
            ContentJSON.Get(AccessTokenLbl, JSON);
            Token := JSON.AsValue().AsText();
        end else
            Token := ContentText;
    end;

    local procedure CheckPhoneNo(Recipient: Text)
    var
        RegEx: Codeunit Regex;
        PhoneNoErr: Label 'Invalid phone number, The phone number is not valid', Comment = 'DAN="Ugyldigt telefonnummer, Telefonnummeret er ikke gyldigt"';
        PhoneRegExpTxt: Label '^[\+0]*(45)?[\+]*[1-9]{1}[0-9]{7}$';
        RecipientTrimmed: Text;
    begin
        RecipientTrimmed := DelChr(Recipient, '=', ' ');
        if not RegEx.IsMatch(RecipientTrimmed, PhoneRegExpTxt) then
            Error(PhoneNoErr)
    end;


    local procedure GetRequestAcessTokenUri(): Text
    begin
        GetSetup();
        exit(BlueIdeaSMSSetupEVAS."Access Token Endpoint");
    end;

    local procedure GetRequestSendSMSUri(): Text
    begin
        exit(BlueIdeaSMSSetupEVAS.Endpoint);
    end;

    local procedure GetUserNameAndCredentials(var UserName: Text; var UserPassword: Text)
    begin
        GetSetup();
        UserName := BlueIdeaSMSSetupEVAS.Username;
        UserPassword := BlueIdeaSMSSetupEVAS.GetPassword();
    end;

    local procedure GetNameOfSender(): Text
    begin
        GetSetup();
        exit(BlueIdeaSMSSetupEVAS."Name of Sender");
    end;

    local procedure GetTestMode(): Text
    var
        TrueTxt: Label 'true', Locked = true;
        FalseTxt: Label 'false', Locked = true;
    begin
        GetSetup();
        if BlueIdeaSMSSetupEVAS."Test Mode" then
            exit(TrueTxt)
        else
            exit(FalseTxt);
    end;


    local procedure GetProfileID(): Code[10]
    begin
        GetSetup();
        exit(BlueIdeaSMSSetupEVAS."BlueIdea Profile ID");
    end;

    local procedure GetSetup()
    begin
        if SetupRead then
            exit;

        BlueIdeaSMSSetupEVAS.Get();
        SetupRead := true;
    end;
}
