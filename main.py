import pykx as kx
import matplotlib.pyplot as plt

q = kx.q

q('.pq: use `kx.pq;')
q('w: select from .pq.pq`:weather.parquet;')
q('update temperatureC: (temperatureF - 32) * 5%9 from `w;')
q('v: ("PIF"; enlist ",") 0: `:vitals.csv;')
q('firstDay: first exec distinct `date$time from w;')
q('fdw: `time xasc (select from w where time.date = firstDay);')
q('v: `time xasc v;')
q('vw: aj[`time;v;fdw];')

vw = q('vw').pd()
hsp = vw[(vw['heartRate'] > 100) & (vw['temperatureF'] > 77)]

plt.scatter(vw['heartRate'], vw['temperatureF'], alpha=0.3, label='Normal')
plt.scatter(hsp['heartRate'], hsp['temperatureF'], color='red', alpha=0.7, label='High stress')
plt.xlabel('Heart Rate')
plt.ylabel('Temperature (F)')
plt.title('Heart Rate vs Temperature')
plt.legend()
plt.show()

