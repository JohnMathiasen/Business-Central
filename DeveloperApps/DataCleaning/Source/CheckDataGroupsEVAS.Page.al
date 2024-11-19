page 50107 "Check Data Groups_EVAS"
{
    ApplicationArea = All;
    Caption = 'Check Data Groups', Comment = 'DAN="Datakontrolgrupper"';
    PageType = List;
    SourceTable = "Check Data Group_EVAS";
    UsageCategory = Lists;

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
            }
        }
    }
}
