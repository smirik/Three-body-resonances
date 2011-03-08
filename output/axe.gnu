set terminal png
set datafile separator " ";
set xlabel "time (years)"
set ylabel "angle"
set xtic auto
set ytic auto
set pointsize 7.0
set grid
plot 'result' using 1:3 title 'Axe' with points 1 0
