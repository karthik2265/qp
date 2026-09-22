input: trim each read0 `$":input.txt";
beamStartRow: input[0];
countSplits: {[x;row]
    // show "###"; 
    (c; beamIdxes): x;
    // 1 "beamIdxes = ";
    // show beamIdxes;
    // 1 "count = ";
    // show c;
    splittersIdxes: where row = "^";
    forwardBeamIdxes: (where row <> "^") inter beamIdxes;
    // 1 "forwardIdxes = ";
    // show forwardBeamIdxes;
    if[
        "^" in row;
        // 1 "splittersIdxees = ";
        // show splittersIdxes;
        c: c + sum (beamIdxes in splittersIdxes); 
        beamIdxes: (((splittersIdxes- 1), (splittersIdxes+ 1)) except (-1; (count row) + 1));
        beamIdxes: asc distinct beamIdxes, forwardBeamIdxes
        // 1 "beamIdxes after update = ";
        // show beamIdxes
        ];
    // show "###";
    :(c;beamIdxes)
    }

beamIdxes: enlist beamStartRow?"S";
show (0;beamIdxes) countSplits\ input;
