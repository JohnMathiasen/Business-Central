codeunit 50502 "Sort List of Text_EVAS"
{
    /// <summary>
    /// Bubble sort is a simple sorting algorithm that repeatedly steps through the list, compares adjacent elements and swaps them if they are in the wrong order.
    /// </summary>
    /// <param name="List"></param>
    internal procedure BubbleSort(var List: List of [Text])
    var
        Swapped: Boolean;
        i: Integer;
    begin
        if List.Count < 2 then
            exit;

        repeat
            Swapped := false;

            for i := 1 to List.Count - 1 do
                if List.Get(i) > List.Get(i + 1) then begin
                    MoveElement(List, i, i + 1);
                    Swapped := true;
                end;
        until not Swapped;
    end;

    /// <summary>
    /// Selection sort is an in-place comparison sorting algorithm that divides the input list into two parts: the sublist of items already sorted and the sublist of items remaining to be sorted.
    /// </summary>
    /// <param name="List"></param>
    internal procedure SelectionSort(var List: List of [Text])
    var
        MinIndex, i, j : Integer;
    begin
        if List.Count < 2 then
            exit;
        for i := 1 to List.Count - 1 do begin
            // Assume the current position holds
            // the minimum element
            MinIndex := i;

            // Iterate through the unsorted portion
            // to find the actual minimum          
            for j := i + 1 to List.Count do
                // Update min_idx if a smaller element is found
                if List.Get(j) < List.Get(MinIndex) then
                    MinIndex := j;

            // Move minimum element to its
            // correct position
            MoveElement(List, MinIndex, i);
        end;
    end;

    /// <summary>
    /// QuickSort is a divide-and-conquer algorithm. It works by selecting a 'pivot' element from the array and partitioning the other elements into two sub-arrays according to whether they are less than or greater than the pivot.
    /// </summary>
    /// <param name="List"></param>
    internal procedure QuickSort(var List: List of [Text])
    begin
        QuickSort(List, 1, List.Count);
    end;

    local procedure QuickSort(var List: List of [Text]; low: Integer; high: Integer)
    pi: Integer;
    begin
        if low < high then begin
            pi := partition(List, low, high);

            QuickSort(List, low, pi - 1);
            QuickSort(List, pi + 1, high);
        end;
    end;

    local procedure partition(var List: List of [Text]; low: Integer; high: Integer): Integer
    var
        pivot: Text;
        i, j : Integer;
    begin
        pivot := List.Get(high);
        i := low - 1;

        for j := low to high do
            //if Text < Pivot then begin
            if List.Get(j) < Pivot then begin
                i := i + 1;
                SwapElement(List, i, j);
            end;

        SwapElement(List, i + 1, high);
        exit(i + 1);
    end;

    /// <summary>
    /// MergeSort is a divide-and-conquer algorithm that divides the input list into two halves, calls itself for the two halves, and then merges the two sorted halves.
    /// </summary>
    /// <param name="List"></param>
    internal procedure mergeSort(var List: List of [Text])
    var
        i, j, k, n1, n2, Left, mid, right : Integer;
        LList, RList : List of [Text];
    begin
        if List.Count > 1 then begin
            // Create LList ← List[p..q] and RList ← List[q+1..r]
            Left := 1;
            right := List.Count;
            mid := (Left + right) div 2;
            n1 := mid - Left + 1;
            n2 := right - mid;

            for i := 1 to n1 do
                LList.Add(List.Get(Left + i - 1));
            for j := 1 to n2 do
                RList.Add(List.Get(mid + j));

            // Sort the two halves
            mergeSort(LList);
            mergeSort(RList);

            // Maintain current index of sub-arrays and main array
            i := 1;
            j := 1;
            k := Left;

            // Until we reach either end of either LKist or RList, pick larger among
            // elements LList and RList and place them in the correct position at List[p..r]
            while (i <= n1) and (j <= n2) do begin
                if LList.Get(i) <= RList.Get(j) then begin
                    List.Set(k, LList.Get(i));
                    i := i + 1;
                end else begin
                    List.Set(k, RList.Get(j));
                    j := j + 1;
                end;
                k := k + 1;
            end;

            // When we run out of elements in either LList or MList,
            // pick up the remaining elements and put in List[p..r]
            while i <= n1 do begin
                List.Set(k, LList.Get(i));
                i := i + 1;
                k := k + 1;
            end;

            while j <= n2 do begin
                List.Set(k, RList.Get(j));
                j := j + 1;
                k := k + 1;
            end;
        end;
    end;

    local procedure SwapElement(var List: List of [Text]; Index1: Integer; Index2: Integer)
    var
        Text, Text2 : Text;
        Low, High, LastIndex : Integer;
    begin
        if Index1 = Index2 then
            exit;

        LastIndex := List.Count;

        if Index1 > Index2 then begin
            Low := Index2;
            High := Index1;
        end else begin
            Low := Index1;
            High := Index2;
        end;

        List.Get(Low, Text);
        List.Get(High, Text2);
        if High = LastIndex then
            List.Add(Text)
        else
            List.Insert(High + 1, Text);
        List.RemoveAt(High);
        List.Insert(Low + 1, Text2);
        List.RemoveAt(Low);
    end;

    local procedure MoveElement(var List: List of [Text]; FromIndex: Integer; ToIndex: Integer)
    var
        Text: Text;
    begin
        if FromIndex = ToIndex then
            exit;
        List.Get(FromIndex, Text);
        List.RemoveAt(FromIndex);
        List.Insert(ToIndex, Text);
    end;
}
