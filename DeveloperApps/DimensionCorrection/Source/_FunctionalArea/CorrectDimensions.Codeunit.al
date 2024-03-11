/// <summary>
/// Codeunit Correct Dimensions_EVAS (ID 67903).
/// </summary>
codeunit 98200 "Correct Dimensions_EVAS"
{

    var
        TempxDimensionSetEntry: Record "Dimension Set Entry" temporary;
        TempDimensionSetEntry: Record "Dimension Set Entry" temporary;
        RecRef: RecordRef;

    internal procedure ShowDimensions(VariantRecord: Variant)
    var
        DimensioncorrectionEVAS: Page "Dimension correction_EVAS";
    begin
        SetActualRecord(VariantRecord);
        DimensioncorrectionEVAS.SetDimensionSet(GetDimSetID(RecRef));
        DimensioncorrectionEVAS.RunModal();
        DimensioncorrectionEVAS.GetDimensionCorrection(TempxDimensionSetEntry, TempDimensionSetEntry);

        if DimensionsChange() then
            UpdateDimensions(TempxDimensionSetEntry."Dimension Set ID");
    end;

    local procedure DimensionsChange(): Boolean
    var
        ValueChanged: Boolean;
    begin
        if TempxDimensionSetEntry.FindSet() then
            repeat
                if not TempDimensionSetEntry.Get(TempxDimensionSetEntry."Dimension Set ID", TempxDimensionSetEntry."Dimension Code") then
                    ValueChanged := true;
                ValueChanged := TempxDimensionSetEntry."Dimension Value Code" <> TempDimensionSetEntry."Dimension Value Code";
            until (TempxDimensionSetEntry.Next() = 0) or ValueChanged;

        if TempDimensionSetEntry.FindSet() then
            repeat
                if not TempxDimensionSetEntry.Get(TempDimensionSetEntry."Dimension Set ID", TempDimensionSetEntry."Dimension Code") then
                    ValueChanged := true;
            until (TempDimensionSetEntry.Next() = 0) or ValueChanged;
        exit(ValueChanged);
    end;

    local procedure UpdateDimensions(DimSetID: Integer)
    var
        DimensionManagement: Codeunit DimensionManagement;
        FieldRef: FieldRef;
        FieldNo: Integer;
        NewDimSetID: Integer;
        ListOfDimFields: List of [Integer];
        ListOfDimSetFields: List of [Integer];
    begin
        ListOfDimFields := FindFieldsRelatedToTable(RecRef.Number, Database::"Dimension Value");
        foreach FieldNo in ListOfDimFields do begin
            FieldRef := RecRef.Field(FieldNo);
            if FieldRef.Name.Contains('1') then begin
                if TempDimensionSetEntry.Get(DimSetID, GetGlobalDimCode(1)) then
                    UpdateField(FieldRef.Number, TempDimensionSetEntry."Dimension Value Code");
            end else
                if TempDimensionSetEntry.Get(DimSetID, GetGlobalDimCode(2)) then
                    UpdateField(FieldRef.Number, TempDimensionSetEntry."Dimension Value Code");
        end;

        NewDimSetID := DimensionManagement.GetDimensionSetID(TempDimensionSetEntry);

        ListOfDimSetFields := FindFieldsRelatedToTable(RecRef.Number, Database::"Dimension Set Entry");
        foreach FieldNo in ListOfDimSetFields do begin
            FieldRef := RecRef.Field(FieldNo);
            UpdateField(FieldRef.Number, format(NewDimSetID));
        end;
    end;

    local Procedure GetGlobalDimCode(Number: Integer): Code[20]
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        Case Number of
            1:
                exit(GeneralLedgerSetup."Global Dimension 1 Code");
            2:
                exit(GeneralLedgerSetup."Global Dimension 2 Code");
        end;
    end;

    local Procedure UpdateField(FieldNo: Integer; Value: Text)
    var
        FieldRef: FieldRef;
        ValueCode: Code[20];
        ValueInteger: Integer;
    begin
        FieldRef := RecRef.Field(FieldNo);
        case FieldRef.Type of
            FieldRef.Type::Code:
                begin
                    Evaluate(ValueCode, Value);
                    FieldRef.Value := ValueCode;
                end;
            FieldRef.Type::Integer:
                begin
                    Evaluate(ValueInteger, Value);
                    FieldRef.Value := ValueInteger;
                end;
        end;
    end;

    internal procedure FindFieldsRelatedToTable(TableId: Integer; RelatedTableID: Integer) ListOfDimFields: List of [Integer]
    var
        RecRef2: RecordRef;
        FieldRef: FieldRef;
        I: Integer;
        RelatedTable: Integer;
    begin
        RecRef2.Open(TableId);
        for I := 1 to RecRef2.FieldCount do begin
            FieldRef := RecRef2.FieldIndex(I);
            RelatedTable := FieldRef.Relation;
            if RelatedTable = RelatedTableID then
                ListOfDimFields.Add(FieldRef.Number);
        end;
    end;

    internal procedure SetActualRecord(VariantRecord: Variant)
    var
        DataTypeManagement: Codeunit "Data Type Management";
    begin
        DataTypeManagement.GetRecordRef(VariantRecord, RecRef);
    end;

    local procedure GetDimSetID(RecRef: RecordRef) DimSetID: Integer
    var
        FieldRef: FieldRef;
        ListOfDimSetFields: List of [Integer];
    begin
        ListOfDimSetFields := FindFieldsRelatedToTable(RecRef.Number, Database::"Dimension Set Entry");
        if ListOfDimSetFields.Count = 0 then
            Error('Table doesn´t contáin dimensions');

        FieldRef := RecRef.Field(ListOfDimSetFields.Get(1));
        evaluate(DimSetID, FieldRef.Value);
        exit(DimSetID);
    end;

}
