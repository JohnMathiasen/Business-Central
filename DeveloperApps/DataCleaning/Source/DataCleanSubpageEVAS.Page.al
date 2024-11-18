page 50101 "Data Clean Subpage_EVAS"
{
    ApplicationArea = All;
    Caption = 'Data Clean Subpage', Comment = 'DAN="Datavask Subpage"';
    PageType = ListPart;
    SourceTable = "Data Clean Line_EVAS";
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
                        Field: Record Field;
                    begin
                        Field.SetRange(TableNo, Rec."Table No.");
                        Field.SetFilter(Type, '%1|%2', Field.Type::Text, Field.Type::Code);
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
    actions
    {
        area(Processing)
        {
            action(ShowLogEntries)
            {
                ApplicationArea = All;
                Caption = 'Show Log', Comment = 'DAN = "Vis log"';
                ToolTip = 'Show the data clean log.', Comment = 'DAN="Vis datavasklog"';
                Image = Log;
                RunObject = page "Data Clean Log_EVAS";
                RunPageLink = Code = field(Code), "Table No." = field("Table No."), "Field No." = field("Field No.");
            }
        }
    }
}