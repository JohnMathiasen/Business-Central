page 50550 "Excel Buffer_EVAS"
{
    ApplicationArea = All;
    Caption = 'Excel Buffer', Comment = 'Excel Buffer';
    PageType = List;
    SourceTable = "Excel Buffer";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(xlRowID; Rec.xlRowID)
                {
                    ToolTip = 'Specifies the value of the xlRowID field.', Comment = '%';
                }
                field(xlColID; Rec.xlColID)
                {
                    ToolTip = 'Specifies the value of the xlColID field.', Comment = '%';
                }
                field("Row No."; Rec."Row No.")
                {
                    ToolTip = 'Specifies the value of the Row No. field.', Comment = '%';
                }
                field("Column No."; Rec."Column No.")
                {
                    ToolTip = 'Specifies the value of the Column No. field.', Comment = '%';
                }
                field("Cell Type"; Rec."Cell Type")
                {
                    ToolTip = 'Specifies the value of the Cell Type field.', Comment = '%';
                }
                field("Cell Value as Text"; Rec."Cell Value as Text")
                {
                    ToolTip = 'Specifies the value of the Cell Value as Text field.', Comment = '%';
                }
                field(Bold; Rec.Bold)
                {
                    ToolTip = 'Specifies the value of the Bold field.', Comment = '%';
                }
                field(Comment; Rec.Comment)
                {
                    ToolTip = 'Specifies the value of the Comment field.', Comment = '%';
                }
                field("Double Underline"; Rec."Double Underline")
                {
                    ToolTip = 'Specifies the value of the Double Underline field.', Comment = '%';
                }
                field(Formula; Rec.Formula)
                {
                    ToolTip = 'Specifies the value of the Formula field.', Comment = '%';
                }
                field(Formula2; Rec.Formula2)
                {
                    ToolTip = 'Specifies the value of the Formula2 field.', Comment = '%';
                }
                field(Formula3; Rec.Formula3)
                {
                    ToolTip = 'Specifies the value of the Formula3 field.', Comment = '%';
                }
                field(Formula4; Rec.Formula4)
                {
                    ToolTip = 'Specifies the value of the Formula4 field.', Comment = '%';
                }
                field(Italic; Rec.Italic)
                {
                    ToolTip = 'Specifies the value of the Italic field.', Comment = '%';
                }
                field(NumberFormat; Rec.NumberFormat)
                {
                    ToolTip = 'Specifies the value of the NumberFormat field.', Comment = '%';
                }
                field(Underline; Rec.Underline)
                {
                    ToolTip = 'Specifies the value of the Underline field.', Comment = '%';
                }
            }
        }
    }
}
