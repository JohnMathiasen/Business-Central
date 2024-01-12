/// <summary>
/// Page Kill sessions_EVAS (ID 98112).
/// </summary>
page 98112 "Terminate sessions_EVAS"
{
    ApplicationArea = All;
    Caption = 'Terminate sessions', Comment = 'Afslut sessioner';
    PageType = List;
    SourceTable = "Active Session";
    UsageCategory = Tasks;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User ID field.';
                    StyleExpr = MySessionTxt;
                }

                field(IdleClientTimeout; UserSetup."Idle Client Timeout_EVAS")
                {
                    Caption = 'Idle Client Timeout';
                    ToolTip = 'Idle Client Timeout';
                    Editable = false;
                    StyleExpr = MySessionTxt;

                }
                field(EnableIdleClientTimeout; UserSetup."Enable Idle Cli. Timeout_EVAS")
                {
                    Caption = 'Enable Idle Client Timeout';
                    ToolTip = 'Enable Idle Client Timeout';
                    Editable = false;
                    StyleExpr = MySessionTxt;

                }
                field(TotalSessions; UserSetup."Total Sessions_EVAS")
                {
                    Caption = 'Total Sessions';
                    ToolTip = 'Total Sessions';
                    Editable = false;
                    StyleExpr = MySessionTxt;

                }
                field(TotalSessionsLimit; UserSetup."Total Sessions Limit_EVAS")
                {
                    Caption = 'Total Sessions Limit';
                    ToolTip = 'Total Sessions Limit';
                    Editable = false;
                    StyleExpr = MySessionTxt;

                }
                field("Session ID"; Rec."Session ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Session ID field.';
                    StyleExpr = MySessionTxt;
                }
                field("Login Datetime"; Rec."Login Datetime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Login Datetime field.';
                    StyleExpr = MySessionTxt;
                }
                field("Client Type"; Rec."Client Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Client Type field.';
                    StyleExpr = MySessionTxt;
                }
                field("Client Computer Name"; Rec."Client Computer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Client Computer Name field.';
                    StyleExpr = MySessionTxt;
                }
                field("Server Instance ID"; Rec."Server Instance ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Server Instance ID field.';
                    StyleExpr = MySessionTxt;
                }
                field("Server Instance Name"; Rec."Server Instance Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Server Instance Name field.';
                    StyleExpr = MySessionTxt;
                }
                field("Server Computer Name"; Rec."Server Computer Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Server Computer Name field.';
                    StyleExpr = MySessionTxt;
                }
                field("Database Name"; Rec."Database Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Database Name field.';
                    StyleExpr = MySessionTxt;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Termination)
            {
                ApplicationArea = All;
                Caption = 'Terminate Session', Comment = 'DAN="Afslut Session"';
                Image = Stop;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Terminate selected session';

                trigger OnAction();
                var
                    UserPermissions: Codeunit "User Permissions";
                    CancelledTxt: Label 'Selected session has been cancelled', Comment = 'DAN="Den valgte session er lukket"';
                    NoPermissionTxt: Label 'You do not have the proper permission', Comment = 'DAN="Du har ikke de nødvendige rettigheder"';
                    TerminateTxt: Label '%1 terminate your current session.', Comment = 'DAN="%1 Afslut den aktuelle session"';
                    TerminateMsg: Text;
                begin
                    if Rec."Session ID" = SessionId() then
                        exit;

                    if UserPermissions.CanManageUsersOnTenant(UserSecurityId()) then begin
                        TerminateMsg := StrSubstNo(TerminateTxt, UserID());
                        ClearLastError();
                        if not StopSession(Rec."Session ID", TerminateMsg) then begin
                            ErrTxt := GetLastErrorText();
                            if ErrTxt = '' then
                                Rec.Delete(true)
                            else
                                Error(ErrTxt);
                        end else
                            Message(CancelledTxt);
                    end else
                        Message(NoPermissionTxt);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        GetUserSetup(Rec."User ID");
        MySessionTxt := 'standard';
        if Rec."Session ID" = SessionId() then
            MySessionTxt := 'strong';
    end;

    local procedure GetUserSetup(UserID: Text[132]): Boolean
    begin
        if UserID <> Usersetup."User ID" then
            if not UserSetup.Get(UserID) then
                UserSetup.Init();
    end;

    var
        UserSetup: Record "User Setup";
        MySessionTxt: Text;
        ErrTxt: Text;
}
