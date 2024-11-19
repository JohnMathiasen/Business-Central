codeunit 50100 "Process Data Check"
{
    TableNo = "Check Data Header_EVAS";

    trigger OnRun()
    begin

    end;

    var
        CombinedValidCharacterSet: Dictionary of [Code[50], Text];

    internal procedure FindDataForCleaning(var DataCleanHeader: Record "Check Data Header_EVAS"; FromDT: DateTime)
    begin
        if not DataCleanHeader.Enabled then
            exit;
        CheckDataTable(DataCleanHeader, FromDT);
    end;

    internal procedure PostDataCleaning(DataCleanHeader: Record "Check Data Header_EVAS")
    var
        DataCleanLog: Record "Check Data Log_EVAS";
    begin
        DataCleanLog.SetCurrentKey(Transferred, Blocked, Code, "Table No.", "SystemID Ref.", "Field No.");
        DataCleanLog.SetRange(Code, DataCleanHeader.Code);
        DataCleanLog.SetRange("Table No.", DataCleanHeader."Table No.");
        if DataCleanLog.IsEmpty then
            exit;
        DataCleanLog.FindFirst();
        PostDataCleaning(DataCleanLog);
    end;

    internal procedure PostDataCleaning(DataCleanLine: Record "Check Data Line_EVAS")
    var
        DataCleanLog: Record "Check Data Log_EVAS";
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
        DataCleanLog: Record "Check Data Log_EVAS";
    begin
        PostDataCleaning(DataCleanLog);
    end;

    internal procedure PostDataCleaning(var NewDataCleanLog: Record "Check Data Log_EVAS")
    var
        DataCleanLog: Record "Check Data Log_EVAS";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        OldSystemId: Guid;
        SaveValue: Boolean;
    begin
        DataCleanLog.Copy(NewDataCleanLog);
        if DataCleanLog.IsEmpty then
            exit;
        DataCleanLog.SetCurrentKey(Transferred, Blocked, Code, "Table No.", "SystemID Ref.", "Field No.");
        DataCleanLog.SetRange(Transferred, false);
        DataCleanLog.SetRange(Blocked, false);
        if DataCleanLog.FindSet(true) then
            repeat
                SaveValue := false;
                if (RecRef.Number = 0) or (RecRef.Number <> DataCleanLog."Table No.") then begin
                    if RecRef.Number <> 0 then begin
                        if SaveValue then
                            UpdateValue(DataCleanLog, RecRef);
                        RecRef.Close();
                    end;
                    RecRef.Open(DataCleanLog."Table No.");
                    RecRef.GetBySystemId(DataCleanLog."SystemID Ref.");
                end else
                    if OldSystemId <> DataCleanLog."SystemID Ref." then begin
                        if SaveValue then
                            RecRef.Modify(false);
                        RecRef.GetBySystemId(DataCleanLog."SystemID Ref.");
                    end else begin
                        FieldRef := RecRef.Field(DataCleanLog."Field No.");
                        SaveValue := IsValueChanged(DataCleanLog, FieldRef);
                    end;
                OldSystemId := DataCleanLog."SystemID Ref.";
            until DataCleanLog.Next() = 0;
        FieldRef := RecRef.Field(DataCleanLog."Field No.");
        SaveValue := IsValueChanged(DataCleanLog, FieldRef);
        if SaveValue then
            UpdateValue(DataCleanLog, RecRef);
        RecRef.Close();
    end;

    internal procedure CheckDataTable(var NewDataCleanHeader: Record "Check Data Header_EVAS"; FromDT: DateTime)
    var
        DataCleanHeader: Record "Check Data Header_EVAS";
        DataCleanLine: Record "Check Data Line_EVAS";
        RecRef: RecordRef;
        Fieldref: FieldRef;
    begin
        DataCleanHeader.Copy(NewDataCleanHeader);
        if DataCleanHeader.FindSet() then
            repeat
                DataCleanLine.SetRange("Code", DataCleanHeader.Code);
                DataCleanLine.SetRange("Table No.", DataCleanHeader."Table No.");
                if not DataCleanLine.IsEmpty then begin
                    RecRef.Open(DataCleanHeader."Table No.");
                    Fieldref := RecRef.Field(2000000003);
                    Fieldref.SetFilter('>=%1', FromDT);
                    if RecRef.FindSet(false) then
                        repeat
                            CheckRecord(RecRef, DataCleanHeader, DataCleanLine);
                        until RecRef.Next() = 0;
                end;
            until DataCleanHeader.Next() = 0;
    end;

    local procedure CheckRecord(var RecRef: RecordRef; DataCleanHeader: Record "Check Data Header_EVAS"; var DataCleanLine: Record "Check Data Line_EVAS")
    begin
        if DataCleanLine.FindSet() then
            repeat
                Checkfield(RecRef, DataCleanHeader, DataCleanLine);
            until DataCleanLine.Next() = 0;
    end;

    local procedure Checkfield(var RecRef: RecordRef; DataCleanHeader: Record "Check Data Header_EVAS"; DataCleanLine: Record "Check Data Line_EVAS")
    var
        DocumentCharacterSet: Record "Document Character Set_EVAS";
        FieldRef: FieldRef;
        Value: Text[2048];
        NewValue: Text[2048];
    begin
        if DataCleanLine."Field No." = 0 then
            exit;

        FieldRef := RecRef.Field(DataCleanLine."Field No.");

        if not (FieldRef.Type in [FieldRef.Type::Code, FieldRef.Type::Text]) then
            exit;

        Value := FieldRef.Value;
        NewValue := Value;

        DocumentCharacterSet.SetRange(Code, DataCleanLine.Code);
        DocumentCharacterSet.SetRange("Table No.", DataCleanLine."Table No.");
        DocumentCharacterSet.SetRange("Field No.", DataCleanLine."Field No.");
        DocumentCharacterSet.SetFilter("CharacterSet Code", '<>%1', '');
        case DataCleanHeader.Type of
            DataCleanHeader.Type::Check:
                CheckDataField(DocumentCharacterSet, DataCleanLine, NewValue);
            DataCleanHeader.Type::Clean:
                CleanDataField(DocumentCharacterSet, DataCleanLine, NewValue);
        end;

        // if DocumentCharacterSet.FindSet() then
        // repeat
        //     CharacterSet.Get(DocumentCharacterSet."CharacterSet Code");
        //     case DataCleanHeader.Type of
        //         DataCleanHeader.Type::Check:
        //             case CharacterSet.Type of
        //                 CharacterSet.Type::"Invalid":
        //                     AddToCharacterSetList(CharacterSet, ValidList);
        //                 CharacterSet.Type::Regex:
        //                     AddToCharacterSetList(CharacterSet, RegexList);
        //             end;
        //         DataCleanHeader.Type::Clean:
        //             case CharacterSet.Type of
        //                 CharacterSet.Type::"Invalid":
        //                     AddToCharacterSetList(CharacterSet, ValidList);
        //                 CharacterSet.Type::Remove:
        //                     AddToCharacterSetList(CharacterSet, RemoveList);
        //                 CharacterSet.Type::Replace:
        //                     AddToCharacterSetList(CharacterSet, ReplaceList);
        //             end;
        //     end;

        // until DocumentCharacterSet.Next() = 0;

        // if RemoveList.Count > 0 then
        //     foreach CharaterSetCode in RemoveList do begin
        //         DocumentCharacterSet.Get(DataCleanLine.Code, DataCleanLine."Table No.", DataCleanLine."Field No.", CharaterSetCode);
        //         NewValue := RemoveCharacters(NewValue, CharacterSet);
        //     end;

        // if ReplaceList.Count > 0 then
        //     foreach CharaterSetCode in ReplaceList do begin
        //         DocumentCharacterSet.Get(DataCleanLine.Code, DataCleanLine."Table No.", DataCleanLine."Field No.", CharaterSetCode);
        //         NewValue := ReplaceCharacters(NewValue, CharacterSet);
        //     end;

        // if ValidList.Count > 0 then
        //     NewValue := CheckCharacterSet(NewValue, DataCleanLine);

        if NewValue <> Value then
            CreateLog(Value, NewValue, RecRef, DataCleanHeader, DataCleanLine);
    end;

    local procedure CheckDataField(var DocumentCharacterSet: Record "Document Character Set_EVAS"; DataCleanLine: Record "Check Data Line_EVAS"; Value: Text[2048])
    var
        CharacterSet: Record CharacterSet_EVAS;
        ValidList: List of [Code[20]];
        RegexList: List of [Code[20]];
        CharaterSetCode: Code[20];
        ErrorCharacters, NewValue : Text[2048];
    begin
        if DocumentCharacterSet.FindSet() then
            repeat
                case CharacterSet.Type of
                    CharacterSet.Type::"Invalid":
                        AddToCharacterSetList(CharacterSet, ValidList);
                    CharacterSet.Type::Regex:
                        AddToCharacterSetList(CharacterSet, RegexList);
                end;
            until DocumentCharacterSet.Next() = 0;

        if ValidList.Count > 0 then
            NewValue := CheckCharacterSet(Value, DataCleanLine);
        ErrorCharacters := DelChr(Value, '<=>', NewValue);

        if RegexList.Count > 0 then
            foreach CharaterSetCode in RegexList do begin
                CharacterSet.Get(CharaterSetCode);
                CheckRegex(Value, CharacterSet, ErrorCharacters);
            end;
    end;

    local procedure CleanDataField(var DocumentCharacterSet: Record "Document Character Set_EVAS"; DataCleanLine: Record "Check Data Line_EVAS"; NewValue: Text[2048])
    var
        CharacterSet: Record CharacterSet_EVAS;
        ReplaceList: List of [Code[20]];
        RemoveList: List of [Code[20]];
        ValidList: List of [Code[20]];
        CharaterSetCode: Code[20];
    begin
        if DocumentCharacterSet.FindSet() then
            repeat
                CharacterSet.Get(DocumentCharacterSet."CharacterSet Code");
                case CharacterSet.Type of
                    CharacterSet.Type::"Invalid":
                        AddToCharacterSetList(CharacterSet, ValidList);
                    CharacterSet.Type::Remove:
                        AddToCharacterSetList(CharacterSet, RemoveList);
                    CharacterSet.Type::Replace:
                        AddToCharacterSetList(CharacterSet, ReplaceList);
                end;
            until DocumentCharacterSet.Next() = 0;

        if RemoveList.Count > 0 then
            foreach CharaterSetCode in RemoveList do begin
                CharacterSet.Get(CharaterSetCode);
                NewValue := RemoveCharacters(NewValue, CharacterSet);
            end;

        if ReplaceList.Count > 0 then
            foreach CharaterSetCode in ReplaceList do begin
                CharacterSet.Get(CharaterSetCode);
                NewValue := ReplaceCharacters(NewValue, CharacterSet);
            end;

        if ValidList.Count > 0 then
            NewValue := CheckCharacterSet(NewValue, DataCleanLine);

    end;

    local procedure AddToCharacterSetList(CharacterSet: Record CharacterSet_EVAS; var CharactersetList: List of [Code[20]])
    begin
        if not CharactersetList.Contains(CharacterSet.Code) then
            CharactersetList.Add(CharacterSet.Code);
    end;

    local procedure RemoveCharacters(Value: Text[2048]; CharacterSet: Record CharacterSet_EVAS): Text[2048]
    var
        NewValue: Text[2048];
    begin
        NewValue := Value;
        NewValue := DelChr(NewValue, '<=>', CharacterSet."Character set");
        exit(NewValue);
    end;

    local procedure ReplaceCharacters(Value: Text[2048]; CharacterSet: Record CharacterSet_EVAS): Text[2048]
    var
        NewValue: Text[2048];
        FromLetter: Char;
        ToLetter: Char;
        I: Integer;
    begin
        NewValue := Value;
        for I := 1 to StrLen(CharacterSet."Character set") do begin
            FromLetter := CharacterSet."Character set"[I];
            if NewValue.Contains(FromLetter) then begin
                ToLetter := CharacterSet."Replace Character set"[I];
                NewValue := Copystr(NewValue.Replace(FromLetter, ToLetter), 1, MaxStrLen(NewValue));
            end;
        end;
        exit(NewValue);
    end;

    local procedure CheckCharacterSet(Value: Text[2048]; DataCleanLine: Record "Check Data Line_EVAS"): Text[2048]
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

    local procedure CreateLog(Oldvalue: Text[2048]; NewValue: Text[2048]; RecRef: RecordRef; DataCleanHeader: Record "Check Data Header_EVAS"; DataCleanLine: Record "Check Data Line_EVAS")
    var
        DataCleanLog: Record "Check Data Log_EVAS";
        FieldRef: FieldRef;
    begin
        if Oldvalue = NewValue then
            exit;
        FieldRef := RecRef.Field(RecRef.SystemIdNo);
        DataCleanLog.InsertLogEntry(DataCleanLine.Code, DataCleanLine."Table No.", DataCleanLine."Field No.", DataCleanHeader."Data Clean Group Code", DataCleanHeader.Type, OldValue, NewValue, FieldRef.Value);
    end;

    local procedure GetCombinedKey(var DataCleanLine: Record "Check Data Line_EVAS") KeyValue: Code[50]
    var
        CombinedKeyLbl: Label 'T%1F%2', Comment = 'DAN="T%1F%2"';
    begin
        KeyValue := StrSubstNo(CombinedKeyLbl, DataCleanLine."Table No.", DataCleanLine."Field No.");
    end;

    local procedure IsValueChanged(DataCleanLog: Record "Check Data Log_EVAS"; var FieldRef: FieldRef): Boolean
    var
        CurrentValue: Text[2048];
    begin
        CurrentValue := FieldRef.Value;
        if CurrentValue <> DataCleanLog."New Value" then begin
            FieldRef.Value := DataCleanLog."New Value";
            exit(true);
        end;
        exit(false);
    end;

    local procedure UpdateValue(DataCleanLog: Record "Check Data Log_EVAS"; var RecRef: RecordRef)
    begin
        RecRef.Modify(false);
        DataCleanLog.Transferred := true;
        DataCleanLog."Transferred DT" := CurrentDateTime;
        DataCleanLog.Modify(true);
    end;

    local procedure CheckRegex(NewValue: Text[2048]; CharacterSet: Record CharacterSet_EVAS; var ResultTxt: Text[2048])
    var
        Regex: Codeunit Regex;
        Character: Char;
        I: Integer;
        ErrorCharacters: Text[2048];
    begin
        Regex.Regex(CharacterSet."Character set");
        for I := 1 to StrLen(NewValue) do begin
            Character := NewValue[I];
            if not Regex.IsMatch(Character) then
                ErrorCharacters := DelChr(NewValue, Character);
        end;

        if ErrorCharacters = '' then
            exit;

        for I := 1 to StrLen(ErrorCharacters) do begin
            Character := ErrorCharacters[I];
            if not ResultTxt.Contains(Character) then
                ResultTxt += Character;
        end;
    end;
}
