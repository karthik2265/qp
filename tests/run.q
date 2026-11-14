/ Test runner: loads every tests/*_test.q, prints the report, exits 1 on any failure.
/ Run via ./run_tests.sh (which sets QPATH so `use`kx.test` finds mod/kx/test.q).
t:@[use;`kx.test;{-2 "cannot load kx.test: ",x; exit 1}]
t.setDefaults[([verbose:0b])]   / only print the summary table below
.run.main:{
  files:`$"tests/",/:string f where (f:key `:tests) like "*_test.q";
  t.runFile each hsym files;
  r:t.getReport[];
  show select filename,feature,name,status from r;
  bad:select from r where not status=`pass;
  if[count bad; -2 "\n",string[count bad]," of ",string[count r]," test(s) failed"; :1];
  -1 "\nall ",string[count r]," tests passed";
  0 }
exit @[.run.main;::;{-2 "runner error: ",x; 1}]
