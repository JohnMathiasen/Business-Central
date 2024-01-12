/// <summary>
/// Codeunit Idle Session Management_EVAS (ID 98110).
/// </summary>
codeunit 98110 "Idle Session Management_EVAS"
{

    trigger OnRun()
    begin
        TerminateIdleSessions();
    end;

    local procedure TerminateIdleSessions()
    var
        UserSetup: Record "User Setup";
    begin
        UserSetup.SetCurrentKey("Enable Idle Cli. Timeout_EVAS", "Idle Client Timeout_EVAS");
        UserSetup.SetRange("Enable Idle Cli. Timeout_EVAS", true);
        if UserSetup.FindSet(false, false) then
            repeat
                HandleUserSessions(UserSetup);
            until UserSetup.Next() = 0;
    end;

    local procedure HandleUserSessions(UserSetup: Record "User Setup")
    var
        ActiveSession: Record "Active Session";
        LastActiveSession: Record "Active Session";
        TempActiveSession: Record "Active Session" temporary;
        SessionDuration: Duration;
        I: Integer;
    begin
        TempActiveSession.DeleteAll();
        ActiveSession.SetRange("User ID", UserSetup."User ID");
        if ActiveSession.FindSet(false, false) then
            repeat
                SessionDuration := CurrentDateTime - ActiveSession."Login Datetime";
                if SessionDuration > UserSetup."Idle Client Timeout_EVAS" then
                    TerminateSession(ActiveSession)
                else begin
                    I += 1;
                    TempActiveSession := ActiveSession;
                    TempActiveSession.Insert();
                    if ActiveSession."Login Datetime" > LastActiveSession."Login Datetime" then
                        LastActiveSession := ActiveSession;
                end;
            until ActiveSession.Next() = 0;

        if TempActiveSession.IsEmpty then
            exit;

        if (I > 1) and (UserSetup."Total Sessions Limit_EVAS" < I) then begin
            TempActiveSession.FindSet(false, false);
            repeat
                if TempActiveSession."Session ID" <> LastActiveSession."Session ID" then
                    TerminateSession(TempActiveSession);
            until TempActiveSession.Next() = 0;
        end;
    end;

    local procedure TerminateSession(ActiveSession: Record "Active Session")
    var
        TerminateMsg: Text;
        TerminateTxt: Label 'Session terminated for user %1.', Comment = 'DAN="Afsluttet sessionen for bruger %1."';
        ErrTxt: Text;
    begin
        if ActiveSession."Session ID" = SessionId() then
            exit;

        TerminateMsg := StrSubstNo(TerminateTxt, UserID());
        ClearLastError();
        if not StopSession(ActiveSession."Session ID", TerminateMsg) then begin
            ErrTxt := GetLastErrorText();
            if ErrTxt = '' then
                ActiveSession.Delete(true)
            else
                Error(ErrTxt);
        end;
    end;
}
