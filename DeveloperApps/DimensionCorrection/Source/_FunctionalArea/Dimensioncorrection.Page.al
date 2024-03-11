/// <summary>
/// Page Dimesion correction_EVAS (ID 67902).
/// </summary>
page 98200 "Dimension correction_EVAS"
{
    ApplicationArea = All;
    Caption = 'Dimesion correction';
    PageType = List;
    SourceTable = "Dimension Set Entry";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Dimension Name"; Rec."Dimension Name")
                {
                    ToolTip = 'Specifies the descriptive name of the Dimension Code field.';
                }
                field("Dimension Code"; TempDimensionSetEntry."Dimension Code")
                {
                    ToolTip = 'Specifies the code of the dimension.';
                    trigger OnValidate()
                    begin
                        if xTempDimensionSetEntry."Dimension Code" <> TempDimensionSetEntry."Dimension Code" then
                            TempDimensionSetEntry.Modify();
                    end;
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ToolTip = 'Specifies the value of the Dimension Set ID field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(UpdateDim)
            {
                ApplicationArea = all;
                Caption = 'Update Dimensions';
                Image = UpdateDescription;
                trigger OnAction()
                begin

                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.SetRange("Dimension Set ID", DimSetID);
        CopyDimensions(Rec, xTempDimensionSetEntry);
        CopyDimensions(Rec, TempDimensionSetEntry);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        TempDimensionSetEntry.Get(Rec."Dimension Set ID", Rec."Dimension Code");
        xTempDimensionSetEntry.Get(Rec."Dimension Set ID", Rec."Dimension Code");

    end;

    trigger OnAfterGetRecord()
    begin
        TempDimensionSetEntry.Get(Rec."Dimension Set ID", Rec."Dimension Code");
        xTempDimensionSetEntry.Get(Rec."Dimension Set ID", Rec."Dimension Code")
    end;

    var
        xTempDimensionSetEntry: Record "Dimension Set Entry" temporary;
        TempDimensionSetEntry: Record "Dimension Set Entry" temporary;
        DimSetID: Integer;

    internal procedure SetDimensionSet(NewDimSetID: Integer)
    begin
        DimSetID := NewDimSetID;
    end;

    internal procedure GetDimensionCorrection(var TempDimensionSetEntryOld: Record "Dimension Set Entry" temporary; TempDimensionSetEntryNew: Record "Dimension Set Entry" temporary)
    begin
        TempDimensionSetEntryOld.Copy(xTempDimensionSetEntry);
        TempDimensionSetEntryNew.Copy(TempDimensionSetEntry);
    end;

    local procedure CopyDimensions(DimensionSetEntry: Record "Dimension Set Entry"; var NewTempDimensionSetEntry: Record "Dimension Set Entry" temporary)
    begin
        if DimensionSetEntry.FindSet() then
            repeat
                NewTempDimensionSetEntry := DimensionSetEntry;
                NewTempDimensionSetEntry.Insert();
            until DimensionSetEntry.Next() = 0;

    end;
}
