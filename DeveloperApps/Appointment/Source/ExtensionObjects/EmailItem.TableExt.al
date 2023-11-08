/// <summary>
/// TableExtension Email Item_EVAS (ID 50300) extends Record Email Item.
/// </summary>
tableextension 50300 "Email Item_EVAS" extends "Email Item"
{
    fields
    {
        field(50300; "Starting DateTime_EVAS"; DateTime)
        {
            Caption = 'Starting Datetime', Comment = 'DAN="Start datotid"';
            DataClassification = CustomerContent;
        }
        field(50301; "Ending DateTime_EVAS"; DateTime)
        {
            Caption = 'Ending Datetime', Comment = 'DAN="Slut datotid"';
            DataClassification = CustomerContent;
        }
        field(50302; Calender_EVAS; Boolean)
        {
            Caption = 'Calender', Comment = 'DAN="Kalender"';
            DataClassification = CustomerContent;
        }
        field(50303; "Appointment Title_EVAS"; Text[250])
        {
            Caption = 'Title', Comment = 'DAN="Titel"';
            DataClassification = CustomerContent;
        }
        field(50304; Location_EVAS; Text[250])
        {
            Caption = 'Location', Comment = 'DAN="Sted"';
            DataClassification = CustomerContent;
        }
        field(503005; Cancellation_EVAS; Boolean)
        {
            Caption = 'Cancellation', Comment = 'DAN="Annullering"';
            DataClassification = CustomerContent;
        }
    }
}
