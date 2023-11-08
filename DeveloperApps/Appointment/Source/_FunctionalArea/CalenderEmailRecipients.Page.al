/// <summary>
/// Page Calender Email Recipients_EVAS (ID 50301).
/// </summary>
page 50301 "Calender Email Recipients_EVAS"
{
    Caption = 'Calender Email Recipients', Comment = 'DAN="Kalender mailmodtagere"';
    PageType = List;
    SourceTable = "Calender Email Recipient_EVAS";
    UsageCategory = None;
    SourceTableTemporary = true;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.', Comment = 'DAN="Navn"';
                }
                field("E-mail Address"; Rec."E-Mail Address")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the E-mail Address field.', Comment = 'DAN="E-mail adresse"';
                }
                field("Email Recipient Type"; Rec."Email Recipient Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Email Recipient Type field.', Comment = 'DAN="Mailmodtager type"';
                    visible = false;
                }
                field("Calender Entry Id"; Rec."Calender Entry UID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Calender Entry Id field.', Comment = 'DAN="Kalenderpost id"';
                }
            }
        }
    }

    /// <summary>
    /// GetSelectedSuggestions.
    /// </summary>
    /// <param name="CalenderEmailRecipient">VAR Record "Calender Email Recipient_EVAS".</param>
    internal procedure GetSelectedSuggestions(var CalenderEmailRecipient: Record "Calender Email Recipient_EVAS")
    begin
        CurrPage.SetSelectionFilter(Rec);
        if Rec.IsEmpty then
            exit;

        Rec.FindSet();
        repeat
            CalenderEmailRecipient.TransferFields(Rec);
            CalenderEmailRecipient.Insert();
        until Rec.Next() = 0;
    end;

    /// <summary>
    /// AddSuggestions.
    /// </summary>
    /// <param name="CalenderEmailRecipient">VAR Record "Calender Email Recipient_EVAS".</param>
    internal procedure AddSuggestions(var CalenderEmailRecipient: Record "Calender Email Recipient_EVAS")
    begin
        if CalenderEmailRecipient.FindSet() then
            repeat
                Rec.Copy(CalenderEmailRecipient);
                Rec.Insert();
            until CalenderEmailRecipient.Next() = 0;

    end;

    /// <summary>
    /// GetSelectedSuggestionsAsText.
    /// </summary>
    /// <param name="CalenderEmailRecipient">VAR Record "Calender Email Recipient_EVAS".</param>
    /// <returns>Return value of type Text.</returns>
    internal procedure GetSelectedSuggestionsAsText(var CalenderEmailRecipient: Record "Calender Email Recipient_EVAS"): Text
    var
        Recipients: Text;
    begin
        if CalenderEmailRecipient.FindSet() then
            repeat
                Recipients += CalenderEmailRecipient."E-Mail Address" + ';';
            until CalenderEmailRecipient.Next() = 0;
        exit(Recipients);
    end;
}
