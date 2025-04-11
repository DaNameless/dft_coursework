Remember the following steps:

1) ENCUT convergence (xencut.sh) *You need to change the `?` symbols in the scripts. One could ask for a range to start, the starting KPOINTS and other parameters for the INCAR* 

2) KPOINTS convergence (xkpts.sh) *Change the system name, ENCUT previously found, and range of KPOINTS*

3) Cell size convergence (xcell.sh) *Change range of values for vol ($vol) and the entire block of POSCAR for the given POSCAR, AND the KPOINTS found in the k variable in the script*

4) Calculation with optimal volume (xbulk.sh) *Change $opvol to value found in the previous step. In the INCAR-st comment LCHARGE = .FALSE, uncomment LORBIT=11*

5) Calculate Band Structure (xbs.sh) *Obtain the KPOINTS_OPT in a KPOINTS-bs file. Create a INCAR-bs file, copy the INCAR used for the DOS but remove the line #LPLANE=T !T if num nodes << NGX,NGY,NGZ*


