/// <summary>
/// Page SMS Setup_EVAS (ID 52001).
/// </summary>
page 52000 "SMS Provider Setup_EVAS"
{
    Caption = 'SMS Provider Setup', Comment = 'DAN="Opsætning af SMS udbyder"';
    PageType = List;
    SourceTable = "SMS Provider Setup_EVAS";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Code field.', Comment = 'DAN="Kode"';
                }
                field("SMS Provider"; Rec."SMS Provider")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SMS Provider field.', Comment = 'DAN="SMS-udbyder"';
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(SMSProviderPage)
            {
                ApplicationArea = All;
                Caption = 'SMS Provider', Comment = 'DAN="SMS-udbyder"';
                Image = ContactReference;
                trigger OnAction()
                begin
                    OpenSMSProviderPage();
                end;
            }
        }
    }

    local procedure OpenSMSProviderPage()
    var
        ISmsProvider: Interface ISmsProvider_EVAS;
    begin
        ISmsProvider := Rec."SMS Provider";
        ISmsProvider.openSMSProviderSetupPage(Rec.Code);
    end;
}
