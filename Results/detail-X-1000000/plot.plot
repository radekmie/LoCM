set output 'plot-performance.svg'
set terminal svg font 'monospace:Bold,16' linewidth 1.5 size 1000,600
set xlabel 'Computation cost (games)' offset 0,0.5
set ylabel '% of wins' offset 2
set xrange [0:1000000]
set ytics 1
set lmargin 5
set key bottom center horizontal width 3
set style fill transparent solid 0.25 noborder

parse(group) = "<(paste " . group . ".*.p | grep '^ ' | awk '{print $1 \" \" (($2 + $5 + $8 + $11 + $14 + $17 + $20 + $23 + $26 + $29) / 10) \" \" sqrt(($2 ^ 2 + $5 ^ 2 + $8 ^ 2 + $11 ^ 2 + $14 ^ 2 + $17 ^ 2 + $20 ^ 2 + $23 ^ 2 + $26 ^ 2 + $29 ^ 2 - ((($2 + $5 + $8 + $11 + $14 + $17 + $20 + $23 + $26 + $29) ^ 2) / 10)) / 10)}')"

array groups[8]
groups[1] = "evolve-specialized"
groups[2] = "evolve-standard"
groups[3] = "evolve-specialized-all"
groups[4] = "evolve-specialized-lerp"
groups[5] = "evolve-active-2"
groups[6] = "evolve-active-4"
groups[7] = "evolve-variant-2"
groups[8] = "evolve-variant-4"

array labels[8]
labels[1] = "E_a"
labels[2] = "E_b"
labels[3] = "E_{all}"
labels[4] = "E_{aw}"
labels[5] = "E_{aw/2d}"
labels[6] = "E_{aw/4d}"
labels[7] = "E_{aw/2g}"
labels[8] = "E_{aw/4g}"

plot for [i = 1 : 8] parse(groups[i]) using 1:2 title labels[i] with lines lc i lw 2
