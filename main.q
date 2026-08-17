getFactors:{[x]
    d: 1 + til `long$floor sqrt x;
    lo: d where 0 = x mod d;
    hi: x div lo;
    res: lo, hi;
    res: asc distinct res;
    h: floor x % 2;
    res where res <= h
    };

/
11-22 still has two invalid IDs, 11 and 22.
95-115 now has two invalid IDs, 99 and 111.
998-1012 now has two invalid IDs, 999 and 1010.
1188511880-1188511890 still has one invalid ID, 1188511885.
222220-222224 still has one invalid ID, 222222.
1698522-1698528 still contains no invalid IDs.
446443-446449 still has one invalid ID, 446446.
38593856-38593862 still has one invalid ID, 38593859.
565653-565659 now has one invalid ID, 565656.
824824821-824824827 now has one invalid ID, 824824824.
2121212118-2121212124 now has one invalid ID, 2121212121.
\ 

r: 0 0;
do[1; r: r + .Q.ts[{[]
    raw: first read0 `$":day-2-inputs.txt";
    ranges: "," vs raw;
    expandRange:{[r] nums:"J"$"-"vs r;:nums[0] + til(1+nums[1]-nums[0])};
    flattenedList: raze expandRange each ranges;
    flattenedList: string each flattenedList;
    checkIfEqual:{[x]
        // show "###"
        n: count x;
        factors: getFactors[n];
        possiblerepeats: {[x;factor] factor#x}[x;] each factors;
        multfactorforpossiblerepeats: {[n;factor] n div factor}[n;] each factors;
        // show x;
        // show possiblerepeats;
        // show multfactorforpossiblerepeats;
        possibilities: n#'possiblerepeats;
        // show possibilities;
        // show "x = ", x;
        // need to do this to avoid using in operator on empty list error
        if[(count possibilities) = 0; possibilities:: ("hi";"bye")];
        // show "possibilities = ", possibilities;
        // show type x;
        // show type possibilities;
        // show "###";
        if[((count possibilities )> 0) & (x in possibilities); :"J"$x];
        :0b
        };
    res: sum checkIfEqual each flattenedList;
    show res;
    :res
    }; enlist[::]]]

timeTakenInSeconds: r[0][0]%1000;
spaceTakenInMb: r[0][1]%(1024*1024);
show timeTakenInSeconds, spaceTakenInMb;
