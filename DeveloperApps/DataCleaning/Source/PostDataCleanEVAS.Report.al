report 50101 "Post Data Clean_EVAS"
{
    ApplicationArea = All;
    Caption = 'Post Data Clean', Comment = 'DAN="Bogfør datavask"';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    dataset
    {
        dataitem(DataCleanLog; "Data Clean Log_EVAS")
        {
            DataItemTableView = sorting(Transferred, Blocked, Code, "Table No.", "SystemID Ref.", "Field No.") where(Transferred = const(false), Blocked = const(false));
            RequestFilterFields = Code, "Table No.", "Field No.";
            MaxIteration = 1;

            trigger OnAfterGetRecord()
            var
                ProcessDataClean: Codeunit "Process Data Clean";
            begin
                ProcessDataClean.PostDataCleaning(DataCleanLog);
            end;
        }
    }
}
