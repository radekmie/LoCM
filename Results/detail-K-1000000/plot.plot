set output 'plot-evolution.png'
set terminal png font 'monospace:Bold,16' linewidth 2 size 600,400
set bmargin 2.25
set lmargin 4.75
set rmargin 1
set tmargin 0.5
set xlabel '% of wins on known drafts' offset 0, 0.75
set ylabel '% of wins on fresh drafts' offset 2, 0
set key bottom Left
set style fill transparent solid 0.5 noborder
set style circle radius 0.05
set fit logfile '/dev/null'
set yrange [52:66]
set xrange [52:66]

a1 = 1; b1 = 1; c1 = 50; data1 = "<(cat evolve-specialized.*.p      | grep '^ ')"
a2 = 1; b2 = 1; c2 = 50; data2 = "<(cat evolve-specialized-all.*.p  | grep '^ ')"
a3 = 1; b3 = 1; c3 = 50; data3 = "<(cat evolve-specialized-lerp.*.p | grep '^ ')"
a4 = 1; b4 = 1; c4 = 50; data4 = "<(cat evolve-standard.*.p         | grep '^ ')"

y1(x) = a1 * x + b1; avg1(x) = c1; fit y1(x) data1 via a1, b1; fit avg1(x) data1 via c1
y2(x) = a2 * x + b2; avg2(x) = c2; fit y2(x) data2 via a2, b2; fit avg2(x) data2 via c2
y3(x) = a3 * x + b3; avg3(x) = c3; fit y3(x) data3 via a3, b3; fit avg3(x) data3 via c3
y4(x) = a4 * x + b4; avg4(x) = c4; fit y4(x) data4 via a4, b4; fit avg4(x) data4 via c4

name(a, b, c, name) = name

plot \
  data1 title name(a1, b1, c1, 'AG')           with circles lc 1, \
  data2 title name(a2, b2, c2, 'AG_{all}')     with circles lc 2, \
  data3 title name(a3, b3, c3, 'AG_{weights}') with circles lc 3, \
  data4 title name(a4, b4, c4, 'Evo_{base}')   with circles lc 4, \
  y1(x) lc 1 notitle, \
  y2(x) lc 2 notitle, \
  y3(x) lc 3 notitle, \
  y4(x) lc 4 notitle
