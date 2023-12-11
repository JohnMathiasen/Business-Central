/// <summary>
/// Codeunit Outlook Appointment_EVAS (ID 50300).
/// </summary>
codeunit 50300 "Outlook Appointment_EVAS"
{
    var
        OutlookAppointmentImplEVAS: Codeunit "Outlook Appointment Impl._EVAS";

    /// <summary>
    /// CreateAppointment.
    /// </summary>
    /// <param name="CalenderMessage">VAR Codeunit "Outlook Calender Content_EVAS".</param>
    /// <param name="HideMailDialog">Boolean.</param>
    /// <param name="HideEmailSendingError">Boolean.</param>
    /// <returns>Return value of type Boolean.</returns>
    internal procedure CreateAppointment(var CalenderMessage: Codeunit "Calender Message_EVAS"; HideMailDialog: Boolean; HideEmailSendingError: Boolean): Boolean
    begin
        exit(OutlookAppointmentImplEVAS.CreateAppointment(CalenderMessage, HideMailDialog, HideEmailSendingError));
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
        exit(OutlookAppointmentImplEVAS.UpdateAppointment(CalenderMessage, HideMailDialog, HideEmailSendingError));
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
        exit(OutlookAppointmentImplEVAS.CancelAppointment(CalenderMessage, HideMailDialog, HideEmailSendingError));
    end;

    /// <summary>
    /// HandleAppointment.
    /// </summary>
    /// <param name="CalenderMessage">VAR Codeunit "Calender Message_EVAS".</param>
    /// <param name="HideMailDialog">Boolean.</param>
    /// <param name="HideEmailSendingError">Boolean.</param>
    /// <returns>Return value of type Boolean.</returns>
    internal procedure HandleAppointment(var CalenderMessage: Codeunit "Calender Message_EVAS"; HideMailDialog: Boolean; HideEmailSendingError: Boolean): Boolean
    begin
        exit(OutlookAppointmentImplEVAS.HandleAppointment(CalenderMessage, HideMailDialog, HideEmailSendingError));
    end;

    /// <summary>
    /// CreateRequest.
    /// </summary>
    /// <param name="TempEmailItem">Temporary VAR Record "Email Item".</param>
    /// <param name="CalenderMessage">Codeunit "Outlook Calender Content_EVAS".</param>
    /// <returns>Return value of type Boolean.</returns>
    internal procedure CreateRequest(var TempEmailItem: Record "Email Item" temporary; CalenderMessage: Codeunit "Calender Message_EVAS"): Boolean
    begin
        exit(OutlookAppointmentImplEVAS.CreateRequest(TempEmailItem, CalenderMessage));
    end;

    /// <summary>
    /// CreateCancellation.
    /// </summary>
    /// <param name="TempEmailItem">Temporary VAR Record "Email Item".</param>
    /// <param name="CalenderMessage">Codeunit "Outlook Calender Content_EVAS".</param>
    /// <returns>Return value of type Boolean.</returns>
    internal procedure CreateCancellation(var TempEmailItem: Record "Email Item" temporary; CalenderMessage: Codeunit "Calender Message_EVAS"): Boolean
    begin
        exit(OutlookAppointmentImplEVAS.CreateCancellation(TempEmailItem, CalenderMessage));
    end;

    /// <summary>
    /// OpenAppointmentEditor.
    /// </summary>
    /// <param name="CalenderMessage">VAR Codeunit "Calender Message_EVAS".</param>
    /// <param name="IsModal">Boolean.</param>
    /// <returns>Return value of type Enum "Email Action".</returns>
    internal procedure OpenAppointmentEditor(var CalenderMessage: Codeunit "Calender Message_EVAS"; IsModal: Boolean): Enum "Email Action"
    begin
        exit(OutlookAppointmentImplEVAS.OpenAppointmentEditor(CalenderMessage, IsModal));
    end;

    /// <summary>
    /// OpenAppointmentEditor.
    /// </summary>
    /// <param name="OutlookCalenderEntry">VAR Record "Outlook Calender Entry_EVAS".</param>
    /// <param name="IsModal">Boolean.</param>
    /// <returns>Return value of type Enum "Email Action".</returns>
    internal procedure OpenAppointmentEditor(var OutlookCalenderEntry: Record "Outlook Calender Entry_EVAS"; IsModal: Boolean): Enum "Email Action"
    begin
        exit(OutlookAppointmentImplEVAS.OpenAppointmentEditor(OutlookCalenderEntry, IsModal));
    end;

    /// <summary>
    /// GetEmailAccount.
    /// </summary>
    /// <param name="OutlookCalenderEntry">Record "Outlook Calender Entry_EVAS".</param>
    /// <returns>Return variable EmailAccount of type Record "Email Account".</returns>
    internal procedure GetEmailAccount(OutlookCalenderEntry: Record "Outlook Calender Entry_EVAS") EmailAccount: Record "Email Account";
    begin
        exit(OutlookAppointmentImplEVAS.GetEmailAccount(OutlookCalenderEntry));
    end;

    /// <summary>
    /// DiscardAppointment.
    /// </summary>
    /// <param name="OutlookCalenderEntry">VAR Record "Outlook Calender Entry_EVAS".</param>
    /// <param name="Confirm">Boolean.</param>
    /// <returns>Return value of type Boolean.</returns>
    internal procedure DiscardAppointment(var OutlookCalenderEntry: Record "Outlook Calender Entry_EVAS"; Confirm: Boolean): Boolean
    begin
        exit(OutlookAppointmentImplEVAS.DiscardAppointment(OutlookCalenderEntry, Confirm));
    end;

    /// <summary>
    /// UploadAttachment.
    /// </summary>
    /// <param name="CalenderMsgAttachment">Record "Calender Msg. Attachment_EVAS".</param>
    internal procedure UploadAttachment(CalenderMsgAttachment: Record "Calender Msg. Attachment_EVAS");
    begin
        OutlookAppointmentImplEVAS.UploadAttachment(CalenderMsgAttachment);
    end;

    /// <summary>
    /// DownloadAttachment.
    /// </summary>
    /// <param name="MediaID">Guid.</param>
    /// <param name="FileName">Text.</param>
    internal procedure DownloadAttachment(MediaID: Guid; FileName: Text)
    begin
        OutlookAppointmentImplEVAS.DownloadAttachment(MediaID, FileName);
    end;
}
