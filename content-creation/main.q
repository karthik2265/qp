/
As-of Join (aj) in kdb+


An as-of join lets you join two tables on time, where instead of requiring an exact timestamp match, it finds the most recent record from the second table that occurred at or before the time in the first table.

It's most commonly used in financial data to attach the prevailing bid/ask spread to a trade — giving you the quote that was live at the exact moment the trade hit.


How it works

Say you have a trade for AAPL at 09:30:00.500, and two quotes for AAPL:

- Quote A at 09:30:00.300 → bid: 150.20

- Quote B at 09:30:00.700 → bid: 150.25

aj will attach Quote A to the trade, because it's the most recent quote that existed at or before the trade time. Quote B hadn't arrived yet.

Syntax

aj[`sym`time; trades; quotes]

The last column in the key list (time) is ths (sym) must be an exact match. Both tablesmust be pre-sorted with xasc.

note: No match = nulls. If no record in the quotes table exists at or before the trade time, aj returns null for those columns — worth checking for, especially a

See the example on the next page to understand this better
\

// tables/data
trades:([]
  sym:`AAPL`MSFT;
  time:2026.11.06D09:30:00.600 2026.11.06D09:30:00.400;
  price:150.30 420.50;
  size:200 150
  );

quotes:([]
  sym:`AAPL`AAPL`AAPL`MSFT`MSFT;
  time:2026.11.06D09:30:00.200 2026.11.06D09:30:00.400 2026.11.06D09:30:00.800 2026.11.06D09:30:00.150 2026.11.06D09:30:00.300;
  bid:150.20 150.25 150.28 420.35 420.40;
  ask:150.30 150.35 150.38 420.55 420.60
  );
// sort the tables
trades: `sym`time xasc trades;
quotes: `sym`time xasc quotes;

show "# trades #";
show trades;
show "###";
show "# quotes #";
show quotes;
show "###";

result: aj[`sym`time;trades;quotes];
show result;