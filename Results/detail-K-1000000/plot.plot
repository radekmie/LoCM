set output 'plot-evolution.svg'
set terminal svg font 'monospace:Bold,16' linewidth 2 size 600,400
# set terminal svg size 600,400
set bmargin 1.5
set lmargin 3
set rmargin 1
set tmargin 1
set xlabel 'Known drafts %'
set ylabel 'Fresh drafts %'
set key bottom horizontal Right
unset xlabel
unset ylabel
unset key
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

name(name, a, b, c) = sprintf("%s (y = %.2fx + %5.2f, avg = %.2f)", name, a, b, c)

plot \
  data1 title name('evolve-specialized     ', a1, b1, c1) with circles lc 1, \
  data2 title name('evolve-specialized-all ', a2, b2, c2) with circles lc 2, \
  data3 title name('evolve-specialized-lerp', a3, b3, c3) with circles lc 3, \
  data4 title name('evolve-standard        ', a4, b4, c4) with circles lc 4, \
  y1(x) lc 1 notitle, \
  y2(x) lc 2 notitle, \
  y3(x) lc 3 notitle, \
  y4(x) lc 4 notitle
