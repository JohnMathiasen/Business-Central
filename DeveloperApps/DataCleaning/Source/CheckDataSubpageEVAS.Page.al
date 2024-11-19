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
                        DataCleanHeader: Record "Chack Data Header_EVAS";
                        Field: Record Field;
                    begin
                        DataCleanHeader.get(Rec.Code);
                        Field.SetRange(TableNo, Rec."Table No.");
                        if Page.RunModal(Page::"Fields Lookup", Field) = Action::LookupOK then
                            Text := format(Field."No.");
                        exit(Text <> '');
                    end;
                }
                field("Character Sets"; Rec.GetFieldCharacterSets())
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
                        DocumentCharacterSetsPage.Run();
                    end;
                }
            }
        }
    }
}