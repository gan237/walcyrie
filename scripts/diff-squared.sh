if test "$#" -ne 2; then
    echo "Incorrect usage: expected 2 argument, received $# arguments"
    echo "Usage: diff-squared.sh <logfile2> <logfile2>"
    exit;
fi

log1=`basename $1`
log2=`basename $2`

#gen-table.sh $1 | awk 'NR != 1' | sort -k 4 -b >  /tmp/$log1.prob
gen-table.sh $1 > /dev/null
gen-table.sh $2 > /dev/null


printf "\nUnison:\n"
awk 'FNR == NR {_[$4]++} FNR < NR {if ( $4 in _ ) print $0}' /tmp/$log1.problems /tmp/$log2.problems > /tmp/$log1-$log2.unison

if [[ -s /tmp/$log1-$log2.unison ]]; then
  cat /tmp/$log1-$log2.unison
else
  printf "NONE. (an empty input? differing runs?)\n"
fi

printf "\nDischord:\n"
awk 'FNR == NR {_[$4]++} FNR < NR {if ( $4 in _ ){}else{print $1, $0}}' /tmp/$log1.problems /tmp/$log2.problems > /tmp/$log1-$log2.dischord
if [[ -s /tmp/$log1-$log2.dischord ]]; then
  cat /tmp/$log1-$log2.dischord
else
  printf "\tNONE! (good)\n"
fi
printf "\n"


#join -v1 -j 4  <(sort -k 4 /tmp/$log1.prob) <(sort -k 4 /tmp/$log2.prob)

#awk '{print $4}' /tmp/$log1.problems | sort  > /tmp/$log1.problems.fname
#awk '{print $4}' /tmp/$log2.problems | sort  > /tmp/$log2.problems.fname
#comm -12  /tmp/$log1.problems.fname /tmp/$log2.problems.fname > /tmp/$log1-$log2.unison
#comm -3  /tmp/$log1.problems.fname /tmp/$log2.problems.fname > /tmp/$log1-$log2.dischord

#awk '{print $4}'  /tmp/$log1.problems| grep -f  - /tmp/$log2.problems #>  /tmp/$log1-$log2.ident
#awk '{print $4}'  /tmp/$log1.problems| grep -vf - /tmp/$log2.problems #>  /tmp/$log1-$log2.differ
