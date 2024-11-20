table 50102 "CharacterSet_EVAS"
{
    Caption = 'CharacterSet', Comment = 'DAN="Tegnsæt"';
    DataClassification = CustomerContent;
    LookupPageId = CharacterSets_EVAS;
    DrillDownPageId = CharacterSets_EVAS;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code', Comment = 'DAN="Kode"';
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description', Comment = 'DAN="Beskrivelse"';
        }
        field(3; "Type"; Enum "Characterset Type_EVAS")
        {
            Caption = 'Type', comment = 'DAN="Type"';
        }
        field(5; "Character set"; Text[2048])
        {
            Caption = 'Character set', comment = 'DAN="Tegn"';
            trigger OnValidate()
            begin
            end;
        }
        field(6; "Replace Character set"; Text[2048])
        {
            Caption = 'Replace Characters set', comment = 'DAN="Erstat Tegn"';
            trigger OnValidate()
            begin
            end;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }


    internal procedure CheckReplaceList(ShowErr: Boolean): Boolean
    begin
        if "Character set" = "Replace Character set" then
            exit(true);
        if not CheckRedundancyTextList("Character set", ShowErr) then
            exit(false);
        if not CheckRedundancyTextList("Replace Character set", ShowErr) then
            exit(false);
        exit(CompareReplaceList(ShowErr));
    end;

    local procedure CompareReplaceList(ShowErr: Boolean): Boolean
    var
        SameNumberCharatersErr: Label '%1 and %2 must have the same number of characters', Comment = 'DAN = "%1 og %2 skal have samme antal tegn"';
    begin
        if "Character set" = "Replace Character set" then
            exit(true);
        if "Character set" = '' then
            exit(false);
        if "Replace Character set" = '' then
            exit(false);
        if StrLen("Character set") <> StrLen("Replace Character set") then
            if ShowErr then
                Error(SameNumberCharatersErr, FieldCaption("Character set"), FieldCaption("Replace Character set"))
            else
                exit(false);

        CheckTextList("Character set", ShowErr);
        CheckTextList("Replace Character set", ShowErr);
        CompareTextList("Character set", "Replace Character set", ShowErr);

        exit(true);
    end;

    local procedure CompareTextList(TextList1: Text; TextList2: Text; ShowErr: Boolean): Boolean
    var
        CheckTxt: Text;
        I: Integer;
        SameCharacterErr: Label 'Character %1 exists in bot lists - %2 and %3', Comment = 'DAN = "Tegn %1 findes i begge lister - %2 og %3"';
    begin
        CheckTxt := TextList1;
        for I := 1 to strlen(TextList2) do
            if not CheckCharacter(TextList2[I], CheckTxt) then
                if ShowErr then
                    Error(SameCharacterErr, TextList2[I], FieldCaption("Character set"), FieldCaption("Replace Character set"))
                else
                    exit(false);
    end;

    local procedure CheckTextList(TextList: Text; ShowErr: Boolean): Boolean
    var
        CheckTxt: Text;
        I: Integer;
        SameCharacterErr: Label 'Character %1 exists more one time in %2', Comment = 'DAN = "Tegn %1 findes flere gange i %2"';
    begin
        for I := 1 to strlen(TextList) do
            if not CheckCharacter(TextList[I], CheckTxt) then
                if ShowErr then
                    Error(SameCharacterErr, "Character set"[I], "Character set")
                else
                    exit(false);
    end;

    local procedure CheckCharacter(Character: Char; var CheckTxt: Text): Boolean
    begin
        if CheckTxt.Contains(Character) then
            exit(false)
        else
            CheckTxt += "Character";
    end;

    local procedure CheckRedundancyTextList(TextList: Text[2048]; ShowErr: Boolean): Boolean
    var
        RedundantErr: Label 'Redundant character %1', Comment = 'DAN = "Redundant tegn %1"';
        CheckTxt: Text[2048];
        I: Integer;
    begin
        for I := 1 to StrLen(TextList) do
            if CheckTxt.Contains(TextList[I]) then
                if ShowErr then
                    Error(RedundantErr, TextList[I])
                else
                    exit(false)
            else
                CheckTxt += TextList[I];
        exit(true);
    end;

    internal procedure CreateDefaultCharacterSet()
    var
        NumberDescLbl: Label 'Numbers', Comment = 'DAN = "Tal"';
        DKDescLbl: Label 'DK Letters', Comment = 'DAN = "DK alfabet"';
        AddDKDescLbl: Label 'Add. DK Letters', Comment = 'DAN = "Tilføjet DK alfabet"';
        NewType: Enum "Characterset Type_EVAS";
    begin
        CreateCharacterSet(GetNumberCharacterSetCode(), NewType::"Invalid", NumberDescLbl, GetNumberCharacterSetContent());
        CreateCharacterSet(GetDKCharacterSetCode(), NewType::"Invalid", DKDescLbl, GetDKCharacterSetContent());
        CreateCharacterSet(GetAddDKCharacterSetCode(), NewType::"Invalid", AddDKDescLbl, GetAddDKCharacterSetContent());
    end;



    local procedure CreateCharacterSet(NewCode: Code[20]; NewType: Enum "Characterset Type_EVAS"; NewDescription: Text[100]; NewCharacterset: Text[2048])
    var
        CharacterSet: Record "CharacterSet_EVAS";
    begin
        if CharacterSet.Get(NewCode) then
            exit;
        if CharacterSetExist(NewCharacterset) then
            exit;
        CreateDefault(NewCode, NewType, NewDescription, NewCharacterset);
    end;

    local procedure CreateDefault(NewCode: Code[20]; NewType: Enum "Characterset Type_EVAS"; NewDescription: Text[100]; NewCharacterset: Text[2048])
    begin
        Init();
        Code := NewCode;
        Description := NewDescription;
        Type := NewType;
        "Character set" := NewCharacterset;
        Insert(true);
    end;

    local procedure CharacterSetExist(NewCharacterset: Text[2048]): Boolean
    var
        CharacterSet: Record "CharacterSet_EVAS";
    begin
        CharacterSet.SetRange("Character set", NewCharacterset);
        exit(not CharacterSet.IsEmpty);
    end;

    local procedure GetNumberCharacterSetCode(): Code[20]
    var
        CharacterSetCodeLbl: Label 'NUMBERS', Locked = true;
    begin
        exit(CharacterSetCodeLbl);
    end;

    local procedure GetNumberCharacterSetContent(): Text[2048]
    var
        CharacterSetContentLbl: Label '0123456789', Locked = true;
    begin
        exit(CharacterSetContentLbl);
    end;

    local procedure GetDKCharacterSetCode(): Code[20]
    var
        CharacterSetCodeLbl: Label 'LETTERS', Locked = true;
    begin
        exit(CharacterSetCodeLbl);
    end;

    local procedure GetDKCharacterSetContent(): Text[2048]
    var
        CharacterSetContentLbl: Label 'abcdefghijklmnopqrstuvwxyzæøå', Locked = true;
        SpaceLbl: Label ' ', Locked = true;
    begin
        exit(CharacterSetContentLbl + UpperCase(CharacterSetContentLbl) + SpaceLbl);
    end;

    local procedure GetAddDKCharacterSetCode(): Code[20]
    var
        CharacterSetCodeLbl: Label 'ADDDKLETTERS', Locked = true;
    begin
        exit(CharacterSetCodeLbl);
    end;

    local procedure GetAddDKCharacterSetContent(): Text[2048]
    var
        CharacterSetContentLbl: Label 'äöü', Locked = true;
        SpaceLbl: Label ' ', Locked = true;
    begin
        exit(CharacterSetContentLbl + UpperCase(CharacterSetContentLbl) + SpaceLbl);
    end;
}
