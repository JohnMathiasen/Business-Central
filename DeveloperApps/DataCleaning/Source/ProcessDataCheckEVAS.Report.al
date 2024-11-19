report 50100 "Process Data Check_EVAS"
{
    ApplicationArea = All;
    Caption = 'Process Check Data', Comment = 'DAN="Proces datakontrol"';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    dataset
    {
        dataitem(CheckDataHeader; "Check Data Header_EVAS")
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = Code, "Check Data Group Code";

            trigger OnAfterGetRecord()
            begin
                ProcessCleanData(CheckDataHeader);
            end;
        }
    }

    local procedure ProcessCleanData(CheckDataHeader: Record "Check Data Header_EVAS")
    var
        ProcessDataClean: Codeunit "Process Data Check";
        FromDT: DateTime;
    begin
        FromDT := CreateDateTime(CalcDate('<-36M>', Today), 0T);
        ProcessDataClean.FindDataForCleaning(CheckDataHeader, FromDT);
    end;
}
