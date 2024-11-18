page 50107 "Data Clean Groups_EVAS"
{
    ApplicationArea = All;
    Caption = 'Data Clean Groups', Comment = 'DAN="Datavask Grupper"';
    PageType = List;
    SourceTable = "Data Clean Group_EVAS";
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
