r: 0 0;
do[10; r: r + .Q.ts[{[]
    raw: first read0 `$":day-2-inputs.txt";
    ranges: "," vs raw;
    expandRange:{[r] nums:"J"$"-"vs r;:nums[0] + til(1+nums[1]-nums[0])};
    flattenedList: raze expandRange each ranges;
    flattenedList: string each flattenedList;
    checkIfEqual:{[x]
        n: count x;
        h: n div 2;
        fh: h#x;
        sh: h _ x;
        xLong: "J"$x;
        if[fh~sh; :xLong];
        :0b
        };
    sum checkIfEqual each flattenedList
    }; enlist[::]]]

timeTakenInSeconds: r[0][0]%1000;
spaceTakenInMb: r[0][1]%(1024*1024);

show timeTakenInSeconds, spaceTakenInMb;