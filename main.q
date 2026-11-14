//your answer here 
savePath: {[dt;t]
    r: read0`:par.txt;
    n: count r;
    s:r (dt mod n);
    :` sv hsym[`$s],`$string dt,t
    }
show savePath[2000.01.01;`trade]
show key `:.