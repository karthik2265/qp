inputs: read0 `$":day-5-inputs.txt";

ids: "J"$((inputs?"") + 1) _ inputs;
ranges: {"J"$("-" vs x)} each (inputs til inputs?"");
res: sum {any (x within/:ranges)} each ids;
show res;