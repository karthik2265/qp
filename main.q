inputs: read0 `$":day-3-inputs.txt";
getPower:{[accumulatedPower; x]
/
        We need to find a 12-digit number by repeatedly finding the maximum digit
        within a valid range. After selecting a digit, the left boundary moves to
        the index immediately after the selected digit.

        Example:
        Input = "289337136173502378292"  (length = 21)

        prevous index = -1
        find left pointer by incrementing previous index by plus one.
        find right pointer by count digits - (digits needed (12) - current count of digits in res)
        repeat this till res is count of digits needed.

        Special case:
        - If at any point the left pointer becomes equal to the right pointer,
            there is no longer any choice to make.
        - Take all digits from the left pointer to the end and finish.

\
    digits: "J"$'x;
    // -1 "digits = ", .Q.s1 digits;
    (prevIdx;digitsNeeded):-1 12;
    res: `long$();
    // -1 "### before while loop";
    while[(count res) < digitsNeeded;
          currResCount: count res;
          rp: (count digits) - (digitsNeeded-currResCount);
          lp: prevIdx+1; 
          range: lp + til 1+rp-lp;
        //   -1 "range for ",(string count res), ": ",(string lp), "-",(string rp);
          if[lp=rp; res::res,digits (lp + til (digitsNeeded-currResCount))];
          if[lp<>rp;maxNumInRange: max digits range;res:: res,maxNumInRange];
          prevIdx:: lp+((digits range)?maxNumInRange);
        //   -1 "append an item to res: ", (.Q.s1 res);
         ];
    // -1 "### after while loop";
    res: 10 sv res;
    // -1 "res = ", (.Q.s1 res);
    :accumulatedPower+res
    }

0 getPower/ inputs
