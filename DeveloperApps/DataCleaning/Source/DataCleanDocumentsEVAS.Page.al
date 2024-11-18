page 50102 "Data Clean Documents_EVAS"
{
    ApplicationArea = All;
    Caption = 'Data Clean Documents', Comment = 'DAN="Datavaskdokumenter"';
    PageType = List;
    SourceTable = "Data Clean Header_EVAS";
    UsageCategory = Lists;
    Editable = false;
    CardPageId = "Data Clean Document_EVAS";

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
                field("Table No."; Rec."Table No.")
                {
                    ToolTip = 'Specifies the value of the Table No. field.', Comment = 'DAN="Tabelnr."';
                }
                field("Data Clean Group"; Rec."Data Clean Group Code")
                {
                    ToolTip = 'Specifies the value of the Data Clean Group field.', Comment = 'DAN="Datavaskgruppe"';
                }
                field(Enabled; Rec.Enabled)
                {
                    ToolTip = 'Specifies the value of the Enabled field.', Comment = 'DAN="Aktiv"';
                }
            }
        }
    }
}
