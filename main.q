// load/memeory map the table
.pq: use `kx.pq;
w: select from .pq.pq`:weather.parquet;
// use celcius instead of fahrenheit
update temperatureC: (temperatureF - 32) * 5%9 from `w;
// delete temperatureF from `w;
// calculate
// avgTemp: select avgTmpF: avg temperatureF, avgTmpC: avg temperatureC by sensorId, 0D01:00 xbar time from w;
// wAvgTemp: select avgTmpF: humidity wavg temperatureF, avgTmpC: humidity wavg temperatureC by sensorId, 0D01:00 xbar time from w;
// quiz
// 1
// show 1#(`highestHourlyAvgTemp xdesc select highestHourlyAvgTemp: max avgTmpF by sensorId from avgTemp where time.date = 2026.01.25);
// 2
// show (`highestHourlyAvgTemp xdesc select highestHourlyAvgTemp: max avgTmpC from avgTemp where time.date = 2026.01.25);
// 3
// show 1#(`lowestHourlyAvgTemp xasc select lowestHourlyAvgTemp: min avgTmpC by sensorId from wAvgTemp where time.date = 2026.01.25);
// 4
// show (select lowestHourlyAvgTemp: min avgTmpC from wAvgTemp where time.date = 2026.01.25);
v: ("PIF"; enlist ",") 0: `:vitals.csv;
// sort by time both w and v
firstDay: first exec distinct `date$time from w;
fdw: `time xasc (select from w where time.date = firstDay);
v: `time xasc v;
fdv: `time xasc (select from v where time.date = firstDay)

vw: aj[`time;fdv;fdw];
// 1
s: first exec sensorId from (`c xdesc select c:count i by sensorId from vw);
show s;
// 2
hsp: exec count i from vw where heartRate>100, temperatureF>77;
show hsp;
// 3
hsp: select from vw where heartRate > 100, temperatureF > 77;
hspbh: `c xdesc select c:count i by 0D01:00:00 xbar time from hsp;
show hspbh;
