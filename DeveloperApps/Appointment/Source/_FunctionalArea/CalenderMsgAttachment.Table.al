/// <summary>
/// Table Calender Msg. Attachment_EVAS (ID 50302).
/// </summary>
table 50302 "Calender Msg. Attachment_EVAS"
{
    Caption = 'Calender Message Attachment', Comment = 'DAN=""';
    DataClassification = CustomerContent;

    fields
    {

        field(1; Id; BigInteger)
        {
            Caption = 'ID', Comment = 'DAN="Id"';
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }

        field(2; "Calender Message Id"; Guid)
        {
            Caption = 'Calender Message ID', Comment = 'DAN="Kalender besked id"';
            DataClassification = SystemMetadata;
            TableRelation = "Outlook Calender Entry_EVAS".UID;
        }
        field(4; "Attachment Name"; Text[250])
        {
            Caption = 'Attachment Name', Comment = 'DAN="Vedhæftning navn"';
            DataClassification = CustomerContent;
        }

        field(5; "Content Type"; Text[250])
        {
            Caption = 'Content Type', Comment = 'DAN="Indholdstype"';
            DataClassification = SystemMetadata;
        }

        field(6; InLine; Boolean)
        {
            Caption = 'InLine', Comment = 'DAN="I linje"';
            DataClassification = SystemMetadata;
        }

        field(7; "Content Id"; Text[40])
        {
            Caption = 'Content Id', Comment = 'DAN="Indholds-id"';
            DataClassification = SystemMetadata;
        }

        field(8; Length; Integer)
        {
            Caption = 'Length', Comment = 'DAN="Længde"';
            DataClassification = SystemMetadata;
        }

        field(9; Data; Media)
        {
            Caption = 'Data', Comment = 'DAN="Data"';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; Id)
        {
            Clustered = true;
        }

        key(MessageId; "calender Message Id")
        {

        }
    }

    /// <summary>
    /// FormatFileSize.
    /// Used for formatting a filesize in KB or MB (only)
    /// </summary>
    /// <param name="SizeInBytes">Integer.</param>
    /// <returns>Return value of type Text.</returns>
    internal procedure FormatFileSize(SizeInBytes: Integer): Text
    var
        FileSizeConverted: Decimal;
        FileSizeUnit: Text;
        FileSizeTxt: Label '%1 %2', Comment = '%1 = File Size, %2 = Unit of measurement', Locked = true;
    begin
        FileSizeConverted := SizeInBytes / 1024; // The smallest size we show is KB
        if FileSizeConverted < 1024 then
            FileSizeUnit := 'KB'
        else begin
            FileSizeConverted := FileSizeConverted / 1024; // The largest size we show is MB
            FileSizeUnit := 'MB'
        end;
        exit(StrSubstNo(FileSizeTxt, Round(FileSizeConverted, 1, '>'), FileSizeUnit));
    end;

    /// <summary>
    /// GetContentTypeFromFilename.
    /// </summary>
    /// <param name="FileName">Text.</param>
    /// <returns>Return value of type Text[250].</returns>
    internal procedure GetContentTypeFromFilename(FileName: Text): Text[250]
    begin
        if FileName.EndsWith('.graphql') or FileName.EndsWith('.gql') then
            exit('application/graphql');
        if FileName.EndsWith('.js') then
            exit('application/javascript');
        if FileName.EndsWith('.json') then
            exit('application/json');
        if FileName.EndsWith('.doc') then
            exit('application/msword(.doc)');
        if FileName.EndsWith('.pdf') then
            exit('application/pdf');
        if FileName.EndsWith('.sql') then
            exit('application/sql');
        if FileName.EndsWith('.xls') then
            exit('application/vnd.ms-excel(.xls)');
        if FileName.EndsWith('.ppt') then
            exit('application/vnd.ms-powerpoint(.ppt)');
        if FileName.EndsWith('.odt') then
            exit('application/vnd.oasis.opendocument.text(.odt)');
        if FileName.EndsWith('.pptx') then
            exit('application/vnd.openxmlformats-officedocument.presentationml.presentation(.pptx)');
        if FileName.EndsWith('.xlsx') then
            exit('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet(.xlsx)');
        if FileName.EndsWith('.docx') then
            exit('application/vnd.openxmlformats-officedocument.wordprocessingml.document(.docx)');
        if FileName.EndsWith('.xml') then
            exit('application/xml');
        if FileName.EndsWith('.zip') then
            exit('application/zip');
        if FileName.EndsWith('.zst') then
            exit('application/zstd(.zst)');
        if FileName.EndsWith('.mpeg') then
            exit('audio/mpeg');
        if FileName.EndsWith('.ogg') then
            exit('audio/ogg');
        if FileName.EndsWith('.gif') then
            exit('application/gif');
        if FileName.EndsWith('.jpeg') then
            exit('application/jpeg');
        if FileName.EndsWith('.jpg') then
            exit('application/jpg');
        if FileName.EndsWith('.png') then
            exit('application/png');
        if FileName.EndsWith('.css') then
            exit('text/css');
        if FileName.EndsWith('.csv') then
            exit('text/csv');
        if FileName.EndsWith('.html') then
            exit('text/html');
        if FileName.EndsWith('.php') then
            exit('text/php');
        if FileName.EndsWith('.txt') then
            exit('text/plain');
        exit('');
    end;

    /// <summary>
    /// AddAttachmentInternal.
    /// </summary>
    /// <param name="AttachmentName">Text[250].</param>
    /// <param name="ContentType">Text[250].</param>
    /// <param name="AttachmentInStream">InStream.</param>
    /// <param name="MessageId">Guid.</param>
    /// <returns>Return variable Size of type Integer.</returns>
    internal procedure AddAttachmentInternal(AttachmentName: Text[250]; ContentType: Text[250]; AttachmentInStream: InStream; MessageId: Guid) Size: Integer
    var
        NullGuid: Guid;
    begin
        exit(AddAttachmentInternal(AttachmentName, ContentType, AttachmentInStream, false, NullGuid, MessageId));
    end;

    /// <summary>
    /// AddAttachmentInternal.
    /// </summary>
    /// <param name="AttachmentName">Text[250].</param>
    /// <param name="ContentType">Text[250].</param>
    /// <param name="AttachmentInStream">InStream.</param>
    /// <param name="InLineValue">Boolean.</param>
    /// <param name="ContentId">Text[40].</param>
    /// <param name="MessageId">Guid.</param>
    /// <returns>Return variable Size of type Integer.</returns>
    internal procedure AddAttachmentInternal(AttachmentName: Text[250]; ContentType: Text[250]; AttachmentInStream: InStream; InLineValue: Boolean; ContentId: Text[40]; MessageId: Guid) Size: Integer
    var
        CalenderMsgAttachment: Record "Calender Msg. Attachment_EVAS";
    begin
        AddAttachment(AttachmentName, ContentType, InLineValue, ContentId, MessageId, CalenderMsgAttachment);
        InsertAttachment(CalenderMsgAttachment, AttachmentInStream, '');
        exit(CalenderMsgAttachment.Length);
    end;

    local procedure AddAttachment(AttachmentName: Text[250]; ContentType: Text[250]; InLineValue: Boolean; ContentId: Text[40]; MessageId: Guid; var CalenderMsgAttachment: Record "Calender Msg. Attachment_EVAS")
    begin
        CalenderMsgAttachment."Calender Message Id" := MessageId;
        CalenderMsgAttachment."Attachment Name" := AttachmentName;
        CalenderMsgAttachment."Content Type" := ContentType;
        CalenderMsgAttachment.InLine := InLineValue;
        CalenderMsgAttachment."Content Id" := ContentId;
    end;

    local procedure InsertAttachment(var CalenderMsgAttachment: Record "Calender Msg. Attachment_EVAS"; AttachmentInStream: InStream; AttachmentName: Text)
    var
        TenantMedia: Record "Tenant Media";
        MediaID: Guid;
    begin
        MediaID := CalenderMsgAttachment.Data.ImportStream(AttachmentInStream, AttachmentName, CalenderMsgAttachment."Content Type");
        TenantMedia.Get(MediaID);
        TenantMedia.CalcFields(Content);
        CalenderMsgAttachment.Length := TenantMedia.Content.Length;
        CalenderMsgAttachment.Insert();
    end;
}
