enum 50100 "Characterset Type_EVAS"
{
    Extensible = true;

    value(0; "Invalid")
    {
        Caption = 'Invalid Character', Comment = 'DAN="Ugyldige tegn"';
    }
    value(1; Remove)
    {
        Caption = 'Remove Character', Comment = 'DAN="Fjern tegn"';
    }
    value(2; Replace)
    {
        Caption = 'Replace Character', Comment = 'DAN="Erstat tegn"';
    }
    value(3; Regex)
    {
        Caption = 'Regex', Comment = 'DAN="Regex"';
    }
}
