permissionset 50100 "DataClean_ADM_EVAS"
{
    Assignable = true;
    Caption = 'Data Cleaning Adm', MaxLength = 30;
    Permissions =
        tabledata "Data Clean Header_EVAS" = RMID,
        tabledata "Data Clean Line_EVAS" = RMID,
        tabledata "CharacterSet_EVAS" = RMID,
        tabledata "Document Character Set_EVAS" = RMID,
        tabledata "Data Clean Log_EVAS" = RMID,
        tabledata "Data Clean Group_EVAS" = RMID;
}
