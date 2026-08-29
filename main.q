inputs: read0 `$":day-4-inputs.txt";

rowsCount: count inputs;
columnsCount: count inputs[0];

countRollsOfPaperInAdjacentPositions: {[x;y]
    adjacentPositions: ((x;y-1);(x+1;y);(x;y+1);(x-1;y);(x+1;y-1);(x+1;y+1);(x-1;y+1);(x-1;y-1));
    :sum {[pos]
        (r;c): pos;
        $[(r >= 0) and (r < rowsCount) and (c >= 0) and (c < columnsCount) and (inputs[r;c] = "@");
        1;
        0]
    } each adjacentPositions
    }

getAccessCount: {[currentCount;position]
    (x;y):position;
    rollsOfPaperInAdjacentPositions: countRollsOfPaperInAdjacentPositions[x;y];
    if[rollsOfPaperInAdjacentPositions < 4; currentCount: currentCount+1];
    :currentCount
    }

// take positions of paper rolls
idxesOfRollsOfPaper: where raze inputs = "@"
positionsOfRollsOfPapers: flip (idxesOfRollsOfPaper div columnsCount; idxesOfRollsOfPaper mod columnsCount);
show (0 getAccessCount/ positionsOfRollsOfPapers);



