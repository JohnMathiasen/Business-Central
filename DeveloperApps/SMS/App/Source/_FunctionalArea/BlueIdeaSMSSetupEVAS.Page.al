/// <summary>
/// Page BlueIdea SMS Setup_EVAS (ID 52000).
/// </summary>
page 52001 "BlueIdea SMS Setup_EVAS"
{
    Caption = 'BlueIdea SMS Setup', Comment = 'DAN="BlueIdea SMS opsætning"';
    PageType = Card;
    SourceTable = "BlueIdea SMS Setup_EVAS";
    UsageCategory = None;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'DAN="Generelt"';
                field("BlueIdea Profile ID"; Rec."BlueIdea Profile ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the BlueIdea Profile ID field.', Comment = '%DAN="BlueIdea profil ID"';
                }
                field("Name of Sender"; Rec."Name of Sender")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Navn ved afsendelse field.', Comment = '%DAN="Navn ved afsendelse"';
                }
                field(PasswordText; PasswordText)
                {
                    ApplicationArea = All;
                    Caption = 'Password', Comment = 'DAN="Kodeord"';
                    ExtendedDatatype = Masked;
                    ToolTip = 'Specifies the value of the Password field.', Comment = 'DAN="Kodeord"';
                    trigger OnValidate()
                    begin
                        Rec.SetPassword(PasswordText);
                        CurrPage.Update(true);
                    end;
                }
                field("Access Token Endpoint"; Rec."Access Token Endpoint")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Accecss Token Endpoint field.', Comment = '%DAN="Adgangstoken Endpoint"';
                }
                field(Endpoint; Rec.Endpoint)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Endpoint field.', Comment = '%DAN="Endpoint"';
                }
                field("Test Mode"; Rec."Test Mode")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Test mode field.', Comment = '%DAN="Testtilstand"';
                }
            }
        }
    }

    var
        PasswordText: Text;
}
