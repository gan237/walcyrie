# PPoPP 2016 Artefact

This artefact is for **The Virtues of Conflict: Analysing Modern Concurrency** accepted for PPoPP 2016.

##Instructions

Here we describe the step by step instructions to obtain, compile and run our artefact.


###Step 0: Artefact Requirements

The artefact can be compiled and run on any Linux machine. You will need a C/C++ compiler, Flex and Bison, and GNU make; the GNU Make version must be 3.81 or higher and the g++ version 4.6.x or higher. The `perl` and `lwp-download` (provided by libwww-perl in Ubundu) executables needs to be in the $PATH. Internet access is required for the automated download of MiniSAT2 sources.

To run the tests, you will need `cpbm` (included) and `runsolver` (included). 

To produce the plots, we require `awk`, `sed`, `perl`, `gnuplot`, `epstopdf` and `pdf90` to be in the $PATH.


###Step 1: Getting the Artefact

The artefact can be obtained by simply using the following clone command.

	git clone https://github.com/gan237/walcyrie

This creates a directory called walcyrie under the current working directory ($cwd). The directory $cwd/walcyrie/walcyrie-cbmc-5.1/ houses the sources; $cwd/walcyrie/benchmarks houses the benchmarks used (sv-comp15, litmus); $cwd/walcyrie/scripts houses various scripts to run the artefact and produce the plots used in the paper; $cwd/walcyrie/logs houses the experimental results used to produce our plots.


###Step 2: Compiling the Artefact

Here we describe how to compile the artefact.

####2.0 Setting up the Solver

To download and set up the solver (MiniSAT2) used in our experiments, do:

	cd $cwd/walcyrie/walcyrie-cbmc-5.1/src
	make minisat2-download

####2.1 To compile the walcyrie tool, do:

	(staying in $cwd/walcyrie/walcyrie-cbmc-5.1/src directory)
	make

Alternatively, one may try a parallel make command

    make -jN

Where 'N' is the number of processor cores in the machine to speed up the compilation.

This should result in a binary named `walcyrie` under $cwd/walcyrie/walcyrie-cbmc-5.1/src/cbmc/.

####2.2 To compile the cbmc-po tool, do:
	(staying in $cwd/walcyrie/walcyrie-cbmc-5.1/src directory)
	sed -i '/^CXXFLAGS   += -DWALCYRIE/s/^/#/' config.inc 
	make clean; make

The first command will comment out the -DWALCYRIE flag. The second make should result in a binary named `cbmc-po` under $cwd/walcyrie/walcyrie-cbmc-5.1/src/cbmc/.


###Step 3: Running the Artefact

To set up the runs, first copy the walcyrie or cbmc-po binaries from $cwd/walcyrie/walcyrie-cbmc-5.1/src/cbmc/ to the $cwd/walcyrie/bin directory.

Add $cwd/bin/cpbm-0.5 to the $PATH. Compile the runsolver tool and add the resulting binary to the $PATH. This is as shown below.

	export PATH=$PATH:~/walcyrie/bin/cpbm-0.5/:~/walcyrie/bin/runsolver/src/

####3.0 Running the Litmus suite

	cd $cwd/walcyrie/runs/litmus
	./litmus-runs.sh

This results in two sets of three runs with one run per memory model (sc, tso, pso). The first set is for walcyrie and the second for cbmc-po. The results are packed into files of the form "log.litmus.6.0s.$exe.$mm.csv" under the $cwd/runs/litmus/ directory: 6 is the number of unrolling used, 0s means no timeout was used, $exe is the name of the binary ($exe={walcyrie, cbmc-po}), and $mm is the memory model used ($mm={sc,tso,pso}).


####3.1 Running the SV-COMP15 suite

	cd $cwd/runs/svcomp15
	./svcomp15-runs.sh

This again results in two sets of three runs with one run per memory model (sc, tso, pso). The first set is for walcyrie and the second for cbmc-po. The results are packed into files of the form "log.svcomp15.6.900s.$exe.$mm" under the  $cwd/runs/svcomp15 directory: 6 is the number of unrolling used, 900s is the timeout used, $exe is the name of the binary ($exe={walcyrie, cbmc-po}), and $mm is the memory model used ($mm={sc,tso,pso}).


The SVCOMP-15 plot processing also outputs the benchmarks that were mis-classified on to the terminal.

###Step 3: Generating the plots

Here we describe how to produce the scatter plots used in the paper. Add $cwd/runs to your $PATH. By default all these scripts will use a X11 terminal to render the plots. Set the plot='pdf' to force the scripts to produce pdf plots.

####3.0 Generating the Litmus plots

Plots 4{a, b, c} can be produced by varying $mm over {sc, tso, pso} as follows.

	cd $cwd/runs/litmus	
	splot_litmus.sh log.litmus.6.0s.walcyrie.$mm.csv log.litmus.6.0s.cbmc-po.$mm.csv \
					walcyrie cbmc-po $mm;


####3.1 Generating the SV-COMP15 plots

Plots 4{d, e, f} can be produced by varying $mm over {sc, tso, pso} as follows.

	cd $cwd/runs/svcomp15
	splot_svcomp15.sh log.svcomp15.6.900s.walcyrie.$mm log.svcomp15.6.900s.cbmc-po.$mm \
					  walcyrie cbmc-po $mm;

####3.2 Generating the Exploration Efficacy plots
Plots 4{g, h, i} can be produced by varying $mm over {sc, tso, pso} as follows.

	cd $cwd/runs/svcomp15
	splot_sat.sh log.svcomp15.6.900s.walcyrie.$mm log.svcomp15.6.900s.cbmc-po.$mm \
				 walcyrie cbmc-po $mm;

