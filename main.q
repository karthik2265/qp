// compress data

n: 10000000;
trade: ([] time:n?.z.p; sym:n?`AAPL`GGL`SPY; price: 200f + n?100.5f; size: 1 + n?10);
(`:db/trade/;17;2;6) set .Q.en[`:db/] trade;
-21!`:db/trade/sym

tradeSorted: `sym`time xasc trade;
(`:db/tradeSorted/;17;2;6) set .Q.en[`:db/] tradeSorted;
-21!`:db/tradeSorted/sym

