#runs the specified list of sv-comp15 benchmarks.

if test "$#" -ne 7; then
    echo "Incorrect usage: expected 7 arguments, received $# arguments"
    echo "run-svcomp15.sh <file-list>  <benchmark-dir-prefix> <num-unwinds> <logfile-prefix> <exe-name> <timeout> <memory-model>";
    exit;
fi

blist=$1;
bprefix=$2;
nunwinds=$3;
lprefix=$4;
exec_name=$5;
timeout=$6;
mm=$7;

echo "1 = $1"; #list
echo "2 = $2"; #prefix_dir
echo "3 = $3"; #num-unwinds
echo "4 = $4"; #logfile-prefix
echo "5 = $5"; #executable-name
echo "6 = $6"; #timeout
echo "7 = $7"; #memory-model

now=$(date +%Y-%m-%d.%H:%M:%S)
logf=$lprefix.svcomp15.$nunwinds.$timeout"s".$exec_name.$mm

if [ -a $logf ]; then
echo "$logf exists!"
exit -1
fi

echo "==============================================================\n" >> $logf
echo "\\begin{header}" >> $logf
cat /proc/cpuinfo      >> $logf
cat /proc/meminfo      >> $logf
hostname               >> $logf
w                      >> $logf
date                   >> $logf
echo "\\end{header}"   >> $logf 
echo "==============================================================\n" >> $logf

for i in `cat $blist`;
do 
#cbmc
  runsolver -W $timeout $exec_name --32 --no-unwinding-assertions --error-label ERROR --mm $mm  --unwind $nunwinds  $bprefix/$i >> $logf 2>&1 ;

#nidhugg
#  runsolver -W $timeout $exec_name -$mm -unroll=$nunwinds  $bprefix/$i >> $logf 2>&1

#cpachecker
  #runsolver  -W $timeout $exec_name -sv-comp15 -preprocess -disable-java-assertions $bprefix/$i -spec $bprefix/pthread/ALL.prp  >> $logf 2>&1 

#esbmc
#  runsolver  -W $timeout $exec_name  --no-unwinding-assertions --error-label ERROR  --unwind $nunwinds  $bprefix/$i >> $logf 2>&1

#cseq
#  runsolver  -W $timeout $exec_name  -u$nunwinds  --error-label ERROR  -r3 -bcbmc $bprefix/$i >> $logf 2>&1

  #runsolver -W $timeout $exec_name --no-unwinding-assertions --error-label ERROR --mm $mm  --unwind $nunwinds  $bprefix/$i >> $logf 2>&1 ; 
  echo "VERIFICATION $i" >> $logf 2>&1 
done

echo "==============================================================\n" >> $logf
echo "\\begin{footer}" >> $logf
cat /proc/cpuinfo      >> $logf
cat /proc/meminfo      >> $logf
hostname               >> $logf
w                      >> $logf
date                   >> $logf
echo "\\end{footer}"   >> $logf
echo "==============================================================\n" >> $logf

exit;

#for the original cav version
#  runsolver -W $timeout $exec_name --no-unwinding-assertions --error-label ERROR --memory-model $mm  --unwind $nunwinds  $bprefix/$i >> $logf 2>&1 ; 
