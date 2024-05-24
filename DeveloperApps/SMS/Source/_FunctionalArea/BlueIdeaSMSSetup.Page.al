/// <summary>
/// Page BlueIdea SMS Setup_EVAS (ID 52000).
/// </summary>
page 52000 "BlueIdea SMS Setup_EVAS"
{
    Caption = 'BlueIdea SMS Setup';
    PageType = Card;
    SourceTable = "BlueIdea SMS Setup_EVAS";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';


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
                field(Username; Rec.Username)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User Name field.', Comment = '%DAN="Brugernavn"';
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
                field("Test Mode"; Rec."Test Mode")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Test mode field.', Comment = '%DAN="Testtilstand"';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Iniitialize();
    end;

    var
        PasswordText: Text;



}
