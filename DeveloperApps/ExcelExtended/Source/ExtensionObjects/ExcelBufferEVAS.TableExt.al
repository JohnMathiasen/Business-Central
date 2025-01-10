tableextension 50550 "Excel Buffer_EVAS" extends "Excel Buffer"
{
    /// <summary>
    /// Showbuffer   
    /// </summary>
    /// <param name="ExcelBuffer"></param>
    procedure Showbuffer(ExcelBuffer: Record "Excel Buffer" temporary)
    begin
        Page.RunModal(Page::"Excel Buffer_EVAS", ExcelBuffer);
    end;
}
