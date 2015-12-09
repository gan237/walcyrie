# PPoPP 2016 Artefact

This artefact is for **The Virtues of Conflict: Analysing Modern Concurrency** accepted for PPoPP 2016.

##Instructions

Here we describe the step by step instructions to obtain, compile and run our artefact.


###Step 0: Artefact Requirements

The artefact can be compiled and run on any Linux machine. You will need a C/C++ compiler, Flex and Bison, and GNU make; the GNU Make version must be 3.81 or higher and the g++ version 4.6.x or higher. The `perl` and `lwp-download` (provided by libwww-perl in Ubuntu/Fedora) executables needs to be in the $PATH. Internet access is required for the automated download of MiniSAT2 sources. We assume you will be using a `bash` shell.

To run the tests, you will need `cpbm` (included) and `runsolver` (included). 

To produce the plots, we require `awk`, `sed`, `perl` (Switch.pm, Text::CSV), `gnuplot`, `epstopdf` and `pdf90` to be in the $PATH.


###Step 1: Obtaining the Artefact

The artefact can be obtained by simply using the following clone command.

	git clone https://github.com/gan237/walcyrie

This creates a directory called walcyrie under the current working directory ($cwd). The directory $cwd/walcyrie/walcyrie-cbmc-5.1/ houses the sources; $cwd/walcyrie/benchmarks houses the benchmarks used (sv-comp15, litmus); $cwd/walcyrie/scripts houses various utility scripts; $cwd/walcyrie/logs houses the experimental results used to produce our plots; $cwd/walcyrie/bin has the packages used and scripts to compile/run our artefact.

You will need to set the $ARTEFACT_ROOT to the absolute path of the repo root as follows. This variable is used by all our scripts to find the root directory of the artefact.

	export  ARTEFACT_ROOT=$cwd/walcyrie

###Step 2: Compiling the Artefact

Simply run:

	$cwd/walcyrie/bin/compile.sh

Now you should have the binaries `walcyrie` and `cbmc-po` in the $cwd/walycrie/bin/ directory.


###Step 3: Running the Artefact

First check below for expected time scales of the experiments. 	A complete run takes about 7½ days<sup>§</sup>. When ready to run the experiments, do:

	$cwd/walcyrie/bin/experiments.sh

This will result in twelve log files, six each under the $cwd/run/svcomp15 and $cwd/run/litmus. The first six are for the Litmus tests and the second six for the SV-COMP15 suite. The log files are of the form `log.svcomp15.6.900s.$exe.$mm` or `log.litmus.6.0s.$exe.$mm.csv`. 6 is the number of unrolling used; 0s/900s is the timeout set, 0s is no timeout;  $exe is the name of the binary, $exe={walcyrie, cbmc-po}; $mm is the memory model used, $mm={sc,tso,pso}.

<div align="center">
<b>Achtung!</b>
</div>
	Each individual Litmus test will take ~3:00hrs. A complete Litmus run will take >6*3:00hrs.
	Each SV-COMP15 test will take ~12:30hrs. A complete SVCOMP15 run will take >6*12:30hrs.

	Use tail -f $cwd/runs/litmus/nohup.out to track the Litmus runs.
	Use tail -f $cwd/runs/svcomp15/log.svcomp15.6.900s.$exe.$mm to track the SV-COMP15 runs.

<div align="right">
<i>§ On a 3GHz CPU</i>.
</div>

###Step 4: Generating the Plots

Simply do:

	$cwd/walcyrie/bin/plots.sh

On completion, you should have the nine pdf plots, six under $cwd/run/svcomp15 and three under $cwd/run/litmus.

The $cwd/walcyrie/bin/log directory contains all the log files we obtained for generating the plots in the paper. To reproduce these plots, do the following:

	cd $ARTEFACT_ROOT
	cp logs/cbmc-po/log.litmus.*   logs/walcyrie/log.litmus.*   runs/litmus
	cp logs/cbmc-po/log.svcomp15.* logs/walcyrie/log.svcomp15.* runs/svcomp15
	./bin/plots.sh


******

##Alternate Sources

An alternate source to obtain our artefact, as a VM image, is from 

	http://www.cprover.org/wmm/tc/ppopp16/

This is a Fedora release 23 VM that has walcyrie already compiled and ready to use. To run the experiments, log in as ppopp16 (passwd: ae), and simply run ~/walcyrie/bin/experiments.sh. The $ARTEFACT_ROOT is set to ~/walcyrie.
