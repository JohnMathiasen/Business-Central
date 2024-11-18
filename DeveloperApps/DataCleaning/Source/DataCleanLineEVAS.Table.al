table 50101 "Data Clean Line_EVAS"
{
    Caption = 'Data Clean  Line', Comment = 'DAN="Datavasklinje"';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code', Comment = 'DAN="Kode"';
        }
        field(2; "Table No."; Integer)
        {
            Caption = 'Table No.', Comment = 'DAN="Tabelnr."';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));
        }
        field(3; "Field No."; Integer)
        {
            Caption = 'Field No.', Comment = 'DAN="Felt nr."';
            TableRelation = Field."No." where(TableNo = field("Table No."), Type = filter(Text | Code));
        }
        field(10; "Character Set exist"; Boolean)
        {
            Caption = 'Character Set exist', Comment = 'DAN="Tegnsæt eksisterer"';
            FieldClass = FlowField;
            CalcFormula = exist("Document Character Set_EVAS" where(Code = field(Code), "Table No." = field("Table No."), "Field No." = field("Field No.")));
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Code", "Table No.", "Field No.")
        {
            Clustered = true;
        }
    }

    internal procedure GetFieldCharacterSets(): Text
    var
        DocumentCharacterSet: Record "Document Character Set_EVAS";
        CharacterSets: Text;
    begin
        DocumentCharacterSet.SetRange(Code, Code);
        DocumentCharacterSet.SetRange("Table No.", "Table No.");
        DocumentCharacterSet.SetRange("Field No.", "Field No.");
        if DocumentCharacterSet.IsEmpty then
            exit('');

        DocumentCharacterSet.FindSet();
        repeat
            CharacterSets += DocumentCharacterSet."CharacterSet Code" + ',';
        until DocumentCharacterSet.Next() = 0;
        exit(CharacterSets.TrimEnd(','));
    end;

    internal procedure GetCombineCharacterSets(): Text
    var
        DocumentCharacterSet: Record "Document Character Set_EVAS";
        CharacterSet: Record "CharacterSet_EVAS";
        CombinedCharacterSet: Text;
        I, J : Integer;
    begin
        DocumentCharacterSet.SetRange(Code, Code);
        DocumentCharacterSet.SetRange("Table No.", "Table No.");
        DocumentCharacterSet.SetRange("Field No.", "Field No.");
        if DocumentCharacterSet.IsEmpty then
            exit('');

        DocumentCharacterSet.FindSet();
        repeat
            I += 1;
            CharacterSet.Get(DocumentCharacterSet."CharacterSet Code");
            if I = 1 then
                CombinedCharacterSet := CharacterSet."Character set"
            else
                for J := 1 to StrLen(CharacterSet."Character set") do
                    if not CombinedCharacterSet.Contains(CharacterSet."Character set"[J]) then
                        CombinedCharacterSet += CharacterSet."Character set"[J];
        until DocumentCharacterSet.Next() = 0;
        exit(CombinedCharacterSet)
    end;
}
