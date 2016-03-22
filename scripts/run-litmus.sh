#runs litmus tests from cav'13.

#function pause()
#{
#  read -s -n 1 -p "$*: Press any key to continue . . ."
#  echo
#}

#pause "Use this script to run only the litmus tests."


if test "$#" -ne 5; then
    echo "Incorrect usage: expected 5 arguments, received $# arguments"
    echo "run-litmus.sh src.tar.gz  src-bm.tar.gz src <exe-name> <memory-model>";
    exit;
fi

pdir=$(pwd)
export PATH=$PATH:$pdir

tgz=$1;    #name of the source file
bm=$2;     #name of the -bm.tgz file
dname=$3; 
bname=$4
mm=$5

mkdir -p $bname
cd $bname

mkdir -p $mm
cp ../$tgz ../$bm $mm
cd $mm
cpbm unpack $tgz  $bm
cd $dname
#replace --memory-model with --mm
sed -i 's/--memory-model /--mm /' cprover/rules
cprover/rules table CONFIG=cbmc.$mm
cp cprover/results.cbmc.$mm.csv ../../../log.litmus.6.0s.$bname.$mm.csv
cd ..
cd ..
cd ..
