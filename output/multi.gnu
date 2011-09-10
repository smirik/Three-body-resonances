set term png size 600,1000 font '/Library/Fonts/Microsoft/Calibri.ttf,15'
set xrange[0:100000]
set ytics format "%.3f"

set tmargin 1
set bmargin 0
set lmargin 12
set rmargin 3
unset xtics
unset xlabel
unset ylabel

set multiplot layout 7, 1 
#title "Астероид 12065, резонанс: 4 -2 -1"
# Resonant parameter
#set title "Резонансный аргумент"
set ylabel "Sigma"
set ytics -100, 2, 100 format "%.0f"
plot 'result' using 1:2 lt -1 lc -1 notitle with dots
# S/m axis
set ylabel "a"
set ytics format "%.3f" -100, 0.005, 100
plot 'result' using 1:3 lt -1 title '' with dots
# Eccentricity
set ylabel "e"
set ytics format "%.2f" -100, 0.03, 100
plot 'result' using 1:4 lt -1 title '' with dots
# Node
set ylabel "node"
set ytics format "%.0f" -100, 2.0, 100
plot 'result' using 1:6 lt -1 title '' with dots
# Node
set ylabel "w"
set ytics format "%.0f" -100, 2.0, 100
plot 'result' using 1:7 lt -1 title '' with dots
# Inclination
set ylabel "i"
set ytics format "%.2f" -100, 0.02, 100
set xlabel "Время"
set xtics 0, 20000, 100000 format "%2.0f"
plot 'result' using 1:4 lt -1 title '' with dots
# On some terminals, nothing gets plotted until this command is issued
unset multiplot
