n:1000000;
t:([]time:"P"$(string[.z.d],"D"),/:string[n?00:00:00.000];sym:n?`AAPL`JPM`GOOG`AMZN;ID:"i"$neg[n]?n;price:n?100f);
newTab:`time xasc t; //speeding up the time lookup using the sorted attribute on time column
newTab:update `u#ID, `g#sym from newTab; //applying grouped and unique to improve performance on sym and ID lookup
\t:10000 select avg price from t where sym=`JPM,time.time>09:00,ID within 500 600;
\t:10000 select avg price from newTab where sym=`JPM,time.time>09:00,ID within 500 600;