#!/bin/bash
#%%%% cores available %%%%%%%%%%
#grep '^core id' /proc/cpuinfo |sort -u|wc -l > cores
#Cores=`echo $( cat cores )`
Cores=2
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

res=results
cd $res
cp KPOINTS-bs KPOINTS_OPT

cp INCAR-st INCAR

mpirun -n $Cores vasp > output-bs.out
wait

rm KPOINTS_OPT

cd ..


