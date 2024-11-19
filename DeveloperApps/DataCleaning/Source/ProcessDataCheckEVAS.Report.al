report 50100 "Process Data Check_EVAS"
{
    ApplicationArea = All;
    Caption = 'Process Data Clean', Comment = 'DAN="Proces datavask"';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    dataset
    {
        dataitem(DataCleanHeader; "Chack Data Header_EVAS")
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = Code, "Data Clean Group Code";

            trigger OnAfterGetRecord()
            begin
                ProcessCleanData(DataCleanHeader);
            end;
        }
    }

    local procedure ProcessCleanData(DataCleanHeader: Record "Chack Data Header_EVAS")
    var
        ProcessDataClean: Codeunit "Process Data Check";
        FromDT: DateTime;
    begin
        FromDT := CreateDateTime(CalcDate('<-36M>', Today), 0T);
        ProcessDataClean.FindDataForCleaning(DataCleanHeader, FromDT);
    end;
}
