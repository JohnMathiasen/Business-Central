codeunit 50500 "Sort/Search List_EVAS"
{
    /// <summary>
    /// Sort a list of integer values using the specified sorting method.
    /// </summary>
    /// <param name="List"></param>
    /// <param name="SortingMethod"></param>
    procedure Sort(var List: List of [Integer]; SortingMethod: Enum "Sorting Method")
    var
        SortListofIntDec: Codeunit "Sort List of Int/Dec_EVAS";
    begin
        case SortingMethod of
            SortingMethod::Selection:
                SortListofIntDec.SelectionSort(List);
            SortingMethod::Bubble:
                SortListofIntDec.BubbleSort(List);
            SortingMethod::Merge:
                SortListofIntDec.mergeSort(List);
            SortingMethod::Quick:
                SortListofIntDec.QuickSort(List);
        end;
    end;

    /// <summary>
    /// Sort a list of decimal values using the specified sorting method.
    /// </summary>
    /// <param name="List"></param>
    /// <param name="SortingMethod"></param>
    procedure Sort(var List: List of [Decimal]; SortingMethod: Enum "Sorting Method")
    var
        SortListofIntDec: Codeunit "Sort List of Int/Dec_EVAS";
    begin
        case SortingMethod of
            SortingMethod::Selection:
                SortListofIntDec.SelectionSort(List);
            SortingMethod::Bubble:
                SortListofIntDec.BubbleSort(List);
            SortingMethod::Merge:
                SortListofIntDec.mergeSort(List);
            SortingMethod::Quick:
                SortListofIntDec.QuickSort(List);
        end;
    end;

    /// <summary>
    /// Sort a list of text values using the specified sorting method.
    /// </summary>
    /// <param name="List"></param>
    /// <param name="SortingMethod"></param>
    procedure Sort(var List: List of [Text]; SortingMethod: Enum "Sorting Method")
    var
        SortListofText: Codeunit "Sort List of Text_EVAS";
    begin
        case SortingMethod of
            SortingMethod::Selection:
                SortListofText.SelectionSort(List);
            SortingMethod::Bubble:
                SortListofText.BubbleSort(List);
            SortingMethod::Merge:
                SortListofText.mergeSort(List);
            SortingMethod::Quick:
                SortListofText.QuickSort(List);
        end;
    end;

    /// <summary>
    /// Sort a list of DateTime values using the specified sorting method.
    /// </summary>
    /// <param name="List"></param>
    /// <param name="SortingMethod"></param>
    procedure Sort(var List: List of [DateTime]; SortingMethod: Enum "Sorting Method")
    var
        SortListofDateTime: Codeunit SortListofDateTime_EVAS;
    begin
        case SortingMethod of
            SortingMethod::Selection:
                SortListofDateTime.SelectionSort(List);
            SortingMethod::Bubble:
                SortListofDateTime.BubbleSort(List);
            SortingMethod::Merge:
                SortListofDateTime.mergeSort(List);
            SortingMethod::Quick:
                SortListofDateTime.QuickSort(List);
        end;
    end;

    /// <summary>
    /// Sort a list of Date values using the specified sorting method.
    /// </summary>
    /// <param name="List"></param>
    /// <param name="SortingMethod"></param>
    procedure Sort(var List: List of [Date]; SortingMethod: Enum "Sorting Method")
    var
        SortListofDateTime: Codeunit SortListofDateTime_EVAS;
    begin
        case SortingMethod of
            SortingMethod::Selection:
                SortListofDateTime.SelectionSort(List);
            SortingMethod::Bubble:
                SortListofDateTime.BubbleSort(List);
            SortingMethod::Merge:
                SortListofDateTime.mergeSort(List);
            SortingMethod::Quick:
                SortListofDateTime.QuickSort(List);
        end;
    end;

    /// <summary>
    /// Sort a list of Time values using the specified sorting method.
    /// </summary>
    /// <param name="List"></param>
    /// <param name="SortingMethod"></param>
    procedure Sort(var List: List of [Time]; SortingMethod: Enum "Sorting Method")
    var
        SortListofDateTime: Codeunit SortListofDateTime_EVAS;
    begin
        case SortingMethod of
            SortingMethod::Selection:
                SortListofDateTime.SelectionSort(List);
            SortingMethod::Bubble:
                SortListofDateTime.BubbleSort(List);
            SortingMethod::Merge:
                SortListofDateTime.mergeSort(List);
            SortingMethod::Quick:
                SortListofDateTime.QuickSort(List);
        end;
    end;

    /// <summary>
    /// Search for a value in a sorted list of integers using the specified search method.
    /// </summary>
    /// <param name="List"></param>
    /// <param name="SearchValue"></param>
    /// <param name="SearchMethod"></param>
    /// <returns></returns>
    procedure Search(var List: List of [Integer]; SearchValue: Integer; SearchMethod: Enum "Search Method"): Integer
    var
        SortListofIntDec: Codeunit "Sort List of Int/Dec_EVAS";
    begin
        case SearchMethod of
            SearchMethod::Linear:
                exit(SortListofIntDec.LinearSearch(List, SearchValue));
            SearchMethod::Binary:
                exit(SortListofIntDec.BinarySearch(List, SearchValue));
        end;
    end;

    /// <summary>
    /// Search for a value in a sorted list of decimals using the specified search method.
    /// </summary>
    /// <param name="List"></param>
    /// <param name="SearchValue"></param>
    /// <param name="SearchMethod"></param>
    /// <returns></returns>
    procedure Search(var List: List of [Decimal]; SearchValue: Decimal; SearchMethod: Enum "Search Method"): Integer
    var
        SortListofIntDec: Codeunit "Sort List of Int/Dec_EVAS";
    begin
        case SearchMethod of
            SearchMethod::Linear:
                exit(SortListofIntDec.LinearSearch(List, SearchValue));
            SearchMethod::Binary:
                exit(SortListofIntDec.BinarySearch(List, SearchValue));
        end;
    end;

    /// <summary>
    /// Search for a value in a sorted list of texts using the specified search method.
    /// </summary>
    /// <param name="List"></param>
    /// <param name="SearchValue"></param>
    /// <param name="SearchMethod"></param>
    /// <returns></returns>
    procedure Search(var List: List of [Text]; SearchValue: Text; SearchMethod: Enum "Search Method"): Integer
    var
        SortListofText: Codeunit "Sort List of Text_EVAS";
    begin
        case SearchMethod of
            SearchMethod::Linear:
                exit(SortListofText.LinearSearch(List, SearchValue));
            SearchMethod::Binary:
                exit(SortListofText.BinarySearch(List, SearchValue));
        end;
    end;

    /// <summary>
    /// Search for a value in a sorted list of Date values using the specified search method.
    /// </summary>
    /// <param name="List"></param>
    /// <param name="SearchValue"></param>
    /// <param name="SearchMethod"></param>
    /// <returns></returns>
    procedure Search(var List: List of [Date]; SearchValue: Date; SearchMethod: Enum "Search Method"): Integer
    var
        SortListofDateTime: Codeunit SortListofDateTime_EVAS;
    begin
        case SearchMethod of
            SearchMethod::Linear:
                exit(SortListofDateTime.LinearSearch(List, SearchValue));
            SearchMethod::Binary:
                exit(SortListofDateTime.BinarySearch(List, SearchValue));
        end;
    end;

    /// <summary>
    /// Search for a value in a sorted list of Time values using the specified search method.
    /// </summary>
    /// <param name="List"></param>
    /// <param name="SearchValue"></param>
    /// <param name="SearchMethod"></param>
    /// <returns></returns>
    procedure Search(var List: List of [Time]; SearchValue: Time; SearchMethod: Enum "Search Method"): Integer
    var
        SortListofDateTime: Codeunit SortListofDateTime_EVAS;
    begin
        case SearchMethod of
            SearchMethod::Linear:
                exit(SortListofDateTime.LinearSearch(List, SearchValue));
            SearchMethod::Binary:
                exit(SortListofDateTime.BinarySearch(List, SearchValue));
        end;
    end;

    /// <summary>
    /// Search for a value in a sorted list of DateTime values using the specified search method.
    /// </summary>
    /// <param name="List"></param>
    /// <param name="SearchValue"></param>
    /// <param name="SearchMethod"></param>
    /// <returns></returns>
    procedure Search(var List: List of [DateTime]; SearchValue: DateTime; SearchMethod: Enum "Search Method"): Integer
    var
        SortListofDateTime: Codeunit SortListofDateTime_EVAS;
    begin
        case SearchMethod of
            SearchMethod::Linear:
                exit(SortListofDateTime.LinearSearch(List, SearchValue));
            SearchMethod::Binary:
                exit(SortListofDateTime.BinarySearch(List, SearchValue));
        end;
    end;

    /// <summary>
    /// Rabin-Karp - Search for a pattern in a text using the hash Calculation
    /// </summary>
    /// <param name="Pattern"></param>
    /// <param name="String"></param>
    /// <param name="q"></param>
    /// <returns></returns>
    procedure Search(Pattern: Text; String: Text; q: Integer): List of [Integer]
    var
        m, d, n, p, t, i, j : Integer;
        PatternIndexList: List of [Integer];
    begin
        m := StrLen(Pattern);
        n := StrLen(String);
        p := 0;
        t := 0;
        i := 0;
        j := 0;
        d := 10;

        //Calculate hash value for pattern and text
        p := CalcHash(Pattern, m, d);
        t := CalcHash(copystr(String, 1, m), m, d);


        // Find the match
        for i := 1 to n - m + 1 do begin
            if p = t then begin
                for j := 1 to m do
                    if GetNumber(String, i + j - 1) <> GetNumber(Pattern, j) then
                        break;

                if j = m then
                    PatternIndexList.Add(i);
            end;

            if i < n - m + 1 then
                t := CalcHash(CopyStr(String, i + 1, m), m, d);
        end;

        exit(PatternIndexList);
    end;


    procedure CalcHash(Text: Text; PatternLegth: Integer; d: Integer): Integer
    var
        q, t, i : Integer;
    begin
        q := 13;
        for i := 1 to PatternLegth do
            t := (d * t + GetNumber(Text, i)) mod q;
        exit(t);
    end;

    procedure GetNumber(Text: Text; i: Integer): Integer
    var
        c: Char;
    begin
        c := Text[i];
        exit(c);
    end;
}
