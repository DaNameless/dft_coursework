#!/bin/bash
#%%%% cores available %%%%%%%%%%
#grep '^core id' /proc/cpuinfo |sort -u|wc -l > cores
#Cores=`echo $( cat cores )`
Cores=2
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

res=results
cd $res
cp KPOINTS-bs KPOINTS_OPT

cat > parallel<<!
#%%%%%%%%%% PARALLELIZATION %%%%%%%%%%%%%%%%%%%%%%%
#NCORE=$Cores ! cores per procesor
NSIM=1  !
!

cat INCAR-bs parallel > INCAR


mpirun -n $Cores vasp > output-bs.out
wait

rm KPOINTS_OPT

cd ..


