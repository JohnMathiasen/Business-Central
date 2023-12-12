/// <summary>
/// PageExtension VendorList_EVAS (ID 50300) extends Record Vendor List.
/// </summary>
pageextension 50300 "VendorList_EVAS" extends "Vendor List"
{
    layout
    {
    }
    actions
    {
        addlast(processing)
        {
            action(TestCalendermail_EVAS)
            {
                ApplicationArea = all;
                Caption = 'Test Calender Mail';
                ToolTip = 'Test Calender Mail';
                Image = Calendar;
                trigger OnAction()
                var
                    CalenderMessage: Codeunit "Calender Message_EVAS";
                    OutlookAppointment: Codeunit "Outlook Appointment_EVAS";
                begin
                    ScheduleAppointment(CalenderMessage, '<+14D>');
                    SetCalenderDemoDetails(CalenderMessage);
                    //CalenderMessage.AddEmailAddressForLookup('Hans Jensen', 'hjensen@ghks.dk', Enum::"Email Recipient Type"::"To");
                    //CalenderMessage.AddEmailAddressForLookup('Per Jensen', 'pjensen@ghks.dk', Enum::"Email Recipient Type"::Cc);
                    //CalenderMessage.AddEmailAddressForLookup('Pia Gregersen', 'pgregersen@ghks.dk', Enum::"Email Recipient Type"::Cc);

                    OutlookAppointment.CreateAppointment(CalenderMessage, false, false);
                end;
            }

            action(TestCancel_EVAS)
            {
                ApplicationArea = all;
                Caption = 'Test Calender Cancel Mail';
                ToolTip = 'Test Calender Cancel Mail';
                Image = Calendar;

                trigger OnAction()
                var
                    OutlookAppointment: Codeunit "Outlook Appointment_EVAS";
                    CalenderMessage: Codeunit "Calender Message_EVAS";
                begin
                    ScheduleAppointment(CalenderMessage, '<+14D>');
                    SetCalenderDemoDetails(CalenderMessage);

                    OutlookAppointment.CancelAppointment(CalenderMessage, false, false);
                end;

            }
            action(TestMoveAppointment_FPS_EVAS)
            {
                ApplicationArea = all;
                Caption = 'Test Calender Move Appointment mail';
                ToolTip = 'Test Calender Move Appointment Mail';
                Image = Calendar;

                trigger OnAction()
                var
                    OutlookAppointment: Codeunit "Outlook Appointment_EVAS";
                    CalenderMessage: Codeunit "Calender Message_EVAS";
                begin

                    ScheduleAppointment(CalenderMessage, '<+21D>');
                    SetCalenderDemoDetails(CalenderMessage);

                    OutlookAppointment.UpdateAppointment(CalenderMessage, false, false);
                end;
            }
        }
    }

    local procedure SetCalenderDemoDetails(var CalenderMessage: Codeunit "Calender Message_EVAS")
    var
        Vendor: Record Vendor;
    begin
        Vendor.Get(Rec."No.");
        CalenderMessage.SetRecord(Vendor);
        CalenderMessage.SetUID(GetUID());
        //CalenderMessage.SetEmailScenario(Enum::"Email Scenario"::"Purchase Order");
        // CalenderMessage.SetFromEmail(JobTodo."Executer e-mail");
        CalenderMessage.SetSubject('Test meeting');
        CalenderMessage.SetSendToEmail('jnm@elbek-vejrup.dk');
        //CalenderMessage.SetMessageBody('');
        CalenderMessage.SetSummery(Vendor."No." + ' - ' + Vendor.Name);
        CalenderMessage.SetAppointmentDescription('Samarbejdsrelationer');
        CalenderMessage.SetLocation('Pacman');
    end;

    local procedure ScheduleAppointment(var CalenderMessage: Codeunit "Calender Message_EVAS"; DateFormula: Text)
    var
        AppointmentStart: DateTime;
        AppointmentEnd: DateTime;
    begin

        GetAppointment(AppointmentStart, AppointmentEnd, Today, DateFormula);

        CalenderMessage.SetStartDateTime(AppointmentStart);
        CalenderMessage.SetEndDateTime(AppointmentEnd);
    end;

    local procedure GetAppointment(var StartDT: DateTime; var EndDT: DateTime; AppointmentDate: Date; DateFormula: Text)
    begin
        StartDT := CreateDateTime(CalcDate(DateFormula, AppointmentDate), 100000T);
        EndDT := CreateDateTime(DT2Date(StartDT), 120000T);
    end;

    local procedure GetUID(): Guid
    var
        TestUID: Guid;
    begin
        TestUID := '{B1090155-8859-4962-832D-67C3F228D6F5}';
        exit(TestUID);
    end;

}

