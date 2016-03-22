if test "$#" -ne 1; then
    echo "Incorrect usage: expected 1 argument, received $# arguments"
    echo "Usage: gen-table.sh <logfile>"
    exit;
fi

fname=`basename $1`

#collect the necessary data from runsolver.
#perl -w logTO5rows.pl $1 > /tmp/$fname.5rows
grep -E "^Real|^maximum resident|^VERIFICATION \./|VERIFICATION SUCC|VERIFICATION FAIL" $1 >  /tmp/$fname.4rows

#build the table
perl -w 4rows2table.pl /tmp/$fname.4rows > /tmp/$fname.table 

#get the problem instances
awk  '{if (($1 == "SAT") && !index($4, "false-unreach")) { print} }'  /tmp/$fname.table > /tmp/$fname.problems
awk  '{if (($1 == "UNSAT") && !index($4, "true-unreach")) { print} }'  /tmp/$fname.table >> /tmp/$fname.problems

#notify the problems
if [[ -s /tmp/$fname.problems ]]; then
  echo "The problem instances: $fname"
  cat /tmp/$fname.problems
else
  echo "There were NO problem instances: 'expected' matches the 'computed'"
fi
