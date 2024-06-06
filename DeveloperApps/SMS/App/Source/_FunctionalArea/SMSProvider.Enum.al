/// <summary>
/// Enum SMS Provider_EVAS (ID 52000) implements Interface ISmsProvider_EVAS.
/// </summary>
enum 52000 "SMS Provider_EVAS" implements ISmsProvider_EVAS
{
    Extensible = true;

    value(0; Blueidea)
    {
        Caption = 'Blueidea';
        Implementation = ISMSProvider_EVAS = "SMS BlueIdea_EVAS";
    }
    // value(1; CPSMS)
    // {
    //     Caption = 'CPSMS';
    // }
}
