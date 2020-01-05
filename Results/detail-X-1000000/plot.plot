# set output ''
set terminal svg font 'monospace:Bold,12' linewidth 1.5 size 600,400
set xlabel 'Computation cost (games)' offset 0,0.25
set ylabel '% of wins' offset 1
set xrange [0:1000000]
set yrange [51:58]
set ytics 1
set lmargin 5
set key bottom center horizontal width 3
set style fill transparent solid 0.25 noborder

parse(group) = "<(paste " . group . ".*.p | grep '^ ' | awk '{print $1 \" \" (($2 + $5 + $8 + $11 + $14 + $17 + $20 + $23 + $26 + $29) / 10) \" \" sqrt(($2 ^ 2 + $5 ^ 2 + $8 ^ 2 + $11 ^ 2 + $14 ^ 2 + $17 ^ 2 + $20 ^ 2 + $23 ^ 2 + $26 ^ 2 + $29 ^ 2 - ((($2 + $5 + $8 + $11 + $14 + $17 + $20 + $23 + $26 + $29) ^ 2) / 10)) / 10)}')"

array groups[8]
groups[1] = "evolve-specialized"
groups[2] = "evolve-specialized-lerp"
groups[3] = "evolve-specialized-all"
groups[4] = "evolve-standard"
groups[5] = "evolve-active-2"
groups[6] = "evolve-active-4"
groups[7] = "evolve-variant-2"
groups[8] = "evolve-variant-4"

array labels[8]
labels[1] = "AG"
labels[2] = "AG_{weights}"
labels[3] = "AG_{all}"
labels[4] = "Evo_{base}"
labels[5] = "AG_{weights/2d}"
labels[6] = "AG_{weights/4d}"
labels[7] = "AG_{weights/2g}"
labels[8] = "AG_{weights/4g}"

set output 'plot-performance-random.svg'
plot for [i = 1 : 4] parse(groups[i]) using 1:2 title labels[i] with lines lc i lw 2
set output 'plot-performance-random-variants.svg'
plot for [i = 5 : 8] parse(groups[i]) using 1:2 title labels[i] with lines lc i lw 2
