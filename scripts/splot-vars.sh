#generates scatter plots: set plot to 'pdf' to generate pdf output.

#plot='x11';
plot='pdf';
x11='x11';
e2pdf ()
{
    epstopdf $1.eps -o $1.pdf;
    pdf90 $1.pdf -o $1.pdf;
    pdf90 $1.pdf -o $1.pdf;
    pdf90 $1.pdf -o $1.pdf
}

if test "$#" -ne 5; then
    echo "Incorrect usage: expected 5 arguments, received $# arguments!"
    echo "Usage: splot-vars.sh <xaxis_logfile>  <yaxis_logfile> <xlabel> <ylabel> <title>"
    exit;
fi

fname1=`basename $1` #TC
fname2=`basename $2` #CAV13

xlabel=$3
ylabel=$4

title=$5

grep  "variables\|VERIFICATION ./" $1 > /tmp/$fname1.vars.2rows
perl -w 2rows2table.pl /tmp/$fname1.vars.2rows > /tmp/$fname1.vars.table

grep  "variables\|VERIFICATION ./" $2 > /tmp/$fname2.vars.2rows
perl -w 2rows2table.pl /tmp/$fname2.vars.2rows > /tmp/$fname2.vars.table

OUTFILE=$fname1-$fname2.vars.table

#inner join
join                                    \
  <(sort -k 1 /tmp/$fname1.vars.table)  \
  <(sort -k 1 /tmp/$fname2.vars.table)  \
  | column -t > $OUTFILE.tmp

sed -i '1i #fname TCvariables TCclauses POvariables POclauses Label'  $OUTFILE.tmp

#need to check...
awk 'NR >= 2 {$(NF+1)="'$title'";}1'  $OUTFILE.tmp  | column -t > $OUTFILE

rm -f $OUTFILE.tmp 

now=$(date +%Y-%m-%d.%H:%M:%S)
gnuplot_file="gnuplot.$now.gp"

#plot
echo 'set xlabel "'$xlabel'"'                   >  $gnuplot_file
echo 'set ylabel "'$ylabel'"'                   >> $gnuplot_file
echo 'set logscale x'                           >> $gnuplot_file
echo 'set logscale y'                           >>  $gnuplot_file
#for sc
echo 'set xrange[10**3:10**7]'                  >>  $gnuplot_file
echo 'set yrange[10**3:10**7]'                  >>  $gnuplot_file
#echo 'set xrange[10**4:10**7]'                     >>  $gnuplot_file
#echo 'set yrange[10**4:10**7]'                     >>  $gnuplot_file
echo 'set title "'$title'"'                     >> $gnuplot_file
if [ $plot = $x11 ]; then
  echo 'set terminal x11 persist'               >> $gnuplot_file
else
  echo 'set out "'$OUTFILE.eps'"'               >> $gnuplot_file
  echo 'set terminal postscript color enhanced' >> $gnuplot_file
fi

echo 'plot "'$OUTFILE'" u 2:4 w p pt 9 t "", x w l t ""' >> $gnuplot_file
gnuplot $gnuplot_file

if [ $plot != $x11 ]; then
  e2pdf $fname1-$fname2

  rm -f $fname1-$fname2.eps

  xpdf $fname1-$fname2.pdf
fi

#rm -f $OUTFILE
#rm -f $gnuplot_file

