/// <summary>
/// Interface "ISmsProvider_EVAS._EVAS"
/// </summary>
interface "ISmsProvider_EVAS"
{

    /// <summary>
    /// GetAccessToken.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    procedure GetAccessToken(): Text;
    /// <summary>
    /// SendTextMessage.
    /// </summary>
    /// <param name="MessageText">Text.</param>
    /// <param name="Recipient">Text.</param>
    /// <param name="ReferenceId">Integer.</param>
    /// <param name="ReturnValue">VAR Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure SendTextMessage(MessageText: Text; Recipient: Text; ReferenceId: Integer; var ReturnValue: Text): Boolean;

    /// <summary>
    /// openSMSProviderSetup.
    /// </summary>
    /// <param name="SMSProviderCode">Code[20].</param>
    procedure openSMSProviderSetup(SMSProviderCode: Code[20]);
}
