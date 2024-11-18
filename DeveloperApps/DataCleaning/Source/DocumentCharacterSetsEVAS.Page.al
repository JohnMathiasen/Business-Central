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
                    begin
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
