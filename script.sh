#!/bin/bash


Help(){
	echo "
This wrapper bash script to calculate Adaptive Poisson-Boltzmann Solver with
the apbs tool developed in:

Baker NA, Sept D, Joseph S, Holst MJ, McCammon JA. Electrostatics of
nanosystems: application to microtubules and the ribosome. Proc.
Natl. Acad. Sci. USA 98, 10037-10041 2001.

The soft is available in:
https://github.com/Electrostatics/apbs

This also requires the installation of pdb2pqr. Follow the instructios in:
https://pdb2pqr.readthedocs.io/en/latest/getting.html

**********************
Instructions:

This script calcultes at once the APBS at pH 5 and pH 7 using the same imput 
pdb structure.

Load the pdb structures in the curren working directory.
Run the script as: 

	./script [protein].pdb

The output will be created in the same directory.

"
}

# Error messages
[[ $# -lt 1 ]] && Help && exit
[[ ! -f $1 ]] && echo "ERROR: File ${1} does not exist. 
Input pdb structures must be loaded in this directory " && exit



# Analysis
for PROT in $1
	do
	PROT=$(echo $PROT | sed 's/\.pdb//g')
		for PH in 5 7 ; do 
		pdb2pqr30 --ff=CHARMM ./${PROT}.pdb ./${PROT}.pH_${PH}.pqr  --log-level  ERROR \
							--apbs-input ./apbs_${PROT}.pH_${PH}.in \
							--titration-state-method propka \
							--with-ph ${PH} --drop-water
		apbs ./apbs_${PROT}.pH_${PH}.in --output-file=./map_${PROT}.pH_${PH}
		done
done
