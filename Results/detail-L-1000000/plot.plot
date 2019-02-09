set output 'plot-performance.svg'
set terminal svg font 'monospace:Bold,16' linewidth 2 size 1000,600
set xlabel 'Plays'
set ylabel '% of wins'
# set xrange [100000:1000000]
# set yrange [0:100]
set key bottom center horizontal Left
set style fill transparent solid 0.25 noborder

parse(group) = "<(paste " . group . ".*.p | grep '^ ' | awk '{print $1 \" \" (($2 + $5 + $8 + $11 + $14) / 5) \" \" sqrt(($2 ^ 2 + $5 ^ 2 + $8 ^ 2 + $11 ^ 2 + $14 ^ 2 - ((($2 + $5 + $8 + $11 + $14) ^ 2) / 5)) / 5)}')"
array groups[4]
groups[1] = "evolve-specialized"
groups[2] = "evolve-specialized-all"
groups[3] = "evolve-specialized-lerp"
groups[4] = "evolve-standard"
# groups[5] = "evolve-specialized-drafts"
# groups[6] = "evolve-specialized-epochs"

plot \
  for [i = 1 : 4] parse(groups[i]) using 1:($2 - $3):($2 + $3) notitle with filledcurve lc i, \
  for [i = 1 : 4] parse(groups[i]) using 1:2 title groups[i] with lines lc i lw 1.5
