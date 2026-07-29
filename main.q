raw: read0 `$":day-1-inputs.txt";

directions:raw[;0];

rotations:"J"$1_/:raw;

rotations:@[rotations; where directions="L"; neg];

rotations[0]+:50;

show sum 0=((+\)rotations) mod 100 //969