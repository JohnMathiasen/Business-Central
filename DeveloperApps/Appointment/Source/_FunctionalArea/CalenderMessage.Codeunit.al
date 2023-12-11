/// <summary>
/// Codeunit Outlook Calender Content_EVAS (ID 50301).
/// </summary>
codeunit 50301 "Calender Message_EVAS"
{
    var
        CalenderMessageImplEVAS: Codeunit "Calender Message Impl._EVAS";

    /// <summary>
    /// Set FromEmail(Organizer)
    /// </summary>
    /// <param name="FromEmail">Text.</param>
    internal procedure SetFromEmail(FromEmail: Text[250])
    begin
        CalenderMessageImplEVAS.SetFromEmail(FromEmail);
    end;

    /// <summary>
    /// Get calender FromEmail(Organizer).
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetFromEmail(): Text
    begin
        exit(CalenderMessageImplEVAS.GetFromEmail());
    end;

    /// <summary>
    /// Set calender SendTo Email.
    /// </summary>
    /// <param name="SendToEmail">Text.</param>
    internal procedure SetSendToEmail(SendToEmail: Text[250])
    begin
        CalenderMessageImplEVAS.SetSendToEmail(SendToEmail);
    end;

    /// <summary>
    /// Get calender SendTo Email.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetSendToEmail(): Text
    begin
        exit(CalenderMessageImplEVAS.GetSendToEmail());
    end;

    /// <summary>
    /// Set calender Send CcEmail.
    /// </summary>
    /// <param name="SendCcEmail">Text.</param>
    internal procedure SetSendCcEmail(SendCcEmail: Text[250])
    begin
        CalenderMessageImplEVAS.SetSendCcEmail(SendCcEmail);
    end;

    /// <summary>
    /// Get calender Send CcEmail.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetSendCcEmail(): Text
    begin
        exit(CalenderMessageImplEVAS.GetSendCcEmail());
    end;

    /// <summary>
    /// Set calender SendBcc Email.
    /// </summary>
    /// <param name="SendBccEmail">Text.</param>
    internal procedure SetSendBccEmail(SendBccEmail: Text[250])
    begin
        CalenderMessageImplEVAS.SetSendBccEmail(SendBccEmail);
    end;

    /// <summary>
    /// Get calender SendBcc Email.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetSendBccEmail(): Text
    begin
        exit(CalenderMessageImplEVAS.GetSendBccEmail());
    end;

    /// <summary>
    /// Set Calender StartDateTime.
    /// </summary>
    /// <param name="StartDateTime">DateTime.</param>
    internal procedure SetStartDateTime(StartDateTime: DateTime)
    begin
        CalenderMessageImplEVAS.SetStartDateTime(StartDateTime);
    end;

    /// <summary>
    /// GetStartDateTime.
    /// </summary>
    /// <returns>Return variable StartDateTime of type DateTime.</returns>
    internal procedure GetStartDateTime() StartDateTime: DateTime
    begin
        exit(CalenderMessageImplEVAS.GetStartDateTime());
    end;

    /// <summary>
    /// Set Calender EndDate.
    /// </summary>
    /// <param name="StartDate">Date.</param>
    /// <param name="Duration">Decimal.</param>
    internal procedure SetEndDate(StartDate: Date; Duration: Decimal)
    begin
        CalenderMessageImplEVAS.SetEndDate(StartDate, Duration);
    end;

    /// <summary>
    /// Set Calender EndDateTime.
    /// </summary>
    /// <param name="EndDateTime">DateTime.</param>
    internal procedure SetEndDateTime(EndDateTime: DateTime)
    begin
        CalenderMessageImplEVAS.SetEndDateTime(EndDateTime);
    end;

    /// <summary>
    /// GetEndDateTime.
    /// </summary>
    /// <returns>Return variable EndDateTime of type DateTime.</returns>
    internal procedure GetEndDateTime() EndDateTime: DateTime
    begin
        exit(CalenderMessageImplEVAS.GetEndDateTime());
    end;

    /// <summary>
    /// Set Calender AppointmentDescription.
    /// </summary>
    /// <param name="DescriptionIn">Text.</param>
    internal procedure SetAppointmentDescription(DescriptionIn: Text)
    begin
        CalenderMessageImplEVAS.SetAppointmentDescription(DescriptionIn);
    end;

    /// <summary>
    /// Get AppointmentDescription.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetAppointmentDescription(): Text
    begin
        exit(CalenderMessageImplEVAS.GetAppointmentDescription());
    end;

    /// <summary>
    /// Set Calender Subject.
    /// </summary>
    /// <param name="Subject">Text.</param>
    internal procedure SetSubject(Subject: Text[250])
    begin
        CalenderMessageImplEVAS.SetSubject(Subject);
    end;

    /// <summary>
    /// Get Calender Subject.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetSubject(): Text
    begin
        exit(CalenderMessageImplEVAS.GetSubject());
    end;

    /// <summary>
    /// Set Calender Location.
    /// </summary>
    /// <param name="Location">Text.</param>
    internal procedure SetLocation(Location: Text[250])
    begin
        CalenderMessageImplEVAS.SetLocation(Location);
    end;

    /// <summary>
    /// Get Calender Location.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetLocation(): Text
    begin
        exit(CalenderMessageImplEVAS.GetLocation());
    end;

    /// <summary>
    /// Set Calender Summery.
    /// </summary>
    /// <param name="Summery">text.</param>
    internal procedure SetSummery(Summery: text)
    begin
        CalenderMessageImplEVAS.SetSummery(Summery);
    end;

    /// <summary>
    /// Get Calender Summery.
    /// </summary>
    /// <returns>Return value of type text.</returns>
    internal procedure GetSummery(): text
    begin
        exit(CalenderMessageImplEVAS.GetSummery());
    end;

    /// <summary>
    /// Set Calender UID.
    /// </summary>
    /// <param name="UIDIn">Guid.</param>
    internal procedure SetUID(UIDIn: Guid)
    begin
        CalenderMessageImplEVAS.SetUID(UIDIn);
    end;

    /// <summary>
    /// Get Calender UID.
    /// </summary>
    /// <returns>Return value of type Guid.</returns>
    internal procedure GetUID(): Guid
    begin
        exit(CalenderMessageImplEVAS.GetUID());
    end;

    /// <summary>
    /// Set Calender Sequence.
    /// </summary>
    /// <param name="Sequence">Integer.</param>
    internal procedure SetSequence(Sequence: Integer)
    begin
        CalenderMessageImplEVAS.SetSequence(Sequence);
    end;

    /// <summary>
    /// Get Calender Sequence.
    /// </summary>
    /// <returns>Return value of type Integer.</returns>
    internal procedure GetSequence(): Integer
    begin
        exit(CalenderMessageImplEVAS.GetSequence());
    end;

    /// <summary>
    /// Set Calender SendRequest.
    /// </summary>
    /// <param name="CreateAppointment">Boolean.</param>
    internal procedure SetCreateAppointment(CreateAppointment: Boolean)
    begin
        CalenderMessageImplEVAS.SetCreateAppointment(CreateAppointment);
    end;

    /// <summary>
    /// Get Calender SendRequest.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    internal procedure GetCreateAppointment(): Boolean
    begin
        exit(CalenderMessageImplEVAS.GetCreateAppointment());
    end;

    /// <summary>
    /// Set Calender SendCancellation.
    /// </summary>
    /// <param name="CancelAppointment">Boolean.</param>
    internal procedure SetCancelAppointment(CancelAppointment: Boolean)
    begin
        CalenderMessageImplEVAS.SetCancelAppointment(CancelAppointment);
    end;

    /// <summary>
    /// Get Calender SendCancellation.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    internal procedure GetCancelAppointment(): Boolean
    begin
        exit(CalenderMessageImplEVAS.GetCancelAppointment());
    end;

    /// <summary>
    /// SetUpdateAppointment.
    /// </summary>
    /// <param name="UpdateAppointment">Boolean.</param>
    internal procedure SetUpdateAppointment(UpdateAppointment: Boolean)
    begin
        CalenderMessageImplEVAS.SetUpdateAppointment(UpdateAppointment);
    end;

    /// <summary>
    /// GetUpdateAppointment.
    /// </summary>
    /// <returns>Return value of type Boolean.</returns>
    internal procedure GetUpdateAppointment(): Boolean
    begin
        exit(CalenderMessageImplEVAS.GetUpdateAppointment());
    end;


    /// <summary>
    /// Set Calender AttachmentName.
    /// </summary>
    /// <param name="AttchmentName">Text.</param>
    internal procedure SetAttachmentName(AttchmentName: Text)
    begin
        CalenderMessageImplEVAS.SetAttachmentName(AttchmentName);
    end;

    /// <summary>
    /// Get Calender AttachmentName.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetAttachmentName(): Text
    begin
        exit(CalenderMessageImplEVAS.GetAttachmentName());
    end;

    /// <summary>
    /// Set Calender Message Body.
    /// </summary>
    /// <param name="MessageBody">Text.</param>
    internal procedure SetMessageBody(MessageBody: Text)
    begin
        CalenderMessageImplEVAS.SetMessageBody(MessageBody);
    end;

    /// <summary>
    /// Get Calender Message Body.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetMessageBody(): Text
    begin
        exit(CalenderMessageImplEVAS.GetMessageBody());
    end;

    /// <summary>
    /// Set a Record - Tablename added to the TelemetryText.
    /// </summary>
    /// <param name="RecordVariant">Variant.</param>
    internal procedure SetRecord(RecordVariant: Variant)
    begin
        CalenderMessageImplEVAS.SetRecord(RecordVariant);
    end;

    /// <summary>
    /// Get Record.
    /// </summary>
    /// <param name="RecRef">VAR RecordRef.</param>
    internal procedure GetRecord(var RecRef: RecordRef)
    begin
        CalenderMessageImplEVAS.GetRecord(RecRef);
    end;

    /// <summary>
    /// Set TelemetryText.
    /// </summary>
    /// <param name="TelemetryText">Text.</param>
    internal procedure SetTelemetryText(TelemetryText: Text)
    begin
        CalenderMessageImplEVAS.SetTelemetryText(TelemetryText);
    end;

    /// <summary>
    /// Get TelemetryText.
    /// </summary>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetTelemetryText(): Text
    begin
        exit(CalenderMessageImplEVAS.GetTelemetryText());
    end;

    /// <summary>
    /// Set Email Scenario.
    /// </summary>
    /// <param name="EmailScenario">Enum "Email Scenario".</param>
    internal procedure SetEmailScenario(EmailScenario: Enum "Email Scenario")
    begin
        CalenderMessageImplEVAS.SetEmailScenario(EmailScenario);
    end;

    /// <summary>
    /// Get Email Scenario.
    /// </summary>
    /// <returns>Return value of type Enum "Email Scenario".</returns>
    internal procedure GetEmailScenario(): Enum "Email Scenario"
    begin
        exit(CalenderMessageImplEVAS.GetEmailScenario());
    end;

    /// <summary>
    /// CheckMandatoryCalender.
    /// </summary>
    internal procedure CheckMandatoryCalender()
    begin
        CalenderMessageImplEVAS.CheckMandatoryCalender();
    end;

    /// <summary>
    /// AddEmailAddressForLookup.
    /// </summary>
    /// <param name="Name">Text[250].</param>
    /// <param name="EmailAddress">Text[250].</param>
    internal procedure AddEmailAddressForLookup(Name: Text[250]; EmailAddress: Text[250])
    begin
        CalenderMessageImplEVAS.AddEmailAddressForLookup(Name, EmailAddress);
    end;

    /// <summary>
    /// AddEmailAddressForLookup.
    /// </summary>
    /// <param name="Name">Text[250].</param>
    /// <param name="EmailAddress">Text[250].</param>
    /// <param name="EmailRecipientType">Enum "Email Recipient Type".</param>
    internal procedure AddEmailAddressForLookup(Name: Text[250]; EmailAddress: Text[250]; EmailRecipientType: Enum "Email Recipient Type")
    begin
        CalenderMessageImplEVAS.AddEmailAddressForLookup(Name, EmailAddress, EmailRecipientType);
    end;

    /// <summary>
    /// LookupAllRecipients.
    /// </summary>
    /// <param name="CalenderEntryID">Guid.</param>
    /// <param name="Text">VAR Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    internal procedure LookupAllRecipients(CalenderEntryID: Guid; var Text: Text): Boolean
    begin
        exit(CalenderMessageImplEVAS.LookupAllRecipients(CalenderEntryID, Text));
    end;

    /// <summary>
    /// LookupRecipients.
    /// </summary>
    /// <param name="CalenderEntryID">Guid.</param>
    /// <param name="EmailRecipientType">Enum "Email Recipient Type".</param>
    /// <param name="Text">VAR Text.</param>
    /// <returns>Return value of type Boolean.</returns>
    internal procedure LookupRecipients(CalenderEntryID: Guid; EmailRecipientType: Enum "Email Recipient Type"; var Text: Text): Boolean
    begin
        exit(CalenderMessageImplEVAS.LookupRecipients(CalenderEntryID, EmailRecipientType, Text));
    end;

    /// <summary>
    /// CreateNewCalenderEntry.
    /// </summary>
    /// <param name="OutlookCalenderEntry">VAR Record "Outlook Calender Entry_EVAS".</param>
    internal procedure CreateNewCalenderEntry(var OutlookCalenderEntry: Record "Outlook Calender Entry_EVAS")
    begin
        CalenderMessageImplEVAS.CreateNewCalenderEntry(OutlookCalenderEntry);
    end;

    /// <summary>
    /// SetCalenderEntry.
    /// </summary>
    /// <param name="OutlookCalenderEntry">VAR Record "Outlook Calender Entry_EVAS".</param>
    internal procedure SetCalenderEntry(var OutlookCalenderEntry: Record "Outlook Calender Entry_EVAS")
    begin
        CalenderMessageImplEVAS.SetCalenderEntry(OutlookCalenderEntry);
    end;

    /// <summary>
    /// GetCalenderMessage.
    /// </summary>
    /// <param name="OutlookCalenderEntry">Record "Outlook Calender Entry_EVAS".</param>
    internal procedure GetCalenderMessage(OutlookCalenderEntry: Record "Outlook Calender Entry_EVAS")
    begin
        CalenderMessageImplEVAS.GetCalenderMessage(OutlookCalenderEntry);
    end;

    /// <summary>
    /// SaveCalenderEmailRecipients.
    /// </summary>
    internal procedure SaveCalenderEmailRecipients()
    begin
        CalenderMessageImplEVAS.SaveCalenderEmailRecipients();
    end;

    /// <summary>
    /// GetCalenderEntry.
    /// </summary>
    /// <param name="UIDin">Guid.</param>
    /// <returns>Return value of type Record "Outlook Calender Entry_EVAS".</returns>
    internal procedure GetCalenderEntry(UIDin: Guid): Record "Outlook Calender Entry_EVAS"
    begin
        exit(CalenderMessageImplEVAS.GetCalenderEntry(UIDin));
    end;
}
