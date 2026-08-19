inputs: read0 `$":day-3-inputs.txt";
res:0;
getPower:{[accumulatedPower; x]
    n: count x;
    digits: "J"$'x;
    firstDigitOptions: (n-1) # digits;
    firstDigitIdx: first (firstDigitOptions ? max firstDigitOptions);
    secondDigitOptionsCount: n - firstDigitIdx;
    secondDigitOptions: digits[firstDigitIdx+1 + til secondDigitOptionsCount-1]; 
    power: 10 sv (max firstDigitOptions; max secondDigitOptions);
    :power+accumulatedPower;
    }

0 getPower/ inputs