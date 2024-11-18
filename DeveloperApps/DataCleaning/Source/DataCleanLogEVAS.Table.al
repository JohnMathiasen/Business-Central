table 50104 "Data Clean Log_EVAS"
{
    Caption = 'Data Clean Log', Comment = 'DAN="Datavask log"';
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
        field(6; "Data Clean Group Code"; Code[10])
        {
            Caption = 'Data Clean Group Code', Comment = 'DAN="Datavaskgruppekode"';
            TableRelation = "Data Clean Group_EVAS"."Code";
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

    internal procedure InsertLogEntry(NewCode: Code[20]; NewTableNo: Integer; NewFieldNo: Integer; NewGroup: Code[10]; OldValue: Text[2048]; NewValue: Text[2048]; SystemIDRef: Guid)
    var
        DataCleanLog: Record "Data Clean Log_EVAS";
    begin
        DataCleanLog.Init();
        DataCleanLog."Entry No." := GetNextEntryNo();
        DataCleanLog.Code := NewCode;
        DataCleanLog."Table No." := NewTableNo;
        DataCleanLog."Field No." := NewFieldNo;
        DataCleanLog."Data Clean Group Code" := NewGroup;
        DataCleanLog."Old Value" := OldValue;
        DataCleanLog."New Value" := NewValue;
        DataCleanLog."SystemID Ref." := SystemIDRef;
        DataCleanLog.Insert(true);
    end;

    local procedure GetNextEntryNo(): Integer
    var
        DataCleanLog: Record "Data Clean Log_EVAS";
    begin
        if DataCleanLog.FindLast() then
            exit(DataCleanLog."Entry No." + 1)
        else
            exit(1);
    end;
}
