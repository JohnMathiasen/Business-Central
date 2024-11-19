page 50105 "Check Data Log_EVAS"
{
    ApplicationArea = All;
    Caption = 'Check Data Log', Comment = 'DAN="Data kontrol log"';
    PageType = List;
    SourceTable = "Check Data Log_EVAS";
    UsageCategory = History;
    Editable = false;

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
                field("Table No."; Rec."Table No.")
                {
                    ToolTip = 'Specifies the value of the Table No. field.', Comment = 'DAN="Tabelnr."';
                }
                field("Field No."; Rec."Field No.")
                {
                    ToolTip = 'Specifies the value of the Field No. field.', Comment = 'DAN="Felt nr."';
                }
                field("Check Data Group Code"; Rec."Check Data Group Code")
                {
                    ToolTip = 'Specifies the value of the Check Data Group Code field.', Comment = 'DAN="Datakontrolgruppekode"';
                }
                field("Old Value"; Rec."Old Value")
                {
                    ToolTip = 'Specifies the value of the Old Value field.', Comment = 'DAN="Gammel værdi"';
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = 'DAN="Type"';
                }
                field("New Value"; Rec."New Value")
                {
                    ToolTip = 'Specifies the value of the New Value field.', Comment = '%DAN="Ny værdi"';
                    Visible = Rec.type = Rec.Type::Clean;
                }
                field("Invalid Characters"; Rec."Invalid Characters")
                {
                    ToolTip = 'Specifies the value of the Invalid Characters field.', Comment = 'DAN="Ugyldige tegn"';
                    Visible = Rec.type = Rec.Type::Check;
                }
                field(Transferred; Rec.Transferred)
                {
                    ToolTip = 'Specifies the value of the Transferred field.', Comment = 'DAN="Overført"';
                }
                field("Transferred DT"; Rec."Transferred DT")
                {
                    ToolTip = 'Specifies the value of the Transferred Datetime field.', Comment = 'DAN="Overført dato"';
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ToolTip = 'Specifies the value of the Entry No. field.', Comment = 'DAN="løbenr."';
                }
            }
        }
    }
    actions
    {
        area(Navigation)
        {
            action(OpenRelatedRecord)
            {
                ApplicationArea = Invoicing, Suite;
                Caption = 'Open Related Record', Comment = 'DAN="Åbn relateret post"';
                Image = View;
                ToolTip = 'Open the record that is associated with this activity.', Comment = 'DAN="Åbn posten, der er relateret til denne aktivitet"';

                trigger OnAction()
                begin
                    Rec.ShowRecord();
                end;
            }
        }
    }
}
