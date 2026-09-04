inputs: read0 `$":day-5-inputs.txt";



findValidIdsBasic: {
    ids: "J"$((inputs?"") + 1) _ inputs;
    ranges: {"J"$("-" vs x)} each (inputs til inputs?"");
    res: sum {[id;r] any (id within/:r)}[;ranges] each ids;
    res
    };

\ts:1000 findValidIdsBasic[]

findValidIdsMergeRanges: {
    ids: "J"$((inputs?"") + 1) _ inputs;
    ranges: flip asc {"J"$("-" vs x)} each (inputs til inputs?"");
    (lowerBounds;upperBounds): ranges;
    rangesCount: count lowerBounds;
    idxOfNewRanges: lowerBounds > 1 + prev maxs upperBounds;
    cutPoints: where idxOfNewRanges;
    mergedLowers: first each (cutPoints _ lowerBounds);
    mergedUppers: last each (cutPoints _ maxs upperBounds);
    ranges: flip (mergedLowers; mergedUppers);
    res: sum {[id;r] any (id within/:r)}[;ranges] each ids;
    res
    }

\ts:1000 findValidIdsMergeRanges[]

findCountOfValidIds: {
    ids: "J"$((inputs?"") + 1) _ inputs;
    ranges: flip asc {"J"$("-" vs x)} each (inputs til inputs?"");
    (lowerBounds;upperBounds): ranges;
    rangesCount: count lowerBounds;
    idxOfNewRanges: lowerBounds > 1 + prev maxs upperBounds;
    cutPoints: where idxOfNewRanges;
    mergedLowers: first each (cutPoints _ lowerBounds);
    mergedUppers: last each (cutPoints _ maxs upperBounds);
    ranges: flip (mergedLowers; mergedUppers);
    res: sum ({((x 1) - (x 0)) + 1} each ranges);
    :res
    }

show findCountOfValidIds[]