set output 'plot-performance.svg'
set terminal svg font 'monospace:Bold,16' linewidth 2 size 1000,600
set xlabel 'Plays'
set ylabel '% of wins'
set xrange [100000:500000]
set key bottom center horizontal Left
set style fill transparent solid 0.5 noborder
filenames = "evolve-specialized evolve-specialized-all evolve-specialized-lerp evolve-standard"
plot for [file in filenames] "<(cat ".file.".p | grep '^ ')" using 1:($2 - $3):($2 + $3) title file with filledcurve
