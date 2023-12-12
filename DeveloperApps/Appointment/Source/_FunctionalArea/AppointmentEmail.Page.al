/// <summary>
/// Page Appointment Email_EVAS (ID 50302).
/// </summary>
page 50302 "Appointment Email_EVAS"
{
    PageType = Document;
    SourceTable = "Outlook Calender Entry_EVAS";
    Caption = 'Compose an Appointment Email', Comment = 'DAN="Dan en aftale mail"';
    UsageCategory = Tasks;
    ApplicationArea = All;
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    Extensible = true;

    layout
    {

        area(Content)
        {
            group("Email Details")
            {
                Caption = 'Email Details', Comment = 'DAN="Email detaljer"';

                grid("Email Details Grid")
                {
                    group("Email Inner Details")
                    {
                        ShowCaption = false;

                        field(Account; FromDisplayName)
                        {
                            ShowMandatory = true;
                            ApplicationArea = All;
                            Caption = 'From', Comment = 'DAN="Fra"';
                            ToolTip = 'Specifies the account to send the email from.', Comment = 'DAN="Angiver mailkonto, der afsendes fra"';
                            Editable = false;

                            trigger OnAssistEdit()
                            begin
                                ChangeEmailAccount(Rec, TempEmailAccount);

                                UpdateFromField(TempEmailAccount);
                                CurrPage.Update();
                            end;
                        }

                        field(ToField; ToRecipient)
                        {
                            ShowMandatory = true;
                            Caption = 'To', Comment = 'DAN="Til"';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the email addresses to send the email to.', Comment = 'DAN="Angiver den mailadresse, som mailen skal sendes til."';
                            Importance = Promoted;
                            Lookup = true;

                            trigger OnValidate()
                            begin
                                CalenderMessage.SetSendToEmail(ToRecipient);
                            end;

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                exit(LookupRecipients(Text));
                            end;

                        }

                        field(CcField; CcRecipient)
                        {
                            Caption = 'Cc', Comment = 'DAN="Cc"';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the email addresses of people who should receive a copy of the email.', Comment = 'DAN="Angiver mailadresserne på personer, der skal modtage en kopi af mailen."';
                            Importance = Additional;
                            Lookup = true;

                            trigger OnValidate()
                            begin
                                CalenderMessage.SetSendCcEmail(CcRecipient);
                            end;

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                exit(LookupRecipients(Text));
                            end;
                        }

                        field(BccField; BccRecipient)
                        {
                            Caption = 'Bcc', Comment = 'DAN="Bcc"';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the email addresses of people who should receive a blind carbon copy (Bcc) of the email. These addresses are not shown to other recipients.', Comment = 'DAN="Angiver mailadresserne på personer, som skal modtage en Bcc (Blind carbon copy) af mailen. Disse adresser vises ikke for andre modtagere."';
                            Importance = Additional;
                            Lookup = true;

                            trigger OnValidate()
                            begin
                                CalenderMessage.SetSendBccEmail(BccRecipient);
                            end;

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                exit(LookupRecipients(Text));
                            end;
                        }

                        field(SubjectField; EmailSubject)
                        {
                            Caption = 'Subject', Comment = 'DAN="Emne"';
                            ApplicationArea = All;
                            ToolTip = 'Specifies the subject of the email.', Comment = 'DAN="Angiver emnet i mailen."';
                            Importance = Promoted;

                            trigger OnValidate()
                            begin
                                CalenderMessage.SetSubject(EmailSubject);

                                CurrPage.Caption(EmailSubject);
                                CurrPage.Update();
                            end;
                        }
                        field(Location_EVAS; LocationTxt)
                        {
                            ApplicationArea = all;
                            Caption = 'Location', Comment = 'DAN="Sted"';
                            ToolTip = 'Specifies the appointment location.', Comment = 'DAN="Angiver det aftale stedet."';
                            Importance = Additional;
                            trigger OnValidate()
                            begin
                                CalenderMessage.SetLocation(LocationTxt);
                            end;
                        }

                    }
                }
            }
            group(AppointmentTime_EVAS)
            {
                ShowCaption = false;
                grid(AppointmentDetailsGrid_EVAS)
                {
                    group(AppointmentStart_EVAS)
                    {
                        ShowCaption = false;
                        group(Time1_EVAS)
                        {
                            Caption = 'Start time', Comment = 'DAN="Starttidspunkt"';
                            field("Starting Date_EVAS"; StartDate)
                            {
                                ShowMandatory = true;
                                ApplicationArea = all;
                                ToolTip = 'Specifies starting date for the appointment.', Comment = 'DAN="Angiver aftalens start dato."';
                                ShowCaption = false;
                                Importance = Promoted;

                                trigger OnValidate()
                                begin
                                    ValidateDates(true);
                                    CalenderMessage.SetStartDateTime(CreateDateTime(StartDate, StartTime));
                                end;
                            }
                            field("Starting Time_EVAS"; StartTime)
                            {
                                ShowMandatory = true;
                                ApplicationArea = all;
                                ToolTip = 'Specifies starting time for the appointment.', Comment = 'DAN="Angiver aftalens start tidspunkt."';
                                ShowCaption = false;
                                Importance = Promoted;

                                trigger OnAssistEdit()
                                var
                                    RetText: Text;
                                begin
                                    if Lookuptime(RetText) then
                                        evaluate(StartTime, RetText);

                                    ValidateTimes(true);
                                    CalenderMessage.SetStartDateTime(CreateDateTime(StartDate, StartTime));
                                end;

                                trigger OnValidate()
                                begin
                                    ValidateTimes(true);
                                    CalenderMessage.SetStartDateTime(CreateDateTime(StartDate, StartTime));
                                end;
                            }
                        }
                    }
                    group(AppointmentEnd_EVAS)
                    {
                        ShowCaption = false;
                        group(Time2_EVAS)
                        {
                            Caption = 'Ending time', Comment = 'DAN="Sluttidspunkt"';
                            field("Ending Date_EVAS"; EndDate)
                            {
                                ShowMandatory = true;
                                ApplicationArea = all;
                                ToolTip = 'Specifies ending date for the appointment.', Comment = 'DAN="Angiver aftalens slut dato."';
                                ShowCaption = false;
                                Importance = Promoted;

                                trigger OnValidate()
                                begin
                                    ValidateDates(false);
                                    CalenderMessage.SetEndDateTime(CreateDateTime(EndDate, EndTime));
                                end;
                            }
                            field("Ending Time_EVAS"; EndTime)
                            {
                                ShowMandatory = true;
                                ApplicationArea = all;
                                ToolTip = 'Specifies ending time for the appointment.', Comment = 'DAN="Angiver aftalens slut tidspunkt."';
                                ShowCaption = false;
                                Importance = Promoted;

                                trigger OnAssistEdit()
                                var
                                    RetText: Text;
                                begin
                                    if Lookuptime(RetText) then
                                        evaluate(EndTime, RetText);

                                    ValidateTimes(false);
                                    CalenderMessage.SetEndDateTime(CreateDateTime(EndDate, EndTime));
                                end;

                                trigger OnValidate()
                                begin
                                    ValidateTimes(false);
                                    CalenderMessage.SetEndDateTime(CreateDateTime(EndDate, EndTime));
                                end;
                            }
                        }
                    }
                }
            }
            group(HTMLFormattedBody)
            {
                ShowCaption = false;
                Caption = ' ';
                Visible = IsHTMLFormatted;

                field("Email Editor"; EmailBody)
                {
                    Caption = 'Message', Comment = 'DAN="Besked"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the content of the email.', Comment = 'DAN="Angiver indholdet af mailen."';
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        CalenderMessage.SetMessageBody(EmailBody);
                    end;
                }
            }

            group(RawTextBody)
            {
                ShowCaption = false;
                Caption = ' ';
                Visible = not IsHTMLFormatted;

                field(BodyField; EmailBody)
                {
                    Caption = 'Message', Comment = 'DAN="Besked"';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the content of the email.', Comment = 'DAN="Angiver indholdet af mailen."';
                    MultiLine = true;

                    trigger OnValidate()
                    begin
                        CalenderMessage.SetMessageBody(EmailBody);
                    end;
                }
            }

            part(CalAttachments; "Calender Msg. Attachment_EVAS")
            {
                ApplicationArea = All;
                SubPageLink = "Calender Message Id" = field(UID);
                UpdatePropagation = Both;
                Caption = 'Attachments', comment = 'DAN="Vedhæftninger"';
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Send)
            {
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Caption = 'Send Email', Comment = 'DAN="Send Email"';
                ToolTip = 'Send the email.', Comment = 'DAN="Send Email"';
                ApplicationArea = All;
                Image = SendMail;

                trigger OnAction()
                var
                    OutlookAppointment: Codeunit "Outlook Appointment_EVAS";
                begin
                    OutlookAppointment.HandleAppointment(CalenderMessage, true, false);
                    EmailAction := Enum::"Email Action"::Sent;
                    CurrPage.Close();
                end;
            }
            action(Discard)
            {
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                Caption = 'Discard Draft', Comment = 'DAN="Slet udkast"';
                ToolTip = 'Discard the draft email and close the page.', Comment = 'DAN="Slet email udkast og luk siden."';
                ApplicationArea = All;
                Image = Delete;

                trigger OnAction()
                var
                    OutlookAppointment: Codeunit "Outlook Appointment_EVAS";
                begin
                    if OutlookAppointment.DiscardAppointment(Rec, true) then begin
                        EmailAction := Enum::"Email Action"::Discarded;
                        CurrPage.Close();
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec := CalenderMessage.GetCalenderEntry(CalenderMessage.GetUID());
        CurrPage.SetTableView(Rec);

        if not IsNewCalenderEntry then begin
            IsNewCalenderEntry := Rec.Id = 0;
            if IsNewCalenderEntry then
                CalenderMessage.CreateNewCalenderEntry(Rec);
        end;

        if IsNewCalenderEntry then begin
            Rec.SetRange(Id, Rec.Id);
            CurrPage.SetTableView(Rec);
        end;

        DefaultExitOption := 1;
    end;

    trigger OnAfterGetRecord()
    begin
        GetEmailAccount(TempEmailAccount);
        UpdateFromField(TempEmailAccount);
        LocationTxt := CalenderMessage.GetLocation();
        ToRecipient := CalenderMessage.GetSendToEmail();
        CcRecipient := CalenderMessage.GetSendCcEmail();
        BccRecipient := CalenderMessage.GetSendBccEmail();
        EmailBody := CalenderMessage.GetMessageBody();
        EmailSubject := CalenderMessage.GetSubject();
        StartDate := DT2Date(CalenderMessage.GetStartDateTime());
        StartTime := DT2Time(CalenderMessage.GetStartDateTime());
        EndDate := DT2Date(CalenderMessage.GetEndDateTime());
        EndTime := DT2Time(CalenderMessage.GetEndDateTime());
        if EmailSubject <> '' then
            CurrPage.Caption(EmailSubject)
        else
            CurrPage.Caption(PageCaptionTxt); // fallback to default caption
        CurrPage.CalAttachments.Page.UpdateValues(CalenderMessage, true);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        CalenderMessage.SetCalenderEntry(Rec);
        if EmailAction <> EmailAction::Sent then
            exit(ShowCloseOptionsMenu());
    end;

    local procedure UpdateFromField(EmailAccount: Record "Email Account" temporary)
    var
        ExtFromDisplayNameLbl: Label '%1 (%2 %3)', Comment = '%1 - From Email, %2 - Account Name, %3 - Email address', Locked = true;
        FromDisplayNameLbl: Label '%1 (%2)', Comment = '%1 - Account Name, %2 - Email address', Locked = true;
    begin
        if CalenderMessage.GetFromEmail() <> '' then begin
            FromDisplayName := StrSubstNo(ExtFromDisplayNameLbl, CalenderMessage.GetFromEmail(), EmailAccount.Name, EmailAccount."Email Address");
            exit;
        end;

        if EmailAccount."Email Address" = '' then
            FromDisplayName := ''
        else
            FromDisplayName := StrSubstNo(FromDisplayNameLbl, EmailAccount.Name, EmailAccount."Email Address");
    end;

    local procedure ShowCloseOptionsMenu(): Boolean
    var
        OutlookAppointment: Codeunit "Outlook Appointment_EVAS";
        CloseOptions: Text;
        SelectedCloseOption: Integer;
    begin

        CloseOptions := OptionsOnClosePageNewEmailLbl;
        SelectedCloseOption := Dialog.StrMenu(CloseOptions, DefaultExitOption, CloseThePageQst);

        case SelectedCloseOption of
            1:
                EmailAction := Enum::"Email Action"::"Saved As Draft";
            2:
                begin
                    OutlookAppointment.DiscardAppointment(Rec, false);
                    EmailAction := Enum::"Email Action"::Discarded;
                end;
            else
                exit(false) // Cancel
        end;

        exit(true);
    end;

    /// <summary>
    /// LookupRecipients.
    /// </summary>
    /// <param name="Text">VAR Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    internal procedure LookupRecipients(var Text: Text): Boolean
    var
        IsSuccess: Boolean;
    begin
        IsSuccess := CalenderMessage.LookupAllRecipients(Rec.UID, Text);
        exit(IsSuccess);
    end;

    /// <summary>
    /// GetAction.
    /// </summary>
    /// <returns>Return value of type Enum "Email Action".</returns>
    internal procedure GetAction(): Enum "Email Action"
    begin
        exit(EmailAction);
    end;

    /// <summary>
    /// SetAsNew.
    /// </summary>
    internal procedure SetAsNew()
    begin
        IsNewCalenderEntry := true;
    end;

    local procedure GetEmailAccount(var EmailAccount: Record "Email Account");
    var
        OutlookAppointment: Codeunit "Outlook Appointment_EVAS";
    begin
        EmailAccount := OutlookAppointment.GetEmailAccount(Rec);
    end;

    local procedure ValidateTimes(FromField: Boolean)
    var
        EndTimeErr: Label 'End time must be after Start time.', Comment = 'DAN="Slut tidspkt. skal være efter Start tidspkt."';
    begin
        if StartDate < EndDate then
            exit;

        if Endtime > StartTime then
            exit;

        if FromField then begin
            CalenderMessage.SetEndDateTime(CreateDateTime(EndDate, StartTime));
            CurrPage.Update(false);
        end else
            Error(EndTimeErr);
    end;

    local procedure ValidateDates(FromField: Boolean)
    var
        EndDateErr: Label 'End date must be after start date.', Comment = 'DAN="Slut dato skal være efter start dato."';
        StartDT, EndDT : DateTime;
    begin
        StartDT := CreateDateTime(StartDate, StartTime);
        EndDT := CreateDateTime(EndDate, EndTime);
        if StartDT > EndDT then begin
            if StartDate = EndDate then begin
                ValidateTimes(FromField);
                exit;
            end else
                if FromField then begin
                    if EndTime > StartTime then
                        CalenderMessage.SetEndDateTime(CreateDateTime(StartDate, StartTime))
                    else
                        CalenderMessage.SetEndDateTime(CreateDateTime(StartDate, EndTime));
                    CurrPage.Update(false);
                end else
                    Error(EndDateErr);
        end else
            exit;
    end;

    /// <summary>
    /// SetCalenderMessage.
    /// </summary>
    /// <param name="NewCalenderMessage">Codeunit "Calender Message_EVAS".</param>
    internal procedure SetCalenderMessage(NewCalenderMessage: Codeunit "Calender Message_EVAS")
    begin
        CalenderMessage := NewCalenderMessage;
    end;

    /// <summary>
    /// GetCalenderMessage.
    /// </summary>
    /// <param name="NewCalenderMessage">VAR Codeunit "Calender Message_EVAS".</param>
    internal procedure GetCalenderMessage(var NewCalenderMessage: Codeunit "Calender Message_EVAS")
    begin
        NewCalenderMessage := CalenderMessage;
    end;

    /// <summary>
    /// ChangeEmailAccount.
    /// </summary>
    /// <param name="OutlookCalenderEntry">VAR Record "Outlook Calender Entry_EVAS".</param>
    /// <param name="ChosenEmailAccount">VAR Record "Email Account".</param>
    internal procedure ChangeEmailAccount(var OutlookCalenderEntry: Record "Outlook Calender Entry_EVAS"; var ChosenEmailAccount: Record "Email Account")
    var
        EmailAccounts: Page "Email Accounts";
    begin
        EmailAccounts.EnableLookupMode();

        if not IsNullGuid(ChosenEmailAccount."Account Id") then
            EmailAccounts.SetAccount(ChosenEmailAccount);

        if EmailAccounts.RunModal() = Action::LookupOK then begin
            EmailAccounts.GetAccount(ChosenEmailAccount);

            OutlookCalenderEntry."Account Id" := ChosenEmailAccount."Account Id";
            OutlookCalenderEntry.Connector := ChosenEmailAccount.Connector;
            OutlookCalenderEntry.Modify();
        end;
    end;

    /// <summary>
    /// SetHTMLFormatted.
    /// </summary>
    internal procedure SetHTMLFormatted()
    begin
        IsHTMLFormatted := true;
    end;

    local procedure LookupTime(var Text: Text): Boolean
    var
        OptionLookupBuffer: Record "Option Lookup Buffer";
        I: Integer;
        LDateTime: DateTime;
    begin
        Text := '';
        LDateTime := CreateDateTime(today, 0T);

        for I := 10 to 57 do begin
            OptionLookupBuffer.Init();
            OptionLookupBuffer.ID := I;
            OptionLookupBuffer."Option Caption" := format(DT2Time(LDateTime));
            OptionLookupBuffer."Lookup Type" := OptionLookupBuffer."Lookup Type"::Permissions;
            OptionLookupBuffer.Insert();
            LDateTime := LDateTime + 1800000;
        end;

        if Page.RunModal(Page::"Option Lookup List", OptionLookupBuffer) = Action::LookupOK then
            Text := OptionLookupBuffer."Option Caption";

        exit(Text <> '');
    end;

    var
        TempEmailAccount: Record "Email Account" temporary;
        CalenderMessage: Codeunit "Calender Message_EVAS";
        IsHTMLFormatted, IsNewCalenderEntry : Boolean;
        EndDate, StartDate : Date;
        EmailAction: Enum "Email Action";
        DefaultExitOption: Integer;
        CloseThePageQst: Label 'The Appointment email has not been sent.', Comment = 'DAN="Aftele e-mail er ikke blevet sendt."';
        OptionsOnClosePageNewEmailLbl: Label 'Keep as draft in Calender Entry,Discard Appointment email', Comment = 'DAN="Bevar som kladde i kalenderpost,Slet aftale mail"';
        PageCaptionTxt: Label 'Compose an Appointment Email', Comment = 'DAN="Opret en aftale mail"';
        EmailBody, FromDisplayName : Text;
        BccRecipient, CcRecipient, EmailSubject, LocationTxt, ToRecipient : Text[250];
        EndTime, StartTime : Time;
}

