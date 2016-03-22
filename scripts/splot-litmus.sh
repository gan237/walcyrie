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
    echo "Usage: splot-litmus.sh <xaxis_logfile>  <yaxis_logfile> <xlable> <ylabel> <title>"
    exit;
fi


tc=`basename $1`
cav13=`basename $2`


xlabel=$3
ylabel=$4

title=$5

join -t, -j  2 $1  $2  > one

#remove the header that comes from join
sed -i '1d' one

sed -i '1i Benchmark,TCLogFile,TCResult,TCcommand,TCcommandline,TCcpuinfo,TCdate,TCexitcode,TCexpected,TCmaxmem,TCmeminfo,TCmemlimit,TCmt_all_constr,TCmt_max_constr,TCtimeout,TCuname,TCuser,TCusertime,TCversion,TCwallclock, CAVLogFile, CAVResult, CAVcommand, CAVcommandline, CAVcpuinfo, CAVdate, CAVexitcode, CAVexpected, CAVmaxmem, CAVmeminfo, CAVmemlimit, CAVmt_all_constr, CAVmt_max_constr, CAVtimeout, CAVuname, CAVuser, CAVusertime, CAVversion, CAVwallclock' one

sed -i '1i #Benchmark,LogFile,Result,command,commandline,cpuinfo,date,exitcode,expected,maxmem,meminfo,memlimit,mt_all_constr,mt_max_constr,timeout,uname,user,usertime,version,wallclock,LogFile,Result,command,commandline,cpuinfo,date,exitcode,expected,maxmem,meminfo,memlimit,mt_all_constr,mt_max_constr,timeout,uname,user,usertime,version,wallclock' one

OUTFILE=$tc-$cav13
mv one  $OUTFILE

grep FAILED $OUTFILE > $OUTFILE.sat
grep SUCCESSFUL $OUTFILE > $OUTFILE.unsat
cat $OUTFILE.sat  $OUTFILE.unsat |column -t > $OUTFILE.both

#gnuplot_file="tmp.gnuplot"
now=$(date +%Y-%m-%d.%H:%M:%S)
gnuplot_file="gnuplot.$now.gp"

#plot
echo 'set datafile separator "','"'             >  $gnuplot_file
echo 'set logscale x'                           >> $gnuplot_file
echo 'set logscale y'                           >> $gnuplot_file
echo 'set xlabel "'$xlabel'"'                   >> $gnuplot_file
echo 'set ylabel "'$ylabel'"'                   >> $gnuplot_file
echo 'set xrange [0.1:10]'                      >> $gnuplot_file
echo 'set yrange [0.1:10]'                      >> $gnuplot_file
echo 'set title "'$title'"'                     >> $gnuplot_file
if [ $plot = $x11 ]; then
  echo 'set terminal x11 persist'               >> $gnuplot_file
else
  echo 'set out "'$OUTFILE'.eps"'                      >> $gnuplot_file
  echo 'set terminal postscript color enhanced' >> $gnuplot_file
fi
echo 'plot "'$OUTFILE.sat'" u 18:37 w p pt 9 t "SAT", "'$OUTFILE'.unsat" u 18:37 t "UNSAT" w p pt 4, x t ""'  >> $gnuplot_file
#echo 'plot "'$OUTFILE.sat'" u 18:35 w p pt 9 t "SAT", "'$OUTFILE'.unsat" u 18:35 t "UNSAT" w p pt 4, x t ""'  >> $gnuplot_file
gnuplot $gnuplot_file

rm -f $gnuplot_file

if [ $plot != $x11 ]; then
  e2pdf $OUTFILE

  rm -f $OUTFILE.eps

  #mv $OUTFILE.pdf $tcb-$cav13b.pdf
  xpdf $OUTFILE.pdf
fi

rm -f $OUTFILE.unsat $OUTFILE.sat
rm -f $OUTFILE
