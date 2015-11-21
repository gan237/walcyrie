#generates scatter plots: set plot to 'pdf' to generate pdf output.

if test "$#" -ne 5; then
    echo "Incorrect usage: expected 5 arguments, received $# arguments"
    echo "Usage: splot-svcomp15.sh <xaxis_logfile>  <yaxis_logfile> <xlable> <ylabel> <title>"
    exit;
fi


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

tc=$1
cav13=$2

xlabel=$3
ylabel=$4

title=$5

tcb=`basename $tc`
cav13b=`basename $cav13`

OUTFILE=$tcb-$cav13b

echo "Processing "$tc"...";
gen-table.sh $tc
echo "Processing "$cav13"...";
gen-table.sh $cav13


join -j 4 /tmp/$tcb.table  /tmp/$cav13b.table | column -t > $OUTFILE
sed -i '1i NAME \t TCOUT \t TCRT \t TCMaxRSS \t CAVOUT \t CAVRT \t CAVMaxRSS' $OUTFILE
sed -i '1i #NAME \t tc-outcome \t tc-rtime \t tc-MaxRSS \t cav13-outcome \t cav13-rtime \t cav13-MaxRSS' $OUTFILE


#sanity check.. see if the benchmark names match between tables
#awk  '{if ($4 != $8) { print} }'   $OUTFILE >  $OUTFILE.problems
#if [[  -s $OUTFILE.problems ]]; then
#  echo "The files have unaligned benchmarks:"
#  cat $OUTFILE.problems
#else 
#  echo "Both files are have aligned benchmarks"
#fi

grep false-unreach $OUTFILE  > $OUTFILE.sat
grep true-unreach $OUTFILE   > $OUTFILE.unsat

#add UNSAT/SAT lables..
awk '{$(NF+1)="UNSAT";}1'  $OUTFILE.unsat |column -t > $OUTFILE.tmp 
mv  $OUTFILE.tmp   $OUTFILE.unsat 

awk '{$(NF+1)="SAT";}1'  $OUTFILE.sat  |column -t > $OUTFILE.tmp
mv  $OUTFILE.tmp   $OUTFILE.sat 


sed -i '1i NAME \t TCOUT \t TCRT \t TCMaxRSS \t CAVOUT \t CAVRT \t CAVMaxRSS \t EXPECTED' $OUTFILE.sat
sed -i '1i #NAME \t tc-outcome \t tc-rtime \t tc-MaxRSS \t cav13-outcome \t cav13-rtime \t cav13-MaxRSS \t EXPECTED' $OUTFILE.sat
cat $OUTFILE.sat  $OUTFILE.unsat |column -t > $OUTFILE.both

now=$(date +%Y-%m-%d.%H:%M:%S)
gnuplot_file="gnuplot.$now.gp"

#plot
echo 'set xlabel "'$xlabel'"'                   >  $gnuplot_file
echo 'set ylabel "'$ylabel'"'                   >> $gnuplot_file
echo 'set xrange [0:1000]'                      >> $gnuplot_file
echo 'set yrange [0:1000]'                      >> $gnuplot_file
echo 'set title "'$title'"'                     >> $gnuplot_file
if [ $plot = $x11 ]; then
  echo 'set terminal x11 persist'               >> $gnuplot_file
else
  echo 'set out "'$OUTFILE'.eps"'                      >> $gnuplot_file
  echo 'set terminal postscript color enhanced' >> $gnuplot_file
fi
echo 'plot "'$OUTFILE.sat'" u 3:6 w p pt 9 t "SAT", "'$OUTFILE'.unsat" u 3:6 t "UNSAT" w p pt 4, x t ""'  >> $gnuplot_file
gnuplot $gnuplot_file

rm -f $gnuplot_file
rm -f $OUTFILE.unsat $OUTFILE.sat

if [ $plot != $x11 ]; then
  e2pdf $OUTFILE

  rm -f $OUTFILE.eps

  #mv $OUTFILE.pdf $tcb-$cav13b.pdf
  xpdf $OUTFILE.pdf
fi

rm $OUTFILE  $OUTFILE.both
exit
