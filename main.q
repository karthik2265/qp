
// load/memeory map the table
.pq: use `kx.pq;
t: select from .pq.pq`:weather.parquet;
// use celcius instead of fahrenheit
update temperatureC: (temperatureF - 32) * 5%9 from `t;
// delete temperatureF from `t;
// calculate
avgTemp: select avgTmpF: avg temperatureF, avgTmpC: avg temperatureC by sensorId, 0D01:00 xbar time from t;
wAvgTemp: select avgTmpF: humidity wavg temperatureF, avgTmpC: humidity wavg temperatureC by sensorId, 0D01:00 xbar time from t;
// quiz
// 1
// show 1#(`highestHourlyAvgTemp xdesc select highestHourlyAvgTemp: max avgTmpF by sensorId from avgTemp where time.date = 2026.01.25);
// 2
// show (`highestHourlyAvgTemp xdesc select highestHourlyAvgTemp: max avgTmpC from avgTemp where time.date = 2026.01.25);
// 3
// show 1#(`lowestHourlyAvgTemp xasc select lowestHourlyAvgTemp: min avgTmpC by sensorId from wAvgTemp where time.date = 2026.01.25);
// 4
// show (select lowestHourlyAvgTemp: min avgTmpC from wAvgTemp where time.date = 2026.01.25);