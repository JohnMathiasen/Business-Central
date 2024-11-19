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
                CheckDataLine.SetFilter("Field No.", '<>%1', 0);
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

        if Value = '' then
            exit;

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

        if NewValue <> Value then
            CreateLog(Value, NewValue, RecRef, CheckDataHeader, CheckDataLine);
    end;

    local procedure CheckDataField(var DocumentCharacterSet: Record "Document Character Set_EVAS"; CheckDataLine: Record "Check Data Line_EVAS"; var Value: Text[2048])
    var
        CharacterSet: Record CharacterSet_EVAS;
        CharaterSetCode: Code[20];
        RegexList, ValidList : List of [Code[20]];
        ErrorCharacters, NewValue : Text[2048];
    begin
        if DocumentCharacterSet.FindSet() then
            repeat
                CharacterSet.Get(DocumentCharacterSet."CharacterSet Code");
                case CharacterSet.Type of
                    CharacterSet.Type::"Invalid":
                        AddToCharacterSetList(CharacterSet, ValidList);
                    CharacterSet.Type::Regex:
                        AddToCharacterSetList(CharacterSet, RegexList);
                end;
            until DocumentCharacterSet.Next() = 0;

        if ValidList.Count > 0 then begin
            NewValue := CheckCharacterSet(Value, CheckDataLine);
            ErrorCharacters := DelChr(Value, '<=>', NewValue);
        end;

        if RegexList.Count > 0 then
            foreach CharaterSetCode in RegexList do begin
                CharacterSet.Get(CharaterSetCode);
                CheckRegex(Value, CharacterSet, ErrorCharacters);
            end;

        Value := ErrorCharacters;
    end;

    local procedure CleanDataField(var DocumentCharacterSet: Record "Document Character Set_EVAS"; CheckDataLine: Record "Check Data Line_EVAS"; var NewValue: Text[2048])
    var
        CharacterSet: Record CharacterSet_EVAS;
        CharaterSetCode: Code[20];
        RemoveList, ReplaceList, ValidList : List of [Code[20]];
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
    begin
        if Regex.IsMatch(NewValue, CharacterSet."Character set") then
            exit;

        ResultTxt := 'Fejl';
    end;
}
