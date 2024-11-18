page 50103 "CharacterSets_EVAS"
{
    ApplicationArea = All;
    Caption = 'CharacterSet List', Comment = 'DAN="Tegnsæt oversigt"';
    PageType = List;
    SourceTable = CharacterSet_EVAS;
    UsageCategory = Lists;
    CardPageId = "CharacterSet_EVAS";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = 'DAN="Kode"';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = 'DAN="Beskrivelse"';
                }
                field("Type"; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = 'DAN="Type"';
                }
                field("Character set"; Rec."Character set")
                {
                    ToolTip = 'Specifies the value of the Characters field.', Comment = 'DAN="Tegn"';
                }
                field("Replace Character set"; Rec."Replace Character set")
                {
                    ToolTip = 'Specifies the value of the Characters field.', Comment = 'DAN="Tegn"';
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.CreateDefaultCharacterSet();
    end;
}
