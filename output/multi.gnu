set terminal png
set xrange [0:100000]
set ytics format "%.2f"
# Uncomment the following to line up the axes
# set lmargin 6
set multiplot layout 3, 1 title "Resonances"
# Resonant parameter
set title "Resonant parameter"
set xlabel "time (years)"
set ylabel "angle"
plot 'result' using 1:2 title 'Resonant angle' with points 1 0
# S/m axis
set title "S/m axis"
set xlabel "time (years)"
set ylabel "S/m axis"
plot 'result' using 1:3 title 'S/m axis' with points 2 0
# Eccentricity
set title "Eccentricity"
set xlabel "time (years)"
set ylabel "eccentricity"
plot 'result' using 1:4 title 'Eccentricity' with points 3 0 
# On some terminals, nothing gets plotted until this command is issued
unset multiplot
