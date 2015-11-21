
#set the Artefact Root
#ARTEFACT_ROOT=~/walcyrie

SRC=$ARTEFACT_ROOT/walcyrie-cbmc-5.1/src
nproc=$(nproc)


red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

pushd .
echo "${green}Will use $nproc make jobs${reset}...${red}";

cd $SRC

if [[ $? != 0 ]];then
	echo "Incorrect ARTEFACT_ROOT=$ARTEFACT_ROOT${reset}...";
	exit 1;
fi
#echo $?

echo "${green}Setting up MiniSAT2${reset}..."
sleep 1
make minisat2-download

echo "${green}Compiling walcyrie${reset}..."
sleep 1
make -j$nproc

echo "${green}Copying walcyrie${reset}..."
sleep 1
cp cbmc/walcyrie $ARTEFACT_ROOT/bin

echo "${green}Cleaning up${reset}..."
sleep 1
make clean

echo "${green}Setting up cbmc-po${reset}..."
sleep 1
sed -i '/^CXXFLAGS   += -DWALCYRIE/s/^/#/' config.inc

echo "${green}Compiling cbmc-po${reset}..."
sleep 1
make -j$nproc

echo "${green}Copying cbmc-po${reset}..."
sleep 1
cp cbmc/cbmc-po $ARTEFACT_ROOT/bin

echo "${green}Cleaning up${reset}..."
sleep 1
make clean
sed -i '/^#CXXFLAGS   += -DWALCYRIE/s/^//' config.inc

echo "${green}All done${reset}."
sleep 1

popd


