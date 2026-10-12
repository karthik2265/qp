input: trim each read0 `$":input.txt";
beamStartRow: input[0];
beamStartRow[where beamStartRow = "S"]: "^";
input[0]: beamStartRow;
countSplits: {[previousRow;currentRow]
    // show "###";
    beamIdxesInPreviousRow: where previousRow <> 0;
    // -1 "previousRow = ";
    // show previousRow;
    // -1 "beamIdxesInPreviousRow = ";
    // show beamIdxesInPreviousRow;
    splitterIdxesInCurrentRow: where currentRow = "^";
    usefulSplitterIdxesInCurrentRow: beamIdxesInPreviousRow where beamIdxesInPreviousRow in splitterIdxesInCurrentRow;
    // construct next row
    n: count previousRow;
    nextRow: n#0;
    // -1 "usefulSplitterIdxesInCurrentRow = ";
    // show usefulSplitterIdxesInCurrentRow;
    leftIdxes: usefulSplitterIdxesInCurrentRow - 1;
    rightIdxes: usefulSplitterIdxesInCurrentRow + 1;
    usefulLeftIdxes:leftIdxes where leftIdxes >= 0;
    usefulRightIdxes: rightIdxes where rightIdxes < n;
    // -1 "usefulLeftIdxes = ";
    // show usefulLeftIdxes;
    // -1 "usefulRightIdxes = ";
    // show usefulRightIdxes;
    // pass the previous values to left and right
    nextRow: @[nextRow; usefulLeftIdxes; +; previousRow[usefulSplitterIdxesInCurrentRow]];
    nextRow: @[nextRow; usefulRightIdxes; +; previousRow[usefulSplitterIdxesInCurrentRow]];
    // -1 "nextRow = ";
    // show nextRow;
    // show previousRow[usefulSplitterIdxesInCurrentRow];
    // beam split positions where split happened should be 0
    previousRow[usefulSplitterIdxesInCurrentRow]: 0;
    nextRow: previousRow + nextRow;
    // -1 "nextRow = ";
    // show nextRow;
    // show "###";
    :nextRow
    }

previousRow: "j"$ beamStartRow = "^";
input: 1_input;
res: previousRow countSplits/ input;
show sum res;
