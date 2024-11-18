page 50105 "Data Clean Log_EVAS"
{
    ApplicationArea = All;
    Caption = 'Data Clean Log', Comment = 'DAN="Datavask log"';
    PageType = List;
    SourceTable = "Data Clean Log_EVAS";
    UsageCategory = History;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the value of the Code field.', Comment = '%DAN="Kode"';
                }
                field("Table No."; Rec."Table No.")
                {
                    ToolTip = 'Specifies the value of the Table No. field.', Comment = '%DAN="Tabelnr."';
                }
                field("Field No."; Rec."Field No.")
                {
                    ToolTip = 'Specifies the value of the Field No. field.', Comment = '%DAN="Felt nr."';
                }
                field("Data Clean Group Code"; Rec."Data Clean Group Code")
                {
                    ToolTip = 'Specifies the value of the Data Clean Group Code field.', Comment = 'DAN="Datavaskgruppekode"';
                }
                field("Old Value"; Rec."Old Value")
                {
                    ToolTip = 'Specifies the value of the Old Value field.', Comment = '%DAN="Gammel værdi"';
                }
                field("New Value"; Rec."New Value")
                {
                    ToolTip = 'Specifies the value of the New Value field.', Comment = '%DAN="Ny værdi"';
                }
                field(Transferred; Rec.Transferred)
                {
                    ToolTip = 'Specifies the value of the Transferred field.', Comment = '%DAN="Overført"';
                }
                field("Transferred DT"; Rec."Transferred DT")
                {
                    ToolTip = 'Specifies the value of the Transferred Datetime field.', Comment = '%DAN="Overført dato"';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = '%';
                }
            }
        }
    }
}
