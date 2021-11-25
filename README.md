# CD28_APBS_tool
## Tool to calculate Difference between APBS maps 


This is a wrapper script in bash to calculate difference between two maps obtained by Adaptive Poisson-Boltzmann Solver using the apbs tool developed in:

*Baker NA, Sept D, Joseph S, Holst MJ, McCammon JA. Electrostatics of nanosystems: application to microtubules and the ribosome. Proc. Natl. Acad. Sci. USA 98, 10037-10041 2001.*

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

	./Detal_q_script.sh [protein].pdb

3) The output file (Delta_q-[protein].dx) will be created in the same directory.

4) The maps can be loaded in Pymol to the same input PDB structure.
