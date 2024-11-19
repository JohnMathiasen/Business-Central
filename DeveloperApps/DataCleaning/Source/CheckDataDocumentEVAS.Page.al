page 50100 "Check Data Document_EVAS"
{
    ApplicationArea = All;
    Caption = 'Check Data Document', Comment = 'DAN="Datakontroldokument"';
    PageType = Document;
    SourceTable = "Check Data Header_EVAS";
    UsageCategory = None;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

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
                field("Check Data Group Code"; Rec."Check Data Group Code")
                {
                    ToolTip = 'Specifies the value of the Check Data Group code field.', Comment = 'DAN="Datakontrolgruppekode"';
                }
                field(Type; Rec.Type)
                {
                    ToolTip = 'Specifies the value of the Type field.', Comment = 'DAN="Type"';
                }
                field(Enabled; Rec.Enabled)
                {
                    ToolTip = 'Specifies the value of the Enabled field.', Comment = 'DAN="Aktiv"';
                }
            }
            part(Lines; "Check Data Subpage_EVAS")
            {
                Caption = 'Fields', Comment = 'DAN="Felter"';
                SubPageLink = Code = field("Code"), "Table No." = field("Table No.");
            }
        }
    }


    actions
    {
        area(Promoted)
        {
            actionref(CleanData; Process)
            { }
            actionref(PostData; Post)
            { }
            actionref(ShowLog; ShowLogEntries)
            { }
        }
        area(Processing)
        {
            action(Process)
            {
                ApplicationArea = All;
                Caption = 'Process', Comment = 'DAN="Proces"';
                ToolTip = 'Process the data clean document.', Comment = 'DAN="Behandl datavaskdokument"';
                Image = Process;
                trigger OnAction()
                var
                    CheckDataHeader: Record "Check Data Header_EVAS";
                begin
                    CheckDataHeader.SetRange(Code, Rec.Code);
                    CheckDataHeader.SetRange("Table No.", Rec."Table No.");
                    Report.Run(Report::"Process Data Check_EVAS", true, false, CheckDataHeader);
                end;
            }
            action(Post)
            {
                ApplicationArea = All;
                Caption = 'Post', Comment = 'DAN = "Bogfør"';
                ToolTip = 'Post the data clean document.', Comment = 'DAN="Bogfør datavaskdokument"';
                Image = Post;

                trigger OnAction()
                var
                    CheckDataLog: Record "Check Data Log_EVAS";
                begin
                    CheckDataLog.SetRange(Code, Rec.Code);
                    CheckDataLog.SetRange("Table No.", Rec."Table No.");
                    Report.Run(Report::"Post Data Clean_EVAS", true, false, CheckDataLog);
                end;
            }
        }
        area(Navigation)
        {
            action(ShowLogEntries)
            {
                ApplicationArea = All;
                Caption = 'Show Log', Comment = 'DAN = "Vis log"';
                ToolTip = 'Show the data clean log.', Comment = 'DAN="Vis datavasklog"';
                Image = Log;
                RunObject = page "Check Data Log_EVAS";
                RunPageLink = Code = field(Code);
            }
        }
    }
}
