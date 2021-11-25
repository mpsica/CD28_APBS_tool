#!/bin/bash


Help(){
	echo "
This is a wrapper script in bash to calculate difference between two maps obtained by 
Adaptive Poisson-Boltzmann Solver using the apbs tool developed in:

Baker NA, Sept D, Joseph S, Holst MJ, McCammon JA. Electrostatics of nanosystems:
application to microtubules and the ribosome. Proc. Natl. Acad. Sci. USA 98, 10037-10041 2001.

The soft is available in:
https://github.com/Electrostatics/apbs

This analysis also requires the installation of pdb2pqr. Follow the instructios in:
https://pdb2pqr.readthedocs.io/en/latest/getting.html

**********************
Two files are necessary to make the calculations: Detal_q_script.sh and _func.R

Program langs: bash & R

Special libraries: none

This script calcultes at once the APBS maps at pH 5 and pH 7 using the same imput pdb structure. 
The maps are 3D matrices, so to calculate the difference between maps a simple script in R (_func.R) calcultes 
a voxel-to-voxel subtraction. For that reason it is important that APBS at both pHs are calculated 
over the same input structure. The substracton is calculated as *map_at_pH7 minus map_at_pH5* so
positive difference (Delta_q > 0) means an increase in positive charge.

Remember to give execution permission to these scripts.

**********************
Instructions:

1) Load the pdb structures in the current working directory.

2) Run the script as: 

	./Delta_q_script.sh [protein].pdb

3) The output file (Delta_q-[protein].dx) will be created in the same directory.

4) The maps can be loaded in Pymol to the same input PDB structure.

"
}

# Error messages
[[ $# -lt 1 ]] && Help && exit
[[ ! -f $1 ]] && echo "ERROR: File ${1} does not exist. 
Input pdb structures must be loaded in this directory " && exit



# Analysis
for PROT in $1
	do
	
	[[ -f ./tmp ]]	&& rm -f  ./tmp

	PROT=$(echo $PROT | sed 's/\.pdb//g')
		for PH in 5 7 ; do 
		pdb2pqr30 --ff=CHARMM ./${PROT}.pdb ./${PROT}.pH_${PH}.pqr  --log-level  ERROR \
							--apbs-input ./apbs_${PROT}.pH_${PH}.in \
							--titration-state-method propka \
							--with-ph ${PH} --drop-water
		apbs ./apbs_${PROT}.pH_${PH}.in --output-file=./map_${PROT}.pH_${PH}
		done

	awk 'NF=3 {print}'  ${PROT}.pH_7.pqr.dx | egrep -v "^[a-z]" > ${PROT}.pH_7.dat
	awk 'NF=3 {print}'  ${PROT}.pH_5.pqr.dx | egrep -v "^[a-z]" > ${PROT}.pH_5.dat
	
	WD=$(pwd)

	echo -n "Calculating Delta charge... "
	Rscript _func.R ${WD} ${PROT}

	OUT="Delta_q-"${PROT}".dx"
	 head ./${PROT}.pH_5.pqr.dx -n 12 >  ${OUT}
	 cat ./tmp                       >>  ${OUT}
	 tail ./${PROT}.pH_5.pqr.dx -n 5 >>  ${OUT}
	 rm  ./tmp ./${PROT}*.dat
	 echo "Done.
	 "

done
