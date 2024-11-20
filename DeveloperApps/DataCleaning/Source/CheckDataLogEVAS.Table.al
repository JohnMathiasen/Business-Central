table 50104 "Check Data Log_EVAS"
{
    Caption = 'Check Data Log', Comment = 'DAN="Data kontrol log"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; "Code"; Code[20])
        {
            Caption = 'Code', Comment = 'DAN="Kode"';
            TableRelation = "Check Data Header_EVAS"."Code";
        }
        field(4; "Table No."; Integer)
        {
            Caption = 'Table No.', Comment = 'DAN="Tabelnr."';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));
        }
        field(5; "Field No."; Integer)
        {
            Caption = 'Field No.', Comment = 'DAN="Felt nr."';
            TableRelation = Field."No." where(TableNo = field("Table No."), Type = filter(Text | Code));
        }
        field(6; "Check Data Group Code"; Code[10])
        {
            Caption = 'Check Data Group Code', Comment = 'DAN="Datakontrolgruppekode"';
            TableRelation = "Check Data Group_EVAS"."Code";
        }
        field(7; Type; Enum "Check Data Type_EVAS")
        {
            Caption = 'Type', Comment = 'DAN="Type"';
        }
        field(12; "Old Value"; Text[2048])
        {
            Caption = 'Old Value', Comment = 'DAN="Gammel værdi"';
        }
        field(13; "New Value"; Text[2048])
        {
            Caption = 'New Value', Comment = 'DAN="Ny værdi"';
        }
        field(14; "SystemID Ref."; Guid)
        {
            Caption = 'SystemID Ref.', Comment = 'DAN="SystemID Ref."';
        }
        field(15; Transferred; Boolean)
        {
            Caption = 'Transferred', Comment = 'DAN="Overført"';
        }
        field(16; "Transferred DT"; DateTime)
        {
            Caption = 'Transferred Datetime', Comment = 'DAN="Overført dato"';
        }
        field(17; Valid; Boolean)
        {
            Caption = 'Valid', Comment = 'DAN="Gyldig"';
        }
        field(18; Blocked; Boolean)
        {
            Caption = 'Blocked', Comment = 'DAN="Spærret"';
            trigger OnValidate()
            var
                blockedTransferErrorLbl: Label 'It''s not possible to block, when the value is transferred.', Comment = 'DAN = "Det er ikke muligt at spærre, når værdien er overført."';
            begin
                if Transferred then
                    Error(blockedTransferErrorLbl);
            end;
        }
    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; Transferred, Blocked, Code, "Table No.", "SystemID Ref.", "Field No.")
        {
        }
    }

    internal procedure InsertLogEntry(NewCode: Code[20]; NewTableNo: Integer; NewFieldNo: Integer; NewGroup: Code[10]; NewType: Enum "Check Data Type_EVAS"; OldValue: Text[2048]; NewValue: Text[2048]; ValidValue: Boolean; SystemIDRef: Guid)
    var
        CheckDataLog: Record "Check Data Log_EVAS";
    begin
        CheckDataLog.Init();
        CheckDataLog."Entry No." := GetNextEntryNo();
        CheckDataLog.Code := NewCode;
        CheckDataLog."Table No." := NewTableNo;
        CheckDataLog."Field No." := NewFieldNo;
        CheckDataLog."Check Data Group Code" := NewGroup;
        CheckDataLog.Type := NewType;
        CheckDataLog."Old Value" := OldValue;
        CheckDataLog."New Value" := NewValue;
        case CheckDataLog.Type of
            CheckDataLog.Type::Check:
                CheckDataLog.Valid := ValidValue;
            CheckDataLog.Type::Clean:
                CheckDataLog.Valid := NewValue = OldValue;
        end;
        CheckDataLog."SystemID Ref." := SystemIDRef;
        CheckDataLog.Insert(true);
    end;

    local procedure GetNextEntryNo(): Integer
    var
        CheckDataLog: Record "Check Data Log_EVAS";
    begin
        if CheckDataLog.FindLast() then
            exit(CheckDataLog."Entry No." + 1)
        else
            exit(1);
    end;

    internal procedure ShowRecord()
    var
        PageManagement: Codeunit "Page Management";
        RecRef: RecordRef;
        NoRelatedRecordMsg: Label 'There are no related records to display.', Comment = 'DAN="Der er ingen relaterede poster at vise."';
    begin
        if "Entry No." = 0 then
            exit;
        RecRef.Open("Table No.");
        RecRef.GetBySystemId("SystemID Ref.");

        if not PageManagement.PageRun(RecRef.RecordId) then
            Message(NoRelatedRecordMsg);
    end;
}
