/// <summary>
/// Page Calender Msg. Attachment_EVAS (ID 50303).
/// </summary>
page 50303 "Calender Msg. Attachment_EVAS"
{
    Caption = 'Appointment Attachment', Comment = 'DAN="Aftale vedhæftning"';
    PageType = ListPart;
    SourceTable = "Calender Msg. Attachment_EVAS";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(FileName; Rec."Attachment Name")
                {
                    ApplicationArea = All;
                    Caption = 'File Name', Comment = 'DAN="Filnavn"';
                    ToolTip = 'Specifies the name of the attachment', Comment = 'DAN="Angiver navn på vedhæftning"';

                    trigger OnDrillDown()
                    var
                        OutlookAppointment: Codeunit "Outlook Appointment_EVAS";
                    begin
                        OutlookAppointment.DownloadAttachment(Rec.Data.MediaId(), Rec."Attachment Name");
                        CurrPage.Update(false);
                    end;
                }
                field(FileSize; AttachmentFileSize)
                {
                    ApplicationArea = All;
                    Width = 10;
                    Caption = 'File Size', Comment = 'DAN="Fil størrelse"';
                    ToolTip = 'Specifies the size of the attachment', Comment = 'DAN="Angiver størrelse på vedhæftning"';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Upload)
            {
                ApplicationArea = All;
                Image = Attach;
                Caption = 'Add file', Comment = 'DAN="Tilføj fil"';
                ToolTip = 'Attach files, such as documents or images, to the email.', Comment = 'DAN="vedhæft filer, såsom dokumenter eller billeder til aftale emailen."';
                Scope = Page;
                Visible = IsCalenderEmailEditable;

                trigger OnAction()
                var
                    OutlookAppointment: Codeunit "Outlook Appointment_EVAS";
                begin
                    Rec."Calender Message Id" := CalenderMessageId;
                    OutlookAppointment.UploadAttachment(Rec);
                end;
            }
            action("Delete")
            {
                ApplicationArea = All;
                Enabled = DeleteActionEnabled;
                Image = Delete;
                Caption = 'Delete', Comment = 'DAN="Slet"';
                ToolTip = 'Delete the selected row.', Comment = 'DAN="Slet den valgte linje."';
                Scope = Repeater;
                Visible = IsCalenderEmailEditable;

                trigger OnAction()
                var
                    CalenderMsgAttachment: Record "Calender Msg. Attachment_EVAS";
                begin
                    if Confirm(DeleteQst) then begin
                        CurrPage.SetSelectionFilter(CalenderMsgAttachment);
                        CalenderMsgAttachment.DeleteAll();
                        UpdateDeleteActionEnablement();
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec."Calender Message Id" := CalenderMessageId;
    end;


    trigger OnAfterGetRecord()
    begin
        AttachmentFileSize := Rec.FormatFileSize(Rec.Length);
    end;

    var
        CalenderMessage: Codeunit "Calender Message_EVAS";
        DeleteActionEnabled, IsCalenderEmailEditable : Boolean;
        CalenderMessageId: Guid;
        DeleteQst: Label 'Go ahead and delete?', Comment = 'DAN="Slet valgte vedhæftede file?"';
        AttachmentFileSize: Text;

    /// <summary>
    /// UpdateValues.
    /// </summary>
    /// <param name="SourceCalenderMessage">Codeunit "Calender Message_EVAS".</param>
    /// <param name="CalenderEmailEditable">Boolean.</param>
    internal procedure UpdateValues(SourceCalenderMessage: Codeunit "Calender Message_EVAS"; CalenderEmailEditable: Boolean)
    begin
        CalenderMessageId := SourceCalenderMessage.GetUID();
        CalenderMessage := SourceCalenderMessage;

        UpdateDeleteActionEnablement();
        IsCalenderEmailEditable := CalenderEmailEditable;
    end;

    protected procedure UpdateDeleteActionEnablement()
    var
        CalenderMsgAttachment: Record "Calender Msg. Attachment_EVAS";
    begin

        CalenderMsgAttachment.SetFilter("Calender Message Id", CalenderMessageId);
        DeleteActionEnabled := not CalenderMsgAttachment.IsEmpty();
        CurrPage.Update();
    end;
}
