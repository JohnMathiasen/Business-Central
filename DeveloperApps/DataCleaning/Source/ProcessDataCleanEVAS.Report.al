report 50100 "Process Data Clean_EVAS"
{
    ApplicationArea = All;
    Caption = 'Process Data Clean', Comment = 'DAN="Proces datavask"';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    dataset
    {
        dataitem(DataCleanHeader; "Data Clean Header_EVAS")
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = Code, "Data Clean Group Code";

            trigger OnAfterGetRecord()
            begin
                ProcessCleanData(DataCleanHeader);
            end;
        }
    }

    local procedure ProcessCleanData(DataCleanHeader: Record "Data Clean Header_EVAS")
    var
        ProcessDataClean: Codeunit "Process Data Clean";
        FromDT: DateTime;
    begin
        FromDT := CreateDateTime(CalcDate('<-36M>', Today), 0T);
        ProcessDataClean.FindDataForCleaning(DataCleanHeader, FromDT);
    end;
}
