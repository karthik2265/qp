// read data
filepath: hsym `$"day-1-inputs.txt"
lines: read0 filepath
{[x] show x} each lines
// parse data
directions: first each lines
extractRotations:{[line] 1 20 sublist line}
rotations: extractRotations each lines
rotations: {[x] "I"$x} each rotations
// calculate the result
position:50
zerocount:0
processLine: {[i;direction] 
    if[position=0;zerocount+::1];
    /0N! "###";
    /0N! i;
    /0N! direction;
    /0N! rotations[i];
    $[direction="R";position::((position + rotations[i]) mod 100);position::((position - rotations[i]) mod 100)]; 
    /0N! position;
    /0N! "###";
    i+1
    }

/ use over instead of do
0 processLine/ directions 
0N! zerocount / 59
show position / 52