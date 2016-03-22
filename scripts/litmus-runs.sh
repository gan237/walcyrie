
#ARTEFACT_ROOT=$CWD/walcyrie


WALCYRIE_PATH=$ARTEFACT_ROOT/bin
CBMCPO_PATH=$ARTEFACT_ROOT/bin

SCRIPT_PATH=$ARTEFACT_ROOT/scripts
LITMUS_IN=$ARTEFACT_ROOT/benchmarks/litmus
LITMUS_OUT=$ARTEFACT_ROOT/runs/litmus


red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

tabs 4

#echo "${red}About to delete all the files from previous runs. Press Enter to confirm${reset}..."
#
#read discardinput;

shopt -s extglob
rm -rf !(litmus-runs.sh)

echo -en '\t'
echo "${green}Starting the WALCYRIE Litmus runs${reset}..."
sleep 1;

cp $LITMUS_IN/src.cprover-bm.tar.gz .
cp $LITMUS_IN/src.tar.gz .

rm -f cbmc
ln -s $WALCYRIE_PATH/walcyrie cbmc

echo -en '\t\t'
echo "${green}Starting the WALCYRIE Litmus SC run${reset}..."
echo -en '\t\t'
echo "(${green}Check $LITMUS_OUT/nohup.out to track progress${reset})..."
echo -en '\t\t'
echo `date`
sleep 1;
nohup $SCRIPT_PATH/run-litmus.sh src.tar.gz  src.cprover-bm.tar.gz src walcyrie sc

echo -en '\t\t'
echo "${green}Starting the WALCYRIE Litmus TSO run${reset}..."
echo -en '\t\t'
echo "(${green}Check $LITMUS_OUT/nohup.out to track progress${reset})..."
echo -en '\t\t'
echo `date`
sleep 1;
nohup $SCRIPT_PATH/run-litmus.sh src.tar.gz  src.cprover-bm.tar.gz src walcyrie tso

echo -en '\t\t'
echo "${green}Starting the WALCYRIE Litmus PSO run${reset}..."
echo -en '\t\t'
echo "(${green}Check $LITMUS_OUT/nohup.out to track progress${reset})..."
echo -en '\t\t'
echo `date`
sleep 1;
nohup $SCRIPT_PATH/run-litmus.sh src.tar.gz  src.cprover-bm.tar.gz src walcyrie pso  

echo -en '\t'
echo "${green}Completed the WALCYRIE Litmus runs${reset}..."
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
echo "${green}Starting the CBMC-PO Litmus runs${reset}..."
sleep 1;

rm -f cbmc
ln -s $CBMCPO_PATH/cbmc-po cbmc

echo -en '\t\t'
echo "${green}Starting the CBMC-PO Litmus SC run${reset}..."
echo -en '\t\t'
echo "(${green}Check $LITMUS_OUT/nohup.out to track progress${reset})..."
echo -en '\t\t'
echo `date`
sleep 1;
nohup $SCRIPT_PATH/run-litmus.sh src.tar.gz  src.cprover-bm.tar.gz src cbmc-po sc 

echo -en '\t\t'
echo "${green}Starting the CBMC-PO Litmus TSO run${reset}..."
echo -en '\t\t'
echo "(${green}Check $LITMUS_OUT/nohup.out to track progress${reset})..."
echo -en '\t\t'
echo `date`
sleep 1;
nohup $SCRIPT_PATH/run-litmus.sh src.tar.gz  src.cprover-bm.tar.gz src cbmc-po tso

echo -en '\t\t'
echo "${green}Starting the CBMC-PO Litmus PSO run${reset}..."
echo -en '\t\t'
echo "(${green}Check $LITMUS_OUT/nohup.out to track progress${reset})..."
echo -en '\t\t'
echo `date`
sleep 1; 
nohup $SCRIPT_PATH/run-litmus.sh src.tar.gz  src.cprover-bm.tar.gz src cbmc-po pso

echo -en '\t'
echo "${green}Completed the CBMC-PO Litmus runs${reset}..."
echo -en '\t\t'
echo `date` 
