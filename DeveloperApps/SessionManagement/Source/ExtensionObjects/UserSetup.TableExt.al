tableextension 98100 "User Setup_EVAS" extends "User Setup"
{
    fields
    {
        field(98100; "Idle Client Timeout_EVAS"; Duration)
        {
            Caption = 'Idle Client Timeout';
            DataClassification = SystemMetadata;
        }
        field(98101; "Enable Idle Cli. Timeout_EVAS"; Boolean)
        {
            Caption = 'Enable Idle Client Timeout';
            DataClassification = SystemMetadata;
        }
        field(98102; "Total Sessions_EVAS"; Integer)
        {
            Caption = 'Total Sessions';
            DataClassification = SystemMetadata;
            MinValue = 1;
            InitValue = 1;
        }
        field(98103; "Total Sessions Limit_EVAS"; Integer)
        {
            Caption = 'Total Sessions Limit';
            DataClassification = SystemMetadata;
            MinValue = 1;
            InitValue = 1;
        }

    }
    keys
    {
        key(Key98101; "Enable Idle Cli. Timeout_EVAS", "Idle Client Timeout_EVAS")
        {

        }
    }
}
