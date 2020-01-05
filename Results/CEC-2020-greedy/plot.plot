set output 'plot-performance-greedy.svg'
set terminal svg font 'monospace:Bold,13' linewidth 1.5 size 588,400
set xlabel 'Computation cost (games)' offset 0,0.25
set ylabel '% of wins' offset 1
set xrange [0:1000000]
set yrange [60:74]
set ytics 2
set lmargin 5
set key bottom center horizontal width 3
set style fill transparent solid 0.25 noborder

parse(group) = "<(paste " . group . ".*.p | grep '^ ' | awk '{print $1 \" \" (($2 + $5 + $8) / 3) \" \" sqrt(($2 ^ 2 + $5 ^ 2 + $8 ^ 2 - ((($2 + $5 + $8) ^ 2) / 3)) / 3)}')"

array groups[4]
groups[1] = "evolve-specialized"
groups[2] = "evolve-standard"
groups[3] = "evolve-specialized-all"
groups[4] = "evolve-specialized-lerp"

array labels[4]
labels[1] = "E_a"
labels[2] = "E_b"
labels[3] = "E_{all}"
labels[4] = "E_{aw}"

plot for [i = 1 : 4] parse(groups[i]) using 1:2 title labels[i] with lines lc i lw 2
