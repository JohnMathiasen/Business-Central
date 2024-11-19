table 50103 "Document Character Set_EVAS"
{
    Caption = 'Document Character Set', Comment = 'DAN="Dokument Tegnsæt"';
    DataClassification = CustomerContent;
    LookupPageId = "Document Character Sets_EVAS";
    DrillDownPageId = "Document Character Sets_EVAS";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; "Table No."; Integer)
        {
            Caption = 'Table No.', Comment = 'DAN="Tabelnr."';
            TableRelation = AllObjWithCaption."Object ID" where("Object Type" = const(Table));
        }
        field(3; "Field No."; Integer)
        {
            Caption = 'Field No.', Comment = 'DAN="Felt nr."';
            TableRelation = Field."No." where(TableNo = field("Table No."));
        }
        field(5; "CharacterSet Code"; Code[20])
        {
            Caption = 'Character Set Code', Comment = 'DAN="Tegnsæt Kode"';
            TableRelation = CharacterSet_EVAS.Code;
            NotBlank = true;
            trigger OnValidate()
            var
                CharacterSet: Record CharacterSet_EVAS;
                DataCleanHeader: Record "Chack Data Header_EVAS";
                CleanDocInvalidCharacterSetErr: Label 'The character set is not valid for a clean document.', Comment = 'DAN="Tegnsættet er ikke gyldigt for et datavask dokument."';
                CheckDocInvalidCharacterSetErr: Label 'The character set is not valid for a check document.', Comment = 'DAN="Tegnsættet er ikke gyldigt for et kontrol dokument."';
            begin
                if Rec."CharacterSet Code" <> '' then begin
                    CharacterSet.Get(Rec."CharacterSet Code");
                    DataCleanHeader.Get(Rec.Code);
                    if ((DataCleanHeader.Type = DataCleanHeader.Type::Clean) and (CharacterSet.Type <> CharacterSet.Type::Regex)) then
                        Error(CleanDocInvalidCharacterSetErr);
                    if ((DataCleanHeader.Type = DataCleanHeader.Type::Check) and (CharacterSet.Type in [CharacterSet.Type::"Invalid", CharacterSet.Type::Regex])) then
                        Error(CheckDocInvalidCharacterSetErr);
                end;
            end;

        }
    }
    keys
    {
        key(PK; "Code", "Table No.", "Field No.", "CharacterSet Code")
        {
            Clustered = true;
        }
    }
}
