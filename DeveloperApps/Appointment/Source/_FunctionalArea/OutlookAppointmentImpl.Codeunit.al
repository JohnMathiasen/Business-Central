/// <summary>
/// Codeunit Outlook Appointment Impl._EVAS (ID 50303).
/// </summary>
codeunit 50303 "Outlook Appointment Impl._EVAS"
{
    /// <summary>
    /// CreateAppointment.
    /// </summary>
    /// <param name="CalenderMessage">VAR Codeunit "Outlook Calender Content_EVAS".</param>
    /// <param name="HideMailDialog">Boolean.</param>
    /// <param name="HideEmailSendingError">Boolean.</param>
    /// <returns>Return value of type Boolean.</returns>
    internal procedure CreateAppointment(var CalenderMessage: Codeunit "Calender Message_EVAS"; HideMailDialog: Boolean; HideEmailSendingError: Boolean): Boolean
    begin
        CalenderMessage.SetCreateAppointment(true);
        exit(HandleAppointment(CalenderMessage, HideMailDialog, HideEmailSendingError));
    end;

    /// <summary>
    /// UpdateAppointment.
    /// </summary>
    /// <param name="CalenderMessage">VAR Codeunit "Outlook Calender Content_EVAS".</param>
    /// <param name="HideMailDialog">Boolean.</param>
    /// <param name="HideEmailSendingError">Boolean.</param>
    /// <returns>Return value of type Boolean.</returns>
    internal procedure UpdateAppointment(var CalenderMessage: Codeunit "Calender Message_EVAS"; HideMailDialog: Boolean; HideEmailSendingError: Boolean): Boolean
    begin
        CalenderMessage.SetUpdateAppointment(true);
        exit(HandleAppointment(CalenderMessage, HideMailDialog, HideEmailSendingError));
    end;

    /// <summary>
    /// CancelAppointment.
    /// </summary>
    /// <param name="CalenderMessage">VAR Codeunit "Outlook Calender Content_EVAS".</param>
    /// <param name="HideMailDialog">Boolean.</param>
    /// <param name="HideEmailSendingError">Boolean.</param>
    /// <returns>Return value of type Boolean.</returns>
    internal procedure CancelAppointment(var CalenderMessage: Codeunit "Calender Message_EVAS"; HideMailDialog: Boolean; HideEmailSendingError: Boolean): Boolean
    begin
        CalenderMessage.SetCancelAppointment(true);
        exit(HandleAppointment(CalenderMessage, HideMailDialog, HideEmailSendingError));
    end;


    /// <summary>
    /// HandleAppointment.
    /// </summary>
    /// <param name="CalenderMessage">VAR Codeunit "Calender Message_EVAS".</param>
    /// <param name="HideMailDialog">Boolean.</param>
    /// <param name="HideEmailSendingError">Boolean.</param>
    /// <returns>Return value of type Boolean.</returns>
    internal procedure HandleAppointment(var CalenderMessage: Codeunit "Calender Message_EVAS"; HideMailDialog: Boolean; HideEmailSendingError: Boolean): Boolean
    var
        ErrorMessageManagement: Codeunit "Error Message Management";
        AppointmentcreateErr: Label 'Appointment cancelled, due to error, when creating a new appointment', Comment = 'DAN="Aftalen er annulleret, som følge af fejl ved oprettelse af ny aftale"';
        Cancelled: Boolean;
        MailSent: Boolean;
        CreateAppmnt, CancelAppmnt : Boolean;
    begin
        CreateAppmnt := CalenderMessage.GetCreateAppointment();
        CancelAppmnt := CalenderMessage.GetCancelAppointment();

        ClearLastError();
        Cancelled := false;
        UpdateSequence(CalenderMessage, CreateAppmnt, CancelAppmnt);
        if not HideMailDialog then begin
            Commit();
            MailSent := OpenAppointmentEditor(CalenderMessage, true) = Enum::"Email Action"::Sent;
            Cancelled := not MailSent;
        end else
            case true of
                (CreateAppmnt) and (not CancelAppmnt):
                    MailSent := CreateAndSendAppointment(CalenderMessage, HideMailDialog);
                (not CreateAppmnt) and (CancelAppmnt):
                    MailSent := CancelAndSendApppointment(CalenderMessage, HideMailDialog);
                (CreateAppmnt) and (CancelAppmnt):
                    if CreateAndSendAppointment(CalenderMessage, HideMailDialog) then
                        exit(true)
                    else
                        Error(AppointmentcreateErr);
            end;

        if not MailSent and not Cancelled and not HideEmailSendingError then
            ErrorMessageManagement.LogSimpleErrorMessage(GetLastErrorText());

        exit(MailSent);
    end;


    local procedure CancelAndSendApppointment(var CalenderMessage: Codeunit "Calender Message_EVAS"; HideMailDialog: Boolean): Boolean
    var
        TempEmailItem: Record "Email Item" temporary;
    begin
        CalenderMessage.CheckMandatoryCalender();

        if CreateCalenderCancellation(CalenderMessage) then
            if CreateCancellation(TempEmailItem, CalenderMessage) then
                exit(TempEmailItem.Send(HideMailDialog, CalenderMessage.GetEmailScenario()));
        exit(false);
    end;


    local procedure CreateAndSendAppointment(var CalenderMessage: Codeunit "Calender Message_EVAS"; HideMailDialog: Boolean): Boolean
    var
        TempEmailItem: Record "Email Item" temporary;
        OfficeAddinTelemetryCategoryTxt: Label 'AL Office Add-in', Locked = true;
    begin
        CalenderMessage.CheckMandatoryCalender();

        if CreateCalenderAppointment(CalenderMessage) then
            if CreateRequest(TempEmailItem, CalenderMessage) then begin
                Session.LogMessage('0000ACX', CalenderMessage.GetTelemetryText(), Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', OfficeAddinTelemetryCategoryTxt);
                exit(TempEmailItem.Send(HideMailDialog, CalenderMessage.GetEmailScenario()));
            end;
        exit(false);
    end;

    /// <summary>
    /// CreateRequest.
    /// </summary>
    /// <param name="TempEmailItem">Temporary VAR Record "Email Item".</param>
    /// <param name="CalenderMessage">Codeunit "Outlook Calender Content_EVAS".</param>
    /// <returns>Return value of type Boolean.</returns>
    internal procedure CreateRequest(var TempEmailItem: Record "Email Item" temporary; CalenderMessage: Codeunit "Calender Message_EVAS"): Boolean
    begin
        if not CreateCalenderAppointment(CalenderMessage) then
            exit;

        CalenderMessage.CheckMandatoryCalender();

        if CalenderMessage.GetFromEmail() <> '' then begin
            GenerateEmail(TempEmailItem, false, CalenderMessage);
            exit(true);
        end;
    end;

    /// <summary>
    /// CreateCancellation.
    /// </summary>
    /// <param name="TempEmailItem">Temporary VAR Record "Email Item".</param>
    /// <param name="CalenderMessage">Codeunit "Outlook Calender Content_EVAS".</param>
    /// <returns>Return value of type Boolean.</returns>
    internal procedure CreateCancellation(var TempEmailItem: Record "Email Item" temporary; CalenderMessage: Codeunit "Calender Message_EVAS"): Boolean
    begin

        if not CreateCalenderCancellation(CalenderMessage) then
            exit(false);

        CalenderMessage.CheckMandatoryCalender();

        if CalenderMessage.GetFromEmail() <> '' then begin
            GenerateEmail(TempEmailItem, true, CalenderMessage);

            exit(true);
        end;
    end;

    /// <summary>
    /// OpenAppointmentEditor.
    /// </summary>
    /// <param name="CalenderMessage">VAR Codeunit "Calender Message_EVAS".</param>
    /// <param name="IsModal">Boolean.</param>
    /// <returns>Return value of type Enum "Email Action".</returns>
    internal procedure OpenAppointmentEditor(var CalenderMessage: Codeunit "Calender Message_EVAS"; IsModal: Boolean): Enum "Email Action"
    var
        OutlookCalenderEntry: Record "Outlook Calender Entry_EVAS";
    begin
        OutlookCalenderEntry := CalenderMessage.GetCalenderEntry(CalenderMessage.GetUID());
        exit(OpenAppointmentEditor(CalenderMessage, OutlookCalenderEntry, IsModal));
    end;

    /// <summary>
    /// OpenAppointmentEditor.
    /// </summary>
    /// <param name="OutlookCalenderEntry">VAR Record "Outlook Calender Entry_EVAS".</param>
    /// <param name="IsModal">Boolean.</param>
    /// <returns>Return value of type Enum "Email Action".</returns>
    internal procedure OpenAppointmentEditor(var OutlookCalenderEntry: Record "Outlook Calender Entry_EVAS"; IsModal: Boolean): Enum "Email Action"
    var
        CalenderMessage: Codeunit "Calender Message_EVAS";
    begin
        CalenderMessage.GetCalenderMessage(OutlookCalenderEntry);
        exit(OpenAppointmentEditor(CalenderMessage, OutlookCalenderEntry, IsModal));
    end;

    local procedure OpenAppointmentEditor(var CalenderMessage: Codeunit "Calender Message_EVAS"; var OutlookCalenderEntry: Record "Outlook Calender Entry_EVAS"; IsModal: Boolean): Enum "Email Action"
    var
        EmailEditorPage: Page "Appointment Email_EVAS";
        EmailAction: Enum "Email Action";
    begin
        EmailEditorPage.SetTableView(OutlookCalenderEntry);
        EmailEditorPage.SetCalenderMessage(CalenderMessage);
        if OutlookCalenderEntry.id <> 0 then
            EmailEditorPage.SetAsNew();

        if IsModal then begin
            Commit(); // Commit before opening modally
            EmailEditorPage.RunModal();
            EmailEditorPage.GetCalenderMessage(CalenderMessage);
            OutlookCalenderEntry := CalenderMessage.GetCalenderEntry(CalenderMessage.GetUID());
            EmailAction := EmailEditorPage.GetAction();
            if EmailAction = EmailAction::"Saved As Draft" then
                CalenderMessage.SaveCalenderEmailRecipients();
            exit(EmailAction);
        end
        else
            EmailEditorPage.Run();
    end;

    /// <summary>
    /// GetEmailAccount.
    /// </summary>
    /// <param name="OutlookCalenderEntry">Record "Outlook Calender Entry_EVAS".</param>
    /// <returns>Return variable EmailAccount of type Record "Email Account".</returns>
    internal procedure GetEmailAccount(OutlookCalenderEntry: Record "Outlook Calender Entry_EVAS") EmailAccount: Record "Email Account";
    var
        EmailAccounts: Codeunit "Email Account";
    begin
        EmailAccounts.GetAllAccounts(EmailAccount);

        if not EmailAccount.Get(OutlookCalenderEntry."Account Id", OutlookCalenderEntry.Connector) then
            Clear(EmailAccount);
        exit(EmailAccount);
    end;

    local procedure GenerateEmail(var TempEmailItem: Record "Email Item" temporary; Cancel: Boolean; CalenderMessage: Codeunit "Calender Message_EVAS")
    var

        TempBlob: Codeunit "Temp Blob";
        AttachFileNameTxt: Label '%1.ics', Comment = '%1= file name';
        Stream: OutStream;
        InStream: Instream;
        ICS: Text;
    begin
        ICS := GenerateICS(Cancel, CalenderMessage);
        TempBlob.CreateOutStream(Stream, TextEncoding::UTF8);
        Stream.Write(ICS);
        TempBlob.CreateInStream(InStream);

        TempEmailItem.Initialize();
        TempEmailItem."From Address" := CalenderMessage.GetFromEmail();
        TempEmailItem."Send to" := CopyStr(CalenderMessage.GetSendToEmail(), 1, MaxStrLen(TempEmailItem."Send to"));
        TempEmailItem."Send CC" := CopyStr(CalenderMessage.GetSendCcEmail(), 1, MaxStrLen(TempEmailItem."Send CC"));
        TempEmailItem."Send BCC" := CopyStr(CalenderMessage.GetSendBccEmail(), 1, MaxStrLen(TempEmailItem."Send BCC"));
        TempEmailItem.Subject := CalenderMessage.GetSubject();
        TempEmailItem."Starting DateTime_EVAS" := CalenderMessage.GetStartDateTime();
        TempEmailItem."Ending DateTime_EVAS" := CalenderMessage.GetEndDateTime();
        TempEmailItem.AddAttachment(InStream, StrSubstNo(AttachFileNameTxt, CalenderMessage.GetAttachmentName()));
        TempEmailItem.Location_EVAS := CopyStr(CalenderMessage.GetLocation(), 1, MaxStrLen(TempEmailItem.Location_EVAS));
        TempEmailItem.SetBodyText(CalenderMessage.GetMessageBody());
        TempEmailItem.Cancellation_EVAS := Cancel;
        AddCalenderAttachmentToEmail(TempEmailItem, CalenderMessage);
    end;

    local procedure AddCalenderAttachmentToEmail(var TempEmailItem: Record "Email Item" temporary; CalenderMessage: Codeunit "Calender Message_EVAS")
    var
        CalenderMsgAttachment: Record "Calender Msg. Attachment_EVAS";
        TempBlob: Codeunit "Temp Blob";
        Outstream: OutStream;
        Instream: InStream;
    begin
        CalenderMsgAttachment.SetRange("Calender Message Id", CalenderMessage.GetUID());
        if CalenderMsgAttachment.FindSet() then
            repeat
                TempBlob.CreateOutStream(Outstream);
                CalenderMsgAttachment.Data.ExportStream(Outstream);
                TempBlob.CreateInStream(Instream);
                TempEmailItem.AddAttachment(InStream, CalenderMsgAttachment."Attachment Name");
            until CalenderMsgAttachment.Next() = 0;
        CalenderMsgAttachment.DeleteAll();
    end;

    local procedure GenerateICS(Cancel: Boolean; CalenderMessage: Codeunit "Calender Message_EVAS") ICS: Text
    var
        TextBuilder: TextBuilder;
        Status: Text;
        Method: Text;
        ProdIDTxt: Label '//Microsoft Corporation//Dynamics 365//EN', Locked = true;
    begin
        if Cancel then begin
            Method := 'CANCEL';
            Status := 'CANCELLED';
        end else begin
            Method := 'REQUEST';
            Status := 'CONFIRMED';
        end;

        TextBuilder.AppendLine('BEGIN:VCALENDAR');
        TextBuilder.AppendLine('VERSION:2.0');
        TextBuilder.AppendLine('PRODID:-' + ProdIDTxt);
        TextBuilder.AppendLine('METHOD:' + Method);
        TextBuilder.AppendLine('BEGIN:VEVENT');
        TextBuilder.AppendLine('UID:' + DelChr(CalenderMessage.GetUID(), '<>', '{}'));
        TextBuilder.AppendLine('ORGANIZER:' + CalenderMessage.GetFromEmail());
        TextBuilder.AppendLine('LOCATION:' + CalenderMessage.GetLocation());
        TextBuilder.AppendLine('DTSTART:' + GetStartDatetimeTxt(CalenderMessage));
        TextBuilder.AppendLine('DTEND:' + GetEndDatetimeText(CalenderMessage));
        TextBuilder.AppendLine('SUMMARY:' + CalenderMessage.GetSummery());
        TextBuilder.AppendLine('DESCRIPTION:' + CalenderMessage.GetAppointmentDescription());
        TextBuilder.AppendLine('X-ALT-DESC;FMTTYPE=' + GetHtmlDescription(CalenderMessage.GetAppointmentDescription()));
        TextBuilder.AppendLine('SEQUENCE:' + Format(CalenderMessage.GetSequence()));
        TextBuilder.AppendLine('STATUS:' + Status);
        TextBuilder.AppendLine('END:VEVENT');
        TextBuilder.AppendLine('END:VCALENDAR');
        ICS := TextBuilder.ToText();
    end;

    local procedure GetEndDatetimeText(CalenderMessage: Codeunit "Calender Message_EVAS") EndDateTime: Text
    var
        DateTimeFormatTxt: Label '<Year4><Month,2><Day,2>T<Hours24,2><Minutes,2><Seconds,2>', Locked = true;
    begin
        EndDateTime := Format(CalenderMessage.GetEndDateTime(), 0, DateTimeFormatTxt);
    end;

    local procedure GetStartDatetimeTxt(CalenderMessage: Codeunit "Calender Message_EVAS") StartDateTime: Text
    var
        DateTimeFormatTxt: Label '<Year4><Month,2><Day,2>T<Hours24,2><Minutes,2><Seconds,2>', Locked = true;
    begin
        StartDateTime := Format(CalenderMessage.GetStartDateTime(), 0, DateTimeFormatTxt);
    end;

    local procedure GetHtmlDescription(Description: Text) HtmlAppointDescription: Text
    var
        Regex: Codeunit Regex;
    begin
        HtmlAppointDescription := Regex.Replace(Description, '\\r', '');
        HtmlAppointDescription := Regex.Replace(HtmlAppointDescription, '\\n', '<br>');
        HtmlAppointDescription := 'text/html:<html><body>' + HtmlAppointDescription + '</html></body>';
    end;

    local procedure CreateCalenderAppointment(var CalenderMessage: Codeunit "Calender Message_EVAS"): Boolean
    var
        UID: Guid;
    begin
        if not CalenderMessage.GetCreateAppointment() then
            exit(false);

        UID := CalenderMessage.GetUID();

        if IsNullGuid(UID) then
            CalenderMessage.SetUID(CreateGuid());
        exit(true);
    end;

    local procedure CreateCalenderCancellation(var CalenderMessage: Codeunit "Calender Message_EVAS"): Boolean
    var
        MissingUIDTxt: Label 'Cannot cancel an appointment without af reference to the oulook appointment', Comment = 'DAN="Kan ikke annullere en aftale uden referencen til oulook aftalen"';
        UID: Guid;
    begin
        if not CalenderMessage.GetCancelAppointment() then
            exit(false);

        UID := CalenderMessage.GetUID();
        if IsNullGuid(UID) then
            error(MissingUIDTxt);
        exit(true);
    end;

    local procedure UpdateSequence(var CalenderMessage: Codeunit "Calender Message_EVAS"; CreateAppmnt: Boolean; CancelAppmnt: Boolean)
    var
        Sequence: Integer;
    begin
        Sequence := CalenderMessage.GetSequence();
        case true of
            (CreateAppmnt) and (not CancelAppmnt):
                if Sequence = 0 then
                    Sequence := 1;
            (not CreateAppmnt) and (CancelAppmnt):
                Sequence += 1;
            (CreateAppmnt) and (CancelAppmnt):
                Sequence += 1;
        end;
        CalenderMessage.SetSequence(Sequence);
    end;

    internal procedure DiscardAppointment(var OutlookCalenderEntry: Record "Outlook Calender Entry_EVAS"; Confirm: Boolean): Boolean
    var
        ConfirmDiscardEmailQst: Label 'Go ahead and discard?', Comment = 'DAN="Slet aftale mail?"';
    begin
        if Confirm then
            if not Confirm(ConfirmDiscardEmailQst, true) then
                exit(false);

        exit(OutlookCalenderEntry.Delete(true));
    end;

    /// <summary>
    /// UploadAttachment.
    /// </summary>
    /// <param name="CalenderMsgAttachment">Record "Calender Msg. Attachment_EVAS".</param>
    internal procedure UploadAttachment(CalenderMsgAttachment: Record "Calender Msg. Attachment_EVAS");
    var
        FileName: Text;
        Instream: Instream;
        AttachmentName, ContentType : Text[250];
        AttachamentSize: Integer;
        UploadingAttachmentMsg: Label 'Attached file with size: %1, Content type: %2', Comment = '%1 - File size, %2 - Content type', Locked = true;
        EmailCategoryLbl: Label 'Email', Locked = true;
    begin
        UploadIntoStream('', '', '', FileName, Instream);
        if FileName = '' then
            exit;

        AttachmentName := CopyStr(FileName, 1, 250);
        ContentType := CalenderMsgAttachment.GetContentTypeFromFilename(Filename);
        //AttachamentSize := EmailMessageImpl.AddAttachmentInternal(AttachmentName, ContentType, Instream);
        AttachamentSize := CalenderMsgAttachment.AddAttachmentInternal(AttachmentName, ContentType, Instream, CalenderMsgAttachment."Calender Message Id");
        Session.LogMessage('0000CTX', StrSubstNo(UploadingAttachmentMsg, AttachamentSize, ContentType), Verbosity::Normal, DataClassification::SystemMetadata, TelemetryScope::ExtensionPublisher, 'Category', EmailCategoryLbl);
    end;

    /// <summary>
    /// DownloadAttachment.
    /// </summary>
    /// <param name="MediaID">Guid.</param>
    /// <param name="FileName">Text.</param>
    internal procedure DownloadAttachment(MediaID: Guid; FileName: Text)
    var
        TenantMedia: Record "Tenant Media";
        MediaInStream: InStream;
    begin
        TenantMedia.Get(MediaID);
        TenantMedia.CalcFields(Content);

        if TenantMedia.Content.HasValue() then
            TenantMedia.Content.CreateInStream(MediaInStream);
        DownloadFromStream(MediaInStream, '', '', '', FileName);
    end;
}
