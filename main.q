inputs: trim each read0 `$":day-6-inputs.txt";
inputs: {(" " vs x where (or)prior " "<>x)} each inputs;
show sum {$[last last x = "*"; :prd "I"$-1 _ x; :sum "I"$-1 _ x]} each inputs;