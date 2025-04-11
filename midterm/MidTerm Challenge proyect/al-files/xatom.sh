#!/bin/bash
#%%%% cores available %%%%%%%%%%
#grep '^core id' /proc/cpuinfo |sort -u|wc -l > cores
#Cores=`echo $( cat cores )`
Cores=2
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd results_atom

cat > parallel<<!
#%%%%%%%%%% PARALLELIZATION %%%%%%%%%%%%%%%%%%%%%%%
NCORE=$Cores ! cores per procesor
NSIM=1  ! 
!

cat INCAR-atom parallel > INCAR
cp POSCAR-atom POSCAR
cp KPOINTS-atom KPOINTS

rm W*

mpirun -n $Cores vasp > output-atom.out
wait

awk '/energy  without entropy=/ {ene=$7; print ene} ' OUTCAR > tmp

echo atom $( cat tmp ) >> atom.dat

rm tmp

mv OUTCAR OUTCAR-atom.out
mv OSZICAR OSZICAR-atom.out

