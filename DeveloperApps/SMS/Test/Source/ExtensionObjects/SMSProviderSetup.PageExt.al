/// <summary>
/// PageExtension SMS Provider Setup_EVAS (ID 50100) extends Record SMS Provider Setup_EVAS.
/// </summary>
pageextension 50100 "SMS Provider Setup_EVAS" extends "SMS Provider Setup_EVAS"
{
    actions
    {
        addlast(processing)
        {
            action(SetupSMSProvider_EVAS)
            {
                Caption = 'Setup SMS Provider';
                ApplicationArea = All;
                Image = Setup;
                trigger OnAction()
                begin
                    SetupSMSProvider(Rec."SMS Provider");
                end;
            }
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

    local procedure SetupSMSProvider(SMSProvider: Enum "SMS Provider_EVAS")
    begin

        case SMSProvider of
            SMSProvider::Blueidea:
                SetupBlueIdea(Rec);
        end;
    end;

    local procedure SetupBlueIdea(SMSProviderSetupEVAS: Record "SMS Provider Setup_EVAS")
    var
        BlueIdeaSMSSetupEVAS: Record "BlueIdea SMS Setup_EVAS";
    begin
        if not BlueIdeaSMSSetupEVAS.Get(SMSProviderSetupEVAS.Code) then begin
            BlueIdeaSMSSetupEVAS.Init();
            BlueIdeaSMSSetupEVAS.Code := SMSProviderSetupEVAS.Code;
            BlueIdeaSMSSetupEVAS.Insert();
        end;
        if BlueIdeaSMSSetupEVAS."BlueIdea Profile ID" = '' then
            BlueIdeaSMSSetupEVAS."BlueIdea Profile ID" := '5221';
        if BlueIdeaSMSSetupEVAS.Username = '' then
            BlueIdeaSMSSetupEVAS.Username := 'krk@elbek-vejrup.dk';
        if not BlueIdeaSMSSetupEVAS.Password.HasValue then
            BlueIdeaSMSSetupEVAS.setPassword('ITA4ever?');
        if BlueIdeaSMSSetupEVAS."Access Token Endpoint" = '' then
            BlueIdeaSMSSetupEVAS."Access Token Endpoint" := BlueIdeaSMSSetupEVAS.GetRequestAcessTokenUri();
        if BlueIdeaSMSSetupEVAS.Endpoint = '' then
            BlueIdeaSMSSetupEVAS.Endpoint := BlueIdeaSMSSetupEVAS.GetRequestSendSMSUri();
        BlueIdeaSMSSetupEVAS.Modify();
    end;
}
