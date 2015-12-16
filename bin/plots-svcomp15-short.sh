
#set the Artefact Root
#ARTEFACT_ROOT=~/walcyrie

SCRIPTS=$ARTEFACT_ROOT/scripts
LITMUS=$ARTEFACT_ROOT/runs/litmus
SVCOMP15=$ARTEFACT_ROOT/runs/svcomp15

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

tabs 4

pushd .

echo "${green}Generating SVCOMP15 plots${reset}..."
sleep 1

cd $SVCOMP15

if [[ $? != 0 ]];then
	echo "${red}Incorrect ARTEFACT_ROOT=$ARTEFACT_ROOT${reset}...";
	exit 1;
fi

cp $SCRIPTS/gen-table.sh $SCRIPTS/4rows2table.pl .
$SCRIPTS/splot-svcomp15.sh log.short.svcomp15.6.60s.walcyrie.sc log.short.svcomp15.6.60s.cbmc-po.sc WALCYRIE CBMC-PO SC
$SCRIPTS/splot-svcomp15.sh log.short.svcomp15.6.60s.walcyrie.tso log.short.svcomp15.6.60s.cbmc-po.tso WALCYRIE CBMC-PO TSO
$SCRIPTS/splot-svcomp15.sh log.short.svcomp15.6.60s.walcyrie.pso log.short.svcomp15.6.60s.cbmc-po.pso WALCYRIE CBMC-PO PSO
rm -f gen-table.sh 4rows2table.pl

echo "${green}SVCOMP15 plot done${reset}..."
sleep 1

popd
##################################################
pushd .

echo "${green}Generating Exploration Efficacy plots${reset}..."
sleep 1

cd $SVCOMP15

cp $SCRIPTS/10rows2table.pl .
$SCRIPTS/splot-sat.sh log.short.svcomp15.6.60s.walcyrie.sc log.short.svcomp15.6.60s.cbmc-po.sc WALCYRIE CBMC-PO SC
$SCRIPTS/splot-sat.sh log.short.svcomp15.6.60s.walcyrie.tso log.short.svcomp15.6.60s.cbmc-po.tso WALCYRIE CBMC-PO TSO
$SCRIPTS/splot-sat.sh log.short.svcomp15.6.60s.walcyrie.pso log.short.svcomp15.6.60s.cbmc-po.pso WALCYRIE CBMC-PO PSO
rm -f  $SCRIPTS/10rows2table.pl

echo "${green}Exploration Efficacy plots done${reset}..."
sleep 1

popd
##################################################
echo "${green}All done. The PDFs are under their respective benchmark directories${reset}..."

echo -n '3 plots'
echo -en '\t'
echo "->${green}$LITMUS/*.pdf ${reset}"
ls -l $LITMUS/*.pdf

echo -n '6 plots'
echo -en '\t'
echo "->${green}$SVCOMP15/*.pdf ${reset}"
ls -l $SVCOMP15/*.pdf
sleep 1

