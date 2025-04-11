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

cp INCAR-st INCAR 

for vol
in 1.05 1.55 2.05 2.55 3.05 3.55 4.05 4.55 5.05 5.55 6.05 6.55 7.05 7.55 \
8.05 8.55 9.05 ; do

cat > POSCAR<<!
Al 
 $vol
     2.8633999999999999    0.0000000000000000    0.0000000000000000
     1.4317000000000002    2.4797771411963616    0.0000000000000000
     1.4317000000000002    0.8265923803987874    2.3379563098284502
 Al 
   1
Cartesian
  0.0000000000000000  0.0000000000000000  0.0000000000000000
!


cat > KPOINTS<<!
Al Atom   # System label
0              # Automatic generation
Gamma      # Generation scheme
$k $k $k          # Sampling - in this case single gamma point only
0 0 0          # Shift
!


mpirun -n $Cores vasp > output-$lat.out
wait

awk '/energy  without entropy=/ {ene=$7; print ene} ' OUTCAR > tmp
tail -2 OSZICAR | awk '/DAV/ {x=$2; print x} ' > tmp2

echo $vol $( cat tmp ) $( cat tmp2 ) >> cell.dat

done
cd ..
