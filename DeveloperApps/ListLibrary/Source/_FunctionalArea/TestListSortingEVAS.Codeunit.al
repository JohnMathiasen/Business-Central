codeunit 50549 "Test List Sorting_EVAS"
{
    trigger OnRun()
    begin
        TestSelectionSortofInteger();
        TestSelectionSortofDecimal();
        TestSelectionSortofText();
        TestSelectionSortofDate();
        TestSelectionSortofTime();
        TestSelectionSortofDateTime();

        TestbubbleSortofInt();
        TestbubbleSortofDecimal();
        TestBubbleSortofTime();
        TestbubbleSortofText();
        TestBubbleSortofDate();
        TestBubbleSortofDateTime();

        TestMergeSortofinteger();
        TestMergeSortofDecimal();
        TestMergeSortofText();
        TestMergeSortofDate();
        TestMergeSortofTime();
        TestMergeSortofDateTime();

        TestQuickSortofInteger();
        TestQuickSortofDecimal();
        TestQuickSortofText();
        TestQuickSortofTime();
        TestQuickSortofDate();
        TestQuickSortofDateTime();

        TestSearchListofInteger();
        TestSearchListofDecimal();
        TestSearchListofText();
        TestSearchListofDate();
        TestSearchListofTime();
        TestSearchListofDateTime();
    end;

    var
        SortSearchList: Codeunit "Sort/Search List_EVAS";

    local procedure TestSelectionSortofInteger()
    var
        IntegerList: List of [Integer];
    begin
        IntegerList := CreateTestListofinteger();
        SortSearchList.Sort(IntegerList, Enum::"Sorting Method"::Selection);
    end;

    local procedure TestSelectionSortofDecimal()
    var
        DecimalList: List of [Decimal];
    begin
        DecimalList := CreateTestListofDecimal();
        SortSearchList.Sort(DecimalList, Enum::"Sorting Method"::Selection);
    end;

    local procedure TestSelectionSortofText()
    var
        TextList: List of [Text];
    begin
        TextList := CreateTestListofText();
        SortSearchList.Sort(TextList, Enum::"Sorting Method"::Selection);
    end;

    local procedure TestSelectionSortofDateTime()
    var
        DTList: List of [DateTime];
    begin
        DTList := CreateTestListofDateTime();
        SortSearchList.Sort(DTList, Enum::"Sorting Method"::Selection);
    end;

    local procedure TestSelectionSortofDate()
    var
        DList: List of [Date];
    begin
        DList := CreateTestListofDate();
        SortSearchList.Sort(DList, Enum::"Sorting Method"::Selection);
    end;

    local procedure TestSelectionSortofTime()
    var
        TList: List of [Time];
    begin
        TList := CreateTestListofTime();
        SortSearchList.Sort(TList, Enum::"Sorting Method"::Selection);
    end;

    local procedure TestbubbleSortofInt()
    var
        IntegerList: List of [Integer];
    begin
        IntegerList := CreateTestListofinteger();
        SortSearchList.Sort(IntegerList, Enum::"Sorting Method"::Bubble);
    end;

    local procedure TestbubbleSortofDecimal()
    var
        DecimalList: List of [Decimal];
    begin
        DecimalList := CreateTestListofDecimal();
        SortSearchList.Sort(DecimalList, Enum::"Sorting Method"::Bubble);
    end;

    local procedure TestbubbleSortofText()
    var
        TextList: List of [Text];
    begin
        TextList := CreateTestListofText();
        SortSearchList.Sort(TextList, Enum::"Sorting Method"::Bubble);
    end;

    local procedure TestBubbleSortofDate()
    var
        DList: List of [Date];
    begin
        DList := CreateTestListofDate();
        SortSearchList.Sort(DList, Enum::"Sorting Method"::Bubble);
    end;

    local procedure TestBubbleSortofTime()
    var
        TList: List of [Time];
    begin
        TList := CreateTestListofTime();
        SortSearchList.Sort(TList, Enum::"Sorting Method"::Bubble);
    end;

    local procedure TestBubbleSortofDateTime()
    var
        DTList: List of [DateTime];
    begin
        DTList := CreateTestListofDateTime();
        SortSearchList.Sort(DTList, Enum::"Sorting Method"::Bubble);
    end;

    local procedure TestMergeSortofinteger()
    var
        IntegerList: List of [Integer];
    begin
        IntegerList := CreateTestListofinteger();
        SortSearchList.Sort(IntegerList, Enum::"Sorting Method"::Merge);
    end;

    local procedure TestMergeSortofDecimal()
    var
        DecimalList: List of [Decimal];
    begin
        DecimalList := CreateTestListofDecimal();
        SortSearchList.Sort(DecimalList, Enum::"Sorting Method"::Merge);
    end;

    local procedure TestMergeSortofText()
    var
        TextList: List of [Text];
    begin
        TextList := CreateTestListofText();
        SortSearchList.Sort(TextList, Enum::"Sorting Method"::Merge);
    end;

    local procedure TestMergeSortofDate()
    var
        DList: List of [Date];
    begin
        DList := CreateTestListofDate();
        SortSearchList.Sort(DList, Enum::"Sorting Method"::Merge);
    end;

    local procedure TestMergeSortofTime()
    var
        TList: List of [Time];
    begin
        TList := CreateTestListofTime();
        SortSearchList.Sort(TList, Enum::"Sorting Method"::Merge);
    end;

    local procedure TestMergeSortofDateTime()
    var
        DTList: List of [DateTime];
    begin
        DTList := CreateTestListofDateTime();
        SortSearchList.Sort(DTList, Enum::"Sorting Method"::Merge);
    end;

    local procedure TestQuickSortofInteger()
    var
        IntegerList: List of [Integer];
    begin
        IntegerList := CreateTestListofinteger();
        SortSearchList.Sort(IntegerList, Enum::"Sorting Method"::Quick);
    end;

    local procedure TestQuickSortofDecimal()
    var
        DecimalList: List of [Decimal];
    begin
        DecimalList := CreateTestListofDecimal();
        SortSearchList.Sort(DecimalList, Enum::"Sorting Method"::Quick);
    end;

    local procedure TestQuickSortofText()
    var
        TextList: List of [Text];
    begin
        TextList := CreateTestListofText();
        SortSearchList.Sort(TextList, Enum::"Sorting Method"::Quick);
    end;

    local procedure TestQuickSortofDate()
    var
        DList: List of [Date];
    begin
        DList := CreateTestListofDate();
        SortSearchList.Sort(DList, Enum::"Sorting Method"::Quick);
    end;

    local procedure TestQuickSortofTime()
    var
        TList: List of [Time];
    begin
        TList := CreateTestListofTime();
        SortSearchList.Sort(TList, Enum::"Sorting Method"::Quick);
    end;

    local procedure TestQuickSortofDateTime()
    var
        DTList: List of [DateTime];
    begin
        DTList := CreateTestListofDateTime();
        SortSearchList.Sort(DTList, Enum::"Sorting Method"::Quick);
    end;

    local procedure TestSearchListofInteger()
    var
        IntegerList: List of [Integer];
    begin
        IntegerList := CreateTestListofinteger();
        SortSearchList.Sort(IntegerList, Enum::"Sorting Method"::Merge);
        SortSearchList.Search(IntegerList, 9, Enum::"Search Method"::Binary);
    end;

    local procedure TestSearchListofDecimal()
    var
        DecimalList: List of [Decimal];
    begin
        DecimalList := CreateTestListofDecimal();
        SortSearchList.Sort(DecimalList, Enum::"Sorting Method"::Merge);
        SortSearchList.Search(DecimalList, 8.343, Enum::"Search Method"::Binary);
    end;

    local procedure TestSearchListofText()
    var
        TextList: List of [Text];
    begin
        TextList := CreateTestListofText();
        SortSearchList.Sort(TextList, Enum::"Sorting Method"::Merge);
        SortSearchList.Search(TextList, 'Carrot', Enum::"Search Method"::Binary);
    end;

    local procedure TestSearchListofDate()
    var
        DList: List of [Date];
    begin
        DList := CreateTestListofDate();
        SortSearchList.Sort(DList, Enum::"Sorting Method"::Merge);
        SortSearchList.Search(DList, 20150101D, Enum::"Search Method"::Binary);
    end;

    local procedure TestSearchListofTime()
    var
        TList: List of [Time];
    begin
        TList := CreateTestListofTime();
        SortSearchList.Sort(TList, Enum::"Sorting Method"::Merge);
        SortSearchList.Search(TList, 003100T, Enum::"Search Method"::Binary);
    end;

    local procedure TestSearchListofDateTime()
    var
        DTList: List of [DateTime];
    begin
        DTList := CreateTestListofDateTime();
        SortSearchList.Sort(DTList, Enum::"Sorting Method"::Merge);
        SortSearchList.Search(DTList, CreateDateTime(20220519D, 210443T), Enum::"Search Method"::Binary);
    end;

    local procedure CreateTestListofinteger(): List of [Integer]
    var
        IntegerList: List of [Integer];
    begin
        IntegerList.Add(4);
        IntegerList.Add(7);
        IntegerList.Add(1);
        IntegerList.Add(8);
        IntegerList.Add(2);
        IntegerList.Add(3);
        IntegerList.Add(9);
        IntegerList.Add(6);
        IntegerList.Add(5);
        exit(IntegerList);
    end;

    local procedure CreateTestListofDecimal(): List of [Decimal]
    var
        DecimalList: List of [Decimal];
    begin
        DecimalList.Add(4.34);
        DecimalList.Add(4.02);
        DecimalList.Add(100.34);
        DecimalList.Add(8.343);
        DecimalList.Add(124.55);
        DecimalList.Add(33.21);
        DecimalList.Add(9000.23);
        DecimalList.Add(164.32);
        DecimalList.Add(0.544312);
        exit(DecimalList);
    end;

    local procedure CreateTestListofText(): List of [Text]
    var
        TextList: List of [Text];
    begin
        TextList.Add('Zebra');
        TextList.Add('Apple');
        TextList.Add('Frog');
        TextList.Add('Dog');
        TextList.Add('Elephant');
        TextList.Add('Giraffe');
        TextList.Add('Horse');
        TextList.Add('Carrot');
        TextList.Add('Banana');
        exit(TextList);
    end;

    local procedure CreateTestListofDate(): List of [Date]
    var
        DTList: List of [Date];
    begin
        DTList.Add(20231203D);
        DTList.Add(20230223D);
        DTList.Add(20241012D);
        DTList.Add(20180424D);
        DTList.Add(20210804D);
        DTList.Add(20220519D);
        DTList.Add(20241206D);
        DTList.Add(20231203D);
        DTList.Add(20150101D);
        exit(DTList);
    end;

    local procedure CreateTestListofTime(): List of [Time]
    var
        DTList: List of [Time];
    begin
        DTList.Add(113423T);
        DTList.Add(100413T);
        DTList.Add(011403T);
        DTList.Add(073009T);
        DTList.Add(183128T);
        DTList.Add(210443T);
        DTList.Add(063548T);
        DTList.Add(103433T);
        DTList.Add(003100T);
        exit(DTList);
    end;

    local procedure CreateTestListofDateTime(): List of [DateTime]
    var
        DTList: List of [DateTime];
    begin
        DTList.Add(CreateDateTime(20231203D, 113423T));
        DTList.Add(CreateDateTime(20230223D, 100413T));
        DTList.Add(CreateDateTime(20241012D, 011403T));
        DTList.Add(CreateDateTime(20230424D, 073009T));
        DTList.Add(CreateDateTime(20210804D, 183128T));
        DTList.Add(CreateDateTime(20220519D, 210443T));
        DTList.Add(CreateDateTime(20241206D, 063548T));
        DTList.Add(CreateDateTime(20231203D, 103433T));
        DTList.Add(CreateDateTime(20240101D, 003100T));
        exit(DTList);
    end;
}
