set terminal png
set datafile separator " ";
set xlabel "time (years)"
set ylabel "angle"
set xtic auto
set ytic auto
set pointsize 7.0
set yrange [0:6.3]
set grid
plot 'result' using 1:2 title 'Resonant angle' with lines 2 0
