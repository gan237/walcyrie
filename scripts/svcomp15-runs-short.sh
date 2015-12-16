echo "starting WALCYRIE SVCOMP15 runs"

#$ARTEFACT_ROOT=$CWD/walcyrie

WALCYRIE_PATH=$ARTEFACT_ROOT/bin
CBMCPO_PATH=$ARTEFACT_ROOT/bin

SCRIPT_PATH=$ARTEFACT_ROOT/scripts
SVCOMP15_IN=$ARTEFACT_ROOT/benchmarks/svcomp15
SVCOMP15_OUT=$ARTEFACT_ROOT/runs/svcomp15

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`


tabs 4

#echo "${red}About to delete all the files from previous runs. Press Enter to confirm${reset}..."
#
#read discardinput;

shopt -s extglob
rm -rf !(svcomp15-runs.sh)

echo -en '\t'
echo "${green}Starting the WALCYRIE SVCOMP15 runs${reset}..."
sleep 1;

rm -f walcyrie
ln -s $WALCYRIE_PATH/walcyrie .

echo -en '\t\t'
echo "${green}Starting the WALCYRIE SVCOMP15 SC run${reset}..."
echo -en '\t\t'
echo "(${green}Check $SVCOMP15_OUT/log.short.svcomp15.6.60s.walcyrie.sc to track progress${reset})..."
echo -en '\t\t'
echo `date`
sleep 1;
nohup $SCRIPT_PATH/run-svcomp15.sh  $SVCOMP15_IN/list.i.svcomp15.short.sc  $SVCOMP15_IN 6 log.short walcyrie 60 sc

echo -en '\t\t'
echo "${green}Starting the WALCYRIE SVCOMP15 TSO run${reset}..."
echo -en '\t\t'
echo "(${green}Check $SVCOMP15_OUT/log.short.svcomp15.6.60s.walcyrie.tso to track progress${reset})..."
echo -en '\t\t'
echo `date`
sleep 1;
nohup $SCRIPT_PATH/run-svcomp15.sh  $SVCOMP15_IN/list.i.svcomp15.short.tso  $SVCOMP15_IN 6 log.short walcyrie 60 tso

echo -en '\t\t'
echo "${green}Starting the WALCYRIE SVCOMP15 PSO run${reset}..."
echo -en '\t\t'
echo "(${green}Check $SVCOMP15_OUT/log.short.svcomp15.6.60s.walcyrie.pso to track progress${reset})..."
echo -en '\t\t'
echo `date`
sleep 1;
nohup $SCRIPT_PATH/run-svcomp15.sh  $SVCOMP15_IN/list.i.svcomp15.short.pso  $SVCOMP15_IN 6 log.short walcyrie 60 pso

echo -en '\t'
echo "${green}Completed the WALCYRIE SVCOMP15 runs${reset}..."
echo -en '\t\t'
echo `date`

###############################################################################

#for job in `jobs -p`
#do
#echo $job
#    wait $job || let "FAIL+=1"
#done

###############################################################################


sleep 3;

echo -en '\t'
echo "${green}Starting the CBMC-PO SVCOMP15 runs${reset}..."
sleep 1;

rm -f cbmc-po
ln -s $WALCYRIE_PATH/cbmc-po .

echo -en '\t\t'
echo "${green}Starting the CBMC-PO SVCOMP15 SC run${reset}..."
echo -en '\t\t'
echo "(${green}Check $SVCOMP15_OUT/log.short.svcomp15.6.60s.cbmc-po.sc to track progress${reset})..."
echo -en '\t\t'
echo `date`
sleep 1;
nohup $SCRIPT_PATH/run-svcomp15.sh  $SVCOMP15_IN/list.i.svcomp15.short.sc  $SVCOMP15_IN 6 log.short cbmc-po 60 sc

echo -en '\t\t'
echo "${green}Starting the CBMC-PO SVCOMP15 TSO run${reset}..."
echo -en '\t\t'
echo "(${green}Check $SVCOMP15_OUT/log.short.svcomp15.6.60s.cbmc-po.tso to track progress${reset})..."
echo -en '\t\t'
echo `date`
sleep 1;
nohup $SCRIPT_PATH/run-svcomp15.sh  $SVCOMP15_IN/list.i.svcomp15.short.tso  $SVCOMP15_IN 6 log.short cbmc-po 60 tso

echo -en '\t\t'
echo "${green}Starting the CBMC-PO SVCOMP15 PSO run${reset}..."
echo -en '\t\t'
echo "(${green}Check $SVCOMP15_OUT/log.short.svcomp15.6.60s.cbmc-po.pso to track progress${reset})..."
echo -en '\t\t'
echo `date`
sleep 1;
nohup $SCRIPT_PATH/run-svcomp15.sh  $SVCOMP15_IN/list.i.svcomp15.short.pso  $SVCOMP15_IN 6 log.short cbmc-po 60 pso

echo -en '\t'
echo "${green}Completed the CBMC-PO SVCOMP15 runs${reset}..."
echo -en '\t\t'
echo `date` 
