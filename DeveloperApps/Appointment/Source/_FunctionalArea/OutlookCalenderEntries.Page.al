/// <summary>
/// Page Outlook Calender Entries_EVAS (ID 6042716).
/// </summary>
page 50300 "Outlook Calender Entries_EVAS"
{
    ApplicationArea = All;
    Caption = 'Calender Entries', Comment = 'DAN="Kalenderposter"';
    PageType = List;
    SourceTable = "Outlook Calender Entry_EVAS";
    UsageCategory = Lists;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Id; Rec.Id)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Calender entry Id.', Comment = 'DAN="Angiver kalenderpostens id."';
                }
                field("Account Id"; Rec."Account Id")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Mail Account Id.', Comment = 'DAN="Angiver mailkonto id."';
                }
                field(Connector; Rec.Connector)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Connector field.', Comment = 'DAN=""';
                    Visible = false;
                }
                field("From Address"; Rec."From Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the account to send the email from.', Comment = 'DAN="Angiver den konto, mailen sendes fra."';
                }
                field("Send to"; Rec."Send to")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the email addresses to send the email to.', Comment = 'DAN="Angiver den mailadresse, som mailen skal sendes til."';
                }
                field("Send CC"; Rec."Send CC")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the email addresses of people who should receive a copy of the email.', Comment = 'DAN="Angiver mailadresserne på personer, der skal modtage en kopi af mailen."';
                }
                field("Send BCC"; Rec."Send BCC")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the email addresses of people who should receive a blind carbon copy (Bcc) of the email. These addresses are not shown to other recipients.', Comment = 'DAN="Angiver mailadresserne på personer, som skal modtage en Bcc (Blind carbon copy) af mailen. Disse adresser vises ikke for andre modtagere."';
                }
                field(Subject; Rec.Subject)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the subject of the email.', Comment = 'DAN="Angiver emnet i mailen."';
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the appointment location.', Comment = 'DAN="Angiver det aftale stedet."';
                }
                field("Starting Datetime"; Rec."Starting Datetime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Starting Datetime field.', Comment = 'DAN="Angiver Start datotid"';
                }
                field("Ending Datetime"; Rec."Ending Datetime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Appointment Ending Datetime.', Comment = 'DAN="Angiver Slut datotid"';
                }
                field(UID; Rec.UID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Calender Reference', Comment = 'DAN="Angiver Calender referencen."';
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(ShowAppointmentMail)
            {
                ApplicationArea = All;
                Caption = 'Show Appointment', Comment = 'DAN="Vis Aftale"';
                ToolTip = 'Show the Appointment email.', Comment = 'DAN="Vis aftale e-mail."';
                Image = Calendar;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    OutlookAppointment: Codeunit "Outlook Appointment_EVAS";
                    EmailAction: Enum "Email Action";
                begin
                    EmailAction := OutlookAppointment.OpenAppointmentEditor(Rec, true);
                    if EmailAction = EmailAction::Sent then
                        Rec.Delete(true);
                    CurrPage.Update(false);
                end;
            }
        }
        area(Processing)
        {
            action(SendEmail)
            {
                ApplicationArea = All;
                Caption = 'Send', Comment = 'DAN="Send"';
                ToolTip = 'Send the Appointment email for processing.', Comment = 'DAN="Send aftale e-mail til behandling."';
                Image = Email;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    SelectedCalenderEntry: Record "Outlook Calender Entry_EVAS";
                    OutlookAppointment: Codeunit "Outlook Appointment_EVAS";
                    CalenderMessage: Codeunit "Calender Message_EVAS";
                begin
                    CurrPage.SetSelectionFilter(SelectedCalenderEntry);
                    if SelectedCalenderEntry.IsEmpty then
                        exit;

                    SelectedCalenderEntry.FindSet(false);
                    repeat
                        CalenderMessage.GetCalenderMessage(SelectedCalenderEntry);
                        OutlookAppointment.HandleAppointment(CalenderMessage, true, false);
                    until SelectedCalenderEntry.Next() = 0;
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
