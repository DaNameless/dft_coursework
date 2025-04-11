#!/bin/bash
#%%%% cores available %%%%%%%%%%
#grep '^core id' /proc/cpuinfo |sort -u|wc -l > cores
#Cores=`echo $( cat cores )`
Cores=2
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

res=results
opvol=16.4757
cd $res

rm W* CHG*

cp INCAR-bulk INCAR

cat > POSCAR<<!
Al 
 -$opvol
     2.8633999999999999    0.0000000000000000    0.0000000000000000
     1.4317000000000002    2.4797771411963616    0.0000000000000000
     1.4317000000000002    0.8265923803987874    2.3379563098284502
 Al 
   1
Cartesian
  0.0000000000000000  0.0000000000000000  0.0000000000000000
!

mpirun -n $Cores vasp > output-bulk.out
wait

awk '/energy  without entropy=/ {ene=$7; print ene} ' OUTCAR > tmp

echo bulk $( cat tmp ) >> bulk.dat
rm tmp


mv OUTCAR OUTCAR-bulk
mv CHGCAR CHGCAR-bulk.vasp
mv DOSCAR DOSCAR-bulk

cd ..

