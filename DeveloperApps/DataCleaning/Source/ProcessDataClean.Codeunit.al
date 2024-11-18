codeunit 50100 "Process Data Clean"
{
    TableNo = "Data Clean Header_EVAS";

    trigger OnRun()
    begin

    end;

    var
        CombinedValidCharacterSet: Dictionary of [Code[50], Text];

    internal procedure FindDataForCleaning(var DataCleanHeader: Record "Data Clean Header_EVAS"; FromDT: DateTime)
    begin
        if not DataCleanHeader.Enabled then
            exit;
        CleanDataTable(DataCleanHeader, FromDT);
    end;

    internal procedure PostDataCleaning(DataCleanHeader: Record "Data Clean Header_EVAS")
    var
        DataCleanLog: Record "Data Clean Log_EVAS";
    begin
        DataCleanLog.SetCurrentKey(Transferred, Blocked, Code, "Table No.", "SystemID Ref.", "Field No.");
        DataCleanLog.SetRange(Code, DataCleanHeader.Code);
        DataCleanLog.SetRange("Table No.", DataCleanHeader."Table No.");
        if DataCleanLog.IsEmpty then
            exit;
        DataCleanLog.FindFirst();
        PostDataCleaning(DataCleanLog);
    end;

    internal procedure PostDataCleaning(DataCleanLine: Record "Data Clean Line_EVAS")
    var
        DataCleanLog: Record "Data Clean Log_EVAS";
    begin
        DataCleanLog.SetCurrentKey(Transferred, Blocked, Code, "Table No.", "SystemID Ref.", "Field No.");
        DataCleanLog.SetRange(Code, DataCleanLine.Code);
        DataCleanLog.SetRange("Table No.", DataCleanLine."Table No.");
        DataCleanLog.SetRange("Field No.", DataCleanLine."Field No.");
        if DataCleanLog.IsEmpty then
            exit;
        DataCleanLog.FindFirst();
        PostDataCleaning(DataCleanLog);
    end;

    internal procedure PostDataCleaning()
    var
        DataCleanLog: Record "Data Clean Log_EVAS";
    begin
        PostDataCleaning(DataCleanLog);
    end;

    internal procedure PostDataCleaning(var NewDataCleanLog: Record "Data Clean Log_EVAS")
    var
        DataCleanLog: Record "Data Clean Log_EVAS";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        OldSystemId: Guid;
    begin
        DataCleanLog.Copy(NewDataCleanLog);
        if DataCleanLog.IsEmpty then
            exit;
        DataCleanLog.SetCurrentKey(Transferred, Blocked, Code, "Table No.", "SystemID Ref.", "Field No.");
        DataCleanLog.SetRange(Transferred, false);
        DataCleanLog.SetRange(Blocked, false);
        if DataCleanLog.FindSet(true) then
            repeat
                if (RecRef.Number = 0) or (RecRef.Number <> DataCleanLog."Table No.") then begin
                    if RecRef.Number <> 0 then begin
                        RecRef.Modify(false);
                        RecRef.Close();
                    end;
                    RecRef.Open(DataCleanLog."Table No.");
                    RecRef.GetBySystemId(DataCleanLog."SystemID Ref.");
                end else
                    if OldSystemId <> DataCleanLog."SystemID Ref." then begin
                        RecRef.Modify(false);
                        RecRef.GetBySystemId(DataCleanLog."SystemID Ref.");
                    end else begin
                        FieldRef := RecRef.Field(DataCleanLog."Field No.");
                        FieldRef.Value := DataCleanLog."New Value";
                    end;
                OldSystemId := DataCleanLog."SystemID Ref.";
            until DataCleanLog.Next() = 0;
    end;

    internal procedure CleanDataTable(DataCleanHeader: Record "Data Clean Header_EVAS"; FromDT: DateTime)
    var
        DataCleanLine: Record "Data Clean Line_EVAS";
        RecRef: RecordRef;
        Fieldref: FieldRef;
    begin
        DataCleanLine.SetRange("Code", DataCleanHeader.Code);
        DataCleanLine.SetRange("Table No.", DataCleanHeader."Table No.");

        RecRef.Open(DataCleanHeader."Table No.");
        Fieldref := RecRef.Field(2000000003);
        Fieldref.SetFilter('>=%1', FromDT);
        if RecRef.FindSet(false) then
            repeat
                CleanRecord(RecRef, DataCleanLine);
            until RecRef.Next() = 0;
    end;

    local procedure CleanRecord(var RecRef: RecordRef; var DataCleanLine: Record "Data Clean Line_EVAS")
    begin
        if DataCleanLine.FindSet() then
            repeat
                Cleanfield(RecRef, DataCleanLine);
            until DataCleanLine.Next() = 0;
    end;

    local procedure Cleanfield(var RecRef: RecordRef; DataCleanLine: Record "Data Clean Line_EVAS")
    var
        DocumentCharacterSet: Record "Document Character Set_EVAS";
        CharacterSet: Record CharacterSet_EVAS;
        FieldRef: FieldRef;
        Value: Text[2048];
        ReplaceList: List of [Code[20]];
        RemoveList: List of [Code[20]];
        ValidList: List of [Code[20]];
        CharaterSetCode: Code[20];
        NewValue: Text[2048];
    begin
        if DataCleanLine."Field No." = 0 then
            exit;

        DocumentCharacterSet.SetRange(Code, DataCleanLine.Code);
        DocumentCharacterSet.SetRange("Table No.", DataCleanLine."Table No.");
        DocumentCharacterSet.SetRange("Field No.", DataCleanLine."Field No.");
        DocumentCharacterSet.SetFilter("CharacterSet Code", '<>%1', '');
        if DocumentCharacterSet.IsEmpty then
            exit;

        DocumentCharacterSet.FindSet();
        repeat
            CharacterSet.Get(DocumentCharacterSet."CharacterSet Code");
            case CharacterSet.Type of
                CharacterSet.Type::"Clean Invalid":
                    if not ValidList.Contains(DocumentCharacterSet."CharacterSet Code") then
                        ValidList.Add(DocumentCharacterSet."CharacterSet Code");
                CharacterSet.Type::Remove:
                    if not RemoveList.Contains(DocumentCharacterSet."CharacterSet Code") then
                        RemoveList.Add(DocumentCharacterSet."CharacterSet Code");
                CharacterSet.Type::Replace:
                    if not ReplaceList.Contains(DocumentCharacterSet."CharacterSet Code") then
                        ReplaceList.Add(DocumentCharacterSet."CharacterSet Code");

            end;
        until DocumentCharacterSet.Next() = 0;

        FieldRef := RecRef.Field(DataCleanLine."Field No.");

        if not (FieldRef.Type in [FieldRef.Type::Code, FieldRef.Type::Text]) then
            exit;

        Value := FieldRef.Value;
        NewValue := Value;

        if RemoveList.Count > 0 then
            foreach CharaterSetCode in RemoveList do begin
                DocumentCharacterSet.Get(DataCleanLine.Code, DataCleanLine."Table No.", DataCleanLine."Field No.", CharaterSetCode);
                NewValue := RemoveCharacters(NewValue, DocumentCharacterSet);
            end;

        if ReplaceList.Count > 0 then
            foreach CharaterSetCode in ReplaceList do begin
                DocumentCharacterSet.Get(DataCleanLine.Code, DataCleanLine."Table No.", DataCleanLine."Field No.", CharaterSetCode);
                NewValue := ReplaceCharacters(NewValue, DocumentCharacterSet);
            end;

        if ValidList.Count > 0 then
            NewValue := CheckCharacterSet(NewValue, DataCleanLine);

        if NewValue <> Value then
            CreateLog(Value, NewValue, RecRef, DataCleanLine);
    end;

    local procedure RemoveCharacters(Value: Text[2048]; DocumentCharacterSet: Record "Document Character Set_EVAS"): Text[2048]
    var
        CharacterSet: Record CharacterSet_EVAS;
        NewValue: Text[2048];
    begin
        NewValue := Value;
        CharacterSet.Get(DocumentCharacterSet."CharacterSet Code");
        NewValue := DelChr(NewValue, '<=>', CharacterSet."Character set");
        exit(NewValue);
    end;

    local procedure ReplaceCharacters(Value: Text[2048]; DocumentCharacterSet: Record "Document Character Set_EVAS"): Text[2048]
    var
        CharacterSet: Record CharacterSet_EVAS;
        NewValue: Text[2048];
        FromLetter: Char;
        ToLetter: Char;
        I: Integer;
    begin
        NewValue := Value;
        CharacterSet.Get(DocumentCharacterSet."CharacterSet Code");
        for I := 1 to StrLen(CharacterSet."Character set") do begin
            FromLetter := CharacterSet."Character set"[I];
            if NewValue.Contains(FromLetter) then begin
                ToLetter := CharacterSet."Replace Character set"[I];
                NewValue := Copystr(NewValue.Replace(FromLetter, ToLetter), 1, MaxStrLen(NewValue));
            end;
        end;
        exit(NewValue);
    end;

    local procedure CheckCharacterSet(Value: Text[2048]; DataCleanLine: Record "Data Clean Line_EVAS"): Text[2048]
    var
        NewValue: Text[2048];
        CheckValue: Text[2048];
        ValidCharacters: Text;
    begin
        NewValue := Value;
        if not CombinedValidCharacterSet.Get(GetCombinedKey(DataCleanLine), ValidCharacters) then
            ValidCharacters := DataCleanLine.GetCombineCharacterSets();

        if not CombinedValidCharacterSet.ContainsKey(GetCombinedKey(DataCleanLine)) then
            CombinedValidCharacterSet.Add(GetCombinedKey(DataCleanLine), ValidCharacters);

        CheckValue := DelChr(Value, '<=>', ValidCharacters);
        if CheckValue <> '' then
            NewValue := DelChr(Value, '<=>', CheckValue);
        exit(NewValue);
    end;

    local procedure CreateLog(Oldvalue: Text[2048]; NewValue: Text[2048]; RecRef: RecordRef; DataCleanLine: Record "Data Clean Line_EVAS")
    var
        DataCleanLog: Record "Data Clean Log_EVAS";
        FieldRef: FieldRef;
    begin
        if Oldvalue = NewValue then
            exit;
        FieldRef := RecRef.Field(RecRef.SystemIdNo);
        DataCleanLog.InsertLogEntry(DataCleanLine.Code, DataCleanLine."Table No.", DataCleanLine."Field No.", OldValue, NewValue, FieldRef.Value);
    end;

    local procedure GetCombinedKey(var DataCleanLine: Record "Data Clean Line_EVAS") KeyValue: Code[50]
    var
        CombinedKeyLbl: Label 'T%1F%2', Comment = 'DAN="T%1F%2"';
    begin
        KeyValue := StrSubstNo(CombinedKeyLbl, DataCleanLine."Table No.", DataCleanLine."Field No.");
    end;
}