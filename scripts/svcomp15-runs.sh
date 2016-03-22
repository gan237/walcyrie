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
rm -rf !(svcomp15-runs.sh|svcomp15-runs-short.sh)

echo -en '\t'
echo "${green}Starting the WALCYRIE SVCOMP15 runs${reset}..."
sleep 1;

rm -f walcyrie
ln -s $WALCYRIE_PATH/walcyrie .

echo -en '\t\t'
echo `date`
echo -en '\t\t'
echo "${green}Starting the WALCYRIE SVCOMP15 SC run${reset}..."
echo -en '\t\t'
echo "(${green}Check $SVCOMP15_OUT/log.svcomp15.6.900s.walcyrie.sc to track progress${reset})..."
sleep 1;
nohup $SCRIPT_PATH/run-svcomp15.sh  $SVCOMP15_IN/list.i.svcomp15.sc  $SVCOMP15_IN 6 log walcyrie 900 sc

echo -en '\t\t'
echo `date`
echo -en '\t\t'
echo "${green}Starting the WALCYRIE SVCOMP15 TSO run${reset}..."
echo -en '\t\t'
echo "(${green}Check $SVCOMP15_OUT/log.svcomp15.6.900s.walcyrie.tso to track progress${reset})..."
sleep 1;
nohup $SCRIPT_PATH/run-svcomp15.sh  $SVCOMP15_IN/list.i.svcomp15.tso  $SVCOMP15_IN 6 log walcyrie 900 tso

echo -en '\t\t'
echo `date`
echo -en '\t\t'
echo "${green}Starting the WALCYRIE SVCOMP15 PSO run${reset}..."
echo -en '\t\t'
echo "(${green}Check $SVCOMP15_OUT/log.svcomp15.6.900s.walcyrie.pso to track progress${reset})..."
sleep 1;
nohup $SCRIPT_PATH/run-svcomp15.sh  $SVCOMP15_IN/list.i.svcomp15.pso  $SVCOMP15_IN 6 log walcyrie 900 pso

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
echo `date`
echo -en '\t\t'
echo "${green}Starting the CBMC-PO SVCOMP15 SC run${reset}..."
echo -en '\t\t'
echo "(${green}Check $SVCOMP15_OUT/log.svcomp15.6.900s.cbmc-po.sc to track progress${reset})..."
sleep 1;
nohup $SCRIPT_PATH/run-svcomp15.sh  $SVCOMP15_IN/list.i.svcomp15.sc  $SVCOMP15_IN 6 log cbmc-po 900 sc

echo -en '\t\t'
echo `date`
echo -en '\t\t'
echo "${green}Starting the CBMC-PO SVCOMP15 TSO run${reset}..."
echo -en '\t\t'
echo "(${green}Check $SVCOMP15_OUT/log.svcomp15.6.900s.cbmc-po.tso to track progress${reset})..."
sleep 1;
nohup $SCRIPT_PATH/run-svcomp15.sh  $SVCOMP15_IN/list.i.svcomp15.tso  $SVCOMP15_IN 6 log cbmc-po 900 tso

echo -en '\t\t'
echo `date`
echo -en '\t\t'
echo "${green}Starting the CBMC-PO SVCOMP15 PSO run${reset}..."
echo -en '\t\t'
echo "(${green}Check $SVCOMP15_OUT/log.svcomp15.6.900s.cbmc-po.pso to track progress${reset})..."
sleep 1;
nohup $SCRIPT_PATH/run-svcomp15.sh  $SVCOMP15_IN/list.i.svcomp15.pso  $SVCOMP15_IN 6 log cbmc-po 900 pso

echo -en '\t'
echo "${green}Completed the CBMC-PO SVCOMP15 runs${reset}..."
echo -en '\t\t'
echo `date` 
