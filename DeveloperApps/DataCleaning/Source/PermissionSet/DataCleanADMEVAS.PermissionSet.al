permissionset 50100 "DataClean_ADM_EVAS"
{
    Assignable = true;
    Caption = 'Data Cleaning Adm', MaxLength = 30;
    Permissions =
        tabledata "Check Data Header_EVAS" = RMID,
        tabledata "Check Data Line_EVAS" = RMID,
        tabledata "CharacterSet_EVAS" = RMID,
        tabledata "Document Character Set_EVAS" = RMID,
        tabledata "Check Data Log_EVAS" = RMID,
        tabledata "Check Data Group_EVAS" = RMID;
        tabledata "Check Data Log_EVAS" = RMID,
        tabledata "Check Data Group_EVAS" = RMID;
}
