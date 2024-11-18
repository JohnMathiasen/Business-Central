permissionset 50101 "DataClean_BASE_EVAS"
{
    Assignable = true;
    Caption = 'Data Cleaning BASE', MaxLength = 30;
    Permissions =
        tabledata "Data Clean Header_EVAS" = Rmid,
        tabledata "Data Clean Line_EVAS" = Rmid;
}
