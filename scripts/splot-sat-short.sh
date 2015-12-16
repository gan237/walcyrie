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
    echo "Usage: splot-sat.sh <xaxis_logfile>  <yaxis_logfile> <xlable> <ylabel> <title>"
    exit;
fi

fname1=`basename $1` #TC
fname2=`basename $2` #CAV13

xlabel=$3
ylabel=$4

title=$5

grep   -A5 -E "^restarts|^VERIFICATION ./" $1 | grep -v "\-\-" > /tmp/$fname1.minisat.stats.6rows

perl -w 10rows2table.pl /tmp/$fname1.minisat.stats.6rows | awk -F' ' 'NR==1 {$(NF-1)="rho" FS$(NF-1);}1 NR>1 {if($3+0 != 0){$(NF-1)=$4/$3 FS$(NF-1);}else{if($3+0 == $3){$(NF-1)=0 FS $(NF-1);}}}1' |  column -t  > /tmp/$fname1.table

grep   -A5 -E "^restarts|^VERIFICATION ./" $2 | grep -v "\-\-" > /tmp/$fname2.minisat.stats.6rows

perl -w 10rows2table.pl /tmp/$fname2.minisat.stats.6rows | awk -F' ' 'NR==1 {$(NF-1)="rho" FS$(NF-1);}1 NR>1 {if($3+0 != 0){$(NF-1)=$4/$3 FS$(NF-1);}else{if($3+0 == $3){ $(NF-1)=0 FS $(NF-1);}}}1' | column -t  > /tmp/$fname2.table

#cat /tmp/$fname1.table  /tmp/$fname2.table 
OUTFILE=$fname1-$fname2.table

#do an inner join
# The first set of columns are TC/$fname1 and 
# The second set of columns are TC/$fname2
# 
rev <(join                                \
        <(sort <(rev /tmp/$fname1.table)) \
        <(sort <(rev /tmp/$fname2.table)) \
     )  | column -t > $OUTFILE 

#  )  > /tmp/ooo
#cat $OUTFILE

grep false-unreach $OUTFILE  > $OUTFILE.sat
grep true-unreach  $OUTFILE  > $OUTFILE.unsat

#add UNSAT/SAT lables..
awk '{$(NF+1)="UNSAT";}1'  $OUTFILE.unsat |column -t > $OUTFILE.tmp 
mv  $OUTFILE.tmp   $OUTFILE.unsat 

awk '{$(NF+1)="SAT";}1'  $OUTFILE.sat  | column -t > $OUTFILE.tmp

sed -i '1i TCrestarts  TCconflicts  TCdecisions  TCpropagations  TCconflict-literals  TCrho      TCoutcome  CAVrestarts  CAVconflicts  CAVdecisions  CAVpropagations  CAVconflict-literals  CAVrho      CAVoutcome  name EXPECTED' $OUTFILE.tmp

sed -i '1i #restarts  conflicts  decisions  propagations  conflict-literals  rho      outcome  restarts  conflicts  decisions  propagations  conflict-literals  rho      outcome  name EXPECTED' $OUTFILE.tmp
column -t  $OUTFILE.tmp >  $OUTFILE.sat 
rm -f $OUTFILE.tmp 

cat $OUTFILE.sat  $OUTFILE.unsat |column -t > $OUTFILE.both


now=$(date +%Y-%m-%d.%H:%M:%S)
gnuplot_file="gnuplot.$now.gp"

#plot
echo 'set xlabel "'$xlabel'"'                   >  $gnuplot_file
echo 'set ylabel "'$ylabel'"'                   >> $gnuplot_file
echo 'set logscale x 2'                         >> $gnuplot_file
echo 'set logscale y 2'                         >>  $gnuplot_file
#for sc
#echo 'set xrange[128:4096]'                      >>  $gnuplot_file
#echo 'set xrange[128:4096]'                      >>  $gnuplot_file
echo 'set xrange[512:4096]'                     >>  $gnuplot_file
echo 'set yrange[512:4096]'                     >>  $gnuplot_file
echo 'set title "'$title'"'                     >> $gnuplot_file
if [ $plot = $x11 ]; then
  echo 'set terminal x11 persist'               >> $gnuplot_file
else
  echo 'set out "'$fname1-$fname2.eps'"'        >> $gnuplot_file
  echo 'set terminal postscript color enhanced' >> $gnuplot_file
fi

echo 'plot "'$OUTFILE.sat'" u ($4/$2):($11/$9) w p pt 9 t "SAT", "'$OUTFILE.unsat'" u ($4/$2):($11/$9) w p pt 9 t "UNSAT", x t ""' >> $gnuplot_file
gnuplot $gnuplot_file

if [ $plot != $x11 ]; then
  mv $fname1-$fname2.eps $fname1-$fname2.EE.eps 
  e2pdf $fname1-$fname2.EE

  rm -f $fname1-$fname2.EE.eps

  xpdf $fname1-$fname2.EE.pdf
  #mv one.pdf $tcb-$cav13b.pdf
fi

rm -f $OUTFILE.unsat $OUTFILE.sat $OUTFILE.both $OUTFILE 
rm -f $gnuplot_file

