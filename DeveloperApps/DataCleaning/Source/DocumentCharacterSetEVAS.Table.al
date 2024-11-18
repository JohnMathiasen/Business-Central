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
