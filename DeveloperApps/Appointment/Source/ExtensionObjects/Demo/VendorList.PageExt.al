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

                    if OutlookAppointment.CreateAppointment(CalenderMessage, false, false) then begin
                        //  JobTodo."Outlook Calendar Event ID" := GetOutlookEventID(CalenderMessage.GetUID());
                        //  JobTodo.Modify();
                    end;
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
                    // JobTodo: Record "Job To-do_FPS";
                    OutlookAppointment: Codeunit "Outlook Appointment_EVAS";
                    CalenderMessage: Codeunit "Calender Message_EVAS";
                // StdStatusChangeFunct: Codeunit "Std. Status Change Funct._FPS";
                begin
                    ScheduleAppointment(CalenderMessage, '<+14D>');
                    SetCalenderDemoDetails(CalenderMessage);

                    //     JobTodo.Get(1);

                    //     if (JobTodo."Outlook Calendar Event ID" = '') then
                    //         exit;


                    //     CalenderMessage.SetRecord(JobTodo);
                    //     CalenderMessage.SetEmailScenario(Enum::"Email Scenario"::"Job To-do");
                    //     CalenderMessage.SetUID(JobTodo."Outlook Calendar Event ID");
                    //     CalenderMessage.SetStartDateTime(JobTodo."Scheduled Start");
                    //     CalenderMessage.SetEndDateTime(JobTodo."Scheduled End");
                    //     CalenderMessage.SetFromEmail(JobTodo."Executer e-mail");
                    //     CalenderMessage.SetSendToEmail('jnm@elbek-vejrup.dk');  //TODO
                    //     CalenderMessage.SetSubject(JobTodo.Title);
                    //     // CalenderMessage.SetMessageBody('');
                    //     // CalenderMessage.SetSummery(JobTodo."Job No." + ' ' + JobTodo.Description);
                    //     // CalenderMessage.SetAppointmentDescription(StdStatusChangeFunct.GetAppoinmentDescription(JobTodo));
                    if OutlookAppointment.CancelAppointment(CalenderMessage, false, false) then begin
                        //         JobTodo."Outlook Calendar Event ID" := '';
                        //         JobTodo.Modify();
                    end;
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
                    // JobTodo.Get(1);
                    //     if (JobTodo."Outlook Calendar Event ID" = '') then
                    //         exit;
                    //     JobTodo."Scheduled Start" := CreateDateTime(CalcDate('<+20D>', today), DT2Time(JobTodo."Scheduled Start"));
                    //     JobTodo."Scheduled End" := CreateDateTime(CalcDate('<+21D>', today), DT2Time(JobTodo."Scheduled End"));

                    //     CalenderMessage.SetRecord(JobTodo);
                    //     CalenderMessage.SetEmailScenario(Enum::"Email Scenario"::"Job To-do");
                    //     CalenderMessage.SetUID(JobTodo."Outlook Calendar Event ID");
                    //     CalenderMessage.SetStartDateTime(JobTodo."Scheduled Start");
                    //     CalenderMessage.SetEndDateTime(JobTodo."Scheduled End");
                    //     CalenderMessage.SetFromEmail(JobTodo."Executer e-mail");
                    //     CalenderMessage.SetSubject(JobTodo.Title);
                    //     CalenderMessage.SetSendToEmail('jnm@elbek-vejrup.dk');  //TODO
                    //     CalenderMessage.SetSummery(JobTodo."Job No." + ' ' + JobTodo.Description);
                    //     CalenderMessage.SetAppointmentDescription(JobTodo.Title + ' for sag ' + JobTodo."Job No.");
                    if OutlookAppointment.UpdateAppointment(CalenderMessage, false, false) then begin
                        //         JobTodo."Outlook Calendar Event ID" := GetOutlookEventID(CalenderMessage.GetUID());
                        //         JobTodo.Modify();
                    end;
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

