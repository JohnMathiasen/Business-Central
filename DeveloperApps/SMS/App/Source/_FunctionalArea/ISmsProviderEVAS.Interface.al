/// <summary>
/// Interface "ISmsProvider_EVAS._EVAS"
/// </summary>
interface "ISmsProvider_EVAS"
{

    /// <summary>
    /// GetAccessToken.
    /// </summary>
    /// <param name="SMSProviderCode">Code[20].</param>
    /// <returns>Return value of type Text.</returns>
    procedure GetAccessToken(SMSProviderCode: Code[20]): Text;
    /// <summary>
    /// SendTextMessage.
    /// </summary>
    /// <param name="SMSProviderCode">Code[20].</param>
    /// <param name="MessageText">Text.</param>
    /// <param name="Recipient">Text.</param>
    /// <param name="ReferenceId">Integer.</param>
    /// <param name="ReturnValue">VAR Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure SendTextMessage(SMSProviderCode: Code[20]; MessageText: Text; Recipient: Text; ReferenceId: Integer; var ReturnValue: Text): Boolean;

    /// <summary>
    /// openSMSProviderSetup.
    /// </summary>
    /// <param name="SMSProviderCode">Code[20].</param>
    procedure openSMSProviderSetupPage(SMSProviderCode: Code[20]);
}
