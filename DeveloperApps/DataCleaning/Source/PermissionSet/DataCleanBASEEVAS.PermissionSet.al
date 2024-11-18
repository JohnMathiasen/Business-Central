permissionset 50101 "DataClean_BASE_EVAS"
{
    Assignable = true;
    Caption = 'Data Cleaning BASE', MaxLength = 30;
    Permissions =
        tabledata "Data Clean Header_EVAS" = Rmid,
        tabledata "Data Clean Line_EVAS" = Rmid,
        tabledata "CharacterSet_EVAS" = Rmid,
        tabledata "Document Character Set_EVAS" = Rmid,
        tabledata "Data Clean Log_EVAS" = Rmid,
        tabledata "Data Clean Group_EVAS" = Rmid;
}
