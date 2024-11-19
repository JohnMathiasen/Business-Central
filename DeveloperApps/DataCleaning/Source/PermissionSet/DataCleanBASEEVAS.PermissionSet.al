permissionset 50101 "DataClean_BASE_EVAS"
{
    Assignable = true;
    Caption = 'Data Cleaning BASE', MaxLength = 30;
    Permissions =
        tabledata "Chack Data Header_EVAS" = Rmid,
        tabledata "Check Data Line_EVAS" = Rmid,
        tabledata "CharacterSet_EVAS" = Rmid,
        tabledata "Document Character Set_EVAS" = Rmid,
        tabledata "Check Data Log_EVAS" = Rmid,
        tabledata "Check Data Group_EVAS" = Rmid;
}
