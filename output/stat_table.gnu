set term png size 600,1000 font '/Library/Fonts/Microsoft/Calibri.ttf,15'
set datafile separator ";";
set xlabel "s/m axis"
set ylabel "angle"
set xtic auto
set ytic auto
set pointsize 7.0
set grid
plot 'stat_table' using 1:2 lt -1 lc -1 notitle with dots 
