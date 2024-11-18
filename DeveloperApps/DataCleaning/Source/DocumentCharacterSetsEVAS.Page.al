page 50104 "Document Character Sets_EVAS"
{
    ApplicationArea = All;
    Caption = 'Document Character Sets', Comment = 'DAN="Dokument Tegnsæt"';
    PageType = List;
    SourceTable = "Document Character Set_EVAS";
    UsageCategory = Lists;
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = 'DAN="Kode"';
                    Visible = not UseAsLookup;
                }
                field("Table No."; Rec."Table No.")
                {
                    ToolTip = 'Specifies the value of the Table No. field.', Comment = 'DAN="Tabelnr."';
                    Visible = not UseAsLookup;
                }
                field("Field No."; Rec."Field No.")
                {
                    ToolTip = 'Specifies the value of the Field No. field.', Comment = 'DAN="Felt nr."';
                    Visible = not UseAsLookup;
                }
                field("CharacterSet Code"; Rec."CharacterSet Code")
                {
                    ToolTip = 'Specifies the value of the Character Set Code field.', Comment = 'DAN="Tegnsæt kode"';
                    trigger OnValidate()
                    var
                        CharacterSet: Record CharacterSet_EVAS;
                        DataCleanHeader: Record "Data Clean Header_EVAS";
                    begin
                        if "CharacterSet Code" <> '' then begin
                            CharacterSet.Get(Rec."CharacterSet Code");
                            DataCleanHeader.Get(Rec.Code);
                            if ((DataCleanHeader.Type = DataCleanHeader.Type::Clean) and (CharacterSet.Type <> CharacterSet.Type::Regex)) then
                                Error('The character set is not valid for a clean document.');
                            if ((DataCleanHeader.Type = DataCleanHeader.Type::Check) and (CharacterSet.Type in [CharacterSet.Type::"Clean Invalid", CharacterSet.Type::Regex])) then
                                Error('The character set is not valid for a check document.');
                        end;
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        DataCleanHeader: Record "Data Clean Header_EVAS";
                        CharacterSet: Record CharacterSet_EVAS;
                    begin
                        DataCleanHeader.Get(Rec.Code);
                        if DataCleanHeader.Type = DataCleanHeader.Type::Clean then
                            CharacterSet.SetFilter(Type, '<>%1', CharacterSet.Type::Regex)
                        else
                            CharacterSet.SetFilter(Type, '%1|%2', CharacterSet.Type::"Clean Invalid", CharacterSet.Type::Regex);
                        if Page.RunModal(Page::CharacterSets_EVAS, CharacterSet) = Action::LookupOK then
                            Text := CharacterSet."Code";
                        exit(Text <> '');
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin

    end;

    var
        UseAsLookup: Boolean;

    internal procedure SetLookupMode(NewUseAsLookup: Boolean)
    begin
        UseAsLookup := NewUseAsLookup;
    end;
}
