codeunit 50100 "Process Data Check"
{
    TableNo = "Check Data Header_EVAS";

    trigger OnRun()
    begin

    end;

    var
        CombinedValidCharacterSet: Dictionary of [Code[50], Text];

    internal procedure FindDataForCleaning(var CheckDataHeader: Record "Check Data Header_EVAS"; FromDT: DateTime)
    begin
        if not CheckDataHeader.Enabled then
            exit;
        CheckDataTable(CheckDataHeader, FromDT);
    end;

    internal procedure PostDataCleaning(CheckDataHeader: Record "Check Data Header_EVAS")
    var
        CheckDataLog: Record "Check Data Log_EVAS";
    begin
        CheckDataLog.SetCurrentKey(Transferred, Blocked, Code, "Table No.", "SystemID Ref.", "Field No.");
        CheckDataLog.SetRange(Code, CheckDataHeader.Code);
        CheckDataLog.SetRange("Table No.", CheckDataHeader."Table No.");
        if CheckDataLog.IsEmpty then
            exit;
        CheckDataLog.FindFirst();
        PostDataCleaning(CheckDataLog);
    end;

    internal procedure PostDataCleaning(CheckDataLine: Record "Check Data Line_EVAS")
    var
        CheckDataLog: Record "Check Data Log_EVAS";
    begin
        CheckDataLog.SetCurrentKey(Transferred, Blocked, Code, "Table No.", "SystemID Ref.", "Field No.");
        CheckDataLog.SetRange(Code, CheckDataLine.Code);
        CheckDataLog.SetRange("Table No.", CheckDataLine."Table No.");
        CheckDataLog.SetRange("Field No.", CheckDataLine."Field No.");
        if CheckDataLog.IsEmpty then
            exit;
        CheckDataLog.FindFirst();
        PostDataCleaning(CheckDataLog);
    end;

    internal procedure PostDataCleaning()
    var
        CheckDataLog: Record "Check Data Log_EVAS";
    begin
        PostDataCleaning(CheckDataLog);
    end;

    internal procedure PostDataCleaning(var NewCheckDataLog: Record "Check Data Log_EVAS")
    var
        CheckDataLog: Record "Check Data Log_EVAS";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        OldSystemId: Guid;
        SaveValue: Boolean;
    begin
        CheckDataLog.Copy(NewCheckDataLog);
        if CheckDataLog.IsEmpty then
            exit;
        CheckDataLog.SetCurrentKey(Transferred, Blocked, Code, "Table No.", "SystemID Ref.", "Field No.");
        CheckDataLog.SetRange(Transferred, false);
        CheckDataLog.SetRange(Blocked, false);
        if CheckDataLog.FindSet(true) then
            repeat
                SaveValue := false;
                if (RecRef.Number = 0) or (RecRef.Number <> CheckDataLog."Table No.") then begin
                    if RecRef.Number <> 0 then begin
                        if SaveValue then
                            UpdateValue(CheckDataLog, RecRef);
                        RecRef.Close();
                    end;
                    RecRef.Open(CheckDataLog."Table No.");
                    RecRef.GetBySystemId(CheckDataLog."SystemID Ref.");
                end else
                    if OldSystemId <> CheckDataLog."SystemID Ref." then begin
                        if SaveValue then
                            RecRef.Modify(false);
                        RecRef.GetBySystemId(CheckDataLog."SystemID Ref.");
                    end else begin
                        FieldRef := RecRef.Field(CheckDataLog."Field No.");
                        SaveValue := IsValueChanged(CheckDataLog, FieldRef);
                    end;
                OldSystemId := CheckDataLog."SystemID Ref.";
            until CheckDataLog.Next() = 0;
        FieldRef := RecRef.Field(CheckDataLog."Field No.");
        SaveValue := IsValueChanged(CheckDataLog, FieldRef);
        if SaveValue then
            UpdateValue(CheckDataLog, RecRef);
        RecRef.Close();
    end;

    internal procedure CheckDataTable(var NewCheckDataHeader: Record "Check Data Header_EVAS"; FromDT: DateTime)
    var
        CheckDataHeader: Record "Check Data Header_EVAS";
        CheckDataLine: Record "Check Data Line_EVAS";
        RecRef: RecordRef;
        Fieldref: FieldRef;
    begin
        CheckDataHeader.Copy(NewCheckDataHeader);
        if CheckDataHeader.FindSet() then
            repeat
                CheckDataLine.SetRange("Code", CheckDataHeader.Code);
                CheckDataLine.SetRange("Table No.", CheckDataHeader."Table No.");
                if not CheckDataLine.IsEmpty then begin
                    RecRef.Open(CheckDataHeader."Table No.");
                    Fieldref := RecRef.Field(2000000003);
                    Fieldref.SetFilter('>=%1', FromDT);
                    if RecRef.FindSet(false) then
                        repeat
                            CheckRecord(RecRef, CheckDataHeader, CheckDataLine);
                        until RecRef.Next() = 0;
                end;
            until CheckDataHeader.Next() = 0;
    end;

    local procedure CheckRecord(var RecRef: RecordRef; CheckDataHeader: Record "Check Data Header_EVAS"; var CheckDataLine: Record "Check Data Line_EVAS")
    begin
        if CheckDataLine.FindSet() then
            repeat
                Checkfield(RecRef, CheckDataHeader, CheckDataLine);
            until CheckDataLine.Next() = 0;
    end;

    local procedure Checkfield(var RecRef: RecordRef; CheckDataHeader: Record "Check Data Header_EVAS"; CheckDataLine: Record "Check Data Line_EVAS")
    var
        DocumentCharacterSet: Record "Document Character Set_EVAS";
        FieldRef: FieldRef;
        Value: Text[2048];
        NewValue: Text[2048];
    begin
        if CheckDataLine."Field No." = 0 then
            exit;

        FieldRef := RecRef.Field(CheckDataLine."Field No.");

        if not (FieldRef.Type in [FieldRef.Type::Code, FieldRef.Type::Text]) then
            exit;

        Value := FieldRef.Value;
        NewValue := Value;

        DocumentCharacterSet.SetRange(Code, CheckDataLine.Code);
        DocumentCharacterSet.SetRange("Table No.", CheckDataLine."Table No.");
        DocumentCharacterSet.SetRange("Field No.", CheckDataLine."Field No.");
        DocumentCharacterSet.SetFilter("CharacterSet Code", '<>%1', '');
        case CheckDataHeader.Type of
            CheckDataHeader.Type::Check:
                CheckDataField(DocumentCharacterSet, CheckDataLine, NewValue);
            CheckDataHeader.Type::Clean:
                CleanDataField(DocumentCharacterSet, CheckDataLine, NewValue);
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
            CreateLog(Value, NewValue, RecRef, CheckDataHeader, CheckDataLine);
    end;

    local procedure CheckDataField(var DocumentCharacterSet: Record "Document Character Set_EVAS"; CheckDataLine: Record "Check Data Line_EVAS"; Value: Text[2048])
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
            NewValue := CheckCharacterSet(Value, CheckDataLine);
        ErrorCharacters := DelChr(Value, '<=>', NewValue);

        if RegexList.Count > 0 then
            foreach CharaterSetCode in RegexList do begin
                CharacterSet.Get(CharaterSetCode);
                CheckRegex(Value, CharacterSet, ErrorCharacters);
            end;
    end;

    local procedure CleanDataField(var DocumentCharacterSet: Record "Document Character Set_EVAS"; CheckDataLine: Record "Check Data Line_EVAS"; NewValue: Text[2048])
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
            NewValue := CheckCharacterSet(NewValue, CheckDataLine);

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

    local procedure CheckCharacterSet(Value: Text[2048]; CheckDataLine: Record "Check Data Line_EVAS"): Text[2048]
    var
        NewValue: Text[2048];
        CheckValue: Text[2048];
        ValidCharacters: Text;
    begin
        NewValue := Value;
        if not CombinedValidCharacterSet.Get(GetCombinedKey(CheckDataLine), ValidCharacters) then
            ValidCharacters := CheckDataLine.GetCombineCharacterSets();

        if not CombinedValidCharacterSet.ContainsKey(GetCombinedKey(CheckDataLine)) then
            CombinedValidCharacterSet.Add(GetCombinedKey(CheckDataLine), ValidCharacters);

        CheckValue := DelChr(Value, '<=>', ValidCharacters);
        if CheckValue <> '' then
            NewValue := DelChr(Value, '<=>', CheckValue);
        exit(NewValue);
    end;

    local procedure CreateLog(Oldvalue: Text[2048]; NewValue: Text[2048]; RecRef: RecordRef; CheckDataHeader: Record "Check Data Header_EVAS"; CheckDataLine: Record "Check Data Line_EVAS")
    var
        CheckDataLog: Record "Check Data Log_EVAS";
        FieldRef: FieldRef;
    begin
        if Oldvalue = NewValue then
            exit;
        FieldRef := RecRef.Field(RecRef.SystemIdNo);
        CheckDataLog.InsertLogEntry(CheckDataLine.Code, CheckDataLine."Table No.", CheckDataLine."Field No.", CheckDataHeader."Check Data Group Code", CheckDataHeader.Type, OldValue, NewValue, FieldRef.Value);
    end;

    local procedure GetCombinedKey(var CheckDataLine: Record "Check Data Line_EVAS") KeyValue: Code[50]
    var
        CombinedKeyLbl: Label 'T%1F%2', Comment = 'DAN="T%1F%2"';
    begin
        KeyValue := StrSubstNo(CombinedKeyLbl, CheckDataLine."Table No.", CheckDataLine."Field No.");
    end;

    local procedure IsValueChanged(CheckDataLog: Record "Check Data Log_EVAS"; var FieldRef: FieldRef): Boolean
    var
        CurrentValue: Text[2048];
    begin
        CurrentValue := FieldRef.Value;
        if CurrentValue <> CheckDataLog."New Value" then begin
            FieldRef.Value := CheckDataLog."New Value";
            exit(true);
        end;
        exit(false);
    end;

    local procedure UpdateValue(CheckDataLog: Record "Check Data Log_EVAS"; var RecRef: RecordRef)
    begin
        RecRef.Modify(false);
        CheckDataLog.Transferred := true;
        CheckDataLog."Transferred DT" := CurrentDateTime;
        CheckDataLog.Modify(true);
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
