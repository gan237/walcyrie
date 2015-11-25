
#set the Artefact Root
#ARTEFACT_ROOT=~/walcyrie

LITMUS=$ARTEFACT_ROOT/runs/litmus
SVCOMP15=$ARTEFACT_ROOT/runs/svcomp15
CPBM=$ARTEFACT_ROOT/bin/cpbm-0.5
RUNSOLVER=$ARTEFACT_ROOT/bin/runsolver/src

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

nproc=$(nproc)

pushd .

export PATH=$PATH:$CPBM
echo "${green}Checking for cpbm${reset}...${red}"
sleep 1
cpbm --version

if [[ $? != 0 ]];then
	echo "Failed to detect cpbm${reset}...";
	exit 1;
fi

echo -n "${green}Checking for runsolver${reset}...${red}"
sleep 1

cd $RUNSOLVER

if [[ $? != 0 ]];then
	echo "Failed to detect runsolver${reset}...";
	exit 1;
fi

echo "${green} Found"
sleep 1

echo "${green}Compiling runsolver${reset}..."
sleep 1
make -j$nproc

export PATH=$PATH:$RUNSOLVER
popd 

runsolver cat /dev/null  > /dev/null

if [[ $? != 0 ]];then
	echo "${red}Unable to run runsolver!${reset}...";
	exit 1;
fi

echo "${green}Both cpbm & runsolver are correctly installed${reset}...";

pushd .

echo "${red}############################################################${reset}"
echo       "Each of the SIX Litmus runs will take upward ${red}3:00hrs${reset} @ 3GHz"
echo       "Allow ${red}6*3:00hrs${reset} for Litmus tests"
echo "${red}############################################################${reset}"


echo "${green}Starting the Litmus tests${reset}..."
sleep 1
cd $LITMUS

if [[ $? != 0 ]];then
	echo "${red}Incorrect ARTEFACT_ROOT=$ARTEFACT_ROOT${reset}...";
	exit 1;
fi


./litmus-runs.sh


echo "${green}Completed the Litmus tests${reset}..."
sleep 1


echo "${red}##################################################################${reset}"
echo       "Each of the SIX SV-COMP15 runs will take upward ${red}12:30hrs${reset} @ 3GHz"
echo       "Allow ${red}6*12:30hrs${reset} for SV-COMP15 tests"
echo "${red}##################################################################${reset}"


echo "${green}Starting the SVCOMP15 tests${reset}..."
sleep 1

cd $SVCOMP15

if [[ $? != 0 ]];then
	echo "${red}Incorrect SVCOMP15 ARTEFACT_ROOT=$ARTEFACT_ROOT${reset}...";
	exit 1;
fi


./svcomp15-runs.sh


echo "${green}Completed the SVCOMP15 tests${reset}..."
sleep 1

echo "${green}All done${reset}."
sleep 1

popd


