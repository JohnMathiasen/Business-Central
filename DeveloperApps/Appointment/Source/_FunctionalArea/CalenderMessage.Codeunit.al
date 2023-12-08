/// <summary>
/// Codeunit Outlook Calender Content_EVAS (ID 50301).
/// </summary>
codeunit 50301 "Calender Message_EVAS"
{
    var
        TempCalenderEmailRecipient: Record "Calender Email Recipient_EVAS" temporary;
        GlobalCalenderEntry: Record "Outlook Calender Entry_EVAS";
        EmailScenarisSpecified: Boolean;
        SendToCalendarTelemetryDefaultTxt: Label 'Business Central Sending to calendar.', Comment = 'DAN="Business Central Sender til kalendar."', Locked = true;
        SendToCalendarTelemetryTxt: Label 'Sending %1 to calendar.', Comment = 'Sender %1 til kalendar.', Locked = true;
        CalenderAttchmentName, CalenderMessageBody, CalenderTelemetryText : Text;
        OriginRecordVariant: Variant;
        UID: Guid;

    /// <summary>
    /// Set FromEmail(Organizer)
    /// </summary>
    /// <param name="FromEmail">Text.</param>
    internal procedure SetFromEmail(FromEmail: Text[250])
    begin
        SetGlobalCalenderEntry();
        GlobalCalenderEntry."From Address" := FromEmail;
    end;

    /// <summary>
    /// Get calender FromEmail(Organizer).
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetFromEmail(): Text
    begin
        exit(GlobalCalenderEntry."From Address");
    end;

    /// <summary>
    /// Set calender SendTo Email.
    /// </summary>
    /// <param name="SendToEmail">Text.</param>
    internal procedure SetSendToEmail(SendToEmail: Text[250])
    begin
        SetGlobalCalenderEntry();
        GlobalCalenderEntry."Send to" := SendToEmail;
    end;

    /// <summary>
    /// Get calender SendTo Email.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetSendToEmail(): Text
    begin
        exit(GlobalCalenderEntry."Send to");
    end;

    /// <summary>
    /// Set calender Send CcEmail.
    /// </summary>
    /// <param name="SendCcEmail">Text.</param>
    internal procedure SetSendCcEmail(SendCcEmail: Text[250])
    begin
        SetGlobalCalenderEntry();
        GlobalCalenderEntry."Send CC" := SendCcEmail;
    end;

    /// <summary>
    /// Get calender Send CcEmail.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetSendCcEmail(): Text
    begin
        exit(GlobalCalenderEntry."Send CC");
    end;

    /// <summary>
    /// Set calender SendBcc Email.
    /// </summary>
    /// <param name="SendBccEmail">Text.</param>
    internal procedure SetSendBccEmail(SendBccEmail: Text[250])
    begin
        SetGlobalCalenderEntry();
        GlobalCalenderEntry."Send BCC" := SendBccEmail;
    end;

    /// <summary>
    /// Get calender SendBcc Email.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetSendBccEmail(): Text
    begin
        exit(GlobalCalenderEntry."Send BCC");
    end;

    /// <summary>
    /// Set Calender StartDateTime.
    /// </summary>
    /// <param name="StartDateTime">DateTime.</param>
    internal procedure SetStartDateTime(StartDateTime: DateTime)
    begin
        SetGlobalCalenderEntry();
        GlobalCalenderEntry."Starting Datetime" := StartDateTime;
        CheckAppointmentDates();
    end;

    /// <summary>
    /// GetStartDateTime.
    /// </summary>
    /// <returns>Return variable StartDateTime of type DateTime.</returns>
    internal procedure GetStartDateTime() StartDateTime: DateTime
    begin
        exit(GlobalCalenderEntry."Starting Datetime");
    end;

    /// <summary>
    /// Set Calender EndDate.
    /// </summary>
    /// <param name="StartDate">Date.</param>
    /// <param name="Duration">Decimal.</param>
    /// <returns>Return variable EndDateTime of type DateTime.</returns>
    internal procedure SetEndDate(StartDate: Date; Duration: Decimal) EndDateTime: DateTime
    var
        EndTime: Time;
        Days: Integer;
    begin
        SetGlobalCalenderEntry();
        if Duration < 12 then
            Evaluate(EndTime, Format(8 + Duration))
        else
            Days := Round(Duration / 24, 1, '>');

        EndDateTime := CreateDateTime(StartDate + Days, EndTime);
        SetEndDateTime(EndDateTime);
    end;

    /// <summary>
    /// Set Calender EndDateTime.
    /// </summary>
    /// <param name="EndDateTime">DateTime.</param>
    internal procedure SetEndDateTime(EndDateTime: DateTime)
    begin
        SetGlobalCalenderEntry();
        GlobalCalenderEntry."Ending Datetime" := EndDateTime;
        CheckAppointmentDates();
    end;

    /// <summary>
    /// GetEndDateTime.
    /// </summary>
    /// <returns>Return variable EndDateTime of type DateTime.</returns>
    internal procedure GetEndDateTime() EndDateTime: DateTime
    begin
        exit(GlobalCalenderEntry."Ending Datetime");
    end;

    /// <summary>
    /// Set Calender AppointmentDescription.
    /// </summary>
    /// <param name="DescriptionIn">Text.</param>
    internal procedure SetAppointmentDescription(DescriptionIn: Text)
    begin
        SetGlobalCalenderEntry();
        GlobalCalenderEntry.Description := DescriptionIn;
    end;

    /// <summary>
    /// Get AppointmentDescription.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetAppointmentDescription(): Text
    begin
        exit(GlobalCalenderEntry.Description);
    end;

    /// <summary>
    /// Set Calender Subject.
    /// </summary>
    /// <param name="Subject">Text.</param>
    internal procedure SetSubject(Subject: Text[250])
    begin
        SetGlobalCalenderEntry();
        GlobalCalenderEntry.Subject := Subject;
    end;

    local procedure SetDefaultSubject()
    var
        DefaultCreateSubjectTxt: Label 'Create appointment', Comment = 'DAN="Lav aftale"';
        DefaultCancelSubjectTxt: Label 'Cancel appointment', Comment = 'DAN="Annullér aftale"';
        DefaultUpdateSubjectTxt: Label 'Update appointment', Comment = 'DAN="Opdatér aftale"';
    begin
        if GlobalCalenderEntry.Subject = '' then
            case true of
                (GlobalCalenderEntry."Create Appointment") and (not GlobalCalenderEntry."Cancel Appointment"):
                    GlobalCalenderEntry.Subject := DefaultCreateSubjectTxt;
                (not GlobalCalenderEntry."Create Appointment") and (GlobalCalenderEntry."Cancel Appointment"):
                    GlobalCalenderEntry.Subject := DefaultCancelSubjectTxt;
                (GlobalCalenderEntry."Create Appointment") and (GlobalCalenderEntry."Cancel Appointment"):
                    GlobalCalenderEntry.Subject := DefaultUpdateSubjectTxt;
            end;
    end;

    /// <summary>
    /// Get Calender Subject.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetSubject(): Text
    begin
        exit(GlobalCalenderEntry.Subject);
    end;

    /// <summary>
    /// Set Calender Location.
    /// </summary>
    /// <param name="Location">Text.</param>
    internal procedure SetLocation(Location: Text[250])
    begin
        SetGlobalCalenderEntry();
        GlobalCalenderEntry.Location := Location;
    end;

    /// <summary>
    /// Get Calender Location.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetLocation(): Text
    begin
        exit(GlobalCalenderEntry.Location);
    end;

    /// <summary>
    /// Set Calender Summery.
    /// </summary>
    /// <param name="Summery">text.</param>
    internal procedure SetSummery(Summery: text)
    begin
        SetGlobalCalenderEntry();
        GlobalCalenderEntry.Summery := Summery;
    end;

    /// <summary>
    /// Get Calender Summery.
    /// </summary>
    /// <returns>Return value of type text.</returns>
    internal procedure GetSummery(): text
    begin
        exit(GlobalCalenderEntry.Summery);
    end;

    /// <summary>
    /// Set Calender UID.
    /// </summary>
    /// <param name="UIDIn">Guid.</param>
    internal procedure SetUID(UIDIn: Guid)
    begin
        SetGlobalCalenderEntry();
        UID := UIDIn;
        GlobalCalenderEntry.UID := UIDIn;
    end;

    /// <summary>
    /// Get Calender UID.
    /// </summary>
    /// <returns>Return value of type Guid.</returns>
    internal procedure GetUID(): Guid
    begin
        exit(GlobalCalenderEntry.UID);
    end;

    /// <summary>
    /// Set Calender Sequence.
    /// </summary>
    /// <param name="Sequence">Integer.</param>
    internal procedure SetSequence(Sequence: Integer)
    begin
        SetGlobalCalenderEntry();
        GlobalCalenderEntry.Sequence := Sequence;
    end;

    /// <summary>
    /// Get Calender Sequence.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    internal procedure GetSequence(): Integer
    begin
        exit(GlobalCalenderEntry.Sequence);
    end;

    /// <summary>
    /// Set Calender SendRequest.
    /// </summary>
    /// <param name="CreateAppointment">Boolean.</param>
    internal procedure SetCreateAppointment(CreateAppointment: Boolean)
    begin
        SetGlobalCalenderEntry();
        GlobalCalenderEntry."Create Appointment" := CreateAppointment;
        SetDefaultSubject();
    end;

    /// <summary>
    /// Get Calender SendRequest.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    internal procedure GetCreateAppointment(): Boolean
    begin
        exit(GlobalCalenderEntry."Create Appointment");
    end;

    /// <summary>
    /// Set Calender SendCancellation.
    /// </summary>
    /// <param name="CancelAppointment">Boolean.</param>
    internal procedure SetCancelAppointment(CancelAppointment: Boolean)
    begin
        SetGlobalCalenderEntry();
        GlobalCalenderEntry."Cancel Appointment" := CancelAppointment;
        SetDefaultSubject();
    end;

    /// <summary>
    /// Get Calender SendCancellation.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    internal procedure GetCancelAppointment(): Boolean
    begin
        exit(GlobalCalenderEntry."Cancel Appointment");
    end;

    /// <summary>
    /// SetUpdateAppointment.
    /// </summary>
    /// <param name="UpdateAppointment">Boolean.</param>
    internal procedure SetUpdateAppointment(UpdateAppointment: Boolean)
    begin
        SetCreateAppointment(UpdateAppointment);
        SetCancelAppointment(UpdateAppointment);
        SetDefaultSubject();
    end;

    /// <summary>
    /// GetUpdateAppointment.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    internal procedure GetUpdateAppointment(): Boolean
    begin
        exit(GlobalCalenderEntry."Create Appointment" and GlobalCalenderEntry."Cancel Appointment");
    end;


    /// <summary>
    /// Set Calender AttachmentName.
    /// </summary>
    /// <param name="AttchmentName">Text.</param>
    internal procedure SetAttachmentName(AttchmentName: Text)
    begin
        CalenderAttchmentName := AttchmentName;
    end;

    /// <summary>
    /// Get Calender AttachmentName.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetAttachmentName(): Text
    begin
        exit(CalenderAttchmentName);
    end;

    /// <summary>
    /// Set Calender Message Body.
    /// </summary>
    /// <param name="MessageBody">Text.</param>
    internal procedure SetMessageBody(MessageBody: Text)
    begin
        SetGlobalCalenderEntry();
        CalenderMessageBody := MessageBody;
        GlobalCalenderEntry.AddBody(MessageBody);
    end;

    /// <summary>
    /// Get Calender Message Body.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetMessageBody(): Text
    begin
        exit(CalenderMessageBody);
    end;

    /// <summary>
    /// Set a Record - Tablename added to the TelemetryText.
    /// </summary>
    /// <param name="RecordVariant">Variant.</param>
    internal procedure SetRecord(RecordVariant: Variant)
    var
        DataTypeManagement: Codeunit "Data Type Management";
        RecRef: RecordRef;
    begin
        DataTypeManagement.GetRecordRef(RecordVariant, RecRef);
        OriginRecordVariant := RecRef;
        if RecRef.Name <> '' then
            CalenderTelemetryText := StrSubstNo(SendToCalendarTelemetryTxt, RecRef.Name)
        else
            CalenderTelemetryText := SendToCalendarTelemetryDefaultTxt;
        GlobalCalenderEntry."Record ID" := RecRef.RecordId;
    end;

    /// <summary>
    /// Get Record.
    /// </summary>
    /// <param name="RecRef">VAR RecordRef.</param>
    internal procedure GetRecord(var RecRef: RecordRef)
    var
        DataTypeManagement: Codeunit "Data Type Management";

    begin
        DataTypeManagement.GetRecordRef(OriginRecordVariant, RecRef);
    end;

    /// <summary>
    /// Set TelemetryText.
    /// </summary>
    /// <param name="TelemetryText">Text.</param>
    internal procedure SetTelemetryText(TelemetryText: Text)
    begin
        CalenderTelemetryText := TelemetryText;
    end;

    /// <summary>
    /// Get TelemetryText.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetTelemetryText(): Text
    begin
        if CalenderTelemetryText = '' then
            CalenderTelemetryText := SendToCalendarTelemetryDefaultTxt;
        exit(CalenderTelemetryText);
    end;

    /// <summary>
    /// Set Email Scenario.
    /// </summary>
    /// <param name="EmailScenario">Enum "Email Scenario".</param>
    internal procedure SetEmailScenario(EmailScenario: Enum "Email Scenario")
    begin
        GlobalCalenderEntry."Email Scenario" := EmailScenario;
#pragma warning disable AA0206
        EmailScenarisSpecified := true;
#pragma warning restore AA0206
    end;

    /// <summary>
    /// Get Email Scenario.
    /// </summary>
    /// <returns>Return value of type Enum "Email Scenario".</returns>
    internal procedure GetEmailScenario(): Enum "Email Scenario"
    begin
        exit(GlobalCalenderEntry."Email Scenario");
    end;

    /// <summary>
    /// CheckMandatoryCalender.
    /// </summary>
    internal procedure CheckMandatoryCalender()
    var
        RecRef: RecordRef;
        SendCancellation, SendAppointment : Boolean;
        AppointmentErr: Label 'You must either specify a new appointment or a cancellation of a existing appointment - Specify SetCreateAppointment or SetCancelAppointment', Comment = 'DAN="Du skal angive om det drejer sig om en oprettelse aller annullering af en aftale - Angiv SetCreateAppointment eller SetCancelAppointment"';
        MissingUIDErr: Label 'A reference to an appointment is required for a cancellation - Specify SetUID', Comment = 'DAN="Der kræves en reference til annullering af en Kalender aftale - Angiv SetUID"';
        FromEmailErr: Label 'You must specify From Email', Comment = 'DAN="Du skal angive From Email"';
        TilEmailErr: Label 'You must specify Recipient Email', Comment = 'DAN="Du skal angive Recipient Email"';
        MissingStartDateErr: Label 'You must specify a Start date for the appointment', Comment = 'DAN="Du skal angive Start dato for aftalen"';
        MissingEndDateErr: Label 'You must specify a End date for the appointment', Comment = 'DAN="Du skal angive Slut dato for aftalen"';
        MissingSubjectErr: Label 'You must specify a Subject for the appointment', Comment = 'DAN="Du skal angive et emne for aftalen"';
        TableOriginationErr: Label 'You must specify a Record for the appointment - Which record that the appointment is referenced to.', Comment = 'DAN="Du skal angive en oprindelses tabel for aftalen - Den konkrete record aftalen er opstået fra."';
    begin
        SendCancellation := GetCancelAppointment();
        SendAppointment := GetCreateAppointment();

        if not SendAppointment and not SendCancellation then
            Error(AppointmentErr);

        if GetFromEmail() = '' then
            Error(FromEmailErr);

        if GetSendToEmail() = '' then
            Error(TilEmailErr);

        if GetStartDateTime() = 0DT then
            Error(MissingStartDateErr);

        if GetEndDateTime() = 0DT then
            Error(MissingEndDateErr);

        if SendCancellation then
            if IsNullGuid(GetUID()) then
                Error(MissingUIDErr);

        if SendAppointment then
            if GetSubject() = '' then
                Error(MissingSubjectErr);

        GetRecord(RecRef);
        if RecRef.Number = 0 then
            Error(TableOriginationErr);
    end;

    internal procedure AddEmailAddressForLookup(Name: Text[250]; EmailAddress: Text[250])
    begin
        AddEmailAddressForLookup(Name, EmailAddress, Enum::"Email Recipient Type"::"To");
    end;

    internal procedure AddEmailAddressForLookup(Name: Text[250]; EmailAddress: Text[250]; EmailRecipientType: Enum "Email Recipient Type")
    begin
        if EmailAddress = '' then
            exit;

        TempCalenderEmailRecipient.SetRange("E-Mail Address", EmailAddress);
        if Name <> '' then
            TempCalenderEmailRecipient.SetRange(Name, Name);
        if not TempCalenderEmailRecipient.IsEmpty then
            exit;
        TempCalenderEmailRecipient.Reset();
        TempCalenderEmailRecipient."Calender Entry UID" := GetUID();
        TempCalenderEmailRecipient."E-Mail Address" := EmailAddress;
        TempCalenderEmailRecipient.Name := Name;
        TempCalenderEmailRecipient."Email Recipient Type" := EmailRecipientType;
        if TempCalenderEmailRecipient.Insert() then;
    end;

    internal procedure LookupAllRecipients(CalenderEntryID: Guid; var Text: Text): Boolean
    var
        EmailRecipientType: Enum "Email Recipient Type";
    begin
        exit(LookupRecipients(CalenderEntryID, EmailRecipientType, true, Text));
    end;

    internal procedure LookupRecipients(CalenderEntryID: Guid; EmailRecipientType: Enum "Email Recipient Type"; var Text: Text): Boolean
    begin
        exit(LookupRecipients(CalenderEntryID, EmailRecipientType, Text));
    end;

    local procedure LookupRecipients(CalenderEntryID: Guid; EmailRecipientType: Enum "Email Recipient Type"; AllMailRecipients: Boolean; var Text: Text): Boolean
    var
        TempSuggestedCalenderEmailRecipient: Record "Calender Email Recipient_EVAS" temporary;
        CalenderEmailRecipientsPage: Page "Calender Email Recipients_EVAS";
    begin
        TempCalenderEmailRecipient.SetRange("Calender Entry UID", CalenderEntryID);
        if not AllMailRecipients then
            TempCalenderEmailRecipient.SetRange("Email Recipient Type", EmailRecipientType);
        if TempCalenderEmailRecipient.IsEmpty then
            exit;

        TempCalenderEmailRecipient.FindSet(false);
        repeat
            CalenderEmailRecipientsPage.AddSuggestions(TempCalenderEmailRecipient);
        until TempCalenderEmailRecipient.Next() = 0;

        CalenderEmailRecipientsPage.LookupMode(true);
        if (CalenderEmailRecipientsPage.RunModal() = Action::LookupOK) then begin
            CalenderEmailRecipientsPage.GetSelectedSuggestions(TempSuggestedCalenderEmailRecipient);

            if TempSuggestedCalenderEmailRecipient.FindSet() then begin
                if (Text <> '') and (not Text.EndsWith(';')) then
                    Text += ';';
                Text += CalenderEmailRecipientsPage.GetSelectedSuggestionsAsText(TempSuggestedCalenderEmailRecipient);

                // Added recipients is added as related entities on the email
                //AddRelatedRecordsFromEmailAddress(MessageID, SuggestedEmailAddressLookup);
                exit(true);
            end;
        end;
        exit(false);
    end;

    local procedure SetGlobalCalenderEntry()
    begin
        if IsNullGuid(GlobalCalenderEntry."Account Id") then
            InitializeGlobalCelenderEntry(GlobalCalenderEntry);

        if IsNullGuid(GlobalCalenderEntry.UID) then begin
            GlobalCalenderEntry.UID := CreateGuid();
            UID := GlobalCalenderEntry.UID;
        end;
    end;

    internal procedure CreateNewCalenderEntry(var OutlookCalenderEntry: Record "Outlook Calender Entry_EVAS")
    begin
        if OutlookCalenderEntry.UID = GlobalCalenderEntry.UID then
            if GlobalCalenderEntry.Id = 0 then
                GlobalCalenderEntry.Insert(true);

        OutlookCalenderEntry := GlobalCalenderEntry;
    end;

    internal procedure SetCalenderEntry(var OutlookCalenderEntry: Record "Outlook Calender Entry_EVAS")
    begin
        if OutlookCalenderEntry.UID = GlobalCalenderEntry.UID then begin
            GlobalCalenderEntry.Modify();
            OutlookCalenderEntry := GlobalCalenderEntry;
        end;
    end;

    local procedure InitializeGlobalCelenderEntry(var OutlookCalenderEntry: Record "Outlook Calender Entry_EVAS")
    var
        EmailAccount: Record "Email Account";
    begin
        EmailAccount := GetFromAddress(GetEmailScenario());
        OutlookCalenderEntry."Account Id" := EmailAccount."Account Id";
        OutlookCalenderEntry.Connector := EmailAccount.Connector;
        OutlookCalenderEntry."From Address" := EmailAccount."Email Address";
    end;

    local procedure GetFromAddress(EmailScenario: Enum "Email Scenario"): Record "Email Account" temporary;
    var
        TempEmailModuleAccount: Record "Email Account" temporary;
        EmailScenarios: Codeunit "Email Scenario";
        NoDefaultScenarioDefinedErr: Label 'The default account is not selected. Please, register an account on the ''Email Accounts'' page and mark it as the default account on the ''Email Scenario Setup'' page.', Comment = 'Standard konto er ikke valgt. Angiv venligst en konto på ''Mmail konti'' side og  markér den som standard konto på ''Tildeling af mailscenarie'' side."';
        NoScenarioDefinedErr: Label 'No email account defined for the scenario ''%1''. Please, register an account on the ''Email Accounts'' page and assign scenario ''%1'' to it on the ''Email Scenario Setup'' page. Mark one of the accounts as the default account to use it for all scenarios that are not explicitly defined.', Comment = 'DAN="Ingen email konto er defineret for scenarie ''%1''. Angiv venligst en konto på ''Mail konto'' side og tildel et scenarie ''%1'' til det på ''Tildeling af mailscenarie'' side. Markér en konto som standard konto tl anvendelse for alle scenarioer, der ikke er eksplicit defineret."';
    begin
        // Try get the email account to use by the provided scenario
        if not EmailScenarios.GetEmailAccount(EmailScenario, TempEmailModuleAccount) then
            if EmailScenario = Enum::"Email Scenario"::Default then
                Error(NoDefaultScenarioDefinedErr)
            else
                Error(NoScenarioDefinedErr, EmailScenario);
        exit(TempEmailModuleAccount);
    end;

    internal procedure GetCalenderMessage(OutlookCalenderEntry: Record "Outlook Calender Entry_EVAS")
    var
        IStream: InStream;
    begin
        GlobalCalenderEntry := OutlookCalenderEntry;
        GlobalCalenderEntry.CalcFields(Body);
        GlobalCalenderEntry.Body.CreateInStream(IStream);
        IStream.Read(CalenderMessageBody);
        EmailScenarisSpecified := true;
        SetReferencedRecord();
        GetTempEmailRecipients()
    end;

    local procedure SetReferencedRecord(): Boolean
    var
        RecRef: RecordRef;
    begin
        if GlobalCalenderEntry."Record ID".TableNo = 0 then
            exit(false);
        RecRef.Get(GlobalCalenderEntry."Record ID");
        OriginRecordVariant := RecRef;
        exit(true);
    end;

    local procedure GetTempEmailRecipients()
    var
        CalenderEmailRecipient: Record "Calender Email Recipient_EVAS";
    begin
        if not TempCalenderEmailRecipient.IsEmpty then
            exit;
        CalenderEmailRecipient.SetRange("Calender Entry UID", GetUid());
        if CalenderEmailRecipient.IsEmpty then
            exit;
        CalenderEmailRecipient.FindSet(false);
        repeat
            TempCalenderEmailRecipient := CalenderEmailRecipient;
            TempCalenderEmailRecipient.Insert();
        until CalenderEmailRecipient.Next() = 0;
    end;

    internal procedure SaveCalenderEmailRecipients()
    var
        CalenderEmailRecipient: Record "Calender Email Recipient_EVAS";
    begin
        TempCalenderEmailRecipient.Reset();
        TempCalenderEmailRecipient.SetRange("Calender Entry UID", GetUid());
        if TempCalenderEmailRecipient.IsEmpty then
            exit;

        CalenderEmailRecipient.SetRange("Calender Entry UID", GetUid());
        CalenderEmailRecipient.DeleteAll();

        TempCalenderEmailRecipient.FindSet(false);
        repeat
            CalenderEmailRecipient := TempCalenderEmailRecipient;
            CalenderEmailRecipient.Insert();
        until TempCalenderEmailRecipient.Next() = 0;
    end;

    internal procedure GetCalenderEntry(UIDin: Guid): Record "Outlook Calender Entry_EVAS"
    begin
        if GlobalCalenderEntry.UID = UIDin then
            exit(GlobalCalenderEntry);
    end;

    local procedure CheckAppointmentDates()
    var
        DateErr: Label 'The appointment starting date must be before ending date.', Comment = 'DAN"Aftalens startdato skal være før slutdato."';
    begin
        if (GlobalCalenderEntry."Starting Datetime" = 0DT) and
            (GlobalCalenderEntry."Ending Datetime" = 0DT) then
            exit;
        if GlobalCalenderEntry."Ending Datetime" <> 0DT then
            if GlobalCalenderEntry."Starting Datetime" > GlobalCalenderEntry."Ending Datetime" then
                Error(DateErr);
    end;

}
