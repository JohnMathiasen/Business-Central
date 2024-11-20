page 50104 "Document Character Sets_EVAS"
{
    ApplicationArea = All;
    Caption = 'Document Character Sets', Comment = 'DAN="Dokument Tegnsæt"';
    PageType = List;
    SourceTable = "Document Character Set_EVAS";
    DataCaptionExpression = GetDataCaption();
    UsageCategory = None;
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

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CheckDataHeader: Record "Check Data Header_EVAS";
                        CharacterSet: Record CharacterSet_EVAS;
                    begin
                        CheckDataHeader.Get(Rec.Code);
                        if CheckDataHeader.Type = CheckDataHeader.Type::Clean then
                            CharacterSet.SetFilter(Type, '<>%1', CharacterSet.Type::Regex)
                        else
                            CharacterSet.SetFilter(Type, '%1|%2', CharacterSet.Type::"Invalid", CharacterSet.Type::Regex);
                        if Page.RunModal(Page::CharacterSets_EVAS, CharacterSet) = Action::LookupOK then
                            Text := CharacterSet."Code";
                        exit(Text <> '');
                    end;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = 'DAN="Beskrivelse"';
                }
            }
        }
    }

    var
        UseAsLookup: Boolean;

    internal procedure SetLookupMode(NewUseAsLookup: Boolean)
    begin
        UseAsLookup := NewUseAsLookup;
    end;

    local procedure GetDataCaption(): Text
    var
        DataCaptionLbl: Label '%1-%2-%3-%4', Comment = '%1=Code, %2=Table No., %3=Field No., %4=CharacterSet Code';
    begin
        exit(StrSubstNo(DataCaptionLbl, Rec."Code", Rec."Table No.", Rec."Field No.", Rec."CharacterSet Code"));
    end;
}
