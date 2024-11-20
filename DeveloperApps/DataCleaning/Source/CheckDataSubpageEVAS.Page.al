page 50101 "Check Data Subpage_EVAS"
{
    ApplicationArea = All;
    Caption = 'Check Data Subpage', Comment = 'DAN="Datakontrol Subpage"';
    PageType = ListPart;
    SourceTable = "Check Data Line_EVAS";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Field No."; Rec."Field No.")
                {
                    ToolTip = 'Specifies the value of the Field No. field.', Comment = 'DAN="Felt nr."';
                    LookupPageId = "Fields Lookup";
                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CheckDataHeader: Record "Check Data Header_EVAS";
                        Field: Record Field;
                    begin
                        CheckDataHeader.Get(Rec.Code);
                        Field.SetRange(TableNo, Rec."Table No.");
                        Field.SetRange(Class, Field.Class::Normal);
                        case CheckDataHeader.Type of
                            CheckDataHeader.Type::Clean:
                                Field.SetFilter(Type, '%1|%2', Field.Type::Code, Field.Type::"Text");
                            CheckDataHeader.Type::Check:
                                Field.SetFilter(Type, '%1', Field.Type::Text);
                        end;
                        if Page.RunModal(Page::"Fields Lookup", Field) = Action::LookupOK then
                            Text := format(Field."No.");
                        exit(Text <> '');
                    end;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.', Comment = 'DAN="Navn"';
                }
                field("Character Sets"; CharacterSets)
                {
                    Caption = 'Character Sets', Comment = 'DAN="Tegnsæt"';
                    ToolTip = 'Specifies the value of the Character Sets field.', Comment = 'DAN="Tegnsæt"';
                    trigger OnAssistEdit()
                    var
                        DocumentCharacterSet: Record "Document Character Set_EVAS";
                        DocumentCharacterSetsPage: Page "Document Character Sets_EVAS";
                    begin
                        DocumentCharacterSet.SetRange(Code, Rec."Code");
                        DocumentCharacterSet.SetRange("Table No.", Rec."Table No.");
                        DocumentCharacterSet.SetRange("Field No.", Rec."Field No.");

                        DocumentCharacterSetsPage.SetLookupMode(true);
                        DocumentCharacterSetsPage.SetTableView(DocumentCharacterSet);
                        DocumentCharacterSetsPage.RunModal();
                        CharacterSets := Rec.GetFieldCharacterSets();
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.InitLine();
    end;

    trigger OnAfterGetRecord()
    begin
        CharacterSets := Rec.GetFieldCharacterSets();
        CurrPage.Update(false);
    end;


    var
        CharacterSets: Text;
}