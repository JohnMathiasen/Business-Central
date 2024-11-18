page 50106 "CharacterSet_EVAS"
{
    ApplicationArea = All;
    Caption = 'CharacterSet', Comment = 'DAN="Tegnsæt"';
    PageType = Card;
    SourceTable = CharacterSet_EVAS;
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'DAN="Generelt"';

                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = 'DAN="Kode"';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.', Comment = 'DAN="Beskrivelse"';
                }
                field("Type"; Rec."Type")
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = 'DAN="Type"';
                }
            }
            group(Characters)
            {
                Caption = 'Character set', Comment = 'DAN="Tegnsæt"';

                field("Character set"; Rec."Character set")
                {
                    ToolTip = 'Specifies the value of the Characters field.', Comment = 'DAN="Tegn"';
                }
                group(Replace)
                {
                    ShowCaption = false;

                    Visible = Rec.Type = Rec.Type::Replace;

                    field("Replace Character set"; Rec."Replace Character set")
                    {
                        ToolTip = 'Specifies the value of the Characters field.', Comment = 'DAN="Tegn"';
                    }
                }
            }
        }
    }
}