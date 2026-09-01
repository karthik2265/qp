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

getAccessCount: {[accessiblePositions;position]
    (x;y):position;
    rollsOfPaperInAdjacentPositions: countRollsOfPaperInAdjacentPositions[x;y];
    if[rollsOfPaperInAdjacentPositions < 4; accessiblePositions: accessiblePositions,enlist (x;y)];
    :accessiblePositions
    }

// take positions of paper rolls
idxesOfRollsOfPaper: where raze inputs = "@";
positionsOfRollsOfPapers: flip (idxesOfRollsOfPaper div columnsCount; idxesOfRollsOfPaper mod columnsCount);
accessiblePositions: () getAccessCount/ positionsOfRollsOfPapers;
// iterate and count
res:0;
while[
    count accessiblePositions > 0; 
    {[pos] (x;y): pos; inputs[x;y]: "."} each accessiblePositions; 
    res: res+(count accessiblePositions); 
    idxesOfRollsOfPaper: where raze inputs = "@";
    positionsOfRollsOfPapers: flip (idxesOfRollsOfPaper div columnsCount; idxesOfRollsOfPaper mod columnsCount);
    accessiblePositions: () getAccessCount/ positionsOfRollsOfPapers
    ];
show res;


