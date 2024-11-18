page 50100 "Data Clean Document_EVAS"
{
    ApplicationArea = All;
    Caption = 'Data Clean Document', Comment = 'DAN="Datavaskdokument"';
    PageType = Document;
    SourceTable = "Data Clean Header_EVAS";
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
                field("Data Clean Group Code"; Rec."Data Clean Group Code")
                {
                    ToolTip = 'Specifies the value of the Data Clean Group code field.', Comment = 'DAN="Datavaskgruppekode"';
                }
                field(Enabled; Rec.Enabled)
                {
                    ToolTip = 'Specifies the value of the Enabled field.', Comment = 'DAN="Aktiv"';
                }
            }
            part(Lines; "Data Clean Subpage_EVAS")
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
                    DataCleanHeader: Record "Data Clean Header_EVAS";
                begin
                    DataCleanHeader.SetRange(Code, Rec.Code);
                    DataCleanHeader.SetRange("Table No.", Rec."Table No.");
                    Report.Run(Report::"Process Data Clean_EVAS", true, false, DataCleanHeader);
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
                    DataCleanLog: Record "Data Clean Log_EVAS";
                begin
                    DataCleanLog.SetRange(Code, Rec.Code);
                    DataCleanLog.SetRange("Table No.", Rec."Table No.");
                    Report.Run(Report::"Post Data Clean_EVAS", true, false, DataCleanLog);
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
                RunObject = page "Data Clean Log_EVAS";
                RunPageLink = Code = field(Code), "Table No." = field("Table No.");
            }
        }
    }
}
