cd ..
gnuplot --persist plot.plot
mv *.svg plots

cd ../detail-X-1000000
gnuplot --persist plot.plot
mv *.svg ../CEC-2020-greedy/plots

cd ../CEC-2020-greedy/plots
for plot in *.svg; do
  inkscape -D -z --file="$plot" --export-pdf="${plot/svg/pdf}" --export-latex
  perl -pi -e "s|\\\\textbf\{1x10\}\\\\textbf\{6\}|\\\\textbf{10x10\\\\textsuperscript{5}}|g" "${plot/svg/pdf_tex}"
  perl -pi -e "s|\\\\textbf\{(\d)00000\}|\\\\textbf{\1x10\\\\textsuperscript{5}}|g" "${plot/svg/pdf_tex}"
  perl -pi -e "s|\\\\textbf\{(.*?)\}\\\\textbf\{(.*?)\}|\\\\textbf{\1\\\\textsubscript{\2}}|g" "${plot/svg/pdf_tex}"
  perl -pi -e "s|\\\\textbf\{(.*?)\}|\\\\texttt{\\\\textbf{\\\\small{\1}}}|g" "${plot/svg/pdf_tex}"
  perl -pi -e "s|% of wins|\\\\% of wins|g" "${plot/svg/pdf_tex}"
done

rm -f *.svg
