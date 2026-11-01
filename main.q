

// Inserted from [md] project.md

//your code here - or work in the scratchpad

dataPath: hsym `$getenv[`HOME],"/fundamentals_capstone_dbs/";
system "l ",1_string dataPath;

// // 1.2
// showTableSummary: {[]
//     tableNames: key each tables[];
//     countOfRowsForTables: {count select from x} each tableNames;
//     :tableNames ! countOfRowsForTables
//     }

refServiceHandle: hopen `::5457;

uniqueOpts: (select distinct option_id from trade)`option_id;
optRef: refServiceHandle (`getOptionRef; uniqueOpts);

uniqueInstruments: (select distinct inst_id from optRef)`inst_id;
instRef: refServiceHandle (`getInstRef; uniqueInstruments);

csvPath: `$getenv[`AX_WORKSPACE],"/FP.Data/message.csv";
messages: ("**"; enlist ",") 0: csvPath;
// testSection[`exercise1]

update expiry: "D"$expiry from `optRef;

update broker_id: extractBrokerId each exch_message from `messages;

// testSection[`exercise2];
trade: select from trade;
nbbo: select from nbbo;
lastDateTrades: select from trade where date=max date;
tradeContext: aj[`date`option_id`time;lastDateTrades;nbbo];
delete bsize, asize from `tradeContext;

// check for badTrades
qualityOfTrades: classifyTrades tradeContext;
badTrades: select from qualityOfTrades where (date=max distinct date) & (exQuality=0);
pathToSaveBadTrades: hsym `$getenv[`AX_WORKSPACE],"/badTrades.csv";
pathToSaveBadTrades 0:csv 0:badTrades;

// testSection[`exercise3]

// What is the total edge (as edge), total traded volume (as qty) and the number of trades (numTrds) 
// in each 15 minute window (minute) starting from 0930hrs to the End of day on the latest date? 
// Store this in a variable called edge15.

edge15: select edge: sum edge, qty: sum qty, numTrds: count edge
          by 15 xbar time.minute 
          from trade 
//           by 09:30:00.000 + xbar[900000; time - 09:30:00.000]
//           from tradeContext
          where date = last date;
// edge15:select edge:sum edge, qty:sum qty, numTrds:count i 
//         
//         where date = last date;

// {[orderColumn;order;N;tab]
top5EdgeTimes: returnN[`edge;`top;5;edge15];
bottom5QtyTimes: returnN[`qty;`bottom;5;edge15];
edge15Value: value edge15;
timeSeries: `edge`qty`numTrds ! edge15Value`edge`qty`numTrds;
// show timeSeries;
// show (timeSeries`edge) cor (timeSeries`edge);
// show (timeSeries`edge;timeSeries`qty cor timeSeries`edge;timeSeries`numTrades);
edgeCor: `edge`qty`numTrds ! ((timeSeries`edge) cor (timeSeries`edge); (timeSeries`edge) cor ("f"$timeSeries`qty); (timeSeries`edge) cor ("f"$timeSeries`numTrds));
// show edgeCor;
// testSection[`exercise4]

optProfile: `option_id xkey (select numTrds: count i, avgEdge: avg edge, minQty: min qty, maxQty: max qty 
             by option_id 
             from lastDateTrades);
// show 3#optProfile;
// show meta optProfile;
// show select distinct date from trade;
// show select distinct date from lastDateTrades;
// show type key[optProfile]`option_id;
// show type lastDateTrades`option_id;
// show optProfile;
// edgeProfile: `option_id xkey select numTrds: count i, edge: avg edge, minQty: min qty, maxQty: max qty by option_id from trade where edge > (avg; edge) fby `option_id;
edgeProfile: `option_id xkey (select
        numTrds: count i,
        avgEdge: avg edge,
        minQty: min qty,
        maxQty: max qty
    by option_id
    from lastDateTrades
    where edge > (avg;edge) fby option_id);

// show type lastDateTrades`option_id;
// show type lastDateTrades`edge;
// show count edgeProfile;
optInstRef: `option_id xkey (optRef ij `inst_id xkey instRef);
edgeProfileFull: `option_id xkey (edgeProfile lj optInstRef);
// testSection[`exercise5]
