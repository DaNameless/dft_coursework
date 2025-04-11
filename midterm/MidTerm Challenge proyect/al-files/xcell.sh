#!/bin/bash
#%%%% cores available %%%%%%%%%%
#grep '^core id' /proc/cpuinfo |sort -u|wc -l > cores
#Cores=`echo $( cat cores )`
Cores=2
#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

res=results
k=25

cd $res
rm W* CHG*

cp INCAR-bulk INCAR 

for vol
in 13.5 14. 14.5 15. 15.5 16. 16.5 17. 17.5 18. 18.5 19. 19.5 20. 20.5 \
21. 21.5; do

cat > POSCAR<<!
Al 
 -$vol
     2.8633999999999999    0.0000000000000000    0.0000000000000000
     1.4317000000000002    2.4797771411963616    0.0000000000000000
     1.4317000000000002    0.8265923803987874    2.3379563098284502
 Al 
   1
Cartesian
  0.0000000000000000  0.0000000000000000  0.0000000000000000
!

cp POSCAR POSCAR-bulk
cp KPOINTS KPOINTS-bulk

mpirun -n $Cores vasp > output-$lat.out
wait

awk '/energy  without entropy=/ {ene=$7; print ene} ' OUTCAR > tmp
tail -2 OSZICAR | awk '/DAV/ {x=$2; print x} ' > tmp2

echo $vol $( cat tmp ) $( cat tmp2 ) >> cell.dat

done
cd ..
